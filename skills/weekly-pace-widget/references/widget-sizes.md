# Widget sizes

Offer 8 home screen sizes (columns x rows): 1x1, 2x1, 3x1, 4x1, 1x2, 2x2, 3x2, 4x2. Register each as its own `AppWidgetProvider` (thin subclasses of one class) so the launcher lists them separately. Draw into a bitmap sized from `AppWidgetManager.getAppWidgetOptions` (`OPTION_APPWIDGET_MIN_WIDTH`, `OPTION_APPWIDGET_MAX_HEIGHT`), and redraw when the size changes.

What to show per size:

| Size | Content |
| --- | --- |
| 1x1 | percent, tiny bar or ring, short delta (`-6%p`) |
| 2x1 | percent left; short delta, bar, pace on the right |
| 3x1, 4x1 | add text status and time left; 4x1 adds age |
| 1x2, 2x2 | stacked: percent, delta, bar or ring, time left |
| 3x2, 4x2 | title, percent, status, pace, time left, reset time, age |

Rules: minimum text size 9 dp; shrink text to fit width, hide a line rather than let lines overlap; keep one pace marker (a short white line) on the bar or ring.
