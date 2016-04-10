/*
* Author: alganthe
* Check if the unit is authorized to enter the pilot / copilot slot of the vehicle, if not they are kicked out.
* This is called by the getIn eventhandler.
*
* Arguments:
* 0: vehicle the getIn action is used on <OBJECT>
* 1: position in which the unit is entering <driver, gunner or cargo>
* 2: unit doing the action <OBJECT>
* 3: turretIndex of the position < [] for driver and [0] to n number of seats>
*
* Return Value:
* Nothing
*
* Example:
*
* yourVehicle addEventHandler [""GetIn"",{_this call derp_fnc_pilotCheck}];
*/
params ["_vehicle", "_position", "_unit", "_turretIndex"];

_authorizedPilotUnits = ["B_pilot_F", "B_Helipilot_F"];
_secondCopilotHelos = ["O_Heli_Transport_04_F", "O_Heli_Transport_04_ammo_F", "O_Heli_Transport_04_bench_F", "O_Heli_Transport_04_box_F", "O_Heli_Transport_04_covered_F", "O_Heli_Transport_04_fuel_F", "O_Heli_Transport_04_repair_F", "O_Heli_Transport_04_medevac_F"];
_casHelos = ["B_Heli_Attack_01_F", "O_Heli_Attack_02_F", "O_Heli_Attack_02_black_F"];

if !(typeOf _unit in _authorizedPilotUnits) then {

    if (_position == "driver") then {
        moveOut _unit;
        ["What are you doing?", "You are not in a pilot slot!"] remoteExecCall ["derp_fnc_hintC", _unit];

    } else {

        if (!(typeOf _vehicle in _casHelos) && {!(typeof _vehicle in _secondCopilotHelos) && {0 in _turretIndex}} || {typeof _vehicle in _secondCopilotHelos && {0 in _turretIndex || {1 in _turretIndex}}}) then {
            moveOut _unit;
            ["What are you doing?", "You are not in a pilot slot!"] remoteExecCall ["derp_fnc_hintC", _unit];
        };
    };
};
