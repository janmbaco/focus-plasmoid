import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5 as Controls
import QtQuick.Window 2.7

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: root

    readonly property bool isVertical: plasmoid.formFactor === PlasmaCore.Types.Vertical

    Plasmoid.switchWidth: units.gridUnit * 10
    Plasmoid.switchHeight: units.gridUnit * 12

    property var min: 25
    property var sec: 0
    property var stateVal: 1
    property var maxTime: 1500
    property var currTime: 1500
    property var customIconSource: "pomodoro-start-light"

    NotificationManager { id: notificationManager }

    Plasmoid.compactRepresentation: MouseArea {
        id: compactRoot

        onClicked: plasmoid.expanded = !plasmoid.expanded

        PlasmaCore.IconItem {
            width: height
            height: compactRoot.height
            Layout.preferredWidth: height
            source: customIconSource
        }
    }

    Plasmoid.fullRepresentation: Item {
        id: fullRoot

        Layout.minimumWidth: units.gridUnit * 12
        Layout.maximumWidth: units.gridUnit * 12
        Layout.minimumHeight: units.gridUnit * 10
        Layout.maximumHeight: units.gridUnit * 10

        property bool isPinVisible: {
            return plasmoid.location != PlasmaCore.Types.Floating
        }

        RowLayout {
            id: buttonsRow
            spacing: 8

            anchors.horizontalCenter: parent.horizontalCenter

            PlasmaComponents.Button {
                id: skipBtn
                text: "Skip"
                implicitWidth: minimumWidth
                iconSource: "media-skip-forward"
                onClicked: skip()
            }

            PlasmaComponents.Button {
                id: sessionBtn
                text: "Start"
                implicitWidth: minimumWidth
                iconSource: "media-playback-start"
                onClicked: {
                    if(sessionBtn.text == "Start") {
                        start()
                    } else {
                        pause()
                    }
                }
            }

            PlasmaComponents.Button {
                id: breakBtn
                text: "Stop"
                implicitWidth: minimumWidth
                iconSource: "media-playback-stop"
                onClicked: stop()
            }
        }

        function start() {
            notificationManager.start(stateVal)
            textTimer.start()
            sessionBtn.text = "Pause"
            sessionBtn.iconSource= "media-playback-pause"
            customIconSource = "pomodoro-indicator-light-53"
        }

        function pause() {
            textTimer.stop()
            sessionBtn.text = "Start"
            sessionBtn.iconSource= "media-playback-start"
            customIconSource = "pomodoro-start-light"
        }

        function skip() {
            nextState()
            resetTime()
        }

        function stop() {
            textTimer.stop()
            stateVal = 1
            resetTime()
            sessionBtn.text = "Start"
            sessionBtn.iconSource= "media-playback-start"
            customIconSource = "pomodoro-start-light"
        }

        function end() {
            notificationManager.end()
            textTimer.stop()
            sessionBtn.text = "Start"
            sessionBtn.iconSource= "media-playback-start"
            customIconSource = "pomodoro-start-light"
            nextState()
            resetTime()
        }

        function resetTime() {
            sec = 0
            switch(stateVal) {
                case 1:
                case 3:
                case 5:
                case 7:
                    min = 25
                    currTime = 1500
                    maxTime = 1500
                    status.text = "focus"
                    break;
                case 2:
                case 4:
                case 6:
                    min = 5
                    currTime = 300
                    maxTime = 300
                    status.text = "short break"
                    break;
                case 8:
                    min = 20
                    currTime = 1200
                    maxTime = 1200
                    status.text = "long break"
                    break;
            }

            time.update()
        }

        function nextState() {
            if(stateVal < 8) {
                stateVal++
            } else {
                stateVal = 1
            }
        }

        Timer {
            id: textTimer
            interval: 1000
            repeat: true
            running: false
            triggeredOnStart: false
            onTriggered: time.set()
        }

        Column {
            anchors.top: buttonsRow.bottom
            anchors.left: fullRoot.left
            anchors.right: fullRoot.right
            anchors.bottom: fullRoot.bottom

            Column {
                anchors.centerIn: parent;
                height: time.height 

                PlasmaComponents.Label {
                    id: time
                    text: formatNumberLength(min,2) + ":" + formatNumberLength(sec,2)
                    font.pointSize: fullRoot.width/6
                    anchors.horizontalCenter: parent.horizontalCenter

                    function set() {
                        if(sec == 0) {
                            min--
                            sec = 59
                        } else {
                            sec--
                        }

                        currTime--

                        if(currTime == 0) {
                            end()
                        }

                        time.update()
                    }

                    function update() {
                        time.text = formatNumberLength(min,2) + ":" + formatNumberLength(sec,2)
                    }

                    function formatNumberLength(num, length) {
                        var r = "" + num;
                        while (r.length < length) {
                            r = "0" + r;
                        }
                        return r;
                    }
                }

                Controls.PageIndicator {
                    id: pageIndicator
                    count: 4
                    currentIndex: (stateVal - 1)/2

                    anchors.bottom: time.top
                    anchors.horizontalCenter: parent.horizontalCenter

                    spacing: fullRoot.width/25
                    delegate: Rectangle {
                        implicitWidth: fullRoot.width/25
                        implicitHeight: width
                        radius: width / 2
                        color: theme.activeTextColor

                        opacity: index === pageIndicator.currentIndex ? 0.95 : 0.3

                        Behavior on opacity {
                            OpacityAnimator {
                                duration: 100
                            }
                        }
                    }
                }

                PlasmaComponents.Label {
                    id: status
                    text: "focus"
                    font.pointSize: fullRoot.width/15
                    anchors.top: time.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        Binding {
            target: plasmoid
            property: "hideOnWindowDeactivate"
            value: !plasmoid.configuration.pin
        }

        PlasmaComponents.ToolButton {
            visible: isPinVisible
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            width: Math.round(units.gridUnit * 1.25)
            height: width
            checkable: true
            iconSource: "window-pin"
            checked: plasmoid.configuration.pin
            onCheckedChanged: plasmoid.configuration.pin = checked
        }
    }
}
