import QtQuick 2.10
import QtQuick.Controls 2.2

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 480
    title: qsTr("Thinking Hat")

    font.family: "Droid Sans Mono"

    QtObject {
        id: appGlobal

        property string userName: ""
        property int userAge: 0
        property string avatar: ""
    }

    StackView {
        id: stackView
        initialItem: "views/homeView.qml"
        anchors.fill: parent
    }
}
