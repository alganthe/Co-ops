#include "..\..\defines.hpp"
/*
* Author: alganthe
* Kill an officer.
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Kill the officer.
* Fail: none.
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
private _smID = "officerKill" + str derp_SMID;

[west, [_smID, _missionID], ["We have intel that an enemy officer is in the AO, find him and take him out. We currently have no information on his exact location, good luck.", "Kill the enemy officer", ""], objNull, "Created", 5, true, "kill", true] call BIS_fnc_taskCreate;

private _randomPos = ([_AOPos, derp_PARAM_AOSize / 2, "(1 - sea)"] call derp_fnc_randomPos) param [0];
private _officerGroup = [_randomPos, EAST, (configfile InfantryGroupsCFGPATH (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;
private _officer = _officerGroup createUnit [(selectRandom OFFICERSMTarget), _randomPos, [], 0, "NONE"];
_officerGroup selectLeader _officer;
[_officerGroup, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

{
    _x addCuratorEditableObjects [(units _officerGroup), false];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_officer", "_officerGroup", "_smID"];

    if (!alive _officer) then {
        derp_sideMissionInProgress = false;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_officerGroup", "_smID"];

            {
                if !(isNull _x) then {
                    deleteVehicle _x;
                };
            } foreach (units _officerGroup);

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_officerGroup, _smID], 300] call derp_fnc_waitAndExecute;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;

    } else {
        [_AOPos] call derp_fnc_airReinforcements;
    };
}, 10, [_AOPos, _officer, _officerGroup, _smID]] call derp_fnc_addPerFrameHandler;
