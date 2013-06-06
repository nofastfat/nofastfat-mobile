package com.xy.graphics {
import flash.display.Shape;
import flash.geom.Point;

/**
 * 赛贝尔曲线
 * 配合CubicBezierCurve.swf使用
 * @author xy
 */
public class CubicBezier {
    // Default values
    private var segments : Number = 100;
    private var color : uint = 0x000000;
    private var thikness : Number = 1;

    //Reference objects
    private var anchor1 : Point;
    private var anchor2 : Point;
    private var control1 : Point;
    private var control2 : Point;

    /**
     * Constructor
     *
     * used to store references to anchor points and control points
     */
    public function CubicBezier(anchorPoint1 : Point, anchorPoint2 : Point, controlPoint1 : Point, controlPoint2 : Point, color : uint = 0x666666, thikness : int = 1) {
        anchor1 = anchorPoint1;
        anchor2 = anchorPoint2;
        control1 = controlPoint1;
        control2 = controlPoint2;
        this.color = color;
        this.thikness = thikness;
    }

    /**
     * Draws a bezier curve by dividing it up in the predefined segments and draws a line between them
     *
     * @todo	find a way to use less segments and use curveTo to draw the line
     */
    public function draw() : Shape {
        var step : Number = 1 / segments;
        var line : Shape = new Shape();
        line.graphics.lineStyle(thikness, color);
        line.graphics.moveTo(anchor1.x, anchor1.y);

        var posx : Number;
        var posy : Number;

        //This loops draws each step of the curve
        for (var u : Number = 0; u <= 1; u += step) {
            posx = Math.pow(u, 3) * (anchor2.x + 3 * (control1.x - control2.x) - anchor1.x) + 3 * Math.pow(u, 2) * (anchor1.x - 2 * control1.x + control2.x) + 3 * u * (control1.x - anchor1.x) + anchor1.x;
            posy = Math.pow(u, 3) * (anchor2.y + 3 * (control1.y - control2.y) - anchor1.y) + 3 * Math.pow(u, 2) * (anchor1.y - 2 * control1.y + control2.y) + 3 * u * (control1.y - anchor1.y) + anchor1.y;
            line.graphics.lineTo(posx, posy);
        }

        //As a final step, make sure the curve ends on the second anchor
        line.graphics.lineTo(anchor2.x, anchor2.y);

        return line;
    }

    /**
     *	Set number of segments
     */
    public function setSegments(_segments : Number) : void {
        segments = _segments;
    }

    /**
     * 	Set color
     */
    public function setColor(_color : uint) : void {
        color = _color;
    }

    /**
     * 	Set thikness
     */
    public function setThikness(_thikness : Number) : void {
        thikness = _thikness;
    }
}
}
