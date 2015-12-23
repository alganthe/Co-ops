/*
 * Author: alganthe
 * Handles mission transitions
 *
 * Arguments:
 * 0: position of the previous mission <OBJECT>
 * 1: shape of the previous marker <STRING>
 * 2: size of the previous marker <ARRAY>
 *
 * Return Value:
 * nothing
 */
params ["_markerPos","_markerShape"];

_bluforCheck = createTrigger ["EmptyDetector",_markerPos,false];
_bluforCheck setTriggerArea [PARAM_AOSize,PARAM_AOSize,0,false];
_bluforCheck setTriggerActivation ["WEST","NOT PRESENT",false];
_bluforCheck setTriggerStatements ["this","westNotPresent = true;",""];

_markerTransition1 = createMarker ["missionTransition1_mrk",_markerPos];
"missionTransition1_mrk" setMarkerShape _markerShape;
"missionTransition1_mrk" setMarkerSize [PARAM_AOSize,PARAM_AOSize];
"missionTransition1_mrk" setMarkerBrush "Border";
"missionTransition1_mrk" setMarkerColor "ColorGreen";

_markerTransition2 = createMarker ["missionTransition2_mrk", _markerPos];
"missionTransition2_mrk" setMarkerShape "ICON";
"missionTransition2_mrk" setMarkerType "mil_dot";
"missionTransition2_mrk" setMarkerText "Leave the previous AO area";

_TriggerPFH = {
    if (!isNil "westNotPresent") then {

        deleteMarker "missionTransition1_mrk";
        deleteMarker "missionTransition2_mrk";

        westNotPresent = nil;

        [{[] call derp_fnc_missionSelection;}, [], 10] call derp_fnc_waitAndExec;
        [_this select 1] call CBA_fnc_removePerFrameHandler;
    };
};
[_TriggerPFH,10,[]] call CBA_fnc_addPerFrameHandler;
