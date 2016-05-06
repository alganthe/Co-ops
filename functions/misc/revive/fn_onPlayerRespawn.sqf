params ["_newUnit", "_corpse", "_respawn", "_respawnDelay"];

[player] call derp_fnc_reviveActions; // Add back the action, since we can't fucking keep it

if (_newUnit getVariable ["derp_revive_downed", false]) then {
    cutText ["", "BLACK"];
    // Saving corpse pos and dir
    _dir = getDir _corpse;
    _pos = getPosWorld _corpse;
    // Saving the above
    _newUnit setVariable ["derp_revive_corpseDir", _dir];
    _newUnit setVariable ["derp_revive_corpsePos", _pos];

    // Prep the new unit
    [_newUnit, "DOWNED"] call derp_fnc_switchState;

    // Move the corpse, because deleting it fuck over zeus.
    _corpse setPos [0,0,0];
} else {
    [_newUnit, "ALIVE"] call derp_fnc_switchState;
};
