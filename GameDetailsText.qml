import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string metatext
    Layout.minimumWidth: rowcontent.width + vpx(4);
    Layout.maximumWidth: vpx(260);
    Layout.minimumHeight: rowcontent.height //+ vpx(6);
    Layout.alignment: Qt.AlignHCenter;
    color: "transparent"

  RowLayout {
    id: rowcontent
    anchors.verticalCenter: root.verticalCenter
    anchors.horizontalCenter: root.horizontalCenter
      Text {
          id: metaData
          text: metatext
          font.weight: Font.Bold
          font.pixelSize: vpx(10)
          font.capitalization: Font.AllUppercase
          color: "#97999b"
          elide: Text.ElideRight
          Layout.maximumWidth: vpx(250)
      }
    }
  }
//}
