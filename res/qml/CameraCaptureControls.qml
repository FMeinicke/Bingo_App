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

