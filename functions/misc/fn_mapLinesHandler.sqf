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

    ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["draw", {
        {if (markerShape _x == 'POLYLINE') then {deleteMarker _x}} forEach allMapMarkers;
    }];
};
