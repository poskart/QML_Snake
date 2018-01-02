import QtQuick 2.0

Rectangle {
    id: snakeBoard
    anchors.fill: parent

    property int nextTileTime: 200
    property BoardTile tailTile
    property BoardTile headTile

    function generateFood(){
        var randomIndex = Math.floor(Math.random() * (grid.columns * grid.rows))
        var tmpTile = tilesRepeater.itemAt(randomIndex)
        tmpTile.isFood = true
    }

    Grid{
        id: grid
        rows: 1040/40
        columns: 1840/40
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
                        snakeBoard.generateFood()
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

        function checkFood(){
            if(head.currentTile.isFood){
                tail.pauseAnimations()
            }
        }

        function checkCollision(){
            if((head.currentTile.row == 0 && head.state == "up") ||
                    (head.currentTile.row == (grid.rows - 1) && head.state == "down") ||
                    (head.currentTile.col == 0 && head.state == "left") ||
                    (head.currentTile.col == (grid.columns - 1) && head.state == "right"))
                Qt.quit()
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
            if(head.currentTile != null){
                checkCollision()
            }
        }

        function setCurrentTile(){
            currentTile = nextTile
            stateChangedFlag = false
        }

        Behavior on x {
            id: behaviorXHead
            NumberAnimation {
                id: xAnimHead
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
                    else if(running == true){
                        head.checkFood()
                    }
                }
            }
        }
        Behavior on y {
            id: behaviorYHead
            NumberAnimation {
                id: yAnimHead
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
                    else if(running == true){
                        head.checkFood()
                    }
                }
            }
        }
    }

    SnakeTail{
        id: tail
        property NumberAnimation pausedAnimation

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

        function pauseAnimations(){
            if(behaviorXTail.animation.running){
                pausedAnimation = behaviorXTail.animation
            }
            else if(behaviorYTail.animation.running){
                pausedAnimation = behaviorYTail.animation
            }
            pausedAnimation.pause()
        }

        function resumeAnimations(){
            pausedAnimation.resume()
        }

        Behavior on x {
            id: behaviorXTail
            NumberAnimation {
                id: xAnimTail
                duration: snakeBoard.nextTileTime
                easing.type: Easing.Linear
                onRunningChanged: {
                    if(running == false){
                        tail.currentTile.isSnake = false
                        tail.currentTile.isFood = false
                        tail.updateTargetTile()
                        tail.setCurrentTile()
                    }
                }
            }
        }
        Behavior on y {
            id: behaviorYTail
            NumberAnimation {
                id: yAnimTail
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

