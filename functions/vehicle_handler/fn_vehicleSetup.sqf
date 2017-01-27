#include "..\..\defines.hpp"
/*
* Author: alganthe
* Serve as an init for the specified vehicle with whatever variable / code needed.
*
* Arguments:
* 0: Vehicle to be init <OBJECT>
*
* Return Value:
* Nothing
*/
params ["_vehicle"];

private _vehicleType = typeOf _vehicle;

if (isNull _vehicle) exitWith {};

// Add UAV crew
if (_vehicleType in VHCrewedVehicles) then {
    createVehicleCrew _vehicle;
};

// remove ammo cargo
if (_vehicleType in NoAmmoCargoVehc) then {
    _vehicle setAmmoCargo 0;
};

// Add to zeus
{_x addCuratorEditableObjects [[_vehicle], false]} forEach allCurators;
