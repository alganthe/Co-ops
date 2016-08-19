#include "..\..\defines.hpp"
/*
* Author: alganthe
* Dropped cargo SM
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
private _smID = "droppedCargo" + str derp_SMID;

// Try to get an underwater pos
private _randomPosArray = [_AOPos, derp_PARAM_AOSize, "(1 + sea) * (1 + (waterDepth factor [0.1, 0.5]))"] call derp_fnc_randomPos;
private _randomPos = _randomPosArray select 0;

private _cargoPlane = "";
private _cargoBox = "";
private _spawnedUnits = [];

// no underwater pos available, switch to land pos
if (_randomPosArray select 1 <= 2) then {
    _randomPos = ([_AOPos, derp_PARAM_AOSize, "(1 + meadow) * (1 - sea) * (1 - houses)"] call derp_fnc_randomPos) param [0];
    _cargoPlane = CARGOSMPlane createVehicle _randomPos;
    _cargoBox = CARGOSMBox createVehicle (_randomPos findEmptyPosition [5, 20, CARGOSMBox]);

    for "_derpSMgrpLand" from 0 to 2 step 1 do {
        private _infantryGroup = [([(position _cargoBox), 30, "(1 + meadow) * (1 - sea) * (1 - houses)"] call derp_fnc_randomPos) param [0], EAST, (configFile InfantryGroupsCFGPATH (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

        [_infantryGroup, _cargoBox, 50] call BIS_fnc_taskPatrol;

        {
            _spawnedUnits pushBack _x;
        } foreach (units _infantryGroup);
    };
} else {
    _cargoPlane = CARGOSMPlane createVehicle _randomPos;
    _cargoBox = createVehicle [CARGOSMBox, _randomPos, [], 20, "NONE"];

    for "_derpSMgrp" from 0 to 3 step 1 do {
        private _scubaGroup = [([(position _cargoBox), 30, "(1 + sea) * (1 + (waterDepth factor [0.1, 0.5]))"] call derp_fnc_randomPos) param [0], EAST, (configFile CARGOSMScubaGroup)] call BIS_fnc_spawnGroup;

        deleteWaypoint [_scubaGroup, 0];
        for "_derpWp" from 1 to 3 step 1 do {
            private _waypoint = _scubaGroup addWaypoint [([_cargoBox, 150, "(1 + sea)"] call derp_fnc_randomPos) param [0], 10];
            _waypoint setWaypointType "MOVE";
            _waypoint setWaypointCompletionRadius 20;
        };

        private _waypoint = _scubaGroup addWaypoint [_cargoBox, 0];
        _waypoint setWaypointType "CYCLE";

        {
            _spawnedUnits pushBack _x;
        } foreach (units _scubaGroup);
    };
};

{
    _x addCuratorEditableObjects [([_cargoPlane, _cargoBox] + _spawnedUnits), false];
} forEach allCurators;

[true, _cargoBox] remoteExecCall ["derp_fnc_droppedCargoSM_action", 0, "droppedCargoSM_action"];

// Create the task after because we're placing it on an object this time
[west, [_smID, _missionID], ["One of our cargo planes got shot down, but unfortunately the box it was carrying survived. Do not let our enemies get their hands on it, destroy it.", "Find and destroy lost cargo"], _cargoBox, "Created", 5, true, "destroy", true] call BIS_fnc_taskCreate;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_smID", "_cargoPlane", "_cargoBox", "_spawnedUnits"];

    if (!alive _cargoBox) then {

        if !(isNull _box) then {
            [false] remoteExecCall ["derp_fnc_droppedCargoSM_action", -2, "droppedCargoSM_action"];
            // Remove remoteExec'd action from the JIP queue
            remoteExecCall ["", "droppedCargoSM_action"];
        };

        derp_sideMissionInProgress = false;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_cargoBox", "_cargoPlane", "_spawnedUnits", "_smID"];

            {
                if !(isNull _x) then {
                    deleteVehicle _x;
                };
            } foreach ([_cargoBox, _cargoPlane] + _spawnedUnits);

            [_smID, true] call BIS_fnc_deleteTask;
        }, [_cargoBox, _cargoPlane, _spawnedUnits, _smID], 300] call derp_fnc_waitAndExec;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;

    } else {
        [_AOPos] call derp_fnc_airReinforcements;
    };
}, 10, [_AOPos, _smID, _cargoPlane, _cargoBox, _spawnedUnits]] call derp_fnc_addPerFrameHandler;
