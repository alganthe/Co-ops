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

            [_unit, [_unit, "derp_revive_loadout"]] call bis_fnc_loadInventory;
            [_unit, [_unit, "derp_revive_loadout"], nil, true] call bis_fnc_saveInventory;

            [_unit] call derp_revive_fnc_reviveTimer;
            call derp_revive_fnc_hotkeyHandler;
            call derp_revive_fnc_uiElements;

            derp_revive_animChangedID = _unit addEventHandler ["AnimChanged", {
                params ["_unit", "_anim"];

                if (_unit getVariable ["derp_revive_downed", false] && {isNull objectParent _unit} && {!(_unit getVariable ["derp_revive_isDragged",false]) || {!(_unit getVariable ["derp_revive_isCarried", false])}}) then {
                    _unit switchMove "acts_injuredlyingrifle02_180";
                };
            }];

            //fade in
            _unit switchCamera "external";
            titleCut ["","BLACK IN",1];

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
        if !(isNil "derp_revive_drawIcon3DID") then {["derp_revive_drawIcon3DID", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};

    if !(isNil "derp_revive_ppColor") then {{_x ppEffectEnable false} forEach [derp_revive_ppColor, derp_revive_ppVig, derp_revive_ppBlur]};

        _unit setCaptive false;
    };

    case "REVIVED": {
        _unit setVariable ["derp_revive_downed", false, true];

        // Enable player's action menu
        if (isPlayer _unit) then {{inGameUISetEventHandler [_x, ""]} forEach ["PrevAction", "Action", "NextAction"]};

        // Remove revive EHs
       if !(isNil "derp_reviveKeyDownID") then {(findDisplay 46) displayRemoveEventHandler ["KeyDown", derp_reviveKeyDownID]};
       if !(isNil "derp_reviveKeyUpID") then {(findDisplay 46) displayRemoveEventHandler ["KeyUp", derp_reviveKeyUpID]};
       if !(isNil "derp_revive_animChangedID") then {_unit removeEventHandler ["AnimChanged",derp_revive_animChangedID]};
       if !(isNil "derp_revive_drawIcon3DID") then {["derp_revive_drawIcon3DID", "onEachFrame"] call BIS_fnc_removeStackedEventHandler};

       derp_revive_ppColor ppEffectAdjust [1,1,0,[0.3,0.3,0.3,0],[0.2,0.2,0.2,0.2],[1,1,1,1]];
       derp_revive_ppVig ppEffectAdjust [1,1,0,[0.15,0,0,1],[1.0,0.5,0.5,1],[0.587,0.199,0.114,0],[0.6,0.6,0,0,0,0.2,1]];
       derp_revive_ppBlur ppEffectAdjust [0.7];
       {_x ppEffectCommit 1} forEach [derp_revive_ppColor, derp_revive_ppVig, derp_revive_ppBlur];

       _unit setDamage 0.4;
       _unit setCaptive false;
       _unit switchMove "amovppnemstpsnonwnondnon";
    };
};
