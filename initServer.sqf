//---------------------------------- Functions compiling
call compile preprocessFileLineNumbers "functions\core\Ported_funcs\portedFuncsInit.sqf";
call compile preprocessFileLineNumbers "functions\core\serverSide_functions_compile.sqf";

//---------------------------------- Dynamic groups init
["Initialize"] call BIS_fnc_dynamicGroups;

//---------------------------------- Mission vars
derp_HCAOsConnected = false;
derp_HCAmbiantConnected = false;
derp_missionCounter = 0;
derp_sideMissionInProgress = false;
derp_airReinforcement = objNull;
derp_lastAirReinforcementTime = 0;
derp_vehicleHandlingArray = [];
derp_quadHandlingArray = [];
derp_mission1Locations = ["missionMarker_Athira", "missionMarker_Frini", "missionMarker_Abdera", "missionMarker_Galati", "missionMarker_Syrta", "missionMarker_Oreokastro", "missionMarker_Kore", "missionMarker_Negades", "missionMarker_Aggelochori", "missionMarker_Neri", "missionMarker_Panochori", "missionMarker_Agios_Dionysios", "missionMarker_Zaros", "missionMarker_Therisa", "missionMarker_Poliakko", "missionMarker_Alikampos", "missionMarker_Neochori", "missionMarker_Rodopoli", "missionMarker_Paros", "missionMarker_Kalochori", "missionMarker_Charkia", "missionMarker_Sofia", "missionMarker_Molos", "missionMarker_Pyrgos", "missionMarker_Dorida", "missionMarker_Chalkeia", "missionMarker_Panagia", "missionMarker_Feres", "missionMarker_Selakano"];
derp_SMID = 0;
derp_mission1ID = 0;

PARAM_missionAmount = "MissionAmount" call BIS_fnc_getParamValue;
PARAM_vehicleRespawnDistance = "VehicleRespawnDistance" call BIS_fnc_getParamValue;
PARAM_airReinforcementTimer = "airReinforcementTimer" call BIS_fnc_getParamValue;

if (("EnableRespawn" call BIS_fnc_getParamValue) == 0) then {
    PARAM_enableRespawn = true;
} else {
    PARAM_enableRespawn = false;
};

if (("MissionRepetition" call BIS_fnc_getParamValue) == 1 ) then {
    PARAM_missionRepetition = true;
} else {
    PARAM_missionRepetition = false;
};

if (("paraJumpEnabled" call BIS_fnc_getParamValue) == 1) then {
    PARAM_paraJumpEnabled = true;
} else {
    PARAM_paraJumpEnabled = false;
};
//---------------------------------- EHs
["HCdisconnectedStackedEH", "HandleDisconnect", {
    params ["_unit", "_ID", "_UID", "_name"];
    if (_name == "HCAOs") then {
        derp_HCAOsConnected = false;
    };
}, []] call BIS_fnc_addStackedEventHandler;

//---------------------------------- Scripts and functions calls.
[{[true] call derp_fnc_missionSelection}, [], 30] call derp_fnc_waitAndExec; // STart mission selection

//-------------- vehicle handling
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_fnc_vehicleInit;
    _vehicle call derp_fnc_vehicleSetup;

} forEach [
    [hummy1, 60], [ghostHawk1, 60], [ghostHawk2, 60], [mohawk1, 60], [huron1, 60],[greyhawk1, 900], [buzzard1, 600], // Air
    [stomper1, 30], [stomper2, 30], [hunter1, 30], [hunter2, 30], [hunter3, 30], [hunter4, 30], [hunter5, 30], [hunter6, 30], [armedTechnical1, 30], [armedTechnical2, 30], // Cars
    [truck1, 30], [truck2, 30], [truck3, 30], [truck4, 30], [truck5, 30], // Trucks
    [armored1, 30], [armored2, 30], [armored3, 30], [armored4, 30], // Armored
    [sdv1, 30], [boat1, 30], [boat2, 30], [boat3, 30] // water stuff
];
[] call derp_fnc_vehiclePFH;

//-------------- quads handling
{
    _x params ["_vehicle", "_timer"];
    [_vehicle, _timer] call derp_fnc_quadInit;
    _vehicle call derp_fnc_vehicleSetup;

} forEach [
    [quad1, 5], [quad2, 5], [quad3, 5], [quad4, 5], [quad5, 5], [quad6, 5], [quad7, 5]
];
[] call derp_fnc_quadPFH;
