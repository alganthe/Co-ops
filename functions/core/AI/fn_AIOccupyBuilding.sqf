/*
* Author: alganthe
* Handles placing the AI into houses
*
* Arguments:
* 0: The building(s) nearest this position are used <POSITION>
* 1: Limit the building search to those type of building <ARRAY>
* 2: Units that will be garrisoned <ARRAY>
* 3: Radius to fill building(s) -1 for nearest only <SCALAR> default: -1
* 4: True to fill building(s) evenly, false for one by one <BOOL> default: false
* 5: True to fill building(s) from top to bottom <BOOL> default: false

* Return Value:
* Array of units not garrisoned
*
* Example:
* [position, nil, [unit1, unit2, unit3, unitN], 200, false, false] call derp_fnc_AIOccupyBuilding
*/

params ["_startingPos", ["_buildingTypes", ["house"]], "_unitsArray", ["_fillingRadius", -1], ["_evenlyFill", false], ["_topDownFilling", false]];

if (_startingPos isEqualTo [0,0,0]) exitWith {
    player sideChat str "AIOccupyBuilding Error : Invalid position given.";
    diag_log "AIOccupyBuilding Error : Invalid position given.";
};

if (count _unitsArray == 0 || {isNull (_unitsArray select 0)}) exitWith {
    player sideChat str "AIOccupyBuilding Error : No units provided.";
    diag_log "AIOccupyBuilding Error : No units provided.";
};

private _buildings = [];

_arrayShuffle = {
    private "_cnt";
    _cnt = count _this;
    for "_i" from 1 to _cnt do {
        _this pushBack (_this deleteAt floor random _cnt);
    };
    _this
};

if (_fillingRadius == -1) then {
    _buildings = nearestObjects [_startingPos, _buildingTypes, 50];
} else {
    _buildings = nearestObjects [_startingPos, _buildingTypes, _fillingRadius];
    _buildings = _buildings call _arrayShuffle;
};

if (count _buildings == 0) exitWith {
    player sideChat str "AIOccupyBuilding Error : No building found.";
    diag_log "AIOccupyBuilding Error : No building found.";
};

private _buildingsIndexes = [];
private _evenFillIndexes = [];

if (_topDownFilling) then {
    {
        _buildingPos = _x buildingPos -1;

        {
            reverse _x;
        } foreach _buildingPos;

        _buildingPos sort false;

        {
            reverse _x;
        } foreach _buildingPos;

        _buildingsIndexes pushback _buildingPos;
    } foreach _buildings;
} else {
    {
        _buildingsIndexes pushback (_x buildingPos -1);
    } foreach _buildings;
};

private _indexCount = 0;
{
    _cnt = count _x;

    if (_cnt == 0) then {
        _buildingsIndexes deleteAt (_buildingsIndexes find _x);
    };
    _indexCount = _indexCount + _cnt;
} foreach _buildingsIndexes;
_evenFillIndexes = _buildingsIndexes;

private _leftOverAICount = (count _unitsArray) - _indexCount;

if (_leftOverAINumber > 0) then {
    diag_log "AIOccupyBuilding Warning: Not enough spots to place all units";
};

While {count _unitsArray > 0} do {
    scopeName "Main";

    for "_i" from 0 to (count _unitsArray) do {
        scopeName "loop";
        private _unit = _unitsArray select 0;

        if (_evenlyFill) then {

            _buildingsPositions = _buildingsIndexes select 0;

            if (count _buildingsPositions == 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                breakTo "loop";
            };

            _buildingPos = _buildingsPositions select 0;

            if (count (_buildingPos nearObjects ["CAManBase", 2]) == 0) then {
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";

                _unit setPos _buildingPos;

                doStop _unit;
                commandStop _unit;

                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                _buildingsIndexes pushback (_buildingsPositions - _buildingPos);
            } else {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                _buildingsIndexes pushback (_buildingsPositions - _buildingPos);
                breakTo "loop";
            };
        } else {
            _buildingsPositions = selectRandom _buildingsIndexes;

            if (count _buildingsPositions == 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                breakTo "loop";
            };

            private "_buildingPos";
            if (_topDownFilling) then {
                _buildingPos = _buildingsPositions select 0;
            } else {
                _buildingPos = selectRandom _buildingsPositions;
            };

            if (count (_buildingPos nearObjects ["CAManBase", 2]) == 0) then {
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";

                _unit setPos _buildingPos;

                doStop _unit;
                commandStop _unit;

                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
            } else {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
                breakTo "loop";
            };
        };
    };

    if (count _unitsArray > 0) then {

        {
            _cnt = count _x;

            if (_cnt == 0) then {
                _evenFillIndexes deleteAt (_evenFillIndexes find _x);
            } else {
                {
                    if (count (_x nearObjects ["CAManBase", 2]) == 0) then {
                        _evenFillIndexes deleteAt (_evenFillIndexes find _x);
                    };
                } foreach _x
            };
        } foreach _evenFillIndexes;

        if (count _evenFillIndexes == 0) then {
            breakOut "Main";
        } else {
            _buildingsIndexes = _evenFillIndexes;
        };
    };
};

_unitsArray
