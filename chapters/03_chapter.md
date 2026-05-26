# Експериментальне дослідження

## Умови проведення експериментів

Всі експерименти проводились на обчислювальному кластері:
GPU NVIDIA A100 (40~GB), CPU AMD EPYC 7742 (64 ядра), RAM 512~GB.
Гіперпараметри навчання наведено у таблиці~\ref{tbl:hyperparams}.

\snippet{table_hyperparams.tex}

## Результати та порівняння

Результати порівняння наведено у таблиці~\ref{tbl:results}
та на рисунку~\ref{fig:chart}.

\snippet{table_results.tex}

\snippet{figure_chart.tex}

Запропонований метод перевищує найкращий базовий підхід на 2.5\% за Accuracy
та на 0.036 за F1-score (таблиця~\ref{tbl:results}, рисунок~\ref{fig:chart}).

## Аналіз компонентів

Ablation study (таблиця~\ref{tbl:ablation}) підтвердив внесок кожної гілки.

\snippet{table_ablation.tex}

\chapterconclusion{3}

Проведено порівняльне дослідження HybridNet та трьох базових підходів.
HybridNet демонструє найвищі показники. Ablation study підтвердив доцільність
навчуваного параметра~$\alpha$ у формулі~\eqref{eq:fusion}.