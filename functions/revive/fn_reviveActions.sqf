/*
* Author: alganthe
* Add the proper actions on unit init, those use cursorObject and are added to the player, no need to add them back after death
*
* Arguments:
* 0: Unit the actions are added to <OBJECT>
*
* Return Value:
* Nothing
*/
params ["_unit"];

private _whoCanRevive = "";
if (getMissionConfigValue ["derp_revive_everyoneCanRevive", 0] == 0) then {
    _whoCanRevive = "{_this getUnitTrait 'medic'} &&";
};

// Revive
_unit addAction [
    "<t color='#ff0000'> Revive </t>",
    {
        params ["", "_caller", "", "_args"];

        _caller removeItem "FirstAidKit";

        _caller playAction "MedicOther";

        [
            10, // Time the action takes to complete
            [_caller], // Args passed to the code
            {
                [cursorObject, "REVIVED"] remoteExecCall ["derp_revive_fnc_switchState", cursorObject];
            }, // code executed upon action completion
            {}, // Code executed upon action failure
            format ["Reviving %1", name cursorObject], // Title text
            {
                (alive cursorObject) && {cursorObject getVariable ["derp_revive_downed", false]} && {isNull objectParent ((_this select 0) select 0)} && {!(cursorObject getVariable ['derp_revive_isDragged', false]) || {!(cursorObject getVariable ['derp_revive_isCarried', false])}}
            } // Code to check each frame
        ] call derp_fnc_progressBar;
    },
    [],
    10,
    true,
    true,
    "",
    "(cursorObject getVariable ['derp_revive_downed', false]) && {!(_this getVariable ['derp_revive_downed', false])} && {isNull objectParent _this} &&" + _whoCanRevive + "{'FirstAidKit' in items _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])} && {_this distance cursorObject < 5}" // condition
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
        {
            detach _x;
        } foreach ((attachedObjects _caller) select {isNull _x});

        private _dragged = ((attachedObjects _caller) select {_x isKindOf "CAManBase"});
        if (_dragged isEqualTo []) then {
            _caller setVariable ["derp_revive_isCarrying", false ,true];
        } else {
            [_caller, _dragged select 0, "DRAGGING"] call derp_revive_fnc_dropPerson;
        };
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
        {
            detach _x;
        } foreach ((attachedObjects _caller) select {isNull _x});

        private _dragged = ((attachedObjects _caller) select {_x isKindOf "CAManBase"});
        if (_dragged isEqualTo []) then {
            _caller setVariable ["derp_revive_isCarrying", false ,true];
        } else {
            [_caller, _dragged select 0, "CARRYING"] call derp_revive_fnc_dropPerson;
        };

    },
    [],
    10,
    true,
    true,
    "",
    "(_this getVariable ['derp_revive_isCarrying', false])"
];
