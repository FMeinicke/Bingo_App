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

Page {
  id: root
  width: Screen.width
  height: Screen.height
  focusPolicy: Qt.StrongFocus

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

    property var numScoreCards: 5 ///< change this to get more or less scorecards
    property list<BingoCardForm> bingoCards

    anchors.top: parent.top
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter
    height: 420
    width: 350
    scale: 0.6

    spacing: 0

    // dynamically create the bingo scorecards
    Component.onCompleted: {
      for (var i = 0; i < numScoreCards; i++) {
        let component = Qt.createComponent("BingoCardForm.qml")
        if (component.status == Component.Ready) {
          let bingoCard = component.createObject(scoreCardsView)
          bingoCards.push(bingoCard)
        }
      }
    }

    // checks if any of the bingo scorecards has a bingo
    function hasBingo() {
      for (var i = 0; i < bingoCards.length; i++) {
        if (bingoCards[i].model.hasBingo) {
          return true
        }
        return false
      }
    }

    // marks the given num on all of the scorecards and shows an error if num is invalid
    function markValidNumberOnAll(num) {
      for (var i = 0; i < bingoCards.length; i++) {
        const cardModel = bingoCards[i].model
        if (!cardModel.markValidNumber(num)) {
          errorMsg.show(qsTr(cardModel.readLastError()))
          return
        }
        cardModel.checkForBingo()
      }
      numberInput.clear()
    }

    function clearAllCards() {
      for (var i = 0; i < bingoCards.length; i++) {
        bingoCards[i].model.clearCard()
      }
    }

    // give new cards
    function newCards() {
      for (var i = 0; i < bingoCards.length; i++) {
        bingoCards[i].model.newCard()
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

    placeholderText: "B13"
    font.bold: true
    font.pointSize: 24
    font.capitalization: Font.AllUppercase
    inputMethodHints: Qt.ImhUppercaseOnly
    horizontalAlignment: Text.AlignHCenter

    anchors.top: scoreCardsView.bottom
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    onPressed: clear()

    onEditingFinished: {
      scoreCardsView.markValidNumberOnAll(displayText)
      //      enabled = !scoreCardsView.hasBingo()
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
          scoreCardsView.newCards()
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
