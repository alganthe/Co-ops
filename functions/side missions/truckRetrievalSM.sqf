/*
* Author: alganthe
* Retrieve a truck full of ammo.
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Bring the truck to the recover point.
* Fail: Truck destroyed.
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
_smID = "truckRetrieval" + str derp_SMID;

[west, [_smID, _missionID], ["A truck full GBUs got spotted in the AO, secure it and bring it back to the return point so we can dismantle them. The destruction of the vehicle will result in the failure of the mission.", "Retrieve ammo truck", ""], objNull, "Created", 5, true, "Default", true] call BIS_fnc_taskCreate;

_spawnPos = _AOPos findEmptyPosition [10,200,"O_Truck_03_ammo_F"];
_ammoTruck = "O_Truck_03_ammo_F" createVehicle _spawnPos;
_ammoTruck setAmmoCargo 0;

{
    _x addCuratorEditableObjects [[_ammoTruck], false];
} forEach allCurators;

_ammoTruck addEventHandler ["Killed", {
    params ["_vehicle"];
    "Bo_GBU12_LGB" createVehicle (getPos _vehicle);
}];

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_ammoTruck", "_smID"];

    if (alive _ammoTruck && {_ammoTruck distance2D (getMarkerPos "returnPointMarker") < 4}) then {
        derp_sideMissionInProgress = false;

        [_smID, 'SUCCEEDED', true] call BIS_fnc_taskSetState;

        {moveOut _x} foreach (crew _ammoTruck);
        _ammoTruck lock 2;

        [{
            params ["_ammoTruck", "_smID"];

            if (!isNull _ammoTruck) then {
                deleteVehicle _ammoTruck;
            };

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_ammoTruck, _smID], 300] call derp_fnc_waitAndExec;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call CBA_fnc_removePerFrameHandler;
    };

    if (!alive _ammoTruck) then {
        derp_sideMissionInProgress = false;

        [_smID, 'FAILED', true] call BIS_fnc_taskSetState;

        [{
            params ["_ammoTruck", "_smID"];

            if (!isNull _ammoTruck) then {
                deleteVehicle _ammoTruck;
            };

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_ammoTruck, _smID], 300] call derp_fnc_waitAndExec;
        _pfhID call CBA_fnc_removePerFrameHandler;

    } else {
        if ((!alive derp_airReinforcement) && {derp_lastAirReinforcementTime <= (time - PARAM_airReinforcementTimer)}) then {
            _AOPos params ["_xPos", "_yPos"];

            derp_airReinforcement = createVehicle [["O_Plane_CAS_02_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F"] call BIS_fnc_selectRandom, getMarkerPos "opforAirSpawn_marker1", ["opforAirSpawn_marker2", "opforAirSpawn_marker3", "opforAirSpawn_marker4"], 50, "FLY"];
            createVehicleCrew derp_airReinforcement;

            {_x addCuratorEditableObjects [[derp_airReinforcement], true]} forEach allCurators;

            _wp = (group derp_airReinforcement) addWaypoint [[_xPos, _yPos, 1000], 0];
            _wp setWaypointType "SAD";

            derp_lastAirReinforcementTime = time;
        };
    };
}, 10, [_AOPos, _ammoTruck, _smID]] call CBA_fnc_addPerFrameHandler;
