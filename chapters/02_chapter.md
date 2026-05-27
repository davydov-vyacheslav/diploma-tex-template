# Розробка запропонованого методу

## Постановка задачі

Нехай задано навчальну вибірку $\mathcal{D} = \{(x_i, y_i)\}_{i=1}^{N}$,
де $x_i \in \mathbb{R}^{H \times W \times 3}$ -- зображення,
а $y_i \in \{1, \ldots, C\}$ -- клас із $C$ можливих.

Потрібно знайти функцію $f_\theta$, що мінімізує емпіричний ризик:

\begin{equation}
  \mathcal{L}(\theta) = \frac{1}{N}\sum_{i=1}^{N}
  \ell\bigl(f_\theta(x_i),\, y_i\bigr) + \lambda\|\theta\|_2^2,
  \label{eq:loss}
\end{equation}

\where де $\ell$ -- функція перехресної ентропії, $\lambda$ -- коефіцієнт
L2-регуляризації. Мінімізацію~\eqref{eq:loss} здійснено методом AdamW.

## Архітектура гібридної мережі

Запропонована архітектура HybridNet (рисунок~\ref{fig:arch}) поєднує
два паралельних потоки:

- **локальний** (CNN) -- видобування текстурних та локальних ознак;
- **глобальний** (ViT) -- моделювання довгострокових просторових залежностей.

\begin{figure}[H]
  \centering
  \includegraphics[width=0.88\linewidth]{assets/images/architecture.png}
  \caption{Архітектура запропонованої гібридної мережі HybridNet}
  \label{fig:arch}
\end{figure}

Об'єднання ознак відбувається через механізм зваженої конкатенації:

\begin{equation}
  z = \alpha \cdot z_{\text{local}} \oplus (1-\alpha) \cdot z_{\text{global}},
  \label{eq:fusion}
\end{equation}

\where де $\alpha \in [0,1]$ -- навчуваний параметр балансу гілок~\eqref{eq:fusion}.

## Реалізація

Модель реалізована мовою Python з використанням PyTorch.
Основну архітектуру показано у лістингу~\ref{lst:hybridnet}.

\snippet{listing_hybridnet.tex}

\chapterconclusion{2}

Розроблено архітектуру HybridNet, що поєднує CNN і ViT через механізм зваженої
конкатенації~\eqref{eq:fusion}. Реалізацію (лістинг~\ref{lst:hybridnet})
виконано на PyTorch.
