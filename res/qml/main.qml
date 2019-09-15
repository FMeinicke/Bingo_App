import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3

ApplicationWindow {
  id: window
  visible: true
  width: Screen.width
  height: Screen.height

  header: ToolBar {
    contentHeight: label.height

    ToolButton {
      id: toolButton

      Rectangle {
        width: label.height
        height: label.height
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
    }

    Label {
      id: label
      text: qsTr("Mobile Bingo")
      font.pixelSize: Qt.application.font.pixelSize * 1.6
      color: "black"

      height: 50
      width: window.width
      verticalAlignment: Text.AlignVCenter
      horizontalAlignment: Text.AlignHCenter
    }
  }

  Drawer {
    id: drawer
    x: 0
    y: header.implicitHeight
    width: window.width * 0.66
    height: window.height - header.implicitHeight

    Column {
      anchors.fill: parent

      ItemDelegate {
        text: qsTr("Settings")
        width: parent.width
        anchors.verticalCenterOffset: height / 2 - 50
        topPadding: window.height

        icon.source: "qrc:/images/settings.png"

        onClicked: {
          stackView.push("SettingsForm.ui.qml")
          drawer.close()
        }
      }
    }
  }

  StackView {
    id: stackView
    anchors.fill: parent

    initialItem: "ChooseGameForm.ui.qml"

    // Implements back key navigation
    focus: true
    property bool wantsQuit: false

    Timer {
      id: timer
      interval: 2000
      running: stackView.wantsQuit
      repeat: false
      onTriggered: {
        // user didn't press back twice within the small intervall - doesn't want to quit
        stackView.wantsQuit = false
      }
    }

    ToolTip {
      id: quitMsg
      text: qsTr("Press again to quit...")
      y: parent.height - 50
      visible: stackView.wantsQuit
      timeout: 2100
      delay: 500

      onClosed: {
        if (stackView.wantsQuit) {
          // user pressed back button twice within a small intervall- quit app
          window.close()
        }
      }
    }

    Keys.onBackPressed: {
      if (depth > 1) {
        // if not on the main page, don't close the app on back key press
        // just go back one page
        wantsQuit = false
        pop()
      } else if (!wantsQuit) {
        // close on next back button press
        wantsQuit = true
      } else if (timer.running === true) {
        // user pressed back button twice within a small intervall- quit app
        window.close()
      }
    }
  }
}
