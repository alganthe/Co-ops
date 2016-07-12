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

private _itemUsed = "{('FirstAidKit' in items _this) || {'FirstAidKit' in items cursorObject}} &&";

if (getMissionConfigValue ["derp_revive_reviveItem", 0] == 1) then {
    _itemUsed = "{'Medikit' in items _this} &&";
};

// Revive
[
    _unit, // Object
    "<t color='#ff0000'> Revive </t>", // Title
    "", // Idle icon
    "", // Progress icon
    "(cursorObject getVariable ['derp_revive_downed', false]) && {isNull objectParent _this} &&" + _whoCanRevive + _itemUsed + "{!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])", // Condition for action to be shown
    "true", // Condition for action to progress
    {
        params ["", "_caller"];
        _caller playAction "MedicOther";
    }, // Code executed on start
    {
        (cursorObject getVariable ['derp_revive_downed', false]) && {isNull objectParent (_this select 1)} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])}
    }, // Code executed on every tick
    {
        params ["", "_caller"];

        if (getMissionConfigValue ["derp_revive_removeFAKOnUse", 1] == 1 && {getMissionConfigValue ["derp_revive_reviveItem", 0] == 0}) then {
            if ('FirstAidKit' in items _caller) then {
                _caller removeItem "FirstAidKit";
            } else {
                cursorObject removeItem "FirstAidKit";
            };

            [cursorObject, "REVIVED"] remoteExecCall ["derp_revive_fnc_switchState", cursorObject];
        };
    }, // Code executed on completion
    {
        params ["", "_caller"];

        if (getMissionConfigValue ["derp_revive_removeFAKOnUse", 1] == 1 && {getMissionConfigValue ["derp_revive_reviveItem", 0] == 0}) then {
            if ('FirstAidKit' in items _caller) then {
                _caller removeItem "FirstAidKit";
            } else {
                cursorObject removeItem "FirstAidKit";
            };
        };
    }, // Code executed on fail
    [], // Arguments
    6, // Action duration
    10, // Priority
    false, // Remove on completion
    false // Shown on unconscious
] call BIS_fnc_holdActionAdd;

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
    "(cursorObject getVariable ['derp_revive_downed', false]) && {isNull objectParent _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])}",
    5,
    false
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
    "(cursorObject getVariable ['derp_revive_downed', false]) && {isNull objectParent _this} && {!(cursorObject getVariable ['derp_revive_isDragged', false])} && {!(cursorObject getVariable ['derp_revive_isCarried', false])}",
    5,
    false
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
