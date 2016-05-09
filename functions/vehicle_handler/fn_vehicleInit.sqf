/*
* Author: alganthe
* Add a vehicle with the required parameters to the vehicle handling PFH.
*
* Arguments:
* 0: Vehicle to be added <OBJECT>
* 1: Respawn timer (in seconds) <NUMBER>
*
* Return Value:
* Nothing
*/
params ["_vehicle", "_timer"];

derp_vehicleHandler_vehicleHandlingArray pushBack [_vehicle, typeOf _vehicle, getPosATL _vehicle, getDir _vehicle, _timer];
