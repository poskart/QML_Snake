import QtQuick 2.0

SnakePart {
    property bool stateChangedFlag: false
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
