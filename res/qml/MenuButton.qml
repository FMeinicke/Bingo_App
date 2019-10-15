//============================================================================
/// \file   MenuButton.qml
/// \author Florian Meinicke <florian.meinicke@t-online.de>
/// \date   13.09.2019
/// \brief  A button displaying custom text and leading the user to a custom
/// page when clicked.
//============================================================================
import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.12

Button {
  id: root

  property string title
  property string qmlFile

  Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
  Layout.preferredWidth: 3 * parent.width / 5
  Layout.preferredHeight: parent.height / 6

  text: qsTr(title)
  font.pointSize: 20
  Material.background: Material.color(Material.Green, Material.Shade200)

  onClicked: {
    if (qmlFile) {
      stackView.push(qmlFile)
    }
  }
}
