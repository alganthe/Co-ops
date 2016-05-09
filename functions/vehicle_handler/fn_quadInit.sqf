/*
* Author: alganthe
* Add a quad with the required parameters to the quad handling PFH.
*
* Arguments:
* 0: quad to be added <OBJECT>
* 1: Respawn timer (in seconds) <NUMBER>
*
* Return Value:
* Nothing
*/
params ["_vehicle", "_timer"];

derp_vehicleHandler_quadHandlingArray pushBack [_vehicle, typeOf _vehicle, getPosATL _vehicle, getDir _vehicle, _timer];
