#include "..\..\defines.hpp"
/*
* Author: alganthe
* Download intel from a downed uav and destroy it
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Uav download finished and uav destroyed
* Fail: Uav destroyed before download finished.
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
private _smID = "uavDownloadAndKill" + str derp_SMID;

[west, [_smID, _missionID], ["We have shot down an enemy UAV above the current AO but we got intel that it is still in one piece. We may be able to recover some intel from it. Download the intel and then destroy the UAV", "Download intel from the UAV"], objNull, "Created", 5, true, "upload", true] call BIS_fnc_taskCreate;

private _spawnPos = _AOPos findEmptyPosition [10, 200, "CraterLong"];
private _dirtHump = "CraterLong" createVehicle _spawnPos;
private _uav = (selectRandom UAVSMUav) createVehicle _spawnPos;
_uav setDamage 0.5;

_uav setPos (_dirtHump modelToWorld [-1, -1]);
{
    _x addCuratorEditableObjects [[_dirtHump, _uav], false];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_uav", "_dirtHump", "_smID"];

    private _isPlayersNear = count ((_uav nearEntities ["CAManBase", 15]) select {isPlayer _x});

    // Download not started, players near start it.
    if (_isPlayersNear > 0 && {isNil "derp_uavSM_downloadProgress"} && {isNil "derp_uavSM_isDownloadDone"}) then {
        derp_uavSM_downloadProgress = 0;
        [[west, "HQ"], "Intel download started"] remoteExec ["sideChat", 0];
    } else {
        // Downlaod started and players still near it.
        if (_isPlayersNear > 0 && {!(isNil "derp_uavSM_downloadProgress")} && {isNil "derp_uavSM_isDownloadDone"}) then {
            derp_uavSM_downloadProgress = derp_uavSM_downloadProgress + 10;


            if (derp_uavSM_downloadProgress == 100) then {
                derp_uavSM_downloadProgress = nil;
                derp_uavSM_isDownloadDone = true;
                [[west, "HQ"],"Intel download completed, destroy the uav"] remoteExec ["sideChat", 0];

            } else {
                [[west, "HQ"],(format ["Intel download at: %1",derp_uavSM_downloadProgress]) + "%"] remoteExec ["sideChat", 0];
            };

        } else { // Players aren't near the objective anymore
            if (_isPlayersNear == 0 && {!(isNil "derp_uavSM_downloadProgress")} && {isNil "derp_uavSM_isDownloadDone"}) then {
                derp_uavSM_downloadProgress = nil;
                [[west, "HQ"], "Intel download failed, start again"] remoteExec ["sideChat", 0];
            };
        };
    };

    if (!alive _uav && {!(isNil "derp_uavSM_isDownloadDone")}) then {
        derp_sideMissionInProgress = false;
        derp_uavSM_isDownloadDone = nil;

        [_smID, 'SUCCEEDED', true] call BIS_fnc_taskSetState;

        [{
            params ["_uav", "_dirtHump", "_smID"];

            detach _uav;
            deleteVehicle _uav;
            deleteVehicle _dirtHump;
            [_smID, true] call BIS_fnc_deleteTask;

        }, [_uav, _dirtHump, _smID], 300] call derp_fnc_waitAndExecute;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;
    } else {
        if (!alive _uav && {isNil "derp_uavSM_isDownloadDone"}) then {
            derp_sideMissionInProgress = false;
            derp_uavSM_isDownloadDone = nil;

            [_smID, 'FAILED', true] call BIS_fnc_taskSetState;

            [{
                params ["_uav", "_dirtHump", "_smID"];

                detach _uav;
                deleteVehicle _uav;
                deleteVehicle _dirtHump;
                [_smID, true] call BIS_fnc_deleteTask;

                }, [_uav, _dirtHump, _smID], 300] call derp_fnc_waitAndExecute;

                _pfhID call derp_fnc_removePerFrameHandler;

        } else {
            [_AOPos] call derp_fnc_airReinforcements;
        };
    };
}, 10, [_AOPos, _uav, _dirtHump, _smID]] call derp_fnc_addPerFrameHandler;
