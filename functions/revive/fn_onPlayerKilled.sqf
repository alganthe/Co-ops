params ["_unit", "_killer", "_respawn", "_respawnDelay"];

// Exit if player respawned using pause menu or bled out
private _time = missionNamespace getVariable ["RscDisplayMPInterrupt_respawnTime", -1];
if (time - _time < 1 || {_unit getVariable ["derp_revive_downed", false]}) exitWith {

    _unit setVariable ["derp_revive_downed", false, true];
    player call derp_revive_fnc_executeTemplates;
};

// Exit if player is respawned via respanwOnStart or if he was in a vehicle or underwater
if (_unit == objNull || {!isNull objectParent _unit} || {(getPosASL _unit) select 2 < 0}) exitWith {

    _unit setVariable ["derp_revive_downed", false, true];
    player call derp_revive_fnc_executeTemplates;
};

player addPlayerScores [0, 0, 0, 0, -1];

// Save loadout
_unit setVariable ["derp_revive_loadout", (getUnitLoadout _unit)];

// Remove corpse weapons
if (primaryWeapon _unit != "") then {
    _unit removeWeapon (primaryWeapon _unit);
};

if (secondaryWeapon _unit != "") then {
    _unit removeWeapon (secondaryWeapon _unit);
};

//fade out
{inGameUISetEventHandler [_x, "true"]} forEach ["PrevAction", "Action", "NextAction"];
titleCut ["","BLACK OUT",1];

// Set as downed
_unit setVariable ["derp_revive_downed", true, true];

// Force respawn
[{setPlayerRespawnTime 0}, [], 1] call derp_fnc_waitAndExecute;
