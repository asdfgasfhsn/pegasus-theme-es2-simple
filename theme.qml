import QtQuick 2.0
import QtGraphicalEffects 1.12
// Welcome! This is the entry point of the theme; it defines two "views"
// and a way to move (and animate moving) between them.
FocusScope {
    // When the theme loads, try to restore the last selected game
    // and collection. If this is the first time launching this theme, these
    // values will be undefined, which is why there are zeroes as fallback
    Component.onCompleted: {
        collectionsView.currentCollectionIndex = api.memory.get('collectionIndex') || 0;
        // detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
    }

    // Loading the fonts here makes them usable in the rest of the theme
    // and can be referred to using their name and weight.
    FontLoader { source: "fonts/OPENSANS.TTF" }
    FontLoader { source: "fonts/OPENSANS-LIGHT.TTF" }
    // Draw grid background for all views
    Item {
      id: bgRect
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      Item {
        width: parent.width
        height: parent.height
        id: bgBlock
        opacity: 0.5
        Row {
          Repeater {
            model: 144
            Column {
              Repeater {
                model: 78
                Rectangle {
                  width: vpx(20)
                  height: vpx(20)
                  color: "black"
                  border.color: Qt.rgba(0.5, 0.5, 0.5, 0.3)
                  border.width: 1
                  radius: 0
                }
              }
            }
          }
        }
      }
    }

    // The actual views are defined in their own QML files. They activate
    // each other by setting the focus. The details view is glued to the bottom
    // of the collections view, and the collections view to the bottom of the
    // screen for animation purposes (see below).
    CollectionsView {
        id: collectionsView
        anchors.bottom: parent.bottom

        focus: true
        onCollectionSelected: {
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
          detailsView.focus = true
        }
    }
    DetailsView {
        id: detailsView
        anchors.top: collectionsView.bottom

        currentCollection: collectionsView.currentCollection

        onCancel: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.focus = true
        }
        onNextCollection: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.selectNext()
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
        }
        onPrevCollection: {
          api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
          api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
          collectionsView.selectPrev()
          detailsView.currentGameIndex = api.memory.get(currentCollection.shortName + 'GameIndex') || 0;
        }
        onLaunchGame: {
            api.memory.set('collectionIndex', collectionsView.currentCollectionIndex);
            api.memory.set(currentCollection.shortName + 'GameIndex', currentGameIndex);
            currentGame.launch();
        }
    }

    // I animate the collection view's bottom anchor to move it to the top of
    // the screen. This, in turn, pulls up the details view.
    states: [
        State {
            when: detailsView.focus
            AnchorChanges {
                target: collectionsView;
                anchors.bottom: parent.top
            }
        }
    ]
    // Add some animations. There aren't any complex State definitions so I just
    // set a generic smooth anchor animation to get the job done.
    transitions: Transition {
        AnchorAnimation {
            duration: 1500
            easing.type: Easing.OutQuad
        }
    }
}
