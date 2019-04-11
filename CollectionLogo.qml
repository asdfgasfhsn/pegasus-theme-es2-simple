import QtQuick 2.8
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
    opacity: 1.0

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
        scale: 1 //selected ? 1.0 : 0.66
        //Behavior on scale { NumberAnimation { duration: 600 } }
    }
    layer.enabled: selected ? true : false
    layer.effect: DropShadow {
      fast: true
      horizontalOffset: 0
      verticalOffset: 0
      spread: 0.15
      radius: vpx(172)
      samples: 32
      color: "purple"
      transparentBorder: true
      SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation { from: "#809932CC"; to: "#800000FF"; duration: 6666 }
            ColorAnimation { from: "#800000FF"; to: "#809932CC"; duration: 6666 }
        }
    }



}
