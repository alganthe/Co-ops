params ["_vehicle","_timer"];

vehicleHandlingArray pushBack [_vehicle, typeOf _vehicle, getPosWorld _vehicle, getDir _vehicle,_timer];
diag_log format ["%1",vehicleHandlingArray];
