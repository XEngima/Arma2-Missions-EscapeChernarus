// Initialization for server
if (!isServer) exitWith {};

private ["_referenceUnit", "_side", "_infantryClasses", "_minSkill", "_maxSkill", "_debug", "_spawnRadius", "_villagePos", "_minSoldiersPerGroup", "_maxSoldiersPerGroup", "_areaPerGroup"];
private ["_village", "_possibleInfantryTypes", "_soldierType", "_soldierCount", "_soldier", "_soldiers", "_i", "_isFaction"];
private ["_villageNo", "_villageSize", "_maxGroupsCount", "_groupsCount", "_groups", "_groupIndex", "_damage", "_spawned", "_soldierObj"];
private ["_script", "_skill", "_ammo", "_trigger", "_soldierPos", "_rank", "_hasScript", "_groupPos", "_roadSegments", "_roadSegment"];
private ["_message", "_villageMarkerName", "_fnc_onSpawnGroup"];

if (isNil "drn_var_villageMarkersInitialized") exitWith {
    [] spawn {
        player sideChat "Scripts\DRN\VillageMarkers\InitVillageMarkers.sqf must be called before call to Scripts/DRN/VillagePatrols/InitVillagePatrols.sqf.";
        sleep 10;
    };
};

_referenceUnit = _this select 0;
_side = _this select 1;
if (count _this > 2) then {_infantryClasses = _this select 2;} else {_infantryClasses = [];};
if (count _this > 3) then {_minSoldiersPerGroup = _this select 3;} else {_minSoldiersPerGroup = 2;};
if (count _this > 4) then {_maxSoldiersPerGroup = _this select 4;} else {_maxSoldiersPerGroup = 5;};

// If village area is less than this number 0 or 1 group will be spawned. If village area is double this number, 0, 1 or 2 groups will spawn, and so on.
if (count _this > 5) then {_areaPerGroup = _this select 5;} else {_areaPerGroup = 5000;};

if (count _this > 6) then {_minSkill = _this select 6;} else {_minSkill = 0.3;};
if (count _this > 7) then {_maxSkill = _this select 7;} else {_maxSkill = 0.6;};
if (count _this > 8) then {_spawnRadius = _this select 8;} else {_spawnRadius = 750;};
if (count _this > 9) then {_fnc_onSpawnGroup = _this select 9;} else {_fnc_onSpawnGroup = {};};
if (count _this > 10) then {_debug = _this select 10;} else {_debug = false;};

if (_debug) then {
	_message = "Initializing village patrols.";
	diag_log _message;
	player sideChat _message;
};

_isFaction = false;
if (str _infantryClasses == """USMC""") then {
    _possibleInfantryTypes = ["USMC_Soldier_AA", "USMC_Soldier_HAT", "USMC_Soldier_AT", "USMC_Soldier_AR", "USMC_Soldier_Medic", "USMC_SoldierM_Marksman", "USMC_SoldierS_Engineer", "USMC_Soldier_TL", "USMC_Soldier_GL", "USMC_Soldier_MG", "USMC_Soldier_Officer", "USMC_Soldier", "USMC_Soldier2", "USMC_Soldier_LAT", "USMC_SoldierS_Sniper", "USMC_SoldierS_SniperH"];    
    _isFaction = true;
};
if (str _infantryClasses == """CDF""") then {
    _possibleInfantryTypes = ["CDF_Soldier_Strela", "CDF_Soldier_RPG", "CDF_Soldier_AR", "CDF_Soldier_GL", "CDF_Soldier_MG", "CDF_Soldier_Marksman", "CDF_Soldier_Medic", "CDF_Soldier_Militia", "CDF_Soldier_Officer", "CDF_Soldier", "CDF_Soldier_Sniper"];
    _isFaction = true;
};
if (str _infantryClasses == """RU""") then {
    _possibleInfantryTypes = ["RU_Soldier_AA", "RU_Soldier_HAT", "RU_Soldier_AR", "RU_Soldier_GL", "RU_Soldier_MG", "RU_Soldier_Marksman", "RU_Soldier_Medic", "RU_Soldier", "RU_Soldier_LAT", "RU_Soldier_AT", "RU_Soldier2", "RU_Soldier_Sniper", "RU_Soldier_SniperH"];
    _isFaction = true;
};
if (str _infantryClasses == """INS""") then {
    _possibleInfantryTypes = ["Ins_Soldier_AA", "Ins_Soldier_AT", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2", "Ins_Soldier_Sniper"];
    _isFaction = true;
};
if (str _infantryClasses == """GUE""") then {
    _possibleInfantryTypes = ["GUE_Soldier_AR", "GUE_Soldier_GL", "GUE_Soldier_Sniper", "GUE_Soldier_MG", "GUE_Soldier_Medic", "GUE_Soldier_3", "GUE_Soldier_2", "GUE_Soldier_1", "GUE_Soldier_AT", "GUE_Soldier_AA"];
    _isFaction = true;
};

if (!_isFaction) then {
    _possibleInfantryTypes =+ _infantryClasses;
};

drn_arr_villagePatrols_Villages = [];
drn_fnc_VillagePatrols_OnSpawnGroup = _fnc_OnSpawnGroup;
_villageNo = 0;

// Create spawn triggers around each village
{
    _villageMarkerName = "drn_villageMarker" + str _villageNo;
    
    _villagePos = _x select 0;
    _villageSize = _x select 3;
    _maxGroupsCount = ceil (((_villageSize select 0) * (_villageSize select 1)) / _areaPerGroup);
    
    _groupsCount = floor random (_maxGroupsCount + 1);
    _groupsCount = _groupsCount + (floor random (_maxGroupsCount + 1 - _groupsCount));
//    _groupsCount = floor random (_maxGroupsCount + 1);
//    _groupsCount = _maxGroupsCount;
    _groups = [];
    
    // Create groups
    
    for [{_groupIndex = 0}, {_groupIndex < _groupsCount}, {_groupIndex = _groupIndex + 1}] do {
        
        _soldierCount = _minSoldiersPerGroup + floor (random (_maxSoldiersPerGroup - _minSoldiersPerGroup + 1));
        _rank = "SERGEANT";
        _hasScript = false;
        _groupPos = [_villageMarkerName] call drn_fnc_CL_GetRandomMarkerPos;
        _roadSegments = _groupPos nearRoads 100;
        if (count _roadSegments > 0) then {
            _roadSegment = _roadSegments select floor random count _roadSegments;
            _groupPos = getPos _roadSegment;
        };
        
        _soldiers = [];
        for [{_i = 0}, {_i < _soldierCount}, {_i = _i + 1}] do {
            _soldierType = _possibleInfantryTypes select floor random count _possibleInfantryTypes;
            
            _damage = 0;
            _spawned = false;
            _soldierObj = objNull;
            _script = objNull;
            _soldierPos = _groupPos;
            _skill = (_minSkill + random (_maxSkill - _minSkill));
            _ammo = random 1;
            
            _soldier = [_soldierType, _damage, _spawned, _soldierObj, _script, _soldierPos, _skill, _ammo, _rank, _hasScript];
            _rank = "PRIVATE";
            _soldiers set [_i, _soldier];
        };
        
        _groups set [count _groups, _soldiers];
    };

	_village = [_villageMarkerName, _villagePos, _groups, _side];
	drn_arr_villagePatrols_Villages set [count drn_arr_villagePatrols_Villages, _village];

	// Set village trigger

	_trigger = createTrigger["EmptyDetector", _villagePos];
	_trigger triggerAttachVehicle [vehicle _referenceUnit];
	_trigger setTriggerArea[_spawnRadius, _spawnRadius, 0, false];
	_trigger setTriggerActivation["MEMBER", "PRESENT", true];
	_trigger setTriggerTimeout [1, 1, 1, true];
	_trigger setTriggerStatements["this", "_nil = [drn_arr_villagePatrols_Villages select " + str _villageNo + ", " + str _debug + "] execVM ""Scripts\DRN\VillagePatrols\PopulateVillage.sqf"";", "_nil = [drn_arr_villagePatrols_Villages select " + str _villageNo + ", " + str _debug + "] execVM ""Scripts\DRN\VillagePatrols\DepopulateVillage.sqf"";"];

	_villageNo = _villageNo + 1;
} foreach drn_villageMarkers;

if (_debug) then {
	_message = "Initialized villages: " + str _villageNo;
	diag_log _message;
	player sideChat _message;
};

