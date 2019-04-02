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


import QtQuick 2.6
import QtMultimedia 5.9

Item {
    property var game

    onGameChanged: {
        videoPreview.stop();
        videoPreview.playlist.clear();
        videoDelay.restart();
        gameDebug.gameDebug(game);
    }

    // a small delay to avoid loading videos during scrolling
    Timer {
        id: videoDelay
        interval: 250
        onTriggered: {
            if (game && game.assets.videos.length > 0) {
                for (var i = 0; i < game.assets.videos.length; i++)
                    videoPreview.playlist.addItem(game.assets.videos[i]);

                videoPreview.play();
            }
        }
    }

    Item {
      id: gameDebug
      function gameDebug(game) {
        console.warn("video count: ", game.assets.videos.length);
        }
    }

    Rectangle {
        id: videoBox
        color: "transparent"

        // anchors.top: logo.bottom
        // anchors.bottom: parent.bottom
        anchors.fill: parent
        //border { color: "#444"; width: 1 }
        width: Image.width //vpx(512)
        height: Image.height
        //radius: vpx(4)
        clip: true
        visible: (game && (game.assets.videos.length || game.assets.screenshots.length)) || false

        Video {
            id: videoPreview
            visible: playlist.itemCount > 0

            anchors { fill: parent; margins: 1 }
            fillMode: VideoOutput.PreserveAspectFit

            playlist: Playlist {
                playbackMode: Playlist.Loop
            }
        }

        Image {
            visible: !videoPreview.visible

            anchors { fill: parent; margins: 1 }
            fillMode: Image.PreserveAspectFit

            source: (game && game.assets.screenshots.length && game.assets.screenshots[0]) || ""
            sourceSize { width: 512; height: 512 }
            asynchronous: true
        }
    }
}
