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
            text: "Set up your profile"
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

		Text {
			text: "Choose an avatar"
			anchors.horizontalCenter: parent.horizontalCenter

            font.family: appTheme.fontFamily
            font.pixelSize: 18
            color: "black"
            horizontalAlignment: Text.AlignHCenter
		}

		ListView {
			id: characterList

			property int itemSize: 50
			property int numItems: 4

			anchors.horizontalCenter: parent.horizontalCenter
			height: itemSize + 10
			width: itemSize * numItems + (spacing * (numItems - 1)) + (currentIndex != -1 ? 10 : 0)

			orientation: Qt.Horizontal
			model: numItems
			spacing: 20
			currentIndex: -1
			interactive: false

			delegate: Rectangle {
				property bool selected: characterList.currentIndex === index
				anchors.verticalCenter: parent.verticalCenter

                color: "white"
				width: characterList.itemSize + (selected ? 10 : 0)
				height: characterList.itemSize + (selected ? 10 : 0)
				radius: width / 2.0
                border.color: characterList.currentIndex === index ? "black" : "gray"
                border.width: 1

                Image {
                    //mipmap: true
                    anchors.centerIn: parent
                    width: parent.width / 1.6
                    height: parent.height / 1.6

                    source: {
                        if (index === 0)
                            return "../resources/avatars/001.png"
                        else if (index === 1)
                            return "../resources/avatars/002.png"
                        else if (index === 2)
                            return "../resources/avatars/003.png"
                        else if (index === 3)
                            return "../resources/avatars/004.png"
                    }
                }

				MouseArea {
					anchors.fill: parent

					onClicked: {
						characterList.currentIndex = index
					}
				}
			}
		}

        Item {
            width: parent.width
            height: 100
        }

		Text {
			text: "Write your username"
			anchors.horizontalCenter: parent.horizontalCenter
            font.family: appTheme.fontFamily
            font.pixelSize: 18
            color: "black"
            horizontalAlignment: Text.AlignHCenter
		}

		TextField {
			id: name

			anchors.horizontalCenter: parent.horizontalCenter

			placeholderText: "-"
			horizontalAlignment : TextInput.AlignHCenter
            font.family: appTheme.fontFamily
            font.pixelSize: 18

            background: Rectangle {
                implicitWidth: 230
                implicitHeight: 30
                border.color: name.focus ? "black" : "gray"
                border.width: name.focus ? 2 : 1
            }
		}

		Text {
			text: "Tell us your age"
			anchors.horizontalCenter: parent.horizontalCenter
            font.family: appTheme.fontFamily
            font.pixelSize: 18
		}

		TextField {
			id: age

			anchors.horizontalCenter: parent.horizontalCenter
			placeholderText: "-"
			horizontalAlignment : TextInput.AlignHCenter
			validator: IntValidator {bottom: 1; top: 150}
            font.family: appTheme.fontFamily
            font.pixelSize: 18

            background: Rectangle {
                implicitWidth: 230
                implicitHeight: 30
                border.color: age.focus ? "black" : "gray"
                border.width: age.focus ? 2 : 1
            }
		}

        Item {
            Layout.fillHeight: true
            width: parent.width
        }

        Button {
            id: nextBtn

            text: "Next"
            font.family: appTheme.fontFamily
            font.pixelSize: 14

            enabled: name.text != "" && age.text != "" && Number.fromLocaleString(age.text) !== 0 && characterList.currentIndex !== -1
            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                appGlobal.userName = name.text
                appGlobal.userAge = Number.fromLocaleString(age.text)

                if (characterList.currentIndex === 0)
                    appGlobal.avatar = "../resources/avatars/001.png"
                else if (characterList.currentIndex === 1)
                    appGlobal.avatar = "../resources/avatars/002.png"
                else if (characterList.currentIndex === 2)
                    appGlobal.avatar = "../resources/avatars/003.png"
                else if (characterList.currentIndex === 3)
                    appGlobal.avatar = "../resources/avatars/004.png"

                stackView.push("readyView.qml")
            }

            background: Rectangle {
                color: nextBtn.enabled ? "black" : "gray"
                radius: width / 3.2
                width: 90
                anchors.horizontalCenter: parent.horizontalCenter
            }

            contentItem: Text {
                    text: nextBtn.text
                    font: nextBtn.font
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
