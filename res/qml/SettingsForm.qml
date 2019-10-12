//============================================================================
/// \file   SettingsForm.qml
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

  GroupBox {
    id: gameSettingsBox

    property int offset: 30
    font.pointSize: Qt.application.font.pixelSize * 1.4

    title: qsTr("Game Settings")

    anchors.top: parent.top
    anchors.topMargin: offset
    anchors.right: parent.right
    anchors.rightMargin: offset
    anchors.left: parent.left
    anchors.leftMargin: offset

    ColumnLayout {
      anchors.fill: parent
      CheckBox {
        text: qsTr("Detect diagonal Bingo")
        font.pixelSize: Qt.application.font.pixelSize

        Component.onCompleted: {
          checked = ScoreCardSettings.detectDiagonal
        }

        onCheckedChanged: {
          console.log("hello")
          ScoreCardSettings.detectDiagonal = checked
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

