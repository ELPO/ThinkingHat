import QtQuick 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Layouts 1.3

Item
{

    Video {
        id: intro

        anchors.fill: parent
        source: "../resources/intro.3gp" // "../resources/intro.avi"
        state: "play"

        onStopped: {
            state = "stop"
        }

        states: [
            State{ name: "play" },
            State{ name: "stop"; PropertyChanges { target: intro; opacity: 0 } }
        ]

        onOpacityChanged:{
            if (opacity === 0) {
                intro.visible = false
                introText.visible = true
                introButton.visible = true
                hat.visible = true
            }
        }

        transitions: Transition {
            NumberAnimation {
                property: "opacity";
                easing.type: Easing.Linear;
                duration: 500;
            }
        }
    }

    ColumnLayout {
		anchors.fill: parent

        Item {
            width: parent.width
            height: 100
        }

        Image {
            id: hat

            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            height: 105
            width: 150
            mipmap: true
            source: "../resources/mainHat.png"
        }

        Item {
            width: parent.width
            height: 100
        }

		Text {
            id: introText

            visible: false

            text: "ThinkingHat is a game\ncreated to help kids learning\nproblem-solving skills for\nmaths and beyond."
			anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Droid Sans Mono"
            font.pointSize: 18
            color: "black"
            horizontalAlignment: Text.AlignHCenter
		}

        Item {
            width: parent.width
            Layout.fillHeight: true
        }

        Button {
            id: introButton

            text: "Next"
            visible: false
            font.family: "Droid Sans Mono"
            font.pointSize: 14


            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                stackView.push("characterView.qml")
            }

            background: Rectangle {
                color: "black"
                radius: width / 3.2
                width: 90
                anchors.horizontalCenter: parent.horizontalCenter
            }

            contentItem: Text {
                    text: introButton.text
                    font: introButton.font
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

    Component.onCompleted: intro.play()
}
