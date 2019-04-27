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
    //visible: y < parent.height

    visible: y + height >= 0

    signal cancel
    signal nextCollection
    signal prevCollection
    signal launchGame

    // Key handling. In addition, pressing left/right also moves to the prev/next collection.
    // Keys.onLeftPressed: prevCollection()
    // Keys.onRightPressed: nextCollection()
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

  BackgroundImage {
    id: backgroundimage
    gameData: currentGame
    collectionView: collectionsView.focus
    detailView: detailsView.focus
    anchors {
      left: parent.left; right: parent.right
      top: parent.top; bottom: parent.bottom
    }
    opacity: 0.555
  }

// GridView start!
    Rectangle {
        id: content
        anchors {
          top: parent.top
          left: screenshot.right
          right: parent.right
          bottom: parent.bottom
        }

        color: "transparent"
        //clip: true

        GridView {
            id: grid
            width: vpx(560)
            height: vpx(700)

            preferredHighlightBegin: vpx(120)
            preferredHighlightEnd: vpx(600)

            anchors {
              rightMargin: vpx(48)
              top: parent.top;
              right: parent.right;
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

            transform: Rotation { origin.x: grid.height/2; origin.y: grid.width/2; axis { x: 0; y: 1; z: 0 } angle: -5 }

            delegate: GameGridItem {
                width: GridView.view.cellWidth
                height: GridView.view.cellHeight
                selected: GridView.isCurrentItem

                //transform: Rotation { origin.x: parent.width/2; origin.y: parent.width/2; axis { x: 0; y: 1; z: 0 } angle: selected ? 5 : 0 }

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


// Header/Meta Start
  Rectangle {
    id: headerGameTitle
    readonly property int paddingH: vpx(20) // H as horizontal
    readonly property int paddingV: vpx(20) // V as vertical
    width: vpx(1260)
    height: vpx(60)
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
      }
    }
  }

  Item {
    id: metaBar
    width: parent.width
    height: vpx(110)
    anchors {
      top: headerGameTitle.bottom
      left: headerGameTitle.left
      right: parent.right
    }

    Rectangle {
      id: metaBarBg
      width:  vpx(620)
      height: parent.height
      color: "#30f3f3f3"
      visible: true
    }

    Text {
        id: collectionName
        anchors {
          left: parent.left; leftMargin: vpx(10)
          top: parent.top;
          topMargin: vpx(4)
          }
        text: "≡ %1".arg(currentCollection.name) || "Not Found"
        color: "#f3f3f3"
        font.pixelSize: vpx(18)
        font.family: "coolvetica"
        font.capitalization: Font.AllUppercase
        Behavior on text {
          FadeAnimation {
              target: systemItemCount
            }
          }
      }

      GameMetaInfo {
        id: gameDetails1
        game: currentGame
        color: "transparent"
        width: vpx(620) // parent.width
        anchors {
          top: collectionName.bottom; topMargin: vpx(10)
          left: parent.left; leftMargin: vpx(10)
          bottomMargin: vpx(20)
        }
     }
  }


  GameDetails {
    id: gameDetails
    game: currentGame
    color: "#30f3f3f3"
    width: vpx(620)// headerGameTitle.width
    height: vpx(100)
    anchors {
      top: metaBar.bottom
      left: headerGameTitle.left; //leftMargin: vpx(20)
    }
  }

  Rectangle {
      id: screenshot
      height: vpx(400)
      width: vpx(600)// headerGameTitle.width
      color: "#30f3f3f3"
      // border.color: 'red'
      // border.width: vpx(5)
      anchors {
          top: gameDetails.bottom
          left: headerGameTitle.left
          horizontalCenter: gameDetails.horizontalCenter
      }

  GameVideoItem {
      id: screenshotImage
      anchors { fill: parent }
      game: currentGame
        collectionView: collectionsView.focus
        detailView: detailsView.focus
   }
 }

    // TODO: Add nice artwork or something in footer
    Rectangle {
        id: footer
        anchors.top: screenshot.bottom
        anchors.left: screenshot.left
        anchors.right: screenshot.right
        height: vpx(10)
        color: "#30f3f3f3"
    }




}
