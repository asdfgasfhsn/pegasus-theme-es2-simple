import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string titletext
    property var game
    // border.color: 'red'
    // border.width: vpx(5)

    color: "transparent"

    width: parent.width
    height: parent.height
    clip: true

    Image {
        id: logo
        asynchronous: true
        width: parent.width - vpx(60)
        height: parent.height - vpx(20)
        source: (game && game.assets.logo) || ""
        sourceSize { width: 580; height: 256 }
        fillMode: Image.PreserveAspectFit
        smooth: true

        anchors {
          verticalCenter: parent.verticalCenter
          horizontalCenter: parent.horizontalCenter
        }

        Behavior on source {
          FadeAnimation { target: logo }
        }

      Text {
          id: titleText
          text: titletext
          color: "#f3f3f3"

          width: parent.width
          height: parent.height
          horizontalAlignment: Text.AlignHCenter
          verticalAlignment: Text.AlignVCenter

          font.capitalization: Font.AllUppercase
          font.family: "coolvetica"
          font.pixelSize: vpx(78)
          font.weight: Font.Bold
          fontSizeMode: Text.Fit;
          minimumPixelSize: vpx(40)
          Layout.maximumWidth: vpx(500)
          elide: Text.ElideRight

          visible: parent.status != Image.Ready && parent.status != Image.Loading

          Behavior on text {
            FadeAnimation { target: titleText }
          }
        }
     }
  }
