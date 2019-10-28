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

