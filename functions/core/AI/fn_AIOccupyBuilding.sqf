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
* [position, nil, [unit1, unit2, unit3, unitN], 200, 1, false] call derp_fnc_AIOccupyBuilding
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

// Remove buildings without pos
{
    _buildingsIndexes deleteAt (_buildingsIndexes find _x);
} foreach (_buildingsIndexes select {count _x == 0});

private _cnt = 0;
{_cnt = _cnt + count _x} foreach _buildingsIndexes;
private _leftOverAICount = (count _unitsArray) - _cnt;
if (_leftOverAICount > 0) then {
    diag_log "AIOccupyBuilding Warning: Not enough spots to place all units";
};

switch (_fillingType) do {
    case 0: {
        scopeName "main";
        for "_i" from 0 to (count _unitsArray) do {
            if (count _buildingsIndexes == 0) exitWith {breakOut "main"};

            _building = _buildingsIndexes select 0;
            _pos = _building select 0;

            if ( count (_pos nearEntities ["CAManBase", 2]) > 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _pos);
            } else {
                _unit = _unitsArray select 0;
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";
                _unit forceSpeed 0;
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _building deleteAt 0;
                _buildingsIndexes pushbackUnique _building;
            };
        };
    };

    case 1: {
        scopeName "main";
        for "_i" from 0 to (count _unitsArray) do {
            if (count _buildingsIndexes == 0) exitWith {breakOut "main"};

            _pos = (_buildingsIndexes select 0) select 0;

            if ( count (_pos nearEntities ["CAManBase", 2]) > 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _pos);
            } else {
                _unit = _unitsArray select 0;
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";
                _unit forceSpeed 0;
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes deleteAt (_buildingsIndexes find _pos);
            };
        };
    };

    case 2: {
        scopeName "main";
        for "_i" from 0 to (count _unitsArray) do {
            if (count _buildingsIndexes == 0) exitWith {breakOut "main"};

            _pos = selectRandom (selectRandom _buildingsIndexes);

            if ( count (_pos nearEntities ["CAManBase", 2]) > 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _pos);
            } else {
                _unit = _unitsArray select 0;
                _unit disableAI "FSM";
                _unit disableAI "AUTOCOMBAT";
                _unit forceSpeed 0;
                _unit setPos _pos;
                _unitsArray deleteAt (_unitsArray find _unit);
                _buildingsIndexes deleteAt (_buildingsIndexes find _pos);
            };
        };
    };
};

_unitsArray
