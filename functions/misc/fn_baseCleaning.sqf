/*
* Author: alganthe
* Base cleanup
*
* Arguments:
* Nothing
*
* Return Value:
* Nothing
*/
[{
    params ["_args", "_pfhID"];

    ((getMarkerPos "BASE") nearObjects ["WeaponHolder", 300]) apply {deleteVehicle _x};
    ((getMarkerPos "BASE") nearObjects ["WeaponHolderSimulated", 300]) apply {deleteVehicle _x};
    ((getMarkerPos "BASE") nearObjects ["CraterLong", 300]) apply {deleteVehicle _x};
}, 30, []] call derp_fnc_addPerFrameHandler;
