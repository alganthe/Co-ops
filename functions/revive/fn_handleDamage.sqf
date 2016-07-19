// can be lower
#define MAX_SAFE_DAMAGE 0.95

player addEventHandler ["HandleDamage", {
    params ["_unit", "_selection", "_damage", "_source", "", "_index"];


private _damageReturned = 0;

if (alive _unit) then {
    if (!isNull objectParent _unit && {!alive vehicle _unit}) exitWith {
        _damageReturned = 1;

        forceRespawn player;
    };

    if (isNull _source) then {
        _source = missionNamespace getVariable ["derp_revive_lastDamageSource",objNull];
    } else {
        derp_revive_lastDamageSource = _source;
    };

    if (_index > -1) then {
        if (_damage < 0.1) then {
            _damageReturned = (_unit getHit _selection) min MAX_SAFE_DAMAGE;
        } else {

            systemChat format ["damage: %1, selection: %2",_damage, _selection];

            if (_damage >= 1.5 && {alive _unit}) then {
                _damageReturned = 1;
                forceRespawn player;
                [_source] call bis_fnc_reviveAwardKill;
            } else {
                if (_damage >= 1 && {!(_unit getVariable ["derp_revive_downed", false])}) then {
                    _damageReturned = 0.95;
                    systemChat "ded detected";

                    if (isNull objectParent _unit) then {
                        _unit setUnconscious true;
                        [player, "DOWNED"] call derp_revive_fnc_switchState;
                        systemChat "ded, downed";
                        cutText ["","BLACK", 1];
                        _unit allowDamage false;
                    } else {
                        private _seat = ((fullCrew vehicle _unit) select {_x select 0 == _unit}) select 0;

                        if ( (_seat select 1 == "driver" && {getNumber (configFile >> "CfgVehicles" >> typeOf (vehicle _unit) >> "ejectDeadDriver") == 1}) || {(_seat select 1 in ["cargo", "turret", "gunner"]) && {getNumber (configFile >> "CfgVehicles" >> typeOf (vehicle _unit) >> "ejectDeadCargo") == 1}}) then {
                            systemChat "ded force respawn";
                            _damageReturned = 1;
                            forceRespawn player;
                            [_source] call bis_fnc_reviveAwardKill;

                        } else {
                            [player, "DOWNED"] call derp_revive_fnc_switchState;
                            systemChat "ded, vehicle downed";
                            cutText ["","BLACK", 1];
                            _unit allowDamage false;
                        };
                    };

                } else {
                    _damageReturned = MAX_SAFE_DAMAGE min _damage;
                };
            };
        };
    };
};

_damageReturned
}];
