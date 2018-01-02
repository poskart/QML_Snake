import QtQuick 2.0

Rectangle {
    id: snakePart
    property color snakePartColor: "#BBBBFF"
    property color fromColor
    property color toColor
    color: snakePartColor

//    property int tileX:0
//    property int tileY:0

    width: 40
    height: width
    // This is the behavior, and it applies a NumberAnimation to any attempt to set the x property
}
