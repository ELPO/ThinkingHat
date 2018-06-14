import QtQuick 2.10
import QtQuick.Controls 2.2
import QtMultimedia 5.8
import QtQuick.Layouts 1.3
import QtSensors 5.0
import QtGraphicalEffects 1.0

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
            if (text === "quita 6" || text === "me quita 6")
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
                font.family: appTheme.fontFamily
                font.pixelSize: 14
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

        Text {
            id: statment

            property var distances: undefined

            text: "Tengo 12 casas de montaña y el juez me quita 6 para mi exmujer. ¿Cuántas casas me quedan?"
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.preferredWidth: parent.width - appTheme.margin * 2 //to do scale
            wrapMode: Text.Wrap
            lineHeight: 2

            font.pixelSize: appTheme.fontMedium
            font.family: appTheme.fontFamily

            FontMetrics {
                id: fontMetrics

                font.family: statment.font.family
                font.pixelSize: statment.font.pixelSize
            }

            onWidthChanged: {
                // Assumption: Window size is not editable so this is like an effective onComplete slot
                console.log(fontMetrics.maximumCharacterWidth)
                if (parent.width !== 0) {
                    var myMap = [[]];
                    var length = text.length;
                    var line = 0
                    var startLine = 0
                    var startWord = 0

                    for (var i = 0; i < length; i++) {
                        if (i === 0 || text.charAt(i - 1) === " ")
                            startWord = i

                        var cursor = fontMetrics.advanceWidth(text.substring(startLine, i))
//                        if (cursor > width && text.charAt(cursor) !== " ") {
//                            line++
//                            startLine = startWord
//                            cursor = fontMetrics.advanceWidth(text.substring(startLine, i))
//                            for (var j = startWord; j < i; j++) {
//                                console.log("chchch " + j)
//                                myMap[j] = [line, fontMetrics.advanceWidth(text.substring(startLine, j))]
//                            }
//                        }

                        myMap[i] = [line, cursor];
                    }

                    for (i = 0; i < length; i++) {
                        console.log(i + ": " + myMap[i] + " " + text.charAt(i))
                    }
                }

                distances = myMap
                canvas.requestPaint()
                console.log("patata " + fontMetrics.advanceWidth(" "))
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
                    var xSpace = Qt.platform.os === "android" ? fontMetrics.advanceWidth(truePre) :
                                                                fontMetrics.advanceWidth(truePre)

                    console.log(xSpace + " " + ySpace + " " + rect)


                    Qt.createQmlObject('import QtQuick 2.10; Rectangle {x: ' + xSpace + '; y: ' + ySpace + '; color: "' + selectionColor
                                       +'"; width: ' + (rect.width + 2)  + '; height: '+ fontMetrics.height + '; Text {anchors.centerIn: parent; font.pixelSize: ' +
                                       statment.font.pixelSize + '; font.family: appTheme.fontFamily; text: "' + trimmed +'";}}', statment)
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

            Canvas {
                id: canvas
                anchors.fill: parent

                onPaint: {
                    var ctx = getContext('2d');

                    ctx.lineWidth = 1;
                    ctx.lineCap = "round"
                    ctx.lineJoin ="bevel"
                    ctx.fillStyle = "red"
                    ctx.strokeStyle = "black"

                    var rect = fontMetrics.boundingRect(statment.text)
                    ctx.fillRect(0, fontMetrics.height, fontMetrics.advanceWidth("Tengo 12 casas de montaña y"), fontMetrics.height)
                    //ctx.fillRect(0, fontMetrics.height, fontMetrics.averageCharacterWidth * 27, fontMetrics.height)

                    for (var i = 0; i < statment.distances.length; i++) {
                        if (statment.distances[i][0] === 0) {
                            ctx.rect(statment.distances[i][1], fontMetrics.height, 1, fontMetrics.height)
                        }
                    }

                    ctx.stroke()
                }

                MouseArea {
                    id: pressDetector

                    visible: false
                    anchors.fill: parent
                    property int start: 0
                    property int start2: 0
                    property int end: 0

                    onPressed: {
                        var lines = statment.contentHeight / fontMetrics.height
                        var clickHeight = Math.floor(mouseY / fontMetrics.height)
                        var line = 1

                        if (clickHeight % 2 === 1) {
                            //to do make a map
                            for (var i = 0; i < statment.distances.length; i++) {
                                //console.log(i + " " + (statment.distances.length - 1) + " " +  statment.text.charAt(i))
                                if (i === (statment.distances.length - 1)) {
                                    if (statment.distances[i][0] === Math.floor(clickHeight / 2.0) &&
                                        statment.distances[i][1] <= mouseX) {
                                        console.log(statment.distances[i][1] + " !!!  " + mouseX + " " + i)
                                        console.log(i + " " + statment.text.charAt(i))
                                    }
                                } else {
                                    //console.log(i)
                                    if (statment.distances[i][0] === Math.floor(clickHeight / 2.0) &&
                                        statment.distances[i][1] <= mouseX && (statment.distances[i+1][1] > mouseX)) {
                                        console.log(statment.distances.length)
                                        console.log(statment.distances[i][1] + " " + mouseX + " " + statment.distances[i+1][1])
                                        console.log(i + " " + statment.text.charAt(i))
                                    }
                                }
                            }
                        }

//                        var letterNumber = /^[0-9a-zA-Zñáéíóúäëïöü¿?!¡-]+$/;
//                        var ini = statment.positionAt(mouseX, mouseY)
//                        var end = ini
//                        while (statment.getText(ini - 1 , ini).match(letterNumber)) {
//                            ini = ini - 1
//                        }

//                        start = ini

//                        while (statment.getText(end, end + 1).match(letterNumber)) {
//                            end = end + 1
//                        }

//                        start2 = end
                    }

                    onMouseXChanged: {
                        //customSelection()
                    }

                    onMouseYChanged: {
                        //customSelection()
                    }

                    onReleased: {
//                        start = 0
//                        end = 0

//                        statment.evaluate()
                    }

                    function customSelection() {
                        var letterNumber = /^[0-9a-zA-Zñáéíóúäëïöü¿?!¡-]+$/;
                        var pos = statment.positionAt(mouseX, mouseY)
                        var offset;
                        if (pos > start) {
                            while (statment.getText(pos, pos + 1).match(letterNumber)) {
                                pos = pos + 1
                            }

                            if (pos !== end) {
                                end = pos
                                statment.select(start, end)
                            }
                        } else {
                            while (statment.getText(pos - 1, pos).match(letterNumber)) {
                                pos = pos - 1
                            }

                            if (pos !== end) {
                                end = pos
                                statment.select(start2, end)
                            }
                        }
                    }
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
            font.family: appTheme.fontFamily
            font.pixelSize: 14

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
                    draw.visible = false
                    header.visible = true
                    buttons.visible = true
                } else {
                    stackView.push("theCakeCalc.qml")
                }
            }
        }

        Item {
            id: smallSpacer

            width: parent.width
            height: 10
        }

        Button {
            id: draw

            text: "Draw Strategy"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: appTheme.fontFamily
            font.pixelSize: 14

            background: Rectangle {
                color: "black"
                radius: width / 3.2
            }

            contentItem: Text {
                text: draw.text
                font: draw.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onClicked: {
                visible = false
                check.visible = false
                smallSpacer.visible = false
                spacer.visible = false
                drawCanvas.visible = true
                avatarItem.visible = true
                timer.restart()
            }
        }

        Item {
            id: eraserItem

            anchors.right: parent.right
            anchors.rightMargin: parent.height / 22
            width: parent.height / 22
            height: parent.height / 22


            Image {
                id: eraser

                property bool erasing: false

                visible: false
                anchors.fill: parent

                source: "../../resources/eraser.png"
                mipmap: true

                ColorOverlay {
                    anchors.fill: eraser
                    source: eraser
                    color: "blue"

                    visible: eraser.erasing
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: eraser.erasing = !eraser.erasing
                }
            }
        }

        Canvas {
            id: drawCanvas

            readonly property int imgSize: width / 12
            readonly property int boxSize: width / 24
            property bool erasing: false

            width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            Layout.fillHeight: true

            SensorGesture {
                gestures : ["QtSensors.shake"]
                enabled: true

                onDetected: {
                    if (avatarItem.state === "5")
                        avatarItem.state = "6"
                }
            }

            visible: false

            onPaint: {
                var ctx = getContext('2d');

                if (erasing) {
                    ctx.fillStyle = "white"
                    ctx.fillRect(0, 0, width, height)
                    drawCanvas.erasing = false
                    ctx.reset()
                }

                for (var i = 0; i < drawMouseAra.points.length; ++i) {
                    var x = drawMouseAra.points[i].x
                    var y = drawMouseAra.points[i].y
                    if (avatarItem.state === "2") {
                        ctx.drawImage (drawMouseAra.houses[i], x - (imgSize / 2.0),
                                       y - (imgSize / 2.0), imgSize, imgSize)
                    } else if (avatarItem.state === "6" || avatarItem.state === "7") {
                        ctx.lineWidth = 2

                        ctx.beginPath()
                        ctx.rect (x - (drawCanvas.boxSize / 2.0), y - (drawCanvas.boxSize / 2.0), drawCanvas.boxSize, drawCanvas.boxSize)
                        ctx.strokeStyle = "black"
                        ctx.stroke()

                        if (drawMouseAra.tachadas.indexOf(i) !== -1) {
                            ctx.beginPath()
                            ctx.moveTo (x - 5 -drawCanvas.boxSize / 2, y - 5 -drawCanvas.boxSize / 2)
                            ctx.lineTo(x + drawCanvas.boxSize / 2 + 5, y + drawCanvas.boxSize / 2 + 5)

                            ctx.strokeStyle = "red"
                            ctx.stroke()

                        }
                    }
                }
            }

            Component.onCompleted: {
                loadImage("../../resources/houses/house1.png")
                loadImage("../../resources/houses/house2.png")
                loadImage("../../resources/houses/house3.png")
                loadImage("../../resources/houses/house4.png")
                loadImage("../../resources/houses/house5.png")
                loadImage("../../resources/houses/house6.png")
            }

            MouseArea {
                id: drawMouseAra

                property var houses: []
                property var points: []
                property var tachadas: []

                visible: false

                anchors.fill: parent
                onClicked: {
                    if (avatarItem.state === "2") {
                        if (mouseX > width - drawCanvas.imgSize / 2 || mouseX < drawCanvas.imgSize / 2 ||
                            mouseY > height - drawCanvas.imgSize / 2 || mouseY < drawCanvas.imgSize / 2)
                            return

                        for (var i = 0; i < drawMouseAra.points.length; ++i) {
                            if (mouseX >= points[i].x - drawCanvas.imgSize && mouseX <= points[i].x + drawCanvas.imgSize &&
                                mouseY >= points[i].y - drawCanvas.imgSize && mouseY <= points[i].y + drawCanvas.imgSize) {

                                if (eraser.erasing) {
                                    points.splice(i, 1);
                                    houses.splice(i, 1);
                                    drawCanvas.erasing = true
                                    drawCanvas.requestPaint()
                                }

                                return
                            }
                        }

                        if (!eraser.erasing) {
                            points.push(Qt.point(mouseX, mouseY))
                            var houseString = "../../resources/houses/house" + Math.round(Math.random() * 5 + 1) + ".png"
                            houses.push(houseString)
                            drawCanvas.requestPaint()
                        }
                    } else if (avatarItem.state === "5" ) {
                        avatarItem.state = "6"
                    } else if (avatarItem.state === "7" ) {
                        for (var j = 0; j < drawMouseAra.points.length; ++j) {
                            if (mouseX >= points[j].x - drawCanvas.boxSize && mouseX <= points[j].x + drawCanvas.boxSize &&
                                mouseY >= points[j].y - drawCanvas.boxSize && mouseY <= points[j].y + drawCanvas.boxSize) {

                                var tindex = tachadas.indexOf(j)
                                if (eraser.erasing) {
                                    if (tachadas.indexOf(j) !== -1) {

                                        tachadas.splice(tindex, 1);
                                        drawCanvas.erasing = true
                                        drawCanvas.requestPaint()
                                    }
                                } else {
                                    if (tachadas.indexOf(j) === -1) {
                                        tachadas.push(j)
                                        drawCanvas.requestPaint()
                                    }
                                }

                                return
                            }
                        }
                    }
                }
            }
        }

        Item {
            id: avatarItem

            width: parent.width
            height: 140
            state: "1"
            visible: false

            states: [
                State {
                    name: "1";
                    PropertyChanges { target: avatarText; text: "¡Hacer problemas es sencillo\nsi los dibujamos!" }
                },
                State {
                    name: "2";
                    PropertyChanges { target: avatarText; text: "  Pulsa para dibujar las 12 casas" }
                    PropertyChanges { target: drawMouseAra; visible: true }
                    PropertyChanges { target: checkCasas; visible: true }
                    PropertyChanges { target: eraser; visible: true }
                },
                State {
                    name: "3";
                    PropertyChanges { target: avatarText; text: "  Ooops ¡Parece que no es correcto!" }
                },
                State {
                    name: "4";
                    PropertyChanges { target: avatarText; text: "  ¡Genial!" }
                    PropertyChanges { target: eraser; visible: true }
                },
                State {
                    name: "5";
                    PropertyChanges { target: drawMouseAra; visible: true }
                    PropertyChanges { target: avatarText; text: "Un truco es que no es necesario\npintar las casas, basta\ncon representarlas unidades.\nDa una sacudida para\nsimplificar el dibujo." }
                },
                State {
                    name: "6";
                    PropertyChanges { target: avatarText; text: "  ¡Brillante!" }
                },
                State {
                    name: "7";
                    PropertyChanges { target: avatarText; text: "  Tacha tantas unidades como casas\nme quita el juez" }
                    PropertyChanges { target: drawMouseAra; visible: true }
                    PropertyChanges { target: checkCasas; visible: true }
                    PropertyChanges { target: eraser; visible: true }
                },
                State {
                    name: "8";
                    PropertyChanges { target: avatarText; text: "  Ooops ¡Parece que no es correcto!" }
                },
                State {
                    name: "9";
                    PropertyChanges { target: avatarText; text: "  ¡Fantastico! Ya podemos\nresolver el problema" }
                }
            ]

            onStateChanged: {
                if (state === "3" || state === "4" || state === "8") {
                    timer.interval = 1400
                    timer.restart()
                    return
                }

                if (state === "6") {
                    drawCanvas.erasing = true
                    drawCanvas.requestPaint()
                    timer.interval = 1400
                    timer.restart()
                }

                if (state === "9") {
                    timer.interval = 1800
                    timer.restart()
                    return
                }

                if (state === "7") {
                    appGlobal.drawPre = drawCanvas.toDataURL()
                    return
                }

                eraser.erasing = false
            }

            Image {
                id: avatar

                property int moveMargin: 0

                source: "../../resources/hatCartoon.png"
                mipmap: true
                height:parent.height
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.leftMargin: moveMargin
                fillMode: Image.PreserveAspectFit

                SequentialAnimation {
                    running: avatarItem.state === "3" || avatarItem.state === "8"
                    alwaysRunToEnd: true
                    loops: Animation.Infinite

                    NumberAnimation {
                        target: avatar
                        property: "moveMargin"
                        from: 0
                        to: 10
                        duration: 60
                    }

                    NumberAnimation  {
                        target: avatar
                        property: "moveMargin"
                        from: 10
                        to: 0
                        duration: 60
                    }
                }

                NumberAnimation {
                    target: avatar
                    property: "rotation"
                    from: 0
                    to: 360
                    duration: 300

                    running: avatarItem.state === "4" || avatarItem.state === "6" || avatarItem.state === "9"
                    alwaysRunToEnd: true
                    loops: 1
                }
            }

            Text {
                id: avatarText

                text: "¡Hacer problemas es sencillo si los dibujamos!"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.leftMargin: avatar.width +  avatar.width * -0.35
                font.family: appTheme.fontFamily
                font.pixelSize: 14
                color: "black"
                horizontalAlignment: Text.AlignHCenter
            }

            Button {
                id: checkCasas

                text: "Ya estan todas"
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: appTheme.fontFamily
                font.pixelSize: 14
                visible: false
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 20

                background: Rectangle {
                    color: "black"
                    radius: width / 3.2
                }

                contentItem: Text {
                    text: checkCasas.text
                    font: checkCasas.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    if (avatarItem.state === "2") {
                        if (drawMouseAra.points.length !== 12) {
                            avatarItem.state = "3"
                        } else {
                            avatarItem.state = "4"
                        }
                    } else if (avatarItem.state === "7") {
                        if (drawMouseAra.tachadas.length !== 6) {
                            avatarItem.state = "8"
                        } else {
                            avatarItem.state = "9"
                        }
                    }
                }
            }

            Timer {
                id: timer

                interval: 2300;

                onTriggered: {
                    if (avatarItem.state === "4") {
                        avatarItem.state = "5"
                        return
                    }

                    if (avatarItem.state === "6") {
                        avatarItem.state = "7"
                        return
                    }

                    if (avatarItem.state === "8") {
                        avatarItem.state = "7"
                        return
                    }


                    if (avatarItem.state === "9") {
                        appGlobal.drawPost = drawCanvas.toDataURL()
                        stackView.push("theCakeCalcDraw.qml")
                        return
                    }

                    avatarItem.state = "2"
                }
            }
        }

        Item {
            id: spacer

            visible: true
            width: parent.width
            Layout.fillHeight: true
        }

        Text {
            id: header

            font.family: appTheme.fontFamily
            font.pixelSize: 12
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

                        font.family: appTheme.fontFamily
                        font.pixelSize: 14
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
