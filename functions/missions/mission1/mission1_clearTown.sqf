/*
* Author: alganthe
*
* Arguments:
* Nothing
*
* Return Value:
* Nothing
*
* Mission1: Clear a town out of any enemy presence.
*
* Phases: NONE
*
* Conditions:
* Win: No opfor left inside the marker and side mission completed or failed.
* Fail: None
*/
missionInProgress = true;
publicVariable "missionInProgress";

private _mainAOUnits = [];
private _selectedLocation = selectRandom derp_mission1Locations;

//------------------- Get random mission loc based on existing markers
while {(count ((getMarkerPos _selectedLocation) nearEntities [["CAManBase", "Air", "Car", "Tank"], derp_PARAM_AOSize])) == 0} do {
	_selectedLocation = selectRandom derp_mission1Locations;

};

//------------------- Sort the AO location
derp_mission1Locations = derp_mission1Locations - [_selectedLocation];
if (count derp_mission1Locations <= 6) then {
    derp_mission1Locations = ["missionMarker_Athira", "missionMarker_Frini", "missionMarker_Abdera", "missionMarker_Galati", "missionMarker_Syrta", "missionMarker_Oreokastro", "missionMarker_Kore", "missionMarker_Negades", "missionMarker_Aggelochori", "missionMarker_Neri", "missionMarker_Panochori", "missionMarker_Agios_Dionysios", "missionMarker_Zaros", "missionMarker_Therisa", "missionMarker_Poliakko", "missionMarker_Alikampos", "missionMarker_Neochori", "missionMarker_Rodopoli", "missionMarker_Paros", "missionMarker_Kalochori", "missionMarker_Charkia", "missionMarker_Sofia", "missionMarker_Molos", "missionMarker_Pyrgos", "missionMarker_Dorida", "missionMarker_Chalkeia", "missionMarker_Panagia", "missionMarker_Feres", "missionMarker_Selakano"];
};
_markerPos = getMarkerPos _selectedLocation;

//------------------- Para jump location
if (derp_PARAM_paraJumpEnabled) then {
    derp_paraPos = _markerPos;
    publicVariable "derp_paraPos";
};

//------------------- Spawn In enemies
if (derp_HCAOsConnected) then {
    [_markerPos, [true, true, true, true, true, true, true, true]] remoteExecCall ["derp_fnc_mainAOSpawnHandler", derp_HCAOs];
    _mainAOUnits = spawnedUnits;
    spawnedUnits = nil;

} else {
    _mainAOUnits = [_markerPos, [true, true, true, true, true, true, true, true]] call derp_fnc_mainAOSpawnHandler;
};

//------------------- AO boundaries + task
_marker = createMarker ["mission1_mrk", _markerPos];
"mission1_mrk" setMarkerShape "ICON";
"mission1_mrk" setMarkerType "selector_selectable";
"mission1_mrk" setMarkerColor "ColorBLUFOR";

_marker2 = createMarker ["mission1_1_mrk", _markerPos];
"mission1_1_mrk" setMarkerShape "ELLIPSE";
"mission1_1_mrk" setMarkerSize [derp_PARAM_AOSize, derp_PARAM_AOSize];
"mission1_1_mrk" setMarkerBrush "Border";
"mission1_1_mrk" setMarkerColor "ColorOPFOR";

(nearestLocations [_markerPos, ["NameCityCapital", "NameCity", "NameVillage"], 200]) params ["_townName"];

derp_mission1ID = derp_mission1ID + 1;
_missionID = "mission1" + str derp_mission1ID;

[west, _missionID, [format ["%1 has been captured, you need to clear it out! Good luck and don't forget to complete the side mission we're assigning you.",(text _townName)], ["Clear ", (text _townName)] joinString "", _selectedLocation], _selectedLocation, true, 5, true, "Attack", true] call BIS_fnc_taskCreate;

//------------------- Trigger for mission end
[{
	params ["_markerPos", "_missionID"];

    [_markerPos, _missionID] call derp_fnc_sideMissionSelection;

	_winTrigger = createTrigger ["EmptyDetector", _markerPos, false];
	_winTrigger setTriggerArea [derp_PARAM_AOSize, derp_PARAM_AOSize, 0, false];
	_winTrigger setTriggerActivation ["EAST", "PRESENT", false];
	_winTrigger setTriggerStatements ["(({alive _x && {side _x == east}} count thisList) < 10)", "missionWin = true", ""];
}, [_markerPos, _missionID], 30] call derp_fnc_waitAndExec;

//------------------- PFH checking every 10s if the mission has been completed
[{
	if ((!isNil "missionWin") && {missionWin} && {!derp_sideMissionInProgress}) then {
        params ["_args", "_pfhID"];
        _args params ["_markerPos", "_mainAOUnits", "_missionID"];

		deleteMarker "mission1_mrk";
		deleteMarker "mission1_1_mrk";
        [_missionID, 'Succeeded', true] call BIS_fnc_taskSetState;
		missionWin = nil;
        missionInProgress = false;
        publicVariable "missionInProgress";

        if (derp_PARAM_paraJumpEnabled) then {
            derp_paraPos = nil;
            publicVariable "derp_paraPos";
        };

		[{
			params ["_mainAOUnits", "_missionID"];

            {
                if (!(isNull _x) && {alive _x}) then {
                    deleteVehicle _x;
                };
            } foreach _mainAOUnits;

			[_missionID, true] call BIS_fnc_deleteTask;
		}, [_mainAOUnits, _missionID], 300] call derp_fnc_waitAndExec;

        derp_missionCounter = derp_missionCounter + 1;
		false call derp_fnc_missionSelection;

		_pfhID call CBA_fnc_removePerFrameHandler;
	};
}, 10, [_markerPos, _mainAOUnits, _missionID]] call CBA_fnc_addPerFrameHandler;
