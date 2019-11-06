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
/// \file   CameraCaptureControls.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   26.10.2019
/// \brief  A control panel to use with a camera UI
//============================================================================
import QtQuick 2.0
import QtQuick.Controls 2.12
import QtMultimedia 5.12

Item {
  id: root

  property Camera camera: camera
  property int size: 50

  signal discardImage

  Row {
    anchors.horizontalCenter: parent.horizontalCenter
    spacing: size / 2

    ToolButton {
      id: captureButton

      height: size
      width: size
      visible: root.state === "Capture"

      contentItem: Image {
        source: "qrc:/images/camera_capture.png"
        fillMode: Image.PreserveAspectFit
      }
      onClicked: camera.imageCapture.capture()
    }

    ToolButton {
      id: deleteButton

      height: size
      width: size
      visible: root.state === "Preview"

      contentItem: Image {
        source: "qrc:/images/delete_forever.png"
        fillMode: Image.PreserveAspectFit
      }
      onClicked: discardImage()
    }
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

