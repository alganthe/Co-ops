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
while {(count ((_selectedLocation select 1) nearEntities [["CAManBase", "Air", "Car", "Tank"], derp_PARAM_AOSize * 2])) > 0 || {((getMarkerPos "BASE") distance2D (_selectedLocation select 1)) < (derp_PARAM_AOSize * 2)}} do {
    _selectedLocation = selectRandom derp_mission1Locations;

};

//------------------- Sort the AO location
derp_mission1Locations = derp_mission1Locations - [_selectedLocation];
if (count derp_mission1Locations <= 6) then {
    derp_mission1Locations = call derp_fnc_getAllTownsAndVillages;
};
_selectedLocation params ["_townName", "_pos"];

//------------------- Para jump location
if (derp_PARAM_paraJumpEnabled) then {
    derp_paraPos = _pos;
    publicVariable "derp_paraPos";
};

//------------------- Spawn In enemies
if (derp_HCAOsConnected) then {
    [_pos, [true, true, true, true, true, true, true, true]] remoteExecCall ["derp_fnc_mainAOSpawnHandler", derp_HCAOs];
    _mainAOUnits = spawnedUnits;
    spawnedUnits = nil;

} else {
    _mainAOUnits = [_pos, [true, true, true, true, true, true, true, true]] call derp_fnc_mainAOSpawnHandler;
};

private _mainAOUnitCount = count _mainAOUnits;

//------------------- AO boundaries + task
_marker = createMarker ["mission1_mrk", _pos];
"mission1_mrk" setMarkerShape "ICON";
"mission1_mrk" setMarkerType "selector_selectable";
"mission1_mrk" setMarkerColor "ColorBLUFOR";

_marker2 = createMarker ["mission1_1_mrk", _pos];
"mission1_1_mrk" setMarkerShape "ELLIPSE";
"mission1_1_mrk" setMarkerSize [derp_PARAM_AOSize, derp_PARAM_AOSize];
"mission1_1_mrk" setMarkerBrush "Border";
"mission1_1_mrk" setMarkerColor "ColorOPFOR";

derp_mission1ID = derp_mission1ID + 1;
_missionID = "mission1" + str derp_mission1ID;

[west, _missionID, [format ["%1 has been captured, you need to clear it out! Good luck and don't forget to complete the side mission we're assigning you.",_townName ], ["Clear ", _townName] joinString "", ""], _pos, true, 5, true, "Attack", true] call BIS_fnc_taskCreate;


//------------------- PFH checking every 10s if the mission has been completed
[{
    params ["_pos", "_missionID", "_mainAOUnits", "_mainAOUnitCount"];
    [_pos, _missionID] call derp_fnc_sideMissionSelection;

    [{
        params ["_args", "_pfhID"];
        _args params ["_pos", "_missionID", "_mainAOUnits" ,"_mainAOUnitCount"];

        if (floor ((({position _x inArea "mission1_1_mrk" && {side _x == east} && {alive _x}} count allUnits) / _mainAOUnitCount) * 100) <= ceil ((derp_PARAM_AOFinishEnemyPercentage / 100) * _mainAOUnitCount) && {!derp_sideMissionInProgress}) then {

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
            }, [_mainAOUnits, _missionID], 300] call derp_fnc_waitAndExecute;

            derp_missionCounter = derp_missionCounter + 1;
            false call derp_fnc_missionSelection;

            _pfhID call derp_fnc_removePerFrameHandler;
        };
    }, 10, [_pos, _missionID, _mainAOUnits, _mainAOUnitCount]] call derp_fnc_addPerFrameHandler;
}, [_pos, _missionID,  _mainAOUnits, _mainAOUnitCount], 30] call derp_fnc_waitAndExecute;
