import QtQuick 2.10
import QtQuick.Controls 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 680
    title: qsTr("Thinking Hat")

    font.family: "Droid Sans Mono"

    QtObject {
        id: appGlobal

        property string userName: ""
        property int userAge: 0
        property string avatar: ""
        property string drawPre: ""
        property string drawPost: ""
    }

    StackView {
        id: stackView
        initialItem: "views/homeView.qml"
        anchors.fill: parent
    }
}
