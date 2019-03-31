import QtQuick 2.0
import QtGraphicalEffects 1.12

// The collection logo on the collection carousel. Just an image that gets scaled
// and more visible when selected. Also has a fallback text if there's no image.
Item {
    property string longName: "" // set on the PathView side
    property string shortName: "" // set on the PathView side
    readonly property bool selected: PathView.isCurrentItem

    width: root.width
    height: parent.width
    visible: PathView.onPath // optimization: do not draw if not visible
    opacity: selected ? 1.0 : 0.666


    Image {
        id: systemLogo
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: root.width - vpx(72)
        height: root.height
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/logos/%1.svg".arg(shortName) : ""
        asynchronous: true
        sourceSize { width: vpx(512); height: vpx(512) }
        visible: false
    }
    ColorOverlay {
      anchors.fill: systemLogo
      source: systemLogo
      color: "white"
      smooth: true
      scale: selected ? 1.0 : 0
      opacity: selected ? 0.111 : 0
      Behavior on opacity { NumberAnimation { duration: 6000 } }

      layer.enabled: true
      layer.effect: DropShadow {
      horizontalOffset: 0
      verticalOffset: 0
      radius: 10.0
      samples: 17
      color: "#80000000"
      transparentBorder: true
    }
  }

    Image {
        id: controllerImage
        width: vpx(386)
        height: vpx(386)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/controllers/%1.png".arg(shortName) : ""
        asynchronous: true
        scale: selected ? 1.0 : 0.66
        Behavior on scale { NumberAnimation { duration: 600 } }
    }

}
