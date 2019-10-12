//============================================================================
/// \file   MenuIcon.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   10.10.2019
/// \brief  An item displaying three vertical dots resembling the Android menu icon
//============================================================================
import QtQuick 2.9

Item {
  id: root

  property color bcolor: "black"
  property real xValue: (root.width - 2) / 2
  property real yValue: (root.height - 13) / 2

  Rectangle {
    id: circle1
    color: bcolor
    x: xValue
    y: yValue
    width: 2
    height: 2
    antialiasing: true
  }

  Rectangle {
    id: circle2
    color: bcolor
    x: xValue
    y: yValue + 5
    width: 2
    height: 2
    antialiasing: true
  }

  Rectangle {
    id: circle3
    color: bcolor
    x: xValue
    y: yValue + 10
    width: 2
    height: 2
    antialiasing: true
  }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/

