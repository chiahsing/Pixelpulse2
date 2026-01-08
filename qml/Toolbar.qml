import QtGraphicalEffects 1.0
import QtQuick 2.1
import QtQuick.Controls 2.3
import QtQuick.Dialogs 1.0
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0
import "dataexport.js" as CSVExport
import "sesssave.js" as StateSave

ToolbarStyle {
    property alias repeatedSweep: repeatedSweepItem.checked
    property alias plotsVisible: plotsVisibleItem.checked
    property alias contentVisible: contentVisibleItem.checked
    property alias deviceMngrVisible: deviceMngrVisibleItem.checked
    property alias colorDialog: sessColorDialog
    property alias acqusitionDialog: sessAcqSettDialog

    ButtonGroup {
        id: timeGroup
    }

    AcquisitionSettingsDialog {
        id: sessAcqSettDialog
    }

    FileDialog {
        id: dataDialog

        selectExisting: false
        title: "Please enter a location to save your data."
        nameFilters: ["CSV files (*.csv)", "All files (*)"]
        onAccepted: {
            CSVExport.saveData(dataDialog.fileUrls[0]);
        }
    }

    FileDialog {
        id: sessSaveDialog

        selectExisting: false
        title: "Please enter a location to save your session."
        nameFilters: ["JSON files (*.json)", "All files (*)"]
        onAccepted: {
            fileio.writeByURI(sessSaveDialog.fileUrls[0], JSON.stringify(StateSave.saveState(), 0, 2));
        }
    }

    FileDialog {
        id: sessRestoreDialog

        selectExisting: true
        title: "Please select a session to restore."
        nameFilters: ["JSON files (*.json)", "All files (*)"]
        onAccepted: {
            StateSave.restoreState(JSON.parse(fileio.readByURI(sessRestoreDialog.fileUrls[0])));
        }
    }

    ColorControlDialog {
        id: sessColorDialog
    }

    Button {
        ToolTip.text: "Menu"
        ToolTip.visible: hovered
        hoverEnabled: true
        Layout.fillHeight: true
        background: Loader {
            sourceComponent: btnStyle
            property bool pressed: parent.pressed
            property bool checked: parent.checked
        }
        icon.source: 'qrc:/icons/gear.png'
        icon.color: "white"
        icon.width: 32
        icon.height: 32
        onClicked: menu.open()

        Menu {
            id: menu
            y: parent.height
            MenuItem {
                id: repeatedSweepItem

                text: "Repeated sweep"
                checkable: true
                checked: true
            }

            Menu {
                title: "Sample Time"

                MenuItem {
                    ButtonGroup.group: timeGroup
                    checkable: true
                    checked: controller.sampleTime == 0.01 ? true : false
                    onTriggered: controller.sampleTime = 0.01
                    text: '10 ms'
                }

                MenuItem {
                    ButtonGroup.group: timeGroup
                    checkable: true
                    checked: controller.sampleTime == 0.1 ? true : false
                    onTriggered: controller.sampleTime = 0.1
                    text: '100 ms'
                }

                MenuItem {
                    ButtonGroup.group: timeGroup
                    checkable: true
                    checked: controller.sampleTime == 1 ? true : false
                    onTriggered: controller.sampleTime = 1
                    text: '1 s'
                }

                MenuItem {
                    ButtonGroup.group: timeGroup
                    checkable: true
                    checked: controller.sampleTime == 10 ? true : false
                    onTriggered: controller.sampleTime = 10
                    text: '10 s'
                }

            }

            MenuItem {
                id: dataLoggingItem

                text: "Data logging"
                checkable: true
                checked: false
                enabled: controller.sampleTime == 0.1 || controller.sampleTime == 0.01 ? false : true
                onTriggered: session.onLoggingChanged()
            }

            MenuItem {
                id: plotsVisibleItem

                text: "X-Y Plots"
                checkable: true
            }

            MenuItem {
                id: contentVisibleItem

                text: "About"
                checkable: true
            }

            MenuItem {
                id: deviceMngrVisibleItem

                text: "Device Manager"
                checkable: true
            }

            MenuSeparator {
            }

            MenuItem {
                id: acquisVisibleItem

                text: "Acqusition Settings"
                onTriggered: sessAcqSettDialog.visible = true
            }

            MenuItem {
                id: dataSaveVisibleItem

                text: "Export Data"
                onTriggered: dataDialog.visible = true
            }

            MenuItem {
                id: sessionSaveVisibleItem

                text: "Save Session"
                onTriggered: sessSaveDialog.visible = true
            }

            MenuItem {
                id: sessionRestoreVisibleItem

                text: "Restore Session"
                onTriggered: sessRestoreDialog.visible = true
            }

            MenuItem {
                id: colorControlVisibleItem

                text: "Display Settings"
                onTriggered: sessColorDialog.visible = true
            }

            MenuSeparator {
            }

            MenuItem {
                text: "Exit"
                onTriggered: Qt.quit()
            }

        }

    }

    Button {
        ToolTip.text: "Start"
        ToolTip.visible: hovered
        hoverEnabled: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignRight
        background: Loader {
            sourceComponent: btnStyle
            property bool pressed: parent.pressed
            property bool checked: parent.checked
        }
        icon.source: (controller.enabled & (session.availableDevices > 0)) ? 'qrc:/icons/pause.png' : 'qrc:/icons/play.png'
        icon.color: "white"
        icon.width: 56
        icon.height: 56
        onClicked: {
            if (session.availableDevices > 0)
                controller.toggle();

        }
    }

}
