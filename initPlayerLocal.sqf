//------------------------------ Headless Client
if !(isServer or hasInterface) then {
    if (local HCAOs) then {

        HCAOsConnected = true;
        publicVariableServer "HCAOsConnected";
        diag_log format ["HCAOs connected"];
    } else {

        HCAmbiantConnected = true;
        publicVariableServer "HCAmbiantConnected";
        diag_log format ["HCAmbiantAI connected"];
    };

} else {//-------------------------------- Player stuff

    [] call derp_fnc_diary; // Diary
    execVM "scripts\misc\QS_icons.sqf"; // Icons

    //---------------- mission params
    if (("staminaEnabled" call BIS_fnc_getParamValue) == 0) then {
        player enableStamina false;
    };

    //---------------- class specific stuff
    _pilotsClassnames = ["B_pilot_F","B_Helipilot_F"];
    if ((typeOf player) in _pilotsClassnames) then {
        [player,"pilotRespawn"] call BIS_fnc_addRespawnPosition;
    };

    if (player isKindOf "B_support_Mort_f") then {
    	enableEngineArtillery true;
    } else {
    	enableEngineArtillery false;
    };

    //---------------- EHs and addactions
    player addEventHandler ["Fired", {
        params ["_unit","","","","","","_projectile"];

        if (_unit distance2D (getMarkerPos "BASE") < 300) then {
            deleteVehicle _projectile;
            ["Don't fire at base","Hold your fire soldier, don't throw or fire anything inside the base."] remoteExecCall ["derp_fnc_hintC", _unit];
        };
    }];
};
