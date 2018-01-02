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
                        tail.currentTile = tail.nextTile
                    }
                }
                Component.onCompleted: {
                    if(index == 300){
                        tile.isSnake = true
                        tile.state = "right"
                        head.currentTile = tile
                        head.x = tile.col*tile.width
                        head.y = tile.row*tile.height
                    }
                    else if(index == 301)
                        head.nextTile = tile
                    else if(index == 298){
                        tile.state = "right"
                        tail.currentTile = tile
                        tail.x = tile.col*tile.width
                        tail.y = tile.row*tile.height
                    }
                    else if(index == 299){
                        tile.isSnake = true
                        tile.state = "right"
                        tail.nextTile = tile
                    }
                }
            }
        }
    }

    SnakeHead{
        id: head
        onStateChanged: {
            updateTargetTile()
            stateChangedFlag = true
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
                duration: snakeBoard.nextTileTime
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        head.stateChangedFlag = false
                        head.currentTile.isSnake = true
                        head.currentTile.state = head.state
                        head.updateTargetTile()
                        head.setCurrentTile()
                    }
                }
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: snakeBoard.nextTileTime
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        head.stateChangedFlag = false
                        head.currentTile.isSnake = true
                        head.currentTile.state = head.state
                        head.updateTargetTile()
                        head.setCurrentTile()
                    }
                }
            }
        }
    }

    SnakeTail{
        id: tail

        function updateTargetTile(){
            if(currentTile.state == "up")
                nextTile = tilesRepeater.itemAt((currentTile.row-1)*grid.columns+currentTile.col)
            else if(currentTile.state == "down"){
                nextTile = tilesRepeater.itemAt((currentTile.row+1)*grid.columns+currentTile.col)
            }
            else if(currentTile.state == "right"){
                nextTile = tilesRepeater.itemAt((currentTile.row)*grid.columns+currentTile.col + 1)
            }
            else if(currentTile.state == "left"){
                nextTile = tilesRepeater.itemAt((currentTile.row)*grid.columns+currentTile.col - 1)
            }
        }

        function setCurrentTile(){
            currentTile = nextTile
        }

        Behavior on x {
            NumberAnimation {
                duration: snakeBoard.nextTileTime
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        tail.currentTile.isSnake = false
                        tail.updateTargetTile()
                        tail.setCurrentTile()
                    }
                }
            }
        }
        Behavior on y {
            NumberAnimation {
                duration: snakeBoard.nextTileTime
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        tail.currentTile.isSnake = false
                        tail.updateTargetTile()
                        tail.setCurrentTile()
                    }
                }
            }
        }
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

