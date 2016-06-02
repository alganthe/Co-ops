/*
    This file is where all the enemies and objects are going to be defined (the ones from the missions / SM) at least.
    Please keep the format of the defines as is, if a define is an array keep it an array.
*/

//------------------------------------ Main AO

// Vehicles
#define MRAPList ["O_MRAP_02_gmg_F", "O_MRAP_02_hmg_F"]
#define AAVehicleList ["O_APC_Tracked_02_AA_F"]
#define RandomVehicleList ["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F", "O_APC_Wheeled_02_rcws_F", "O_APC_Tracked_02_cannon_F"]

// Urban groups related stuff
#define UrbanGroupsCFGPATH >> "CfgGroups" >> "East" >> "OPF_F" >> "UInfantry" >>
#define UrbanGroupsList ["OIA_GuardSquad"]
#define UrbanUnits ["O_soldierU_A_F", "O_soldierU_AAR_F", "O_soldierU_AAA_F", "O_soldierU_AAT_F", "O_soldierU_AR_F", "O_soldierU_medic_F", "O_engineer_U_F", "O_soldierU_exp_F", "O_soldierU_GL_F", "O_Urban_HeavyGunner_F", "O_soldierU_M_F", "O_soldierU_AA_F", "O_soldierU_AT_F", "O_soldierU_repair_F", "O_soldierU_F", "O_soldierU_LAT_F", "O_Urban_Sharpshooter_F", "O_soldierU_SL_F", "O_soldierU_TL_F"]

// Infantry groups related stuff
#define InfantryGroupsCFGPATH >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >>
#define InfantryGroupList ["OIA_InfSquad", "OIA_InfSquad_Weapons", "OIA_InfAssault", "OIA_ReconSquad"]
#define AAGroupsList ["OIA_InfTeam_AA"]
#define ATGroupsList ["OIA_InfTeam_AT"]

// Buildings that are always going to be fully filled when present in the AO
#define MilitaryBuildings ["Land_Cargo_House_V1_F", "Land_Cargo_House_V2_F", "Land_Cargo_House_V3_F", "Land_Medevac_house_V1_F", "Land_Research_house_V1_F", "Land_Cargo_HQ_V1_F", "Land_Cargo_HQ_V2_F", "Land_Cargo_HQ_V3_F", "Land_Research_HQ_F", "Land_Medevac_HQ_V1_F", "Land_Cargo_Patrol_V1_F", "Land_Cargo_Patrol_V2_F", "Land_Cargo_Patrol_V3_F", "Land_Cargo_Tower_V1_F", "Land_Cargo_Tower_V2_F", "Land_Cargo_Tower_V3_F"]

//------------------------------------ Side missions

#define CACHESMCacheArray ["Box_FIA_Wps_F", "Box_FIA_Ammo_F", "Box_FIA_Support_F"]
#define COMTOWERSMArray ["Land_Communication_F", "Land_TTowerBig_1_F", "Land_TTowerBig_2_F"]
#define OFFICERSMTarget ["O_officer_F"]
#define OFFICERSMGuards ["O_soldier_F"]
#define TRUCKSMTruck ["O_Truck_03_ammo_F"]
#define UAVSMUav ["O_UAV_02_F"]

// first element of the array: vehicle classname, second element: chance to be picked, higher is better, highest should be 10 (for performances)
#define SMRewards ["B_Heli_Light_01_armed_F", 2], \
["B_Heli_Attack_01_F", 2], \
["I_Heli_light_03_F", 2], \
["O_Heli_Attack_02_black_F", 2], \
["O_Heli_Transport_04_covered_F", 3], \
["B_MBT_01_TUSK_F", 5], \
["B_MBT_01_cannon_F", 5], \
["I_Plane_Fighter_03_AA_F", 2], \
["B_APC_Tracked_01_AA_F", 5], \
["I_APC_tracked_03_cannon_F", 5], \
["I_APC_Wheeled_03_cannon_F", 5], \
["I_MBT_03_cannon_F", 5]

//------------------------------------ Random stuff

#define AirReinforcementVehicleList ["O_Heli_Light_02_F"]
#define NoAmmoCargoVehc ["B_APC_Tracked_01_CRV_F", "B_Truck_01_ammo_F"] // The vehicles that should have their ammoCargo set to 0 on respawn, avoid people abusing them to rearm planes outside of the service pad
#define VHCrewedVehicles  ["B_UAV_02_CAS_F", "B_UAV_02_F", "B_UGV_01_F", "B_UGV_01_rcws_F"] // Respawned vehicles that should have crew aka UAVs
#define ArsenalBoxes [arsenalBox1, arsenalBox2, arsenalDude] // Vars of the arsenal boxes
