import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 1000
    height: 450
    visible: true
    title: qsTr("Car Dashboard")

    Image {
        anchors.fill: parent
        source: "qrc:/new/img/img/Panel.png"
        fillMode: Image.PreserveAspectCrop
    }

    // ===== Đồng hồ vòng tua (trái) =====
    Item {
        id: tachometer
        width: 390
        height: 390
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.verticalCenter: parent.verticalCenter

        // Ảnh mặt đồng hồ
        Image {
            anchors.fill: parent
            source: "qrc:/new/img/img/Tacometer.png"
        }

        // Kim vòng tua
        Item {
            id: rpmNeedle
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            transformOrigin: Item.Center
            rotation: -120

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

    // ===== Đồng hồ tốc độ (phải) =====
    Item {
        id: speedometer
        width: 340
        height: 340
        anchors.right: parent.right
        anchors.rightMargin: 55
        anchors.verticalCenter: parent.verticalCenter

        // Ảnh mặt đồng hồ
        Image {
            anchors.fill: parent
            source: "qrc:/new/img/img/Speedometer.png"
        }

        // Kim tốc độ
        Item {
            id: speedNeedle
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            transformOrigin: Item.Center
            rotation: -120

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

    // ===== Phần giữa: road, xe, thông tin đường =====
    Image {
        source: "qrc:/new/Road/img/icons/Road/road2.png"
        anchors.centerIn: parent
        width: 300
        height: 300

        Rectangle {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 30
            width: 250
            color: "transparent" // Make rectangle invisible

            Row {
                anchors.centerIn: parent
                spacing: 50

                Image {
                    source: "qrc:/new/Road/img/icons/Road/Frame 33.png"
                    width: 40
                    height: 40
                    smooth: true
                }

                Row {
                    spacing: 6
                    Image {
                        source: "qrc:/new/Road/img/icons/Road/mdi_turn-right-bold.svg"
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
                    source: "qrc:/new/Road/img/icons/Road/mingcute_steering-wheel-fill.svg"
                    width: 40
                    height: 40
                    smooth: true
                }
            }
        }

        Image {
            source:"qrc:/new/Road/img/icons/Road/car.png"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 20
            anchors.bottomMargin: 70
            width: 50
            height: 50
        }

        Image {
            source:"qrc:/new/Road/img/icons/Road/car.png"
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: -15
            anchors.bottomMargin: 180
            width: 30
            height: 30
        }
    }

    // --- Đèn cảnh báo bên phải ---
    Row {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.rightMargin: 10
        spacing: 8
        z: 4
        // Icon 1
        Item { width: 30; height: 30; y: 0; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/icon-park-solid_right-two.svg"; width: 30; height: 30 } }
        // Icon 2
        Item { width: 30; height: 30; y: 10; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/mdi_seatbelt.svg"; width: 30; height: 30 } }
        // Icon 3
        Item { width: 30; height: 30; y: 30; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/mdi_car-brake-parking.svg"; width: 30; height: 30 } }
        // Icon 4
        Item { width: 30; height: 30; y: 55; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/mdi_car-light-dimmed.svg"; width: 30; height: 30 } }
        // Icon 5
        Item { width: 30; height: 30; y: 90; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/mdi_car-light-high.svg"; width: 30; height: 30 } }
        // Icon 6
        Item { width: 30; height: 30; y: 120; Image { anchors.centerIn: parent; source: "qrc:/new/icons-right-checked/img/icons/icons-right-checked/mdi_car-light-fog.svg"; width: 30; height: 30 } }
    }

    // --- Đèn cảnh báo bên trái ---
    Row {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 40
        anchors.leftMargin: 10
        spacing: 8
        z: 4
        // Icon 1
        Item { width: 30; height: 30; y: 120; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/ph_engine-bold.svg"; width: 30; height: 30 } }
        // Icon 2
        Item { width: 30; height: 30; y: 90; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/mdi_car-battery.svg"; width: 30; height: 30 } }
        // Icon 3
        Item { width: 30; height: 30; y: 55; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/mdi_car-handbrake.svg"; width: 30; height: 30 } }
        // Icon 4
        Item { width: 30; height: 30; y: 30; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/mdi_car-tire-alert.svg"; width: 30; height: 30 } }
        // Icon 5
        Item { width: 30; height: 30; y: 10; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/mdi_oil.svg"; width: 30; height: 30 } }
        // Icon 6
        Item { width: 30; height: 30; y: 0; Image { anchors.centerIn: parent; source: "qrc:/new/icons-left-checked/img/icons/icons-left-checked/icon-park-solid_right-two.svg"; width: 30; height: 30 } }
    }

    // --- Mức Xăng Trái (Fuel) ---
    Column {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.leftMargin: 20
        spacing: 8

        Item {
            width: 30; height: 30
            anchors.left: parent.left
            Image { anchors.centerIn: parent; source: "qrc:/new/icons/img/icons/feaul.svg"; width: 30; height: 30 }
        }
        Item {
            width: 200; height: 150
            Image { anchors.centerIn: parent; source: "qrc:/new/icons/img/icons/left.svg"; width: 200; height: 150 }
        }
    }

    // --- Mức Nhiệt độ Phải (Temp) ---
    Column {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.rightMargin: 20
        spacing: 8

        Item {
            width: 30; height: 30
            anchors.right: parent.right
            Image { anchors.centerIn: parent; source: "qrc:/new/icons/img/icons/desal.svg"; width: 30; height: 30 }
        }
        Item {
            width: 200; height: 150
            Image { anchors.centerIn: parent; source: "qrc:/new/icons/img/icons/right.svg"; width: 200; height: 150 }
        }
    }

    // --- Bottom Bar ---
    Image {
        source: "qrc:/new/icons/img/icons/bottom.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
        width: 500
        height: 70
    }

    // --- Văn bản thông tin ở trên (Nhiệt độ/Thời gian) ---
    Row {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 40
        spacing: 50

        Image {
            source: "qrc:/new/img/img/Top Bar.png"
            anchors.centerIn: parent
            width: 500
            height: 70

            // Cloud Icon
            Image {
                source: "qrc:/new/icons/img/icons/cloud.svg"
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                width: 20
                height: 20
            }

            // Nhiệt độ
            Text {
                text: "12°C"
                color: "white"
                font.pixelSize: 16
                anchors.left: parent.left
                anchors.leftMargin: 65
                anchors.verticalCenter: parent.verticalCenter
            }

            // Thời gian
            Text {
                text: "12:14 AM"
                color: "white"
                font.pixelSize: 16
                anchors.right: parent.right
                anchors.rightMargin: 40
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    // ===== Kim xoay động =====
    property real rpmValue: 0
    property real speedValue: 0

    Timer {
        interval: 50
        running: true
        repeat: true
        onTriggered: {
            rpmValue = (rpmValue + 1) % 180
            speedValue = (speedValue + 2) % 180
            rpmNeedle.rotation = -120 + rpmValue * 1.4
            speedNeedle.rotation = -120 + speedValue * 1.4
        }
    }
}
