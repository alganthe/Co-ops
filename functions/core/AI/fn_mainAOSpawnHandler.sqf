/*
* Author: alganthe
* Handles creating the AI
*
* Arguments:
* 0: Position of the mission <POSITION>
*
* Return Value:
* Array of units created
*/
params ["_AOpos"];

#define MRAPList ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F"]
#define VehicleList ["O_MBT_02_cannon_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F"]
#define InfantryGroupList ["OIA_InfSquad","OIA_InfSquad_Weapons","OIA_InfTeam","OIA_InfTeam_AA","OIA_InfTeam_AT","OI_reconPatrol"]

private _spawnedUnits = [];

//-------------------------------------------------- AA vehicles
for "_x" from 1 to PARAM_AntiAirAmount do {
    _randomPos = [[[_AOpos, (PARAM_AOSize / 1.5)],[]],["water","out"]] call BIS_fnc_randomPos;
    _AAVehicle = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;

    _AAVehicle allowCrewInImmobile true;
    _spawnedUnits pushBack _AAVehicle;

    _AAVehicle lock 2;
    createVehicleCrew _AAVehicle;

    _group = group _AAVehicle;

    [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
};

//-------------------------------------------------- MRAP
for "_x" from 1 to PARAM_MRAPAmount do {
    _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
    _MRAP = (selectRandom MRAPList) createVehicle _randompos;

    _spawnedUnits pushBack _MRAP;

    _MRAP allowCrewInImmobile true;
    _MRAP lock 2;
    createVehicleCrew _MRAP;

    _group = group _MRAP;

    [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
};

//-------------------------------------------------- random vehcs
for "_x" from 1 to (2 + random 2) do {
    _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
    _vehc = (selectRandom VehicleList) createVehicle _randompos;

    _spawnedUnits pushBack _vehc;

    _vehc allowCrewInImmobile true;
    _vehc lock 2;
    createVehicleCrew _vehc;

    _group = group _vehc;

    [_group, _AOpos, 700] call BIS_fnc_taskPatrol;
};

//-------------------------------------------------- main infantry groups
for "_x" from 1 to PARAM_InfantryGroupsAmount do {
    _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
    _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

    [_infantryGroup, _AOpos, PARAM_AOSize] call BIS_fnc_taskPatrol;

    {_spawnedUnits pushBack _x} foreach (units _infantryGroup);
};

//-------------------------------------------------- Add every spawned unit to zeus
{
    _x addCuratorEditableObjects [_spawnedUnits,true];
} forEach allCurators;

_spawnedUnits
