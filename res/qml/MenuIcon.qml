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

