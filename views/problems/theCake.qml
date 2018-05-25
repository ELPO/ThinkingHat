import QtQuick 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Layouts 1.3

Item
{
    id: screen

    property bool solved: false

    onSolvedChanged: {
        if (solved) {
            check.text = "Let's do the math"
            check.visible = true
        }
    }

    Audio {
        id: audio

        source: "../../resources/problema1.wav"
        onStopped: {
            playSound.enabled = true
        }
    }

    QtObject {
        id: results

        property bool uCond: false
        property bool sCond: false
        property bool cCond: false
    }

    function validate(text)
    {
        if (cursors.currentIndex == 0) {
            if (text === "¿Cuántas casas me quedan?")
                return true
            else return false;
        } else if (cursors.currentIndex == 1) {
            if (text === "12 casas" || text === "12 casas de montaña")
                return true
            else return false;
        } else if (cursors.currentIndex == 2) {
            if (text === "quita 6")
                return true
            else return false;
        }

        return false;
    }

    ColumnLayout {

        anchors.fill: parent

        RowLayout {
            width: parent.width
            height: 40

            property int margin: 30

            Item {
                height: parent.height
                width: parent.margin
            }

            Text {
                text: "Problem 1: The Cake"
                anchors.verticalCenter: parent.verticalCenter
                font.family: "Droid Sans Mono"
                font.pointSize: 14
                color: "gray"
            }

            Item {
                height: parent.height
                Layout.fillWidth: true
            }

            Rectangle {
                id: playSound

                height: parent.height - 10
                width: parent.height - 10
                radius: width / 2.0

                color: enabled ? "white" : "lightgrey"
                border.color: "black"
                border.width: 1

                Image {
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    width: parent.width / 1.8
                    source: "../../resources/audio.png"
                    mipmap: true
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        audio.play()
                        playSound.enabled = false
                    }
                }
            }

            Item {
                height: parent.height
                width: parent.margin
            }
        }

        TextEdit {
            id: statment

            text: "Tengo 12 casas de montaña y\nel juez me quita 6 para mi ex-\nmujer.\n\n¿Cuántas casas me quedan?"
            selectByMouse: false
            selectedTextColor: "black"
            anchors.horizontalCenter: parent.horizontalCenter
            readOnly: true
            persistentSelection: true

            font.pointSize: 18
            font.family: "Droid Sans Mono"

            FontMetrics {
                id: fontMetrics
                font.family: statment.font.family
                font.pointSize: statment.font.pointSize
            }

            function evaluate() {
                var butidx = cursors.currentIndex;
                var trimmed = selectedText.trim()
                if (validate(trimmed)) {
                    var pre = text.substring(0, text.indexOf(trimmed))
                    var truePre = pre.substring(pre.lastIndexOf("\n"))

                    var stringsearch = "\n";
                    var count = -1;
                    for (var index = 0; index != -1; count++, index = pre.indexOf(stringsearch, index + 1));

                    var ySpace = fontMetrics.height * count;
                    var rect = fontMetrics.boundingRect(trimmed)

                    //hardcoded change
                    var xSpace =  fontMetrics.advanceWidth(truePre) - 1

                    Qt.createQmlObject('import QtQuick 2.0; Rectangle {x: ' + xSpace + '; y: ' + ySpace + '; color: "' + selectionColor
                                       +'"; width: ' + (rect.width + 2)  + '; height: '+ fontMetrics.height + '; Text {anchors.centerIn: parent; font.pointSize: ' +
                                       statment.font.pointSize + '; font.family: "Droid Sans Mono"; text: "' + trimmed +'";}}', statment)
                    deselect()
                    selectByMouse = false
                    pressDetector.visible = false

                    if (butidx === 0)
                        results.uCond = true
                    else if (butidx === 1)
                        results.sCond = true
                    else if (butidx === 2)
                        results.cCond = true

                    cursors.currentIndex = -1

                    if (results.uCond === true && results.sCond === true && results.cCond === true) {
                        screen.solved = true
                    }
                }
            }

            MouseArea {
                id: pressDetector

                visible: false
                anchors.fill: parent
                property int start: 0
                property int end: 0

                onPressed: {
                    start = statment.positionAt(mouseX, mouseY)
                }

                onMouseXChanged: {
                    var newEnd = statment.positionAt(mouseX, mouseY)
                    if (newEnd !== end) {
                        end = newEnd
                        statment.select(start, end)
                    }
                }

                onMouseYChanged: {
                    var newEnd = statment.positionAt(mouseX, mouseY)
                    if (newEnd !== end) {
                        end = newEnd
                        statment.select(start, end)
                    }
                }

                onReleased: {
                    start = 0
                    end = 0

                    statment.evaluate()
                }
            }
        }

        Item {
            width: parent.width
            height: 20
        }

        Button {
            id: check

            text: "Check understanding"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Droid Sans Mono"
            font.pointSize: 14

            background: Rectangle {
                color: "black"
                radius: width / 3.2
            }

            contentItem: Text {
                text: check.text
                font: check.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onClicked: {
                if (!screen.solved) {
                    visible = false
                    header.visible = true
                    buttons.visible = true
                } else {
                    stackView.push("theCakeCalc.qml")
                }
            }
        }

        Item {
            width: parent.width
            Layout.fillHeight: true
        }

        Text {
            id: header

            font.family: "Droid Sans Mono"
            font.pointSize: 12
            color: "gray"
            text: "Mark the problem's structural elements"
            anchors.horizontalCenter: parent.horizontalCenter
            height:  20
            visible: false
        }

        Item {
            id: buttons
            width: parent.width
            height: cursors.itemHeight
            visible: false

            ListView {
                id: cursors

                property int buttonSize: 60
                property int buttonTextHeight: 40
                property int internalSpaceHeight: 15
                property int itemHeight: buttonSize + buttonTextHeight + internalSpaceHeight

                orientation: Qt.Horizontal
                width: itemHeight * 3 + spacing * 2
                interactive: false
                model: 3
                height: parent.height
                currentIndex: -1

                spacing: 0
                anchors.horizontalCenter: parent.horizontalCenter

                delegate: Item {
                    height: cursors.itemHeight
                    width: cursors.itemHeight

                    Rectangle {
                        id: cursorBtn
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: index === 0 ?  "#FFFF01" : (index === 1 ? "#b6e8e5" : "#F0A9ED")
                        border.color: "black"
                        border.width: cursors.currentIndex === index ? 2 : 0

                        anchors.top: parent.top
                        height: cursors.buttonSize
                        width: cursors.buttonSize
                        radius: width / 2.0

                        Image {
                            anchors.centerIn: parent
                            fillMode: Image.PreserveAspectFit
                            width: parent.width / 1.8
                            source: {
                                if (index === 0 && results.uCond)
                                    return "../../resources/check.png"
                                else if (index === 1 && results.sCond)
                                    return "../../resources/check.png"
                                else if (index === 2  && results.cCond)
                                    return "../../resources/check.png"
                                else return "../../resources/draw.png"
                            }

                            mipmap: true
                        }

                        MouseArea {
                            visible: index === 0 ? !results.uCond : (index === 1 ? !results.sCond : !results.cCond )
                            anchors.fill: parent

                            onClicked: {
                                pressDetector.visible = true
                                cursors.currentIndex = index
                                statment.deselect()
                                statment.selectByMouse = true
                                statment.selectionColor = cursorBtn.color
                            }
                        }
                    }

                    Item {
                        id: internalSpace
                        width: parent.width
                        height: cursors.internalSpaceHeight
                        anchors.top: cursorBtn.bottom
                    }

                    Text {
                        id: name

                        font.family: "Droid Sans Mono"
                        font.pointSize: 14
                        height: cursors.buttonTextHeight
                        anchors.top: internalSpace.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        horizontalAlignment: Text.AlignHCenter
                        text: index === 0 ? "Unknow" : (index === 1 ? "Starting\nPoint" : "Changer")
                    }
                }
            }
        }
    }
}
