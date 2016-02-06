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
        _x params ["_vehicle","_vehicleClass","_spawnPos","_spawnDir","_timer"];

        if (isNull _vehicle) then {
            [{
                params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                _newVehicle setDir _spawnDir;

                quadHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                [_newVehicle] call derp_fnc_vehicleSetup;

            },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
            quadHandlingArray deleteAt (quadHandlingArray find _x);

        } else {
            if (!alive _vehicle) then {
                [{
                    params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                    _newVehicle setDir _spawnDir;

                    quadHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                    [_newVehicle] call derp_fnc_vehicleSetup;

                },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
                quadHandlingArray deleteAt (quadHandlingArray find _x);

            } else {
                _distanceCheckResult = {
                    if ((_vehicle distance2D _x) > 10 && {_vehicle distance2D _spawnPos > 5}) exitWith {true};
                    if (true) exitWith {false};
                } count allPlayers;

                if (_distanceCheckResult) then {
                    [{
                        params ["_vehicleClass","_spawnPos","_spawnDir","_timer"];
                        _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                        _newVehicle setDir _spawnDir;

                        quadHandlingArray pushBack [_newVehicle,_vehicleClass,_spawnPos,_spawnDir,_timer];
                        [_newVehicle] call derp_fnc_vehicleSetup;

                    },[_vehicleClass,_spawnPos,_spawnDir,_timer],_timer] call derp_fnc_waitAndExec;
                    deleteVehicle _vehicle;
                    quadHandlingArray deleteAt (quadHandlingArray find _x);
                };
            };
        };
    } forEach quadHandlingArray;

},10,[]] call CBA_fnc_addPerFrameHandler;
