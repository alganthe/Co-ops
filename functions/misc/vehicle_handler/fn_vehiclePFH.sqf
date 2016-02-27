/*
* Author: alganthe
* PFEH handling vehicle respawning / abandon
*
* Arguments:
* Nothing
*''
* Return Value:
* Nothing
*/
[{
    {
        _x params ["_vehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

        if (isNull _vehicle) then {
            [{
                params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                _newVehicle setDir _spawnDir;

                derp_vehicleHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                [_newVehicle] call derp_fnc_vehicleSetup;

            }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
            derp_vehicleHandlingArray deleteAt (derp_vehicleHandlingArray find _x);

        } else {
            if (!alive _vehicle) then {
                [{
                    params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                    _newVehicle setDir _spawnDir;

                    derp_vehicleHandlingArray pushBack [_newVehicle,_vehicleClass, _spawnPos, _spawnDir, _timer];
                    [_newVehicle] call derp_fnc_vehicleSetup;

                }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
                derp_vehicleHandlingArray deleteAt (derp_vehicleHandlingArray find _x);

            } else {
                if (_vehicleClass in ["B_UAV_02_CAS_F", "B_UAV_02_F", "B_UGV_01_F", "B_UGV_01_rcws_F"]) then {} else {

                    _distanceCheckResult = {
                        if ((_vehicle distance2D _x) < PARAM_VehicleRespawnDistance || {_vehicle distance2D _spawnPos < 5}) exitWith {false};
                        true;

                    } foreach allPlayers;

                    if ((!isNil "_distanceCheckResult") && {_distanceCheckResult}) then {
                        [{
                            params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                            _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "CAN_COLLIDE"];
                            _newVehicle setDir _spawnDir;

                            derp_vehicleHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                            [_newVehicle] call derp_fnc_vehicleSetup;

                        }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExec;
                        deleteVehicle _vehicle;
                        derp_vehicleHandlingArray deleteAt (derp_vehicleHandlingArray find _x);
                    };
                };
            };
        };
    } forEach derp_vehicleHandlingArray;

}, 10, []] call CBA_fnc_addPerFrameHandler;
