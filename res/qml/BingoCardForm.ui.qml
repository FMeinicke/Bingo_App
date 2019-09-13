//============================================================================
/// \file   BingoCardForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A form displaying one bingo score card
//============================================================================
import QtQuick 2.4

Item {
  width: 350
  height: 420

  GridView {
    id: gridView
    interactive: false
    anchors.fill: parent
    model: scoreCardModel
    delegate: Item {
      x: 5
      height: 50
      Text {
        x: 5
        text: model.modelData.number
        font.bold: true
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }
    cellHeight: 70
    cellWidth: 70
  }
}

/*##^##
Designer {
    D{i:1;anchors_height:140;anchors_width:140;anchors_x:127;anchors_y:149}
}
##^##*/

