params ["_unit", "_mode"];

if (_mode) then {
    _derp_revive_animChangedID = _unit addEventHandler ["AnimChanged", {
        params ["_unit", "_anim"];

        if (_unit getVariable ["derp_revive_downed", false] && {isNull objectParent _unit} && {!(_unit getVariable ["derp_revive_isDragged",false]) || {!(_unit getVariable ["derp_revive_isCarried", false])}}) then {
            _unit switchMove "acts_injuredlyingrifle02_180";
        };
    }];

    _unit setVariable ["_derp_revive_animChangedID", _derp_revive_animChangedID];
} else {
    _unit removeEventHandler ["AnimChanged", (_unit getVariable "_derp_revive_animChangedID")];
    _unit setVariable ["_derp_revive_animChangedID", nil];

};
