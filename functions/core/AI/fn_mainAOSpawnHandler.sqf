#include "..\..\..\defines.hpp"
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
*
* Return Value:
* Array of units created if executed on the server
* Nothing if executed anywhere else (it publicVarServer the array of spawned units instead)
*
* Example:
*
*[_pos, [true, true, false, true, true, true, true, false]] call derp_fnc_mainAOSpawnHandler;
*/
params ["_AOpos", "_settingsArray"];

_settingsArray params [["_AAAVehcSetting", false], ["_MRAPSetting", false], ["_randomVehcsSetting", false], ["_infantryGroupsSetting", false], ["_AAGroupsSetting", false], ["_ATGroupsSetting", false], ["_urbanInfantrySetting", false], ["_milbuildingInfantry", false]];

//-------------------------------------------------- AA, MRAps, and random vehicles
[{
    params ["_AAAVehcSetting", "_MRAPSetting","_randomVehcsSetting", "_AOpos"];

    #include "..\..\..\defines.hpp"

    private _spawnedUnits = [];
    private _AISkillUnitsArray = [];

    if (_AAAVehcSetting) then {
        for "_x" from 1 to derp_PARAM_AntiAirAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 + meadow) * (1 - sea) * (1 - houses)"] call derp_fnc_randomPos) param [0];
            private _AAVehicle = (selectRandom AAVehicleList) createVehicle _randomPos;

            _AAVehicle allowCrewInImmobile true;

            _AAVehicle lock 2;
            createVehicleCrew _AAVehicle;
            _spawnedUnits pushBack _AAVehicle;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (crew _AAVehicle);

            private _group = group _AAVehicle;

            [_group, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;
            _group setSpeedMode "LIMITED";
        };
    };

    if (_MRAPSetting) then {
        for "_x" from 1 to derp_PARAM_MRAPAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 + meadow) * (1 - sea) * (1 - houses)"] call derp_fnc_randomPos) param [0];
            private _MRAP = (selectRandom MRAPList) createVehicle _randompos;

            _MRAP allowCrewInImmobile true;
            _MRAP lock 2;

            createVehicleCrew _MRAP;
            _spawnedUnits pushBack _MRAP;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (crew _MRAP);

            private _group = group _MRAP;

            [_group, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;
            _group setSpeedMode "LIMITED";
        };
    };

    if (_randomVehcsSetting) then {
        for "_x" from 1 to derp_PARAM_RandomVehcsAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 + meadow) * (1 - sea) * (1 - houses)"] call derp_fnc_randomPos) param [0];
            private _vehc = (selectRandom randomVehicleList) createVehicle _randompos;

            _vehc allowCrewInImmobile true;
            _vehc lock 2;

            createVehicleCrew _vehc;
            _spawnedUnits pushBack _vehc;
            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (crew _vehc);
            private _group = group _vehc;

            [_group, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;
        };
    };

    [_AISkillUnitsArray] call derp_fnc_AISkill;
    if (isServer) then {
        {
            _x addCuratorEditableObjects [_spawnedUnits, true];
        } foreach allCurators;
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
    } else {
        [_spawnedUnits, true] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
        publicVariableServer "derp_spawnedUnits";
    };
}, [_AAAVehcSetting, _MRAPSetting, _randomVehcsSetting, _AOpos], 5] call derp_fnc_waitAndExecute;

//-------------------------------------------------- main infantry groups
[{
    params ["_infantryGroupsSetting", "_AOpos"];

    #include "..\..\..\defines.hpp"

    private  _spawnedUnits = [];
    private  _AISkillUnitsArray = [];

    if (_infantryGroupsSetting) then {
        for "_x" from 1 to derp_PARAM_InfantryGroupsAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 - sea)"] call derp_fnc_randomPos) param [0];
            private _infantryGroup = [_randomPos, EAST, (configfile InfantryGroupsCFGPATH (selectRandom InfantryGroupList))] call BIS_fnc_spawnGroup;

            [_infantryGroup, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (units _infantryGroup);
        };
    };

    [_AISkillUnitsArray] call derp_fnc_AISkill;
    if (isServer) then {
        {
            _x addCuratorEditableObjects [_spawnedUnits, true];
        } foreach allCurators;
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
    } else {
        [_spawnedUnits, true] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
        publicVariableServer "derp_spawnedUnits";
    };
}, [_infantryGroupsSetting, _AOpos], 15] call derp_fnc_waitAndExecute;

//-------------------------------------------------- AA and AT groups
[{
    params ["_AAGroupsSetting", "_ATGroupsSetting", "_AOpos"];

    #include "..\..\..\defines.hpp"

    private  _spawnedUnits = [];
    private  _AISkillUnitsArray = [];

    if (_AAGroupsSetting) then {
        for "_x" from 1 to derp_PARAM_AAGroupsAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 - sea)"] call derp_fnc_randomPos) param [0];
            private _infantryGroup = [_randomPos, EAST, (configfile InfantryGroupsCFGPATH (selectRandom AAGroupsList))] call BIS_fnc_spawnGroup;

            [_infantryGroup, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (units _infantryGroup);
        };
    };

    if (_ATGroupsSetting) then {
        for "_x" from 1 to derp_PARAM_ATGroupsAmount do {
            private _randomPos = ([_AOpos, derp_PARAM_AOSize / 1.2, "(1 - sea)"] call derp_fnc_randomPos) param [0];
            private _infantryGroup = [_randomPos, EAST, (configfile InfantryGroupsCFGPATH (selectRandom ATGroupsList))] call BIS_fnc_spawnGroup;

            [_infantryGroup, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (units _infantryGroup);
        };
    };

    [_AISkillUnitsArray] call derp_fnc_AISkill;
    if (isServer) then {
        {
            _x addCuratorEditableObjects [_spawnedUnits, true];
        } foreach allCurators;
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
    } else {
        [_spawnedUnits, true] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
        publicVariableServer "derp_spawnedUnits";
    };
}, [_AAGroupsSetting, _ATGroupsSetting, _AOpos], 25] call derp_fnc_waitAndExecute;

//-------------------------------------------------- Indoors infantry
[{
    params ["_urbanInfantrySetting", "_milbuildingInfantry", "_AOpos"];

    #include "..\..\..\defines.hpp"

    private  _spawnedUnits = [];
    private  _AISkillUnitsArray = [];

    if (_urbanInfantrySetting) then {
        for "_x" from 1 to 3 do {

            private _group = [_AOpos, east, (configfile UrbanGroupsCFGPATH (selectRandom UrbanGroupsList))] call BIS_fnc_spawnGroup;
            private _returnedUnits = [_AOpos, nil, (units _group), (derp_PARAM_AOSize / 3), 2, false] call derp_fnc_AIOccupyBuilding;

            { deleteVehicle _x } foreach _returnedUnits;

            {
                _spawnedUnits pushBack _x;
                _AISkillUnitsArray pushBack _x;
            } foreach (units _group);
        };
    };

    if (_milbuildingInfantry) then {
        private _milBuildings = nearestObjects [_AOpos, MilitaryBuildings, (derp_PARAM_AOSize + 100)];

        _milBuildingCount = count _milBuildings;
        if (_milBuildingCount > 0 ) then {

            for "_x" from 1 to 3 do {

                private _group = [_AOpos, east, (configfile UrbanGroupsCFGPATH (selectRandom UrbanGroupsList))] call BIS_fnc_spawnGroup;
                private _returnedUnits= [_AOpos, MilitaryBuildings, (units _group), (derp_PARAM_AOSize + 100), 2, false] call derp_fnc_AIOccupyBuilding;

                { deleteVehicle _x } foreach _returnedUnits;

                {
                    _spawnedUnits pushBack _x;
                    _AISkillUnitsArray pushBack _x;
                } foreach (units _group);
            };
        };
    };

    [_AISkillUnitsArray] call derp_fnc_AISkill;
    if (isServer) then {
        {
            _x addCuratorEditableObjects [_spawnedUnits, true];
        } foreach allCurators;
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
    } else {
        [_spawnedUnits, true] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
        if (isNil "derp_spawnedUnits") then {
            derp_spawnedUnits = _spawnedUnits;
        } else {
            derp_spawnedUnits = derp_spawnedUnits + _spawnedUnits;
        };
        publicVariableServer "derp_spawnedUnits";
    };
}, [_urbanInfantrySetting, _milbuildingInfantry, _AOpos], 35] call derp_fnc_waitAndExecute;
