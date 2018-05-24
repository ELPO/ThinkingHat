import QtQuick 2.10
import QtQuick.Controls 2.2

Item
{
    property string title: "Challenge"

    Column {

        anchors.fill: parent

        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 80
            height: 80
            radius: width / 2.0
            color: "red"
        }

        Text {
            text: "The Cake"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Level of difficulty:"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Available ThinkingHats Simplify:"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Text {
            text: "Maximun points given:"
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Button {
            text: "Play"
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                stackView.push("theCake.qml")
            }
        }
    }
}
