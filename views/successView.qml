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

        Image {
            id: trophy

            anchors.horizontalCenter: parent.horizontalCenter
            width: 0
            height: 0
            fillMode: Image.PreserveAspectCrop

            source: "../resources/trophy.png"


            NumberAnimation on width {
                from: 0
                to: 250

                duration: 800
            }

            NumberAnimation on height{
                from: 0
                to: 250

                duration: 800

                onStopped: {
                    congratulaText.visible = true
                }
            }

            NumberAnimation on rotation{
                from: 0
                to: 360

                duration: 800
            }
        }

        Item {
            width: parent.width
            height: 30
        }

		Text {
            id: congratulaText

            visible: false
            text: "Bravo " + appGlobal.userName + ", you nailed it!"
			anchors.horizontalCenter: parent.horizontalCenter

            font.family: "Droid Sans Mono"
            font.pointSize: 20
            color: "black"
            horizontalAlignment: Text.AlignHCenter
		}

        Item{
            width: parent.width
            Layout.fillHeight: true
        }

        RowLayout {

            width: parent.width

            Item {
                Layout.fillWidth: true
                height: parent.height
            }

            Button {
                id: continueBtn

                text: "Continue Playing"
                font.family: "Droid Sans Mono"
                font.pointSize: 14

                onClicked: {
                    stackView.push("problemBoardView.qml")
                }

                background: Rectangle {
                    color: "black"
                    radius: width / 3.2
                }

                contentItem: Text {
                    text: continueBtn.text
                    font: continueBtn.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }

            Item {
                width: 30
                height: parent.height
            }

            Button {
                id: exitBtn

                text: "Exit"
                font.family: "Droid Sans Mono"
                font.pointSize: 14

                onClicked: {
                    Qt.quit()
                }

                background: Rectangle {
                    color: "black"
                    radius: width / 3.2
                }

                contentItem: Text {
                    text: exitBtn.text
                    font: exitBtn.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }

            Item {
                Layout.fillWidth: true
                height: parent.height
            }
        }


        Item {
            width: parent.width
            height: 30
        }
	}
}
