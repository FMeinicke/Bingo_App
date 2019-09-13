//============================================================================
/// \file   NewGameForm.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   08.09.2019
/// \brief  A page for choosing the mode for a new game
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5

Page {
    width: 411
    height: 617
    title: qsTr("New Game")

    Label {
        text: qsTr("You are on New Game.")
        anchors.centerIn: parent
    }
}
