import QtQuick 2.0
import QtGraphicalEffects 1.12

// The collection logo on the collection carousel. Just an image that gets scaled
// and more visible when selected. Also has a fallback text if there's no image.
Item {
    property string longName: "" // set on the PathView side
    property string shortName: "" // set on the PathView side
    readonly property bool selected: PathView.isCurrentItem

    width: vpx(256)
    height: vpx(256)
    visible: PathView.onPath // optimization: do not draw if not visible

    opacity: 1.0 //selected ? 1.0 : 0.5
    //Behavior on opacity { NumberAnimation { duration: 600 } }

    Image {
        id: image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/controllers/%1.png".arg(shortName) : ""
        asynchronous: true
        scale: selected ? 1.0 : 0.66
        Behavior on scale { NumberAnimation { duration: 600 } }
    }

    Image {
        id: systemLogo
        anchors.left: image.right; anchors.leftMargin: vpx(10)
        anchors.top: image.top; anchors.topMargin: vpx(32)
        //anchors.horizontalCenter: parent.horizontalCenter
        width: vpx(256)
        height: vpx(256)
        fillMode: Image.PreserveAspectFit
        smooth: true
        source: shortName ? "assets/logos/%1.svg".arg(shortName) : ""
        asynchronous: true
        sourceSize { width: vpx(256); height: vpx(256) } // optimization: render SVGs in at most 256x256
        // scale: selected ? 1.0 : 0.66
        // Behavior on scale { NumberAnimation { duration: 600 } }
        visible: false
    }
    ColorOverlay {
      anchors.fill: systemLogo
      source: systemLogo
      color: "grey"
      smooth: true
      scale: selected ? 1.0 : 0
      Behavior on scale { NumberAnimation { duration: 1200 } }
    }
}
