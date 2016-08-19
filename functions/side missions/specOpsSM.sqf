#include "..\..\defines.hpp"
/*
* Author: alganthe
* Kill the spec-ops squad
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: All members of the squad are dead
* Fail: none.
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
private _smID = "specOps" + str derp_SMID;

[west, [_smID, _missionID], ["An enemy spec-ops squad has been spotted around the AO, you'll have to deal with them, good luck", "Defeat spec-ops squad"], objNull, "Created", 5, true, "kill", true] call BIS_fnc_taskCreate;

private _randomPos = ([_AOPos, derp_PARAM_AOSize / 2, "(1 - sea)"] call derp_fnc_randomPos) param [0];
private _squad = [_randomPos, EAST, (configfile SPECOPSSMGroup)] call BIS_fnc_spawnGroup;
[_squad, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

{
    _x addCuratorEditableObjects [(units _squad), false];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_squad", "_smID"];

    if ({alive _x} count (units _squad) == 0) then {
        derp_sideMissionInProgress = false;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_smID"];

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_smID], 300] call derp_fnc_waitAndExecute;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;

    } else {
        [_AOPos] call derp_fnc_airReinforcements;
    };
}, 10, [_AOPos, _squad, _smID]] call derp_fnc_addPerFrameHandler;
