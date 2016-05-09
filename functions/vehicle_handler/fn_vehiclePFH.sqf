/*
* Author: alganthe
* PFEH handling vehicle respawning / abandon
* DO NOT CALL THIS. This should only be called once on server init.
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

        // Check if vehicle needs to be removed from the PFH
        if (_vehicle getVariable ["derp_taskDelete", false]) then {
            derp_vehicleHandler_vehicleHandlingArray deleteAt (derp_vehicleHandler_vehicleHandlingArray find _x);
        } else {
            // Vehicle was removed, spawn a new one
            if (isNull _vehicle) then {
                [{
                    params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

                    _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                    _newVehicle setDir _spawnDir;

                    derp_vehicleHandler_vehicleHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                    [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                derp_vehicleHandler_vehicleHandlingArray deleteAt (derp_vehicleHandler_vehicleHandlingArray find _x);
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

                        derp_vehicleHandler_vehicleHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                        [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                    }, [_vehicle, _vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                    derp_vehicleHandler_vehicleHandlingArray deleteAt (derp_vehicleHandler_vehicleHandlingArray find _x);
                } else {
                    // Check if the vehicle is a UAV, if it's the case ignore distance check
                    if (_vehicleClass in ["B_UAV_02_CAS_F", "B_UAV_02_F", "B_UGV_01_F", "B_UGV_01_rcws_F"]) then {} else {

                        _distanceCheckResult = {
                            if ((_vehicle distance2D _x) < derp_PARAM_VehicleRespawnDistance || {_vehicle distance2D _spawnPos < 5}) exitWith {false};
                            true;

                        } foreach allPlayers;
                        // Distance check
                        if ((!isNil "_distanceCheckResult") && {_distanceCheckResult}) then {
                            [{
                                params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                                _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                                _newVehicle setDir _spawnDir;

                                derp_vehicleHandler_vehicleHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                                [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                            }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                            deleteVehicle _vehicle;
                            derp_vehicleHandler_vehicleHandlingArray deleteAt (derp_vehicleHandler_vehicleHandlingArray find _x);
                        };
                    };
                };
            };
        };
    } forEach derp_vehicleHandler_vehicleHandlingArray;

}, 10, []] call derp_fnc_addPerFrameHandler;
