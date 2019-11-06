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
/// \file   BingoGame.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  The main game page with all bingo score cards and a field to enter
/// the called-out number
//============================================================================
import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick.Dialogs 1.2
import de.dhge.moco.fm.ScoreCardModel 1.0
import de.dhge.moco.fm.ScoreCardSettings 1.0

Page {
  id: root

  property var customModels: []

  width: Screen.width
  height: Screen.height
  focusPolicy: Qt.StrongFocus

  state: customModels.length > 0 ? "custom" : ""

  states: [
    State {
      name: "custom"
    }
  ]

  MessageDialog {
    id: confirmLeaveDialog

    title: qsTr("Leave Game")
    text: qsTr("Do you really want to leave the game?")
    informativeText: qsTr("You will lose all your current cards and marks!")
    standardButtons: StandardButton.Yes | StandardButton.No

    onButtonClicked: {
      if (clickedButton === StandardButton.Yes) {
        stackView.pop()
      }
    }
  }

  property int offset: 75

  Component.onCompleted: scoreCardsView.newCards()

  Keys.onBackPressed: confirmLeaveDialog.open()

  GridLayout {
    rows: 4
    columns: 3

    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

    Label {
      id: markedCardsInfo

      property color bgColor: "#d02e2e2e"

      visible: scoreCardsView.bingoCards.length > 1

      Layout.columnSpan: 3
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: root.offset / 4
      Layout.minimumHeight: 50
      Layout.fillWidth: true

      font.pointSize: Qt.application.font.pointSize
      wrapMode: Text.WordWrap
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter

      color: "white"
      background: Rectangle {
        anchors.fill: parent

        Behavior on color {
          ColorAnimation {
            duration: 750
          }
        }

        color: root.background.color
        radius: 5
      }

      function show(msg) {
        text = msg
        background.color = markedCardsInfo.bgColor
        timer.restart()
      }

      function hide() {
        text = ""
        background.color = root.background.color
      }

      Timer {
        id: timer

        interval: 5000
        running: markedCardsInfo.state === "visible"

        onTriggered: markedCardsInfo.hide()
      }
    }

    SwipeView {
      id: scoreCardsView

      property var bingoCards: contentChildren

      scale: 0.6
      height: 420
      width: 350

      Layout.columnSpan: 3
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: -root.offset

      spacing: 0

      Repeater {
        id: repeater

        model: customModels.length > 0 ? customModels.length : ScoreCardSettings.numScoreCards

        BingoCardForm {
          // scoreCardModel will be undefined if there is no custom model
          // -> BingoCardForm will create a new model with random fields
          scoreCardModel: customModels[index]
        }
      }

      // checks if any of the bingo scorecards has a bingo
      function hasBingo() {
        for (var i = 0; i < bingoCards.length; i++) {
          if (bingoCards[i].scoreCardModel.hasBingo) {
            // scroll to the scorecard with the bingo
            scoreCardsView.setCurrentIndex(i)
            return true
          }
        }
        return false
      }

      // marks the given num on all of the scorecards and shows an error if num is invalid
      function markValidNumberOnAll(num) {
        numberInput.clear()
        let markedCards = []
        for (var i = 0; i < bingoCards.length; i++) {
          const cardModel = bingoCards[i].scoreCardModel
          if (cardModel.markValidNumber(num)) {
            markedCards.push(i + 1)
          }
          cardModel.checkForBingo()
        }

        // display on which cards the number was marked
        if (markedCards.length > 0) {
          var infoText = qsTr("Found number %1 on card").arg(num)
          infoText += (markedCards.length > 1 ? "s" : "") // 's' suffix for multiple cards

          for (var j = 0; j < markedCards.length; j++) {
            infoText += qsTr(" %1,").arg(markedCards[j])
          }

          markedCardsInfo.show(infoText.slice(0, -1))
        }
      }

      // removes all markers from every card
      function clearAllCards() {
        for (var i = 0; i < bingoCards.length; i++) {
          bingoCards[i].scoreCardModel.removeAllMarkers()
        }
      }

      // give new cards
      function newCards() {
        for (var i = 0; i < bingoCards.length; i++) {
          bingoCards[i].scoreCardModel.newCard()
        }
      }

      ToolTip {
        id: errorMsg

        anchors.centerIn: scoreCardsView
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
    }

    PageIndicator {
      id: indicator

      visible: count > 1

      Layout.columnSpan: 3
      Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
      Layout.topMargin: -root.offset

      count: scoreCardsView.count
      currentIndex: scoreCardsView.currentIndex

      interactive: true
      onCurrentIndexChanged: scoreCardsView.setCurrentIndex(currentIndex)
    }

    Button {
      id: buttonNewCard

      text: qsTr("New Cards")
      font.pointSize: 14

      Layout.minimumWidth: buttonResetCard.width
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: -root.offset

      MessageDialog {
        id: confirmNewCardsDialog

        title: qsTr("Get new cards")
        text: qsTr("Do you really want to get new cards?")
        informativeText: qsTr("You will lose all your current cards!")
        standardButtons: StandardButton.Yes | StandardButton.No

        onButtonClicked: {
          if (clickedButton === StandardButton.Yes) {
            if (root.state === "custom") {
              stackView.pop()
            } else {
              scoreCardsView.newCards()
            }
          }
        }
      }

      onClicked: confirmNewCardsDialog.open()
    }

    TextField {
      id: numberInput

      width: height

      Layout.maximumWidth: 50
      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: -root.offset

      Component.onCompleted: {
        enabled = Qt.binding(function () {
          return !scoreCardsView.hasBingo()
        })
      }

      cursorVisible: false

      placeholderText: "13"

      font.bold: true
      font.pointSize: 24
      horizontalAlignment: Text.AlignHCenter

      // allow multiline input to keep the keyboard open after hitting enter
      inputMethodHints: Qt.ImhDigitsOnly | Qt.ImhMultiLine
      validator: IntValidator {
        id: intValidator

        bottom: 1
        top: 75
      }

      onPressed: clear()

      Keys.onReturnPressed: {
        if (acceptableInput) {
          // because we allow multiline input we need to trim the trailing `CRLF'
          // to get a valid bingo number
          scoreCardsView.markValidNumberOnAll(displayText.trim())
        } else {
          errorMsg.show(
                qsTr(
                  "Invalid number! \nThe number has to be in the range between %1 and %2!").arg(
                  intValidator.bottom).arg(intValidator.top))
          clear()
        }
      }
    }

    Button {
      id: buttonResetCard

      text: qsTr("Reset Cards")
      font.pointSize: 14

      Layout.alignment: Qt.AlignHCenter
      Layout.topMargin: -root.offset

      MessageDialog {
        id: confirmResetCardsDialog

        title: qsTr("Clear all cards")
        text: qsTr("Do you really want to clear all your cards?")
        informativeText: qsTr("You will lose all your marks on every card!")
        standardButtons: StandardButton.Yes | StandardButton.No

        onButtonClicked: {
          if (clickedButton === StandardButton.Yes) {
            scoreCardsView.clearAllCards()
          }
        }
      }

      onClicked: confirmResetCardsDialog.open()
    }
  }
}
