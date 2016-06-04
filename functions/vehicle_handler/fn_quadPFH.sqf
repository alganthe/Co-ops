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

        private _distanceCheckResult = {
            {
                if ((_vehicle distance2D _x) < 10 || {_vehicle distance2D _spawnPos < 5}) exitWith {false};
                    true;
            } foreach allPlayers;
        };

        if (call _distanceCheckResult) then {
            [{
                params ["_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];
                private _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                _newVehicle setDir _spawnDir;

                derp_vehicleHandler_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                }, [_vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
                deleteVehicle _vehicle;
            derp_vehicleHandler_quadHandlingArray deleteAt (derp_vehicleHandler_quadHandlingArray find _x);
        } else {
            [{
                params ["_oldVehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

                if (!isNull _oldVehicle) then {
                    deleteVehicle _oldVehicle;
                };

                private _newVehicle = createVehicle [_vehicleClass, _spawnPos, [], 0, "NONE"];
                _newVehicle setDir _spawnDir;

                derp_vehicleHandler_quadHandlingArray pushBack [_newVehicle, _vehicleClass, _spawnPos, _spawnDir, _timer];
                [_newVehicle] call derp_vehicleHandler_fnc_vehicleSetup;

                }, [_vehicle, _vehicleClass, _spawnPos, _spawnDir, _timer], _timer] call derp_fnc_waitAndExecute;
            derp_vehicleHandler_quadHandlingArray deleteAt (derp_vehicleHandler_quadHandlingArray find _x);
        };
    } forEach (derp_vehicleHandler_quadHandlingArray select {
        _x params ["_vehicle", "_vehicleClass", "_spawnPos", "_spawnDir", "_timer"];

        private _distanceCheckResult = {
            {
                if ((_vehicle distance2D _x) < 10 || {_vehicle distance2D _spawnPos < 5}) exitWith {false};
                    true;
            } foreach allPlayers;
        };

        if (isNull _vehicle || {!alive _vehicle} || {call _distanceCheckResult}) then {
            true
        };
    });
}, 10, []] call derp_fnc_addPerFrameHandler;
