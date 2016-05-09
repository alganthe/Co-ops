/*
* Author: alganthe
* PFEH handling quads respawning / abandon
* DO NOT CALL THIS. This should only be called once on server init.
*
* Arguments:
* Nothing
*
* Return Value:
* Nothing
*/
[{
    {
        _x params ["_vehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

        // Vehicle was removed, spawn a new one
        if (isNull _vehicle) then {
            [{
                params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                _newVehicle setDir _spawnDir;

                derp_vehicleHandler_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

            }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
            derp_vehicleHandler_quadHandlingArray deleteAt (derp_vehicleHandler_quadHandlingArray find _x);
        } else {
            // Vehicle was destroyed, spawn a new one
            if (!alive _vehicle) then {
                [{
                    params ["_oldVehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

                    if (!isNull _oldVehicle) then {
                        deleteVehicle _oldVehicle;
                    };

                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                    _newVehicle setDir _spawnDir;

                    derp_vehicleHandler_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                    [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                }, [_vehicle, _vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                derp_vehicleHandler_quadHandlingArray deleteAt (derp_vehicleHandler_quadHandlingArray find _x);
            // Else check if the vehicle is near it's spawn point
            } else {
                _distanceCheckResult = {
                    if ((_vehicle distance2D _x) < 10 || {_vehicle distance2D _spawnPos < 5}) exitWith {false};
                    true;
                } foreach allPlayers;

                if ((!isNil "_distanceCheckResult") && {_distanceCheckResult}) then {
                    [{
                        params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                        _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                        _newVehicle setDir _spawnDir;

                        derp_vehicleHandler_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                        [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                    }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                    deleteVehicle _vehicle;
                    derp_vehicleHandler_quadHandlingArray deleteAt (derp_vehicleHandler_quadHandlingArray find _x);
                };
            };
        };
    } forEach derp_vehicleHandler_quadHandlingArray;
}, 10, []] call derp_fnc_addPerFrameHandler;