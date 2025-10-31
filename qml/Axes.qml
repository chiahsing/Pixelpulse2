import QtQuick 2.15
import QtQuick.Layouts 1.11

Item {
    id: axes

    property bool xbottom: true
    property bool yleft: true
    property bool yright: true
    property real xmin: 0
    property real xmax: 1
    property real ymin: 0
    property real ymax: 1
    property real textSpacing: 12
    property int xgridticks: Math.max(0, width / 12)
    property int ygridticks: Math.max(0, height / 12)
    property var gridColor: '#fff'
    property var textColor: '#fff'
    property var textSize: 14
    property real xstep: step(xmin, xmax, xgridticks)
    property real xstart: Math.ceil(xmin / xstep)
    property real ystep: step(ymin, ymax, ygridticks)
    property real ystart: Math.ceil(ymin / ystep)
    property real yscale: height / (ymax - ymin)
    property real xscale: width / (xmax - xmin)

    function step(min, max, count) {
        // Inspired by d3.js
        var span = max - min;
        var step = Math.pow(10, Math.floor(Math.log(span / count) / Math.LN10));
        var err = count / span * step;
        // Filter ticks to get closer to the desired count.
        if (err <= 0.35)
            step *= 10;
        else if (err <= 0.75)
            step *= 5;
        else if (err <= 1)
            step *= 2;
        return step;
    }

    function yToPx(y) {
        return height - (y - ymin) * yscale;
    }

    function yToPxClamped(y) {
        return Math.min(Math.max(yToPx(y), 0), height);
    }

    function pxToY(px) {
        return (height - px) / yscale + ymin;
    }

    function pxToX(px) {
        return px / xscale + xmin;
    }

    function snapx(x) {
        return Math.round(x / (timeline_header.step / (1 / controller.sampleRate))) * (timeline_header.step / (1 / controller.sampleRate));
    }

    function snapy(y) {
        return Math.round(y / ystep) * ystep;
    }

    function xToPx(x) {
        return (x - xmin) * xscale;
    }

    function decimals(x) {
        var tmp = x;
        if (tmp.indexOf(".") > -1)
            return tmp.length - tmp.indexOf(".") - 1;
        else
            return 0;
    }

    Repeater {
        model: ygridticks

        Rectangle {
            property real yval: ((ystart + index) * ystep)
            property string syval: yval.toFixed(decimals(Math.abs(ystep).toString()))

            visible: yval <= ymax
            x: 0
            y: yToPx(yval)
            width: axes.width
            height: 1
            color: gridColor

            Text {
                visible: yleft
                anchors.right: parent.left
                anchors.rightMargin: textSpacing * 2
                anchors.leftMargin: textSpacing
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: textSize
                color: textColor
                text: syval
            }

            Text {
                visible: yright
                anchors.left: parent.right
                anchors.rightMargin: textSpacing * 2
                anchors.leftMargin: textSpacing
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: textSize
                color: textColor
                text: syval
            }

        }

    }

    Repeater {
        model: xgridticks

        Rectangle {
            property real xval: (xstart + index) * xstep
            property string sxval: xval.toFixed(decimals(Math.abs(xstep).toString()))

            visible: xval <= xmax
            x: xToPx(xval)
            y: 0
            width: 1
            height: axes.height
            color: gridColor

            Text {
                visible: xbottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.bottom
                anchors.bottomMargin: textSpacing * 2
                anchors.topMargin: textSpacing
                font.pixelSize: textSize
                color: textColor
                text: sxval
                rotation: -90
            }

        }

    }

}
