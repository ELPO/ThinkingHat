import QtQuick 2.10
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.8

Item
{
    ColumnLayout {

        anchors.fill: parent

        Item {
            width: parent.width
            height: 30
        }

        Audio {
            id: audio

            source: "../../../../resources/sounds/problemFail.wav"

            Component.onCompleted: {
                play()
            }
        }

        Image {
            id: mistake

            anchors.horizontalCenter: parent.horizontalCenter
            width: 200
            height: 200

            source: "../../resources/sad.png"
        }

        Item {
            width: parent.width
            height: 30
        }

        Text {
            id: congratulaText

            visible: true
            text: "Oops " + appGlobal.userName + ",\n that's not correct at all!\n Do not be discouraged and try again"
            anchors.horizontalCenter: parent.horizontalCenter

            font.family: appTheme.fontFamily
            font.pixelSize: 16
            color: "black"
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            width: parent.width
            height: 20
        }

//        Text {
//            id: hint

//            visible: true
//            text: "Hint: El juez me ha quitado casas,\npiensa que operación aritmética se relaciona con\nquitar o sustraer."
//            anchors.horizontalCenter: parent.horizontalCenter

//            font.family: appTheme.fontFamily
//            font.pixelSize: 12
//            color: "gray"
//            horizontalAlignment: Text.AlignHCenter
//        }

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

                text: "Try again"
                font.family: appTheme.fontFamily
                font.pixelSize: 14

                onClicked: {
                    audio.stop()
                    stackView.push("problems/theCakeCalc.qml")
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
                font.family: appTheme.fontFamily
                font.pixelSize: 14

                onClicked: {
                    audio.stop()
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
