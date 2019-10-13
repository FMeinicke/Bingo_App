import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Layouts 1.12

ApplicationWindow {
  id: window

  visible: true
  width: Screen.width
  height: Screen.height

  header: ToolBar {
    contentHeight: label.height

    RowLayout {
      anchors.fill: parent

      Label {
        id: label

        text: qsTr("Mobile Bingo")
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        color: "black"

        height: 50
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        Layout.fillWidth: true
      }

      ToolButton {
        id: toolButton

        property bool menuOpened: false

        onClicked: {
          if (menuOpened) {
            menu.close()
          } else {
            menu.open()
          }
          menuOpened = !menuOpened
        }

        MenuIcon {
          id: menuIcon

          anchors.fill: parent
        }
      }
    }
  }

  Menu {
    id: menu

    x: label.width

    MenuItem {
      text: qsTr("Settings")
      onTriggered: stackView.push("SettingsForm.qml")
    }

    MenuItem {
      text: qsTr("About")
      onTriggered: stackView.push("AboutForm.qml")
      enabled: false
    }

    onClosed: toolButton.menuOpened = false
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
