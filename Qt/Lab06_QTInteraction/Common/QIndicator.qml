import QtQuick 2.15

Rectangle {
    id: root
    width: 220
    height: 220
    color: "transparent"

    // góc quay (đơn vị độ)
    property real angle: 0

    // kim (needle) — quay quanh đáy
    Rectangle {
        id: needle
        width: 4
        height: root.height * 0.48
        color: "red"
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter
        x: root.width/2 - width/2
        y: root.height*0.6 - height
        transformOrigin: Item.Bottom
        rotation: root.angle
    }

    // tâm che
    Rectangle {
        width: 18; height: 18; radius: 9
        color: "#111"
        anchors.horizontalCenter: parent.horizontalCenter
        y: root.height*0.6 - 9
    }
}
