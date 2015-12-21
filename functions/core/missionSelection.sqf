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

diag_log format ["missionSelection called %1",_firstCall];

if (("EnableRespawn" call BIS_fnc_getParamValue) == 0) then {
    [0] remoteExec ["setPlayerRespawnTime",0,true];
    [{[9999] remoteExec ["setPlayerRespawnTime",0,true]},[],300] call derp_fnc_waitAndExec;

};

if ((!isNil "_firstCall") && {_firstCall}) Then {
    funcs =
    [
    derp_fnc_mission_clearTown/*
    derp_fnc_mission_ressuplyTruck,
    derp_fnc_mission_AAVehicleDeal,
    derp_fnc_mission_destroyRadar,
    derp_fnc_mission_KillHVT,
    derp_fnc_mission_deployComs,
    derp_fnc_mission_destroyComs,
    derp_fnc_mission_recoverCrate,
    derp_fnc_mission_destroyUAV,
    derp_fnc_mission_guerMeeting,
    derp_fnc_mission_tankPlatoon,
    derp_fnc_mission_captureNuclearDevice,
    derp_fnc_mission_destroyMortar,
    derp_fnc_mission_captureAndDefendTown,
    derp_fnc_mission_recoverChopperIntel*/
    ];
};
//------------------- Check if the mission amount has been reached.

if ((!isNil "derp_missionCounter") && {("MissionAmount" call BIS_fnc_getParamValue) == derp_missionCounter}) then {
    [] spawn BIS_fnc_EndMission;
} else {
    private _nextMission = funcs select floor random count funcs;
    funcs = funcs - [_nextMission];
    [] call _nextMission;
};

missionInProgress = false;
publicVariable "missionInProgress";
