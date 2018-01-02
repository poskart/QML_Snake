import QtQuick 2.0

SnakePart {
    property bool stateChangedFlag: false
    property BoardTile currentTile
    property BoardTile nextTile
    state: "right"
    states: [
        State{
            name: "up"
        },
        State{
            name: "down"
        },
        State{
            name: "right"
        },
        State{
            name: "left"
        }
    ]
}
