//============================================================================
/// \file   BingoCardForm.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A form displaying one bingo score card
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
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

    // image taken from https://www.wikihow.com/Sample/Blank-Bingo-Card
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

      property color bingoColor: Material.color(Material.Red)
      property color markingColor: partOfBingo ? bingoColor : Material.primary

      Behavior on markingColor {
        id: bingoAnimation

        property int duration: 450

        SequentialAnimation {
          loops: 1

          running: partOfBingo

          ColorAnimation {
            to: bingoColor
            duration: bingoAnimation.duration
          }

          SequentialAnimation {
            loops: 3

            ColorAnimation {
              from: bingoColor
              to: markingColor
              duration: bingoAnimation.duration
            }
            ColorAnimation {
              from: markingColor
              to: bingoColor
              duration: bingoAnimation.duration
            }
          }
        }
      }

      Text {
        // center field is a free field -> it's number shouldn't be displayed
        text: fieldType === ScoreCardNumberFieldType.FREE_SPACE ? "" : number
        font.bold: true
        fontSizeMode: Text.Fit
        font.pixelSize: 30
        minimumPixelSize: 12
        anchors.centerIn: parent
      }
      Rectangle {
        id: marking

        // center field is a free field -> marked by default but shouldn't be displayed
        visible: fieldType === ScoreCardNumberFieldType.FREE_SPACE ? false : marked

        anchors.fill: parent
        scale: 0.9

        color: markingColor

        opacity: 0.5
        radius: 50
      }

      InnerShadow {
        source: marking
        anchors.fill: marking
        visible: marking.visible

        radius: 2.0
        samples: 16
        horizontalOffset: -7
        verticalOffset: 7

        color: "#b0000000"
        opacity: marking.opacity
      }
    }
  }
}
