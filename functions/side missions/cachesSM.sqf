#include "..\..\defines.hpp"
/*
* Author: alganthe
* Caches side mission
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Destroy all the caches.
* Fail: None
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
private _smID = "caches" + str derp_SMID;

[west, [_smID, _missionID], ["Our enemies have found three ammo caches around the town, find and destroy them.", "Find and destroy ammo caches", ""], objNull, "Created", 5, true, "destroy", true] call BIS_fnc_taskCreate;

private _ammoCaches = [];

for "_i" from 1 to 3 do {
    private _box = (selectRandom CACHESMCacheArray) createVehicle ([[[_AOpos, 150], []], ["water", "out"]] call BIS_fnc_randomPos);

    _ammoCaches pushback _box;
};

{
    _x addCuratorEditableObjects [_ammoCaches, false];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_ammoCaches", "_smID"];

    if ({alive _x} count _ammoCaches == 0) then {
        derp_sideMissionInProgress = false;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_ammoCaches", "_smID"];

            {
                if !(isNull _x) then {
                    deleteVehicle _x;
                };
            } foreach _ammoCaches;

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_ammoCaches, _smID], 300] call derp_fnc_waitAndExecute;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;

    } else {
        [_AOPos] call derp_fnc_airReinforcements;
    };
}, 10, [_AOPos, _ammoCaches, _smID]] call derp_fnc_addPerFrameHandler;
