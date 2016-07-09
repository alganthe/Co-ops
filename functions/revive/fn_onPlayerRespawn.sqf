params ["_newUnit", "_corpse", "_respawn", "_respawnDelay"];

[player] call derp_revive_fnc_reviveActions; // Add back the action, since we can't fucking keep it

if (_newUnit getVariable ["derp_revive_downed", false]) then {

    // Saving corpse pos and dir
    [{
        (velocity (_this select 1)) distance [0,0,0] < 0.1;
    },
    {
        params ["_unit", "_corpse"];
        _unit setPosWorld (getPosWorld _corpse);
        _unit setDir (getDir _corpse);
        [_unit, "DOWNED"] call derp_revive_fnc_switchState;
        _corpse setPos [0,0,0];
    }, [_newUnit, _corpse]] call derp_fnc_waitUntilAndExecute;

    // Move the corpse, because deleting it fuck over zeus.

} else {
    [_newUnit, "ALIVE"] call derp_revive_fnc_switchState;
};
