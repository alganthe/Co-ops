/*
 * Author: alganthe
 * Set time of the day
 *
 * Arguments:
 * None: this is called via mission parameters and shouldn't be called by anything else.
 *
 * Return Value:
 * nothing
 */

private ["_hour","_date"];
_hour = "Daytime" call BIS_fnc_getParamValue;

_date = date;
_date set [3,_hour];
_date set [4,0];
[_date] call bis_fnc_setDate;
