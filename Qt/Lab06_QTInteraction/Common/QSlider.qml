import QtQuick 2.15

Item {
    id: rootItem
    width: widthProgressBar
    height: heightProgressBar

    property int widthProgressBar: 0
    property int heightProgressBar: 0
    property int sizePoint: 0
    property int positionPoint: 0
    property string colorBackground: "transparent"
    property string colorTimeLine: "transparent"
    property string colorPoint: "transparent"

    signal clicked()
    signal positionChanged()
    signal exited()

    Rectangle {
        id: bgProgressBarID
        anchors.fill: parent
        color: rootItem.colorBackground
        radius: parent.width/2
        border.width: 1
        border.color: rootItem.colorTimeLine

        Rectangle{
            id: bgTimeLineID
            width: rootItem.positionPoint
            height: bgProgressBarID.height
            color: rootItem.colorTimeLine
            radius: height/2
        }

        Rectangle {
            id: pointProgressBarID
            width: rootItem.sizePoint
            height: rootItem.sizePoint
            radius: rootItem.sizePoint/2
            color: rootItem.colorPoint
            x: rootItem.positionPoint - width/2
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {
            positionPoint = mouse.x
            rootItem.clicked()
        }

        onPositionChanged: {
            let checkPosition = mouse.x
            if(checkPosition > rootItem.width) checkPosition = rootItem.width
            if(checkPosition < 0) checkPosition = 0
            positionPoint = checkPosition

            rootItem.positionChanged()
        }


        onExited: {
            rootItem.exited()
        }
    }
}
