/*
* Author: alganthe
* Search for CfgWeapons and CfgGlasses entries with scope = 2
*
* Arguments:
* Nothing
*
* Return Value:
* Array of strings !!! WARNING VERY LONG ARRAYS !!! <ARRAY>
*
* Example:
* copyToClipboard ([true] call derp_fnc_findItemList);
*/
private _returnArray = [];

private _cfgArray = "getNumber (_x >> 'scope') >= 2" configClasses (configFile >> "CfgWeapons");
{_returnArray pushBack (configName _x)} forEach _cfgArray;

_cfgArray = "getNumber (_x >> 'scope') >= 2" configClasses (configFile >> "CfgGlasses");
{_returnArray pushBack (configName _x)} forEach _cfgArray;

_cfgArray = "(901 in (getArray (_x >> 'allowedSlots')))" configClasses (configFile >> "CfgVehicles");
{_returnArray pushBack (configName _x)} forEach _cfgArray;

_returnArray
