params [["_pos", [0, 0, 0]], ["_radius", 0], ["_mathsRHard", ""]];

if (_pos isEqualTo [] || {_pos isEqualTo [0, 0, 0]}) exitWith {systemChat "randomPos: wrong position array type supplied"};

if (_radius < 20) exitWith {systemChat "randomPos: radius size too small"};

if (_mathsRHard isEqualTo "") exitWith {systemChat "randomPos: no arithmetic operation supplied"};

private _returnValue = selectBestPlaces [_pos, _radius, _mathsRHard, 60, 10];

(_returnValue select 0) select 0;
