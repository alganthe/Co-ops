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

    // Remove already deleted vehicles
    {
        derp_cleaner_bodyArray deleteAt (derp_cleaner_bodyArray find _x);
    } foreach (derp_cleaner_bodyArray select {isNull (_x select 0)});

    // Remove bodies / wrecks
    {
        deleteVehicle (_x select 0);
        derp_cleaner_bodyArray deleteAt (derp_cleaner_bodyArray find _x);
    } foreach (derp_cleaner_bodyArray select {time >= (_x select 1)});

    // Add new bodies
    private _array = allDead select {!(_x in derp_cleaner_bodyArray)};
    _array apply {_array set [(_array find _x), [_x, time + 300]]};
    derp_cleaner_bodyArray append _array;

}, 60, []] call derp_fnc_addPerFrameHandler;
