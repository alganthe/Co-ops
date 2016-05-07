#include "reviveDefines.hpp"
params ["_dragger", "_dragged", "_state"];

_state = toUpper _state;
if !(_state in ["DRAGGING", "CARRYING"]) exitWith {};

switch (_state) do {
    case "DRAGGING": {

        detach _dragged;

        _dragged switchMove "acts_injuredlyingrifle02_180";

        if (alive _dragger && {isNull objectParent _dragger}) then {

            _dragger playAction "released";
        };

        _dragger setVariable ["derp_revive_isDragging", false, true];
        _dragged setVariable ["derp_revive_isDragged", false, true];
    };

    case "CARRYING": {
        detach _dragged;

        _dragger switchMove "";
        _dragged switchMove "acts_injuredlyingrifle02_180";

        if (alive _dragger && {isNull objectParent _dragger}) then {
            // play release animation
            _dragged switchMove "acts_injuredlyingrifle02_180";
        };

        _dragger setVariable ["derp_revive_isCarrying", false, true];
        _dragged setVariable ["derp_revive_isCarried", false, true];
    };
};
