import QtQuick 2.12
import QtQuick.Controls 2.5

ApplicationWindow {
  id: window
  visible: true
  width: 640
  height: 480
  title: qsTr("Stack")

  header: ToolBar {
    contentHeight: toolButton.implicitHeight

    ToolButton {
      id: toolButton

      property url hamburgerIcon: "qrc:/images/hamburger.png"
      property url backIcon: "qrc:/images/back.png"

      display: "IconOnly"
      icon.color: "transparent"
      icon.source: stackView.depth > 1 ? backIcon : hamburgerIcon

      font.pixelSize: Qt.application.font.pixelSize * 1.6
      onClicked: {
        if (stackView.depth > 1) {
          stackView.pop()
        } else {
          drawer.open()
        }
      }
    }

    Label {
      text: stackView.currentItem.title
      anchors.centerIn: parent
    }
  }

  Drawer {
    id: drawer
    width: window.width * 0.66
    height: window.height

    Column {
      anchors.fill: parent

      ItemDelegate {
        text: qsTr("Page 1")
        width: parent.width
        onClicked: {
          stackView.push("Page1Form.ui.qml")
          drawer.close()
        }
      }
      ItemDelegate {
        text: qsTr("Page 2")
        width: parent.width
        onClicked: {
          stackView.push("Page2Form.ui.qml")
          drawer.close()
        }
      }
    }
  }

  StackView {
    id: stackView
    initialItem: "HomeForm.ui.qml"
    anchors.fill: parent
  }
}
