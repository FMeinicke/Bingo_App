//============================================================================
/// \file   BingoCardForm.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A form displaying one bingo score card
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import QtGraphicalEffects 1.0
import de.dhge.moco.fm.ScoreCardModel 1.0

Item {
  id: root

  width: 350
  height: 420

  property alias model: scoreCardModel

  state: model.hasBingo ? "bingo" : ""

  states: [
    State {
      name: "bingo"
      PropertyChanges {
        target: bingoImage
        opacity: 1
        scale: 1
      }
    }
  ]

  transitions: [
    Transition {
      to: "bingo"
      SequentialAnimation {
        PauseAnimation {
          // wait unil the number fields that are part of the bingo finished blinking
          duration: 3000
        }

        ParallelAnimation {
          id: bingoImageAnimation
          property int duration: 350
          PropertyAnimation {
            target: bingoImage
            property: "opacity"
            to: 1
            duration: bingoImageAnimation.duration
          }
          PropertyAnimation {
            target: bingoImage
            property: "scale"
            to: 1
            duration: bingoImageAnimation.duration
          }
        }
      }
    }
  ]

  Image {
    id: backgroundImage

    property int padding: 22
    property double ratio: (height + padding) / implicitHeight
    property int cellSize: 100 * ratio

    fillMode: Image.PreserveAspectFit
    anchors.fill: parent

    // image taken from https://www.wikihow.com/Sample/Blank-Bingo-Card
    source: "qrc:/images/score_card.png"
  }

  Image {
    id: bingoImage
    fillMode: Image.PreserveAspectFit
    anchors.fill: gridView

    opacity: 0
    scale: 0.5

    source: "qrc:/images/bingo.png"

    z: 1
    rotation: -23
  }

  DropShadow {
    anchors.fill: bingoImage

    horizontalOffset: 3
    verticalOffset: 10

    radius: 8.0
    samples: 17
    color: "#aa000000"

    opacity: bingoImage.opacity
    scale: bingoImage.scale

    source: bingoImage

    z: 1
    rotation: -23
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

    model: ScoreCardModel {
      id: scoreCardModel
    }

    delegate: ScoreCardDelegate {
      height: gridView.cellHeight
      width: gridView.cellWidth
    }
  }
}
