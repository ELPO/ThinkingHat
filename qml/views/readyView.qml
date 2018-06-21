import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

Item
{
    ColumnLayout {

		anchors.fill: parent

        Item {
            width: parent.width
            height: 30
        }

        Text {
            text: "Ready to play!"
            anchors.horizontalCenter: parent.horizontalCenter

            font.family: appTheme.fontFamily
            font.pixelSize: 18
            color: "gray"
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            width: parent.width
            height: 50
        }

		Rectangle {
			anchors.horizontalCenter: parent.horizontalCenter
            width: 120
            height: 120
			radius: width / 2.0
            color: "white"
            border.color: "gray"
            border.width: 2

            Image {
                anchors.centerIn: parent
                width: parent.width / 1.6
                height: parent.height / 1.6

                source: appGlobal.avatar
            }
		}

		Text {
			text: appGlobal.userName
			anchors.horizontalCenter: parent.horizontalCenter

            font.family: appTheme.fontFamily
            font.pixelSize: 18
            color: "black"
            horizontalAlignment: Text.AlignHCenter
            font.bold: true
		}

		Text {
            text: appGlobal.userAge + " years old"
			anchors.horizontalCenter: parent.horizontalCenter

            font.family: appTheme.fontFamily
            font.pixelSize: 16
            color: "black"
            horizontalAlignment: Text.AlignHCenter
		}

        Item{
            width: parent.width
            Layout.fillHeight: true
        }

        Button {
            id: control

            text: "Let's solve problems now!"
            font.family: appTheme.fontFamily
            font.pixelSize: 14

            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                stackView.push("problemBoardView.qml")
            }

            background: Rectangle {
                color: "black"
                radius: width / 3.2
            }

            contentItem: Text {
                text: control.text
                font: control.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }


        Item {
            width: parent.width
            height: 30
        }
	}
}
