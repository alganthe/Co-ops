/*
* Author: alganthe
* Handles the revive states
*
* Arguments:
* 0: Unit to switch state <OBJECT>
* 1: State <ALIVE, DOWNED, REVIVED>
*
* Return Value:
* Nothing
*/
params ["_unit", "_state"];

if (isNull _unit) exitWith {};

_state = toUpper _state;
if !(_state in ["ALIVE", "DOWNED", "REVIVED"]) exitWith {};

switch (_state) do {
    case "DOWNED": {
        // Disable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "Action", "NextAction"]};

        // Disable moving and being shot at
        _unit disableAI "MOVE";
        _unit setCaptive true;

        // Because BI loves race conditions....
        [{
            params ["_unit"];

            _unit setVariable ["derp_revive_downed", true, true];
            _unit setVariable ["derp_revive_loadout", getUnitLoadout _unit];

            [_unit] call derp_revive_fnc_reviveTimer;
            call derp_revive_fnc_hotkeyHandler;
            call derp_revive_fnc_uiElements;

            if (vehicle _unit == _unit) then {
                _unit setUnconscious false;
                [_unit, "acts_injuredlyingrifle02_180"] call derp_fnc_syncAnim;
            } else {
                [_unit, "Die"] remoteExec ["playAction", 0];
            };

            [_unit, true] call derp_revive_fnc_animChanged;
            //fade in
            _unit switchCamera "external";
            cutText ["","BLACK IN",1];


            derp_revive_actionID = (_unit addAction ["", {}, "", 0, false, true, "DefaultAction"]);
            derp_revive_actionID2 = (_unit addAction ["", {}, "", 0, false, true, "Throw"]);

            _unit allowDamage true;

        }, [_unit], 2] call derp_fnc_waitAndExecute;
    };

    case "ALIVE": {
        _unit setVariable ["derp_revive_downed", false, true];

        // Enable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "Action", "NextAction"]};

        _unit setVariable ["derp_revive_downed", false, true];

        // Remove revive EHs and effects
        if !(isNil "derp_reviveKeyDownID") then {(findDisplay 46) displayRemoveEventHandler ["KeyDown", derp_reviveKeyDownID]};
        if !(isNil "derp_reviveKeyUpID") then {(findDisplay 46) displayRemoveEventHandler ["KeyUp", derp_reviveKeyUpID]};
        if !(isNil "derp_revive_animChangedID") then {_unit removeEventHandler ["AnimChanged",derp_revive_animChangedID]};
        if !(isNil "derp_revive_drawIcon3DID") then {removeMissionEventHandler ["Draw3D", derp_revive_drawIcon3DID]};
        if !(isNil "derp_revive_actionID") then {_unit removeAction derp_revive_actionID};
        if !(isNil "derp_revive_actionID2") then {_unit removeAction derp_revive_actionID2};

        if !(isNil "derp_revive_ppColor") then {
            {_x ppEffectEnable false} forEach [derp_revive_ppColor, derp_revive_ppVig, derp_revive_ppBlur];
        };

        showHUD [true, true, true, true, false, true, true, true];

        _unit setCaptive false;
        remoteExec ["", (str _unit + "animChangedJIPID")];
    };

    case "REVIVED": {
        _unit setVariable ["derp_revive_downed", false, true];

        _unit removeAction derp_revive_actionID;
        _unit removeAction derp_revive_actionID2;

        // Enable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "Action", "NextAction"]};

        // Remove revive EHs
        if !(isNil "derp_reviveKeyDownID") then {(findDisplay 46) displayRemoveEventHandler ["KeyDown", derp_reviveKeyDownID]};
        if !(isNil "derp_reviveKeyUpID") then {(findDisplay 46) displayRemoveEventHandler ["KeyUp", derp_reviveKeyUpID]};
        if !(isNil "derp_revive_animChangedID") then {_unit removeEventHandler ["AnimChanged",derp_revive_animChangedID]};
        if !(isNil "derp_revive_drawIcon3DID") then {removeMissionEventHandler ["Draw3D", derp_revive_drawIcon3DID]};
        if !(isNil "derp_revive_actionID") then {_unit removeAction derp_revive_actionID};
        if !(isNil "derp_revive_actionID2") then {_unit removeAction derp_revive_actionID2};

        if !(isNil "derp_revive_ppColor") then {
            {_x ppEffectEnable false} forEach [derp_revive_ppColor, derp_revive_ppVig, derp_revive_ppBlur];
        };

        showHUD [true, true, true, true, false, true, true, true];

        _unit setCaptive false;

        [_unit, "amovppnemstpsnonwnondnon"] call derp_fnc_syncAnim;
    };
};
