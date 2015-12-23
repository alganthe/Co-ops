/*
 * Author: alganthe
 * Handle the mission selection, this should only be called on server init or after missionTransition
 *
 * Arguments:
 * 0: amount of missions played <NUMBER>
 * 1: If this is the first time the function is called <BOOL>
 *
 * Return Value:
 * nothing
 */

params ["_firstCall"];

if (("EnableRespawn" call BIS_fnc_getParamValue) == 0) then {
    [0] remoteExec ["setPlayerRespawnTime",0,true];
    [{[9999] remoteExec ["setPlayerRespawnTime",0,true]},[],300] call derp_fnc_waitAndExec;

};

if ((!isNil "_firstCall") && {_firstCall}) Then {
    funcs =
    [
    derp_fnc_mission_clearTown
    ];
};
//------------------- Check if the mission amount has been reached.

if ((!isNil "derp_missionCounter") && {PARAM_missionAmount == derp_missionCounter}) then {
    [] spawn BIS_fnc_EndMission;
} else {
    private _nextMission = funcs select floor random count funcs;
    funcs = funcs - [_nextMission];
    [] call _nextMission;
};

missionInProgress = false;
publicVariable "missionInProgress";
