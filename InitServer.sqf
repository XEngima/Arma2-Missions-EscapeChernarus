if (!isServer) exitWith {};

private ["_useEscapeSurprises", "_useRandomStartPos", "_useAmmoDepots", "_useSearchLeader", "_useMotorizedSearchGroup", "_useVillagePatrols", "_useMilitaryTraffic", "_useAmbientInfantry", "_useSearchChopper", "_useRoadBlocks", "_guardsExist", "_guardsAreArmed", "_guardLivesLong"];
private ["_debugEscapeSurprises", "_debugAmmoDepots", "_debugSearchLeader", "_showGroupDiagnostics", "_debugVillagePatrols", "_debugMilitaryTraffic", "_debugAmbientInfantry", "_debugGarbageCollector", "_debugRoadBlocks"];
private ["_enemyMinSkill", "_enemyMaxSkill", "_searchChopperSearchTimeMin", "_searchChopperRefuelTimeMin", "_enemySpawnDistance", "_playerGroup", "_enemyFrequency", "_comCenGuardsExist", "_fenceRotateDir", "_scriptHandle"];

// Developer Variables

_useRandomStartPos = true;
_useEscapeSurprises = true;
_useAmmoDepots = true;
_useSearchLeader = true;
_useMotorizedSearchGroup = true;
_useVillagePatrols = true;
_useMilitaryTraffic = true;
_useAmbientInfantry = true;
_useSearchChopper = true;
_useRoadBlocks = true;

_guardsExist = true;
_comCenGuardsExist = true;
_guardsAreArmed = true;
_guardLivesLong = true;

// Debug Variables

_debugEscapeSurprises = false;
_debugAmmoDepots = false;
_debugSearchLeader = false;
_debugVillagePatrols = false;
_debugMilitaryTraffic = false;
_debugAmbientInfantry = false;
_debugGarbageCollector = false;
_debugRoadBlocks = false;
drn_var_Escape_debugMotorizedSearchGroup = false;
drn_var_Escape_debugDropChoppers = false;
drn_var_Escape_debugReinforcementTruck = false;
drn_var_Escape_debugSearchChopper = false;
drn_var_Escape_DebugSearchGroup = false;
drn_var_Escape_debugCivilEnemy = false;

_showGroupDiagnostics = false;

// Game Control Variables, do not edit!

drn_var_Escape_AllPlayersDead = false;
drn_var_Escape_MissionComplete = false;
publicVariable "drn_var_Escape_AllPlayersDead";
publicVariable "drn_var_Escape_MissionComplete";

_enemyMinSkill = (paramsArray select 0) / 5;
_enemyMaxSkill = (paramsArray select 0) / 5 + 0.2;
drn_var_Escape_enemyMinSkill = _enemyMinSkill;
drn_var_Escape_enemyMaxSkill = _enemyMaxSkill;

_searchChopperSearchTimeMin = (5 + random 10);
_searchChopperRefuelTimeMin = (5 + random 10);

waituntil {!isnil "bis_fnc_init"};

_enemyFrequency = (paramsArray select 1);
_enemySpawnDistance = (paramsArray select 5);

drn_searchAreaMarkerName = "drn_searchAreaMarker";

// Choose a start position
if (_useRandomStartPos) then {
    drn_startPos = [] call drn_fnc_Escape_FindGoodPos;
}
else {
    drn_startPos = getPos ((call drn_fnc_Escape_GetPlayers) select 0);
};
publicVariable "drn_startPos";

// Build start position
_fenceRotateDir = random 360;
_scriptHandle = [drn_startPos, _fenceRotateDir] execVM "Scripts\Escape\BuildStartPos.sqf";
waitUntil {scriptDone _scriptHandle};
sleep 0.25;

drn_fenceIsCreated = true;
publicVariable "drn_fenceIsCreated";

call compile preprocessFileLineNumbers "Scripts\DRN\VillageMarkers\InitVillageMarkers.sqf";
[_enemyFrequency] call compile preprocessFileLineNumbers "Scripts\Escape\UnitClasses.sqf";
_playerGroup = group ((call drn_fnc_Escape_GetPlayers) select 0);

if (_useEscapeSurprises) then {
    [_enemyMinSkill, _enemyMaxSkill, _enemyFrequency, _debugEscapeSurprises] execVM "Scripts\Escape\EscapeSurprises.sqf";
};

if (_showGroupDiagnostics) then {
    [] execVM "Scripts\DRN\Diagnostics\MonitorEmptyGroups.sqf";
};

// Initialize communication centers
if (true) then {
    private ["_communicationCenterMarkers", "_comCenNo", "_comCenMarkerNames", "_markerCoreName", "_markerName", "_instanceNo", "_marker", "_minEnemies", "_maxEnemies", "_chosenComCenIndexes", "_index", "_comCenPositions", "_comCenItem", "_distanceBetween", "_currentPos", "_tooClose", "_pos", "_scriptHandle"];

    call compile preprocessFileLineNumbers ("Scripts\Escape\CommunicationCenterMarkers" + worldName + ".sqf");
    
    _comCenMarkerNames = [];
    _comCenNo = 1;
    _markerCoreName = "drn_var_communicationCenter";
    _markerName = _markerCoreName + str _comCenNo;
    _chosenComCenIndexes = [];

    _distanceBetween = 1500;
    
    while {count _chosenComCenIndexes < 5} do {
        _index = floor random count drn_arr_communicationCenterMarkers;
        _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;
        
        // North west
        if (count _chosenComCenIndexes == 0) then {
            while {_currentPos select 0 > (getMarkerPos "center") select 0 || _currentPos select 1 < (getMarkerPos "center") select 1} do {
                _index = floor random count drn_arr_communicationCenterMarkers;
                _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;
            };
        };
        // North east
        if (count _chosenComCenIndexes == 1) then {
            while {_currentPos select 0 < (getMarkerPos "center") select 0 || _currentPos select 1 < (getMarkerPos "center") select 1} do {
                _index = floor random count drn_arr_communicationCenterMarkers;
                _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;
            };
        };
        // South east
        if (count _chosenComCenIndexes == 2) then {
            while {_currentPos select 0 < (getMarkerPos "center") select 0 || _currentPos select 1 > (getMarkerPos "center") select 1} do {
                _index = floor random count drn_arr_communicationCenterMarkers;
                _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;
            };
        };
        // South west
        if (count _chosenComCenIndexes == 3) then {
            while {_currentPos select 0 > (getMarkerPos "center") select 0 || _currentPos select 1 > (getMarkerPos "center") select 1} do {
                _index = floor random count drn_arr_communicationCenterMarkers;
                _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;
            };
        };
        
        if (!(_index in _chosenComCenIndexes)) then {
            _currentPos = (drn_arr_communicationCenterMarkers select _index) select 0;

            _tooClose = false;
            {
                _pos = (drn_arr_communicationCenterMarkers select _x) select 0;
                if (_pos distance _currentPos < _distanceBetween) then {
                    _tooClose = true;
                };
                if (_useRandomStartPos && _currentPos distance drn_startPos < _distanceBetween) then {
                    _tooClose = true;
                };
            } foreach _chosenComCenIndexes;
            
            if (!_tooClose) then {
                _chosenComCenIndexes set [count _chosenComCenIndexes, _index];
            };
        };
    };
    
    // Unmark this if you want communication centers everywhere
    /*
    _i = 0;
    {
        _chosenComCenIndexes set [_i, _i];
        _i = _i + 1;
    } foreach drn_arr_communicationCenterMarkers;
    */
    
    _instanceNo = 0;
    
    switch (_enemyFrequency) do
    {
        case 1: // 1-2 players
        {
            _minEnemies = 8;
            _maxEnemies = 12;
        };
        case 2: // 3-5 players
        {
            _minEnemies = 12;
            _maxEnemies = 16;
        };
        default // 6-8 players
        {
            _minEnemies = 16;
            _maxEnemies = 24;
        };
    };
    
    _comCenPositions = [];
    
    {
        private ["_index"];
        private ["_pos", "_dir"];
        
        _index = _x;
        _comCenItem = drn_arr_communicationCenterMarkers select _index;
        
        _pos = _comCenItem select 0;
        _dir = _comCenItem select 1;
        _comCenPositions set [count _comCenPositions, _pos];
        
        _scriptHandle = [_pos, _dir, drn_arr_ComCenStaticWeapons, drn_arr_ComCenParkedVehicles] execVM "Scripts\Escape\BuildCommunicationCenter.sqf";
        waitUntil {scriptDone _scriptHandle};
        
        _marker = createMarker ["drn_CommunicationCenterMapMarker" + str _instanceNo, _pos];
        _marker setMarkerType "Faction_INS";
        
        _marker = createMarkerLocal ["drn_CommunicationCenterPatrolMarker" + str _instanceNo, _pos];
        _marker setMarkerShapeLocal "ELLIPSE";
        _marker setMarkerAlpha 0;
        _marker setMarkerSizeLocal [75, 75];
        
        _instanceNo = _instanceNo + 1;
    } foreach _chosenComCenIndexes;
    
    if (_comCenGuardsExist) then {
        _scriptHandle = [_playerGroup, "drn_CommunicationCenterPatrolMarker", drn_var_enemySide, "INS", 4, _minEnemies, _maxEnemies, _enemyMinSkill, _enemyMaxSkill, _enemySpawnDistance] execVM "Scripts\DRN\DynamicGuardedLocations\InitGuardedLocations.sqf";
        waitUntil {scriptDone _scriptHandle};
    };
    
    drn_var_Escape_communicationCenterPositions = _comCenPositions;
    publicVariable "drn_var_Escape_communicationCenterPositions";
    
    // Initialize armor defence at communication centers
    
    if (_comCenGuardsExist) then {
        [_playerGroup, _comCenPositions, _enemySpawnDistance, _enemyFrequency] call drn_fnc_Escape_InitializeComCenArmor;
    };
};

// Initialize ammo depots
if (_useAmmoDepots) then {
    [_enemyMinSkill, _enemyMaxSkill, _debugAmmoDepots, _enemySpawnDistance, _playerGroup, _enemyFrequency] spawn {
        private ["_enemyMinSkill", "_enemyMaxSkill", "_debugAmmoDepots", "_enemySpawnDistance", "_playerGroup", "_enemyFrequency"];
        private ["_playerGroup", "_minEnemies", "_maxEnemies", "_bannedPositions", "_scriptHandle"];
        
        _enemyMinSkill = _this select 0;
        _enemyMaxSkill = _this select 1;
        _debugAmmoDepots = _this select 2;
        _enemySpawnDistance = _this select 3;
        _playerGroup = _this select 4;
        _enemyFrequency = _this select 5;
        
        _bannedPositions = + drn_var_Escape_communicationCenterPositions + [drn_startPos, getMarkerPos "drn_insurgentAirfieldMarker"];
        drn_var_Escape_ammoDepotPositions = _bannedPositions call drn_fnc_Escape_FindAmmoDepotPositions;
        publicVariable "drn_var_Escape_ammoDepotPositions";
        
        for "_i" from 0 to (count drn_var_Escape_ammoDepotPositions) - 1 do {
            sleep 1;
            [drn_var_Escape_ammoDepotPositions select _i, drn_arr_Escape_AmmoDepot_StaticWeaponClasses, drn_arr_Escape_AmmoDepot_ParkedVehicleClasses] call drn_fnc_Escape_BuildAmmoDepot;
        };
        
        switch (_enemyFrequency) do
        {
            case 1: // 1-2 players
            {
                _minEnemies = 6;
                _maxEnemies = 8;
            };
            case 2: // 3-5 players
            {
                _minEnemies = 8;
                _maxEnemies = 12;
            };
            default // 6-8 players
            {
                _minEnemies = 12;
                _maxEnemies = 18;
            };
        };
        
        _scriptHandle = [_playerGroup, "drn_AmmoDepotPatrolMarker", drn_var_enemySide, "INS", 3, _minEnemies, _maxEnemies, _enemyMinSkill, _enemyMaxSkill, _enemySpawnDistance, _debugAmmoDepots] execVM "Scripts\DRN\DynamicGuardedLocations\InitGuardedLocations.sqf";
        waitUntil {scriptDone _scriptHandle};
    };
};

// Initialize search leader
if (_useSearchLeader) then {
    [drn_searchAreaMarkerName, _debugSearchLeader] execVM "Scripts\Escape\SearchLeader.sqf";
};

// Create motorized search group
if (_useMotorizedSearchGroup) then {
    [_enemyFrequency, _enemyMinSkill, _enemyMaxSkill] spawn {
        private ["_enemyFrequency", "_enemyMinSkill", "_enemyMaxSkill"];
        private ["_spawnSegment"];
        
        _enemyFrequency = _this select 0;
        _enemyMinSkill = _this select 1;
        _enemyMaxSkill = _this select 2;
        
        _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
        while {(str _spawnSegment) == """NULL"""} do {
            _spawnSegment = [(call drn_fnc_Escape_GetPlayerGroup), 1500, 2000] call drn_fnc_Escape_FindSpawnSegment;
            sleep 1;
        };
        
        [getPos _spawnSegment, drn_searchAreaMarkerName, _enemyFrequency, _enemyMinSkill, _enemyMaxSkill, drn_var_Escape_debugMotorizedSearchGroup] execVM "Scripts\Escape\CreateMotorizedSearchGroup.sqf";
    };
};

// Start garbage collector
[_playerGroup, 750, _debugGarbageCollector] spawn drn_fnc_CL_RunGarbageCollector;

// Run initialization for scripts that need the players to be gathered at the start position
[_useVillagePatrols, _useMilitaryTraffic, _useAmbientInfantry, _debugVillagePatrols, _debugMilitaryTraffic, _debugAmbientInfantry, _enemyMinSkill, _enemyMaxSkill, _enemySpawnDistance, _enemyFrequency, _useRoadBlocks, _debugRoadBlocks] spawn {
    private ["_useVillagePatrols", "_useMilitaryTraffic", "_useAmbientInfantry", "_debugVillagePatrols", "_debugMilitaryTraffic", "_debugAmbientInfantry", "_enemyMinSkill", "_enemyMaxSkill", "_enemySpawnDistance", "_enemyFrequency", "_useRoadBlocks", "_debugRoadBlocks"];
    private ["_fnc_OnSpawnAmbientInfantryGroup", "_fnc_OnSpawnAmbientInfantryUnit", "_scriptHandle"];
    private ["_playerGroup", "_minEnemiesPerGroup", "_maxEnemiesPerGroup", "_fnc_OnSpawnGroup"];
    
    _useVillagePatrols = _this select 0;
    _useMilitaryTraffic = _this select 1;
    _useAmbientInfantry = _this select 2;
    _debugVillagePatrols = _this select 3;
    _debugMilitaryTraffic = _this select 4;
    _debugAmbientInfantry = _this select 5;
    _enemyMinSkill = _this select 6;
    _enemyMaxSkill = _this select 7;
    _enemySpawnDistance = _this select 8;
    _enemyFrequency = _this select 9;
    _useRoadBlocks = _this select 10;
    _debugRoadBlocks = _this select 11;
    
    waitUntil {[drn_startPos] call drn_fnc_Escape_AllPlayersOnStartPos};
    _playerGroup = group ((call drn_fnc_Escape_GetPlayers) select 0);
    
    if (_useVillagePatrols) then {
        switch (_enemyFrequency) do
        {
            case 1: // 1-2 players
            {
                _minEnemiesPerGroup = 2;
                _maxEnemiesPerGroup = 4;
            };
            case 2: // 3-5 players
            {
                _minEnemiesPerGroup = 3;
                _maxEnemiesPerGroup = 6;
            };
            default // 6-8 players
            {
                _minEnemiesPerGroup = 4;
                _maxEnemiesPerGroup = 8;
            };
        };
        
        _fnc_OnSpawnGroup = {
            {
                _x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
            } foreach units _this;
        };
        
        _scriptHandle = [(units _playerGroup) select 0, drn_var_enemySide, drn_arr_Escape_InfantryTypes, _minEnemiesPerGroup, _maxEnemiesPerGroup, 5000, _enemyMinSkill, _enemyMaxSkill, _enemySpawnDistance + 250, _fnc_OnSpawnGroup, _debugVillagePatrols] execVM "Scripts\DRN\VillagePatrols\InitVillagePatrols.sqf";
        waitUntil {scriptDone _scriptHandle};
    };
    
    // Initialize ambient infantry groups
    if (_useAmbientInfantry) then {
        
        _fnc_OnSpawnAmbientInfantryUnit = {
            _this setVehicleAmmo (0.3 + random 0.7);
            _this removeWeapon "ItemGPS";
            _this removeWeapon "ItemMap";
            _this removeWeapon "ItemCompass";
            
            if (random 100 > 75) then {
                _this addWeapon "ItemMap";
                if (random 100 > 67) then {
                    _this addWeapon "ItemCompass";
                };
            };
        };
        
        _fnc_OnSpawnAmbientInfantryGroup = {
            private ["_unit", "_enemyUnit", "_i"];
            private ["_scriptHandle"];
            
            _unit = units _this select 0;
            
            while {!(isNull _unit)} do {
                _enemyUnit = _unit findNearestEnemy (getPos _unit);
                if (!(isNull _enemyUnit)) exitWith {
                    
                    for [{_i = (count waypoints _this) - 1}, {_i >= 0}, {_i = _i - 1}] do {
                        deleteWaypoint [_this, _i];
                    };
                    
                    _scriptHandle = [_this, drn_searchAreaMarkerName, (getPos _enemyUnit), drn_var_Escape_DebugSearchGroup] execVM "Scripts\DRN\SearchGroup\SearchGroup.sqf";
                    _this setVariable ["drn_scriptHandle", _scriptHandle];
                };
                
                sleep 5;
            };
        };
        
        private ["_infantryTypes"];
        private ["_infantryGroupsCount", "_radius", "_groupsPerSqkm"];

        switch (_enemyFrequency) do
        {
            case 1: // 1-2 players
            {
                _minEnemiesPerGroup = 2;
                _maxEnemiesPerGroup = 4;
                _groupsPerSqkm = 1;
            };
            case 2: // 3-5 players
            {
                _minEnemiesPerGroup = 2;
                _maxEnemiesPerGroup = 8;
                _groupsPerSqkm = 1.2;
            };
            default // 6-8 players
            {
                _minEnemiesPerGroup = 2;
                _maxEnemiesPerGroup = 12;
                _groupsPerSqkm = 1.4;
            };
        };

        _radius = (_enemySpawnDistance + 500) / 1000;
        _infantryGroupsCount = round (_groupsPerSqkm * _radius * _radius * 3.141592);
        
        [_playerGroup, drn_var_enemySide, drn_arr_Escape_InfantryTypes, _infantryGroupsCount, _enemySpawnDistance + 200, _enemySpawnDistance + 500, _minEnemiesPerGroup, _maxEnemiesPerGroup, _enemyMinSkill, _enemyMaxSkill, 750, _fnc_OnSpawnAmbientInfantryUnit, _fnc_OnSpawnAmbientInfantryGroup, _debugAmbientInfantry] execVM "Scripts\DRN\AmbientInfantry\AmbientInfantry.sqf";
        sleep 0.25;
    };
    
    // Initialize the Escape military and civilian traffic
    if (_useMilitaryTraffic) then {
        private ["_vehiclesPerSqkm", "_radius", "_vehiclesCount", "_fnc_onSpawnCivilian", "_vehicleClasses"];
        
        // Civilian traffic
        
        switch (_enemyFrequency) do
        {
            case 1: // 1-3 players
            {
                _vehiclesPerSqkm = 1.6;
            };
            case 2: // 4-6 players
            {
                _vehiclesPerSqkm = 1.4;
            };
            default // 7-8 players
            {
                _vehiclesPerSqkm = 1.2;
            };
        };
        
        _radius = _enemySpawnDistance + 500;
        _vehiclesCount = round (_vehiclesPerSqkm * (_radius / 1000) * (_radius / 1000) * 3.141592);
        
        _fnc_onSpawnCivilian = {
            private ["_vehicle", "_crew"];
            _vehicle = _this select 0;
            _crew = _this select 1;
            //_vehiclesGroup = _result select 2;
            
            {
                {
                    _x removeWeapon "ItemMap";
                } foreach _crew; // foreach crew
                
                _x addeventhandler ["killed",{
                    if ((_this select 1) in (call drn_fnc_Escape_GetPlayers)) then {
                        drn_var_Escape_SearchLeader_civilianReporting = true;
                        publicVariable "drn_var_Escape_SearchLeader_civilianReporting";
                        (_this select 1) addScore -4;
                        [name (_this select 1) + " has killed a civilian."] call drn_fnc_CL_ShowCommandTextAllClients;
                    }
                }];
            } foreach _crew;
            
            if (random 100 < 20) then {
                private ["_index", "_weaponItem"];
                
                _index = floor random count drn_arr_CivilianCarWeapons;
                _weaponItem = drn_arr_CivilianCarWeapons select _index;
                
                _vehicle addWeaponCargoGlobal [_weaponItem select 0, 1];
                _vehicle addMagazineCargoGlobal [_weaponItem select 1, _weaponItem select 2];
            };
        };
        
        [_playerGroup, civilian, drn_arr_Escape_MilitaryTraffic_CivilianVehicleClasses, _vehiclesCount, _enemySpawnDistance, _radius, 0.5, 0.5, _fnc_onSpawnCivilian, _debugMilitaryTraffic] execVM "Scripts\DRN\MilitaryTraffic\MilitaryTraffic.sqf";
        sleep 0.25;
        
        // Enemy military traffic
        
        switch (_enemyFrequency) do
        {
            case 1: // 1-3 players
            {
                _vehiclesPerSqkm = 0.6;
            };
            case 2: // 4-6 players
            {
                _vehiclesPerSqkm = 0.8;
            };
            default // 7-8 players
            {
                _vehiclesPerSqkm = 1;
            };
        };
        
        _radius = _enemySpawnDistance + 500;
        _vehiclesCount = round (_vehiclesPerSqkm * (_radius / 1000) * (_radius / 1000) * 3.141592);
        [_playerGroup, drn_var_enemySide, drn_arr_Escape_MilitaryTraffic_EnemyVehicleClasses, _vehiclesCount, _enemySpawnDistance, _radius, _enemyMinSkill, _enemyMaxSkill, drn_fnc_Escape_TrafficSearch, _debugMilitaryTraffic] execVM "Scripts\DRN\MilitaryTraffic\MilitaryTraffic.sqf";
        sleep 0.25;
    };
    
    if (_useRoadBlocks) then {
        private ["_areaPerRoadBlock", "_maxEnemySpawnDistanceKm", "_roadBlockCount"];
        private ["_fnc_OnSpawnInfantryGroup", "_fnc_OnSpawnMannedVehicle"];
        
        _fnc_OnSpawnInfantryGroup = {{_x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;} foreach units _this;};
        _fnc_OnSpawnMannedVehicle = {{_x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;} foreach (_this select 1);};
        
        switch (_enemyFrequency) do {
            case 1: {
                _areaPerRoadBlock = 4.19;
            };
            case 2: {
                _areaPerRoadBlock = 3.14;
            };
            default {
                _areaPerRoadBlock = 2.5;
            };
        };
        
        _maxEnemySpawnDistanceKm = (_enemySpawnDistance + 500) / 1000;
        _roadBlockCount = round ((_maxEnemySpawnDistanceKm * _maxEnemySpawnDistanceKm * 3.141592) / _areaPerRoadBlock);
        
        if (_roadBlockCount < 1) then {
            _roadBlockCount = 1;
        };
        
        [_playerGroup, drn_var_enemySide, drn_arr_Escape_InfantryTypes, drn_arr_Escape_RoadBlock_MannedVehicleTypes, _roadBlockCount, _enemySpawnDistance, _enemySpawnDistance + 500, 500, 300, _fnc_OnSpawnInfantryGroup, _fnc_OnSpawnMannedVehicle, _debugRoadBlocks] execVM "Scripts\DRN\RoadBlocks\RoadBlocks.sqf";
        sleep 0.25;
    };
};

// Create search chopper
if (_useSearchChopper) then {
    private ["_scriptHandle"];
    _scriptHandle = [getMarkerPos "drn_searchChopperStartPosMarker", drn_var_enemySide, drn_searchAreaMarkerName, _searchChopperSearchTimeMin, _searchChopperRefuelTimeMin, _enemyMinSkill, _enemyMaxSkill, [], drn_var_Escape_debugSearchChopper] execVM "Scripts\Escape\CreateSearchChopper.sqf";
    waitUntil {scriptDone _scriptHandle};
};

// Spawn creation of start position settings
[drn_startPos, _enemyMinSkill, _enemyMaxSkill, _guardsAreArmed, _guardsExist, _guardLivesLong, _enemyFrequency, _fenceRotateDir] spawn {
    private ["_startPos", "_enemyMinSkill", "_enemyMaxSkill", "_guardsAreArmed", "_guardsExist", "_guardLivesLong", "_enemyFrequency", "_fenceRotateDir"];
    private ["_i", "_guard", "_guardGroup", "_marker", "_guardCount", "_guardGroups", "_unit", "_createNewGroup", "_guardPos"];
    
    _startPos = _this select 0;
    _enemyMinSkill = _this select 1;
    _enemyMaxSkill = _this select 2;
    _guardsAreArmed = _this select 3;
    _guardsExist = _this select 4;
    _guardLivesLong = _this select 5;
    _enemyFrequency = _this select 6;
    _fenceRotateDir = _this select 7;
    
    // Spawn guard
    _guardGroup = createGroup drn_var_enemySide;
    _guardPos = [_startPos, [(_startPos select 0) - 4, (_startPos select 1) + 4, 0], _fenceRotateDir] call drn_fnc_CL_RotatePosition;
    (drn_arr_Escape_StartPositionGuardTypes select floor (random count drn_arr_Escape_StartPositionGuardTypes)) createUnit [_guardPos, _guardGroup, "", (0.5), "CAPTAIN"];
    _guard = units _guardGroup select 0;
    _guard disableAI "MOVE";
    _guard setDir _fenceRotateDir + 125;
    _guard setVehicleAmmo 0.3 + random 0.7;
    _guard removeWeapon "ItemMap";
    _guard removeWeapon "ItemCompass";
    _guard removeWeapon "ItemGPS";
    _guard setSkill _enemyMinSkill + random (_enemyMaxSkill - _enemyMinSkill);
    
    _guard addMagazine drn_var_Escape_InnerFenceGuardSecondaryWeaponMagazine;
    _guard addMagazine drn_var_Escape_InnerFenceGuardSecondaryWeaponMagazine;
    _guard addMagazine drn_var_Escape_InnerFenceGuardSecondaryWeaponMagazine;
    if (random 100 < 50) then {
        _guard addMagazine drn_var_Escape_InnerFenceGuardSecondaryWeaponMagazine;
    };
    _guard addWeapon drn_var_Escape_InnerFenceGuardSecondaryWeapon;
    
    if (random 100 < 40) then {
        _guard addweapon "NVGoggles";
    };
    
    // Spawn more guards
    _marker = createMarkerLocal ["drn_guardAreaMarker", _startPos];
    _marker setMarkerAlpha 0;
    _marker setMarkerShapeLocal "ELLIPSE";
    _marker setMarkerSizeLocal [50, 50];
    
    if (_guardsExist) then {
        _guardCount = (4 + (_enemyFrequency)) + floor (random 2);
    }
    else {
        _guardCount = 0;
    };
    _guardGroups = [];
    _createNewGroup = true;
    
    for [{_i = 0}, {_i < _guardCount}, {_i = _i + 1}] do {
        private ["_pos"];
        
        _pos = [_marker] call drn_fnc_CL_GetRandomMarkerPos;
        while {_pos distance _startPos < 10} do {
            _pos = [_marker] call drn_fnc_CL_GetRandomMarkerPos;
        };
        
        if (_createNewGroup) then {
            _guardGroup = createGroup drn_var_enemySide;
            _guardGroups set [count _guardGroups, _guardGroup];
            _createNewGroup = false;
        };
        
        (drn_arr_Escape_StartPositionGuardTypes select floor (random count drn_arr_Escape_StartPositionGuardTypes)) createUnit [_pos, _guardGroup, "", (0.5), "CAPTAIN"];
        
        if (count units _guardGroup >= 2) then {
            _createNewGroup = true;
        };
    };
    
    {
        _guardGroup = _x;
        
        _guardGroup setFormDir floor (random 360);
        
        {
            _unit = _x; //(units _guardGroup) select 0;
            _unit removeWeapon "ItemMap";
            _unit removeWeapon "ItemCompass";
            _unit removeWeapon "ItemGPS";
            
            if (random 100 < 40) then {
                _unit addweapon "NVGoggles";
            };
            
            _unit setSkill _enemyMinSkill + random (_enemyMaxSkill - _enemyMinSkill);
            _unit removeMagazines "Handgrenade_East";
            
            if (_guardsAreArmed) then {
                _unit setVehicleAmmo 0.3 + random 0.7;
            }
            else {
                removeAllWeapons _unit;
            };
        } foreach units _guardGroup;
        
        [_guardGroup, _marker] execVM "Scripts\DRN\SearchGroup\SearchGroup.sqf";
        
    } foreach _guardGroups;
    
    sleep 0.5;
    
    drn_startPos = _startPos;
    publicVariable "drn_startPos";
    
    // Start thread that waits for escape to start
    [_guardGroups, _startPos] spawn {
        private ["_guardGroups", "_startPos"];
        
        _guardGroups = _this select 0;
        _startPos = _this select 1;
        
        sleep 5;
        
        while {isNil "drn_escapeHasStarted"} do {
            // If any member of the group is to far away from fence, then escape has started
            {
                if (!(_x getVariable ["drn_var_initializing", true])) then {
                    if ((_x distance _startPos) > 25 && (_x distance _startPos) < 150) exitWith {
                        drn_escapeHasStarted = true;
                        publicVariable "drn_escapeHasStarted";
                    };
                };
            } foreach call drn_fnc_Escape_GetPlayers;
            
            // If any player have picked up a weapon, escape has started
            {
                if (!(_x getVariable ["drn_var_initializing", true])) then {
                    if (_x hasWeapon "ItemMap") then {
                        if (count weapons _x > 4 || count magazines _x > 0) exitWith {
                            drn_escapeHasStarted = true;
                            publicVariable "drn_escapeHasStarted";
                        };
                    }
                    else {
                        if (count weapons _x > 2 || count magazines _x > 0) exitWith {
                            drn_escapeHasStarted = true;
                            publicVariable "drn_escapeHasStarted";
                        };
                    };
                };
            } foreach call drn_fnc_Escape_GetPlayers;
            
            sleep 1;
        };
        
        // ESCAPE HAS STARTED
        
        {
            _x setCaptive false;
        } foreach call drn_fnc_Escape_GetPlayers;
        
        sleep (5 + random 7);
        
        {
            private ["_guardGroup"];
            
            _guardGroup = _x;
            
            {
                _guardGroup reveal _x;
            } foreach call drn_fnc_Escape_GetPlayers;
        } foreach _guardGroups;
    };
    
    if (_guardLivesLong) then {
        sleep (30 + floor (random 40));
    }
    else {
        sleep 10;
    };
    
    // Guard passes out
    _guard setDamage 1;
};



