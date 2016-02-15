/*
 * Author: alganthe
 * Check for objects around the vehicle
 *
 * Arguments:
 * 0: Vehicle to check <OBJECT>
 * 1: Radius around the vehicle to check objects for <NUMBER>
 *
 * Return Value:
 * <BOOL>
 *
 * Example:
 * [_vehicle,10] call derp_fnc_find_flatPos
 */
params ["_vehicle","_radius"];
private ["_flatPos"];

 _flatPos = (getPosWorld _vehicle) isFlatEmpty
[
_radius,	    //--- Minimal distance from another object
0,				//--- If 0, just check position. If >0, select new one
0.4,			//--- Max gradient
_radius max 5,	//--- Gradient area
0,				//--- 0 for restricted water, 2 for required water,
false,			//--- Has to have shore nearby!
objNull		    //--- Ignored object
];

if !(count _flatPos isEqualTo 0) then {
    _return = true;
} else {
    _return = false;
};
_return
