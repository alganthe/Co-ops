/*
* Author: alganthe
* Initiate the carrying animations, when done will call the proper function to actually start the carrying
*
* Arguments:
* 0: Unit doing the carrying <OBJECT>
* 1: Unit being carried <OBJECT>
*
* Return Value:
* Nothing
*/
params ["_dragger", "_dragged"];

[_dragger] allowGetIn false;

private _timer = derp_missionTime + 5;


[_dragged, ((getDir _dragger) + 180)] remoteExec ["setDir", _dragged];
_dragged setPosASL (getPosASL _dragger vectorAdd (vectorDir _dragger));

[_dragger, "AcinPknlMstpSnonWnonDnon_AcinPercMrunSnonWnonDnon"] call derp_fnc_syncAnim;
[_dragged, "AinjPfalMstpSnonWrflDnon_carried_Up"] call derp_fnc_syncAnim;

private _timer = derp_missionTime + 15;

[{
    params ["_args", "_idPFH"];
    _args params ["_dragger", "_dragged", "_timeOut"];

    if !(_dragger getVariable ["derp_revive_isCarrying", false]) exitWith {
        _dragger setVariable ["derp_revive_isCarrying", false, true];
        _dragged setVariable ["derp_revive_isCarried", false, true];
        [_dragged, "acts_injuredlyingrifle02_180"] call derp_fnc_syncAnim;
        _dragger playActionNow "released";
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };

    if (!alive _dragged || {_dragger distance _dragged > 10}) then {
        _dragger setVariable ["derp_revive_isCarrying", false, true];
        _dragged setVariable ["derp_revive_isCarried", false, true];
        [_dragged, "acts_injuredlyingrifle02_180"] call derp_fnc_syncAnim;
        _dragger playActionNow "released";
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };

    if (derp_missionTime > _timeOut) exitWith {
        [_dragger, _dragged] call derp_revive_fnc_startCarrying;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };
}, 0.2, [_dragger, _dragged, derp_missionTime + 5]] call derp_fnc_addPerFrameHandler;
