/*

*/
//---------------------------------------------------------- CONFIG
params ["_vehicle","_type"];

_type = typeOf _vehicle;

if (isNull _vehicle) exitWith {};

//---------------------------------------------------------- ARRAYS
_ghosthawk = ["B_Heli_Transport_01_camo_F","B_Heli_Transport_01_F"]; 			// ghosthawk
_noAmmoCargo = ["B_APC_Tracked_01_CRV_F","B_Truck_01_ammo_F"];					// Bobcat CRV
_uav = ["B_UAV_02_CAS_F","B_UAV_02_F","B_UGV_01_F","B_UGV_01_rcws_F"];			// UAVs
_fob = [""];

//---------------------------------------------------------- SORT
//---------- FOB sorting
if (_type in _fob) then {
    [_vehicle,nil,true] remoteExecCall ["derp_fnc_FOB_handler", 2];
    // AddAction
};

//---------- Add UAV crew
if (_type in _uav) then {
    createVehicleCrew _vehicle;
};

//---------- remove ammo cargo
if (_type in _noAmmoCargo) then {
	_vehicle setAmmoCargo 0;
};

//---------- EH
if (_type isKindOf ["Air",configFile >> "CfgVehicles"] && !(_type in _uav)) then {
    _vehicle addEventHandler ["GetIn",{_this call derp_fnc_pilotCheck}];
};

_vehicle addEventHandler ["Fired", {
    params ["_unit","","","","","","_projectile"];

    if (_unit distance2D (getMarkerPos "BASE") < 300) then {
        deleteVehicle _projectile;
        ["Warning!","Hold your fire soldier, don't throw or fire anything inside the base."] remoteExecCall ["derp_fnc_hintC", _unit];
    };
}];

//---------- Add to zeus
{_x addCuratorEditableObjects [[_vehicle],false];} count allCurators;
