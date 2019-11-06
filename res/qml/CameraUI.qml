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
/// \file   CameraUI.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   23.10.2019
/// \brief  A user interface for camera usage.
/// Adapted from https://doc.qt.io/qt-5/qtmultimedia-multimedia-declarative-camera-example.html
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtMultimedia 5.12

Rectangle {
  id: cameraUI

  color: "black"
  state: "Capture"

  states: [
    State {
      name: "Capture"
      StateChangeScript {
        script: {
          camera.captureMode = Camera.CaptureStillImage
          camera.start()
        }
      }
    },
    State {
      name: "Preview"
    }
  ]

  Camera {
    id: camera

    captureMode: Camera.CaptureStillImage

    imageCapture {
      onImageCaptured: {
        photoPreview.source = preview
        cameraUI.state = "Preview"
      }
    }

    videoRecorder {
      resolution: "350x420"
      frameRate: 30
    }
  }

  PhotoPreview {
    id: photoPreview

    x: 0
    y: 0
    width: parent.width
    height: parent.height - captureControls.height

    onClosed: cameraUI.state = "Capture"
    visible: cameraUI.state == "Preview"
    focus: visible
  }

  VideoOutput {
    id: viewfinder

    visible: cameraUI.state == "Capture"

    x: 0
    y: 0
    width: parent.width
    height: parent.height - captureControls.height

    source: camera
    autoOrientation: true
  }

  CameraCaptureControls {
    id: captureControls

    state: cameraUI.state
    camera: camera

    visible: camera.imageCapture.ready

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: parent.bottom
      bottomMargin: 0
    }

    onDiscardImage: cameraUI.state = "Capture"
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

