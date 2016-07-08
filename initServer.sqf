#include "defines.hpp"
//---------------------------------- Functions compiling
call compile preprocessFileLineNumbers "functions\core\serverSide_functions_compile.sqf";

//---------------------------------- Dynamic groups init
["Initialize"] call BIS_fnc_dynamicGroups;

//---------------------------------- Mission vars
derp_HCAOsConnected = false;
derp_HCAmbiantConnected = false;
derp_missionCounter = 0;
derp_successfulSMs = 0;
derp_sideMissionInProgress = false;
derp_airReinforcement = objNull;
derp_lastAirReinforcementTime = 0;
derp_vehicleHandler_vehicleHandlingArray = [];
derp_vehicleHandler_quadHandlingArray = [];
derp_mission1Locations = call derp_fnc_getAllTownsAndVillages;
derp_SMID = 0;
derp_mission1ID = 0;
derp_cleaner_bodyArray = [];
derp_cleaner_groupArray = [];

derp_PARAM_missionAmount = "MissionAmount" call BIS_fnc_getParamValue;
derp_PARAM_smRewardAfter = "smRewardAfter" call BIS_fnc_getParamValue;
derp_PARAM_vehicleRespawnDistance = "VehicleRespawnDistance" call BIS_fnc_getParamValue;
derp_PARAM_airReinforcementTimer = "airReinforcementTimer" call BIS_fnc_getParamValue;

if (("EnableRespawn" call BIS_fnc_getParamValue) == 0) then {
    derp_PARAM_enableRespawn = true;
} else {
    derp_PARAM_enableRespawn = false;
};

if (("paraJumpEnabled" call BIS_fnc_getParamValue) == 1) then {
    derp_PARAM_paraJumpEnabled = true;
} else {
    derp_PARAM_paraJumpEnabled = false;
};
//---------------------------------- EHs
addMissionEventHandler ["HandleDisconnect", {
    _this params ["_unit", "", "", "_name"];

    if (_name == "HCAOs") then {
        derp_HCAOsConnected = false;
        diag_log format ["HCAOs connected: %1", derp_HCAOsConnected];
    };

    if ("derp_revive" in (getMissionConfigValue "respawnTemplates")) then {
        _unit setVariable ["derp_revive_downed", false, true];
    };
}];

//---------------------------------- Scripts and functions calls.
[{[true] call derp_fnc_missionSelection}, [], 30] call derp_fnc_waitAndExecute; // STart mission selection

//-------------- vehicle handling
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_vehicleHandler_fnc_vehicleInit;
    _vehicle call derp_vehicleHandler_fnc_vehicleSetup;

} forEach VehicleHandlerArray;
[] call derp_vehicleHandler_fnc_vehiclePFH;

//-------------- quads handling
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_vehicleHandler_fnc_quadInit;
    _vehicle call derp_vehicleHandler_fnc_vehicleSetup;

} forEach VehicleHandlerArrayQuads;
[] call derp_vehicleHandler_fnc_quadPFH;

call derp_fnc_baseCleaning;
call derp_fnc_cleaner;
setTimeMultiplier ("DayDuration" call BIS_fnc_getParamValue);

if ("ShortNights" call BIS_fnc_getParamValue == 1) then {
    call derp_fnc_shortNights;
};

[ArsenalBoxes, ("ArsenalFilter" call BIS_fnc_getParamValue)] call derp_fnc_VA_filter; // Init arsenal boxes.
