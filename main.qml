import QtQuick 2.10
import QtQuick.Controls 2.2

import QtQuick.Window 2.3

ApplicationWindow {
    id: window
    visible: true
    width: appTheme.refWidthScreen
    height: appTheme.refHeightScreen
    maximumHeight: height
    maximumWidth: width

    title: qsTr("Thinking Hat")

    QtObject {
        id: appGlobal

        property string userName: ""
        property int userAge: 0
        property string avatar: ""
        property string drawPre: ""
        property string drawPost: ""
        property string problemStatment: "Tengo 12 casas de montaña y el juez me quita 6 para mi exmujer. ¿Cuántas casas me quedan?"
        property var problemUnkown: ["¿Cuántas casas me quedan?"]
        property var problemStartingPoint: ["12 casas", "12 casas de montaña"]
        property var problemChanger: ["me quita 6", "quita 6"]
    }

    QtObject {
        id: appTheme

        readonly property int refWidthScreen: 411
        readonly property int refHeightScreen: 721
        readonly property int widthScreen: Screen.width
        readonly property int heightScreen: Screen.height
        readonly property int hScale: Screen.width
        readonly property int vScale: Screen.height
        readonly property string fontFamily: "Montserrat"
        readonly property string fontColorBlack: "#111111"
        readonly property string fontColorBlackSoft: "#303030"
        readonly property string fontColorGray: "#656565"
        readonly property string fontColorGraySoft: "#9B9B9B"
        readonly property string fontColorWhite: "#fefefe"
        readonly property string fontColorBlue: "#4a90e2"
        readonly property string fontColorRed: "#f0495e"
        readonly property string fontColorOrange: "#F5A623"
        readonly property string  colorUnknown: "#FFFF01"
        readonly property string  colorStartingPoint: "#b6e8e5"
        readonly property string  colorChanger: "#F0A9ED"
        readonly property int fontHuge: 32
        readonly property int fontGrand: 28
        readonly property int fontBig: 23
        readonly property int fontMedium: 21
        readonly property int fontSmall: 18
        readonly property int fontTiny: 15
        readonly property int margin: 40
    }

    FontLoader {
        id: montserrat

        source: "../resources/fonts/Montserrat-Medium.ttf"
    }

    font.family: appTheme.fontFamily

    StackView {
        id: stackView
        initialItem: "views/problems/theCake.qml"
        anchors.fill: parent
    }
}
