/**
 ** This file is part of the "Mobile Bingo" project.
 ** Copyright (c) 2019 Florian Meinicke <florian.meinicke@t-online.de>.
 **
 ** Permission is hereby granted, free of charge, to any person obtaining a copy
 ** of this software and associated documentation files (the "Software"), to deal
 ** in the Software without restriction, including without limitation the rights
 ** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 ** copies of the Software, and to permit persons to whom the Software is
 ** furnished to do so, subject to the following conditions:
 **
 ** The above copyright notice and this permission notice shall be included in all
 ** copies or substantial portions of the Software.
 **
 ** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 ** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 ** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 ** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 ** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 ** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 ** SOFTWARE.
 **/

//============================================================================
/// \file   ConfigClassicGamePage.ui.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A page for configuring the classic mode of the bingo game
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Page {
  id: page
  width: 411
  height: 617

  title: qsTr("Classic Game")
  ColumnLayout {
    id: columnLayout
    anchors.fill: parent

    MenuButton {
      id: buttonRandom
      title: "Random\n Score Cards"
      font.pointSize: 15
      qmlFile: "BingoGame.qml"
    }

    MenuButton {
      id: buttonCustom
      title: "Custom\n Score Cards"
      font.pointSize: 15
      qmlFile: "CustomCardsPage.qml"
    }

    MenuButton {
      id: buttonScan
      title: "Scan\n Score Cards"
      font.pointSize: 15
      qmlFile: "ScanCardsPage.qml"
    }
  }
}
