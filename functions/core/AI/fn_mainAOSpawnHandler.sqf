/*
* Author: alganthe
* Handles creating the AI
*
* Arguments:
* 0: Position of the mission <POSITION>
* 1: <ARRAY>
*    1: Place AA vehicles <BOOL>
*    2: Place  MRAPS <BOOL>
*    3: Place random vehcs <BOOL>
*    4: Place infantry groups <BOOL>
*    5: Place AA groups <BOOL>
*    6: Place AT groups <BOOL>
*    7: Place urban groups <BOOL>
*    8: Place infantry in milbuildings <BOOL>
* 2: AA vehicles amount <SCALAR> (OPTIONNAL)
* 3: MRAPs amount <SCALAR> (OPTIONNAL)
* 4: Random vehcs amount <SCALAR> (OPTIONNAL)
* 5: Infantry groups amount <SCALAR> (OPTIONNAL)
* 6: AA groups amount <SCALAR> (OPTIONNAL)
* 7: AT groups amount <SCALAR> (OPTIONNAL)
* 8: Urban groups amount <SCALAR> (OPTIONNAL)
*
* Return Value:
* Array of units created if executed on the server
* Nothing if executed anywhere else (it publicVarServer the array of spawned units instead)
*
* Example:
*
*[_pos, [true, true, false, true, true, true, true, false], 2, 1, 3, 5, 1, 1, 3] call derp_fnc_mainAOSpawnHandler;
*/
#define MRAPList ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F"]
#define VehicleList ["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F"]
#define UrbanUnits ["O_soldierU_A_F", "O_soldierU_AAR_F", "O_soldierU_AAA_F", "O_soldierU_AAT_F", "O_soldierU_AR_F", "O_soldierU_medic_F", "O_engineer_U_F", "O_soldierU_exp_F", "O_soldierU_GL_F", "O_Urban_HeavyGunner_F", "O_soldierU_M_F", "O_soldierU_AA_F", "O_soldierU_AT_F", "O_soldierU_repair_F", "O_soldierU_F", "O_soldierU_LAT_F", "O_Urban_Sharpshooter_F", "O_soldierU_SL_F", "O_soldierU_TL_F"]
#define InfantryGroupList ["OIA_InfSquad", "OIA_InfSquad_Weapons", "OIA_InfAssault", "OIA_ReconSquad"]
#define MilitaryBuildings ["Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Medevac_house_V1_F", "Land_Research_house_V1_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Research_HQ_F", "Land_Medevac_HQ_V1_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"]

params ["_AOpos", "_settingsArray", ["_radiusSize", derp_PARAM_AOSize], ["_AAAVehcAmount", derp_PARAM_AntiAirAmount], ["_MRAPAmount", derp_PARAM_MRAPAmount], ["_randomVehcsAmount", derp_PARAM_RandomVehcsAmount], ["_infantryGroupsAmount", derp_PARAM_InfantryGroupsAmount], ["_AAGroupsAmount", derp_PARAM_AAGroupsAmount], ["_ATGroupsAmount", derp_PARAM_ATGroupsAmount], ["_urbanInfantryAmount", 2]];
_settingsArray params [["_AAAVehcSetting", false], ["_MRAPSetting", false], ["_randomVehcsSetting", false], ["_infantryGroupsSetting", false], ["_AAGroupsSetting", false], ["_ATGroupsSetting", false], ["_urbanInfantrySetting", false], ["_milbuildingInfantry", false]];

private _spawnedUnits = [];
private _AISkillUnitsArray = [];

//-------------------------------------------------- AA vehicles
if (_AAAVehcSetting) then {
    for "_x" from 1 to _AAAVehcAmount do {
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

        [_group, _AOpos, _radiusSize / 2] call BIS_fnc_taskPatrol;
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

        [_group, _AOpos, _radiusSize / 3] call BIS_fnc_taskPatrol;
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

        [_group, _AOpos, _radiusSize / 2] call BIS_fnc_taskPatrol;
        _group setSpeedMode "LIMITED";
    };
};

//-------------------------------------------------- main infantry groups
if (_infantryGroupsSetting) then {
    for "_x" from 1 to _infantryGroupsAmount do {
        _randomPos = [[[_AOpos, _radiusSize * 1.2], []], ["water", "out"]] call BIS_fnc_randomPos;
        _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

        [_infantryGroup, _AOpos, _radiusSize / 1.6] call BIS_fnc_taskPatrol;

        {
            _spawnedUnits pushBack _x;
            _AISkillUnitsArray pushBack _x;
        } foreach (units _infantryGroup);
    };
};

//-------------------------------------------------- AA groups
if (_AAGroupsSetting) then {
    for "_x" from 1 to _AAGroupsAmount do {
        _randomPos = [[[_AOpos, _radiusSize], []], ["water", "out"]] call BIS_fnc_randomPos;
        _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AA")] call BIS_fnc_spawnGroup;

        [_infantryGroup, _AOpos, _radiusSize / 1.6] call BIS_fnc_taskPatrol;

        {
            _spawnedUnits pushBack _x;
            _AISkillUnitsArray pushBack _x;
        } foreach (units _infantryGroup);
    };
};

//-------------------------------------------------- AT groups
if (_ATGroupsSetting) then {
    for "_x" from 1 to _ATGroupsAmount do {
        _randomPos = [[[_AOpos, _radiusSize], []], ["water", "out"]] call BIS_fnc_randomPos;
        _infantryGroup = [_randomPos, EAST, (configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfTeam_AT")] call BIS_fnc_spawnGroup;

        [_infantryGroup, _AOpos, _radiusSize / 1.6] call BIS_fnc_taskPatrol;

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
        [_AOpos, nil, (units _group), 150, 2, false] call derp_fnc_AIOccupyBuilding;

        {
            _spawnedUnits pushBack _x;
            _AISkillUnitsArray pushBack _x;
        } foreach (units _group);
    };
};

//-------------------------------------------------- Military area
if (_milbuildingInfantry) then {
    private _milBuildings = nearestObjects [_AOpos, MilitaryBuildings, (_radiusSize + 100)];

    if (count _milBuildings > 0 ) then {
        private _urbanGroup = createGroup east;

        {
            _x params ["_building"];
            {
                if (count (_x nearObjects ["CAManBase", 1]) == 0) then {
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

//-------------------------------------------------- SetSkill + network operations
[_AISkillUnitsArray] call derp_fnc_AISkill;

if (isServer) then {
    {
        _x addCuratorEditableObjects [_spawnedUnits, true];
    } foreach allCurators;
    _spawnedUnits
} else {
    [_spawnedUnits, true] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
    spawnedUnits = _spawnedUnits;
    publicVariableServer "spawnedUnits";
    spawnedUnits = nil;
};
