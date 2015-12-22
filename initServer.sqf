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

//-------------- vehicle handling (long list of vehicles)
[hummy1,60] call derp_fnc_vehicleInit; hummy1 call derp_fnc_vehicleSetup;
[ghostHawk1,60] call derp_fnc_vehicleInit; ghostHawk1 call derp_fnc_vehicleSetup;
[ghostHawk2,60] call derp_fnc_vehicleInit; ghostHawk2 call derp_fnc_vehicleSetup;
[mohawk1,60] call derp_fnc_vehicleInit; mohawk1 call derp_fnc_vehicleSetup;
[huron1,60] call derp_fnc_vehicleInit; huron1 call derp_fnc_vehicleSetup;

[] call derp_fnc_vehiclePFH;
