/*
* Author: alganthe
* Handles placing the AI into houses
*
* Arguments:
* 0: The building(s) nearest this position are used <POSITION>
* 1: Limit the building search to those type of building <ARRAY>
* 2: Units that will be garrisoned <ARRAY>
* 3: Radius to fill building(s) -1 for nearest only <SCALAR> default: -1
* 4: 0: even filling, 1: building by building, 2: random filling <SCALAR> default: 0
* 5: True to fill building(s) from top to bottom <BOOL> default: false

* Return Value:
* Array of units not garrisoned
*
* Example:
* [position, nil, [unit1, unit2, unit3, unitN], 200, false, false] call derp_fnc_AIOccupyBuilding
*/

params ["_startingPos", ["_buildingTypes", ["house"]], "_unitsArray", ["_fillingRadius", -1], ["_fillingType", 0], ["_topDownFilling", false]];

if (_startingPos isEqualTo [0,0,0]) exitWith {
    player sideChat str "AIOccupyBuilding Error : Invalid position given.";
    diag_log "AIOccupyBuilding Error : Invalid position given.";
};

if (count _unitsArray == 0 || {isNull (_unitsArray select 0)}) exitWith {
    player sideChat str "AIOccupyBuilding Error : No units provided.";
    diag_log "AIOccupyBuilding Error : No units provided.";
};

private _buildings = [];

if (_fillingRadius == -1) then {
    _buildings = nearestObjects [_startingPos, _buildingTypes, 50];
} else {
    _buildings = nearestObjects [_startingPos, _buildingTypes, _fillingRadius];
    _buildings = _buildings call derp_fnc_arrayShuffle;
};

if (count _buildings == 0) exitWith {
    player sideChat str "AIOccupyBuilding Error : No building found.";
    diag_log "AIOccupyBuilding Error : No building found.";
};

private _buildingsIndexes = [];

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

private _leftOverAICount = (count _unitsArray) - _indexCount;
if (_leftOverAICount > 0) then {
    diag_log "AIOccupyBuilding Warning: Not enough spots to place all units";
};

While {count _unitsArray > 0} do {
    scopeName "Main";

    for "_i" from 0 to (count _unitsArray) do {
        scopeName "loop";
        private _unit = _unitsArray select 0;

        switch (_fillingType) do {
            case 0: {
                if (count _buildingsIndexes == 0) then {
                    breakOut "Main";
                };

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
                    _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                    _buildingsIndexes pushback (_buildingsPositions - _buildingPos);
                } else {
                    _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);
                    _buildingsIndexes pushback (_buildingsPositions - _buildingPos);
                    breakTo "loop";
                };
            };

            case 1: {
                if (count _buildingsIndexes == 0) then {
                    breakOut "Main";
                };

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
                    _buildingsIndexes = _buildingsIndexes apply {_x select {!(_x isEqualTo _buildingPos)}};
                } else {
                    _buildingsIndexes = _buildingsIndexes apply {_x select {!(_x isEqualTo _buildingPos)}};
                    breakTo "loop";
                };
            };

            case 2: {
                if (count _buildingsIndexes == 0) then {
                    breakOut "Main";
                };

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
                    _buildingsIndexes = _buildingsIndexes apply {_x select {!(_x isEqualTo _buildingPos)}};
                } else {
                    _buildingsIndexes = _buildingsIndexes apply {_x select {!(_x isEqualTo _buildingPos)}};
                    breakTo "loop";
                };
            };
        };
    };
};

_unitsArray
