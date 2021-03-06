import QtQuick 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Layouts 1.3

Item
{
    id: calc

    property string title: ""
    property int squaresSize: 18

    Row {
        anchors.fill: parent

        Repeater {
            model: calc.width / calc.squaresSize
            Item {
                width: calc.squaresSize
                height: calc.height

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 2;
                    height: parent.height

                    color: "#F3F3F3"
                }
            }
        }
    }

    Column {
        anchors.fill: parent

        Repeater {
            model: calc.height / calc.squaresSize
            Item {
                height: calc.squaresSize
                width: calc.width

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: 2;

                    color: "#F3F3F3"
                }
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent

        Text {
            text: "Check understanding"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Droid Sans Mono"
            font.pointSize: 14
            color: "gray"
        }

        RowLayout {
            Item {
                height: parent.height
                width: 30
            }
            Rectangle {
                color: "#b6e8e5"
                width: 160
                height: 70

                Text {
                    anchors.centerIn: parent
                    text: "The starting\npoint?"
                    font.family: "Droid Sans Mono"
                    font.pointSize: 14
                    color: "black"
                }
            }

            Item {
                height: parent.height
                width: 30
            }

            Text {
                text: "12 casas"
                font.family: "Droid Sans Mono"
                font.pointSize: 18
                color: "black"
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Item {
                height: parent.height
                width: 30
            }
            Rectangle {
                color: "#F0A9ED"
                width: 160
                height: 70

                Text {
                    anchors.centerIn: parent
                    text: "What is the\nchanger?"
                    font.family: "Droid Sans Mono"
                    font.pointSize: 14
                    color: "black"
                }
            }

            Item {
                height: parent.height
                width: 30
            }

            Text {
                text: "El juez me\nha quitado 6"
                font.family: "Droid Sans Mono"
                font.pointSize: 18
                color: "black"
                Layout.fillWidth: true
            }
        }

        RowLayout {
            Item {
                height: parent.height
                width: 30
            }
            Rectangle {
                color: "#FFFF01"
                width: 160
                height: 70

                Text {
                    anchors.centerIn: parent
                    text: "What is the\nunknown?"
                    font.family: "Droid Sans Mono"
                    font.pointSize: 14
                    color: "black"
                }
            }

            Item {
                height: parent.height
                width: 30
            }

            Text {
                text: "Cuántas casas\nme quedan?"
                font.family: "Droid Sans Mono"
                font.pointSize: 18
                color: "black"
                Layout.fillWidth: true
            }
        }

        Canvas {
            id: drawArea

            //width: parent.width
            Layout.fillHeight: true
            Layout.minimumHeight: 40
            Layout.minimumWidth: parent.width

            onPaint: {
                var ctx = getContext('2d');

                ctx.lineWidth = 2;
                ctx.lineCap = "round"
                ctx.lineJoin ="bevel"
                ctx.strokeStyle = "black"
                ctx.beginPath()

                ctx.moveTo(eventArea.xStart, eventArea.yStart)
                ctx.lineTo(eventArea.xEnd, eventArea.yEnd)

                ctx.closePath()
                ctx.stroke()

                eventArea.xStart = eventArea.xEnd
                eventArea.yStart = eventArea.yEnd

            }

            function clear() {
                var ctx = getContext('2d')
                ctx.reset()
                requestPaint()
            }


            MouseArea {
                id: eventArea

                anchors.fill: parent
                property real xStart: 0.0
                property real yStart: 0.0
                property real xEnd: 0.0
                property real yEnd: 0.0

                onPressed: {
                    solution.focus = false
                    xStart = mouseX
                    yStart = mouseY
                }

                onReleased: {
                    xEnd = mouseX
                    yEnd = mouseY
                    drawArea.requestPaint()
                }

                onMouseXChanged: {
                    if (xEnd !== mouseX) {
                        xEnd = mouseX
                        drawArea.requestPaint()
                    }
                }

                onMouseYChanged: {
                    if (yEnd !== mouseY)
                    {
                        yEnd = mouseY
                        drawArea.requestPaint()
                    }
                }

                Rectangle {
                    id: resetBtn
                    border.color: "gray"
                    border.width: 1
                    color: "white"
                    width: 30
                    height: 30
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.topMargin: 20
                    radius: width / 2.0

                    Image {
                        anchors.centerIn: parent
                        width: parent.height / 1.5
                        height: parent.height / 1.5

                        source: "../../resources/eraser.png"
                        mipmap: true

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                drawArea.clear()
                            }
                        }
                    }
                }
            }
        }

        RowLayout {
            width: parent.width

            height: 150

            Item {
                height: parent.height
                width: 30
            }

            Item {
                Layout.fillWidth: true
                height: parent.height

                Text {
                    id: headerField

                    anchors.top: parent.top
                    text: "Write your solution here"
                    font.family: "Droid Sans Mono"
                    font.pointSize: 14
                    color: "gray"
                }

                Item {
                    id: space

                    height: 10
                    width: parent.width
                    anchors.top: headerField.bottom
                }

                TextField {
                    id: solution

                    anchors.top: space.bottom
                    height: parent.height - headerField.height - space.height
                    width: parent.width
                    font.family: "Droid Sans Mono"
                    font.pointSize: 80
                    horizontalAlignment: Text.AlignHCenter

                    background: Rectangle {
                        border.color: solution.focus ? "black" : "gray"
                        border.width: solution.focus ? 2 : 1
                    }

                    validator: IntValidator{}
                }
            }

            Button {
                id: submit

                enabled: solution.text != ""

                text: "Submit"
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Droid Sans Mono"
                font.pointSize: 14

                background: Rectangle {
                    color: submit.enabled ? "black" : "gray"
                    radius: width / 3.2
                }

                contentItem: Text {
                    text: submit.text
                    font: submit.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    if (Number.fromLocaleString(solution.text) === 6) {
                        stackView.push("../successView.qml")
                    } else {
                        stackView.push("../wrongView.qml")
                    }

                    drawArea.clear()
                    solution.clear()
                }
            }

            Item {
                height: parent.height
                width: 30
            }
        }

        Item {
            height: 30
            width: parent.width
        }
    }

}

