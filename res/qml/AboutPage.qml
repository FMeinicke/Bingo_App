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
/// \file   AboutPage.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   23.10.2019
/// \brief  A page displaying information about the app
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Page {
  id: page

  Column {
    anchors.fill: parent
    anchors.topMargin: 2 * spacing
    spacing: 10

    Text {
      id: appName

      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      text: Qt.application.name
      font.pixelSize: Qt.application.font.pixelSize * 2
      font.weight: Font.Bold
    }

    Text {
      id: appVersion

      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      text: qsTr("Version %1").arg(Qt.application.version)
      font.pixelSize: Qt.application.font.pixelSize * 1.4
    }

    Image {
      id: appIcon

      width: parent.width
      fillMode: Image.PreserveAspectFit

      source: "qrc:/icons/bingo_app.png"
      height: 75
    }

    Text {
      id: copyright

      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      text: qsTr("Copyright (c) 2019 Florian Meinicke")
      font.pixelSize: Qt.application.font.pixelSize
    }

    Text {
      id: license

      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      textFormat: Text.RichText
      text: qsTr(
              "<html>Licensed under <a href='https://opensource.org/licenses/MIT'>MIT License</a></html>")
      font.pixelSize: Qt.application.font.pixelSize

      onLinkActivated: Qt.openUrlExternally(link)
    }

    ToolSeparator {
      orientation: Qt.Horizontal
      width: parent.width
      hoverEnabled: false
    }
    Text {
      id: imageSources

      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      text: qsTr("Image and Icon Sources")
      font.pixelSize: Qt.application.font.pixelSize * 1.2
      font.weight: Font.DemiBold
    }

    Text {
      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      textFormat: Text.RichText
      text: qsTr(
              "<html>App Icon: <a href='https://icon-library.net/icon/bingo-icon-16.html'>Bingo Icon #25374</a></html>")
      font.pixelSize: Qt.application.font.pixelSize

      onLinkActivated: Qt.openUrlExternally(link)
    }

    Text {
      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      textFormat: Text.RichText
      text: qsTr(
              "<html>Bingo Scorecard: Downloaded from <a href='https://www.wikihow.com/Sample/Blank-Bingo-Card'>wikihow.com</a></html>")
      font.pixelSize: Qt.application.font.pixelSize

      onLinkActivated: Qt.openUrlExternally(link)
    }

    Text {
      width: parent.width
      horizontalAlignment: Text.AlignHCenter

      textFormat: Text.RichText
      text: qsTr(
              "<html>Material Icons: Downloaded from <a href='https://www.material.io/resources/icons/'>material.io</a></html>")
      font.pixelSize: Qt.application.font.pixelSize

      onLinkActivated: Qt.openUrlExternally(link)
    }
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

