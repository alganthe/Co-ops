/*
* Author: commy2
* Disables key input. ESC can still be pressed to open the menu.
*
* Arguments:
* 0: True to disable key inputs, false to re-enable them <BOOL>
*
* Return Value:
* None
*
* Public: No
*/
params ["_state"];

if (_state) then {
    disableSerialization;

    if (!isNull (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull])) exitWith {};
    if (!isNil "derp_disableInputPFH") exitWith {};

    // Close map
    if (visibleMap) then {
        openMap false;
    };

    closeDialog 0;
    createDialog "derp_DisableMouse_Dialog";

    private _dlg = uiNamespace getVariable "derp_dlgDisableMouse";

    _dlg displayAddEventHandler ["KeyDown", {
        params ["", "_key"];

        if (_key == 1 && {alive player}) then {
            createDialog (["RscDisplayInterrupt", "RscDisplayMPInterrupt"] select isMultiplayer);

            disableSerialization;

            private _dlg = findDisplay 49;

            for "_index" from 100 to 2000 do {
                (_dlg displayCtrl _index) ctrlEnable false;
            };

            private _ctrl = _dlg displayctrl 103;
            _ctrl ctrlSetEventHandler ["buttonClick", "while {!isNull (uiNamespace getVariable ['derp_dlgDisableMouse',displayNull])} do {closeDialog 0}; failMission 'LOSER'; [false] call derp_fnc_disableUserInput;"];
            _ctrl ctrlEnable true;
            _ctrl ctrlSetText "ABORT";
            _ctrl ctrlSetTooltip "Abort.";

            _ctrl = _dlg displayctrl ([104, 1010] select isMultiplayer);
            _ctrl ctrlSetEventHandler ["buttonClick", "closeDialog 0; player setDamage 1; [false] call derp_fnc_disableUserInput;"];
            _ctrl ctrlEnable (call {private _config = missionConfigFile >> "respawnButton"; !isNumber _config || {getNumber _config == 1}});
            _ctrl ctrlSetText "RESPAWN";
            _ctrl ctrlSetTooltip "Respawn.";
        };

        if (_key in actionKeys "TeamSwitch" && {teamSwitchEnabled}) then {
            (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull]) closeDisplay 0;

            private _acc = accTime;
            teamSwitch;
            setAccTime _acc;
        };

        if (_key in actionKeys "CuratorInterface" && {getAssignedCuratorLogic player in allCurators}) then {
            (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull]) closeDisplay 0;
            openCuratorInterface;
        };

        if (_key in actionKeys "ShowMap") then {
            (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull]) closeDisplay 0;
            openMap true;
        };

        if (_key == 57 && {player getVariable ["derp_revive_downed", false]}) then {
            _key = 0;
        }; // Revive

        if (isServer || {serverCommandAvailable "#kick"}) then {
            if (!(_key in (actionKeys "DefaultAction" + actionKeys "Throw")) && {_key in (actionKeys "Chat" + actionKeys "PrevChannel" + actionKeys "NextChannel")}) then {
                _key = 0;
            };
        };

        _key > 0
    }];

    _dlg displayAddEventHandler ["KeyUp", {
        if (_key == 57 && {player getVariable ["derp_revive_downed", false]}) then {
        } else {
            true
        };
    }];

    derp_disableInputPFH = [{
        if (isNull (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull]) && {!visibleMap && isNull findDisplay 49 && isNull findDisplay 312 && isNull findDisplay 632}) then {
            [derp_disableInputPFH] call derp_fnc_removePerFrameHandler;
            derp_disableInputPFH = nil;
            [true] call derp_fnc_disableUserInput;
        };
    }, 0, []] call derp_fnc_addPerFrameHandler;
} else {
    if (!isNil "derp_disableInputPFH") then {
        [derp_disableInputPFH] call derp_fnc_removePerFrameHandler;
        derp_disableInputPFH = nil;
    };

    (uiNamespace getVariable ["derp_dlgDisableMouse", displayNull]) closeDisplay 0;
};
