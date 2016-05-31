/*
* Author: alganthe
* Stop doodling on the map based on mission setting
*
* Arguments:
*
* Return Value:
* Nothing
*/
if !(getMissionConfigValue ["mapDrawingEnabled", false]) then {

    [{
        {if (markerShape _x == 'POLYLINE') then {deleteMarker _x}} forEach allMapMarkers;
    }, 0, []] call derp_fnc_addPerFrameHandler;
};
