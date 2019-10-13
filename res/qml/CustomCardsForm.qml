//============================================================================
/// \file   CustomCardsForm.qml
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
