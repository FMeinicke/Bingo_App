//============================================================================
/// \file   ChooseGameForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   28.09.2019
/// \brief  A page for choosing between the different game modes
//============================================================================
import QtQuick 2.12
import QtQuick.Controls.Material 2.12
import QtGraphicalEffects 1.0
import de.dhge.moco.fm.ScoreCardNumberField 1.0

Item {
  id: wrapper

  property color bingoColor: Material.color(Material.Red)
  property color markingColor: Material.primary
  property alias textField: textField
  property bool isFreeField: model.fieldType === ScoreCardNumberFieldType.FREE_SPACE

  state: {
    if (model.partOfBingo) {
      return "bingo"
    } else if (GridView.view.state === "edit") {
      return "edit"
    } else {
      return ""
    }
  }

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

        // free field shouldn't be editable
        readOnly: isFreeField
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
    onClicked: {
      // highlight the current field by giving the GridView the correct index
      wrapper.GridView.view.currentIndex = index
      textField.forceActiveFocus()
    }
  }

  TextInput {
    id: textField

    anchors.centerIn: parent

    // center field is a free field -> it's number shouldn't be displayed
    text: (isFreeField || model.number === 0) ? "" : model.number
    font.bold: true
    font.pixelSize: 30

    readOnly: true

    inputMethodHints: Qt.ImhDigitsOnly
    validator: IntValidator {
      id: intValidator
      property int maxColNumberCount: 15
      property int numColumns: 5
      property int minAcceptableNum: ((index - index % numColumns) / numColumns)
                                     * maxColNumberCount + 1

      bottom: minAcceptableNum
      top: minAcceptableNum + maxColNumberCount - 1
    }

    function showError() {
      errorMsg.show(
            qsTr(
              "Invalid number! \nThe number has to be in the range between %1 and %2!").arg(
              intValidator.bottom).arg(intValidator.top))
    }

    Keys.onReturnPressed: {
      if (!acceptableInput) {
        if (text.length > 0) {
          clear()
          showError()
        }
        return
      }

      model.number = text

      // give the next field focus so that the user doesn't have to manually
      // select the next field
      if (!wrapper.GridView.view.currentItem.isFreeField) {
        wrapper.GridView.view.currentIndex = index + 1
      } else {
        // center field is a free field -> doesn't need a number
        wrapper.GridView.view.currentIndex = index + 2
      }

      wrapper.GridView.view.currentItem.textField.focus = true
    }

    onActiveFocusChanged: {
      if (text.length > 0 && !acceptableInput) {
        showError()
        clear()
      }
    }
  }

  Rectangle {
    id: marking

    // center field is a free field -> marked by default but shouldn't be displayed
    visible: isFreeField ? false : model.marked

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

