// Mission selection
derp_fnc_missionSelection = compile preprocessFileLineNumbers "functions\core\missionSelection.sqf";
derp_fnc_missionTransition = compile preprocessFileLineNumbers "functions\core\missionTransition.sqf";
derp_fnc_sideMissionSelection = compile preprocessFileLineNumbers "functions\core\fn_sideMissionSelection.sqf";

// Vehicle handling
derp_fnc_vehiclePFH = compile preprocessFileLineNumbers "functions\misc\vehicle_handler\fn_vehiclePFH.sqf";
derp_fnc_vehicleInit = compile preprocessFileLineNumbers "functions\misc\vehicle_handler\fn_vehicleInit.sqf";
derp_fnc_vehicleSetup = compile preprocessFileLineNumbers "functions\misc\vehicle_handler\fn_vehicleSetup.sqf";
derp_fnc_quadPFH = compile preprocessFileLineNumbers "functions\misc\vehicle_handler\fn_quadPFH.sqf";
derp_fnc_quadInit = compile preprocessFileLineNumbers "functions\misc\vehicle_handler\fn_quadInit.sqf";

// Missions
derp_fnc_mission_clearTown = compile preprocessFileLineNumbers "functions\missions\mission1\mission1_clearTown.sqf";

// Side missions
derp_fnc_comTowerSM = compile preprocessFileLineNumbers "functions\side missions\comTowerSM.sqf";
derp_fnc_officerMurderSM = compile preprocessFileLineNumbers "functions\side missions\officerMurderSM.sqf";
derp_fnc_truckRetrievalSM = compile preprocessFileLineNumbers "functions\side missions\truckRetrievalSM.sqf";
