/*
* Author: alganthe
* Side mission selector.
*
* Arguments:
* 0: Position of the AO marker <ARRAY>
* 1: ID of the main mission <STRING>
*
* Return Value:
* Nothing
*/
params ["_AOPos", "_missionID"];

derp_sideMissionInProgress = true;

private _sideMissionArray = [
    derp_fnc_officerMurderSM,
    derp_fnc_truckRetrievalSM,
    derp_fnc_cachesSM,
    derp_fnc_uavDownedSM,
    derp_fnc_specOpsSM,
    derp_fnc_droppedCargoSM,
    derp_fnc_comTowerSM
];

[_AOPos, _missionID] call (selectRandom _sideMissionArray);
