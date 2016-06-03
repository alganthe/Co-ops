/*
* Author: alganthe
* Com towers side mission
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: Com towers array <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Destroy all communication antennas.
* Fail: None
*/
params ["_AOPos", "_comTowers", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
private _smID = "antennaTask" + str derp_SMID;

[west, [_smID, _missionID], ["Our enemies have took control of a few antennas, destroy them or they'll call air support. We've marked their locations on your map.", "Destroy enemy com array", ""], objNull, "Created", 5, true, "destroy", true] call BIS_fnc_taskCreate;

//------------------- Markers + mines
private _towerMines = [];
private _markerNumber = 0;
private _markerArray = [];
{
    _markerNumber = _markerNumber + 1;
    private _marker = createMarker ["comTowerMarker" + str _markerNumber, (getPosWorld _x)];
    _marker setMarkerShape "ICON";
    _marker setMarkerType "loc_Transmitter";
    _markerArray pushback _marker;

    for "_x" from 0 to 19 do {
        private _mine = createMine ["APERSBoundingMine", (getMarkerPos _marker), [_marker], 20];
        _towerMines pushback _mine;
    };
} foreach _comTowers;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_comTowers", "_AOPos", "_markerArray", "_towerMines", "_smID"];

    {
        if (!alive _x) then {
            private _arrayPos = (_comTowers find _x);
            _comTowers deleteAt _arrayPos;
            deleteMarker (_markerArray select _arrayPos);
            _markerArray deleteAt _arrayPos;
        };
    } foreach _comTowers;

    if (count _comTowers == 0) then {
        derp_sideMissionInProgress = false;
        {deleteMarker _x} foreach _markerArray;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_towerMines", "_smID"];

            {deleteVehicle _x} foreach _towerMines;

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_towerMines, _smID], 300] call derp_fnc_waitAndExecute;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call derp_fnc_removePerFrameHandler;

    } else {
        [_AOPos] call derp_fnc_airReinforcements;
    };
}, 10, [_comTowers, _AOPos, _markerArray, _towerMines, _smID]] call derp_fnc_addPerFrameHandler;
