import QtQuick 2.0

SnakePart {
    Behavior on x {

        NumberAnimation {
            //This specifies how long the animation takes
            duration: snakeBoard.nextTileTime
            //This selects an easing curve to interpolate with, the default is Easing.Linear
            easing.type: Easing.Linear
        }
    }
    Behavior on y {

        NumberAnimation {
            //This specifies how long the animation takes
            duration: snakeBoard.nextTileTime
            //This selects an easing curve to interpolate with, the default is Easing.Linear
            easing.type: Easing.Linear
        }
    }
}
