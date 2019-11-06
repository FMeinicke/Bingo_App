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
/// \file   CustomCardsPage.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for entering all of the numbers on a bingo card.
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.3
import de.dhge.moco.fm.ScoreCardModel 1.0

Page {
  id: root
  title: qsTr("Custom Cards")

  width: Screen.width
  height: Screen.height
  focusPolicy: Qt.StrongFocus

  property int offset: 75

  property var customModels: []

  StackView.onActivating: {
    customModels.splice(0)
    scoreCard.scoreCardModel.clearCard()
  }

  function addModel() {
    customModels.push(scoreCard.scoreCardModel)
  }

  Label {
    id: description

    anchors.top: parent.top
    anchors.topMargin: 0.15 * root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    text: qsTr("Enter the numbers on your scorecard into the \n"
               + "corresponding fields of the card below")
    font.pixelSize: Qt.application.font.pixelSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
  }

  BingoCardForm {
    id: scoreCard

    scale: 0.6

    anchors.top: parent.top
    anchors.topMargin: -0.25 * root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    state: "edit"
  }

  Button {
    id: buttonDone
    text: qsTr("Done && Play")
    font.pointSize: 14
    enabled: scoreCard.scoreCardModel.isValid

    anchors.top: scoreCard.bottom
    anchors.topMargin: -root.offset
    anchors.left: parent.left
    anchors.leftMargin: 2 * root.offset / 3

    onClicked: {
      addModel()
      stackView.push("BingoGame.qml", {
                       "customModels": customModels
                     })
    }
  }

  Button {
    id: buttonNext
    text: qsTr("Next Card")
    font.pointSize: 14

    anchors.top: scoreCard.bottom
    anchors.topMargin: -root.offset
    anchors.right: parent.right
    anchors.rightMargin: 2 * root.offset / 3

    onClicked: {
      addModel()
      let newScoreCardModel = Qt.createQmlObject(
            "import de.dhge.moco.fm.ScoreCardModel 1.0; ScoreCardModel{}",
            scoreCard)
      newScoreCardModel.clearCard()
      scoreCard.scoreCardModel = newScoreCardModel
    }
  }
}
