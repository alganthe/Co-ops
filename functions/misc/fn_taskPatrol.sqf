params [["_AOPos", []], ["_radius", 200], [ "_group", objNull], ["_wpAmount", 3], ["_mathsRHard", ""]];

if !({typeName _x isEqualTo "SCALAR"} count _AOPos == 3) exitWith {systemChat "derp_taskPatrol: Wrong position format provided"};
if !(typeName _group isEqualTo "GROUP") exitWith {systemChat "derp_taskPatrol: no group provided "};
if (_mathsRHard isEqualTo "") exitWith {systemChat "derp_taskPatrol: no arithmetic operation provided"};

_group setBehaviour "SAFE";

// Random waypoints
for "_i" from 0 to _wpAmount do {
    private _pos = ((selectBestPlaces [_AOPos, _radius, _mathsRHard, 60, 1]) select 0) select 0;
    private _wp = _group addWaypoint [_pos, 0];
    _wp setWaypointType "MOVE";
    _wp setWaypointCompletionRadius 20;

    if (_i == 0) then {
        _wp setWaypointSpeed "LIMITED";
        _wp setWaypointFormation "STAG COLUMN";
    };
};

//Cycle back to the starting pos
private _wp = _group addWaypoint [getPos ((units _group) select 0), 0];
_wp setWaypointType "CYCLE";
_wp setWaypointCompletionRadius 20;
