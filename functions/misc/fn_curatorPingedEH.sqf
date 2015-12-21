/*
* Author: alganthe
* Check if the player is spamming the fucking zeus ping and kills him if he does (5 times without waiting 15s between any of the pings).
* One module linked to all players or linked to an addEditableObjects module linked to all players with the EH is enough.
* This is called by the curatorPinged eventhandler and thus should only be added to zeus modules.
*
* Arguments:
* 0: curator module <always git_rekt_m8>
* 1: unit doing the ping <OBJECT>
*
* Return Value:
* Nothing
*
* Example:
* this addEventHandler [""GetIn"",{_this call derp_fnc_curatorPingedEH}]; // in the zeus module init field
*/
params ["_curator","_unit"];

private _currentTime = serverTime;
private _pingCount = _unit getVariable "curatorPingCount";
private _lastPingTime = _unit getVariable "lastPingTime";

if (isnil "_pingCount") then {
    _unit setVariable ["curatorPingCount", 1, false];
    _unit setVariable ["lastPingTime", _currentTime, false];

} else {
    _pingCount = _pingCount + 1;

    if (_lastPingTime <= serverTime - 15) then {
        _unit setVariable ["lastPingTime",_currentTime,false];
        _unit setVariable ["curatorPingCount",1,false];

    } else {
        if (_pingCount == 4) then {
             ["You have angered Zeus", "wait 15s before pressing the zeus ping button again, or else you'll die."] remoteExecCall ["derp_fnc_hintC",_unit];
        };
        if (_pingCount >= 5) then {
            _unit setDamage 1;
            _unit setVariable ["curatorPingCount", nil, false];
            _unit setVariable ["lastPingTime", nil, false];

        } else {
            _unit setVariable ["lastPingTime",_currentTime,false];
            _unit setVariable ["curatorPingCount",_pingCount,false];

        };
    };
};

if ((("Debug" call BIS_fnc_getParamValue)== 1)) then {
    diag_log format ["%1 %2 %3 %4 %5 %6",_curator,_unit,_pingCount,_lastPingTime,serverTime,(serverTime - 15)];
};
