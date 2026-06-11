import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5
import "./"

Rectangle {
    id: dashboardScreen
    color: "#000000"

    signal openSettings()
    signal openMonitoring()

    focus: true

    // BACKGROUND
    Image {
        anchors.fill: parent
        source: "qrc:/assets/background.png"
        fillMode: Image.PreserveAspectCrop
        cache: true
        asynchronous: true
    }

    // DASHBOARD FRAME
    Image {
        anchors.centerIn: parent
        width: parent.width * 0.98
        height: parent.height * 0.95
        source: "qrc:/assets/Dashboard.svg"
        fillMode: Image.PreserveAspectFit
        cache: true
        asynchronous: true
    }

    // DECORATIVE VECTORS
    Image {
        source: "qrc:/assets/Vector 2.svg"
        width: 150
        height: 600
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.7
        cache: true
    }

    Image {
        source: "qrc:/assets/Vector 1.svg"
        width: 150
        height: 600
        anchors.right: parent.right
        anchors.rightMargin: 50
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.7
        cache: true
    }

    // ===== TOP BAR =====
    Item {
        id: topBar
        width: parent.width * 0.7
        height: 100
        anchors.top: parent.top
        anchors.topMargin: 35
        anchors.horizontalCenter: parent.horizontalCenter

        Image {
            anchors.fill: parent
            source: "qrc:/assets/Vector 70.svg"
            fillMode: Image.PreserveAspectFit
            cache: true
        }

        // LOW BEAM INDICATOR
        Image {
            width: 40
            height: 40
            anchors.left: parent.left
            anchors.leftMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            source: appWindow.lowBeamActive ? "qrc:/assets/Low beam headlights.svg"
                                      : "qrc:/assets/Low_beam_headlights_white.svg"
            opacity: appWindow.lowBeamActive ? 1.0 : 0.7
            cache: true
        }

        // DRIVE MODE INDICATOR
        Rectangle {
            width: 120
            height: 35
            radius: 18
            color: appWindow.accentColor
            opacity: 0.3
            border.color: appWindow.accentColor
            border.width: 2
            anchors.left: parent.left
            anchors.leftMargin: 200
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: appWindow.driveMode
                font.pixelSize: 14
                font.bold: true
                color: appWindow.accentColor
                anchors.centerIn: parent
                font.family: "Arial"
            }
        }

        // TIME DISPLAY
        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                id: currentTimeLabel
                text: "00:00"
                font.pixelSize: 36
                font.bold: true
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Arial"
            }

            Text {
                id: currentDateLabel
                text: "20/11/2025"
                font.pixelSize: 14
                font.bold: true
                color: "#999"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Arial"
            }

            Component.onCompleted: {
                currentTimeLabel.text = Qt.formatDateTime(new Date(), "HH:mm")
                currentDateLabel.text = Qt.formatDateTime(new Date(), "dd/MM/yyyy")
            }
        }

        // RIGHT INFO PANEL
        Rectangle {
            width: 280
            height: 80
            radius: 12
            color: "#0A0A0A"
            border.color: appWindow.accentColor
            border.width: 1
            opacity: 0.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter

            Column {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 8

                Row {
                    width: parent.width
                    spacing: 10
                    height: 28

                    Rectangle {
                        width: 4
                        height: parent.height
                        radius: 2
                        color: appWindow.engineTemp > 105 ? "#FF3333" : "#00FF99"
                    }

                    Column {
                        spacing: 2
                        Text {
                            text: "MOTOR"
                            font.pixelSize: 10
                            font.bold: true
                            color: "#666"
                            font.family: "Arial"
                        }
                        Row {
                            spacing: 6
                            Text {
                                text: appWindow.engineTemp.toFixed(1) + "°C"
                                font.pixelSize: 16
                                font.bold: true
                                color: appWindow.engineTemp > 105 ? "#FF3333" : "#00FF99"
                                font.family: "Arial"
                            }

                            Rectangle {
                                visible: appWindow.engineTemp > 105
                                width: 14
                                height: 14
                                radius: 7
                                color: "#FF3333"
                                anchors.verticalCenter: parent.verticalCenter

                                SequentialAnimation on opacity {
                                    loops: Animation.Infinite
                                    NumberAnimation { to: 0.3; duration: 500 }
                                    NumberAnimation { to: 1.0; duration: 500 }
                                }
                            }

                            Text {
                                text: "/ 120°C"
                                font.pixelSize: 12
                                color: "#666"
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "Arial"
                            }
                        }
                    }
                }

                Row {
                    width: parent.width
                    spacing: 10
                    height: 28

                    Rectangle {
                        width: 4
                        height: parent.height
                        radius: 2
                        color: appWindow.currentBattery < 20 ? "#FF3333" :
                               appWindow.currentBattery < 50 ? "#FFFF00" : appWindow.accentColor
                    }

                    Column {
                        spacing: 2
                        Text {
                            text: "BATTERY"
                            font.pixelSize: 10
                            font.bold: true
                            color: "#666"
                            font.family: "Arial"
                        }
                        Row {
                            spacing: 6
                            Text {
                                text: Math.round(appWindow.currentBattery) + "%"
                                font.pixelSize: 16
                                font.bold: true
                                color: appWindow.currentBattery < 20 ? "#FF3333" :
                                       appWindow.currentBattery < 50 ? "#FFFF00" : appWindow.accentColor
                                font.family: "Arial"
                            }

                            Rectangle {
                                visible: appWindow.isCharging
                                width: 14
                                height: 14
                                radius: 7
                                color: "#00FF99"
                                anchors.verticalCenter: parent.verticalCenter
                                opacity: appWindow.chargingBreathe

                                Text {
                                    text: "⚡"
                                    font.pixelSize: 10
                                    anchors.centerIn: parent
                                }
                            }

                            Text {
                                text: "/ 100%"
                                font.pixelSize: 12
                                color: "#666"
                                anchors.verticalCenter: parent.verticalCenter
                                font.family: "Arial"
                            }
                        }
                    }
                }
            }
        }
    }

    // ===== ANIMATED ROAD =====
    Item {
        id: animatedRoad
        width: 200
        height: 400
        anchors.top: parent.top
        anchors.topMargin: 140
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true

        // Road lane markers
        Column {
            id: laneMarkers
            spacing: 50
            anchors.horizontalCenter: parent.horizontalCenter
            y: roadAnimation.running ? (roadYPosition % (50 + 40)) - 40 : 0

            property real roadYPosition: 0

            Repeater {
                model: 12
                Rectangle {
                    width: 12
                    height: 40
                    radius: 6
                    color: "#00FF99"
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: 0.9
                }
            }

            NumberAnimation {
                id: roadAnimation
                target: laneMarkers
                property: "roadYPosition"
                from: 0
                to: 1200
                duration: 2000
                loops: Animation.Infinite
                running: appWindow.currentSpeed > 0 && appWindow.gear === "D"
            }
        }

        // Left road edge
        Rectangle {
            width: 10
            height: parent.height
            color: "#00CCCC"
            anchors.left: parent.left
            anchors.leftMargin: 15
            radius: 5
            opacity: 0.7
        }

        // Right road edge
        Rectangle {
            width: 10
            height: parent.height
            color: "#00CCCC"
            anchors.right: parent.right
            anchors.rightMargin: 15
            radius: 5
            opacity: 0.7
        }

        // Car icon on the road
        Image {
            id: roadCarIcon
            width: 90
            height: 90
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 60
            source: "qrc:/assets/Car.svg"
            cache: true
            opacity: 1.0
        }
    }

    // ===== TURN SIGNALS =====
    Item {
        id: leftTurnSignalContainer
        width: 80
        height: 80
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.left: parent.left
        anchors.leftMargin: 100

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "transparent"
            border.color: appWindow.leftSignal ? appWindow.accentColor : "#444"
            border.width: 2
            opacity: (appWindow.leftSignal && appWindow.signalBlinkState) ? 1.0 : 0.3

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            Text {
                text: "◀"
                font.pixelSize: 32
                color: appWindow.leftSignal ? appWindow.accentColor : "#888"
                anchors.centerIn: parent
                font.bold: true
                opacity: parent.opacity
            }
        }
    }

    Item {
        id: rightTurnSignalContainer
        width: 80
        height: 80
        anchors.top: parent.top
        anchors.topMargin: 50
        anchors.right: parent.right
        anchors.rightMargin: 100

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: "transparent"
            border.color: appWindow.rightSignal ? appWindow.accentColor : "#444"
            border.width: 2
            opacity: (appWindow.rightSignal && appWindow.signalBlinkState) ? 1.0 : 0.3

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }

            Text {
                text: "▶"
                font.pixelSize: 32
                color: appWindow.rightSignal ? appWindow.accentColor : "#888"
                anchors.centerIn: parent
                font.bold: true
                opacity: parent.opacity
            }
        }
    }

    // ===== GAUGE CLUSTER =====
    Item {
        id: gaugeCluster
        width: parent.width * 0.92
        height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 100

        SideGauge {
            id: leftGauge
            title: "POWER (kW)"
            minValue: 0
            maxValue: 625
            width: 310
            height: 310
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 215
        }

        Gauge {
            id: speedGauge
            gaugeLabel: "KM/H"
            minimumValue: 0
            maximumValue: 250
            value: appWindow.currentSpeed
            width: 330
            height: 330
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 215

            Behavior on value {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.OutQuad
                }
            }
        }

        Component.onCompleted: {
            appWindow.speedGauge = speedGauge
            appWindow.leftGauge = leftGauge
        }
    }

    // ===== CENTER INFO =====
    Item {
        id: centerInfo
        width: 300
        height: 350
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 180

        Rectangle {
            width: 90
            height: 90
            radius: 45
            color: "#F0F0F0"
            border.width: 6
            border.color: appWindow.accentColor
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            visible: !appWindow.isCharging

            Text {
                text: appWindow.nextSpeedTarget.toFixed(0)
                font.pixelSize: 36
                font.bold: true
                color: "black"
                anchors.centerIn: parent
                font.family: "Arial"
            }
        }

        Rectangle {
            width: 240
            height: 60
            radius: 10
            color: appWindow.warningLevel === 2 ? "#FF3333" :
                   appWindow.warningLevel === 1 ? "#FFFF00" : "#00AA44"
            opacity: 0.2
            anchors.top: parent.top
            anchors.topMargin: -40
            anchors.horizontalCenter: parent.horizontalCenter
            border.color: appWindow.warningLevel === 2 ? "#FF3333" :
                          appWindow.warningLevel === 1 ? "#FFFF00" : "#00AA44"
            border.width: 2

            Column {
                anchors.centerIn: parent
                spacing: 4

                Text {
                    text: appWindow.warningLevel === 0 ? "✓ OPTIMAL" :
                          appWindow.warningLevel === 1 ? "⚠ CAUTION" : "⛔ CRITICAL"
                    font.pixelSize: 16
                    font.bold: true
                    color: appWindow.warningLevel === 2 ? "#FF3333" :
                           appWindow.warningLevel === 1 ? "#FFFF00" : "#00FF99"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }

                Text {
                    text: "Efficiency: " + (appWindow.efficiencyRating * 100).toFixed(0) + "%"
                    font.pixelSize: 13
                    color: "#CCC"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                }
            }
        }
    }

    // ===== LEFT INDICATORS PANEL =====
    Column {
        id: leftIndicators
        spacing: 20
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.10
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -60

        // Seatbelt Warning - ✅ THÊM MỚI
        Rectangle {
            width: 60
            height: 60
            radius: 8
            color: appWindow.seatbeltWarning ? "#FF333333" : "#1A1A1A"
            border.color: appWindow.seatbeltWarning ? "#FF3333" : "#444"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on border.color { ColorAnimation { duration: 300 } }

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width - 4

                Image {
                    width: 40
                    height: 40
                    source: "qrc:/assets/daudongco.svg"
                    cache: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: appWindow.seatbeltWarning ? 1.0 : 0.6
                }

                Text {
                    text: "BELT"
                    font.pixelSize: 10
                    color: appWindow.seatbeltWarning ? "#FF3333" : "#888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                    font.bold: true
                }
            }

            SequentialAnimation on opacity {
                running: appWindow.seatbeltWarning
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }

        // Main lights
        Column {
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                width: 45
                height: 45
                source: "qrc:/assets/Lights.svg"
                cache: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Text {
                text: "LIGHT"
                font.pixelSize: 12
                color: "#888"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Arial"
            }
        }

        // Low beam
        Column {
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                width: 45
                height: 45
                source: "qrc:/assets/Low beam headlights.svg"
                cache: true
                anchors.horizontalCenter: parent.horizontalCenter
                opacity: appWindow.lowBeamActive ? 1.0 : 0.6
            }
            Text {
                text: "LOW"
                font.pixelSize: 12
                color: appWindow.lowBeamActive ? "#00FF99" : "#888"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Arial"
            }
        }

        // SPEED WARNING - INTERACTIVE BUTTON
        Rectangle {
            width: 60
            height: 60
            radius: 8
            color: appWindow.speedWarning ? "#FF3333" : "#1A1A1A"
            border.color: appWindow.speedWarning ? "#FF3333" : "#444"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on border.color { ColorAnimation { duration: 300 } }

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width - 4

                Image {
                    width: 40
                    height: 40
                    source: appWindow.speedWarning ? "qrc:/assets/gioihantocdo.svg" : "qrc:/assets/canhbaotocdo.jpg"
                    cache: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: appWindow.speedWarning ? 1.0 : 0.6
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "SPEED"
                    font.pixelSize: 10
                    color: appWindow.speedWarning ? "#FF3333" : "#888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: appWindow.speedWarning = !appWindow.speedWarning
                cursorShape: Qt.PointingHandCursor
            }

            SequentialAnimation on opacity {
                running: appWindow.speedWarning
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }
    }

    // ===== RIGHT INDICATORS PANEL =====
    Column {
        id: rightIndicators
        spacing: 20
        anchors.right: parent.right
        anchors.rightMargin: parent.width * 0.10
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -60

        // Horn / Warning Light - ✅ THÊM MỚI
        Rectangle {
            width: 60
            height: 60
            radius: 8
            color: appWindow.hornActive ? "#FFAA0033" : "#1A1A1A"
            border.color: appWindow.hornActive ? "#FFAA00" : "#444"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on border.color { ColorAnimation { duration: 300 } }

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width - 4

                Image {
                    width: 40
                    height: 40
                    source: "qrc:/assets/FirstRightIcon.svg"
                    cache: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: appWindow.hornActive ? 1.0 : 0.6
                }

                Text {
                    text: "WARN"
                    font.pixelSize: 10
                    color: appWindow.hornActive ? "#FFAA00" : "#888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                    font.bold: true
                }
            }

            SequentialAnimation on opacity {
                running: appWindow.hornActive
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 300 }
                NumberAnimation { to: 1.0; duration: 300 }
            }
        }

        // Engineer / Oil Pressure - ✅ CẬP NHẬT
        // OIL PRESSURE WARNING - INTERACTIVE (BTN_DAU)
        Rectangle {
            width: 60
            height: 60
            radius: 8
            color: appWindow.oilPressureLow ? "#FF333333" : "#1A1A1A"
            border.color: appWindow.oilPressureLow ? "#FF3333" : "#444"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on border.color { ColorAnimation { duration: 300 } }

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width - 4

                Image {
                    width: 40
                    height: 40
                    source: "qrc:/assets/engineer.png"
                    cache: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: appWindow.oilPressureLow ? 1.0 : 0.6
                }

                Text {
                    text: "OIL"
                    font.pixelSize: 10
                    color: appWindow.oilPressureLow ? "#FF3333" : "#888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                    font.bold: true
                }
            }

            // Blinking animation when warning
            SequentialAnimation on opacity {
                running: appWindow.oilPressureLow
                loops: Animation.Infinite
                NumberAnimation { to: 0.5; duration: 500 }
                NumberAnimation { to: 1.0; duration: 500 }
            }
        }

        // ABS - INTERACTIVE BUTTON
        Rectangle {
            width: 60
            height: 60
            radius: 8
            color: appWindow.absActive ? "#FF0088" : "#1A1A1A"
            border.color: appWindow.absActive ? "#FF0088" : "#444"
            border.width: 2
            anchors.horizontalCenter: parent.horizontalCenter

            Behavior on color { ColorAnimation { duration: 300 } }
            Behavior on border.color { ColorAnimation { duration: 300 } }

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width - 4

                Image {
                    width: 40
                    height: 40
                    source: appWindow.absActive ? "qrc:/assets/FourthRightIcon_red.svg" : "qrc:/assets/FourthRightIcon.svg"
                    cache: true
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: appWindow.absActive ? 1.0 : 0.6
                }

                Text {
                    text: "ABS"
                    font.pixelSize: 11
                    color: appWindow.absActive ? "#FF0088" : "#888"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Arial"
                    font.bold: true
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: appWindow.absActive = !appWindow.absActive
                cursorShape: Qt.PointingHandCursor
            }
        }

        // DISTANCE SENSOR WITH SVG ICON
        Column {
            spacing: 4
            anchors.horizontalCenter: parent.horizontalCenter

            Rectangle {
                width: 60
                height: 60
                radius: 8
                color: appWindow.obstacleDetected ? "#330000" : "#1A1A1A"
                border.color: appWindow.obstacleDetected ? "#FF3333" : "#00CCCC"
                border.width: 2
                anchors.horizontalCenter: parent.horizontalCenter

                Behavior on color { ColorAnimation { duration: 300 } }
                Behavior on border.color { ColorAnimation { duration: 300 } }

                Image {
                    width: 45
                    height: 45
                    source: "qrc:/assets/khoangcach.svg"
                    cache: true
                    anchors.centerIn: parent
                    opacity: appWindow.obstacleDetected ? 1.0 : 0.7

                    Behavior on opacity { NumberAnimation { duration: 300 } }

                    SequentialAnimation on opacity {
                        running: appWindow.obstacleDetected
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 400 }
                        NumberAnimation { to: 1.0; duration: 400 }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: appWindow.obstacleDetected = !appWindow.obstacleDetected
                    cursorShape: Qt.PointingHandCursor
                }
            }

            Text {
                text: appWindow.obstacleDetected ? ("⚠ " + appWindow.distanceCm + "cm") : "DIST"
                font.pixelSize: 10
                color: appWindow.obstacleDetected ? "#FF3333" : "#00CCCC"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Arial"
                font.bold: true

                Behavior on color { ColorAnimation { duration: 300 } }
            }
        }
    }

    // ===== BOTTOM BAR =====
    Rectangle {
        id: bottomBar
        width: parent.width * 0.85
        height: 100
        color: "transparent"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        RowLayout {
            anchors.fill: parent

            Text {
                text: (appWindow.engineTemp * 9/5 + 32).toFixed(1) + " °F"
                font.pixelSize: 28
                color: appWindow.engineTemp > 105 ? "#FF3333" : "#00FF99"
                font.bold: true
                font.family: "Arial"
            }

            Item { Layout.fillWidth: true }

            Row {
                spacing: 15

                Image {
                    width: 35
                    height: 35
                    source: "qrc:/assets/fuel.svg"
                    fillMode: Image.PreserveAspectFit
                    cache: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    spacing: 4
                    Repeater {
                        model: 20
                        Rectangle {
                            width: 12
                            height: 25
                            radius: 2
                            color: getPowerBarColor(index, 20)
                            transform: Rotation {
                                origin.x: 6
                                origin.y: 12.5
                                angle: 15
                            }
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                    }
                }

                Text {
                    text: Math.round(appWindow.currentSpeed * 0.621371) + " MPH"
                    font.pixelSize: 28
                    color: "white"
                    font.bold: true
                    leftPadding: 10
                    font.family: "Arial"
                }
            }

            Item { Layout.fillWidth: true }

            Row {
                spacing: 25
                Repeater {
                    model: ["P", "R", "N", "D"]
                    delegate: Text {
                        text: modelData
                        font.pixelSize: 32
                        color: appWindow.gear === modelData ?
                               (modelData === "P" ? appWindow.accentColor :
                                modelData === "R" ? "#FF3333" :
                                modelData === "N" ? "white" : "#00FF99") : "#888"
                        font.bold: true
                        font.family: "Arial"
                        Behavior on color { ColorAnimation { duration: 200 } }
                        Behavior on scale { NumberAnimation { duration: 200 } }
                        scale: appWindow.gear === modelData ? 1.2 : 1.0
                    }
                }
            }
        }
    }

    // ===== KEYBOARD INPUT =====
    Keys.onPressed: (event) => {
        if (event.key === Qt.Key_Space) speedGauge.accelerating = true
        if (event.key === Qt.Key_L) appWindow.lowBeamActive = !appWindow.lowBeamActive
        if (event.key === Qt.Key_P) { appWindow.gear = "P"; appWindow.isCharging = false }
        if (event.key === Qt.Key_R) appWindow.gear = "R"
        if (event.key === Qt.Key_D) appWindow.gear = "D"
        if (event.key === Qt.Key_N) appWindow.gear = "N"

        if (event.key === Qt.Key_BracketLeft) {
            appWindow.leftSignal = !appWindow.leftSignal
            appWindow.rightSignal = false
            appWindow.hazardActive = false
        }

        if (event.key === Qt.Key_BracketRight) {
            appWindow.rightSignal = !appWindow.rightSignal
            appWindow.leftSignal = false
            appWindow.hazardActive = false
        }

        if (event.key === Qt.Key_H) {
            appWindow.hazardActive = !appWindow.hazardActive
            appWindow.leftSignal = appWindow.hazardActive
            appWindow.rightSignal = appWindow.hazardActive
        }

        if (event.key === Qt.Key_M) {
            dashboardScreen.openSettings()
        }

        if (event.key === Qt.Key_C && appWindow.gear === "P") {
            appWindow.isCharging = !appWindow.isCharging
        }

        if (event.key === Qt.Key_F) {
            appWindow.rareFogLightActive = !appWindow.rareFogLightActive
        }

        if (event.key === Qt.Key_A) {
            appWindow.absActive = !appWindow.absActive
        }

        if (event.key === Qt.Key_1) {
            appWindow.roadSlippery = !appWindow.roadSlippery
            if (appWindow.roadSlippery) {
                appWindow.roadWet = false
                appWindow.roadIcy = false
            }
        }

        if (event.key === Qt.Key_2) {
            appWindow.roadWet = !appWindow.roadWet
            if (appWindow.roadWet) {
                appWindow.roadSlippery = false
                appWindow.roadIcy = false
            }
        }

        if (event.key === Qt.Key_3) {
            appWindow.roadIcy = !appWindow.roadIcy
            if (appWindow.roadIcy) {
                appWindow.roadSlippery = false
                appWindow.roadWet = false
            }
        }

        event.accepted = true
    }

    Keys.onReleased: (event) => {
        if (event.key === Qt.Key_Space) speedGauge.accelerating = false
        event.accepted = true
    }

    function getPowerBarColor(index, totalBars) {
        let stats = appWindow.getDriveModeStats()
        let loadFactor = appWindow.currentSpeed / stats.topSpeed
        let barPosition = index / totalBars
        if (barPosition > loadFactor) return "#1A2A2A"
        if (loadFactor < 0.6) return "#00FF99"
        if (loadFactor < 0.85) return "#FFFF00"
        return "#FF3333"
    }

    Component.onCompleted: {
        forceActiveFocus()
        appWindow.currentTimeLabel = currentTimeLabel
        appWindow.currentDateLabel = currentDateLabel
    }
}
