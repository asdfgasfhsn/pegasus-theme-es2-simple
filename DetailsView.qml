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
    property alias currentGameIndex: gameList.currentIndex
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

// Right Menu Backround Start
    Rectangle {
      id: rightMenuBG
      width: vpx(320)
      height: root.height
      color: "#393a3b"
      opacity: 0.6
      anchors {
        top: root.top;
        right: parent.right; rightMargin: vpx(20)
        bottom: root.bottom;
      }
    }
// Right Menu Backround Stop

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

        width: vpx(968)
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
      width: vpx(968)
      height: metadataRow1.height
      clip: true
      color: "transparent"
      RowLayout {
        id: metadataRow1
        anchors { left: parent.left }
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
      width: vpx(968)
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

// Content Start
    Rectangle {
        id: content
        anchors.top: root.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.bottom
        color: "transparent"

        readonly property int paddingH: vpx(30)
        readonly property int paddingV: vpx(40)

       // Gameinfo Start
        Rectangle {
          id: gameDescriptionRect
          //color: Qt.rgba(1, 1, 1, 0.1)
          color: "#393a3b"
          opacity: 0.6
          height: vpx(64)
          anchors {
              top: parent.top; topMargin: vpx(160)
              left: parent.left; leftMargin: vpx(20)
              right: gameList.left; rightMargin: content.paddingH
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
        ListView {
            id: gameList
            width: vpx(350)
            anchors {
                top: parent.top;
                right: parent.right;
                bottom: parent.bottom; bottomMargin: vpx(20)
                topMargin: vpx(20)
            }

            focus: true

            model: currentCollection.games
            delegate: Rectangle {
                readonly property bool selected: ListView.isCurrentItem
                readonly property color clrDark: "#393a3b"
                readonly property color clrLight: "#97999b"
                readonly property color transparent: "transparent"

                width: ListView.view.width
                height: gameTitle.height
                opacity: 1
                color: selected ? clrLight : transparent

                Text {
                    id: gameTitle
                    text: modelData.title
                    color: selected ? parent.clrDark : parent.clrLight

                    font.pixelSize: parent.selected ? vpx(14) : vpx(14)
                    font.capitalization: Font.AllUppercase
                    font.family: "Open Sans"

                    lineHeight: 1.2
                    verticalAlignment: Text.AlignVCenter

                    width: parent.width - vpx(20)
                    elide: Text.ElideRight
                    leftPadding: vpx(16)
                }
            }

            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 0
            preferredHighlightBegin: height * 0.5 - vpx(14)
            preferredHighlightEnd: height * 0.5 + vpx(14)
        }
    }

    // TODO: Add nice artwork or something in footer
    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: vpx(196)
        color: "transparent"

        Item {
            id: cartridge
            height: vpx(196)
            width: Math.max(vpx(196), Math.min(height * cartridgeImage.aspectRatio, vpx(320)))
            anchors {
                top: parent.top; //topMargin: vpx(120)
                left: parent.left; leftMargin: content.paddingH
                bottom: parent.bottom; bottomMargin: content.paddingV
            }

            Image {
                id: cartridgeImage
                readonly property double aspectRatio: (implicitWidth / implicitHeight) || 0
                anchors.fill: parent
                asynchronous: true
                source: currentGame.assets.cartridge || currentGame.assets.logo
                sourceSize { width: 512; height: 512 } // optimization (max size)
                fillMode: Image.PreserveAspectFit
                //horizontalAlignment: Image.AlignCenter
            }
        }
    }
}
