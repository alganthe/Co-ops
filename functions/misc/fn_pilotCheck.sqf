/*
* Author: alganthe
* Check if the unit is authorized to enter the pilot / copilot slot of the vehicle, if not they are kicked out.
* This is called by the getInMan and seatSwitched ehs.
*
* Arguments:
* 0: Unit performing the action <OBJECT>
* 1: position in which the unit is entering <driver, gunner or cargo>
* 2: vehicle being entered <OBJECT>
* 3: turretIndex of the position < [] for driver and [0] to n number of seats>
*
* Return Value:
* Nothing
*
* Example:
*
* yourVehicle addEventHandler ["GetInMan", {_this call derp_fnc_pilotCheck}];
*/
params ["_unit", "_position", "_vehicle", "_turretIndex"];

if !(_vehicle isKindOf "Air" && {!(_vehicle isKindOf "ParachuteBase")}) exitwith {};

if (!(player getUnitTrait "derp_pilot")) then {
    if (_position == "driver") then {
        moveOut _unit;
        ["What are you doing?", "You're not a pilot, you're not allowed to do that."] remoteExec ["derp_fnc_hintC", _unit];

    } else {
        private _coPilotTurret = [_vehicle] call {

            params [["_vehicle", objNull, [objNull]]];

            fullCrew [_vehicle, "turret", true] apply {_x select 3} select {
                getNumber ([_vehicle, _x] call derp_fnc_getTurret >> "isCopilot") == 1
            } param [0, []]
        };

        if (_coPilotTurret isEqualTo _turretIndex) then {
            moveOut _unit;
            ["What are you doing?", "You're not a pilot, you're not allowed to do that."] remoteExec ["derp_fnc_hintC", _unit];
        };
    };
};
