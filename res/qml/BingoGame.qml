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

  SwipeView {
    id: scoreCardsView

    property var bingoCards: contentChildren

    anchors.top: parent.top
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter
    height: 420
    width: 350
    scale: 0.6

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
      for (var i = 0; i < bingoCards.length; i++) {
        const cardModel = bingoCards[i].scoreCardModel
        if (!cardModel.markValidNumber(num)) {
          errorMsg.show(qsTr(cardModel.readLastError()))
          return
        }
        cardModel.checkForBingo()
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
    }
  }

  PageIndicator {
    id: indicator

    visible: count > 1

    anchors.bottom: scoreCardsView.bottom
    anchors.bottomMargin: 0.9 * root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    count: scoreCardsView.count
    currentIndex: scoreCardsView.currentIndex

    interactive: true
    onCurrentIndexChanged: scoreCardsView.setCurrentIndex(currentIndex)
  }

  TextField {
    id: numberInput

    width: height

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

    anchors.top: scoreCardsView.bottom
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    onPressed: clear()

    onEditingFinished: {
      // because we allow multiline input we need to trim the trailing `CRLF'
      // to get a valid bingo number
      scoreCardsView.markValidNumberOnAll(displayText.trim())
    }
  }

  Button {
    id: buttonNewCard

    text: qsTr("New Cards")
    font.pointSize: 14

    anchors.top: scoreCardsView.bottom
    anchors.topMargin: -root.offset
    anchors.left: parent.left
    anchors.leftMargin: root.offset / 3

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

  Button {
    id: buttonResetCard

    text: qsTr("Reset Cards")
    font.pointSize: 14

    anchors.top: scoreCardsView.bottom
    anchors.topMargin: -root.offset
    anchors.right: parent.right
    anchors.rightMargin: root.offset / 3

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
