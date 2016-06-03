/*
* Author: alganthe
* Filter the arsenal for a given box and add an unfucked arsenal action
*
* Arguments:
* 0: Array of objects <ARRAY>
* 1: filter <NUMBER 0: arsenal unavailable, 1: Arsenal available but filtered, 2: arsenal available unfiltered>
*
* Return Value:
* Nothing
*
* Example:
* [_this, 1] call derp_fnc_VA_filter;
*/
params ["_arsenalBoxes", "_filter"];

switch (_filter) do {

    case 0: {
        {
            [_x , [true], true] call BIS_fnc_removeVirtualItemCargo;
            [_x, [true], true] call BIS_fnc_removeVirtualWeaponCargo;
        } foreach _arsenalBoxes;
    };

    case 1: {
        {
            ["AmmoboxInit", [_x, true, {true}]] call BIS_fnc_arsenal;
            [_x, [true], true] call BIS_fnc_removeVirtualItemCargo;
            [_x, [true], true] call BIS_fnc_removeVirtualWeaponCargo;
            [_x, [true], true] call BIS_fnc_removeVirtualBackpackCargo;
        } foreach _arsenalBoxes;

        private _weaponsBlacklist = [
            //------------------------- Weapons with blacklisted scoeps
            "srifle_DMR_01_SOS_F",
            "srifle_EBR_SOS_F",
            "srifle_GM6_SOS_F",
            "srifle_GM6_LRPS_F",
            "srifle_LRR_SOS_F",
            "srifle_LRR_LRPS_F",
            "arifle_Katiba_GL_Nstalker_pointer_F",
            "arifle_MXC_SOS_point_snds_F",
            "arifle_MXM_SOS_pointer_F",
            "srifle_GM6_camo_SOS_F",
            "srifle_GM6_camo_LRPS_F",
            "srifle_LRR_camo_SOS_F",
            "srifle_LRR_camo_LRPS_F",
            "srifle_DMR_02_SOS_F",
            "srifle_DMR_03_SOS_F",
            "srifle_DMR_04_SOS_F",
            "srifle_DMR_04_NS_LP_F",
            "srifle_DMR_05_SOS_F"
        ];

        private _itemBlackList = [
            //------------------------- Optics
            "optic_Nightstalker",
            "optic_tws",
            "optic_tws_mg",

            //------------------------- UAV terminals
            "O_UavTerminal",
            "I_UavTerminal",

            //------------------------- Uniforms (vanilla)
            "U_O_CombatUniform_ocamo",
            "U_O_CombatUniform_oucamo",
            "U_O_OfficerUniform_ocamo",
            "U_O_SpecopsUniform_ocamo",
            "U_I_CombatUniform",
            "U_I_CombatUniform_shortsleeve",
            "U_I_OfficerUniform",
            "U_O_PilotCoveralls",
            "U_I_pilotCoveralls",
            "U_I_HeliPilotCoveralls",

            //------------------------- Ghilies
            "U_B_FullGhillie_ard",
            "U_B_FullGhillie_lsh",
            "U_B_FullGhillie_sard",
            "U_B_GhillieSuit",

            //------------------------- Wetsuits
            "U_O_Wetsuit",
            "U_I_Wetsuit",

            //------------------------- CIV clothes
            "U_C_Poloshirt_blue",
            "U_C_Poloshirt_burgundy",
            "U_C_Poloshirt_stripped",
            "U_C_Poloshirt_tricolour",
            "U_C_Poloshirt_salmon",
            "U_C_Poloshirt_redwhite",

            //------------------------- drivers
            "U_C_Driver_1_black",
            "U_C_Driver_1_blue",
            "U_C_Driver_2",
            "U_C_Driver_1",
            "U_C_Driver_1_green",
            "U_C_Driver_1_orange",
            "U_C_Driver_1_red",
            "U_C_Driver_3",
            "U_C_Driver_4",
            "U_C_Driver_1_white",
            "U_C_Driver_1_yellow",

            //------------------------- random
            "U_C_HunterBody_grn",
            "U_OrestesBody",
            "U_C_Journalist",
            "U_Marshal",
            "U_C_Scientist",
            "U_C_WorkerCoveralls",
            "U_C_Poor_1",
            "U_Competitor",
            "U_Rangemaster",
            "U_B_Protagonist_VR",
            "U_O_Protagonist_VR",
            "U_I_Protagonist_VR",

            //------------------------- Helmets
            "H_HelmetSpecO_blk",
            "H_HelmetSpecO_ocamo",
            "H_HelmetLeaderO_ocamo",
            "H_HelmetLeaderO_oucamo",
            "H_HelmetIA",
            "H_PilotHelmetFighter_O",
            "H_PilotHelmetFighter_I",
            "H_PilotHelmetHeli_O",
            "H_PilotHelmetHeli_I",
            "H_CrewHelmetHeli_O",
            "H_CrewHelmetHeli_I",
            "H_HelmetCrew_I",
            "H_HelmetCrew_O",
            "H_RacingHelmet_1_F",
            "H_RacingHelmet_2_F",
            "H_RacingHelmet_3_F",
            "H_RacingHelmet_4_F",
            "H_RacingHelmet_1_black_F",
            "H_RacingHelmet_1_blue_F",
            "H_RacingHelmet_1_green_F",
            "H_RacingHelmet_1_red_F",
            "H_RacingHelmet_1_white_F",
            "H_RacingHelmet_1_yellow_F",
            "H_RacingHelmet_1_orange_F",
            "H_Cap_marshal",
            "H_StrawHat",
            "H_StrawHat_dark",
            "H_Hat_blue",
            "H_Hat_brown",
            "H_Hat_camo",
            "H_Hat_grey",
            "H_Hat_checker",
            "H_Hat_tan",
            "H_MilCap_ocamo",
            "H_MilCap_dgtl",

            //------------------------- Glasses
            "G_Goggles_VR",
            "TRYK_H_ghillie_top_headless3glass",
            "G_Lady_Blue",
            "G_Spectacles",
            "G_Spectacles_Tinted",
            "G_I_Diving",
            "G_O_Diving",

            //------------------------- Vests
            "V_Press_F",
            "V_HarnessO_brn",
            "V_HarnessOGL_brn",
            "V_HarnessO_gry",
            "V_HarnessOGL_gry",
            "V_HarnessOSpec_brn",
            "V_HarnessOSpec_gry",
            "V_RebreatherIR",
            "V_RebreatherIA",
            "V_PlateCarrierIAGL_dgtl",
            "V_PlateCarrierIAGL_oli",
            "V_PlateCarrierIA1_dgtl",
            "V_PlateCarrierIA2_dgtl"
        ];

        private _backpackBlackList = [
            //------------------------- Backpacks
            "O_Mortar_01_weapon_F",
            "O_Mortar_01_support_F",
            "I_Mortar_01_weapon_F",
            "I_Mortar_01_support_F",

            //------------------------- GMG
            "B_GMG_01_A_weapon_F",
            "B_GMG_01_high_F",
            "B_GMG_01_high_weapon_F",
            "B_GMG_01_weapon_F",
            "O_GMG_01_A_weapon_F",
            "O_GMG_01_high_F",
            "O_GMG_01_high_weapon_F",
            "O_GMG_01_weapon_F",
            "I_GMG_01_A_weapon_F",
            "I_GMG_01_high_F",
            "I_GMG_01_high_weapon_F",
            "I_GMG_01_weapon_F",

            //------------------------- HMG
            "B_HMG_01_A_weapon_F",
            "B_HMG_01_high_weapon_F",
            "B_HMG_01_support_F",
            "B_HMG_01_support_high_F",
            "B_HMG_01_weapon_F",
            "O_HMG_01_A_weapon_F",
            "O_HMG_01_high_weapon_F",
            "O_HMG_01_support_F",
            "O_HMG_01_support_high_F",
            "O_HMG_01_weapon_F",
            "I_HMG_01_A_weapon_F",
            "I_HMG_01_high_weapon_F",
            "I_HMG_01_support_F",
            "I_HMG_01_support_high_F",
            "I_HMG_01_weapon_F",

            //------------------------- AA and AT statics
            "B_AA_01_weapon_F",
            "O_AA_01_weapon_F",
            "I_AA_01_weapon_F",
            "B_AT_01_weapon_F",
            "O_AT_01_weapon_F",
            "I_AT_01_weapon_F",

            //------------------------- Respawn backpacks
            "B_Respawn_Sleeping_bag_blue_F",
            "B_Respawn_Sleeping_bag_brown_F",
            "B_Respawn_Sleeping_bag_F",
            "B_Respawn_TentA_F",
            "B_Respawn_TentDome_F"
        ];

        private _availableItems = [] call derp_fnc_findItemList;

        _availableItems = _availableItems - _itemBlackList;
        _availableItems = _availableItems - _weaponsBlacklist;
        _availableItems = _availableItems - _backpackBlackList;

        {
            [_x, _availableItems, true] call BIS_fnc_addVirtualItemCargo;
            [_x, _availableItems, true] call BIS_fnc_addVirtualWeaponCargo;
            [_x, _availableItems, true] call BIS_fnc_addVirtualBackpackCargo;
        } foreach _arsenalBoxes;

        {
            _x removeAction (_x getVariable "bis_fnc_arsenal_action");
            _action = _x addaction [
            localize "STR_A3_Arsenal",

            {
                params ["_box", "_unit"];
                ["Open", [nil, _box, _unit]] call bis_fnc_arsenal;

                [_unit] spawn {
                    params ["_unit"];

                    uiSleep 2;
                    (uinamespace getvariable "bis_fnc_arsenal_display") displayAddEventHandler ["Unload", {
                        [player, 0] call derp_fnc_gearLimitations;
                    }];
                };
            },
            [],
            6,
            true,
            false,
            "",
            "
                _cargo = _target getvariable ['bis_addVirtualWeaponCargo_cargo',[[],[],[],[]]];
                if ({count _x > 0} count _cargo == 0) then {
                _target removeaction (_target getvariable ['bis_fnc_arsenal_action',-1]);
                _target setvariable ['bis_fnc_arsenal_action',nil];
                };
                _condition = _target getvariable ['bis_fnc_arsenal_condition',{true}];
                alive _target && {_target distance _this < 5} && {call _condition}
            "
            ];
            _x setvariable ["bis_fnc_arsenal_action", _action];
        } foreach _arsenalBoxes;
    };

    case 2: {
        {
            ["AmmoboxInit", [_x, true, {true}]] call BIS_fnc_arsenal;
        } foreach _arsenalBoxes;
    };
};
