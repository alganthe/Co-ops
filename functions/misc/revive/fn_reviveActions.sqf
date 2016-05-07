#include "reviveDefines.hpp"

params ["_unit"];

// Revive
_unit addAction [
    "<t color='#ff0000'> Revive </t>",
    {
        params ["", "_caller", "", "_args"];
        _args params ["_medicAnim"];

        _caller playAction _medicAnim;

        [
            10, // Time the action takes to complete
            [_caller], // Args passed to the code
            {
                [cursorObject, "REVIVED"] remoteExecCall ["derp_revive_fnc_switchState", cursorObject];
            }, // code executed upon action completion
            {}, // Code executed upon action failure
            format ["Reviving %1", name cursorObject], // Title text
            {
                (alive cursorObject) && {cursorObject getVariable ["derp_revive_downed", false]} && {isNull objectParent ((_this select 0) select 0)}
            } // Code to check each frame
        ] call derp_fnc_progressBar;
    },
    [DERP_REVIVE_MEDICANIM],
    10,
    true,
    true,
    "",
    "(cursorObject getVariable ['derp_revive_downed', false]) && {!(_this getVariable ['derp_revive_downed', false])} && {isNull objectParent _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])} && {_this distance cursorObject < 5}" // condition
];

// Dragging
_unit addAction [
    "<t color='#DEB887'> Drag </t>",
    {
        params ["", "_caller", "", "_args"];
        _caller setVariable ["derp_revive_isDragging", true ,true];
        cursorObject setVariable ["derp_revive_isDragged", true ,true];
        [_caller, cursorObject] call derp_revive_fnc_dragging;
    },
    [],
    10,
    true,
    true,
    "",
    "(cursorObject getVariable ['derp_revive_downed', false]) && {!(_this getVariable ['derp_revive_downed', false])} && {isNull objectParent _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])} && {_this distance cursorObject < 5}"
];

// Carrying
_unit addAction [
    "<t color='#DEB887'> Carry </t>",
    {
        params ["", "_caller", "", "_args"];
        _caller setVariable ["derp_revive_isCarrying", true ,true];
        cursorObject setVariable ["derp_revive_isCarried", true ,true];
        [_caller, cursorObject] call derp_revive_fnc_carrying;
    },
    [],
    10,
    true,
    true,
    "",
    "(cursorObject getVariable ['derp_revive_downed', false]) && {!(_this getVariable ['derp_revive_downed', false])} && {isNull objectParent _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])} && {_this distance cursorObject < 5}"
];

// Stop dragging
_unit addAction [
    "<t color='#DEB887'> Stop dragging </t>",
    {
        params ["", "_caller", "", "_args"];
        [_caller, (attachedObjects _caller) select 0, "DRAGGING"] call derp_revive_fnc_dropPerson;
    },
    [],
    10,
    true,
    true,
    "",
    "(_this getVariable ['derp_revive_isDragging', false])"
];

// Stop carrying
_unit addAction [
    "<t color='#DEB887'> Stop carrying </t>",
    {
        params ["", "_caller", "", "_args"];
        [_caller, (attachedObjects _caller) select 0, "CARRYING"] call derp_revive_fnc_dropPerson;
    },
    [],
    10,
    true,
    true,
    "",
    "(_this getVariable ['derp_revive_isCarrying', false])"
];

// Putting in vehicle (foot)
_unit addAction [
    "<t color='#DEB887'> Mount wonded </t>",
    {
        params ["", "_caller", "", "_args"];

        [_caller, (attachedObjects _caller) select 0, "VEHICLE"] call derp_revive_fnc_dropPerson;
    },
    [],
    10,
    true,
    true,
    "",
    "!(cursorObject isKindOf 'CAManBase') && {(_this getVariable ['derp_revive_isCarrying', false]) || {(_this getVariable ['derp_revive_isDragging', false])}} && {{isNull (_x select 0)} count (fullCrew [cursorObject, 'cargo', true]) >= 1} && {_this distance cursorObject < 5}"
];

// Putting outside vehicle (foot)
_unit addAction [
    "<t color='#DEB887'> Eject wounded </t>",
    {
        params ["", "_caller", "", "_args"];

        {
            moveOut _x;
            _x switchMove "acts_injuredlyingrifle02_180";
        } foreach ((crew cursorObject) select {(_x getVariable ['derp_revive_downed', false])});
    },
    [],
    10,
    true,
    true,
    "",
    "!(vehicle cursorObject isKindOf 'CAManBase') && {{(_x getVariable ['derp_revive_downed', false])} count (crew cursorObject) > 0} && {_this distance cursorObject < 5}"
];

// Putting outside vehicle (vehicle)
_unit addAction [
    "<t color='#DEB887'> Eject wounded </t>",
    {
        params ["", "_caller", "", "_args"];

        {
            moveOut _x;
            _x switchMove "acts_injuredlyingrifle02_180";
        } foreach ((crew _caller) select {(_x getVariable ['derp_revive_downed', false])});
    },
    [],
    10,
    true,
    true,
    "",
    "!(vehicle _this isKindOf 'CAManBase') && {{(_x getVariable ['derp_revive_downed', false])} count (crew vehicle _this) > 0} && {_this distance cursorObject < 5}"
];
