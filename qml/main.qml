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
    minimumHeight: height
    minimumWidth: width

    title: qsTr("Thinking Hat")

    QtObject {
        id: appGlobal

        readonly property bool debug: false
        readonly property string initialScreen: "views/homeView.qml"

        property string userName: ""
        property int userAge: 0
        property string avatar: ""
        property string drawPre: ""
        property string drawPost: ""
        property string problemName: ""
        property string problemStatment: ""
        property var problemUnkown: []
        property var problemStartingPoint: []
        property var problemChanger: []
        property string problemPickedChanger: ""
        property string problemPickedUnknown: ""
        property string problemPickedStarting: ""
        property int problemSolution: -1

        Component.onCompleted: {
            if (debug) {
                userAge = 7
                avatar = "../../resources/avatars/001.png"
                problemName = "Debug Problem"
                problemStatment = "Madre ha horneado 20 magdalenas. ¿Cuántas magdalenas quedan para mi si mis 2 hermanos mayores ya se han comido 8 magdalenas cada uno?"
                problemUnkown = ["¿Cuántas magdalenas quedan para mi", "¿Cuántas magdalenas quedan"]
                problemStartingPoint = ["20 magdalenas.", "Madre ha horneado 20 magdalenas."]
                problemChanger = ["mis 2 hermanos mayores ya se han comido 8 magdalenas cada uno?"]
                problemSolution = 4
                problemPickedUnknown = "¿Cuántas magdalenas quedan para mi"
                problemPickedChanger = "mis 2 hermanos mayores ya se han comido 8 magdalenas cada uno?"
                problemPickedStarting = "Madre ha horneado 20 magdalenas."
            }
        }
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
        initialItem: appGlobal.initialScreen
        anchors.fill: parent
    }
}
