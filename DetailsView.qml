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

    // Generate Tiled Background....
    // Todo: Figure out row/column count based on something.
    // Todo: Make row/column render with out pop in (or animate...)
    Item {
      id: bgRect
      anchors.top: parent.top
      anchors.left: parent.left
      Item {
        width: root.width
        height: root.height
        id: bgBlock
        opacity: 0.5
        layer.enabled: true
        Row {
          Repeater {
            model: 144
            Column {
              Repeater {
                model: 78
                Rectangle {
                  width: 18
                  height: 18
                  color: "black"
                  border.color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                  border.width: 1
                  radius: 1
                }
              }
            }
          }
        }
      }
      // Gradient Yo!
      Rectangle {
        id: bgRectGradient
        width: root.width
        height: root.height
        color: "transparent"
        layer.enabled: true
        //z: parent.z + 1
        LinearGradient {
          anchors.fill: parent
          start: Qt.point(0, 0)
          end: Qt.point(0, vpx(1024))
          gradient: Gradient {
              GradientStop {
                 position: 0.000
                 color: Qt.rgba(0.0, 0, 0.1, 0.9)
              }
              GradientStop {
                 position: 0.999
                 color: Qt.rgba(0.0, 0, 0, 0)
              }
          }
        }
      }
    }

    Rectangle {
      id: rightMenuBG
      width: parent.width * 0.26
      height: root.height
      color: "transparent"
      anchors {
        top: root.top
        right: parent.right
        bottom: root.bottom
        }

      LinearGradient {
        anchors.fill: parent
        start: Qt.point(0, 0)
        end: Qt.point(100, 0)
        gradient: Gradient {
          GradientStop {
             position: 0.000
             color: "transparent"
          }
          GradientStop {
             position: 0.02
             color: Qt.rgba(0.0, 0.0, 0.0, 0.9)
          }
          GradientStop {
             position: 0.05
             color: Qt.rgba(0.3, 0.3, 0.3, 0.9)
          }
        }
      }
      // Image {
      //   id: systemLogo
      //   source: currentCollection.shortName ? "logo/%1.svg".arg(currentCollection.shortName) : ""
      //   width: vpx(216)
      //     anchors {
      //       horizontalCenter: rightMenuBG.horizontalCenter
      //       topMargin: vpx(30)
      //       top: parent.top
      //     }
      //     fillMode: Image.PreserveAspectFit
      //     horizontalAlignment: Image.AlignLeft
      //     asynchronous: true
      // }
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
        width: root.width * 0.74
        color: "transparent"

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
          id: header_box
          width: textMetrics.width + vpx(20)
          height: textMetrics.height + vpx(20)
          color: "#393a3b"
          anchors.left: parent.left
          anchors.leftMargin: content.paddingH
          anchors.verticalCenter: parent.verticalCenter
          opacity: 0.6
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

        Rectangle {
          id: metadataRect1
          anchors {
            top: header_box.bottom; topMargin: vpx(8)
          }
          width: root.width * 0.74
          height: metadataRow1.height
          clip: true
          color: "transparent"
          RowLayout {
            id: metadataRow1
            anchors { left: parent.left; leftMargin: content.paddingH }
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
          }
          width: root.width * 0.74
          height: metadataRow2.height
          clip: true
          color: "transparent"
          RowLayout {
            id: metadataRow2
            anchors { left: parent.left; leftMargin: content.paddingH }
            GameDetailsText { metatext: 'Developer: ' + currentGame.developer || "unknown" }
            GameDetailsText { metatext: 'Publisher: ' + currentGame.publisher || "unknown" }
            GameDetailsText { metatext: 'Genre: ' + currentGame.genre || "unknown" }
            }
        }
    }

    Rectangle {
        id: content
        anchors.top: root.top//header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: root.bottom
        color: "transparent"

        readonly property int paddingH: vpx(30)
        readonly property int paddingV: vpx(40)

        Item {
            id: boxart

            height: vpx(218)
            width: Math.max(vpx(160), Math.min(height * boxartImage.aspectRatio, vpx(320)))
            anchors {
                top: parent.top; topMargin: vpx(150)
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
            width: parent.width * 0.26
            anchors {
                top: parent.top; //topMargin: content.paddingV
                right: parent.right; //rightMargin: content.paddingH
                bottom: parent.bottom; bottomMargin: vpx(20)
                topMargin: vpx(20)
            }
            //clip: true

            focus: true

            model: currentCollection.games
            delegate: Rectangle {
                readonly property bool selected: ListView.isCurrentItem
                readonly property color clrDark: "#393a3b"
                readonly property color clrDarkBG: Qt.rgba(1, 1, 1, 0.1)
                readonly property color clrLight: "#97999b"
                readonly property color clrLightBG: Qt.rgba(0.5, 0.5, 0.5, 0.1)
                readonly property color transparent: "transparent"

                width: ListView.view.width
                height: gameTitle.height
                //color: transparent
                opacity: 1
                color: selected ? clrLight : transparent

                Text {
                    id: gameTitle
                    text: modelData.title
                    color: selected ? parent.clrDark : parent.clrLight

                    font.pixelSize: parent.selected ? vpx(16) : vpx(16)
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
