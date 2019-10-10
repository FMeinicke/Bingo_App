import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import de.dhge.moco.fm.ScoreCardNumberField 1.0

Item {
  id: wrapper

  property color bingoColor: Material.color(Material.Red)
  property color markingColor: Material.primary

  state: model.partOfBingo ? "bingo" : ""

  states: [
    State {
      name: "bingo"
      PropertyChanges {
        target: wrapper

        markingColor: bingoColor
      }
    },
    State {
      name: "edit"
      PropertyChanges {
        target: textField

        readOnly: false
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

  // makes the textField editable when clicked on
  MouseArea {
    anchors.fill: parent
    onClicked: textField.forceActiveFocus()
  }

  TextInput {
    id: textField

    anchors.centerIn: parent

    // center field is a free field -> it's number shouldn't be displayed
    text: (model.fieldType === ScoreCardNumberFieldType.FREE_SPACE
           || model.number === 0) ? "" : model.number
    font.bold: true
    font.pixelSize: 30

    readOnly: true

    inputMethodHints: Qt.ImhDigitsOnly
    validator: IntValidator {
      property int maxColNumberCount: 15
      property int numColumns: 5
      property int minAcceptableNum: ((index - index % numColumns) / numColumns)
                                     * maxColNumberCount + 1

      bottom: minAcceptableNum
      top: minAcceptableNum + maxColNumberCount - 1
    }

    onEditingFinished: {
      model.number = text
    }

    onActiveFocusChanged: {
      if (!acceptableInput) {
        clear()
      }
    }
  }

  Rectangle {
    id: marking

    // center field is a free field -> marked by default but shouldn't be displayed
    visible: model.fieldType === ScoreCardNumberFieldType.FREE_SPACE ? false : model.marked

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

