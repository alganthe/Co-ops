/*
* Author: alganthe
* Initiate dragging animations, when done will call the proper function to actually start the dragging
*
* Arguments:
* 0: Unit doing the dragging <OBJECT>
* 1: Unit being dragged <OBJECT>
*
* Return Value:
* Nothing
*/
params ["_dragger", "_dragged"];

[_dragger] allowGetIn false;

_dragged setDir (getDir _dragger + 180);
_dragged setPosASL (getPosASL _dragger vectorAdd (vectorDir _dragger vectorMultiply 1.5));

_dragger playActionNow "grabDrag";
_dragged playMove "AinjPpneMrunSnonWnonDb_grab";

[{
    params ["_args", "_idPFH"];
    _args params ["_dragger", "_dragged", "_timeOut"];

    // handle aborting drag
    if !(_dragger getVariable ["derp_revive_isDragging", false]) exitWith {
        [_dragger, _dragged, "DRAGGING"] call derp_revive_fnc_dropPerson;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };

    if (!alive _dragged || {!alive _dragger}) then {
        [_dragger, _dragged, "DRAGGING"] call derp_revive_fnc_dropPerson;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };

    if (derp_missionTime > _timeOut) exitWith {
        [_dragger, _dragged, "DRAGGING"] call derp_revive_fnc_dropPerson;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };

    // unit is ready to start dragging
    if (animationState _dragger in ["amovpercmstpslowwrfldnon_acinpknlmwlkslowwrfldb_2", "amovpercmstpsraswpstdnon_acinpknlmwlksnonwpstdb_2", "amovpercmstpsnonwnondnon_acinpknlmwlksnonwnondb_2", "acinpknlmstpsraswrfldnon", "acinpknlmstpsnonwpstdnon", "acinpknlmstpsnonwnondnon", "acinpknlmwlksraswrfldb", "acinpknlmwlksnonwnondb"]) exitWith {
        [_dragger, _dragged] call derp_revive_fnc_startDragging;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };
}, 0.2, [_dragger, _dragged, derp_missionTime + 5]] call derp_fnc_addPerFrameHandler;
