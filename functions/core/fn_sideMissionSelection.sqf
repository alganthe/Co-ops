/*
* Author: alganthe
* Side mission selector.
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
*
* Return Value:
* Nothing
*/
params ["_AOPos"];

derp_sideMissionInProgress = true;

private _sideMissionArray = [
derp_fnc_intelRetrievalSM,
derp_fnc_officerMurderSM,
derp_fnc_truckRetrievalSM
];

_nearComTowers = nearestObjects [_AOPos, ["Land_Communication_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F"], PARAM_AOSize * 1.5];

if ({alive _x} count _nearComTowers > 0) then {
    [_AOPos, _nearComTowers] call derp_fnc_comTowerSM;

} else {
    [_AOPos] call (selectRandom _sideMissionArray);
};
