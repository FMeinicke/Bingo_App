//============================================================================
/// \file   BingoCardForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A form displaying one bingo score card
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3

Item {
  id: root

  width: 350
  height: 420

  Image {
    id: backgroundImage

    property int padding: 22
    fillMode: Image.PreserveAspectFit

    // image from https://www.wikihow.com/Sample/Bingo-Card
    source: "qrc:/images/score_card.png"
    anchors.fill: parent
  }

  GridView {
    id: gridView
    interactive: false
    width: 5 * cellWidth
    height: 5 * cellHeight
    x: backgroundImage.padding
    y: root.height - height - backgroundImage.padding / 2

    model: scoreCardModel
    cellHeight: 63
    cellWidth: 61
    delegate: Item {
      id: wrapper
      width: gridView.cellWidth
      height: gridView.cellHeight
      Text {
        property int numberData: model.modelData.number

        // center field is a free field and has '0' as data -> shouldn't be displayed
        text: numberData > 0 ? numberData : ""
        font.bold: true
        fontSizeMode: Text.Fit
        font.pixelSize: 30
        minimumPixelSize: 12
        anchors.centerIn: parent
      }
    }
  }
}
