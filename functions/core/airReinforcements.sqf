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

    private _wp = (group derp_airReinforcement) addWaypoint [[_xPos, _yPos, 1000], 0];
    _wp setWaypointType "SAD";

    derp_lastAirReinforcementTime = time;
};
