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
        readonly property int paddingH: vpx(30) // H as horizontal
        readonly property int paddingV: vpx(20) // V as vertical

        anchors {
          top: parent.top; topMargin: paddingH
          left: parent.left; leftMargin: paddingV
        }

        width: vpx(500)
        height: gameTitleRow.height
        clip: true
        color: "transparent"

        RowLayout {
          id: gameTitleRow
          anchors { left: parent.left }
          spacing: vpx(6)
          HeaderText { titletext: currentGame.title }
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
      width: vpx(500)
      height: metadataRow1.height
      clip: true
      color: "transparent"
      RowLayout {
        id: metadataRow1
        anchors { left: parent.left }
        spacing: vpx(6)
        GameDetailsText { metatext: 'Players: ' + Utils.formatPlayers(currentGame.players) }
        GameDetailsText { metatext: 'Last Played: ' + Utils.formatLastPlayed(currentGame.lastPlayed) }
        //GameDetailsText { metatext: 'Play Time: ' + Utils.formatPlayTime(currentGame.playTime) }
        GameDetailsText { metatext: 'Release Date: ' + Utils.formatDate(currentGame.release) || "unknown" }
      }
    }

    Rectangle {
      id: metadataRect2
      anchors {
        top: metadataRect1.bottom; topMargin: vpx(8)
        left: parent.left; leftMargin: vpx(20)
      }
      width: vpx(500)
      height: metadataRow2.height
      clip: true
      color: "transparent"
      RowLayout {
        id: metadataRow2
        anchors { left: parent.left }
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
   color: "#393a3b"
   opacity: 0.6
   height: vpx(120)
   width: vpx(500)
   anchors {
       top: metadataRect2.bottom; topMargin: vpx(8)
       left: parent.left; leftMargin: vpx(20)
       right: grid.left; // rightMargin: content.paddingH
       //bottom: footer.top; bottomMargin: content.paddingV
   }

   GameInfoText {
       id: gameDescription
       anchors {
         fill: parent
         topMargin: vpx(12)
         bottomMargin: vpx(12)
         leftMargin: vpx(12)
         rightMargin: vpx(12)
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
         left: parent.left; leftMargin: vpx(20)
         right: grid.left
         bottom: parent.bottom; //bottomMargin: content.paddingV
     }

 //     Image {
 //         id: screenshotImage
 //         readonly property double aspectRatio: (implicitWidth / implicitHeight) || 0
 //         anchors {
 //           centerIn: parent
 //         }
 //         asynchronous: true
 //         source: currentGame.assets.screenshots[0] || currentGame.assets.boxFront
 //         sourceSize { width: vpx(384); height: vpx(384) } // optimization (max size)
 //         fillMode: Image.PreserveAspectFit
 //     }
 // }

 GameVideoItem {
     id: screenshotImage
     anchors {
         // left: parent.horizontalCenter; leftMargin: vpx(20)
         // right: parent.right; rightMargin: vpx(20)
         // top: parent.top; topMargin: vpx(40)
         // bottom: parent.bottom; bottomMargin: vpx(8)
         centerIn: parent
     }

     game: currentGame
 }}

 Item {
     id: cartridge
     height: vpx(128)
     width: vpx(128)
     anchors {
         //top: gameDescriptionRect.bottom; topMargin: vpx(8)
         left: parent.left; leftMargin: vpx(20)
         right: grid.left;
         bottom: parent.bottom;
     }

     Image {
         id: cartridgeImage
         readonly property double aspectRatio: (implicitWidth / implicitHeight) || 0
         anchors {
           fill: parent
           centerIn: parent
         }
         //anchors.fill: parent
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
        anchors.top: root.top
        //anchors.topMargin: vpx(32)
        anchors.left: cartridge.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom // footer.top
        //anchors.bottomMargin: vpx(32)
        color: "transparent"
        readonly property int paddingH: vpx(30)
        readonly property int paddingV: vpx(40)
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
                //NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 1000 }
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
