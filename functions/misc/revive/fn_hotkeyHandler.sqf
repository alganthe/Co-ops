derp_reviveKeyDownID = (findDisplay 46) displayAddEventHandler ["KeyDown", {
    systemChat "keyPressed";
    if (_this select 1 != 57) exitWith {}; // Not space

    if !(isNil "derp_revive_keyDown") exitWith {}; // PFH already present

    [{
        params ["_args", "_idPFH"];
        _args params ["_timeOut"];

        if (isNil "derp_revive_keyDown") then {
            [_idPFH] call derp_fnc_removePerFrameHandler;
        } else {
            if (ceil derp_missionTime >= ceil _timeOut + 3) then {
                player setDamage 1;
                [_idPFH] call derp_fnc_removePerFrameHandler;
            } else {
                 titleText ["Respawn in " + str ((ceil _timeOut + 3) - ceil derp_missionTime), "PLAIN", 0.1]; // The use of ceil is to avoid weird numbers
            };
        };
    }, 1, [derp_missionTime]] call derp_fnc_addPerFrameHandler;
    derp_revive_keyDown = true;
}];

derp_reviveKeyUpID = (findDisplay 46) displayAddEventHandler ["KeyUp", {
    systemChat "keyUp";
    derp_revive_keyDown = nil;
}];
