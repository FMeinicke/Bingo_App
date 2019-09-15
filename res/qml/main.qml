import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

ApplicationWindow {
  id: window
  visible: true
  width: Screen.width
  height: Screen.height
  title: qsTr("Stack")

  property int wHeight: 960
  property int wWidth: 540

  header: Text {
    id: appName
    text: qsTr("Mobile Bingo")
    height: 40
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
      interval: 3000
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
      timeout: 1500
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
