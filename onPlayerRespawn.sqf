if (("staminaEnabled" call BIS_fnc_getParamValue) == 0) then {
    player enableStamina false;
};

{
    _x addCuratorEditableObjects [[_this select 0], false];
} forEach allCurators;
