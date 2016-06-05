/*
* Author: yourstruly
* Allow player to choose the paradrop point (within specified radius of derp_paraPos).
* Click within that area initiates paradrop.
*
* Arguments:
* 0: Unit requesting paradrop <OBJECT>
* 1: Size of the AO <NUMBER>
*
* Return Value:
* Nothing
*
* Example:
* [player, 500] call derp_fnc_paradrop;
*/
params ["_unit", "_radius"];

private _markerName = ["max_range_", name _unit] joinString "";
private _marker = createMarkerLocal [_markerName, derp_paraPos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_radius, _radius];
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerColorLocal "ColorBlue";
_marker setMarkerAlphaLocal 0.5;

openMap true;

["derp_paradrop_mapclick", "onMapSingleClick", {
    _this params ["_unit", "_radius"];

    scopeName "main";
    if (leader group _unit == _unit) then {
        private _dist = _pos distance2D derp_paraPos;

        if (_dist > _radius) exitWith {hint "Select position within the marked area."};

        if ({_x getUnitTrait "derp_pilot"}count allPlayers > 0) then {
            if ({side ((crew _x) select 0) == playerSide && {alive ((crew _x ) select 0)} && {speed _x > 10}} count (derp_paraPos nearEntities ["Helicopter", _radius]) == 0) then {
                hint "No helicopter near the AO";
                breakOut "main";
            };
        };

        _unit setPos [_pos select 0, _pos select 1, 1000];
        _unit addAction [
            "Open parachute",
            {
                _this params ["_target", "", "_id"];

                private _parachute = createVehicle ["Steerable_Parachute_F", [(getPos _target) select 0, (getPos _target) select 1, ((getPos _target )select 2) + 1], [], 0, "NONE"];
                _target moveInDriver _parachute;
                _target removeAction _id;
            }
        ];
        openMap false;

    } else {
        private _dist = _pos distance2D derp_paraPos;

        if (_dist > _radius) exitWith {hint "Select position within the marked area."};
        if ((leader _unit distance2D derp_paraPos) > _radius) exitWith {hint "your leader isn't near the AO"};
        if (leader _unit getVariable ["derp_revive_downed", false] || {!alive leader _unit}) exitWith {hint "Your leader is downed or dead"};

        if ({_x getUnitTrait "derp_pilot"}count allPlayers > 0) then {
            if ({side ((crew _x) select 0) == playerSide && {alive ((crew _x ) select 0)} && {speed _x > 10}} count (derp_paraPos nearEntities ["Helicopter", _radius]) == 0) then {
                hint "No helicopter near the AO";
                breakOut "main";
            };
        };

        _pos = getPos leader _unit;
        _unit setPos [_pos select 0, _pos select 1, 1000];
        _unit addAction [
            "Open parachute",
            {
                _this params ["_target", "", "_id"];

                private _parachute = createVehicle ["Steerable_Parachute_F", [(getPos _target) select 0, (getPos _target) select 1, ((getPos _target )select 2) + 1], [], 0, "NONE"];
                _target moveInDriver _parachute;
                _target removeAction _id;
            }
        ];
        openMap false;

        hint "We're dropping you near your leader.";
    };
}, [_unit, _radius]] call BIS_fnc_addStackedEventHandler;

[{
    params ["_args", "_pfhID"];
    _args params ["_markerName"];

    if (!missionInProgress) then {
        deleteMarkerLocal _markerName;
        ["derp_paradrop_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
        openMap false;
        hint "The AO changed";
        _pfhID call derp_fnc_removePerFrameHandler;
    };

    if !(visibleMap) then {
        deleteMarkerLocal _markerName;
        ["derp_paradrop_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
        _pfhID call derp_fnc_removePerFrameHandler;
    };
}, 0, [_markerName]] call derp_fnc_addPerFrameHandler;
