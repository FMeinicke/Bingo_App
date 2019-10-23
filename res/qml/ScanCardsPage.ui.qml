//============================================================================
/// \file   ScanCardsPage.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for scanning all of the numbers on a bingo card.
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
  width: 411
  height: 617
  title: qsTr("Scan Cards")

  Label {
    text: qsTr("You are on Scan Cards.")
    anchors.centerIn: parent
  }
}
