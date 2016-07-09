[{
    params ["_args", "_pfhID"];

    if (isNil "derp_shortNightActivated") then {
        if (daytime >= 18 || {daytime <= 6}) then {
            setTimeMultiplier (timeMultiplier * 2);
            derp_shortNightActivated = true;
        };
    } else {
        if (daytime <= 18 && {daytime >= 6}) then {
            setTimeMultiplier (timeMultiplier / 2);
            derp_shortNightActivated = nil;
        };
    };
}, 60, []] call derp_fnc_addPerFrameHandler;
