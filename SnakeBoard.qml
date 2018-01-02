import QtQuick 2.0

Rectangle {
    id: snakeBoard
    anchors.fill: parent

    property int nextTileTime: 500

    property BoardTile headTile
    property BoardTile tailTile

    Grid{
        id: grid
        rows: 1080/40
        columns: 1920/40
        anchors.fill: parent
        Repeater {
            id: tilesRepeater
            model: grid.rows * grid.columns
            BoardTile{
                id: tile
                row: index/grid.columns
                col: index%grid.columns
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        console.log("before clicked: X", head.x)
                        head.x = tile.x
                        head.y = tile.y
                        headTile = tile
                        console.log("after clicked: X", head.x)
                    }
                }
                Component.onCompleted: {
                    if(index == 300)
                        headTile = tile
                    else if(index == 298)
                        tailTile = tile
                }
            }
        }
    }

    SnakeHead{
        id: head
        x: headTile.x
        y: headTile.y
        currentTile: headTile
        onStateChanged: {
            updateTargetTile()
            stateChangedFlag = true
        }
//        onCurrentTileChanged: {
//            x = currentTile.x
//            y = currentTile.y
//        }

        function updateTargetTile(){
            if(!stateChangedFlag && currentTile != null){
                if(state == "up"){
                    nextTile = tilesRepeater.itemAt((currentTile.row-1)*grid.columns+currentTile.col)
                }
                else if(state == "down"){
                    nextTile = tilesRepeater.itemAt((currentTile.row+1)*grid.columns+currentTile.col)
                }
                else if(state == "right"){
                    nextTile = tilesRepeater.itemAt((currentTile.row)*grid.columns+currentTile.col + 1)
                }
                else if(state == "left"){
                    nextTile = tilesRepeater.itemAt((currentTile.row)*grid.columns+currentTile.col - 1)
                }
            }
        }
        Behavior on x {

            NumberAnimation {
                //This specifies how long the animation takes
                duration: snakeBoard.nextTileTime
                //This selects an easing curve to interpolate with, the default is Easing.Linear
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == true){
                        head.currentTile.isSnake = true
                    }
//                    else if(running == false){
//                        head.currentTile = head.nextTile
//                        head.stateChangedFlag = false
//                    }
                }
            }
        }
        Behavior on y {

            NumberAnimation {
                //This specifies how long the animation takes
                duration: snakeBoard.nextTileTime
                //This selects an easing curve to interpolate with, the default is Easing.Linear
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == true){
                        head.currentTile.isSnake = true
                    }
//                    else if(running == false){
//                        head.currentTile = head.nextTile
//                        head.stateChangedFlag = false
//                    }
                }
            }
        }
    }

    SnakeTail{
        id: tail
        x: tailTile.x
        y: tailTile.y
    }


    focus: true
    Keys.onPressed: {
        if (event.key == Qt.Key_Left) {
            console.log("move left")
            if(!head.stateChangedFlag && head.state != "right"){
                head.state = "left"
            }
        }
        else if(event.key == Qt.Key_Right){
            console.log("move right")
            if(!head.stateChangedFlag && head.state != "left"){
                head.state = "right"
            }
        }
        else if(event.key == Qt.Key_Up){
            console.log("move up")
            if(!head.stateChangedFlag && head.state != "down"){
                head.state = "up"
            }
        }
        else if(event.key == Qt.Key_Down){
            console.log("move down")
            if(!head.stateChangedFlag && head.state != "up"){
                head.state = "down"
            }
        }
        else if(event.key == Qt.Key_Escape){
            console.log("Game over")
            Qt.quit()
        }
        else if(event.key == Qt.Key_N){
            snake.addSnakePart()
        }

        event.accepted = true
    }
}

