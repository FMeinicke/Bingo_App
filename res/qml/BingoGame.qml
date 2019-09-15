//============================================================================
/// \file   BingoGame.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  The main game page with all bingo score cards and a field to enter
/// the drawn number
//============================================================================
import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

Page {
  BingoCardForm {
    anchors.centerIn: parent

    Component.onCompleted: console.log(height, width)
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

