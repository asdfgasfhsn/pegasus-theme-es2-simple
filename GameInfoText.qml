import QtQuick 2.0

// All the game details text have the same basic properties
// so I've moved them into a new QML type.

Text {
    font.pixelSize: vpx(10)
    font.family: "Open Sans"
    font.weight: Font.Bold
    color: "#393a3b"
    elide: Text.ElideRight
}
