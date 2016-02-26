params ["_AOPos", "_comTowers"];

//------------------- Task
derp_SMID = derp_SMID + 1;
_smID = "antennaTask" + str derp_SMID;

[west, _smID, ["The CSAT have took control of a few antennas, destroy them or they'll call air support.", "Destroy enemy AO com array", ""], objNull, "Created", 5, true, "Destroy", true] call BIS_fnc_taskCreate;

//------------------- Markers + mines
private _towerMines = [];
private _markerNumber = 0;
private _markerArray = [];
{
    _markerNumber = _markerNumber + 1;
    _marker = createMarker ["comTowerMarker" + str _markerNumber, (getPosWorld _x)];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "loc_Transmitter";
    _markerArray pushback _marker;

    for "_x" from 0 to 19 do {
        _mine = createMine ["APERSBoundingMine", (getMarkerPos _marker), [_marker], 20];
        _towerMines pushback _mine;
    };
} foreach _comTowers;

{
    _x addCuratorEditableObjects [_towerMines, true];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_comTowers", "_AOPos", "_markerArray", "_towerMines", "_smID"];

    if ({alive _x} count _comTowers == 0) then {
        derp_sideMissionInProgress = false;
        {deleteMarker _x} foreach _markerArray;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_towerMines", "_smID"];

            {deleteVehicle _x} foreach _towerMines;

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_towerMines, _smID], 300] call derp_fnc_waitAndExec;
        _pfhID call CBA_fnc_removePerFrameHandler;

    } else {
        if ((!alive derp_airReinforcement) && {derp_lastAirReinforcementTime <= (time - PARAM_airReinforcementTimer)}) then {
            _AOPos params ["_xPos", "_yPos"];

            derp_airReinforcement = createVehicle ["O_Plane_CAS_02_F", getMarkerPos "opforAirSpawn_marker1", ["opforAirSpawn_marker2", "opforAirSpawn_marker3", "opforAirSpawn_marker4"], 50, "FLY"];
            createVehicleCrew derp_airReinforcement;

            {_x addCuratorEditableObjects [[derp_airReinforcement], true]} forEach allCurators;

            _wp = (group derp_airReinforcement) addWaypoint [[_xPos, _yPos, 1000], 0];
            _wp setWaypointType "SAD";

            derp_lastAirReinforcementTime = time;
        };
    };
}, 10, [_comTowers, _AOPos, _markerArray, _towerMines, _smID]] call CBA_fnc_addPerFrameHandler;
