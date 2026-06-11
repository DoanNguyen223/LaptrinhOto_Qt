import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item {
    id: root
    width: 550
    height: 550

    property real value: 0
    property real minimumValue: 0
    property real maximumValue: 250
    property string gaugeLabel: "KM/H"
    property bool accelerating: false

    readonly property real safeValue: Math.max(minimumValue, Math.min(maximumValue, value))
    readonly property real startAngle: -140
    readonly property real endAngle: 140
    readonly property real rangeAngle: endAngle - startAngle
    readonly property real needleAngle: startAngle + (rangeAngle * (safeValue - minimumValue) / (maximumValue - minimumValue))
    readonly property real radiusVal: width / 2

    property int totalMajorTicks: 11
    property int tickMargin: 40

    // ===== Background =====
    Rectangle {
        anchors.fill: parent
        radius: root.radiusVal
        color: "#080808"
        border.color: "#222"
        border.width: 2
        antialiasing: true
    }

    // ===== Tickmarks =====
    Repeater {
        model: root.totalMajorTicks
        delegate: Item {
            anchors.centerIn: parent
            property real angle: root.startAngle + index * (root.rangeAngle / (root.totalMajorTicks - 1))
            property real tickRadius: root.radiusVal - root.tickMargin

            // Vạch chia lớn
            Rectangle {
                width: 6
                height: 25
                radius: 3
                color: safeValue / maximumValue > 0.85 && index >= totalMajorTicks*0.85 ? "#FF3333" : "white"
                anchors.centerIn: parent
                x: tickRadius * Math.cos((angle - 90) * Math.PI/180)
                y: tickRadius * Math.sin((angle - 90) * Math.PI/180)
                antialiasing: true
                transform: Rotation {
                    origin.x: width/2
                    origin.y: 0
                    angle: angle
                }
            }

            // Số hiển thị
            Text {
                text: (index*(maximumValue/(totalMajorTicks-1))).toFixed(0)
                font.pixelSize: 24
                font.bold: true
                color: safeValue / maximumValue > 0.85 && index >= totalMajorTicks*0.85 ? "#FF3333" : "white"
                anchors.centerIn: parent
                x: (tickRadius - 45) * Math.cos((angle - 90) * Math.PI/180)
                y: (tickRadius - 45) * Math.sin((angle - 90) * Math.PI/180)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                antialiasing: true
            }
        }
    }

    // ===== Progress Arc =====
    Canvas {
        id: progressCanvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            var center = width/2
            var radius = width/2 - tickMargin
            var start = (root.startAngle-90)*Math.PI/180
            var end = (root.needleAngle-90)*Math.PI/180

            var ratio = safeValue / maximumValue
            var grad = ctx.createLinearGradient(0,0,width,0)
            if (ratio < 0.6) {
                grad.addColorStop(0,"#00FFFF")
                grad.addColorStop(1,"#00FF99")
            } else if (ratio < 0.85) {
                grad.addColorStop(0,"#00FFFF")
                grad.addColorStop(0.5,"#FFFF00")
                grad.addColorStop(1,"#FFA500")
            } else {
                grad.addColorStop(0,"#FFFF00")
                grad.addColorStop(0.6,"#FF6600")
                grad.addColorStop(1,"#FF0088")
            }

            ctx.beginPath()
            ctx.arc(center, center, radius, start, end)
            ctx.lineWidth = 15
            ctx.strokeStyle = grad
            ctx.lineCap = "round"
            ctx.shadowBlur = 15
            ctx.shadowColor = grad
            ctx.stroke()
        }

        property bool needsRepaint: false
        Timer {
            interval: 33
            running: true
            repeat: true
            onTriggered: {
                if (progressCanvas.needsRepaint) {
                    progressCanvas.requestPaint()
                    progressCanvas.needsRepaint = false
                }
            }
        }

        Connections {
            target: root
            function onValueChanged() {
                progressCanvas.needsRepaint = true
            }
        }
    }

    // ===== Needle =====
    Item {
        anchors.fill: parent
        rotation: root.needleAngle
        Behavior on rotation { SpringAnimation { spring: 2.5; damping: 0.25; epsilon: 0.5 } }

        Rectangle {
            width: 10
            height: root.height/2 - 40
            anchors.horizontalCenter: parent.horizontalCenter
            y: 40
            radius: 5
            gradient: Gradient {
                GradientStop { position: 0; color: "#00FF99" }
                GradientStop { position: 0.5; color: "#FFFF00" }
                GradientStop { position: 1; color: "#FF0088" }
            }
            antialiasing: true
        }

        Canvas {
            width: 20
            height: 20
            anchors.horizontalCenter: parent.horizontalCenter
            y: 30
            antialiasing: true
            onPaint: {
                var ctx = getContext("2d")
                ctx.reset()
                ctx.beginPath()
                ctx.moveTo(10,0)
                ctx.lineTo(0,20)
                ctx.lineTo(20,20)
                ctx.closePath()
                ctx.fillStyle = "#FF0088"
                ctx.fill()
            }
        }
    }

    // ===== Center info =====
    Column {
        anchors.centerIn: parent
        spacing: -5

        Text {
            text: Math.round(safeValue)
            font.pixelSize: 100
            font.bold: true
            color: accelerating ? "#FF0088" : (safeValue / maximumValue > 0.85 ? "#FF3333" : "#00FFFF")
            font.family: "Arial"
            horizontalAlignment: Text.AlignHCenter
            antialiasing: true
            scale: accelerating ? 1.05 : 1.0
            Behavior on scale { NumberAnimation { duration: 200 } }
            Behavior on color { ColorAnimation { duration: 300 } }
        }

        Text {
            text: gaugeLabel
            font.pixelSize: 24
            color: "#00FFFF"
            font.bold: true
            font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter
            antialiasing: true
        }

        Text {
            text: "(" + Math.round(safeValue*0.621371) + " MPH)"
            font.pixelSize: 16
            color: "#888"
            font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter
            visible: gaugeLabel === "KM/H"
        }
    }

    // ===== Speed warning =====
    Rectangle {
        visible: safeValue > maximumValue*0.85
        width: 140
        height: 40
        radius: 20
        color: "#FF3333"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: "⚠ HIGH SPEED"
            color: "white"
            font.pixelSize: 16
            font.bold: true
            anchors.centerIn: parent
            font.family: "Arial"
        }

        SequentialAnimation on opacity {
            loops: Animation.Infinite
            running: safeValue > maximumValue*0.85
            NumberAnimation { to: 0.5; duration: 500 }
            NumberAnimation { to: 1.0; duration: 500 }
        }
    }
}
