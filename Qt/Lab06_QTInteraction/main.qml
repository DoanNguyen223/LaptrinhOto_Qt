import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root
    width: 1000
    height: 600
    visible: true
    title: qsTr("Car Dashboard")

    Item {
        id: dashBoard
        width : parent.width
        height: 450
        anchors.top : parent.top

        Image {
            anchors.fill: parent
            source: "qrc:/new/prefix1/img/Panel.png"
            fillMode: Image.PreserveAspectCrop
        }

        Item {
            id: tachometer
            width: 390
            height: 390
            anchors.left: parent.left
            anchors.leftMargin: 40
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                source: "qrc:/new/prefix1/img/Tacometer.png"
            }

            Item {
                id : qIndicatorEcho
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                transformOrigin: Item.Center
                // rotation lấy từ C++ (dashboardController.tachoAngle). Nếu controller null -> giữ -120
                rotation: dashboardController ? dashboardController.tachoAngle : -120

                Rectangle {
                    width: 4
                    height: parent.height / 3
                    radius: 2
                    color: "red"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -height / 2 + 10
                }

                Canvas {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    y: -tachometer.height / 2.2 - 5
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.beginPath()
                        ctx.moveTo(width/2, 0)
                        ctx.lineTo(width, height)
                        ctx.lineTo(0, height)
                        ctx.closePath()
                        ctx.fillStyle = "red"
                        ctx.fill()
                    }
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: "black"
                    border.color: "white"
                    border.width: 2
                    anchors.centerIn: parent
                }
            }
        }

        Item {
            id: speedometer
            width: 340
            height: 340
            anchors.right: parent.right
            anchors.rightMargin: 55
            anchors.verticalCenter: parent.verticalCenter

            Image {
                anchors.fill: parent
                source: "qrc:/new/prefix1/img/Speedometer.png"
            }

            Item {
                id: qIndicatorSpeed
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                transformOrigin: Item.Center
                rotation: dashboardController ? dashboardController.speedAngle : -120

                Rectangle {
                    width: 4
                    height: parent.height / 3
                    radius: 2
                    color: "#00ccff"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.verticalCenterOffset: -height / 2 + 10
                }

                Canvas {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    y: -speedometer.height / 2.3 - 5
                    onPaint: {
                        var ctx = getContext("2d")
                        ctx.clearRect(0, 0, width, height)
                        ctx.beginPath()
                        ctx.moveTo(width/2, 0)
                        ctx.lineTo(width, height)
                        ctx.lineTo(0, height)
                        ctx.closePath()
                        ctx.fillStyle = "#00ccff"
                        ctx.fill()
                    }
                }

                Rectangle {
                    width: 18
                    height: 18
                    radius: 9
                    color: "black"
                    border.color: "white"
                    border.width: 2
                    anchors.centerIn: parent
                }
            }
        }

        Image {
            id: roadImage
            source: "qrc:/new/prefix1/img/icons/Road/road2.png"
            anchors.centerIn: parent
            width: 300
            height: 300

            Rectangle {
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: 30
                width: 250

                Row {
                    anchors.centerIn: parent
                    spacing: 50

                    Image {
                        source: "qrc:/new/prefix1/img/icons/Road/Frame 33.png"
                        width: 40
                        height: 40
                        smooth: true
                    }

                    Row {
                        spacing: 6
                        Image {
                            source: "qrc:/new/prefix1/img/icons/Road/mdi_turn-right-bold.svg"
                            width: 40
                            height: 40
                            smooth: true
                        }

                        Column {
                            spacing: 2
                            Text {
                                text: "372 m"
                                color: "white"
                                font.pixelSize: 15
                                font.bold: true
                            }
                            Text {
                                text: "123456"
                                color: "#00CCFF"
                                font.pixelSize: 12
                            }
                        }
                    }

                    Image {
                        source: "qrc:/new/prefix1/img/icons/Road/mingcute_steering-wheel-fill.svg"
                        width: 40
                        height: 40
                        smooth: true
                    }
                }
            }

            Image {
                source:"qrc:/new/prefix1/img/icons/Road/car.png"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: 20
                anchors.bottomMargin: 70
                width: 50
                height: 50
            }

            Image {
                source:"qrc:/new/prefix1/img/icons/Road/car.png"
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: -15
                anchors.bottomMargin: 180
                width: 30
                height: 30
            }
        }

        Row {
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.rightMargin: 10
            spacing: 8
            z: 4

            Item { width: 30; height: 30; y: 0
                Image {  id: rightBlink; anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/icon-park-solid_right-two.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 10
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/mdi_seatbelt.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 30
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/mdi_car-brake-parking.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 55
                Image { id: hiBeamIcon; anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/mdi_car-light-dimmed.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 90
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/mdi_car-light-high.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 120
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-right-checked/mdi_car-light-fog.svg"; width: 30; height: 30 }
            }
        }

        Row {
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.topMargin: 40
            anchors.leftMargin: 10
            spacing: 8
            z: 4

            Item { width: 30; height: 30; y: 120
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/ph_engine-bold.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 90
                Image { id: batteryIcon; anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/mdi_car-battery.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 55
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/mdi_car-handbrake.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 30
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/mdi_car-tire-alert.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 10
                Image { id: oilIcon; anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/mdi_oil.svg"; width: 30; height: 30 }
            }
            Item { width: 30; height: 30; y: 0
                Image { id: leftBlink; anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/icons-left-checked/icon-park-solid_right-two.svg"; width: 30; height: 30 }
            }
        }

        Column {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.leftMargin: 20
            spacing: 8

            Item {
                width: 30; height: 30
                anchors.left: parent.left
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/feaul.svg"; width: 30; height: 30 }
            }
            Item {
                width: 200; height: 150
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/new/prefix1/img/icons/left.svg"
                    width: 200; height: 150
                }
            }
        }

        Column {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            anchors.rightMargin: 20
            spacing: 8

            Item {
                width: 30; height: 30
                anchors.right: parent.right
                Image { anchors.centerIn: parent; source: "qrc:/new/prefix1/img/icons/desal.svg"; width: 30; height: 30 }
            }
            Item {
                width: 200; height: 150
                Image {
                    anchors.centerIn: parent
                    source: "qrc:/new/prefix1/img/icons/right.svg"
                    width: 200; height: 150
                }
            }
        }

        Image {
            source: "qrc:/new/prefix1/img/icons/bottom.png"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 0
            width: 500
            height: 70
        }

        Row {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 40
            spacing: 50

            Image {
                source: "qrc:/new/prefix1/img/Top Bar.png"
                anchors.centerIn: parent
                width: 500
                height: 70

                Image {
                    source: "qrc:/new/prefix1/img/icons/cloud.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.verticalCenter: parent.verticalCenter
                    width: 20
                    height: 20
                }

                Text {
                    text: "36°C"
                    color: "white"
                    font.pixelSize: 16
                    anchors.left: parent.left
                    anchors.leftMargin: 65
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "12:36 AM"
                    color: "white"
                    font.pixelSize: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }

    Item {
        id : controllers
        width : parent.width
        height: 150
        anchors.bottom : parent.bottom

        Row {
            id: controlButtons
            anchors.centerIn: parent
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            Repeater {
                model: [
                    { text: "Turn-Left", color: "#5dade2" },
                    { text: "Turn-Right", color: "#5dade2" },
                    { text: "Hi-Beam", color: "#5dade2" },
                    { text: "Engine Oil", color: "#5dade2" },
                    { text: "Battery", color: "#5dade2" }
                ]
                delegate: Rectangle {
                    id: btn
                    width: 100
                    height: 40
                    radius: 10
                    color: modelData.color
                    property bool active: false

                    Text {
                        anchors.centerIn: parent
                        text: modelData.text
                        color: "white"
                        font.bold: true
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            dashboardController.toggleButtonState(modelData.text)
                        }
                    }

                    Connections {
                        target: dashboardController
                        function onButtonStateChanged(name, state) {
                            if (name === modelData.text) {
                                btn.color = state ? "#2ecc71" : modelData.color
                                btn.active = state
                            }

                            if (name === "Turn-Left") {
                                leftBlinkBlink.running = state
                                leftBlink.opacity = state ? leftBlink.opacity : 1
                            }
                            if (name === "Turn-Right") {
                                rightBlinkBlink.running = state
                                rightBlink.opacity = state ? rightBlink.opacity : 1
                            }
                            if (name === "Hi-Beam") {
                                hiBeamBlink.running = state
                                hiBeamIcon.opacity = state ? hiBeamIcon.opacity : 1
                            }
                            if (name === "Engine Oil") {
                                oilBlink.running = state
                                oilIcon.opacity = state ? oilIcon.opacity : 1
                            }
                            if (name === "Battery") {
                                batteryBlink.running = state
                                batteryIcon.opacity = state ? batteryIcon.opacity : 1
                            }
                        }
                    }
                }
            }
        }

        Row {
            id: slidersRow
            anchors.bottom: controlButtons.top
            anchors.bottomMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 120

            Loader {
                id: loaderTacho
                source: "qrc:/new/prefix1/Common/QSlider.qml"
                onLoaded: {
                    if (item) {
                        item.widthProgressBar = 200
                        item.heightProgressBar = 10
                        item.sizePoint = 20
                        item.colorBackground = "#202020"
                        item.colorTimeLine = "#ffaa00"
                        item.colorPoint = "yellow"
                        if (item.hasOwnProperty("positionPoint")) item.positionPoint = 100
                    }
                }
            }

            Connections {
                target: loaderTacho.item
                function onPositionPointChanged() {
                    if (loaderTacho.item && dashboardController) {
                        dashboardController.updateTachoValue(loaderTacho.item.positionPoint)
                    }
                }
            }

            Loader {
                id: loaderSpeed
                source: "qrc:/new/prefix1/Common/QSlider.qml"
                onLoaded: {
                    if (item) {
                        item.widthProgressBar = 200
                        item.heightProgressBar = 10
                        item.sizePoint = 20
                        item.colorBackground = "#202020"
                        item.colorTimeLine = "#00aaff"
                        item.colorPoint = "cyan"
                        if (item.hasOwnProperty("positionPoint")) item.positionPoint = 150
                    }
                }
            }

            Connections {
                target: loaderSpeed.item
                function onPositionPointChanged() {
                    if (loaderSpeed.item && dashboardController) {
                        dashboardController.updateSpeedValue(loaderSpeed.item.positionPoint)
                    }
                }
            }
        }
    }

    SequentialAnimation {
        id: leftBlinkBlink
        loops: Animation.Infinite
        running: false
        PropertyAnimation { target: leftBlink; property: "opacity"; from: 1; to: 0; duration: 300 }
        PropertyAnimation { target: leftBlink; property: "opacity"; from: 0; to: 1; duration: 300 }
    }

    SequentialAnimation {
        id: rightBlinkBlink
        loops: Animation.Infinite
        running: false
        PropertyAnimation { target: rightBlink; property: "opacity"; from: 1; to: 0; duration: 300 }
        PropertyAnimation { target: rightBlink; property: "opacity"; from: 0; to: 1; duration: 300 }
    }
    SequentialAnimation {
        id: hiBeamBlink
        loops: Animation.Infinite
        running: false
        PropertyAnimation { target: hiBeamIcon; property: "opacity"; from: 1; to: 0; duration: 300 }
        PropertyAnimation { target: hiBeamIcon; property: "opacity"; from: 0; to: 1; duration: 300 }
    }

    SequentialAnimation {
        id: oilBlink
        loops: Animation.Infinite
        running: false
        PropertyAnimation { target: oilIcon; property: "opacity"; from: 1; to: 0; duration: 400 }
        PropertyAnimation { target: oilIcon; property: "opacity"; from: 0; to: 1; duration: 400 }
    }

    SequentialAnimation {
        id: batteryBlink
        loops: Animation.Infinite
        running: false
        PropertyAnimation { target: batteryIcon; property: "opacity"; from: 1; to: 0; duration: 400 }
        PropertyAnimation { target: batteryIcon; property: "opacity"; from: 0; to: 1; duration: 400 }
    }


    Connections {
        target: dashboardController
        function onButtonStateChanged(name, state) {
            console.log("C++ -> QML buttonStateChanged:", name, state)
        }
    }
}
