/*
* Author: alganthe
* addCuratorEditableObjects doesn't work client side, so remoteExc it is.
*
* Arguments:
* 0: Array of objects to add <ARRAY>
* 1: Add crew or not <BOOL>
*
* Return Value:
* Nothing
*
* Example:
*
* [[_myOject1, _myObject2, _myObjectN], true] call derp_fnc_remoteAddCuratorEditableObjects;
*/
params ["_objects", ["_addCrew", true]];

if !(isServer) then {
    [_objects, _addCrew] remoteExec ["derp_fnc_remoteAddCuratorEditableObjects", 2];
} else {
    {
        _x addCuratorEditableObjects [_objects, _addCrew];
    } forEach allCurators;
};
