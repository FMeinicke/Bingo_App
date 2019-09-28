//============================================================================
/// \file   BingoGame.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  The main game page with all bingo score cards and a field to enter
/// the drawn number
//============================================================================
import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5
import QtQuick.Window 2.3
import QtQuick.Dialogs 1.2

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

  Component.onCompleted: scoreCardModel.newCard()

  Keys.onBackPressed: confirmLeaveDialog.open()

  BingoCardForm {
    id: scoreCard
    scale: 0.6
    anchors.top: parent.top
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    ToolTip {
      id: errorMsg
      anchors.centerIn: parent
      visible: false
      timeout: 3000
      delay: 500
    }
  }

  TextField {
    id: numberInput
    width: height

    //    Label {
    //      text: qsTr("Drawn Number:")
    //      anchors.verticalCenter: parent.verticalCenter
    //      anchors.horizontalCenter: parent.horizontalCenter
    //      anchors.horizontalCenterOffset: -115
    //      anchors.verticalCenterOffset: -3
    //    }
    placeholderText: "B13"
    font.bold: true
    font.pointSize: 24
    font.capitalization: Font.AllUppercase
    inputMethodHints: Qt.ImhUppercaseOnly
    horizontalAlignment: Text.AlignHCenter

    anchors.top: scoreCard.bottom
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    cursorVisible: false

    onPressed: clear()

    onEditingFinished: {
      if (!scoreCardModel.markValidNumber(displayText)) {
        errorMsg.show(qsTr(scoreCardModel.readLastError()))
        return
      }
      scoreCardModel.checkForBingo()
    }
  }

  Button {
    id: buttonNewCard
    text: qsTr("New Cards")
    font.pointSize: 14

    anchors.top: scoreCard.bottom
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
          scoreCardModel.newCard()
          numberInput.clear()
        }
      }
    }

    onClicked: confirmNewCardsDialog.open()
  }

  Button {
    id: buttonResetCard
    text: qsTr("Reset Cards")
    font.pointSize: 14

    anchors.top: scoreCard.bottom
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
          scoreCardModel.clearCard()
          numberInput.clear()
        }
      }
    }

    onClicked: confirmResetCardsDialog.open()
  }
}
