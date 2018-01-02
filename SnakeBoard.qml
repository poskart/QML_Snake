import QtQuick 2.0

Rectangle {
    id: snakeBoard
    anchors.fill: parent

    property int nextTileTime: 500
    property BoardTile tailTile
    property BoardTile headTile

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
                        head.currentTile = head.nextTile
                    }
                }
                Component.onCompleted: {
                    if(index == 300){
                        tile.isSnake = true
                        head.currentTile = tile
                        head.x = tile.col*40
                        head.y = tile.row*40
                    }
                    else if(index == 301)
                        head.nextTile = tile
                    else if(index == 298)
                        tailTile = tile
                }
            }
        }
    }

    SnakeHead{
        id: head
        x: 480
        y: 240
        currentTile: headTile
        nextTile: headTile
        onStateChanged: {
            updateTargetTile()
            stateChangedFlag = true
        }
        onCurrentTileChanged: {
            x = currentTile.x
            y = currentTile.y
        }

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

        function setCurrentTile(){
            currentTile = nextTile
            stateChangedFlag = false
        }

        Behavior on x {

            NumberAnimation {
                //This specifies how long the animation takes
                duration: snakeBoard.nextTileTime
                //This selects an easing curve to interpolate with, the default is Easing.Linear
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        head.stateChangedFlag = false
                        head.currentTile.isSnake = true
                        head.updateTargetTile()
                        head.setCurrentTile()
                    }
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
                    if(running == false){
                        head.stateChangedFlag = false
                        head.currentTile.isSnake = true
                        head.updateTargetTile()
                        head.setCurrentTile()
                    }
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

