/*
* Author: esteldunedain
* Executes a code once with a given game time delay, using a PFH
*
* Arguments:
* 0: Code to execute <CODE>
* 1: Parameters to run the code with <ARRAY>
* 2: Delay in seconds before executing the code <NUMBER>
*
* Return Value:
* Nothing
*
* Example:
* [{(_this select 0) setVelocity [0,0,200];}, [player], 10] call derp_fnc_waitAndExec
*/
params ["_func", "_params", "_delay"];

derp_waitAndExecArray pushBack [derp_time + _delay, _func, _params];
derp_waitAndExecArray sort true;
