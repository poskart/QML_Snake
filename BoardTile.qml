import QtQuick 2.0

Rectangle{
    id: tile
    height: 40
    width: height
    color: "#003311"
    property int row
    property int col
    property bool isSnake: false

    states:[
        State{
            name: "right"
        },
        State{
            name: "left"
        },
        State{
            name: "up"
        },
        State{
            name: "down"
        }
    ]

    Rectangle{
        id: innerRect
        height: tile.height - 6
        width: tile.width - 6
        color: "#006622"
        anchors.centerIn: tile
    }
    onIsSnakeChanged: {
        if(isSnake){
            tile.color = "#BBBBFF"
            innerRect.color = "#BBBBFF"
        }
        else{
            tile.color = "#003311"
            innerRect.color = "#006622"
        }
    }
}
