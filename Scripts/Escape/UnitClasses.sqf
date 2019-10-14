/*
 * Description: This file contains vheicle types and unit types for most units spawned in the mission.
 * "Random array" (used below) means that array will be used to spawn units, and that chance is 1/n that each element will be spawned on each spawn. The array can contain 
 * many elements of the same type, so the example array ["Offroad_DSHKM_INS", "Pickup_PK_INS", "Pickup_PK_INS"] will spawn an Offroad with 1/3 probability, and a 
 * Pickup with 2/3 probability.
 *
 * Except for the classes specified in this file, classes are specified in the following files: CreateSearchChopper.sqf, EscapeSurprises (RUSSIANSEARCHCHOPPER) 
 * and RunExtraction.sqf, all in folder Scripts\Escape\.
 */

private ["_enemyFrequency"];

_enemyFrequency = _this select 0;

// Random array. Start position guard types.
drn_arr_Escape_StartPositionGuardTypes = ["Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sab", "Ins_Soldier_Sapper"];

// Inner fence guard's secondary weapon (and corresponding magazine type).
drn_var_Escape_InnerFenceGuardSecondaryWeapon = "Makarov";
drn_var_Escape_InnerFenceGuardSecondaryWeaponMagazine = "8Rnd_9x18_Makarov";

// Random array. Civilian vehicle classes for ambient traffic. (Can also be set to a faction name).
drn_arr_Escape_MilitaryTraffic_CivilianVehicleClasses = ["SkodaBlue", "SkodaGreen", "SkodaRed", "Skoda", "VWGolf", "TT650_Civ", "MMT_Civ", "hilux1_civil_2_covered", "hilux1_civil_1_open", "hilux1_civil_3_open", "car_hatchback", "datsun1_civil_1_open", "datsun1_civil_2_covered", "datsun1_civil_3_open", "V3S_Civ", "car_sedan", "Tractor", "UralCivil", "UralCivil2", "Lada_base", "LadaLM", "Lada2", "Lada1"];

// Random arrays. Enemy vehicle classes for ambient traffic. (Can also be set to a faction name).
// Variable _enemyFrequency applies to server parameter, and can be one of the values 1 (Few), 2 (Some) or 3 (A lot).
switch (_enemyFrequency) do {
    case 1: {
        drn_arr_Escape_MilitaryTraffic_EnemyVehicleClasses = ["TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS"];
    };
    case 2: {
        drn_arr_Escape_MilitaryTraffic_EnemyVehicleClasses = ["TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS"];
    };
    default {
        drn_arr_Escape_MilitaryTraffic_EnemyVehicleClasses = ["TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS", "Ural_ZU23_INS", "BMP2_Ambul_INS", "UralRefuel_INS"];
    };
};

// Random array. General infantry types. E.g. village patrols, ambient infantry, ammo depot guards, communication center guards, etc.
drn_arr_Escape_InfantryTypes = ["Ins_Soldier_AA", "Ins_Soldier_AT", "Ins_Soldier_AT", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper"];

// Random array. A roadblock has a manned vehicle. This array contains possible manned vehicles (can be of any kind, like cars, armored and statics).
drn_arr_Escape_RoadBlock_MannedVehicleTypes = ["Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "AGS_Ins", "DSHKM_Ins", "DSHkM_Mini_TriPod", "SPG9_Ins"];

// Random array. Vehicle classes (preferrably trucks) transporting enemy reinforcements.
drn_arr_Escape_ReinforcementTruck_vehicleClasses = ["Ural_INS", "UralOpen_INS"];
// Total cargo for reinforcement trucks. Each element corresponds to a vehicle (array element) in array drn_arr_Escape_ReinforcementTruck_vehicleClasses above.
drn_arr_Escape_ReinforcementTruck_vehicleClassesMaxCargo = [14, 14];

// Random array. Motorized search groups are sometimes sent to look for you. This array contains possible class definitions for the vehicles.
drn_arr_Escape_MotorizedSearchGroup_vehicleClasses = ["BMP2_INS", "BMP3", "BTR90", "GAZ_Vodnik"];
// Total cargo motorized search group vehicle. Each element corresponds to a vehicle (array element) in array drn_arr_Escape_MotorizedSearchGroup_vehicleClasses above.
drn_arr_Escape_MotorizedSearchGroup_vehicleClassesMaxCargo = [7, 5, 7, 10];

// A communication center is guarded by vehicles depending on variable _enemyFrequency. 1 = a random light armor. 2 = a random heavy armor. 3 = a random 
// light *and* a random heavy armor.

// Random array. Light armored vehicles guarding the communication centers.
drn_arr_ComCenDefence_lightArmorClasses = ["BMP2_INS", "BRDM2_INS", "BMP3", "BTR90", "GAZ_Vodnik"];
// Random array. Heavy armored vehicles guarding the communication centers.
drn_arr_ComCenDefence_heavyArmorClasses = ["T72_INS", "ZSU_INS", "2S6M_Tunguska", "T90"];

// A communication center contains two static weapons (in two corners of the communication center).
// Random array. Possible static weapon types for communication centers.
drn_arr_ComCenStaticWeapons = ["DSHKM_Ins"];
// A communication center have two parked and empty vehicles of the following possible types.
drn_arr_ComCenParkedVehicles = ["TT650_Ins", "Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_INS", "UAZ_INS", "UAZ_INS", "UAZ_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS"];

// Random array. Enemies sometimes use civilian vehicles in their unconventional search for players. The following car types may be used.
drn_arr_Escape_EnemyCivilianCarTypes = ["SkodaBlue", "SkodaGreen", "SkodaRed", "Skoda", "VWGolf", "MMT_Civ", "hilux1_civil_2_covered", "car_hatchback", "datsun1_civil_2_covered", "V3S_Civ", "car_sedan", "UralCivil", "UralCivil2", "Lada_base", "LadaLM", "Lada2", "Lada1"];

// Vehicles, weapons and ammo at ammo depots

// Random array. An ammo depot contains one static weapon of the followin types:
drn_arr_Escape_AmmoDepot_StaticWeaponClasses = ["DSHkM_Mini_TriPod", "AGS_Ins", "DSHKM_Ins", "DSHKM_Ins"];
// An ammo depot have one parked and empty vehicle of the following possible types.
drn_arr_Escape_AmmoDepot_ParkedVehicleClasses = ["Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "Ural_INS", "UralOpen_INS"];

// The following arrays define weapons and ammo contained at the ammo depots
// Index 0: Weapon classname.
// Index 1: Weapon's probability of presence (in percent, 0-100).
// Index 2: If weapon exists, crate contains at minimum this number of weapons of current class.
// Index 3: If weapon exists, crate contains at maximum this number of weapons of current class.
// Index 4: Array of magazine classnames. Magazines of these types are present if weapon exists.
// Index 5: Number of magazines per weapon that exists.

// Weapons and ammo in the basic weapons box
drn_arr_AmmoDepotBasicWeapons = [];
// Insurgent weapons
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_47_M", 40, 8, 12, ["30Rnd_762x39_AK47"], 14]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_47_S", 40, 8, 12, ["30Rnd_762x39_AK47"], 12]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_74", 40, 8, 12, ["30Rnd_545x39_AK"], 12]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_74_GL", 35, 2, 4, ["30Rnd_545x39_AK", "1Rnd_SMOKE_GP25"], 15]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_74_GL", 35, 2, 4, ["30Rnd_545x39_AK", "1Rnd_HE_GP25"], 20]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AKS_74_U", 25, 3, 6, ["30Rnd_545x39_AK"], 12]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["PK", 30, 2, 3, ["100Rnd_762x54_PK"], 15]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["Makarov", 85, 8, 12, ["8Rnd_9x18_Makarov"], 10]];

// Russian weapons
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_107_Kobra", 20, 1, 3, ["30Rnd_545x39_AK"], 18]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["AK_107_GL_Kobra", 15, 1, 3, ["30Rnd_545x39_AK", "1Rnd_SMOKE_GP25", "1Rnd_HE_GP25"], 15]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["bizon", 15, 1, 3, ["64Rnd_9x19_Bizon"], 15]];
drn_arr_AmmoDepotBasicWeapons set [count drn_arr_AmmoDepotBasicWeapons, ["Saiga12K", 15, 1, 2, ["8Rnd_B_Saiga12_74Slug", "8Rnd_B_Saiga12_Pellets"], 20]];

// Weapons and ammo in the special weapons box
drn_arr_AmmoDepotSpecialWeapons = [];
// Insurgent weapons
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["SVD", 20, 1, 2, ["10Rnd_762x54_SVD"], 15]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["AKS_74_UN_Kobra", 20, 1, 2, ["30Rnd_545x39_AKSD"], 20]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["G36C", 20, 1, 2, ["30Rnd_556x45_G36", "30Rnd_556x45_Stanag"], 15]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["Huntingrifle", 20, 1, 2, ["5x_22_LR_17_HMR"], 15]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["RPK_74", 20, 1, 1, ["75Rnd_545x39_RPK"], 18]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["RPK_74", 20, 1, 1, ["30Rnd_545x39_AK"], 18]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["AKS_74_PSO", 20, 1, 3, ["30Rnd_545x39_AK"], 14]];

// Russian weapons
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["AK_107_PSO", 15, 1, 1, ["30Rnd_545x39_AK"], 20]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["AK_107_GL_PSO", 10, 1, 1, ["30Rnd_545x39_AK", "1Rnd_SMOKE_GP25", "1Rnd_HE_GP25"], 12]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["Bizon_Silenced", 15, 2, 5, ["64Rnd_9x19_SD_Bizon"], 8]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["Pecheneg", 10, 1, 1, ["100Rnd_762x54_PK"], 12]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["ksvk", 10, 1, 1, ["5Rnd_127x108_KSVK"], 15]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["VSS_Vintorez", 10, 1, 1, ["10Rnd_9x39_SP5_VSS"], 12]];
drn_arr_AmmoDepotSpecialWeapons set [count drn_arr_AmmoDepotSpecialWeapons, ["MakarovSD", 20, 2, 5, ["8Rnd_9x18_MakarovSD"], 10]];

// Weapons and ammo in the launchers box
drn_arr_AmmoDepotLaunchers = [];
// Insurgent weapons
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["RPG7V", 100, 3, 5, ["PG7VL"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["RPG7V", 25, 1, 2, ["PG7VR"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["Strela", 100, 1, 1, ["Strela"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["Strela", 75, 1, 2, ["Strela"], 2]];

// Russian weapons
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["RPG18", 25, 1, 2, ["RPG18"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["MetisLauncher", 15, 1, 1, ["AT13"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["Igla", 35, 1, 2, ["Igla"], 3]];

// Some stolen western weapons can sometimes appear
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["Javelin", 5, 2, 2, ["Javelin"], 2]];
drn_arr_AmmoDepotLaunchers set [count drn_arr_AmmoDepotLaunchers, ["Stinger", 5, 2, 2, ["Stinger"], 2]];

// Weapons and ammo in the ordnance box
drn_arr_AmmoDepotOrdnance = [];
// General weapons
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Put", 50, 1, 2, ["Mine"], 5]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Put", 35, 1, 2, ["MineE"], 6]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 85, 1, 2, ["HandGrenade_East"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Put", 50, 1, 2, ["PipeBomb"], 2]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 75, 1, 2, ["SmokeShell"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellYellow"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellRed"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellGreen"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellPurple"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellBlue"], 8]];
drn_arr_AmmoDepotOrdnance set [count drn_arr_AmmoDepotOrdnance, ["Throw", 15, 1, 2, ["SmokeShellOrange"], 8]];

// Weapons and ammo in the vehicle box (the big one)
// Some high volumes (mostly for immersion)
drn_arr_AmmoDepotVehicle = [];
drn_arr_AmmoDepotVehicle set [count drn_arr_AmmoDepotVehicle, ["Put", 30, 1, 1, ["Mine"], 100]];
drn_arr_AmmoDepotVehicle set [count drn_arr_AmmoDepotVehicle, ["Throw", 30, 1, 2, ["HandGrenade_East"], 120]];
drn_arr_AmmoDepotVehicle set [count drn_arr_AmmoDepotVehicle, ["Put", 30, 1, 2, ["PipeBomb"], 75]];

// Weapons that may show up in civilian cars

// Index 0: Weapon classname.
// Index 1: Magazine classname.
// Index 2: Number of magazines.

drn_arr_CivilianCarWeapons = [];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["AK_74", "30Rnd_545x39_AK", 5]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["AK_107_GL_PSO", "30Rnd_545x39_AK", 11]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["PK", "100Rnd_762x54_PK", 9]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Makarov", "8Rnd_9x18_Makarov", 8]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["bizon", "64Rnd_9x19_Bizon", 6]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["SVD", "10Rnd_762x54_SVD", 7]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["AKS_74_PSO", "30Rnd_545x39_AK", 5]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Huntingrifle", "5x_22_LR_17_HMR", 8]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Bizon_Silenced", "64Rnd_9x19_SD_Bizon", 5]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["MakarovSD", "8Rnd_9x18_MakarovSD", 12]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["RPG7V", "PG7V", 1]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["RPG18", "RPG18", 1]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Igla", "Igla", 1]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Put", "PipeBomb", 2]];
drn_arr_CivilianCarWeapons set [count drn_arr_CivilianCarWeapons, ["Throw", "HandGrenade_East", 5]];
