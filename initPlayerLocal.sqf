disableRemoteSensors true;

//------------------------------ Headless Client
if !(isServer or hasInterface) then {
    if (profileName == "HCAOs") then {

        derp_HCAOsConnected = true;
        publicVariableServer "HCAOsConnected";
        format ["HCAOs connected: %1", derp_HCAOsConnected] remoteExec ["diag_log", 2];
    };
} else {//-------------------------------- Player stuff

    #include "defines.hpp"
    enableSentences false;
    [] call derp_fnc_diary; // Diary

    [{!isNull (findDisplay 46)}, {call derp_fnc_mapLinesHandler}, []] call derp_fnc_waitUntilAndExecute; // No more penii

    ["InitializePlayer", [player]] call BIS_fnc_dynamicGroups; // Dynamic groups init

    [] execVM "scripts\misc\QS_icons.sqf";  // Map icons

    [[player], false] call derp_fnc_remoteAddCuratorEditableObjects; // Add unit to zeus.
    //---------------- mission params
    if (("staminaEnabled" call BIS_fnc_getParamValue) == 0) then {
        player enableStamina false;
    };

    if (("paraJumpEnabled" call BIS_fnc_getParamValue) == 1) then {
        derp_PARAM_paraJumpEnabled = true;
    } else {
        derp_PARAM_paraJumpEnabled = false;
    };

    //---------------- class specific stuff
    if (player getUnitTrait "derp_pilot") then {
        [player, pilotRespawnMarker] call BIS_fnc_addRespawnPosition;
    };

     // Disable arty computer for non FSG members
    if (player getUnitTrait "derp_mortar") then {
        enableEngineArtillery true;
    } else {
        enableEngineArtillery false;
    };

    if ("derp_revive" in (getMissionConfigValue "respawnTemplates")) then {
        if (getMissionConfigValue "derp_revive_everyoneCanRevive" == 0) then {
            if (player getUnitTrait "medic") then {
                call derp_revive_fnc_drawDowned;
            };
        } else {
            call derp_revive_fnc_drawDowned;
        };
        call derp_revive_fnc_handleDamage;
        if (getMissionConfigValue "respawnOnStart" == -1) then {[player] call derp_revive_fnc_reviveActions};
    };

    //---------------- EHs and addactions
    player addEventHandler ["GetInMan", {
        _this call derp_fnc_pilotCheck;
        call derp_fnc_crewNames;
    }];

    player addEventHandler ["SeatSwitchedMan", {
        if !((_this select 3) isKindOf "Air") exitWith {};
        _this params ["_unit1", "", "_vehicle"];
        private _seat = ((fullCrew _vehicle) select {_x select 0 == _unit1}) select 0;
        [(_seat select 0), (_seat select 1), _vehicle, (_seat select 3)] call derp_fnc_pilotCheck;

    }];

    player addEventHandler ["Fired", {
        params ["_unit", "_weapon", "", "", "", "", "_projectile"];

        if (_unit distance2D (getMarkerPos "BASE") < 300) then {
            deleteVehicle _projectile;
            ["Don't goof at base", "Hold your horses soldier, don't throw, fire or place anything inside the base."] remoteExecCall ["derp_fnc_hintC", _unit];
        }}];

    if ("ArsenalFilter" call BIS_fnc_getParamValue == 1) then {
        player addEventHandler ["Take", {
            params ["_unit", "_container", "_item"];

            [_unit, 1, _item, _container] call derp_fnc_gearLimitations;
        }];

        player addEventHandler ["InventoryClosed", {
            params ["_unit"];

            [_unit, 0] call derp_fnc_gearLimitations;
        }];
    };

    {
        _x addAction [
            "<t color='#006bb3'>Save gear</t>",
            {
                player setVariable ["derp_savedGear", (getUnitLoadout player)];
                systemChat "gear saved";
            }
        ];

        if (derp_PARAM_paraJumpEnabled) then {
            _x addAction [
            "<t color='#FF6600'>Paradrop on AO</t>",
            {
                [player,
                  2 * ("AOSize" call BIS_fnc_getParamValue)
                ] call derp_fnc_paradrop;
            },
            nil,
            0,
            true,
            true,
            "",
            "(!isNil 'missionInProgress') && {missionInProgress} && {!isNil 'derp_paraPos'}",
            5,
            false
            ];
        };
    } foreach ArsenalBoxes;
};

[ArsenalBoxes, ("ArsenalFilter" call BIS_fnc_getParamValue)] call derp_fnc_VA_filter; // Init arsenal boxes.
