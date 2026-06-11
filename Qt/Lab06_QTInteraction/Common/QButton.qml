import QtQuick 2.15
import QtQuick.Controls 2.15

Rectangle {
    id: root
    width: 110
    height: 36
    radius: 8
    property alias text: label.text
    property bool on: false
    signal toggled(bool onState)
    signal clicked()        // ✅ THÊM DÒNG NÀY

    color: root.on ? "#2196F3" : "#666"
    border.color: "#333"

    Text {
        id: label
        anchors.centerIn: parent
        color: "white"
        font.bold: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.on = !root.on
            root.toggled(root.on)
            root.clicked()   // ✅ THÊM DÒNG NÀY
        }
    }
}
