import QtQuick 2.8 // note the version: Text padding is used below and that was added in 2.7 as per docs
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "utils.js" as Utils // some helper functions

// The details "view". Consists of some images, a bunch of textual info and a game list.
FocusScope {
    id: root

    // This will be set in the main theme file
    property var currentCollection
    // Shortcuts for the game list's currently selected game
    property alias currentGameIndex: grid.currentIndex
    readonly property var currentGame: currentCollection.games.get(currentGameIndex)

    // Nothing particularly interesting, see CollectionsView for more comments
    width: parent.width
    height: parent.height
    enabled: focus
    visible: y < parent.height

    signal cancel
    signal nextCollection
    signal prevCollection
    signal launchGame

    // Key handling. In addition, pressing left/right also moves to the prev/next collection.
    Keys.onLeftPressed: prevCollection()
    Keys.onRightPressed: nextCollection()
    Keys.onPressed: {
        if (event.isAutoRepeat)
            return;

        if (api.keys.isAccept(event)) {
            event.accepted = true;
            launchGame();
            return;
        }
        if (api.keys.isCancel(event)) {
            event.accepted = true;
            cancel();
            return;
        }
        if (api.keys.isNextPage(event)) {
            event.accepted = true;
            nextCollection();
            return;
        }
        if (api.keys.isPrevPage(event)) {
            event.accepted = true;
            prevCollection();
            return;
        }
    }
// TODO: Figure out Nice way of Rendering asset.background
// TODO: Determine "default background for each system..."

BackgroundImage {
  id: backgroundimage
  gameData: currentGame
  anchors {
    left: parent.left; right: parent.right
    top: parent.top; bottom: parent.bottom
  }
  opacity: 0.333
}

// Background Start
// Gradient Yo!
  Rectangle {
    id: bgRectGradient
    width: root.width
    height: root.height
    color: "transparent"
    layer.enabled: true
    LinearGradient {
      anchors.fill: parent
      start: Qt.point(0, 0)
      end: Qt.point(0, vpx(720))
      gradient: Gradient {
        GradientStop {
           position: 0.000
           color: "transparent"
           //color: Qt.rgba(0, 0, 0.1, 1)
        }
        GradientStop {
           position: 0.999
           color: Qt.rgba(0, 0, 0, 0.9)
        }
      }
    }
  }
// Background End

// Header/Meta Start
//// Game Title Start
  Rectangle {
    id: headerGameTitle
    readonly property int paddingH: vpx(20) // H as horizontal
    readonly property int paddingV: vpx(20) // V as vertical
    //border { color: "#444"; width: 1 }
    width: vpx(580)
    height: vpx(196)
    color: "transparent"

    anchors {
      top: root.top; topMargin: paddingH
      left: root.left; leftMargin: paddingV
      rightMargin: paddingV

    }

    HeaderText {
      titletext: currentGame.title;
      game: currentGame
      anchors {
        verticalCenter: headerGameTitle.verticalCenter
      }
    }
  }
//// Game Title End

//// Game Metadata Start
    Rectangle {
      id: metadataRect1
      anchors {
        top: headerGameTitle.bottom; topMargin: vpx(8)
        left: parent.left; leftMargin: vpx(20)
      }
      width: vpx(580)
      height: metadataRow1.height
      clip: true
      color: "transparent"
      RowLayout {
        id: metadataRow1
        anchors { horizontalCenter: parent.horizontalCenter } //left: parent.left }
        spacing: vpx(6)
        GameDetailsText { metatext: 'Players: ' + Utils.formatPlayers(currentGame.players) }
        GameDetailsText { metatext: 'Last Played: ' + Utils.formatLastPlayed(currentGame.lastPlayed) }
        GameDetailsText { metatext: 'Play Time: ' + Utils.formatPlayTime(currentGame.playTime) }
        GameDetailsText { metatext: 'Release Date: ' + Utils.formatDate(currentGame.release) || "unknown" }
      }
    }

    Rectangle {
      id: metadataRect2
      anchors {
        top: metadataRect1.bottom; topMargin: vpx(8)
        left: parent.left; leftMargin: vpx(20)
      }
      width: vpx(580)
      height: metadataRow2.height
      clip: true
      color: "transparent"
      RowLayout {
        id: metadataRow2
        anchors { horizontalCenter: parent.horizontalCenter }
        spacing: vpx(6)
        GameDetailsText { metatext: 'Developer: ' + currentGame.developer || "unknown" }
        GameDetailsText { metatext: 'Publisher: ' + currentGame.publisher || "unknown" }
        GameDetailsText { metatext: 'Genre: ' + currentGame.genre || "unknown" }
        }
    }
//// Game Metadata End
// Header/Meta End

// Gameinfo Start
 Rectangle {
   id: gameDescriptionRect
   //color: Qt.rgba(1, 1, 1, 0.1)
   color: "transparent"//"#393a3b"
   opacity: 0.6
   height: vpx(120)
   width: vpx(580)
   anchors {
       top: metadataRect2.bottom; topMargin: vpx(8)
       left: parent.left; leftMargin: vpx(20)
       right: grid.left;
   }

   GameInfoText {
       id: gameDescription
       anchors {
         fill: parent
         topMargin: vpx(12)
         bottomMargin: vpx(12)
         leftMargin: vpx(12)
         rightMargin: vpx(12)
         horizontalCenter: parent.horizontalCenter
       }
       text: currentGame.description
       wrapMode: Text.WordWrap
       elide: Text.ElideRight
       color: "#97999b"
   }
 }
 // Gameinfo End

 // Artwork Time!
 Item {
     id: screenshot
     height: vpx(384)
     width: vpx(500)
     anchors {
         top: gameDescriptionRect.bottom; topMargin: vpx(8)
         //left: parent.left; leftMargin: vpx(30)
         right: grid.left; rightMargin: vpx(30)
         bottom: parent.bottom; bottomMargin: vpx(30)
         horizontalCenter: gameDescriptionRect.horizontalCenter
     }

 GameVideoItem {
     id: screenshotImage
     anchors { fill: parent }
     game: currentGame
  }
}
 Item {
     id: cartridge
     height: vpx(128)
     width: vpx(128)
     anchors {
         //top: gameDescriptionRect.bottom; topMargin: vpx(8)
         left: parent.left; leftMargin: vpx(20)
         right: grid.left;
         bottom: root.bottom; bottomMargin: vpx(20)
     }

     Image {
         id: cartridgeImage
         readonly property double aspectRatio: (implicitWidth / implicitHeight) || 0
         anchors {
           fill: parent
           centerIn: parent
         }
         asynchronous: true
         source: currentGame.assets.cartridge || ""
         sourceSize { width: vpx(256); height: vpx(256) } // optimization (max size)
         fillMode: Image.PreserveAspectFit
     }
 }

// End Artwork Time!
// Content Start
    Rectangle {
        id: content
        anchors {
          top: root.top
          left: cartridge.right
          right: parent.right
          bottom: parent.bottom
        }

        color: "transparent"
        // readonly property int paddingH: vpx(30)
        // readonly property int paddingV: vpx(40)
        clip: true

        GridView {
            id: grid
            width: vpx(620)
            height: vpx(700)
            anchors {
                top: parent.top;
                right: parent.right;
                margins: vpx(32)
                topMargin: vpx(50)
            }
            property bool firstImageLoaded: false
            property real cellHeightRatio: 0.5

            function cells_need_recalc() {
                firstImageLoaded = false;
                cellHeightRatio = 0.5;
            }

            // TODO: Make this "skew to provide lazy 3D look"
            // transform: Matrix4x4 {
            //     property real a: Math.PI / 3
            //     matrix: Qt.matrix4x4(a, 0.01, a, 0,
            //                          0,   1, 0, 0,
            //                          0,   0, 1, 0,
            //                          0,   0, 0, 1)
            // }

            focus: true
            snapMode: GridView.SnapToRow
            highlightFollowsCurrentItem: true
            highlightRangeMode: GridView.StrictlyEnforceRange

            model: currentCollection.games
            onModelChanged: cells_need_recalc()
            onCountChanged: cells_need_recalc()

            property real columnCount: {
                if (cellHeightRatio > 1.2) return 5;
                if (cellHeightRatio > 0.6) return 4;
                return 3;
            }

            function calcHeightRatio(imageW, imageH) {
                cellHeightRatio = 0.5;

                if (imageW > 0 && imageH > 0)
                    cellHeightRatio = imageH / imageW;
            }

            cellWidth: width / columnCount
            cellHeight: cellWidth * cellHeightRatio;

            displayMarginBeginning: anchors.topMargin

            add: Transition {
                NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 1000 }
            }

            displaced: Transition {
                NumberAnimation { properties: "x,y"; duration: 400; easing.type: Easing.OutBounce }
                NumberAnimation { property: "scale"; to: 1.0 }
            }
            remove: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0; duration: 1000 }
                NumberAnimation { property: "scale"; from: 1.0; to: 0; duration: 1000 }
            }


            delegate: GameGridItem {
                width: GridView.view.cellWidth
                selected: GridView.isCurrentItem

                game: modelData

                imageHeightRatio: {
                    if (grid.firstImageLoaded) return grid.cellHeightRatio;
                    return 0.5;
                }
                onImageLoaded: {
                    // NOTE: because images are loaded asynchronously,
                    // firstImageLoaded may appear false multiple times!
                    if (!grid.firstImageLoaded) {
                        grid.firstImageLoaded = true;
                        grid.calcHeightRatio(imageWidth, imageHeight);
                    }
              }
        }
    }
}
    // TODO: Add nice artwork or something in footer
    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: vpx(10)
        color: "transparent"
  }
}
