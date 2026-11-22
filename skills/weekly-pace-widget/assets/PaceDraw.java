package example.pace;

import android.graphics.*;

/** Reference drawing code: pace math, a bar and a ring with a pace marker. No network and no sign-in code. */
final class PaceDraw {
    static final long WEEK = 7L * 24 * 3600;

    /** @return pace in percent: share of the week elapsed x baseline */
    static double pace(long nowSec, long resetsAtSec, int baselinePercent) {
        double elapsed = Math.max(0, Math.min(1, (nowSec - (resetsAtSec - WEEK)) / (double) WEEK));
        return elapsed * baselinePercent;
    }

    static int statusColor(double delta) { return delta <= 0 ? 0xFF2BB8A5 : (delta < 12 ? 0xFFE0A030 : 0xFFE05252); }

    static void bar(Canvas cv, float x0, float x1, float y, float h, double used, double pace, int color, int track, int marker) {
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG);
        p.setColor(track); cv.drawRoundRect(new RectF(x0, y, x1, y + h), h / 2, h / 2, p);
        p.setColor(color);
        float fx = (float) (x0 + (x1 - x0) * Math.min(1, used / 100));
        if (fx > x0 + h / 2) cv.drawRoundRect(new RectF(x0, y, fx, y + h), h / 2, h / 2, p);
        p.setColor(marker); p.setStrokeWidth(Math.max(2, h * 0.22f));
        float bx = (float) (x0 + (x1 - x0) * Math.min(1, pace / 100));
        cv.drawLine(bx, y - h * 0.35f, bx, y + h * 1.35f, p);
    }

    static void ring(Canvas cv, float cx, float cy, float r, float stroke, double used, double pace, int color, int track, int marker) {
        RectF oval = new RectF(cx - r, cy - r, cx + r, cy + r);
        Paint p = new Paint(Paint.ANTI_ALIAS_FLAG); p.setStyle(Paint.Style.STROKE); p.setStrokeWidth(stroke);
        p.setColor(track); cv.drawArc(oval, 0, 360, false, p);
        p.setColor(color); p.setStrokeCap(Paint.Cap.ROUND);
        if (used > 0.5) cv.drawArc(oval, -90, (float) (360 * Math.min(1, used / 100)), false, p);
        double a = Math.toRadians(-90 + 360 * Math.min(1, pace / 100));
        p.setColor(marker); p.setStrokeWidth(Math.max(2, stroke * 0.24f));
        cv.drawLine((float) (cx + (r - stroke * 0.9f) * Math.cos(a)), (float) (cy + (r - stroke * 0.9f) * Math.sin(a)),
                    (float) (cx + (r + stroke * 0.9f) * Math.cos(a)), (float) (cy + (r + stroke * 0.9f) * Math.sin(a)), p);
    }
}
