import QtQuick 2.0

Rectangle {
    id: snakePart
    property BoardTile currentTile
    property BoardTile nextTile
    property color snakePartColor: "#BBBBFF"
    color: snakePartColor
    width: 40
    height: width

    onCurrentTileChanged: {
        if(currentTile != null){
            x = currentTile.x
            y = currentTile.y
        }
    }
}
