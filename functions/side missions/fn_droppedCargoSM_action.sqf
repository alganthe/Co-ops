/*
* Author: alganthe
* Add / delete the cargoSM box action
*
* Arguments:
* 0: Add action <BOOL>
* 1: cargoSM objective <OBJECT>
*
* Return Value:
* Nothing
*/

params [["_add", false], ["_box", objNull]];

if (_box isEqualTo objNull && {_add}) exitWith {};

if (_add) then {
    derp_droppedCargoSM_actionID = _box addAction
        [
            "Place explosives",
            {
                params ["_object", "_caller", "_id", ""];

                [_object] remoteExecCall ["derp_fnc_droppedCargoSM_actionPFH", 2];

                _object removeAction _id;
                [false] remoteExecCall ["derp_fnc_droppedCargoSM_action", -2, "droppedCargoSM_action"];
                // Remove remoteExec'd action from the JIP queue
                remoteExecCall ["", "droppedCargoSM_action"];
            },
            [],
            10,
            true,
            true
        ];
} else {
    if !(isNil "derp_droppedCargoSM_actionID") then {
        _box removeAction derp_droppedCargoSM_actionID
    };
};
