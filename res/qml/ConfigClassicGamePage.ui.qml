//============================================================================
/// \file   ConfigClassicGamePage.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A page for configuring the classic mode of the bingo game
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
  id: page
  width: 411
  height: 617

  title: qsTr("Classic Game")
  ColumnLayout {
    id: columnLayout
    anchors.fill: parent

    MenuButton {
      id: buttonRandom
      title: "Random\n Score Cards"
      font.pointSize: 15
      qmlFile: "BingoGame.qml"
    }

    MenuButton {
      id: buttonCustom
      title: "Custom\n Score Cards"
      font.pointSize: 15
      qmlFile: "CustomCardsPage.qml"
    }

    MenuButton {
      id: buttonScan
      title: "Scan\n Score Cards"
      font.pointSize: 15
      qmlFile: "ScanCardsPage.qml"
    }
  }
}
