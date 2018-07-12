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

        readonly property string wrongSrc: "../../../../resources/sounds/wrong.wav"
        readonly property string right1Src: "../../../../resources/sounds/right1.wav"
        readonly property string right2Src: "../../../../resources/sounds/right2.wav"
        readonly property string right3Src: "../../../../resources/sounds/right3.wav"

        source: "../../../../resources/problema1.wav"
        onStopped: {
            playSound.enabled = true
        }

        function wrong() {
            source = wrongSrc
            play()
        }

        function right1() {
            source = right1Src
            play()
        }

        function right2() {

            source = right2Src
            play()
        }

        function right3() {

            source = right3Src
            play()
        }
    }

    QtObject {
        id: results

        property bool uCond: false
        property bool sCond: false
        property bool cCond: false
    }

    // 0 equal, 1 partial rest false
    function validate(text, reference)
    {
        var ret = -1
        for (var i = 0; i < reference.length; i++) {
            if (text === reference[i])
                return 0
            else if (reference[i].includes(text))
                ret = 1

        }

        return ret
    }

    ColumnLayout {
        anchors.top: parent.top
        anchors.bottom: footer.top
        width: parent.width

        RowLayout {
            width: parent.width
            height: 40

            property int margin: 30

            Item {
                height: parent.height
                width: parent.margin
            }

            Text {
                text: appGlobal.problemName
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

                visible: false

                Image {
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                    width: parent.width / 1.8
                    source: "../../../../resources/audio.png"
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

            property var distances: [[]]
            property var lineswidth: []
            property var lastWords: []

            text: appGlobal.problemStatment
            anchors.horizontalCenter: parent.horizontalCenter
            wrapMode: Text.Wrap
            lineHeight: 2
            Layout.preferredWidth: parent.width - appTheme.margin * 2 // to do scale

            font.pixelSize: appTheme.fontMedium
            font.family: appTheme.fontFamily

            FontMetrics {
                id: fontMetrics

                font.family: statment.font.family
                font.pixelSize: statment.font.pixelSize
            }

            onTextChanged: {
                // Assumption: Text is not editable so this is like an effective onComplete slot
                if(appGlobal.debug)
                    processText()
            }

            onWidthChanged: {
                if(!appGlobal.debug)
                    processText()
            }

            function processText() {
                if (text !== "") {
                    var length = text.length;
                    var line = 0
                    var startLine = 0
                    var startWord = 0
                    var cur = 0
                    var precur = 0

                    while (cur < length) {
                        startWord = cur
                        cur = text.indexOf(" ", cur);
                        if (cur === -1) {
                            if (fontMetrics.advanceWidth(text.substring(startLine, length - 1)) > width) {
                                line++
                                lineswidth.push(fontMetrics.advanceWidth(text.substring(startLine, precur)))
                                lastWords.push(distances.length - 1)
                                startLine = startWord
                            }

                            distances.push([line,
                                            fontMetrics.advanceWidth(text.substring(startLine, startWord)),
                                            fontMetrics.advanceWidth(text.substring(startLine, length)),
                                            startWord,
                                            length])
                            break;
                        }

                        if (fontMetrics.advanceWidth(text.substring(startLine, cur)) > width) {
                            line++
                            lineswidth.push(fontMetrics.advanceWidth(text.substring(startLine, startWord - 1)))
                            lastWords.push(distances.length - 1)
                            startLine = startWord
                        }

                        distances.push([line,
                                        fontMetrics.advanceWidth(text.substring(startLine, startWord)),
                                        fontMetrics.advanceWidth(text.substring(startLine, cur)),
                                        startWord,
                                        cur])

                        precur = cur
                        cur++
                    }

                    lastWords.push(distances.length - 1)
                    lineswidth.push(fontMetrics.advanceWidth(text.substring(startLine, text.length - 1)))
                }
            }

            Canvas {
                id: canvas

                readonly property int margin: 20
                property var validated: []

                width: parent.width + margin * 2
                height: parent.height + margin * 2 + fontMetrics.height / 2.0
                x: -margin
                y: -margin
                clip: true

                onPaint: {
                    var ctx = getContext('2d');

                    ctx.reset()
                    ctx.lineWidth = 6
                    ctx.lineCap = "round"
                    ctx.shadowBlur = 4

                    if (pressDetector.startWord !== -1) {
                        ctx.strokeStyle = cursors.color
                        ctx.shadowColor = cursors.color
                        ctx.beginPath()

                        for (var i = pressDetector.startLine; i <= pressDetector.endLine; i++) {
                            var start = i === pressDetector.startLine ? statment.distances[pressDetector.startWord][1] : 0
                            var end = i === pressDetector.endLine ? statment.distances[pressDetector.endWord][2] : statment.lineswidth[i]
                            var h = fontMetrics.height + 4 + fontMetrics.height * i * 2
                            ctx.moveTo(start + margin, h + margin)
                            ctx.lineTo(end + margin, h + margin)
                        }

                        ctx.stroke()
                    }

                    for (var j = 0; j < validated.length; j++) {
                        var startLine = validated[j][0]
                        var endLine = validated[j][1]
                        var startWord = validated[j][2]
                        var endWord = validated[j][3]
                        ctx.strokeStyle = validated[j][4]
                        ctx.shadowColor = validated[j][4]
                        ctx.beginPath()

                        for (var k = startLine; k <= endLine; k++) {
                            start = k === startLine ? statment.distances[startWord][1] : 0
                            end = k === endLine ? statment.distances[endWord][2] : statment.lineswidth[k]
                            h = fontMetrics.height + 4 + fontMetrics.height * k * 2
                            ctx.moveTo(start + margin, h + margin)
                            ctx.lineTo(end + margin, h + margin)
                        }

                        ctx.stroke()
                    }
                }

                MouseArea {
                    id: pressDetector

                    anchors.fill: parent
                    visible: false

                    property int wordOrigin: -1
                    property int lineOrigin: -1
                    property int startLine: -1
                    property int endLine: -1
                    property int startWord: -1
                    property int endWord: -1
                    property var letterNumberER: /^[0-9a-zA-Zñáéíóúäëïöü¿?!¡.-]+$/;
                    property bool clickFlag: false
                    property bool selectionGoing: false

                    onPressed: {
                        if (selectionGoing)
                            appendSelection()
                        else {
                            clickFlag = true
                            clickSelection()
                        }
                    }

                    onMouseXChanged: {
                        if (clickFlag)
                            clickFlag = false
                        else
                            if (selectionGoing)
                                appendSelection()
                            else {
                                appendSelection()
                            }
                    }

                    onReleased: {
                        statment.evaluate()
                        if (!selectionGoing) {
                            reset()
                        }
                    }

                    function reset() {
                        selectionGoing = false
                        startWord = -1
                        lineOrigin = -1
                        endWord = -1
                        wordOrigin = -1
                        startLine = -1
                        endLine = -1
                    }

                    function appendSelection() {
                        var mouseX = pressDetector.mouseX - canvas.margin
                        var mouseY = pressDetector.mouseY - canvas.margin
                        var clickHeight = Math.floor(mouseY / fontMetrics.height)

                        if (clickHeight % 2 === 0 &&
                            mouseY - clickHeight * fontMetrics.height < fontMetrics.height / 2.0)
                            clickHeight--

                        if (clickHeight % 2 === 1) {
                            var len = statment.text.length

                            for (var i = 0; i < statment.distances.length; i++) {
                                var row = statment.distances[i][0]
                                if (row === Math.floor(clickHeight / 2.0)){
                                    if ((statment.lineswidth[row] < mouseX) &&
                                            mouseX < width - canvas.margin * 2 &&
                                            row !== lineOrigin && lineOrigin !== -1) {
                                        if (lineOrigin < row) {
                                            endLine = row
                                            endWord = statment.lastWords[row]
                                        } else {
                                            startWord = statment.lastWords[row]
                                            startLine = row
                                        }

                                        canvas.requestPaint()
                                        break
                                    }
                                    else if (statment.distances[i][1] <= mouseX &&
                                             (statment.distances[i][2] > mouseX)) {
                                        if (row > lineOrigin) {
                                            endLine = row
                                            endWord = i
                                        } else if (row < lineOrigin) {
                                            startLine = row
                                            startWord = i
                                        } else {
                                            startLine = lineOrigin
                                            endLine = lineOrigin

                                            if (i < wordOrigin) {
                                                startWord = i
                                            } else if (i > wordOrigin) {
                                                endWord = i
                                            } else {
                                                startWord = i
                                                endWord = i
                                            }
                                        }

                                        canvas.requestPaint()
                                        break
                                    }
                                }
                            }
                        }
                    }

                    function clickSelection() {
                        var mouseX = pressDetector.mouseX - canvas.margin
                        var mouseY = pressDetector.mouseY - canvas.margin
                        var clickHeight = Math.floor(mouseY / fontMetrics.height)

                        if (clickHeight % 2 === 0 && mouseY - clickHeight * fontMetrics.height < fontMetrics.height / 2.0) {
                            clickHeight--
                        }

                        if (clickHeight % 2 === 1) {
                            //to do make a map
                            var len = statment.text.length

                            for (var i = 0; i < statment.distances.length; i++) {
                                var row = statment.distances[i][0]
                                if (row === Math.floor(clickHeight / 2.0) &&
                                    statment.distances[i][1] <= mouseX &&
                                    (statment.distances[i][2] > mouseX)) {
                                    lineOrigin = row
                                    startLine = row
                                    endLine = row
                                    wordOrigin = i
                                    startWord = i
                                    endWord = i
                                    canvas.requestPaint()
                                    break;
                                }
                            }
                        }
                    }
                }
            }

            function evaluate() {
                if (pressDetector.startWord === - 1 || pressDetector.endWord === -1)
                    return

                var butidx = cursors.currentIndex;
                var selectedText = statment.text.substring(statment.distances[pressDetector.startWord][3],
                                                           statment.distances[pressDetector.endWord][4])
                var refText = ""
                if (butidx === 0)
                    refText = appGlobal.problemUnkown
                else if (butidx === 1)
                    refText = appGlobal.problemStartingPoint
                else if (butidx === 2)
                    refText = appGlobal.problemChanger

                var result = validate(selectedText, refText)
                if (result === 0) {
                    // play
                    if (canvas.validated.length === 0)
                        audio.right1()
                    else if (canvas.validated.length === 1)
                        audio.right2()
                    else if (canvas.validated.length === 2)
                        audio.right3()

                    if (butidx === 0) {
                        results.uCond = true
                        appGlobal.problemPickedUnknown = selectedText
                    } else if (butidx === 1) {
                        results.sCond = true
                        appGlobal.problemPickedStarting = selectedText
                    } else if (butidx === 2) {
                        results.cCond = true
                        appGlobal.problemPickedChanger= selectedText
                    }

                    canvas.validated.push([pressDetector.startLine,
                                           pressDetector.endLine,
                                           pressDetector.startWord,
                                           pressDetector.endWord,
                                           cursors.color])

                    if (!results.uCond) {
                        cursors.currentIndex = 0
                    } else if (!results.sCond) {
                        cursors.currentIndex = 1
                    } else if (!results.cCond) {
                        cursors.currentIndex = 2
                    } else {
                        pressDetector.visible = false
                        cursors.currentIndex = -1
                        screen.solved = true
                    }

                } else if (result !== 1) {
                    pressDetector.selectionGoing = false
                    audio.wrong();
                    canvas.requestPaint();
                } else pressDetector.selectionGoing = true
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
                    pressDetector.visible = true
                    draw.visible = false
                    header.visible = true
                    buttons.visible = true
                } else {
                    audio.stop()
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

            visible: false

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

                source: "../../../../resources/eraser.png"
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
                loadImage("../../../../resources/houses/house1.png")
                loadImage("../../../../resources/houses/house2.png")
                loadImage("../../../../resources/houses/house3.png")
                loadImage("../../../../resources/houses/house4.png")
                loadImage("../../../../resources/houses/house5.png")
                loadImage("../../../../resources/houses/house6.png")
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
                            var houseString = "../../../../resources/houses/house" + Math.round(Math.random() * 5 + 1) + ".png"
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

                source: "../../../../resources/hatCartoon.png"
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
    }

    Item {
        id: footer

        width: parent.width
        height: cursors.itemHeight + header.height
        anchors.bottom: parent.bottom

        Text {
            id: header

            font.family: appTheme.fontFamily
            font.pixelSize: 12
            color: "gray"
            text: "Mark the problem's structural elements"

            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height:  20
            visible: false
        }

        Item {
            id: buttons
            width: parent.width
            height: cursors.itemHeight
            anchors.bottom: parent.bottom
            visible: false

            ListView {
                id: cursors

                property int buttonSize: 60
                property int buttonTextHeight: 40
                property int internalSpaceHeight: 15
                property int itemHeight: buttonSize + buttonTextHeight + internalSpaceHeight
                property string color: currentIndex === 0 ?  "#FFFF01" : (currentIndex === 1 ? "#b6e8e5" : "#F0A9ED")

                orientation: Qt.Horizontal
                width: itemHeight * 3 + spacing * 2
                interactive: false
                model: 3
                height: parent.height
                currentIndex: 0

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
                                    return "../../../../resources/check.png"
                                else if (index === 1 && results.sCond)
                                    return "../../../../resources/check.png"
                                else if (index === 2  && results.cCond)
                                    return "../../../../resources/check.png"
                                else return "../../../../resources/draw.png"
                            }

                            mipmap: true
                        }

                        MouseArea {
                            visible: index === 0 ? !results.uCond : (index === 1 ? !results.sCond : !results.cCond )
                            anchors.fill: parent

                            onClicked: {
                                cursors.currentIndex = index

                                pressDetector.reset()
                                canvas.requestPaint()
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
                        text: index === 0 ? "Unknown" : (index === 1 ? "Starter" : "Changer")
                    }
                }
            }
        }
    }
}
