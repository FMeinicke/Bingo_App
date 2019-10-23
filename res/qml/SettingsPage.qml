//============================================================================
/// \file   SettingsPage.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   10.10.2019
/// \brief  A page for the app's settings
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import de.dhge.moco.fm.ScoreCardSettings 1.0

Page {
  id: root

  RowLayout {
    property int offset: 30

    anchors.top: parent.top
    anchors.topMargin: offset
    anchors.right: parent.right
    anchors.rightMargin: offset
    anchors.left: parent.left
    anchors.leftMargin: offset

    GroupBox {
      id: gameSettingsBox

      font.pixelSize: Qt.application.font.pixelSize * 1.4

      title: qsTr("Game Settings")

      GridLayout {
        columnSpacing: 6
        columns: 2
        anchors.fill: parent

        Label {
          text: qsTr("Number of Bingo scorecards")
          font.pixelSize: Qt.application.font.pixelSize
          Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        SpinBox {
          from: 1
          to: 20

          Layout.preferredWidth: 120
          font.pixelSize: Qt.application.font.pixelSize

          Component.onCompleted: {
            value = ScoreCardSettings.numScoreCards
          }

          onValueModified: {
            ScoreCardSettings.numScoreCards = value
          }
        }

        Label {
          text: qsTr("Detect diagonal Bingo")
          font.pixelSize: Qt.application.font.pixelSize
          Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
        }

        CheckBox {
          Component.onCompleted: {
            checked = ScoreCardSettings.detectDiagonal
          }

          onCheckedChanged: {
            ScoreCardSettings.detectDiagonal = checked
          }
        }
      }
    }
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:200;anchors_width:200;anchors_x:229;anchors_y:95}
}
##^##*/

