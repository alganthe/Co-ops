[{
    {
        _x params ["_vehicle","_vehicleClass","_spawnPos","_spawnDir","_timer"];

        if (isNull _vehicle) then {
            diag_log format ["%1 was deleted when the check occured",_vehicle];
            [{
                params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                _newVehicle setDir _spawnDir;

                vehicleHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                [_newVehicle] call derp_fnc_vehicleSetup;

            },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
            vehicleHandlingArray deleteAt (vehicleHandlingArray find _x);

        } else {
            if (!alive _vehicle) then {
                diag_log format ["%1 ded",_vehicle];
                [{
                    params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                    _newVehicle setDir _spawnDir;

                    vehicleHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                    [_newVehicle] call derp_fnc_vehicleSetup;

                },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
                vehicleHandlingArray deleteAt (vehicleHandlingArray find _x);

            } else {
                _distanceCheckResult = {
                    if ((_vehicle distance2D _x) > ("VehicleRespawnDistance" call BIS_fnc_getParamValue) && {_vehicle distance2D _spawnPos > 5}) exitWith {true};
                    if (true) exitWith {false};
                } count allPlayers;

                if (_distanceCheckResult) then {
                    diag_log format ["%1 too far from players",_vehicle];
                    [{
                        params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                        _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                        _newVehicle setDir _spawnDir;

                        vehicleHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                        [_newVehicle] call derp_fnc_vehicleSetup;

                    },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
                    deleteVehicle _vehicle;
                    vehicleHandlingArray deleteAt (vehicleHandlingArray find _x);
                };
            };
        };
    } forEach vehicleHandlingArray;

},10,[]] call CBA_fnc_addPerFrameHandler;
