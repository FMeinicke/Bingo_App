/**
 ** This file is part of the "Mobile Bingo" project.
 ** Copyright (c) 2019 Florian Meinicke <florian.meinicke@t-online.de>.
 **
 ** Permission is hereby granted, free of charge, to any person obtaining a copy
 ** of this software and associated documentation files (the "Software"), to deal
 ** in the Software without restriction, including without limitation the rights
 ** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 ** copies of the Software, and to permit persons to whom the Software is
 ** furnished to do so, subject to the following conditions:
 **
 ** The above copyright notice and this permission notice shall be included in all
 ** copies or substantial portions of the Software.
 **
 ** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 ** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 ** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 ** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 ** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 ** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 ** SOFTWARE.
 **/

//============================================================================
/// \file   main.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  The starting screen of the app
//============================================================================
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
      onTriggered: stackView.push("SettingsPage.qml")
    }

    MenuItem {
      text: qsTr("About")
      onTriggered: stackView.push("AboutPage.qml")
    }

    onClosed: toolButton.menuOpened = false
  }

  StackView {
    id: stackView

    anchors.fill: parent

    initialItem: "ConfigClassicGamePage.ui.qml" //"ChooseGamePage.ui.qml"

    // Implements back key navigation
    focus: true
    property bool wantsQuit: false

    onFocusChanged: {
      if (!focus) {
        forceActiveFocus()
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
          // user pressed back button twice within a small intervall - quit app
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
      }
    }
  }
}
