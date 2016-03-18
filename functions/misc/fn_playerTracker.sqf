if (!hasInterface) exitWith {};

// General macro used.
#define ehContent { \
    if (isNull objectParent _x) then { \
        player reveal [_x, 4]; \
 \
        if ([] call bis_fnc_reviveEnabled && {_x getVariable "BIS_revive_incapacitated"}) then { \
            _controlID drawIcon [ \
            "pictureHeal", \
            [0.78, 0.05, 0.05, 1], \
            getPos _x, \
            30, \
            30, \
            0 \
            ]; \
        }; \
 \
        _controlID drawIcon [ \
        "#(argb,8,8,3)color(0,0,0,0)", \
        [0.07, 0.27, 0.67, 1], \
        getPos _x, \
        (0.4 * 0.15) * 10^(abs log (ctrlMapScale _controlID)), \
        (0.1 * 0.15) * 10^(abs log (ctrlMapScale _controlID)), \
        0, \
        name _x, \
        0, \
        0.04, \
        "TahomaB", \
        "right" \
        ]; \
    } else { \
        _vehicleArray pushbackUnique (vehicle _x) \
    }; \
} forEach (allPlayers - entities "HeadlessClient_F"); \
 \
{ \
    private ["_iconText"]; \
    if (count fullCrew _x == 1) then { \
        _iconText = name (effectiveCommander _x) \
    } else { \
        _iconText = [name (effectiveCommander _x),"+", count (fullCrew _x) - 1] joinString " ", \
    }; \
    player reveal [_x, 4]; \
 \
    _controlID drawIcon [ \
    "#(argb,8,8,3)color(0,0,0,0)", \
    [0.07, 0.27, 0.67, 1], \
    getPos _x, \
    (0.4 * 0.15) * 10^(abs log (ctrlMapScale _controlID)), \
    (0.1 * 0.15) * 10^(abs log (ctrlMapScale _controlID)), \
    0, \
    _iconText, \
    0, \
    0.04, \
    "TahomaB", \
    "right" \
    ]; \
} foreach _vehicleArray;

// Map EH
 ((findDisplay 12) displayCtrl 51) ctrlAddEventHandler ["Draw", {
    _controlID = _this select 0;
    private _vehicleArray = [];

    ehContent;
}];

["derpPlayerTrackerClickEH", "onMapSingleClick", {
    _vehicles = _pos nearEntities [['Air','LandVehicle','Ship'], 50];

    {
        if ((side (effectiveCommander _x)) isEqualTo playerSide) then {

            _peopleInside = (crew _x) apply {name _x};
            _peopleInsideNames = _peopleInside joinString "<br />";
            hintSilent parseText _peopleInsideNames;
        };
    } foreach _vehicles;
}, []] call BIS_fnc_addStackedEventHandler;
