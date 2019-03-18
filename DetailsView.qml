import QtQuick 2.7 // note the version: Text padding is used below and that was added in 2.7 as per docs
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

    Image {
      id: tiled_background
      // TODO: Make Tile Betterer so it scales nicer...
      source: 'bg/tile_bg.png'
      fillMode: Image.Tile
      horizontalAlignment: Image.AlignLeft
      verticalAlignment: Image.AlignTop
          anchors {
              left: root.left;
              top: root.top;
              bottom: root.bottom;
              right: root.right;
          }
    }

    // The header ba on the top, with the collection's logo and name
    Rectangle {
        id: header

        readonly property int paddingH: vpx(30) // H as horizontal
        readonly property int paddingV: vpx(22) // V as vertical

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: vpx(115)
        color: "transparent"

        // anchors.fill: parent
        // asynchronous: true
        // source: currentGame.assets.boxFront || currentGame.assets.logo
        // sourceSize { width: 256; height: 256 } // optimization (max size)
        // fillMode: Image.PreserveAspectFit
        // horizontalAlignment: Image.AlignLeft

        // TODO: Use this else where once things have "settled"
        Rectangle {
          // Draw a semi-opaque rectangle to wrap the text
          id: systemLogoBG
          height: systemLogo.height + vpx(20)
          width: systemLogo.width + vpx(20)
          color: "#393a3b"
          anchors.verticalCenter: parent.verticalCenter
          anchors.left: parent.left;
          anchors.leftMargin: header.paddingH
          opacity: 0
        }

        Image {
          id: systemLogo
          source: currentCollection.shortName ? "logo/%1.svg".arg(currentCollection.shortName) : ""
          width: vpx(216)
          //width: Math.max(vpx(120))
            anchors {
              verticalCenter: systemLogoBG.verticalCenter
              horizontalCenter: systemLogoBG.horizontalCenter
            }
            fillMode: Image.PreserveAspectFit
            horizontalAlignment: Image.AlignLeft
            asynchronous: true
        }

        TextMetrics {
          // Define current game text information
          id: textMetrics
          text: currentGame.title
          font.family: "Open Sans"
          font.weight: Font.Bold
          font.pixelSize: vpx(42)
          font.capitalization: Font.AllUppercase
        }

        Rectangle {
          // Draw a semi-opaque rectangle to wrap the text
          id: header_box
          width: textMetrics.width + vpx(20)
          height: textMetrics.height + vpx(20)
          color: "#393a3b"
          anchors.right: parent.right
          anchors.rightMargin: content.paddingH
          anchors.verticalCenter: parent.verticalCenter
          opacity: 0.6
          //rotation: 2
        }

        Text {
            // Render current game text
            text: textMetrics.text
            font: textMetrics.font
            color: "#97999b"
            anchors {
                verticalCenter: header_box.verticalCenter
                horizontalCenter: header_box.horizontalCenter
                margins: vpx(10)
            }
        }

    }

    Rectangle {
        id: content
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: footer.top
        color: "transparent"

        readonly property int paddingH: vpx(30)
        readonly property int paddingV: vpx(40)

        Item {
            id: boxart

            height: vpx(218)
            width: Math.max(vpx(160), Math.min(height * boxartImage.aspectRatio, vpx(320)))
            anchors {
                top: parent.top; topMargin: content.paddingV
                left: parent.left; leftMargin: content.paddingH
            }

            Image {
                id: boxartImage

                readonly property double aspectRatio: (implicitWidth / implicitHeight) || 0

                anchors.fill: parent
                asynchronous: true
                source: currentGame.assets.boxFront || currentGame.assets.logo
                sourceSize { width: 256; height: 256 } // optimization (max size)
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignLeft
            }
        }

        // While the game details could be a grid, I've separated them to two
        // separate columns to manually control thw width of the second one below.
        Column {
            id: gameLabels
            anchors {
                top: boxart.top
                left: boxart.right; leftMargin: content.paddingH
            }

            GameInfoText { text: "Rating:" }
            GameInfoText { text: "Released:" }
            GameInfoText { text: "Developer:" }
            GameInfoText { text: "Publisher:" }
            GameInfoText { text: "Genre:" }
            GameInfoText { text: "Players:" }
            GameInfoText { text: "Last played:" }
            GameInfoText { text: "Play time:" }
        }

        Column {
            id: gameDetails
            anchors {
                top: gameLabels.top
                left: gameLabels.right; leftMargin: content.paddingH
                right: gameList.left; rightMargin: content.paddingH
            }

            // 'width' is set so if the text is too long it will be cut. I also use some
            // JavaScript code to make some text pretty.
            RatingBar { percentage: currentGame.rating }
            GameInfoText { width: parent.width; text: Utils.formatDate(currentGame.release) || "unknown" }
            GameInfoText { width: parent.width; text: currentGame.developer || "unknown" }
            GameInfoText { width: parent.width; text: currentGame.publisher || "unknown" }
            GameInfoText { width: parent.width; text: currentGame.genre || "unknown" }
            GameInfoText { width: parent.width; text: Utils.formatPlayers(currentGame.players) }
            GameInfoText { width: parent.width; text: Utils.formatLastPlayed(currentGame.lastPlayed) }
            GameInfoText { width: parent.width; text: Utils.formatPlayTime(currentGame.playTime) }
        }

        GameInfoText {
            id: gameDescription
            anchors {
                top: boxart.bottom; topMargin: content.paddingV
                left: boxart.left
                right: gameList.left; rightMargin: content.paddingH
                bottom: parent.bottom; bottomMargin: content.paddingV
            }

            text: currentGame.description
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }

        ListView {
            id: gameList
            width: parent.width * 0.35
            anchors {
                top: parent.top; topMargin: content.paddingV
                right: parent.right; rightMargin: content.paddingH
                bottom: parent.bottom; bottomMargin: content.paddingV
            }
            //clip: true

            focus: true

            model: currentCollection.games
            delegate: Rectangle {
                readonly property bool selected: ListView.isCurrentItem
                readonly property color clrDark: "#393a3b"
                readonly property color clrLight: "#97999b"
                readonly property color transparent: "transparent"

                width: ListView.view.width
                height: gameTitle.height
                color: transparent
                // color: selected ? transparent : clrLight
                LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(100, 100)
                gradient: Gradient {
                    GradientStop {
                       position: 0.000
                       color: Qt.rgba(0.5, 0.5, 0.5, 0.2)
                      }
                      // GradientStop {
                      //    position: 0.167
                      //    color: Qt.rgba(1, 1, 0, 1)
                      // }
                      // GradientStop {
                      //    position: 0.333
                      //    color: Qt.rgba(0, 1, 0, 1)
                      // }
                      // GradientStop {
                      //    position: 0.500
                      //    color: Qt.rgba(0, 1, 1, 1)
                      // }
                      // GradientStop {
                      //    position: 0.667
                      //    color: Qt.rgba(0, 0, 1, 1)
                      // }
                      // GradientStop {
                      //    position: 0.833
                      //    color: Qt.rgba(1, 0, 1, 1)
                      // }
                    GradientStop {
                       position: 0.666
                       color: transparent
                    }
                  }
                }
                Text {
                    id: gameTitle
                    text: modelData.title
                    color: selected ? parent.clrLight : parent.clrDark

                    font.pixelSize: parent.selected ? vpx(20) : vpx(20)
                    font.capitalization: Font.AllUppercase
                    font.family: "Open Sans"

                    lineHeight: 1.2
                    verticalAlignment: Text.AlignVCenter

                    width: parent.width
                    elide: Text.ElideRight
                    leftPadding: vpx(10)
                    rightPadding: leftPadding
                }
            }

            highlightRangeMode: ListView.ApplyRange
            highlightMoveDuration: 0
            preferredHighlightBegin: height * 0.5 - vpx(15)
            preferredHighlightEnd: height * 0.5 + vpx(15)
        }
    }

    Rectangle {
        id: footer
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: vpx(25) * 1.5
        color: header.color
    }
}
