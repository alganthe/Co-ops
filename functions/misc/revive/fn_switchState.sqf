#include "reviveDefines.hpp"

params ["_unit", "_state"];

if (isNull _unit) exitWith {};

_state = toUpper _state;
if !(_state in ["ALIVE", "DOWNED", "REVIVED"]) exitWith {};

switch (_state) do {
    case "DOWNED": {
        // Disable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "Action", "NextAction"]};

        // Disable moving and being shot at.
        _unit disableAI "MOVE";
        _unit setCaptive true;

        // Because BI loves race conditions....
        [{
            params ["_unit"];

            _unit switchMove "acts_injuredlyingrifle02_180";
            _unit setPosWorld (_unit getVariable "derp_revive_corpsePos");
            _unit setDir (_unit getVariable "derp_revive_corpseDir");

            [_unit, [_unit, "derp_revive_loadout"]] call bis_fnc_loadInventory;
            [_unit, [_unit, "derp_revive_loadout"], nil, true] call bis_fnc_saveInventory;

            [_unit] call derp_revive_fnc_reviveTimer;
            [true] call derp_fnc_disableUserInput;
            call derp_revive_fnc_hotkeyHandler;

            //fade in
            _unit switchCamera "external";
            titleCut ["","BLACK IN",1];

        }, [_unit], 2] call derp_fnc_waitAndExecute;
    };

    case "ALIVE": {
        // Enable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "Action", "NextAction"]};

        [false] call derp_fnc_disableUserInput;
        _unit setCaptive false;
        _unit setVariable ["derp_revive_downed", false, true];
    };

    case "REVIVED": {
        // Enable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "Action", "NextAction"]};

        if !(isNil "derp_reviveKeyDownID") then {
            (findDisplay 46) displayRemoveEventHandler ["KeyDown", derp_reviveKeyDownID];
            (findDisplay 46) displayRemoveEventHandler ["KeyUp", derp_reviveKeyUpID];
        };

        [false] call derp_fnc_disableUserInput;
        _unit setCaptive false;
        _unit setDamage 0.5;
        _unit setVariable ["derp_revive_downed", false, true];

        _unit switchMove DERP_REVIVE_WAKEUPANIM;
    };
};
