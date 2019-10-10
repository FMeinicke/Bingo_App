//============================================================================
/// \file   ChooseGameForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for choosing between the different game modes
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
  id: page
  width: 411
  height: 617

  title: qsTr("Home")

  ColumnLayout {
    id: columnLayout
    anchors.fill: parent

    MenuButton {
      id: buttonClassic
      title: "Classic Game"
      qmlFile: "ConfigClassicGameForm.ui.qml"
    }

    MenuButton {
      id: buttonBlackout
      title: "Blackout"
      enabled: false
    }

    MenuButton {
      id: buttonTournament
      title: "Tournament"
      enabled: false
    }
  }
}
