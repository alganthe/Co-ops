/*
 * Author: ACE3 team
 * Ported by: alganthe
 *
 * Initialize required vars for the waitAndExec and execNextFrame PFHs, compile necessary funcs and start the main PFH
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Public: No
 */
derp_waitAndExecArray = [];
derp_nextFrameNo = diag_frameno;
derp_nextFrameBufferA = [];
derp_nextFrameBufferB = [];

derp_time = diag_tickTime;
derp_realTime = diag_tickTime;
derp_virtualTime = diag_tickTime;
derp_diagTime = diag_tickTime;
derp_gameTime = time;
derp_pausedTime = 0;
derp_virtualPausedTime = 0;

derp_fnc_timePFH = compile preprocessFileLineNumbers "functions\core\Ported_funcs\timePFH.sqf";

[derp_fnc_timePFH, 0, []] call CBA_fnc_addPerFrameHandler;

call compile preprocessFileLineNumbers "functions\core\Ported_funcs\mainPFH.sqf";
derp_fnc_waitAndExec = compile preprocessFileLineNumbers "functions\core\Ported_funcs\waitAndExec.sqf";
