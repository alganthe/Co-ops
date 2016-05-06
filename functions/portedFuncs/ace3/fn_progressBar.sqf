/*
* Author: commy2, Glowbal, PabstMirror
* Draw progress bar and execute given function if succesful.
* Finish/Failure/Conditional are all passed [_args, _elapsedTime, _totalTime, _errorCode]
*
* Arguments:
* 0: NUMBER - Total Time (in game "time" seconds)
* 1: ARRAY - Arguments, passed to condition, fail and finish
* 2: CODE - On Finish: Code called
* 3: CODE - On Failure: Code called
* 4: STRING - (Optional) Localized Title
* 5: CODE - (Optional) Code to check each frame
* 6: ARRAY - (Optional) Exceptions for checking EFUNC(common,canInteractWith)
*
* Return Value:
* Nothing
*
* Example:
* [5, [], {Hint "Finished!"}, {hint "Failure!"}, "My Title"] call ace_common_fnc_progressBar
*
* Public: Yes
*/
params ["_totalTime", "_args", "_onFinish", "_onFail", ["_localizedTitle", ""], ["_condition", {true}], ["_exceptions", []]];

//Open Dialog and set the title
closeDialog 0;
createDialog "derp_ProgressBar_Dialog";

(uiNamespace getVariable "derp_ctrlProgressBarTitle") ctrlSetText _localizedTitle;

//Adjust position based on user setting:
private _ctrlPos = ctrlPosition (uiNamespace getVariable "derp_ctrlProgressBarTitle");
_ctrlPos set [1, ((0 + 29) * ((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) + (safezoneY + (safezoneH - (((safezoneW / safezoneH) min 1.2) / 1.2))/2))];

(uiNamespace getVariable "derp_ctrlProgressBG") ctrlSetPosition _ctrlPos;
(uiNamespace getVariable "derp_ctrlProgressBG") ctrlCommit 0;
(uiNamespace getVariable "derp_ctrlProgressBar") ctrlSetPosition _ctrlPos;
(uiNamespace getVariable "derp_ctrlProgressBar") ctrlCommit 0;
(uiNamespace getVariable "derp_ctrlProgressBarTitle") ctrlSetPosition _ctrlPos;
(uiNamespace getVariable "derp_ctrlProgressBarTitle") ctrlCommit 0;

[{
    (_this select 0) params ["_args", "_onFinish", "_onFail", "_condition", "_startTime", "_totalTime", "_exceptions"];

    private _elapsedTime = derp_missionTime - _startTime;
    private _errorCode = -1;

    // this does not check: target fell unconscious, target died, target moved inside vehicle / left vehicle, target moved outside of players range, target moves at all.
    if (isNull (uiNamespace getVariable ["derp_ctrlProgressBar", controlNull])) then {
        _errorCode = 1;
    } else {
        if (!alive player) then {
            _errorCode = 2;
        } else {
            if !([_args, _elapsedTime, _totalTime, _errorCode] call _condition) then {
                _errorCode = 3;
            } else {
                if (_elapsedTime >= _totalTime) then {
                    _errorCode = 0;
                };
            };
        };
    };

    if (_errorCode != -1) then {
        //Error or Success, close dialog and remove PFEH

        //Only close dialog if it's the progressBar:
        if (!isNull (uiNamespace getVariable ["derp_ctrlProgressBar", controlNull])) then {
            closeDialog 0;
        };

        [_this select 1] call derp_fnc_removePerFrameHandler;

        if (_errorCode == 0) then {
            if (_onFinish isEqualType "") then {
                [_args, _elapsedTime, _totalTime, _errorCode] call compile _onFinish;
            } else {
                [_args, _elapsedTime, _totalTime, _errorCode] call _onFinish;
            };
        } else {
            if (_onFail isEqualType "") then {
                [_args, _elapsedTime, _totalTime, _errorCode] call compile _onFail;
            } else {
                [_args, _elapsedTime, _totalTime, _errorCode] call _onFail;
            };
        };
    } else {
        //Update Progress Bar (ratio of elepased:total)
        (uiNamespace getVariable "derp_ctrlProgressBar") progressSetPosition (_elapsedTime / _totalTime);
    };
}, 0, [_args, _onFinish, _onFail, _condition, derp_missionTime, _totalTime, _exceptions]] call derp_fnc_addPerFrameHandler;
