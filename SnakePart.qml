import QtQuick 2.0

Rectangle {
    id: snakePart
    property color snakePartColor: "#BBBBFF"
    color: snakePartColor

    width: 40
    height: width
    // This is the behavior, and it applies a NumberAnimation to any attempt to set the x property
}
