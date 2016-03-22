/*
* Author: alganthe
* Check if the player is spamming the fucking zeus ping and kills him if he does (5 times without waiting 15s between any of the pings).
* One module linked to all players or linked to an addEditableObjects module linked to all players with the EH is enough.
* This is called by the curatorPinged eventhandler and thus should only be added to zeus modules.
*
* Arguments:
* 0: Curator module <always 'git_rekt_m8' cuz reasons>
* 1: Unit doing the ping <OBJECT>
*
* Return Value:
* Nothing
*
* Example:
* this addEventHandler ["curatorPinged",{_this call derp_fnc_curatorPingedEH}]; // in the zeus module init field
*/
params ["_curator", "_unit"];

private _pingCount = _unit getVariable "derp_curatorPingCount";
private _lastPingTime = _unit getVariable "derp_lastPingTime";

if (isnil "_pingCount") then {
    _unit setVariable ["derp_curatorPingCount", 1, false];
    _unit setVariable ["derp_lastPingTime", time, false];

} else {
    _pingCount = _pingCount + 1;

    if (_lastPingTime <= time - 15) then {
        _unit setVariable ["derp_lastPingTime", time, false];
        _unit setVariable ["derp_curatorPingCount", 1, false];

    } else {
        if (_pingCount == 4) then {
             ["You have angered Zeus", "wait 15s before pressing the zeus ping button again, or else you'll die."] remoteExecCall ["derp_fnc_hintC", _unit];
        };
        if (_pingCount >= 5) then {
            _unit setDamage 1;
            _unit setVariable ["derp_curatorPingCount", nil, false];
            _unit setVariable ["derp_lastPingTime", nil, false];

        } else {
            _unit setVariable ["derp_lastPingTime", time, false];
            _unit setVariable ["derp_curatorPingCount", _pingCount, false];

        };
    };
};
