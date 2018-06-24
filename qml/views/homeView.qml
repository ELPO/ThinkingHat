import QtQuick 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Layouts 1.3

Item
{
    Video {
        id: intro

        anchors.fill: parent
        source: "../../resources/intro.3gp" // "../../resources/intro.avi"
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
            fillMode: Image.PreserveAspectFit
            mipmap: true
            source: "../../resources/mainHat.png"
        }

        Item {
            width: parent.width
            height: 100
        }

        Text {
            id: introText

            horizontalAlignment: Text.AlignHCenter
            Layout.fillHeight: true

            visible: false
            text: "ThinkingHat is a game created to help kids learning problem-solving skills for maths and beyond."
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: appTheme.fontFamily
            font.pixelSize: 21
            color: "black"
            Layout.preferredWidth: parent.width - appTheme.margin * 2 //to do scale
            wrapMode: Text.Wrap
        }

        Button {
            id: introButton

            anchors.horizontalCenter: parent.horizontalCenter

            text: "Next"
            visible: false
            font.family: appTheme.fontFamily
            font.pixelSize: 14

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
