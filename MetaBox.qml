import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string metaTitle
    property string metaContent
    width: vpx(80)
    height: width
    color: "transparent"

  RowLayout {
    id: rowcontent
    // anchors.verticalCenter: root.verticalCenter
    // anchors.horizontalCenter: root.horizontalCenter
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
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(6); font.pixelSize: vpx(10)
      font.weight: Font.Bold
      font.capitalization: Font.AllUppercase
      horizontalAlignment: Text.AlignHCenter
      anchors {
        top: parent.top; topMargin: vpx(10)
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
      fontSizeMode: Text.Fit; minimumPixelSize: vpx(10); font.pixelSize: vpx(38)
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    //   anchors {
    //     verticalCenter: parent.verticalCenter
    //     horizontalCenter: parent.horizontalCenter
    // }
    Behavior on text {
      FadeAnimation {
          target: ratingValue
        }
      }
    }
    }
  }
}
