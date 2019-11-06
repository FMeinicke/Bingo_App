/**
 ** This file is part of the "Mobile Bingo" project.
 ** Copyright (c) 2019 Florian Meinicke <florian.meinicke@t-online.de>.
 **
 ** Permission is hereby granted, free of charge, to any person obtaining a copy
 ** of this software and associated documentation files (the "Software"), to deal
 ** in the Software without restriction, including without limitation the rights
 ** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 ** copies of the Software, and to permit persons to whom the Software is
 ** furnished to do so, subject to the following conditions:
 **
 ** The above copyright notice and this permission notice shall be included in all
 ** copies or substantial portions of the Software.
 **
 ** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 ** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 ** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 ** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 ** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 ** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 ** SOFTWARE.
 **/

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
import de.dhge.moco.fm.ScoreCardModel 1.0

Item {
  id: root

  width: 350
  height: 420

  property ScoreCardModel scoreCardModel
  property bool isValid: scoreCardModel.isValid

  Component.onCompleted: {
    // create a new random scorecard if we don't get a custom card from the user
    if (!scoreCardModel) {
      scoreCardModel = Qt.createQmlObject(
            "import de.dhge.moco.fm.ScoreCardModel 1.0; ScoreCardModel{}", this)
    }
  }

  state: scoreCardModel.hasBingo ? "bingo" : ""

  states: [
    State {
      name: "bingo"
      PropertyChanges {
        target: bingoImage

        opacity: 1
        scale: 1
      }
    },
    State {
      name: "edit"
      PropertyChanges {
        target: gridView

        focus: true
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

  ToolTip {
    id: errorMsg
    anchors.centerIn: parent
    visible: false
    timeout: 3000
    delay: 500

    contentItem: Text {
      text: errorMsg.text
      color: "white"
      wrapMode: Text.WordWrap
      horizontalAlignment: Text.AlignHCenter
    }
  }

  GridView {
    id: gridView

    property alias errorMsg: errorMsg

    state: root.state

    interactive: false
    keyNavigationWraps: true
    flow: GridView.FlowTopToBottom

    x: backgroundImage.padding
    y: backgroundImage.cellSize + 3 * backgroundImage.padding / 2
    cellHeight: backgroundImage.cellSize
    cellWidth: backgroundImage.cellSize
    width: 5 * cellWidth
    height: 5 * cellHeight

    model: scoreCardModel

    delegate: ScoreCardDelegate {
      height: gridView.cellHeight
      width: gridView.cellWidth
    }

    highlight: Rectangle {
      visible: root.state === "edit"
      color: Material.color(Material.Teal, Material.Shade300)
      opacity: 0.7
      radius: 5
    }

    Component.onCompleted: currentIndex = -1
  }
}
