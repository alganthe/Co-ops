params ["_AOPos"];

derp_sideMissionInProgress = true;

private _sideMissionArray = [
derp_fnc_intelRetrievalSM,
derp_fnc_officerMurderSM,
derp_fnc_truckRetrievalSM
];

_nearComTowers = nearestObjects [_AOPos, ["Land_Communication_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F"], PARAM_AOSize * 1.5];
diag_log format ["towers: %1", _nearComTowers];

if (count _nearComTowers > 0) then {
    [_AOPos, _nearComTowers] call derp_fnc_comTowerSM;
    diag_log format ["towers stuff being called: %1", _nearComTowers];

} else {
    [_AOPos] call (selectRandom _sideMissionArray);
};
