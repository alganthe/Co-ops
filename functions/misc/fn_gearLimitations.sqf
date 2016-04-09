/*
* Author: alganthe
* Enforce gear restriction, check and remove whatever need to be removed from the unit's inventory.
*
* Arguments:
* 0: unit to check <OBJECT>
* 1: Mode to run in, 0: Called from arsenal / inventoryClosed EH 1: Called from take EH.
* 2: Item <OBJECT> (OPTIONNAL)
* 3: Container the item was taken from <CONTAINER>
*
* Return Value:
* Nothing
*
* Example:
*
*/
params ["_unit", ["_mode", 0], ["_item", objNull], ["_container", objNull]];

_unitClass = typeof _unit;

_marksmenRestricted = [["B_soldier_M_F", "B_spotter_F", "B_recon_M_F"], [
    //optics
    "optic_SOS", "optic_DMS", "optic_LRPS", "optic_AMS", "optic_AMS_khk", "optic_AMS_snd", "optic_KHS_blk", "optic_KHS_hex", "optic_KHS_old", "optic_KHS_tan",
    //guns
    "srifle_DMR_01_F", "srifle_DMR_01_ACO_F", "srifle_DMR_01_MRCO_F", "srifle_DMR_01_SOS_F", "srifle_DMR_01_DMS_F", "srifle_DMR_01_DMS_snds_F", " 	srifle_DMR_01_ARCO_F", "srifle_EBR_ACO_F", "srifle_EBR_MRCO_pointer_F", "srifle_EBR_ARCO_pointer_F", "srifle_EBR_SOS_F", "  	srifle_EBR_ARCO_pointer_snds_F", "srifle_EBR_DMS_F", "srifle_EBR_Hamr_pointer_F", "srifle_EBR_DMS_pointer_snds_F", "srifle_DMR_01_DMS_BI_F", "srifle_DMR_01_DMS_snds_BI_F", "srifle_EBR_MRCO_LP_BI_F", "srifle_DMR_03_F", "srifle_DMR_03_khaki_F", "srifle_DMR_03_tan_F", "srifle_DMR_03_multicam_F", "srifle_DMR_03_woodland_F", "srifle_DMR_03_spotter_F", "srifle_DMR_03_ACO_F", "srifle_DMR_03_MRCO_F", "srifle_DMR_03_SOS_F", "srifle_DMR_03_DMS_F", " 	srifle_DMR_03_tan_AMS_LP_F", "srifle_DMR_03_DMS_snds_F", "srifle_DMR_03_ARCO_F", "srifle_DMR_03_AMS_F", "srifle_DMR_04_F", "srifle_DMR_04_Tan_F", " 	srifle_DMR_04_ACO_F", "srifle_DMR_04_MRCO_F", "srifle_DMR_04_SOS_F", "srifle_DMR_04_DMS_F", "srifle_DMR_04_ARCO_F", "srifle_DMR_04_NS_LP_F", "srifle_DMR_06_camo_F", "srifle_DMR_06_olive_F", "srifle_DMR_06_camo_khs_F"
], "Marksman"];

_ATRestricted = [["B_soldier_AT_F", "B_recon_LAT_F"], [
    "launch_B_Titan_F", "launch_I_Titan_F", "launch_O_Titan_F", "launch_B_Titan_short_F", "launch_I_Titan_short_F", "launch_O_Titan_short_F"
], "AT specialist"];

_sniperRestricted = [["B_sniper_F"], [
    "srifle_GM6_F", "srifle_GM6_SOS_F", "srifle_GM6_LRPS_F", "srifle_LRR_F", "srifle_LRR_SOS_F", "srifle_LRR_LRPS_F", "srifle_GM6_camo_F", "srifle_GM6_camo_SOS_F", "srifle_GM6_camo_LRPS_F", "srifle_LRR_camo_F", "srifle_LRR_camo_F", "srifle_LRR_camo_LRPS_F", "srifle_DMR_02_F", "srifle_DMR_02_camo_F", "srifle_DMR_02_sniper_F", "srifle_DMR_02_ACO_F", "srifle_DMR_02_MRCO_F", "srifle_DMR_02_SOS_F", "srifle_DMR_02_DMS_F", "srifle_DMR_02_sniper_AMS_LP_S_F", "srifle_DMR_02_camo_AMS_LP_F", "srifle_DMR_02_ARCO_F", "srifle_DMR_05_blk_F", "srifle_DMR_05_hex_F", "srifle_DMR_05_tan_f", "srifle_DMR_05_ACO_F", "srifle_DMR_05_MRCO_F", "srifle_DMR_05_SOS_F", "srifle_DMR_05_DMS_F", "srifle_DMR_05_KHS_LP_F", "srifle_DMR_05_DMS_snds_F", "srifle_DMR_05_ARCO_F"
], "Sniper"];

_machinegunRestricted = [["B_soldier_AR_F"], [
    "MMG_01_hex_F ", "MMG_01_tan_F", "MMG_01_hex_ARCO_LP_F", "MMG_02_camo_F", "MMG_02_black_F", "MMG_02_sand_F", "MMG_02_sand_RCO_LP_F", "MMG_02_black_RCO_BI_F", "LMG_Mk200_BI_F", "LMG_Mk200_LP_BI_F", "LMG_Zafir_F", "LMG_Zafir_pointer_F", "LMG_Zafir_ARCO_F"
], "Autorifleman"];

_uavOperatorRestricted = [["B_soldier_UAV_F"], ["B_UavTerminal"], "UAV operator"];

_grenadierRestricted = [["B_Soldier_GL_F"], [
    "arifle_Katiba_GL_F", "arifle_Katiba_GL_ACO_F", "arifle_Katiba_GL_ARCO_pointer_F", "arifle_Katiba_GL_ACO_pointer_F", "arifle_Katiba_GL_Nstalker_pointer_F", "arifle_Katiba_GL_ACO_pointer_snds_F", "arifle_Mk20_GL_F", "arifle_Mk20_GL_plain_F", "arifle_Mk20_GL_MRCO_pointer_F", "arifle_Mk20_GL_ACO_F", "arifle_MX_GL_F", "arifle_MX_GL_ACO_F", "arifle_MX_GL_ACO_pointer_F", "arifle_MX_GL_Hamr_pointer_F", "arifle_MX_GL_Holo_pointer_snds_F", "arifle_MX_GL_Black_F", "arifle_MX_GL_Black_Hamr_pointer_F", "arifle_TRG21_GL_F", "arifle_TRG21_GL_MRCO_F", "arifle_TRG21_GL_ACO_pointer_F"
], "Grenadier"];

_gitGudM8 = [[],[
    "optic_Nightstalker", "optic_tws", "optic_tws_mg"
], "Git gud m8"];

_restrictedItems = [];
_restrictedItems pushBack _marksmenRestricted;
_restrictedItems pushBack _ATRestricted;
_restrictedItems pushBack _sniperRestricted;
_restrictedItems pushBack _machinegunRestricted;
_restrictedItems pushBack _uavOperatorRestricted;
_restrictedItems pushBack _grenadierRestricted;
_restrictedItems pushBack _gitGudM8,

_assignedItems = assignedItems _unit;
_weapons = [];
_weapons pushBack (primaryWeapon _unit);
_weapons pushBack (secondaryWeapon _unit);
{_weapons pushBack _x} foreach (primaryWeaponItems _unit);

_items = [];
_items = _items + (uniformItems _unit);
_items = _items + (vestItems _unit);
_items = _items + (backpackItems _unit);
_items = _items + _assignedItems;
_items = _items + _weapons;
{_items pushBack _x} foreach _primaryWeaponItems;

private ["_ITEM_MACRO_assignedItem", "_ITEM_MACRO_weapon", "_ITEM_MACRO_weaponItem", "_ITEM_MACRO_item"];
switch (_mode) do {
    case 0: {
        _ITEM_MACRO_assignedItem = {
            params ["_unit", "_X", "_testedClass"];
            _unit unlinkItem _X;
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_weapon = {
            params ["_unit", "_X", "_testedClass"];
            _unit removeWeapon _X;
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_weaponItem = {
            params ["_unit", "_X", "_testedClass"];
            _unit removePrimaryWeaponItem _X;
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_item = {
            params ["_unit", "_X", "_testedClass"];
            _unit removeItem _X;
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };
    };

    case 1: {

        _ITEM_MACRO_assignedItem = {
            params ["_unit", "_X", "_testedClass", "_item", "_container"];
            _unit unlinkItem _X;
            _container addItemCargoGlobal [_item, 1];
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_weapon = {
            params ["_unit", "_X", "_testedClass", "_item", "_container"];
            _unit removeWeapon _X;
            _container addItemCargoGlobal [_item, 1];
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_weaponItem = {
            params ["_unit", "_X", "_testedClass", "_item", "_container"];
            _unit removePrimaryWeaponItem _X;
            _container addItemCargoGlobal [_item, 1];
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };

        _ITEM_MACRO_item = {
            params ["_unit", "_X", "_testedClass", "_item", "_container"];
            _unit removeItem _X;
            _container addItemCargoGlobal [_item, 1];
            systemChat format ["%1 was removed, switch to %2 to use it.", getText (configFile >> "CfgWeapons" >> _X >> "displayName"), _testedClass];
        };
    };
};

{
    _x params ["_classArray", "_testedArray", "_testedClass"];

    if !(_unitClass in _classArray) then {
        {
            if (_x in _testedArray) then {
                if (_x in _assignedItems) then {
                    [_unit, _X, _testedClass, _item, _container] call _ITEM_MACRO_assignedItem
                } else {
                    if (_x in _weapons) then {
                        if (_unitClass in (_sniperRestricted select 0) && {_testedClass == (_marksmenRestricted select 2)}) then {
                        } else {
                            if (_x == (primaryWeapon _unit) || {_x == (secondaryWeapon _unit)}) then {
                                [_unit, _X, _testedClass, _item, _container] call _ITEM_MACRO_weapon
                            } else {
                                if (_x in (primaryWeaponItems _unit)) then {
                                    [_unit, _X, _testedClass, _item, _container] call _ITEM_MACRO_weaponItem
                                };
                            };
                        };
                    } else {
                        [_unit, _X, _testedClass, _item, _container] call _ITEM_MACRO_item
                    };
                };
            };
        } foreach _items;
    };
} foreach _restrictedItems;
