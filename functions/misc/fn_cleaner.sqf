/*
* Author: alganthe
* Corpse / wreck cleaner
*
* Arguments:
* None
*
* Return Value:
* Nothing
*/
[{
    params ["_args", "_pfhID"];

    //-------------------------------Groups
    // Remove already null groups
    {
        derp_cleaner_groupArray deleteAt (derp_cleaner_groupArray find _x);
    } foreach (derp_cleaner_groupArray select {isNull (_x select 0)});

    // Remove non empty groups from the array.
    {
        derp_cleaner_groupArray deleteAt (derp_cleaner_groupArray find _x);
    } foreach (derp_cleaner_groupArray select {count (units (_x select 0)) > 0});

    // Check the rest
    {
        deleteGroup (_x select 0);
        derp_cleaner_groupArray deleteAt (derp_cleaner_groupArray find _x);
    } foreach (derp_cleaner_groupArray select {time >= (_x select 1)});

    // Add empty groups
    private _groupCompareArray = derp_cleaner_groupArray apply {_x select 0};
    private _groupArray = allGroups select {count (units _x) == 0 && {!(_x in _groupCompareArray)}};
    _groupArray = _groupArray apply {[_x, time + 60]};
    derp_cleaner_groupArray append _groupArray;

    //-------------------------------Bodies and wrecks
    // Remove already deleted bodies / wrecks
    {
        derp_cleaner_bodyArray deleteAt (derp_cleaner_bodyArray find _x);
    } foreach (derp_cleaner_bodyArray select {isNull (_x select 0)});

    // Remove bodies / wrecks
    {
        deleteVehicle (_x select 0);
        derp_cleaner_bodyArray deleteAt (derp_cleaner_bodyArray find _x);
    } foreach (derp_cleaner_bodyArray select {time >= (_x select 1)});

    // Add new bodies / wrecks
    private _bodyCompareArray = derp_cleaner_bodyArray apply {_x select 0};
    private _bodyArray = allDead select {!(_x in _bodyCompareArray)};
    _bodyArray = _bodyArray apply {[_x, time + 300]};
    derp_cleaner_bodyArray append _bodyArray;

}, 20, []] call derp_fnc_addPerFrameHandler;
