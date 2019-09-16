//============================================================================
/// \file   BingoCardForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A form displaying one bingo score card
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import de.dhge.moco.fm.ScoreCardNumberField 1.0

Item {
  id: root

  width: 350
  height: 420

  Image {
    id: backgroundImage

    property int padding: 22
    property double ratio: (height + padding) / implicitHeight
    property int cellSize: 100 * ratio

    fillMode: Image.PreserveAspectFit

    // image taken from https://www.wikihow.com/Sample/Bingo-Card
    source: "qrc:/images/score_card.png"
    anchors.fill: parent
  }

  GridView {
    id: gridView
    interactive: false
    cellHeight: backgroundImage.cellSize
    cellWidth: backgroundImage.cellSize
    width: 5 * cellWidth
    height: 5 * cellHeight
    x: backgroundImage.padding
    y: backgroundImage.cellSize + 3 * backgroundImage.padding / 2

    model: scoreCardModel
    delegate: Item {
      id: wrapper
      width: gridView.cellWidth
      height: gridView.cellHeight
      Text {
        property int numberData: model.modelData.number
        property int fieldTypeData: model.modelData.fieldType
        property int markedData: model.modelData.marked

        // center field is a free field -> it's number shouldn't be displayed
        text: fieldTypeData === ScoreCardNumberFieldType.FREE_SPACE ? "" : numberData
        font.bold: true
        fontSizeMode: Text.Fit
        font.pixelSize: 30
        minimumPixelSize: 12
        anchors.centerIn: parent
      }
    }
  }
}
