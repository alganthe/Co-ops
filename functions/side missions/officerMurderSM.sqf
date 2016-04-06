/*
* Author: alganthe
* Kill an officer.
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*
* Conditions:
* Win: Kill the officer.
* Fail: none.
*/
params ["_AOPos", "_missionID"];

//------------------- Task
derp_SMID = derp_SMID + 1;
_smID = "officerKill" + str derp_SMID;

[west, [_smID, _missionID], ["We have intel that a CSAT officer is in the AO, find him and take him out. We currently have no information on his exact location, good luck.", "Kill the CSAT officer", ""], objNull, "Created", 5, true, "Attack", true] call BIS_fnc_taskCreate;

_buildingArray = _AOPos nearObjects ["House", 200];

private "_officerBuilding";
{
    _buildingPositions = _x buildingPos -1;
    if ({count (_x nearObjects ["CAManBase", 1]) == 0} count _buildingPositions > 5) exitWith {_officerBuilding = _x};
} foreach _buildingArray;

_officerGroup = createGroup east;
_officerPos = selectRandom (_officerBuilding buildingPos -1);
_officer = _officerGroup createUnit ["O_officer_F", _officerPos, [], 0, "NONE"];
_officer disableAI "FSM";
_officer disableAI "AUTOCOMBAT";
_officer setPos _officerPos;
doStop _officer;
commandStop _officer;

{
    if (count (_x nearObjects ["CAManBase", 1]) == 0) then {

        _unit = _officerGroup createUnit ["O_soldier_F", _x, [], 0, "NONE"];
        _unit disableAI "FSM";
        _unit disableAI "AUTOCOMBAT";

        _unit setPos _x;

        doStop _unit;
        commandStop _unit;
    };
} foreach (_officerBuilding buildingPos -1);

{
    _x addCuratorEditableObjects [(units _officerGroup), false];
} forEach allCurators;

//------------------- PFH
[{
    params ["_args", "_pfhID"];
    _args params ["_AOPos", "_officer", "_officerGroup", "_smID"];

    if (!alive _officer) then {
        derp_sideMissionInProgress = false;

        [_smID, 'Succeeded', true] call BIS_fnc_taskSetState;

        [{
            params ["_officerGroup", "_smID"];

            {
                if !(isNull _x) then {
                    deleteVehicle _x;
                };
            } foreach (units _officerGroup);

            [_smID, true] call BIS_fnc_deleteTask;

        }, [_officerGroup, _smID], 300] call derp_fnc_waitAndExec;

        derp_successfulSMs = derp_successfulSMs + 1;
        call derp_fnc_smRewards;
        _pfhID call CBA_fnc_removePerFrameHandler;

    } else {
        if ((!alive derp_airReinforcement) && {derp_lastAirReinforcementTime <= (time - PARAM_airReinforcementTimer)}) then {
            _AOPos params ["_xPos", "_yPos"];

            derp_airReinforcement = createVehicle [["O_Plane_CAS_02_F", "O_Heli_Light_02_F", "O_Heli_Attack_02_F"] call BIS_fnc_selectRandom, getMarkerPos "opforAirSpawn_marker1", ["opforAirSpawn_marker2", "opforAirSpawn_marker3", "opforAirSpawn_marker4"], 50, "FLY"];
            createVehicleCrew derp_airReinforcement;

            {_x addCuratorEditableObjects [[derp_airReinforcement], true]} forEach allCurators;

            _wp = (group derp_airReinforcement) addWaypoint [[_xPos, _yPos, 1000], 0];
            _wp setWaypointType "SAD";

            derp_lastAirReinforcementTime = time;
        };
    };
}, 10, [_AOPos, _officer, _officerGroup, _smID]] call CBA_fnc_addPerFrameHandler;
