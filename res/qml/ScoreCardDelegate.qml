import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import de.dhge.moco.fm.ScoreCardNumberField 1.0

Item {
  id: wrapper

  property color bingoColor: Material.color(Material.Red)
  property color markingColor: Material.primary

  state: partOfBingo ? "bingo" : ""

  states: [
    State {
      name: "bingo"
      PropertyChanges {
        target: wrapper
        markingColor: bingoColor
      }
    }
  ]

  transitions: [
    Transition {
      to: "bingo"
      SequentialAnimation {
        id: bingoAnimation

        property int duration: 450

        SequentialAnimation {
          loops: 3

          ColorAnimation {
            from: markingColor
            to: bingoColor
            duration: bingoAnimation.duration
          }
          ColorAnimation {
            from: bingoColor
            to: markingColor
            duration: bingoAnimation.duration
          }
        }

        // finally change to `bingoColor' so that the corresponding fields stay highlighted
        ColorAnimation {
          to: bingoColor
          duration: bingoAnimation.duration
        }
      }
    }
  ]

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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

