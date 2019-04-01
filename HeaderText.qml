import QtQuick 2.8
import QtQuick.Layouts 1.11

  Rectangle {
    id: root
    property string titletext
    Layout.minimumWidth: rowcontent.width + vpx(10);
    Layout.maximumWidth: vpx(500);
    Layout.minimumHeight: rowcontent.height + vpx(6);
    Layout.alignment: Qt.AlignHCenter;
    color: "#393a3b"
    opacity: 0.6

  RowLayout {
    id: rowcontent
    anchors.verticalCenter: root.verticalCenter
    anchors.horizontalCenter: root.horizontalCenter
      Text {
          id: titleText
          text: titletext
          font.weight: Font.Bold
          font.pixelSize: vpx(20)
          font.capitalization: Font.AllUppercase
          color: "#97999b"
          elide: Text.ElideRight
          Layout.maximumWidth: vpx(500)
      }
    }
  }
//}
