/*
* Author: jaynus
* PFEH to set all Ace Time Variables
*
* Arguments:
* Nothing
*
* Return Value:
* Nothing
*/
private _lastTickTime = derp_diagTime;
private _lastGameTime = derp_gameTime;

derp_gameTime = time;
derp_diagTime = diag_tickTime;

private _delta = derp_diagTime - _lastTickTime;

if (derp_gameTime <= _lastGameTime) then {
    derp_paused = true;
    // Game is paused or not running
    derp_pausedTime = derp_pausedTime + _delta;
    derp_virtualPausedTime = derp_pausedTime + (_delta * accTime);
} else {
    derp_paused = false;
    // Time is updating
    derp_realTime = derp_realTime + _delta;
    derp_virtualTime = derp_virtualTime + (_delta * accTime);
    derp_time = derp_virtualTime;
};
