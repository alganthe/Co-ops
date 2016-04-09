if (("staminaEnabled" call BIS_fnc_getParamValue) == 0) then {
    player enableStamina false;
};

[[player], false] call derp_fnc_remoteAddCuratorEditableObjects;
