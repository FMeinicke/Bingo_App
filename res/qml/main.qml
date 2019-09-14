import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

ApplicationWindow {
  id: window
  visible: true
  width: ScreenInfo.width
  height: ScreenInfo.height
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

    // Implements back key navigation
    focus: true

    initialItem: "ChooseGameForm.ui.qml"

    property bool wantsQuit: false

    ToolTip {
      id: quitMsg
      text: qsTr("Press again to quit...")

      // don't steal focus from the stackView
      focus: false
      y: parent.height - 50
      visible: wantsQuit
      timeout: 3000
      delay: 500
    }

    Keys.onBackPressed: {
      if (depth > 1) {
        wantsQuit = false
        // if not on the main page, don't close the app on back key press
        // just go back one page
        pop()
      } else if (!wantsQuit) {
        // close on next back button press
        wantsQuit = true
        quitMsg.open()
        // don't lose focus to the message
        forceActiveFocus()
      } else {
        // user pressed back button twice - quit app
        window.close()
      }
    }
  }
}
