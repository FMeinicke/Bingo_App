//============================================================================
/// \file   HomeForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  The landing page that appears when the app is started
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
  width: 411
  height: 617
  title: qsTr("Home")

  ColumnLayout {
    id: columnLayout
    anchors.fill: parent

    MenuButton {
      title: "New Game"
      qmlFile: "NewGameForm.ui.qml"
    }

    MenuButton {
      title: "Scan Cards"
      qmlFile: "ScanCardsForm.ui.qml"
    }

    MenuButton {
      title: "Rules"
      qmlFile: "RulesForm.ui.qml"
    }
  }
}
