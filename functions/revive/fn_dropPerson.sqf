/*
* Author: alganthe
* Drop the person from carrying / dragging
*
* Arguments:
* 0: Unit doing the dragging / carrying <OBJECT>
* 1: Unit being dragged / carried <OBJECT>
* 2: State <DRAGGING, CARRYING or VEHICLE>
*
* Return Value:
* Nothing
*/
params ["_dragger", "_dragged", "_state"];

_state = toUpper _state;
if !(_state in ["DRAGGING", "CARRYING"]) exitWith {};

switch (_state) do {
    case "DRAGGING": {

        detach _dragged;

        if (alive _dragged && {isNull objectParent _dragged}) then {
            [_dragged, "acts_injuredlyingrifle02_180"] call derp_fnc_syncAnim;
        };

        if (alive _dragger && {isNull objectParent _dragger}) then {
            _dragger playActionNow "released";
        };

        _dragger setVariable ["derp_revive_isDragging", false, true];
        _dragged setVariable ["derp_revive_isDragged", false, true];
    };

    case "CARRYING": {
        detach _dragged;

        if (alive _dragged && {isNull objectParent _dragged}) then {
            [_dragged, "acts_injuredlyingrifle02_180"] call derp_fnc_syncAnim;
        };

        if (alive _dragger && {isNull objectParent _dragger}) then {
            [_dragger, ""] call derp_fnc_syncAnim;
        };

        _dragger setVariable ["derp_revive_isCarrying", false, true];
        _dragged setVariable ["derp_revive_isCarried", false, true];
    };
};
