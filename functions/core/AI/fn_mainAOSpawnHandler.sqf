/*
* Author: alganthe
* Handles creating the AI
*
* Arguments:
* 0: Position of the mission <POSITION>
* 1: <ARRAY>
*    1: Use default radius (mission param) <BOOL>
*    2: Custom radius <NUMBER> default: mission param
* 2: <ARRAY>
*    1: Create AA vehicles <BOOL>
*    2: Amount of vehicles <NUMBER> default: mission param
* 3: <ARRAY>
*    1: Create MRAPs <BOOL>
*    2: Amount of vehicles <NUMBER> default: mission param
* 4: <ARRAY>
*    1: Create random vehicles <BOOL>
*    2: Amount of vehicles <NUMBER> default: 3
* 5: <ARRAY>
*    1: Create infantry <BOOL>
*    2: Amount of groups <NUMBER> default: mission param
* 6: <ARRAY>
*    1: Create infantry in houses <BOOL>
*    2: Amount of groups <NUMBER> default: 2
* 7: Populate military buildings <BOOL> (OPTIONNAL)
*
* Return Value:
* Array of units created
*/
#define MRAPList ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F"]
#define VehicleList ["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F"]
#define UrbanUnits ["O_soldierU_A_F", "O_soldierU_AAR_F", "O_soldierU_AAA_F", "O_soldierU_AAT_F", "O_soldierU_AR_F", "O_soldierU_medic_F", "O_engineer_U_F", "O_soldierU_exp_F", "O_soldierU_GL_F", "O_Urban_HeavyGunner_F", "O_soldierU_M_F", "O_soldierU_AA_F", "O_soldierU_AT_F", "O_soldierU_repair_F", "O_soldierU_F", "O_soldierU_LAT_F", "O_Urban_Sharpshooter_F", "O_soldierU_SL_F", "O_soldierU_TL_F"]
#define InfantryGroupList ["OIA_InfSquad", "OIA_InfSquad_Weapons", "OIA_InfTeam_AA", "OIA_InfTeam_AT", "OIA_InfAssault", "OIA_ReconSquad"]
#define MilitaryBuildings ["Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Medevac_house_V1_F", "Land_Research_house_V1_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Research_HQ_F", "Land_Medevac_HQ_V1_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"]

params ["_AOpos", "_radiusArray", "_AAArray", "_MRAPArray", "_randomVehcsArray", "_infantryArray", "_urbanIfantryArray", "_milbuildingInfantry"];
_radiusArray params ["_radiusSetting", ["_radiusSize", PARAM_AOSize]];
_AAArray params ["_AASetting", ["_AAAmount", PARAM_AntiAirAmount]];
_MRAPArray params ["_MRAPSetting", ["_MRAPAmount", PARAM_MRAPAmount]];
_randomVehcsArray params ["_randomVehcsSetting", ["_randomVehcsAmount", PARAM_RandomVehcsAmount]];
_infantryArray params ["_infantrySetting", ["_infantryAmount", PARAM_InfantryGroupsAmount]];
_urbanIfantryArray params ["_urbanInfantrySetting", ["_urbanInfantryAmount", 2]];

private _spawnedUnits = [];
private _AISkillUnitsArray = [];

//-------------------------------------------------- AA vehicles
if (_AASetting) then {
    for "_x" from 1 to _AAAmount do {
        _randomPos = [[[_AOpos, (_radiusSize / 1.5)], []], ["water", "out"]] call BIS_fnc_randomPos;
        _AAVehicle = "O_APC_Tracked_02_AA_F" createVehicle _randomPos;

        _AAVehicle allowCrewInImmobile true;

        _AAVehicle lock 2;
        createVehicleCrew _AAVehicle;

        _spawnedUnits pushBack _AAVehicle;

        {
            _spawnedUnits pushBack _x;
        } foreach (crew _AAVehicle);

        _group = group _AAVehicle;

        [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- MRAP
if (_MRAPSetting) then {
    for "_x" from 1 to _MRAPAmount do {
        _randomPos = [[[_AOpos, _radiusSize], []], ["water", "out"]] call BIS_fnc_randomPos;
        _MRAP = (selectRandom MRAPList) createVehicle _randompos;

        _MRAP allowCrewInImmobile true;
        _MRAP lock 2;

        createVehicleCrew _MRAP;
        _spawnedUnits pushBack _MRAP;

        {
            _spawnedUnits pushBack _x;
        } foreach (crew _MRAP);

        _group = group _MRAP;

        [_group, _AOpos, 500] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- random vehcs
if (_randomVehcsSetting) then {
    for "_x" from 1 to _randomVehcsAmount do {
        _randomPos = [[[_AOpos, _radiusSize], []], ["water", "out"]] call BIS_fnc_randomPos;
        _vehc = (selectRandom VehicleList) createVehicle _randompos;

        _vehc allowCrewInImmobile true;
        _vehc lock 2;

        createVehicleCrew _vehc;
        _spawnedUnits pushBack _vehc;
        {
            _spawnedUnits pushBack _x;
        } foreach (crew _vehc);
        _group = group _vehc;

        [_group, _AOpos, 700] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- main infantry groups
if (_infantrySetting) then {
    for "_x" from 1 to _infantryAmount do {
        _randomPos = [[[_AOpos, _radiusSize], []], ["water", "out"]] call BIS_fnc_randomPos;
        _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

        [_infantryGroup, _AOpos, (_radiusSize / 1.5)] call BIS_fnc_taskPatrol;

        {
            _spawnedUnits pushBack _x;
            _AISkillUnitsArray pushBack _x;
        } foreach (units _infantryGroup);
    };
};

//-------------------------------------------------- Indoors infantry
if (_urbanInfantrySetting) then {
    for "_x" from 1 to _urbanInfantryAmount do {

        _group = [_AOpos, east, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "UInfantry" >> "OIA_GuardSquad")] call BIS_fnc_spawnGroup;
        [_AOpos, nil, (units _group), 150, false, false] call derp_fnc_AIOccupyBuilding;

        {
            _spawnedUnits pushBack _x;
            _AISkillUnitsArray pushBack _x;
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
                if (count (_buildingPos nearObjects ["CAManBase", 2]) == 0) then {
                    _x params ["_posX", "_posY", "_posZ"];

                    _unit = _urbanGroup createUnit [(selectRandom UrbanUnits), [_posX, _posY, _posZ], [], 0, "NONE"];

                    _unit disableAI "FSM";
                    _unit disableAI "AUTOCOMBAT";
                    _unit setPos [_posX, _posY, _posZ];
                    doStop _unit;
                    commandStop _unit;

                    _spawnedUnits pushBack _unit;
                };
            } foreach (_building buildingPos -1);
        } foreach _milBuildings;
    };
};

//-------------------------------------------------- Add every spawned unit to zeus
{
    _x addCuratorEditableObjects [_spawnedUnits, false];
} forEach allCurators;

[_AISkillUnitsArray] call derp_fnc_AISkill;

if (isServer) then {
    _spawnedUnits
} else {
    spawnedUnits = _spawnedUnits;
    publicVariableServer "spawnedUnits";
    spawnedUnits = nil;
};
