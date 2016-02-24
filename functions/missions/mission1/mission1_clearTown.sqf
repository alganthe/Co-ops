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
* Win: No opfor left inside the marker
* Fail: None
 */
missionInProgress = true;
publicVariable "missionInProgress";

private _mainAOUnits = [];
private _selectedLocation = [];

//------------------- Get random mission loc based on existing markers
_missionLocations = ["missionMarker_Athira","missionMarker_Frini","missionMarker_Abdera","missionMarker_Galati","missionMarker_Syrta","missionMarker_Oreokastro","missionMarker_Kore","missionMarker_Negades","missionMarker_Aggelochori","missionMarker_Neri","missionMarker_Panochori","missionMarker_Agios_Dionysios","missionMarker_Zaros","missionMarker_Therisa","missionMarker_Poliakko","missionMarker_Alikampos","missionMarker_Neochori","missionMarker_Rodopoli","missionMarker_Paros","missionMarker_Kalochori","missionMarker_Charkia","missionMarker_Sofia","missionMarker_Molos","missionMarker_Pyrgos","missionMarker_Dorida","missionMarker_Chalkeia","missionMarker_Panagia","missionMarker_Feres","missionMarker_Selakano"];

while {true} do {
	_selectedLocation = selectRandom _missionLocations;

	_isAOempty = count ((getMarkerPos _selectedLocation) nearEntities ["Man",PARAM_AOSize]);
	if (_isAOempty == 0) exitWith {
		false
	};
};

_markerPos = getMarkerPos _selectedLocation;

if (PARAM_HALOEnabled) then {
    _markerPos params ["_xPos","_yPos"];
    derp_haloPos = [_xPos,_yPos] apply {_x + PARAM_AOSize + random 300};
    publicVariable "derp_haloPos";
};


//------------------- Spawn In enemies

if (derp_HCAOsConnected) then {
[_markerPos,true,true,true,true,true,true] remoteExecCall ["derp_fnc_mainAOSpawnHandler", derp_HCAOs];
    _mainAOUnits = spawnedUnits;
spawnedUnits = nil;

} else {
    _mainAOUnits = [_markerPos,true,true,true,true,true,true] call derp_fnc_mainAOSpawnHandler;
};

//------------------- AO boundaries + task
_marker = createMarker ["mission1_mrk", _markerPos];
"mission1_mrk" setMarkerShape "ICON";
"mission1_mrk" setMarkerType "selector_selectable";
"mission1_mrk" setMarkerColor "ColorBLUFOR";

_marker2 = createMarker ["mission1_1_mrk", _markerPos];
"mission1_1_mrk" setMarkerShape "ELLIPSE";
"mission1_1_mrk" setMarkerSize [PARAM_AOSize,PARAM_AOSize];
"mission1_1_mrk" setMarkerBrush "Border";
"mission1_1_mrk" setMarkerColor "ColorOPFOR";

(nearestLocations [_markerPos,["NameCityCapital","NameCity","NameVillage"],200]) params ["_taskTitle"];

[west,["mission1"],["A town has been occupied, you need to clear it out! Good Luck",["Clear ",(text _taskTitle)] joinString "",_selectedLocation],_selectedLocation,true,5,true,"Attack",true] call BIS_fnc_taskCreate;

//------------------- Trigger for mission end
[{
	params ["_markerPos"];

	_winTrigger = createTrigger ["EmptyDetector",_markerPos,false];
	_winTrigger setTriggerArea [PARAM_AOSize,PARAM_AOSize,0,false];
	_winTrigger setTriggerActivation ["EAST", "PRESENT", false];
	_winTrigger setTriggerStatements ["(({alive _x && {side _x == east}} count thisList) < 10)", "missionWin = true;['mission1','Succeeded',true] call BIS_fnc_taskSetState", ""];

},[_markerPos],30] call derp_fnc_waitAndExec;

//------------------- PFH checking every 10s if the mission has been completed
[{
	if ((!isNil "missionWin") && {missionWin}) then {
		(_this select 0) params ["_markerPos","_mainAOUnits"];

		deleteMarker "mission1_mrk";
		deleteMarker "mission1_1_mrk";
		missionWin = nil;

        if (PARAM_HALOEnabled) then {
            derp_haloPos = nil;
            publicVariable "derp_haloPos";
        };

        missionInProgress = false;
        publicVariable "missionInProgress";

		[{
			params ["_mainAOUnits"];

            {
                if (!(isNull _x) && {alive _x}) then {
                    deleteVehicle _x;
                };
            } foreach _mainAOUnits;

			["mission1",true] call BIS_fnc_deleteTask;
		},[_mainAOUnits],10] call derp_fnc_waitAndExec;

		[_markerPos,"ELLIPSE"] call derp_fnc_missionTransition;
		derp_missionCounter = derp_missionCounter + 1;

		[_this select 1] call CBA_fnc_removePerFrameHandler;
	};
},10,[_markerPos,_mainAOUnits]] call CBA_fnc_addPerFrameHandler;
