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
_this params ["_unit", "_radius"];

_marker = createMarkerLocal [format["max_range_%1", name _unit], derp_paraPos];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_radius, _radius];
_marker setMarkerBrushLocal "SolidBorder";
_marker setMarkerColorLocal "ColorBlue";
_marker setMarkerAlphaLocal 0.5;

derp_jumped = false;
openMap true;

[_unit, _radius] onMapSingleClick {
    _dist = _pos distance2D derp_paraPos;
    if(_dist > _this select 1) then {
        hint "Select position within the marked area.";
    } else {
        _parachute = createVehicle ["Steerable_Parachute_F", _pos, [], 20, "FLY"];
        (_this select 0) moveInDriver _parachute;
        derp_jumped = true;
        openMap false;
    };
    true
};

waitUntil {derp_jumped || !visiblemap};

if (!visibleMap) then {
    hint "Parajump canceled.";
};

onMapSingleClick "";
deleteMarkerLocal format["max_range_%1", name _unit];
