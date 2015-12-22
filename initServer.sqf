//---------------------------------- Functions compiling
call compile preprocessFileLineNumbers "functions\core\Ported_funcs\portedFuncsInit.sqf";
call compile preprocessFileLineNumbers "functions\core\serverSide_functions_compile.sqf";

//---------------------------------- Mission vars
HCAOsConnected = false;
HCAmbiantConnected = false;
derp_missionCounter = 0;
vehicleHandlingArray = [];
[] call derp_fnc_VAInitSorting;

//---------------------------------- EHs
["onPlayerDisconnected",
{
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
_respawnVehicles = [[hummy1, 60], [ghostHawk1, 60], [ghostHawk2, 60], [mohawk1, 60], [huron1, 60]];
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_fnc_vehicleInit;
    _vehicle call derp_fnc_vehicleSetup;

} forEach _respawnVehicles;

[] call derp_fnc_vehiclePFH;
