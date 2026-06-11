import QtQuick 6.5
import QtQuick.Controls 6.5
import QtQuick.Layouts 6.5

Item {
    id: root
    width: 220
    height: 220

    property real value: 0
    property real minValue: 0
    property real maxValue: 100
    property string title: "Battery"
    property color colorStart: "#00FF00"
    property color colorEnd: "#FFFF00"

    readonly property real safeValue: Math.max(minValue, Math.min(maxValue, value))
    readonly property real startAngle: -140
    readonly property real endAngle: 140
    readonly property real rangeAngle: endAngle - startAngle
    readonly property real needleAngle: startAngle + (rangeAngle * (safeValue - minValue) / (maxValue - minValue))
    readonly property real radiusVal: width / 2

    property int totalMajorTicks: 5
    property int tickMargin: 25

    // Background circle
    Rectangle {
        anchors.fill: parent
        radius: root.radiusVal
        color: "#111"
        border.color: "#444"
        border.width: 2
        opacity: 0.6
    }

    // Only major ticks and labels
    Repeater {
        model: root.totalMajorTicks
        delegate: Item {
            anchors.centerIn: parent
            property real angle: root.startAngle + index * (root.rangeAngle / (root.totalMajorTicks - 1))
            property real tickRadius: root.radiusVal - root.tickMargin
            property real tickLength: 18

            // Tick mark
            Rectangle {
                width: 4
                height: tickLength
                color: "white"
                anchors.centerIn: parent
                x: tickRadius * Math.cos((angle - 90) * Math.PI/180)
                y: tickRadius * Math.sin((angle - 90) * Math.PI/180)
                transform: Rotation { origin.x: width/2; origin.y: 0; angle: angle }
                antialiasing: true
            }

            // Tick label
            Text {
                text: Math.round(index * (maxValue / (totalMajorTicks - 1))).toString() + "%"
                font.pixelSize: 18
                font.bold: true
                color: "white"
                anchors.centerIn: parent
                property real labelRadius: tickRadius - tickLength - 8
                x: labelRadius * Math.cos((angle - 90) * Math.PI/180)
                y: labelRadius * Math.sin((angle - 90) * Math.PI/180)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                antialiasing: true
            }
        }
    }

    // Progress arc
    Canvas {
        id: progressCanvas
        anchors.fill: parent
        property real _paintValue: root.safeValue
        on_PaintValueChanged: requestPaint()

        onPaint: {
            var ctx = getContext("2d"); ctx.reset()
            var cx = width/2; var cy = height/2; var r = width/2 - root.tickMargin
            var startRad = (root.startAngle - 90) * Math.PI/180
            var ratio = (root.safeValue - root.minValue)/(root.maxValue - root.minValue)
            var endRad = startRad + (root.rangeAngle * Math.PI/180) * ratio

            var grad = ctx.createLinearGradient(0,0,width,0)
            grad.addColorStop(0, root.colorStart)
            grad.addColorStop(1, root.colorEnd)

            ctx.beginPath()
            ctx.arc(cx, cy, r, startRad, endRad, false)
            ctx.lineWidth = 10
            ctx.strokeStyle = grad
            ctx.lineCap = "round"
            ctx.stroke()
        }
        onWidthChanged: requestPaint()
        onHeightChanged: requestPaint()
    }

    // Needle
    Item {
        anchors.fill: parent
        rotation: root.needleAngle
        Behavior on rotation { SpringAnimation { spring: 2; damping: 0.25; epsilon: 0.2 } }

        Rectangle {
            width: 4
            height: root.radiusVal - 60
            color: root.colorEnd
            anchors.horizontalCenter: parent.horizontalCenter
            y: 50
            radius: 2
        }

        Rectangle {
            width: 16
            height:16
            radius:8
            color:"#111"
            border.color:"white"
            anchors.centerIn: parent
        }
    }

    // Center info
    Column {
        anchors.centerIn: parent
        spacing: 6
        Text {
            text: Math.round(root.safeValue) + "%"
            font.pixelSize: 60
            font.bold: true
            color: "#00FFFF"
             font.family: "Arial"
            anchors.horizontalCenter: parent.horizontalCenter

        }
        Text {
            text: root.title
            font.pixelSize: 24
            font.bold: true
            color: "#00FFFF"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
