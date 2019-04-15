import QtQuick 2.8
import QtQuick.Layouts 1.11
import QtGraphicalEffects 1.12
import "utils.js" as Utils // some helper functions

Rectangle {
  id: root
  property var game
  // border.color: 'red'
  // border.width: vpx(5)

    Rectangle {
      id: metadataRect1
      anchors {
        top: parent.top; //topMargin: vpx(6)
        left: parent.left; //leftMargin: vpx(20)
        horizontalCenter: parent.horizontalCenter
      }
      width: parent.width
      height: vpx(80)
      color: "transparent"
      RowLayout {
        id: metadataRow1
        anchors{
          margins: vpx(6)
          left: parent.left
        }
        MetaBox { metaTitle: 'PLAYERS'; metaContent: game.players }
        MetaBox { metaTitle: 'RATING'; metaContent: (game.rating == "") ? "N/A" : Math.round(game.rating * 100) + '%'}
        MetaBox { metaTitle: 'LAST PLAYED'; metaContent: Utils.formatLastPlayed(game.lastPlayed) }
        MetaBox { metaTitle: 'RELEASED'; metaContent: ( Utils.formatDate(game.release) || "N/A" ) }
        MetaBox { metaTitle: 'TIME PLAYED'; metaContent: Utils.formatPlayTime(game.playTime) }
        MetaBox { metaTitle: 'GENRE'; metaContent: ( game.genre || "unknown" ) }
      }
    }

    //     GameDetailsText { metatext: 'Developer: ' + ( game.developer || "unknown" ) }
    //     GameDetailsText { metatext: '• Publisher: ' + ( game.publisher || "unknown" ) }
    //     GameDetailsText { metatext: '• Total Played: ' + Utils.formatPlayTime(game.playTime) }
    //     GameDetailsText { metatext: '• Last Played: ' + Utils.formatLastPlayed(game.lastPlayed) }
    //     GameDetailsText { metatext: '• Release Date: ' + ( Utils.formatDate(game.release) || "unknown" ) }

   Item {
     id: gameDescriptionRect
     //color: Qt.rgba(1, 1, 1, 0.1)
     //color: "transparent"//"#393a3b"
     //opacity: 1
     height: vpx(80)
     width: parent.width
     anchors {
         top: metadataRect1.bottom; topMargin: vpx(6)
         horizontalCenter: metadataRect1.horizontalCenter
     }

     GameInfoText {
         id: gameDescription
         width: vpx(300)
         anchors {
           fill: parent
           margins: vpx(6)
         }
         text: game.description
         wrapMode: Text.WordWrap
         elide: Text.ElideRight
         color: "#f3f3f3"
     }
  }
}
