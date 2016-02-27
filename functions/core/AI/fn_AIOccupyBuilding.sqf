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
    _buildings = nearestObjects [_startingPos, _buildingTypes, 30];
} else {
    _buildings = nearestObjects [_startingPos, _buildingTypes, _fillingRadius];
    _buildings = _buildings call _arrayShuffle;
};

if (count _buildings == 0) exitWith {
    player sideChat str "AIOccupyBuilding Error : No building found.";
    diag_log "AIOccupyBuilding Error : No building found.";
};

private _buildingsIndexes = [];
private _garrisonedUnits = [];

if (_topDownFilling) then {
    {
        _buildingsIndexes pushback (reverse (_x buildingPos -1));
    } foreach _buildings;
} else {
    {
        _buildingsIndexes pushback (_x buildingPos -1);
    } foreach _buildings;
};

While {count _unitsArray > 0} do {

    if (_evenlyFill) then {
        {
            _buildingsPositions = _buildingsIndexes select 0;
            diag_log _buildingsPositions;

            if (count _buildingsPositions == 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);

            } else {
                _buildingPos = selectRandom _buildingsPositions;
                diag_log _buildingPos;

                if (count (_buildingPos nearObjects ["Man", 4]) == 0) then {
                    doStop _x;
                    commandStop _x;
                    _x disableAI "FSM";
                    _x disableAI "AUTOCOMBAT";

                    _x setPos _buildingPos;

                    _unitsArray deleteAt (_unitsArray find _x);
                    _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
                };
            };
        } foreach _unitsArray;
    } else {
        {
            _buildingsPositions = (selectRandom _buildingsIndexes);
            diag_log _buildingsPositions;

            if (count _buildingsPositions == 0) then {
                _buildingsIndexes deleteAt (_buildingsIndexes find _buildingsPositions);

            } else {
                _buildingPos = selectRandom _buildingsPositions;
                diag_log _buildingPos;

                if (count (_buildingPos nearObjects ["Man", 4]) == 0) then {
                    doStop _x;
                    commandStop _x;
                    _x disableAI "FSM";
                    _x disableAI "AUTOCOMBAT";

                    _x setPos _buildingPos;

                    _unitsArray deleteAt (_unitsArray find _x);
                    _buildingsIndexes deleteAt (_buildingsIndexes find _buildingPos);
                };
            };
        } foreach _unitsArray;
    };
    if (count _buildingsIndexes == 0) exitWith {};
};

_unitsArray
