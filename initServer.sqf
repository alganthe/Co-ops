// -------------- Functions compiling
call compile preprocessFileLineNumbers "functions\core\Ported_funcs\portedFuncsInit.sqf";
call compile preprocessFileLineNumbers "functions\core\serverSide_functions_compile.sqf";

// -------------- Mission vars
HCAOsConnected = false;
HCAmbiantConnected = false;
derp_missionCounter = 0;

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
[] call derp_fnc_VAInitSorting;
