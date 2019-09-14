//============================================================================
/// \file   CustomCardsForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for entering all of the numbers on a bingo card.
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
  width: 411
  height: 617
  title: qsTr("Custom Cards")

  Label {
    text: qsTr("You are on Custom Cards.")
    anchors.centerIn: parent
  }
}
