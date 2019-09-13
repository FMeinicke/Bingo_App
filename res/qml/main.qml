import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
  id: window
  visible: true
  width: 411
  height: 617
  title: qsTr("Stack")

  property int wHeight: 960
  property int wWidth: 540

  header: ToolBar {
    contentHeight: toolButton.implicitHeight

    ToolButton {
      id: toolButton

      Rectangle {
        width: 40
        height: 40
        color: "transparent"

        MouseArea {
          anchors.fill: parent
          onClicked: {
            menuBackIcon.state = menuBackIcon.state === "menu" ? "back" : "menu"
            if (stackView.depth > 1) {
              stackView.pop()
            } else if (drawer.position === 1.0) {
              drawer.close()
            } else {
              drawer.open()
            }
          }
        }

        MenuBackIcon {
          id: menuBackIcon
          anchors.centerIn: parent
        }
      }

      font.pixelSize: Qt.application.font.pixelSize * 1.6
    }

    Label {
      text: stackView.currentItem.title
      anchors.centerIn: parent
    }
  }

  Drawer {
    id: drawer
    x: 0
    y: toolButton.implicitHeight
    width: window.width * 0.66
    height: window.height - toolButton.implicitHeight

    Column {
      anchors.fill: parent

      ItemDelegate {
        text: qsTr("New Game")
        width: parent.width
        onClicked: {
          stackView.push("NewGameForm.ui.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: qsTr("Scan Cards")
        width: parent.width
        onClicked: {
          stackView.push("ScanCardsForm.ui.qml")
          drawer.close()
        }
      }
    }
  }

  StackView {
    id: stackView
    initialItem: "HomeForm.qml"
    anchors.fill: parent
  }
}
