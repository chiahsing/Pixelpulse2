import QtGraphicalEffects 1.0
import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.1
import QtQuick.Dialogs 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

Dialog {
    property alias plotCheckBox: plotsCheckBox
    property alias sigCheckBox: signalCheckBox
    property alias sliderB: sliderBrightness
    property alias sliderC: sliderContrast
    property alias sliderDot: sliderDotSize
    property alias sliderPh: sliderPhosphorRender

    title: "Display settings"
    width: 300
    height: 300
    modality: Qt.NonModal

    contentItem: RowLayout {
        id: layout

        Rectangle {
            id: rectangle

            property var lastModified
            property color intermPlotColor: '#0c0c0c'
            property color intermPlotAxes: '#222'
            property color intermSignalColor: '#0c0c0c'
            property color intermSignalAxes: '#222'

            color: '#333'
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 300
            Layout.preferredHeight: 300
            Layout.maximumHeight: 300
            Layout.maximumWidth: Layout.preferredWidth
            Layout.minimumHeight: Layout.maximumHeight
            Layout.minimumWidth: Layout.maximumWidth

            CheckBox {
                id: signalCheckBox

                focus: true
                checked: true
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.topMargin: 5 / 100 * parent.height
                anchors.leftMargin: 15 / 100 * parent.width
                onClicked: {
                    sliderContrast.valueHasChanged(signalCheckBox);
                    sliderPhosphorRender.valueHasChanged(signalCheckBox);
                    sliderDotSize.valueHasChanged(signalCheckBox);
                }

                style: CheckBoxStyle {

                    label: Text {
                        color: "white"
                        text: 'Time Plots'
                        font.pixelSize: 14
                    }

                }

            }

            CheckBox {
                id: plotsCheckBox

                focus: true
                checked: xyPane.visible ? true : false
                anchors.top: parent.top
                anchors.left: signalCheckBox.right
                anchors.topMargin: 5 / 100 * parent.height
                anchors.leftMargin: 30
                onClicked: {
                    sliderContrast.valueHasChanged(plotsCheckBox);
                    sliderPhosphorRender.valueHasChanged(plotsCheckBox);
                    sliderDotSize.valueHasChanged(plotsCheckBox);
                }

                style: CheckBoxStyle {

                    label: Text {
                        color: "white"
                        text: 'XY Plots'
                        font.pixelSize: 14
                    }

                }

            }

            Text {
                id: brightLabel

                visible: true
                text: 'Brightness'
                font.pixelSize: 14
                color: 'white'
                anchors.top: plotsCheckBox.bottom
                anchors.left: signalCheckBox.left
                anchors.topMargin: 5 / 100 * parent.height
            }

            Slider {
                id: sliderBrightness

                property real factor
                property real oldValue: 0

                function valueHasChanged(obj) {
                    factor = (sliderBrightness.value);
                    if (plotsCheckBox.checked && (obj !== signalCheckBox)) {
                        var rPlot = parent.intermPlotColor.r + (100 * factor) / 255;
                        var rAxes = parent.intermPlotAxes.r + (100 * factor) / 255;
                        window.xyplotColor = Qt.rgba(rPlot, rPlot, rPlot, 1);
                        window.gridAxesColor = Qt.rgba(rAxes, rAxes, rAxes, 1);
                    }
                    if (signalCheckBox.checked && (obj !== plotsCheckBox)) {
                        rPlot = parent.intermSignalColor.r + (100 * factor) / 255;
                        rAxes = parent.intermSignalAxes.r + (100 * factor) / 255;
                        window.signalRowColor = Qt.rgba(rPlot, rPlot, rPlot, 1);
                        window.signalAxesColor = Qt.rgba(rAxes, rAxes, rAxes, 1);
                    }
                    if (signalCheckBox.checked && plotsCheckBox.checked)
                        oldValue = value;

                }

                focus: true
                anchors.top: brightLabel.bottom
                anchors.topMargin: 1 / 100 * parent.height
                anchors.left: signalCheckBox.left
                value: 0
                minimumValue: 0
                maximumValue: 1
                stepSize: 0.01
                width: 70 / 100 * parent.width
                activeFocusOnPress: true
                activeFocusOnTab: true
                updateValueWhileDragging: true
                onValueChanged: valueHasChanged(sliderBrightness)

                style: StyleSlider {
                }

            }

            Text {
                id: contrastLabel

                visible: true
                text: 'Contrast'
                font.pixelSize: 14
                color: 'white'
                anchors.top: sliderBrightness.bottom
                anchors.left: signalCheckBox.left
                anchors.topMargin: 5 / 100 * parent.height
            }

            Slider {
                id: sliderContrast

                property real factor
                property real oldValue: 0
                property color plotC: '#0c0c0c'
                property color gridC: '#222'

                function valueHasChanged(obj) {
                    factor = (sliderContrast.value);
                    var rPlot = plotC.r - (100 * factor) / 255;
                    var rAxes = gridC.r + (100 * factor) / 255;
                    if (plotsCheckBox.checked && (obj !== signalCheckBox)) {
                        parent.intermPlotAxes = Qt.rgba(rAxes, rAxes, rAxes, 1);
                        parent.intermPlotColor = Qt.rgba(rPlot, rPlot, rPlot, 1);
                        if (factor === 1)
                            parent.intermPlotAxes = '#fdfdfd';

                    }
                    if (signalCheckBox.checked && (obj !== plotsCheckBox)) {
                        parent.intermSignalAxes = Qt.rgba(rAxes, rAxes, rAxes, 1);
                        parent.intermSignalColor = Qt.rgba(rPlot, rPlot, rPlot, 1);
                        if (factor === 1)
                            parent.intermSignalAxes = '#fdfdfd';

                    }
                    if (signalCheckBox.checked && plotsCheckBox.checked)
                        oldValue = value;

                    // Check for value updates in brightness slider
                    sliderBrightness.valueHasChanged(sliderContrast);
                }

                anchors.top: contrastLabel.bottom
                anchors.topMargin: 1 / 100 * parent.height
                anchors.left: signalCheckBox.left
                value: 0
                minimumValue: 0
                focus: true
                maximumValue: 1
                stepSize: 0.01
                width: 70 / 100 * parent.width
                activeFocusOnTab: true
                activeFocusOnPress: true
                updateValueWhileDragging: true
                onValueChanged: sliderContrast.valueHasChanged(sliderContrast)

                style: StyleSlider {
                }

            }

            Text {
                id: phosphorLabel

                visible: true
                text: 'Dot Brightness'
                font.pixelSize: 14
                color: 'white'
                anchors.top: sliderContrast.bottom
                anchors.left: signalCheckBox.left
                anchors.topMargin: 5 / 100 * parent.height
            }

            Slider {
                id: sliderPhosphorRender

                property real factor
                property color dotCurrent: Qt.rgba(0.2, 0.2, 0.03, 1)
                property color dotVoltage: Qt.rgba(0.03, 0.3, 0.03, 1)

                function valueHasChanged(obj) {
                    factor = (sliderPhosphorRender.value);
                    var rCurrent = dotCurrent.r + (300 * factor) / 255;
                    var gCurrent = dotCurrent.g + (500 * factor) / 255;
                    var bCurrent = dotCurrent.b + (100 * factor) / 255;
                    var rVoltage = dotVoltage.r + (100 * factor) / 255;
                    var gVoltage = dotVoltage.g + (500 * factor) / 255;
                    var bVoltage = dotVoltage.b + (100 * factor) / 255;
                    if (plotsCheckBox.checked && (obj !== signalCheckBox)) {
                        window.dotPlotsCurrent = Qt.rgba(rCurrent, gCurrent, bCurrent, 1);
                        window.dotPlotsVoltage = Qt.rgba(rVoltage, gVoltage, bVoltage, 1);
                    }
                    if (signalCheckBox.checked && (obj !== plotsCheckBox)) {
                        window.dotSignalCurrent = Qt.rgba(rCurrent, gCurrent, bCurrent, 1);
                        window.dotSignalVoltage = Qt.rgba(rVoltage, gVoltage, bVoltage, 1);
                    }
                }

                anchors.top: phosphorLabel.bottom
                anchors.topMargin: 1 / 100 * parent.height
                anchors.left: signalCheckBox.left
                value: 0
                minimumValue: 0
                focus: true
                maximumValue: 1
                stepSize: 0.01
                width: 70 / 100 * parent.width
                activeFocusOnTab: true
                activeFocusOnPress: true
                updateValueWhileDragging: true
                onValueChanged: sliderPhosphorRender.valueHasChanged(sliderPhosphorRender)

                style: StyleSlider {
                }

            }

            Text {
                id: dotSizeLabel

                visible: true
                text: 'Dot Size'
                font.pixelSize: 14
                color: 'white'
                anchors.top: sliderPhosphorRender.bottom
                anchors.left: signalCheckBox.left
                anchors.topMargin: 5 / 100 * parent.height
            }

            Slider {
                id: sliderDotSize

                property real factor

                function valueHasChanged(obj) {
                    factor = sliderDotSize.value;
                    if (plotsCheckBox.checked && (obj !== signalCheckBox))
                        window.dotSizePlots = factor;

                    if (signalCheckBox.checked && (obj !== plotsCheckBox))
                        window.dotSizeSignal = factor;

                }

                anchors.top: dotSizeLabel.bottom
                anchors.topMargin: 1 / 100 * parent.height
                anchors.left: signalCheckBox.left
                value: 0.1
                minimumValue: 0.1
                focus: true
                maximumValue: 1
                stepSize: 0.1
                width: 70 / 100 * parent.width
                activeFocusOnTab: true
                activeFocusOnPress: true
                updateValueWhileDragging: true
                onValueChanged: sliderDotSize.valueHasChanged(sliderDotSize)

                style: StyleSlider {
                }

            }

        }

    }

}
