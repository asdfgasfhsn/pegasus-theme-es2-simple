import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string metaTitle
    property string metaContent
    width: vpx(68)
    height: width
    color: "transparent"

  RowLayout {
    id: rowcontent
    anchors.verticalCenter: root.verticalCenter
    anchors.horizontalCenter: root.horizontalCenter
    Rectangle {
        id: ratingCircle
        width: root.width
        height: root.width
        color: "#f6f6f6"
        clip: true

    Text {
      text: metaTitle
      width: parent.width
      font.family: "coolvetica" //coolvetica.name
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(8); font.pixelSize: vpx(8)
      font.weight: Font.Bold
      font.capitalization: Font.AllUppercase
      horizontalAlignment: Text.AlignHCenter
      padding: vpx(6)
      anchors {
        top: parent.top;
        left: parent.left; right: parent.right
      }
    }
    Text {
      id: ratingValue
      text: metaContent
      width: parent.width
      height: parent.height
      font.family: "coolvetica" //coolvetica.name
      font.capitalization: Font.AllUppercase
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(12); font.pixelSize: vpx(44)
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      padding: vpx(10)
    Behavior on text {
      FadeAnimation {
          target: ratingValue
        }
      }
    }
    }
  }
}
