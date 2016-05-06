params ["_unit", "_killer", "_respawn", "_respawnDelay"];

// Exit if player respawned using pause menu or bled out
private _time = missionNamespace getVariable ["RscDisplayMPInterrupt_respawnTime", -1];
if (time - _time < 1 || {_unit getVariable ["derp_revive_downed", false]}) exitWith {

    _unit setVariable ["derp_revive_downed", false, true];
    player call derp_fnc_executeTemplates;
};

// Exit if player is respawned via respanwOnStart or if he was in a vehicle or underwater
if (_unit == objNull || {!isNull objectParent _unit} || {(getPosASL _unit) select 2 < 0}) exitWith {

    _unit setVariable ["derp_revive_downed", false, true];
    player call derp_fnc_executeTemplates;
};

_unit setVariable ["derp_revive_downed", true, true];

// Save loadout
[_unit, [_unit, "derp_revive_loadout"]] call bis_fnc_saveInventory;

[{setPlayerRespawnTime 0}, [], 2] call derp_fnc_waitAndExecute;
