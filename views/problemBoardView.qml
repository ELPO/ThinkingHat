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
            text: "Choose your Challenge"
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

        Item {
            width: parent.width
            height: 20
        }

        ListModel {
            id: problemModel

            ListElement {
                name: "The Cake"
                available: true
                completed: false
            }

            ListElement {
                name: "Tidy Tommy"
                available: false
                completed: false
            }

            ListElement {
                name: "The Traffic"
                available: false
                completed: false
            }

            ListElement {
                name: "Playground"
                available: false
                completed: false
            }

            ListElement {
                name: "Magnets"
                available: false
                completed: false
            }

            ListElement {
                name: "Another story"
                available: false
                completed: false
            }

            ListElement {
                name: "Tidy Tommy 2"
                available: false
                completed: false
            }

            ListElement {
                name: "The Traffic 2"
                available: false
                completed: false
            }

            ListElement {
                name: "Playground 2"
                available: false
                completed: false
            }

            ListElement {
                name: "Magnets 2"
                available: false
                completed: false
            }

            ListElement {
                name: "Another story 2"
                available: false
                completed: false
            }
        }

        RowLayout {

            width: parent.width
            height: 40

            Item {
                width: 36
                height: parent.height
            }

            Text {
                text: "Challenges"

                font.family: appTheme.fontFamily
                font.pixelSize: 12
                color: "black"
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                Layout.fillWidth: true
                height: parent.height
            }

            Text {
                text: "High Score"

                font.family: appTheme.fontFamily
                font.pixelSize: 12
                color: "black"
                horizontalAlignment: Text.AlignHCenter
            }

            Item {
                width: 40
                height: parent.height
            }
        }

        Rectangle {
            width: parent.width
            Layout.fillHeight: true

            ListView {
                id: problemView

                model: problemModel
                anchors.fill: parent
                anchors.topMargin: 30
                anchors.bottomMargin: 30
                boundsBehavior: Flickable.StopAtBounds
                currentIndex: -1

                delegate: Rectangle {
                    width: parent.width
                    height: 40

                    color: index % 2 === 0 ? "#EFEFEF" : "#FAFAFA"

                    MouseArea {
                        anchors.fill: parent
                        visible: available

                        onClicked: {
                            problemView.currentIndex = index
                        }
                    }

                    Image {
                        id: lock

                        mipmap: true
                        source: "../resources/lock.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        width: 15
                        height: 15
                        anchors.verticalCenter: parent.verticalCenter
                        visible: !available
                    }

                    Image {
                        id: hat

                        mipmap: true
                        source: "../resources/hat.png"
                        anchors.left: parent.left
                        anchors.leftMargin: 15
                        width: 20
                        height: 20
                        anchors.verticalCenter: parent.verticalCenter
                        visible: available && index === problemView.currentIndex
                    }

                    Text {
                        text: name
                        anchors.leftMargin: 40
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter

                        font.family: appTheme.fontFamily
                        font.pixelSize: 12
                        color: available ? "black" : "gray"
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: completed ? "0" : "-"
                        anchors.rightMargin: 80
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                        font.family: appTheme.fontFamily
                        font.pixelSize: 12
                        visible: available
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }

        Button {
            id: control

            text: "Go!"
            font.family: appTheme.fontFamily
            font.pixelSize: 14
            enabled: problemView.currentIndex !== -1

            anchors.horizontalCenter: parent.horizontalCenter

            onClicked: {
                stackView.push("problems/theCake.qml")
            }

            background: Rectangle {
                color: enabled? "black" : "gray"
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
