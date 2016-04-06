if (derp_successfulSMs != 0 && {derp_successfulSMs == PARAM_smRewardAfter}) then {
    _smRewardList = [
        ["B_Heli_Light_01_armed_F", 2],
        ["B_Heli_Attack_01_F", 2],
        ["I_Heli_light_03_F", 2],
        ["O_Heli_Attack_02_black_F", 2],
        ["O_Heli_Transport_04_covered_F", 3],
        ["B_MBT_01_TUSK_F", 5],
        ["B_MBT_01_cannon_F", 5],
        ["I_Plane_Fighter_03_AA_F", 2],
        ["B_APC_Tracked_01_AA_F", 5],
        ["I_APC_tracked_03_cannon_F", 5],
        ["I_APC_Wheeled_03_cannon_F", 5],
        ["I_MBT_03_cannon_F", 5]
    ];

    private _selectRandomArray = [];

    _smRewardList apply {
        _x params ["_element" , "_amount"];

        for "_i" from 1 to _amount do {
            _selectRandomArray pushback _element;
        };
    };

    _smRewardList call derp_fnc_arrayShuffle;

    _reward = selectRandom _selectRandomArray;

    if (_reward isKindOf "Helicopter") then {
        _heloReward = createVehicle [_reward, sm_heliRewardPad, [], 0, "NONE"];
        _heloReward setDir (getDir sm_heliRewardPad);
        _heloReward call derp_fnc_vehicleSetup;
    };

    if (_reward isKindOf "Plane") then {
        _planeReward = createVehicle [_reward, getMarkerPos "smReward_Plane", [], 0, "NONE"];
        _planeReward setDir (getDir smReward_Plane_hangar);
        _planeReward call derp_fnc_vehicleSetup;
    };

    if (_reward isKindOf "LandVehicle") then {
        _landReward = createVehicle [_reward, getMarkerPos "smReward_Ground", [], 20, "NONE"];
        _landReward setDir (random 360);
        _landReward call derp_fnc_vehicleSetup;
    };

    derp_successfulSMs = 0;

    format ["The HQ has delivered a reward: <br/> %1", getText (configFile >> "CfgVehicles" >> _reward >> "displayName")] remoteExec ["derp_fnc_globalHint_Handler", -2];
};
