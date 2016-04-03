/*
* Author: alganthe
* PFEH handling quads respawning / abandon
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

        if (isNull _vehicle) then {
            [{
                params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                _newVehicle setDir _spawnDir;

                derp_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                [_newVehicle] call derp_fnc_vehicleSetup;

            }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
            derp_quadHandlingArray deleteAt (derp_quadHandlingArray find _x);

        } else {
            if (!alive _vehicle) then {
                [{
                    params ["_oldVehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

                    if (!isNull _oldVehicle) then {
                        deleteVehicle _oldVehicle;
                    };

                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                    _newVehicle setDir _spawnDir;

                    derp_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                    [_newVehicle] call derp_fnc_vehicleSetup;

                }, [_vehicle, _vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
                derp_quadHandlingArray deleteAt (derp_quadHandlingArray find _x);

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

                        derp_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                        [_newVehicle] call derp_fnc_vehicleSetup;

                    }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
                    deleteVehicle _vehicle;
                    derp_quadHandlingArray deleteAt (derp_quadHandlingArray find _x);
                };
            };
        };
    } forEach derp_quadHandlingArray;
}, 10, []] call CBA_fnc_addPerFrameHandler;
