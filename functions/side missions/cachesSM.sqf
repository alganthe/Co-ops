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
#include "cachesSM_defines.hpp"

params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
_smID = "caches" + str derp_SMID;

[west, [_smID, _missionID], ["The CSAT has found three ammo caches around the town, find and destroy them in order to stop the CSAT from retrieving their content.", "Find and destroy ammo caches", ""], objNull, "Created", 5, true, "Destroy", true] call BIS_fnc_taskCreate;

private _buildingArray = nearestObjects [_AOpos, ["Land_i_House_Small_01_V1_F", "Land_i_House_Small_01_V2_F", "Land_i_House_Small_01_V3_F","Land_i_House_Small_02_V1_F", "Land_i_House_Small_02_V2_F","Land_i_House_Small_02_V3_F", "Land_i_Stone_HouseSmall_V1_F", "Land_i_Stone_HouseSmall_V2_F", "Land_i_Stone_HouseSmall_V3_F", "Land_i_Stone_HouseBig_V1_F", "Land_i_Stone_HouseBig_V2_F", "Land_i_Stone_HouseBig_V3_F", "Land_i_House_Big_01_V1_F", "Land_i_House_Big_01_V2_F", "Land_i_House_Big_01_V3_F", "Land_i_House_Big_02_V1_F", "Land_i_House_Big_02_V2_F", "Land_i_House_Big_02_V3_F"], 200];

private _ammoCaches = [];

for "_i" from 1 to 3 do {
    _building = selectRandom _buildingArray;
    _buildingArray deleteAt (_buildingArray find _building);

    switch (typeOf _building) do {
        case "Land_i_House_Small_01_V1_F": {
            Land_i_House_Small_01_variant
        };

        case "Land_i_House_Small_01_V2_F": {
            Land_i_House_Small_01_variant
        };

        case "Land_i_House_Small_01_V3_F": {
            Land_i_House_Small_01_variant
        };

        case "Land_i_House_Small_02_V1_F": {
            Land_i_House_Small_02_variant
        };

        case "Land_i_House_Small_02_V2_F": {
            Land_i_House_Small_02_variant
        };

        case "Land_i_House_Small_02_V3_F": {
            Land_i_House_Small_02_variant
        };

        case "Land_i_Stone_HouseSmall_V1_F": {
            Land_i_Stone_HouseSmall_variant
        };

        case "Land_i_Stone_HouseSmall_V2_F": {
            Land_i_Stone_HouseSmall_variant
        };

        case "Land_i_Stone_HouseSmall_V3_F": {
            Land_i_Stone_HouseSmall_variant
        };

        case "Land_i_Stone_HouseBig_V1_F": {
            Land_i_Stone_HouseBig_variant
        };

        case "Land_i_Stone_HouseBig_V2_F": {
            Land_i_Stone_HouseBig_variant
        };

        case "Land_i_Stone_HouseBig_V3_F": {
            Land_i_Stone_HouseBig_variant
        };

        case "Land_i_House_Big_01_V1_F": {
            Land_i_House_Big_01_variant
        };

        case "Land_i_House_Big_01_V2_F": {
            Land_i_House_Big_01_variant
        };

        case "Land_i_House_Big_01_V3_F": {
            Land_i_House_Big_01_variant
        };

        case "Land_i_House_Big_02_V1_F": {
            Land_i_House_Big_02_variant
        };

        case "Land_i_House_Big_02_V2_F": {
            Land_i_House_Big_02_variant
        };

        case "Land_i_House_Big_02_V3_F": {
            Land_i_House_Big_02_variant
        };
    };
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

        }, [_ammoCaches, _smID], 300] call derp_fnc_waitAndExec;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call CBA_fnc_removePerFrameHandler;

    } else {
        if ((!alive derp_airReinforcement) && {derp_lastAirReinforcementTime <= (time - PARAM_airReinforcementTimer)}) then {
            _AOPos params ["_xPos", "_yPos"];

            derp_airReinforcement = createVehicle ["O_Heli_Light_02_F", getMarkerPos "opforAirSpawn_marker1", ["opforAirSpawn_marker2", "opforAirSpawn_marker3", "opforAirSpawn_marker4"], 50, "FLY"];
            createVehicleCrew derp_airReinforcement;

            {_x addCuratorEditableObjects [[derp_airReinforcement], true]} forEach allCurators;

            _wp = (group derp_airReinforcement) addWaypoint [[_xPos, _yPos, 1000], 0];
            _wp setWaypointType "SAD";

            derp_lastAirReinforcementTime = time;
        };
    };
}, 10, [_AOPos, _ammoCaches, _smID]] call CBA_fnc_addPerFrameHandler;
