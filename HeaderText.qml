import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string titletext
    property var game
    // border.color: 'red'
    // border.width: vpx(5)

    color: "#f3f3f3"//"#000000"

    property real textWidth: {
        if (textMetrics.width > parent.width) return parent.width - vpx(20);
        return textMetrics.width;
    }

    width: textWidth // textMetrics.width - vpx(20)
    height: parent.height
    clip: true

    TextMetrics {
        id: textMetrics
        font.capitalization: Font.AllUppercase
        font.family: "coolvetica"
        font.pixelSize: vpx(50)
        font.weight: Font.Bold
        text: titletext
    }

    Text {
        id: titleText
        color: "black"//"#f3f3f3"
        text: textMetrics.text
        font: textMetrics.font
        width: textWidth
        //height: textMetrics.height

        leftPadding: vpx(10)
        rightPadding: vpx(10)

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        fontSizeMode: Text.Fit;
        minimumPixelSize: vpx(30)
        Layout.maximumWidth: textWidth - vpx(100)
        elide: Text.ElideRight
      }
   }
