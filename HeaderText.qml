import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string titletext
    property var game

    color: "transparent"

    width: parent.width
    height: parent.height
    clip: true

    Image {
        id: logo
        asynchronous: true
        width: parent.width - vpx(20)
        height: parent.height - vpx(12)
        source: (game && game.assets.logo) || ""
        sourceSize { width: 580; height: 256 }
        fillMode: Image.PreserveAspectFit
        smooth: true

        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }

      Text {
          id: titleText
          text: titletext
          font.weight: Font.Bold
          font.pixelSize: vpx(20)
          font.capitalization: Font.AllUppercase
          color: "#97999b"
          elide: Text.ElideRight
          Layout.maximumWidth: vpx(500)
          visible: parent.status != Image.Ready && parent.status != Image.Loading
        }
     }
  }
