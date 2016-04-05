disableRemoteSensors true;

//------------------------------ Headless Client
if !(isServer or hasInterface) then {
    if (profileName == "HCAOs") then {

        derp_HCAOsConnected = true;
        publicVariableServer "HCAOsConnected";
        format ["HCAOs connected: %1", derp_HCAOsConnected] remoteExec ["diag_log", 2];
    };
} else {//-------------------------------- Player stuff

    [] call derp_fnc_diary; // Diary

    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // Dynamic groups init

    [] execVM "scripts\misc\QS_icons.sqf";

    {
        _x addCuratorEditableObjects [[player], false];
    } forEach allCurators;
    //---------------- mission params
    if (("staminaEnabled" call BIS_fnc_getParamValue) == 0) then {
        player enableStamina false;
    };

    if (("paraJumpEnabled" call BIS_fnc_getParamValue) == 1) then {
        PARAM_paraJumpEnabled = true;
    } else {
        PARAM_paraJumpEnabled = false;
    };

    //---------------- class specific stuff
    _pilotsClassnames = ["B_pilot_F","B_Helipilot_F"];
    if ((typeOf player) in _pilotsClassnames) then {
        [player, "pilotRespawn"] call BIS_fnc_addRespawnPosition;
    };

    if (player isKindOf "B_support_Mort_f") then {
    	enableEngineArtillery true;
    } else {
    	enableEngineArtillery false;
    };

    //---------------- EHs and addactions
    player addEventHandler ["Fired", {
        params ["_unit", "_weapon", "", "", "", "", "_projectile"];

        if (_unit distance2D (getMarkerPos "BASE") < 300) then {
            deleteVehicle _projectile;
            ["Don't goof at base", "Hold your horses soldier, don't throw, fire or place anything inside the base."] remoteExecCall ["derp_fnc_hintC", _unit];
        }}];

    if (PARAM_paraJumpEnabled) then {
        arsenalDude addAction [
        "<t color='#FF6600'>Paradrop on AO</t>",
        {
            _this params ["", "_unit"];
            derp_paraPos params ["_xPos", "_yPos"];

            _randomPos = [(_xPos + (random 50)), (_yPos + (random 50)), 400];
            _parachute = createVehicle ["Steerable_Parachute_F", _randomPos, [], 10, "FLY"];
            _unit moveInDriver _parachute;
        },
        nil,
        0,
        false,
        true,
        "",
        "(!isNil 'missionInProgress') && {missionInProgress} && {!isNil 'derp_paraPos'}"
        ];
    };
};
