/*
* Author: alganthe
* Handles creating the AI
*
* Arguments:
* 0: Position of the mission <POSITION>
* 1: Create AA vehicles <BOOL>
* 2: Create MRAPs <BOOL>
* 3: Create random vehicles <BOOL>
* 4: Create infantry <BOOL>
* 5: Create infantry in houses <BOOL>
* 6: Populate military buildings <BOOL>
*
* Return Value:
* Array of units created
*/
params ["_AOpos","_AA","_MRAP","_randomVehcs","_infantry","_urbanIfantry","_milbuildingInfantry"];

#define MRAPList ["O_MRAP_02_gmg_F","O_MRAP_02_hmg_F"]
#define VehicleList ["O_MBT_02_cannon_F","O_APC_Tracked_02_cannon_F","O_APC_Wheeled_02_rcws_F","O_APC_Tracked_02_cannon_F"]
#define UrbanUnits ["O_soldierU_A_F","O_soldierU_AAR_F","O_soldierU_AAA_F","O_soldierU_AAT_F","O_soldierU_AR_F","O_soldierU_medic_F","O_engineer_U_F","O_soldierU_exp_F","O_soldierU_GL_F","O_Urban_HeavyGunner_F","O_soldierU_M_F","O_soldierU_AA_F","O_soldierU_AT_F","O_soldierU_repair_F","O_soldierU_F","O_soldierU_LAT_F","O_Urban_Sharpshooter_F","O_soldierU_SL_F","O_soldierU_TL_F"]
#define InfantryGroupList ["OIA_InfSquad","OIA_InfSquad_Weapons","OIA_InfTeam_AA","OIA_InfTeam_AT","OIA_InfAssault","OIA_ReconSquad"]
#define MilitaryBuildings ["Land_Cargo_House_V1_F","Land_Cargo_House_V2_F","Land_Cargo_House_V3_F","Land_Medevac_house_V1_F","Land_Research_house_V1_F","Land_Cargo_HQ_V1_F","Land_Cargo_HQ_V2_F","Land_Cargo_HQ_V3_F","Land_Research_HQ_F","Land_Medevac_HQ_V1_F","Land_Cargo_Patrol_V1_F","Land_Cargo_Patrol_V2_F","Land_Cargo_Patrol_V3_F","Land_Cargo_Tower_V1_F","Land_Cargo_Tower_V2_F","Land_Cargo_Tower_V3_F"]

private _spawnedUnits = [];

//-------------------------------------------------- AA vehicles
if !(isNil "_AA") then {
    for "_x" from 1 to PARAM_AntiAirAmount do {
        _randomPos = [[[_AOpos, (PARAM_AOSize / 1.5)],[]],["water","out"]] call BIS_fnc_randomPos;
        _AAVehicle = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;

        _AAVehicle allowCrewInImmobile true;

        _AAVehicle lock 2;
        createVehicleCrew _AAVehicle;

        _spawnedUnits pushBack _AAVehicle;
        {_spawnedUnits pushBack _x} foreach (crew _AAVehicle);
        _group = group _AAVehicle;

        [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- MRAP
if !(isNil "_MRAP") then {
    for "_x" from 1 to PARAM_MRAPAmount do {
        _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
        _MRAP = (selectRandom MRAPList) createVehicle _randompos;

        _MRAP allowCrewInImmobile true;
        _MRAP lock 2;

        createVehicleCrew _MRAP;
        _spawnedUnits pushBack _MRAP;
        {_spawnedUnits pushBack _x} foreach (crew _MRAP);
        _group = group _MRAP;

        [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- random vehcs
if !(isNil "_randomVehcs") then {
    for "_x" from 1 to (2 + random 2) do {
        _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
        _vehc = (selectRandom VehicleList) createVehicle _randompos;

        _vehc allowCrewInImmobile true;
        _vehc lock 2;

        createVehicleCrew _vehc;
        _spawnedUnits pushBack _vehc;
        {_spawnedUnits pushBack _x} foreach (crew _vehc);
        _group = group _vehc;

        [_group, _AOpos, 700] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- main infantry groups
if !(isNil "_infantry") then {
    for "_x" from 1 to PARAM_InfantryGroupsAmount do {
        _randomPos = [[[_AOpos, PARAM_AOSize],[]],["water","out"]] call BIS_fnc_randomPos;
        _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

        [_infantryGroup, _AOpos, (PARAM_AOSize / 1.5)] call BIS_fnc_taskPatrol;

        {_spawnedUnits pushBack _x} foreach (units _infantryGroup);

        {
            _x setSkill ["aimingAccuracy", (PARAM_AIAimingAccuracy / 10)];
            _x setSkill ["aimingShake", (PARAM_AIAimingShake / 10)];
            _x setSkill ["aimingSpeed", (PARAM_AIAimingSpeed / 10)];
            _x setSkill ["endurance", (PARAM_AIEndurance / 10)];
            _x setSkill ["spotDistance", (PARAM_AISpotingDistance / 10)];
            _x setSkill ["spotTime", (PARAM_AISpottingSpeed / 10)];
            _x setSkill ["courage", (PARAM_AICourage / 10)];
            _x setSkill ["reloadSpeed", (PARAM_AIReloadSpeed / 10)];
            _x setSkill ["commanding", (PARAM_AICommandingSkill / 10)];
            _x setSkill ["general", (PARAM_AIGeneralSkill / 10)];
        } foreach (units _infantryGroup);
    };
};

//-------------------------------------------------- Indoors infantry
if !(isNil "_urbanIfantry") then {
    for "_x" from 0 to 2 do {

        _group = [_AOpos, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "UInfantry" >> "OIA_GuardSquad")] call BIS_fnc_spawnGroup;
        {_x disableAI "FSM"} forEach units _group;
        [_AOpos,(units _group),200,false,true,false,false] call Zen_fnc_occupyHouse;

        {_spawnedUnits pushBack _x} foreach (units _group);

        {
            _x setSkill ["aimingAccuracy", (PARAM_AIAimingAccuracy / 10)];
            _x setSkill ["aimingShake", (PARAM_AIAimingShake / 10)];
            _x setSkill ["aimingSpeed", (PARAM_AIAimingSpeed / 10)];
            _x setSkill ["endurance", (PARAM_AIEndurance / 10)];
            _x setSkill ["spotDistance", (PARAM_AISpotingDistance / 10)];
            _x setSkill ["spotTime", (PARAM_AISpottingSpeed / 10)];
            _x setSkill ["courage", (PARAM_AICourage / 10)];
            _x setSkill ["reloadSpeed", (PARAM_AIReloadSpeed / 10)];
            _x setSkill ["commanding", (PARAM_AICommandingSkill / 10)];
            _x setSkill ["general", (PARAM_AIGeneralSkill / 10)];
        } foreach (units _group);
    };
};

//-------------------------------------------------- Military area
if !(isNil "_milbuildingInfantry") then {
    private _milBuildings = nearestObjects [_AOpos, MilitaryBuildings, 1100];

    if (count _milBuildings > 0 ) then {
        private _urbanGroup = createGroup east;

        {
            _x params ["_building"];
            {
                _x params ["_posX","_posY","_posZ"];
                _unit = _urbanGroup createUnit [(selectRandom UrbanUnits), [_posX,_posY,_posZ],[],0,"NONE"];
                doStop _unit;
                commandStop _unit;
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";
                _unit setPos [_posX,_posY,_posZ];

                _spawnedUnits pushBack _unit;
            } foreach (_building buildingPos -1);
        } foreach _milBuildings;
    };
};

//-------------------------------------------------- Add every spawned unit to zeus
{
    _x addCuratorEditableObjects [_spawnedUnits,false];
} forEach allCurators;

if (isServer) then {
    _spawnedUnits
} else {
    spawnedUnits = _spawnedUnits;
    publicVariableServer "spawnedUnits";
};
