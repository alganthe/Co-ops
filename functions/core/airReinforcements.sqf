#include "..\..\defines.hpp"
/*
* Author: alganthe
* Handles the CSAT air support.
*
* Arguments:
* 0: The AO position <POSITION>
*
* Return Value:
* nothing
*
*/
params ["_AOPos"];

if ((!alive derp_airReinforcement) && {derp_lastAirReinforcementTime <= (time - derp_PARAM_airReinforcementTimer)}) then {
    _AOPos params ["_xPos", "_yPos"];

    derp_airReinforcement = createVehicle [(selectRandom AirReinforcementVehicleList), getMarkerPos "opforAirSpawn_marker1", ["opforAirSpawn_marker2", "opforAirSpawn_marker3", "opforAirSpawn_marker4"], 50, "FLY"];
    createVehicleCrew derp_airReinforcement;
    derp_airReinforcement lock 2;

    {_x addCuratorEditableObjects [[derp_airReinforcement], true]} forEach allCurators;

    [group derp_airReinforcement, _AOpos, derp_PARAM_AOSize / 2] call BIS_fnc_taskPatrol;

    derp_lastAirReinforcementTime = time;
};
