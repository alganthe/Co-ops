/*
* Author: alganthe
* Handle the mission selection, this should only be called on server init, or in a mission PFH.
*
* Arguments:
* 0: First call or not <BOOL>
*
* Return Value:
* Nothing
*/
params ["_firstCall"];

if (derp_PARAM_enableRespawn) then {
    [0] remoteExec ["setPlayerRespawnTime", 0, true];
    [{[9999] remoteExec ["setPlayerRespawnTime", 0, true]}, [], 300] call derp_fnc_waitAndExecute;
};

if ((!isNil "_firstCall") && {_firstCall}) Then {
    derp_missionSelectionArray =
    [
    derp_fnc_mission_clearTown
    ];
};
//------------------- Check if the mission amount has been reached.

if ((derp_PARAM_missionAmount > 0) && {!isNil "derp_missionCounter"} && {derp_PARAM_missionAmount == derp_missionCounter}) then {
    "Won" call BIS_fnc_EndMissionServer;

} else {
    private _nextMission = selectRandom derp_missionSelectionArray;

    [] call _nextMission;
};
