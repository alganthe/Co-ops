/*
* Author: alganthe
* Set the mission parameter defined skill values for an array of units.
*
* Arguments:
* 0: Array of units to change <ARRAY>
*
* Return Value:
* NOTHING
*/
params ["_AIArray"];

{
    _x setSkill ["aimingAccuracy", (PARAM_AIAimingAccuracy / 10)];
    _x setSkill ["aimingShake", (PARAM_AIAimingShake / 10)];
    _x setSkill ["aimingSpeed", (PARAM_AIAimingSpeed / 10)];
    _x setSkill ["endurance", (PARAM_AIEndurance / 10)];
    _x setSkill ["spotDistance", (PARAM_AISpotingDistance / 10)];
    _x setSkill ["spotTime", (PARAM_AISpottingSpeed / 10)];
    _x setSkill ["courage", (PARAM_AICourage / 10)];
    _x setSkill ["reloadSpeed", (PARAM_AIReloadSpeed / 10)];
    _x setSkill ["commanding", (PARAM_AICommandingSkill / 10)];
    _x setSkill ["general", (PARAM_AIGeneralSkill / 10)];
} foreach _AIArray;
