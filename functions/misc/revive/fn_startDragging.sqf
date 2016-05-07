#include "reviveDefines.hpp"

params ["_dragger", "_dragged"];

_dragged setPosASL (getPosASL _dragger vectorAdd (vectorDir _dragger vectorMultiply 1.5));

_dragged attachTo [_dragger, [0, 1, 0]];
_dragged setDir 180;
_dragged switchMove "AinjPpneMrunSnonWnonDb_still";

[{
    params ["_args", "_idPFH"];
    _args params ["_dragger","_dragged", "_startTime"];

    if (!alive _dragged || {!alive _dragger} || {!(isNull objectParent _dragger)} || {_dragger distance _dragged > 10}) then {
        if ((_dragger distance _dragged > 10) && {(derp_missionTime - _startTime) < 1}) exitWith {};
        [_dragger, _dragged, "DRAGGING"] call derp_revive_fnc_dropPerson;
        [_idPFH] call derp_fnc_removePerFrameHandler;
    };
} , 0.5, [_dragger, _dragged, derp_missionTime]] call derp_fnc_addPerFrameHandler;
