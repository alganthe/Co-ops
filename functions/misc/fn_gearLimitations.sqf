#include "..\..\defines.hpp"
/*
* Author: alganthe
* Enforce gear restriction, check and remove whatever need to be removed from the unit's inventory.
*
* Arguments:
* 0: unit to check <OBJECT>
* 1: Mode to run in, 0: Called from arsenal / inventoryClosed EH 1: Called from take EH.
* 2: Item <OBJECT> (OPTIONNAL)
* 3: Container the item was taken from <CONTAINER>
*
* Return Value:
* Nothing
*/
params ["_unit", ["_mode", 0], ["_item", objNull], ["_container", objNull]];

private _unitClass = typeof _unit;

private _restrictedItems = [];
_restrictedItems pushBack GearLimitationMarksman;
_restrictedItems pushBack GearLimitationAT;
_restrictedItems pushBack GearLimitationSniper;
_restrictedItems pushBack GearLimitationMMG;
_restrictedItems pushBack GearLimitationUAVOperator;
_restrictedItems pushBack GearLimitationGrenadier;
_restrictedItems pushBack [{_unit getUnitTrait 'gud'}, (ArsenalBlacklistedItems + ArsenalBlacklistedUniforms + ArsenalBlacklistedHelmets + ArsenalBlacklistedBackpacks + ArsenalBlacklistedVests), "This is blacklisted"];

private _assignedItems = assignedItems _unit;
private _weapons = [];
_weapons pushBack (primaryWeapon _unit);
_weapons pushBack (secondaryWeapon _unit);
{_weapons pushBack _x} foreach (primaryWeaponItems _unit);

private _items = [];
_items = (_items + (uniformItems _unit) + (vestItems _unit) + (backpackItems _unit) + _assignedItems + _weapons + [uniform _unit] + [vest _unit] + [backpack _unit] + [headgear _unit]);
{_items pushBack _x} foreach _primaryWeaponItems;

_ITEM_MACRO_assignedItem = {
    params ["_unit", "_item", "_testedClass", "_container"];
    _unit unlinkItem _item;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_weapon = {
    params ["_unit", "_item", "_testedClass", "_container"];
    _unit removeWeapon _item;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_weaponItem = {
    params ["_unit", "_item", "_testedClass", "_container"];
    _unit removePrimaryWeaponItem _item;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_item = {
    params ["_unit", "_item", "_testedClass", "_container"];
    _unit removeItem _item;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_helmet = {
    params ["_unit", "_item", "_testedClass", "_container"];
    removeHeadgear _unit;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_backpack = {
    params ["_unit", "_item", "_testedClass", "_container"];
    removeBackpack _unit;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_uniform = {
    params ["_unit", "_item", "_testedClass", "_container"];
    removeUniform _unit;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

_ITEM_MACRO_vest = {
    params ["_unit", "_item", "_testedClass", "_container"];
    removeVest _unit;
    systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _item >> "displayName"), _testedClass];

    if (_mode == 1) then {
        _container addItemCargoGlobal [_item, 1];
    };
};

{
    _x params ["_classCode", "_testedArray", "_testedClass"];

    if !(call _classCode) then {
        {
            if (_x in _testedArray) then {
                if (_x in _assignedItems) then {
                    [_unit, _x, _testedClass, _container] call _ITEM_MACRO_assignedItem;
                } else {
                    if (_x in _weapons) then {
                        if ((_unit getUnitTrait "derp_sniper") && {_testedClass == "Marksman"}) then {
                        } else {
                            if (_x == (primaryWeapon _unit) || {_x == (secondaryWeapon _unit)}) then {
                                [_unit, _x, _testedClass, _container] call _ITEM_MACRO_weapon;
                            } else {
                                if (_x in (primaryWeaponItems _unit)) then {
                                    [_unit, _x, _testedClass, _container] call _ITEM_MACRO_weaponItem;
                                };
                            };
                        };
                    } else {
                        if (_x == headgear _unit) then {
                            [_unit, _x, _testedClass, _container] call _ITEM_MACRO_helmet;
                        } else {
                            if (_x == backpack _unit) then {
                                [_unit, _x, _testedClass, _container] call _ITEM_MACRO_backpack;
                            } else {
                                if (_x == uniform _unit) then {
                                    [_unit, _x, _testedClass, _container] call _ITEM_MACRO_uniform;
                                } else {
                                    if (_x == vest _unit) then {
                                        [_unit, _x, _testedClass, _container] call _ITEM_MACRO_vest;
                                    } else {
                                        [_unit, _x, _testedClass, _container] call _ITEM_MACRO_item;
                                    };
                                };
                            };
                        };
                    };
                };
            };
        } foreach _items;
    };
} foreach _restrictedItems;
