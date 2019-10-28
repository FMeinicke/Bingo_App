//============================================================================
/// \file   ScanCardsPage.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for scanning all of the numbers on a bingo card.
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12

Page {
  id: root

  property int offset: 75

  width: Screen.width
  height: Screen.height

  state: cameraUI.state

  states: [
    State {
      name: "Capture"
      PropertyChanges {
        target: buttonDone
        enabled: false
      }
      PropertyChanges {
        target: buttonNext
        enabled: false
      }
    },
    State {
      name: "Preview"
      PropertyChanges {
        target: buttonDone
        enabled: true
      }
      PropertyChanges {
        target: buttonNext
        enabled: true
      }
    }
  ]

  GridLayout {
    rows: 3
    columns: 2

    anchors.top: parent.top
    anchors.topMargin: 0.15 * root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      id: description

      Layout.columnSpan: 2
      text: qsTr("Position your Bingo scorecard to fit into \n"
                 + "the view below. \nHit the capture button to scan a card.")
      font.pixelSize: Qt.application.font.pixelSize
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      Layout.fillWidth: true
    }

    CameraUI {
      id: cameraUI

      width: 350
      height: 470

      Layout.alignment: Qt.AlignHCenter
      Layout.columnSpan: 2
    }

    Button {
      id: buttonDone

      Layout.alignment: Qt.AlignLeft
      Layout.leftMargin: root.offset / 3

      text: qsTr("Done && Play")
      font.pointSize: 14
    }

    Button {
      id: buttonNext

      Layout.alignment: Qt.AlignRight
      Layout.rightMargin: root.offset / 3

      text: qsTr("Next Card")
      font.pointSize: 14
    }
  }
}
