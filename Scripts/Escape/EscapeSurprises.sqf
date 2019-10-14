if (!isServer) exitWith {};

private ["_minEnemySkill", "_maxEnemySkill", "_debug"];
private ["_surprises", "_surprise", "_executedSurprises", "_surpriseID", "_surpriseTimeSec", "_condition", "_isExecuted", "_surpriseArgs", "_timeInSek", "_enemyFrequency", "_spawnSegment"];

_minEnemySkill = _this select 0;
_maxEnemySkill = _this select 1;
_enemyFrequency = _this select 2;
if (count _this > 3) then { _debug = _this select 3; } else { _debug = false; };

// Create all surprises

waitUntil {([drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists)};

_surprises = [];

// A surprise have members [ID, MissionTimeSec, Condition, IsExecuted, Surprice Arguments].

// Drop Chopper

_surpriseArgs = [(_enemyFrequency + 2) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
_timeInSek = 5 * 60 + random (60 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_condition = {true};
_surprise = ["DROPCHOPPER", _timeInSek, _condition, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Russian Search Chopper

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 45 * 60 + random (30 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["RUSSIANSEARCHCHOPPER", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Motorized Search Group

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 20 * 60 + random (60 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["MOTORIZEDSEARCHGROUP", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Reinforcement Truck

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 10 * 60 + random (30 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["REINFORCEMENTTRUCK", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);

// Enemies in a civilian car

_surpriseArgs = [_minEnemySkill, _maxEnemySkill];
_timeInSek = 0 * 60 + random (60 * 60);
_timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
_surprise = ["CIVILIANENEMY", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
_surprises set [count _surprises, _surprise];
diag_log ("ESCAPE SURPRISE: " + str _surprise);


// Execute surprises

_executedSurprises = 0;

while {true} do {
    {
        _surprise = _x;
        _surpriseID = _x select 0;
        _surpriseTimeSec = _x select 1;
        _condition = _x select 2;
        _isExecuted = _x select 3;
        _surpriseArgs = _x select 4;
        
        if (!_isExecuted && time > _surpriseTimeSec) then {
            
            if (call _condition) then {
                _surprise set [3, true];
                _executedSurprises = _executedSurprises + 1;
                
                if (_debug) then {
                    ["Starting surprise: " + _surpriseID] call drn_fnc_CL_ShowDebugTextAllClients;
                };
                
                if (_surpriseID == "MOTORIZEDSEARCHGROUP") then {
                    private ["_enemyMinSkill", "_enemyMaxSkill"];
                    
                    _enemyMinSkill = _surpriseArgs select 0;
                    _enemyMaxSkill = _surpriseArgs select 1;
                    
                    _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                    while {(str _spawnSegment) == """NULL"""} do {
                        _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                        sleep 1;
                    };
                    
                    [getPos _spawnSegment, drn_searchAreaMarkerName, _enemyFrequency, _enemyMinSkill, _enemyMaxSkill, drn_var_Escape_debugMotorizedSearchGroup] execVM "Scripts\Escape\CreateMotorizedSearchGroup.sqf";
                    
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 20 * 60 + random (60 * 60);
                    _timeInSek = time + _timeInSek * (4 - _enemyFrequency);
                    _surprise = ["MOTORIZEDSEARCHGROUP", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [count _surprises, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
                };
                
                if (_surpriseID == "DROPCHOPPER") then {
                    private ["_noOfDropUnits", "_noOfDropUnits"];
                    private ["_dropUnitTypeArray", "_dropGroup", "_soldierType", "_soldier", "_dropUnits", "_i", "_dropPosition"];
                    private ["_onGroupDropped"];
                    
                    _noOfDropUnits = _surpriseArgs select 0;
                    
                    _dropGroup = createGroup drn_var_enemySide;
                    _dropUnits = [];
                    
                    for [{_i = 0}, {_i < _noOfDropUnits}, {_i = _i + 1}] do {
                        _soldierType = drn_arr_Escape_InfantryTypes select floor (random count drn_arr_Escape_InfantryTypes);
                        _soldier = _dropGroup createUnit [_soldierType, [0,0,30], [], 0, "FORM"];
                        _soldier setSkill (_minEnemySkill + random (_maxEnemySkill - _minEnemySkill));
                        _soldier setRank "CAPTAIN";
                        _soldier call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
                        _dropUnits set [_i, _soldier];
                    };
                    
                    _dropPosition = [drn_searchAreaMarkerName] call drn_fnc_CL_GetRandomMarkerPos;
                    
                    _onGroupDropped = {
                        private ["_group", "_dropPos"];
                        
                        _group = _this select 0;
                        _dropPos = _this select 1;
                        
                        [_group, drn_searchAreaMarkerName, _dropPos, drn_var_Escape_DebugSearchGroup] execVM "Scripts\DRN\SearchGroup\SearchGroup.sqf";                        
                    };
                    
                    [getMarkerPos "drn_dropChopperStartPosMarker", drn_var_enemySide, "Mi17_Ins", "Ins_Soldier_Pilot", _dropUnits, _dropPosition, _minEnemySkill, _maxEnemySkill, _onGroupDropped, drn_var_Escape_debugDropChoppers] execVM "Scripts\Escape\CreateDropChopper.sqf";
                    
                    // Create next drop chopper
                    _surpriseArgs = [(_enemyFrequency + 2) + floor random (_enemyFrequency * 2)]; // [NoOfDropUnits]
                    _timeInSek = random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _condition = {true};
                    _surprise = ["DROPCHOPPER", _timeInSek, _condition, false, _surpriseArgs];
                    _surprises set [count _surprises, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
                };
                
                if (_surpriseID == "RUSSIANSEARCHCHOPPER") then {
                    private ["_chopper", "_result", "_group"];
                    
                    _chopper = "Ka52Black" createVehicle getMarkerPos "drn_russianSearchChopperStartPosMarker";
                    _chopper lock false;
                    _chopper setVehicleVarName "drn_russianSearchChopper";
                    _chopper call compile format ["%1=_this;", "drn_russianSearchChopper"];
                    
                    _group = createGroup drn_var_enemySide;

                    "Ins_Soldier_Pilot" createUnit [[0, 0, 30], _group, "", (_minEnemySkill + random (_maxEnemySkill - _minEnemySkill)), "LIEUTNANT"];
                    "Ins_Soldier_Pilot" createUnit [[0, 0, 30], _group, "", (_minEnemySkill + random (_maxEnemySkill - _minEnemySkill)), "LIEUTNANT"];

                    ((units _group) select 0) assignAsDriver _chopper;
                    ((units _group) select 0) moveInDriver _chopper;
                    ((units _group) select 1) assignAsGunner _chopper;
                    ((units _group) select 1) moveInGunner _chopper;
                    
                    {
                        _x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
                    } foreach units _group;
                    
                    [_chopper, drn_searchAreaMarkerName, (5 + random 15), (5 + random 15), drn_var_Escape_debugSearchChopper] execVM "Scripts\DRN\SearchChopper\SearchChopper.sqf";
                  
                    // Create new russian search chopper
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 30 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["RUSSIANSEARCHCHOPPER", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [count _surprises, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
                };
                
                if (_surpriseID == "REINFORCEMENTTRUCK") then {
                    private ["_enemyMinSkill", "_enemyMaxSkill", "_playerPos"];
                    
                    _enemyMinSkill = _surpriseArgs select 0;
                    _enemyMaxSkill = _surpriseArgs select 1;

                    _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                    while {(str _spawnSegment) == """NULL"""} do {
                        _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                        sleep 1;
                    };
                    
                    [getPos _spawnSegment, _enemyMinSkill, _enemyMaxSkill, drn_var_Escape_debugReinforcementTruck] execVM "Scripts\Escape\CreateReinforcementTruck.sqf";
                    
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["REINFORCEMENTTRUCK", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [count _surprises, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
                };
                
                if (_surpriseID == "CIVILIANENEMY") then {
                    
                    _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                    while {(str _spawnSegment) == """NULL"""} do {
                        _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
                        sleep 1;
                    };
                    
                    [call drn_fnc_Escape_GetPlayerGroup, getPos _spawnSegment, drn_var_enemySide, drn_arr_Escape_EnemyCivilianCarTypes, drn_arr_Escape_InfantryTypes, _enemyFrequency, drn_var_Escape_debugCivilEnemy] execVM "Scripts\Escape\CreateCivilEnemy.sqf";
                    
                    _surpriseArgs = [_minEnemySkill, _maxEnemySkill];
                    _timeInSek = 15 * 60 + random (45 * 60);
                    _timeInSek = time + (_timeInSek * (0.5 + (4 - _enemyFrequency) / 4));
                    _surprise = ["CIVILIANENEMY", _timeInSek, {[drn_searchAreaMarkerName] call drn_fnc_CL_MarkerExists}, false, _surpriseArgs];
                    _surprises set [count _surprises, _surprise];
                    diag_log ("ESCAPE SURPRISE: " + str _surprise);
                };
            };
        };
    } foreach _surprises;
    
    sleep 60;
};


