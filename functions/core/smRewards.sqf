#include "..\..\defines.hpp"
/*
* Author: alganthe
* Called only after a successful side mission, this gives a reward if the number of successfully completed SMs is equal to the mission param
*
* Arguments:
* None
*
* Return Value:
* Nothing
*/
if (derp_successfulSMs != 0 && {derp_successfulSMs == derp_PARAM_smRewardAfter}) then {
    private _smRewardList = [ SMRewards ];

    private _selectRandomArray = [];

    _smRewardList apply {
        _x params ["_element", "_amount"];

        for "_i" from 1 to _amount do {
            _selectRandomArray pushback _element;
        };
    };

    _smRewardList call derp_fnc_arrayShuffle;

    private _reward = selectRandom _selectRandomArray;
    private _rewardVehicle = "";

    if (_reward isKindOf "Helicopter") then {
        _rewardVehicle = createVehicle [_reward, getMarkerPos "smReward_Helo", [], 0, "NONE"];
        _rewardVehicle setDir (markerDir "smReward_Helo");
        _rewardVehicle call derp_vehicleHandler_fnc_vehicleSetup;
    } else {
        if (_reward isKindOf "Plane") then {
            _rewardVehicle = createVehicle [_reward, getMarkerPos "smReward_Plane", [], 0, "NONE"];
            _rewardVehicle setDir (markerDir "smReward_Plane");
            _rewardVehicle call derp_vehicleHandler_fnc_vehicleSetup;
        } else {
            if (_reward isKindOf "LandVehicle") then {
                _rewardVehicle = createVehicle [_reward, getMarkerPos "smReward_Ground", [], 20, "NONE"];
                _rewardVehicle setDir (random 360);
                _rewardVehicle call derp_vehicleHandler_fnc_vehicleSetup;
            };
        };
    };

    {_x addCuratorEditableObjects [[_rewardVehicle], false]} forEach allCurators;

    derp_successfulSMs = 0;

    format ["The HQ has delivered a reward: <br/> %1", getText (configFile >> "CfgVehicles" >> _reward >> "displayName")] remoteExec ["derp_fnc_globalHint_Handler", -2];
};
