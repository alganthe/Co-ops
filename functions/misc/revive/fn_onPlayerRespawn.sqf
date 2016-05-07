params ["_newUnit", "_corpse", "_respawn", "_respawnDelay"];

if !(isNil "derp_reviveKeyDownID") then {
    (findDisplay 46) displayRemoveEventHandler ["KeyDown", derp_reviveKeyDownID];
    (findDisplay 46) displayRemoveEventHandler ["KeyUp", derp_reviveKeyUpID];

}; // remove the KeyDown and KeyUp events if they exists
[player] call derp_revive_fnc_reviveActions; // Add back the action, since we can't fucking keep it

if (_newUnit getVariable ["derp_revive_downed", false]) then {

    // Saving corpse pos and dir
    _dir = getDir _corpse;
    _pos = getPosWorld _corpse;
    // Saving the above
    _newUnit setVariable ["derp_revive_corpseDir", _dir];
    _newUnit setVariable ["derp_revive_corpsePos", _pos];

    // Prep the new unit
    [_newUnit, "DOWNED"] call derp_revive_fnc_switchState;

    // Move the corpse, because deleting it fuck over zeus.
    _corpse setPos [0,0,0];
} else {
    [_newUnit, "ALIVE"] call derp_revive_fnc_switchState;
};
