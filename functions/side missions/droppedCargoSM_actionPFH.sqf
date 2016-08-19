#include "..\..\defines.hpp"
/*
* Author: alganthe
* PFH handling the cargoSM box explosion
*
* Arguments:
* 0: SM objective <OBJECT>
*
* Return Value:
* Nothing
*/
params [["_box", objNull]];

if !(isServer || {_box isEqualTo objNull}) exitWith {};

private _charge = "DemoCharge_Remote_Ammo_Scripted" createVehicle (position _box);
_charge attachTo [_box, CARGOSMBoxAttachOffset];

[{
    params ["_args", "_pfhID"];
    _args params ["_box", "_timerLegnth", "_startTime", "_demoCharge"];

    if (time >= _startTime + _timerLegnth || {!alive _box}) then {

        detach _demoCharge;


        // Exec destruction next frame
        [{
            params ["_demoCharge", "_box"];

            _demoCharge setDamage 1;

            if !(isNull _box) then {
                deleteVehicle _box;
            };
        }, [_demoCharge, _box]] call derp_fnc_execNextFrame;

    } else {
        format ["SM charge detonation in: %1s",round ((_startTime + _timerLegnth) - time)] remoteExec ["systemChat", 0];
    };

}, 5, [_box, 30, time, _charge]] call derp_fnc_addPerFrameHandler;
