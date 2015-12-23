//---------------------------------- Functions compiling
call compile preprocessFileLineNumbers "functions\core\Ported_funcs\portedFuncsInit.sqf";
call compile preprocessFileLineNumbers "functions\core\serverSide_functions_compile.sqf";

//---------------------------------- Mission vars
HCAOsConnected = false;
HCAmbiantConnected = false;
derp_missionCounter = 0;
vehicleHandlingArray = [];
PARAM_AOSize = "AOSize" call BIS_fnc_getParamValue;
PARAM_missionAmount = "MissionAmount" call BIS_fnc_getParamValue;
PARAM_vehicleRespawnDistance = "VehicleRespawnDistance" call BIS_fnc_getParamValue;

//---------------------------------- EHs
["onPlayerDisconnected", {
    if (local HCAOs) then {
        HCAOsConnected = false;
    };

    if (local HCAmbiantAI) then {
        HCAmbiantConnected = false;
    };
}, []] call BIS_fnc_addStackedEventHandler;

//---------------------------------- Scripts and functions calls.
[{[true] call derp_fnc_missionSelection},[],30] call derp_fnc_waitAndExec; // STart mission selection

//-------------- vehicle handling
_respawnVehicles = [
    [hummy1, 60], [ghostHawk1, 60], [ghostHawk2, 60], [mohawk1, 60], [huron1, 60],[greyhawk1, 900], [greyhawk1, 900], [buzzard1, 600], // Air
    [stomper1, 30], [hunter1, 30], [hunter2, 30], [hunter3, 30], [hunter4, 30], [hunter5, 30], [hunter6, 30], [armedTechnical1, 30], [armedTechnical2, 30], // Cars
    [truck1, 30], [truck2, 30], [truck3, 30], [truck4, 30], [truck5, 30], // Trucks
    [armored1, 30], [armored2, 30], [armored3, 30], [armored4, 30], // Armored
    [sdv1, 30], [boat1, 30], [boat2, 30], [boat3, 30] // water stuff
];
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_fnc_vehicleInit;
    _vehicle call derp_fnc_vehicleSetup;

} forEach _respawnVehicles;

[] call derp_fnc_vehiclePFH;
