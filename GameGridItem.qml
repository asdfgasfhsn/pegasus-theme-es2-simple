// Pegasus Frontend
// Copyright (C) 2017-2018  Mátyás Mustoha
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.


import QtQuick 2.2
import QtGraphicalEffects 1.12

Rectangle {
    id: root

    color: "transparent"

    property bool selected: false
    property var game

    property alias imageWidth: boxFront.paintedWidth
    property alias imageHeight: boxFront.paintedHeight
    property real imageHeightRatio: 0.5

    height: width * imageHeightRatio

    signal clicked()
    signal doubleClicked()
    signal imageLoaded(int imgWidth, int imgHeight)

    scale: selected ? 1.5 : 1.0
    opacity: selected ? 1 : 0.5
    z: selected ? 3 : 1

    Behavior on scale { PropertyAnimation { duration: 300 } }
    Behavior on opacity { PropertyAnimation { duration: 300 } }

    Image {
        id: boxFront
        anchors { fill: parent; margins: vpx(2) }

        asynchronous: true
        visible: false //game.assets.boxFront

        source: game.assets.boxFront || ""
        sourceSize { width: 256; height: 256 }
        fillMode: Image.PreserveAspectFit
        smooth: true

        onStatusChanged: if (status === Image.Ready) {
            imageHeightRatio = paintedHeight / paintedWidth;
            root.imageLoaded(paintedWidth, paintedHeight);
          }
      }

    Desaturate {
        anchors { fill: parent; margins: vpx(2) }
        source: boxFront
        desaturation: selected ? 0 : 0.9
        layer.enabled: true
        layer.effect: DropShadow {
          spread: 0.666
          horizontalOffset: 0
          verticalOffset: 0
          radius: selected ? 15 : 0
          samples: selected ? 18 : 0
          color: "#80000000"
          transparentBorder: true
        }
    }

    Image {
        anchors.centerIn: parent

        visible: boxFront.status === Image.Loading
        source: "assets/loading-spinner.png"

        RotationAnimator on rotation {
            loops: Animator.Infinite;
            from: 0;
            to: 360;
            duration: 500
        }
    }

    Text {
        width: parent.width - vpx(64)
        anchors.centerIn: parent

        visible: !game.assets.boxFront

        text: game.title
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter
        color: "#eee"
        font {
            pixelSize: vpx(16)
            family: globalFonts.sans
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        onDoubleClicked: root.doubleClicked()
    }
}
