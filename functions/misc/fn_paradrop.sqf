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

_markerName = ["max_range_", name _unit] joinString "";
_marker = createMarkerLocal [_markerName, derp_paraPos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_radius, _radius];
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerColorLocal "ColorBlue";
_marker setMarkerAlphaLocal 0.5;

openMap true;

["derp_paradrop_mapclick", "onMapSingleClick", {
    _this params ["_unit", "_radius"];

    _dist = _pos distance2D derp_paraPos;
    if (_dist > _radius) then {
        hint "Select position within the marked area.";

    } else {
        _parachute = createVehicle ["Steerable_Parachute_F", [_pos select 0, _pos select 1, 1000], [], 20, "FLY"];
        _unit moveInDriver _parachute;
        openMap false;

    };
}, [_unit, _radius]] call BIS_fnc_addStackedEventHandler;

["derp_paradrop_visibleMap", "onEachFrame", {
    if !(visibleMap) then {
        deleteMarkerLocal (_this select 0);
        ["derp_paradrop_mapclick", "onMapSingleClick"] call BIS_fnc_removeStackedEventHandler;
        ["derp_paradrop_visibleMap", "onEachFrame"] call BIS_fnc_removeStackedEventHandler;

    };
}, [_markerName]]  call BIS_fnc_addStackedEventHandler;
