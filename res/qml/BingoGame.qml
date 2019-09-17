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

  property int offset: 75

  BingoCardForm {
    id: scoreCard
    scale: 0.6
    anchors.top: parent.top
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter
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
    placeholderText: "B17"
    font.bold: true
    font.pointSize: 24
    font.capitalization: Font.AllUppercase
    horizontalAlignment: Text.AlignHCenter

    anchors.top: scoreCard.bottom
    anchors.topMargin: -root.offset
    anchors.horizontalCenter: parent.horizontalCenter

    cursorVisible: false

    onPressed: clear()

    onEditingFinished: {
      // strip off the first character (i.e. the letter)
      // TODO: don't discard the letter
      scoreCardModel.markNumber(displayText.substr(1))
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
      text: qsTr("Do you really clear all your cards?")
      informativeText: qsTr("You will lose all your marks on every card!")
      standardButtons: StandardButton.Yes | StandardButton.No

      onButtonClicked: {
        if (clickedButton === StandardButton.Yes) {
          scoreCardModel.clearCard()
        }
      }
    }

    onClicked: confirmResetCardsDialog.open()
  }
}
