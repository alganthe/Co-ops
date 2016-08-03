params ["_unit", "_killer", "_respawn", "_respawnDelay"];

// Remove the interactions from the corpse (revive, drag etc) to avoid duplicates
removeAllActions _unit;
// Set it as not downed to avoid the above interactions to be available
_unit setVariable ["derp_revive_downed", false];
