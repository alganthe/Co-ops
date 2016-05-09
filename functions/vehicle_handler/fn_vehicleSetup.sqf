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

_vehicleType = typeOf _vehicle;

if (isNull _vehicle) exitWith {};
//---------------------------------------------------------- Arrays
_noAmmoCargo = ["B_APC_Tracked_01_CRV_F", "B_Truck_01_ammo_F"];					// Bobcat CRV / ammoTruck
_uav = ["B_UAV_02_CAS_F", "B_UAV_02_F", "B_UGV_01_F", "B_UGV_01_rcws_F"];		// UAVs

//---------------------------------------------------------- Sorting
//---------- Add UAV crew
if (_vehicleType in _uav) then {
    createVehicleCrew _vehicle;
};

//---------- remove ammo cargo
if (_vehicleType in _noAmmoCargo) then {
	_vehicle setAmmoCargo 0;
};

//---------- EH
if (_vehicleType isKindOf ["Air", configFile >> "CfgVehicles"] && !(_vehicleType in _uav)) then {
    _vehicle addEventHandler ["GetIn", {_this call derp_fnc_pilotCheck}];
};

_vehicle addEventHandler ["Fired", {
    params ["_unit", "_weapon", "", "", "", "", "_projectile"];

    if ((_weapon != "CMFlareLauncher") && {_unit distance2D (getMarkerPos "BASE") < 300}) then {
        deleteVehicle _projectile;
        ["Don't goof at base", "Hold your horses soldier, don't throw, fire or place anything inside the base."] remoteExecCall ["derp_fnc_hintC", _unit];
    }}];

//---------- Add to zeus
{_x addCuratorEditableObjects [[_vehicle], false]} forEach allCurators;
