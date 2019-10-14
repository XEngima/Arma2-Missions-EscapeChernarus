private ["_referenceGroup", "_side", "_infantryClasses", "_mannedVehicleClasses", "_numberOfRoadBlocks", "_minSpawnDistance", "_maxSpawnDistance", "_minDistanceBetweenRoadBlocks", "_minSpawnDistanceAtStartup", "_fnc_OnSpawnInfantryGroup", "_fnc_OnSpawnMannedVehicle", "_debug"];
private ["_roadBlocks", "_roadSegment", "_roadBlockItem", "_roadBlocksDeleted", "_instanceNo", "_tempRoadBlocks", "_farAway", "_units", "_group", "_firstLoop", "_minDistance", "_isFaction"];
private ["_possibleInfantryTypes", "_possibleVehicleTypes", "_fnc_FindRoadBlockSegment", "_fnc_CreateRoadBlock"];

_referenceGroup = _this select 0;
if (count _this > 1) then { _side = _this select 1; } else { _side = west; };
if (count _this > 2) then { _infantryClasses = _this select 2; } else { _infantryClasses = "USMC"; };
if (count _this > 3) then { _mannedVehicleClasses = _this select 3; } else { _mannedVehicleClasses = "USMC"; };
if (count _this > 4) then { _numberOfRoadBlocks = _this select 4; } else { _numberOfRoadBlocks = 10; };
if (count _this > 5) then { _minSpawnDistance = _this select 5; } else { _minSpawnDistance = 1500; };
if (count _this > 6) then { _maxSpawnDistance = _this select 6; } else { _maxSpawnDistance = 2000; };
if (count _this > 7) then { _minDistanceBetweenRoadBlocks = _this select 7; } else { _minDistanceBetweenRoadBlocks = 500; };
if (count _this > 8) then { _minSpawnDistanceAtStartup = _this select 8; } else { _minSpawnDistanceAtStartup = 300; };
if (count _this > 9) then { _fnc_OnSpawnInfantryGroup = _this select 9; } else { _fnc_OnSpawnInfantryGroup = {}; };
if (count _this > 10) then { _fnc_OnSpawnMannedVehicle = _this select 10; } else { _fnc_OnSpawnMannedVehicle = {}; };
if (count _this > 11) then { _debug = _this select 11; } else { _debug = false; };

_isFaction = false;
if (str _infantryClasses == """USMC""") then {
    _possibleInfantryTypes = ["USMC_Soldier_HAT", "USMC_Soldier_AT", "USMC_Soldier_AR", "USMC_Soldier_Medic", "USMC_SoldierM_Marksman", "USMC_SoldierS_Engineer", "USMC_Soldier_TL", "USMC_Soldier_GL", "USMC_Soldier_MG", "USMC_Soldier_Officer", "USMC_Soldier", "USMC_Soldier2", "USMC_Soldier_LAT"];
    _isFaction = true;
};
if (str _infantryClasses == """CDF""") then {
    _possibleInfantryTypes = ["CDF_Soldier_RPG", "CDF_Soldier_AR", "CDF_Soldier_GL", "CDF_Soldier_MG", "CDF_Soldier_Marksman", "CDF_Soldier_Medic", "CDF_Soldier_Militia", "CDF_Soldier_Officer", "CDF_Soldier"];
    _isFaction = true;
};
if (str _infantryClasses == """RU""") then {
    _possibleInfantryTypes = ["RU_Soldier_HAT", "RU_Soldier_AR", "RU_Soldier_GL", "RU_Soldier_MG", "RU_Soldier_Marksman", "RU_Soldier_Medic", "RU_Soldier", "RU_Soldier_LAT", "RU_Soldier_AT", "RU_Soldier2"];
    _isFaction = true;
};
if (str _infantryClasses == """INS""") then {
    _possibleInfantryTypes = ["Ins_Soldier_AT", "Ins_Soldier_AR", "Ins_Soldier_GL", "Ins_Soldier_MG", "Ins_Soldier_Medic", "Ins_Soldier_1", "Ins_Soldier_2"];
    _isFaction = true;
};
if (str _infantryClasses == """GUE""") then {
    _possibleInfantryTypes = ["GUE_Soldier_AR", "GUE_Soldier_GL", "GUE_Soldier_MG", "GUE_Soldier_Medic", "GUE_Soldier_3", "GUE_Soldier_2", "GUE_Soldier_1", "GUE_Soldier_AT"];
    _isFaction = true;
};

if (!_isFaction) then {
    _possibleInfantryTypes =+ _infantryClasses;
};

_isFaction = false;
if (str _mannedVehicleClasses == """USMC""") then {
    _possibleVehicleTypes = ["HMMWV", "HMMWV_M2", "HMMWV_Armored", "HMMWV_MK19", "HMMWV_TOW", "HMMWV_Avenger", "MTVR", "AAV", "LAV25", "LAV25_HQ", "M1A1", "M1A2_TUSK_MG", "M119", "M2StaticMG", "M252", "M2HD_mini_TriPod", "MK19_TriPod", "TOW_TriPod"];
    _isFaction = true;
};
if (str _mannedVehicleClasses == """CDF""") then {
    _possibleVehicleTypes = ["UAZ_CDF", "UAZ_AGS30_CDF", "UAZ_MG_CDF", "BMP2_CDF", "BMP2_HQ_CDF", "BRDM2_CDF", "BRDM2_ATGM_CDF", "T72_CDF", "ZSU_CDF", "AGS_CDF", "DSHKM_CDF", "DSHkM_Mini_TriPod_CDF", "SPG9_CDF"];
    _isFaction = true;
};
if (str _mannedVehicleClasses == """RU""") then {
    _possibleVehicleTypes = ["UAZ_RU", "UAZ_AGS30_RU", "2S6M_Tunguska", "BMP3", "BTR90", "BTR90_HQ", "T72_RU", "T90", "GAZ_Vodnik", "GAZ_Vodnik_HMG", "AGS_RU", "KORD_high", "KORD", "Metis"];
    _isFaction = true;
};
if (str _mannedVehicleClasses == """INS""") then {
    _possibleVehicleTypes = ["Offroad_DSHKM_INS", "Pickup_PK_INS", "UAZ_INS", "UAZ_AGS30_INS", "UAZ_MG_INS", "UAZ_SPG9_INS", "BMP2_INS", "BMP2_HQ_INS", "BRDM2_INS", "BRDM2_ATGM_INS", "T72_INS", "ZSU_INS", "AGS_Ins", "DSHKM_Ins", "DSHkM_Mini_TriPod", "SPG9_Ins"];
    _isFaction = true;
};
if (str _mannedVehicleClasses == """GUE""") then {
    _possibleVehicleTypes = ["Offroad_DSHKM_Gue", "Offroad_SPG9_Gue", "Pickup_PK_GUE", "V3S_Gue", "BMP2_Gue", "BRDM2_Gue", "BRDM2_HQ_Gue", "T34", "T72_Gue", "DSHKM_Gue", "SPG9_Gue"];
    _isFaction = true;
};

if (!_isFaction) then {
    _possibleVehicleTypes =+ _mannedVehicleClasses;
};

_roadBlocks = [];

_fnc_FindRoadBlockSegment = {
    private ["_roadBlocks", "_referenceGroup", "_minSpawnDistance", "_maxSpawnDistance", "_minDistanceBetweenRoadBlocks"];
    private ["_refUnit", "_roadSegments", "_roadSegment", "_isOk", "_tries", "_result", "_spawnDistanceDiff", "_refPosX", "_refPosY", "_dir", "_tooClose", "_tooFarAwayFromAll"];

    _roadBlocks = _this select 0;
    _referenceGroup = _this select 1;
    _minSpawnDistance = _this select 2;
    _maxSpawnDistance = _this select 3;
    _minDistanceBetweenRoadBlocks = _this select 4;
    
    _spawnDistanceDiff = _maxSpawnDistance - _minSpawnDistance;
    _roadSegment = objNull;
    _refUnit = vehicle ((units _referenceGroup) select floor random count units _referenceGroup);
    
    _isOk = false;
    _tries = 0;
    while {!_isOk && _tries < 100} do {
        _isOk = true;
        
        _dir = random 360;
        _refPosX = ((getPos _refUnit) select 0) + (_minSpawnDistance + _spawnDistanceDiff) * sin _dir;
        _refPosY = ((getPos _refUnit) select 1) + (_minSpawnDistance + _spawnDistanceDiff) * cos _dir;
        
        _roadSegments = [_refPosX, _refPosY] nearRoads (_spawnDistanceDiff);
        _roadSegment = _roadSegments select floor random count _roadSegments;
        
        // Check if road segment is at spawn distance
        _tooFarAwayFromAll = true;
        _tooClose = false;
        {
            private ["_tooFarAway"];
            
            _tooClose = false;
            _tooFarAway = false;
            
            if ((vehicle _x) distance (getPos _roadSegment) < _minSpawnDistance) then {
                _tooClose = true;
            };
            if ((vehicle _x) distance (getPos _roadSegment) > _maxSpawnDistance) then {
                _tooFarAway = true;
            };
            if (!_tooFarAway) then {
                _tooFarAwayFromAll = false;
            };
        } foreach units _referenceGroup;
        
        if (_tooClose || _tooFarAwayFromAll) then {
            _isOk = false;
        };
        
        // Check if road segment is not close to a house
        if ((nearestBuilding _roadSegment) distance _roadSegment < 50) then {
            _isOk = false;
        };
        
        // Check if road segment is not too close to another road block
        {
            private ["_anotherSegment"];
            _anotherSegment = _x select 1;
            
            if (_roadSegment distance _anotherSegment < _minDistanceBetweenRoadBlocks) then {
                _isOk = false;
            };
        } foreach _roadBlocks;
        
        _tries = _tries + 1;
    };
    
    if (!_isOk) then {
        _result = objNull;
    }
    else {
        _result = _roadSegment;
    };
    
    _result
};

_fnc_CreateRoadBlock = {
    private ["_roadSegment", "_side", "_possibleInfantryTypes", "_possibleVehicleTypes", "_fnc_OnSpawnInfantryGroup", "_fnc_OnSpawnMannedVehicle"];
    private ["_dir", "_pos", "_angle", "_posX", "_posY", "_result", "_group", "_barrier", "_guardTypes", "_units", "_vehicle", "_crew", "_possibleVehicles"];
    
    _roadSegment = _this select 0;
    _side = _this select 1;
    _possibleInfantryTypes = _this select 2;
    _possibleVehicleTypes = _this select 3;
    _fnc_OnSpawnInfantryGroup = _this select 4;
    _fnc_OnSpawnMannedVehicle = _this select 5;
    
    _units = [];
    
    _dir = direction _roadSegment;
    _pos = getPos _roadSegment;
    
    if (random 100 < 50) then {
        _angle = 90;
    }
    else {
        _angle = -90;
    };
    
    _posX = (getPos _roadSegment) select 0;
    _posY = (getPos _roadSegment) select 1;
    
    _posX = _posX + 7.5 * sin (_dir + _angle);
    _posY = _posY + 7.5 * cos (_dir + _angle);
    _pos = [_posX, _posY];

    _possibleVehicles = _possibleVehicleTypes;
    _result = [_pos, _dir, _possibleVehicles select floor random count _possibleVehicles, _side] call BIS_fnc_spawnVehicle;
    _vehicle = _result select 0;
    _crew = _result select 1;
    _group = _result select 2;
    
    _units = _units + [_vehicle];
    _units = _units + _crew;
    
    //_waypoint = _group addWaypoint [_pos, 0];
    //_waypoint setWaypointType "MOVE";
    //_waypoint setWaypointBehaviour "AWARE";
    //_waypoint setWaypointCombatMode "RED";
    
    _result spawn _fnc_OnSpawnMannedVehicle;
    
    _posX = (getPos _roadSegment) select 0;
    _posY = (getPos _roadSegment) select 1;
    
    _posX = _posX + 7.5 * sin (_dir - _angle);
    _posY = _posY + 7.5 * cos (_dir - _angle);
    _pos = [_posX, _posY];
    
    _barrier = "RoadBarrier_light" createVehicle _pos;
    _barrier setDir (_dir);
    _units = _units + [_barrier];
    
    _posX = (getPos _roadSegment) select 0;
    _posY = (getPos _roadSegment) select 1;
    
    _posX = _posX + 11 * sin (_dir - _angle);
    _posY = _posY + 11 * cos (_dir - _angle);
    _pos = [_posX, _posY];
    
    _group = createGroup _side;
    _guardTypes = _possibleInfantryTypes;
    (_guardTypes select floor random count _guardTypes) createUnit [_pos, _group, "", 0.5, "LIEUTNANT"];
    (_guardTypes select floor random count _guardTypes) createUnit [_pos, _group, "", 0.5, "LIEUTNANT"];
    (_guardTypes select floor random count _guardTypes) createUnit [_pos, _group, "", 0.5, "LIEUTNANT"];
    (_guardTypes select floor random count _guardTypes) createUnit [_pos, _group, "", 0.5, "LIEUTNANT"];
    
    _units = _units + units _group;
    
    //_waypoint = _group addWaypoint [_pos, 0];
    //_waypoint setWaypointType "MOVE";
    //_waypoint setWaypointBehaviour "AWARE";
    //_waypoint setWaypointCombatMode "YELLOW";
    
    _group spawn _fnc_OnSpawnInfantryGroup;
    
    _units
};

_firstLoop = true;

while {true} do {
    // Spawn road blocks
    while {count _roadBlocks < _numberOfRoadBlocks} do {
        sleep random 0.05;
        if (isNil "drn_var_RoadBlocks_InstanceNo") then {
            drn_var_RoadBlocks_InstanceNo = 0;
        }
        else {
            drn_var_RoadBlocks_InstanceNo = drn_var_RoadBlocks_InstanceNo + 1;
        };
        
        _instanceNo = drn_var_RoadBlocks_InstanceNo;
        
        if (_firstLoop) then {
            _minDistance = _minSpawnDistanceAtStartup;
        }
        else {
            _minDistance = _minSpawnDistance;
        };
        
        _roadSegment = [_roadBlocks, _referenceGroup, _minDistance, _maxSpawnDistance, _minDistanceBetweenRoadBlocks] call _fnc_FindRoadBlockSegment;
        
        if (!isNull _roadSegment) then {
            _units = [_roadSegment, _side, _possibleInfantryTypes, _possibleVehicleTypes, _fnc_OnSpawnInfantryGroup, _fnc_OnSpawnMannedVehicle] call _fnc_CreateRoadBlock;
            
            _roadBlockItem = [_instanceNo, _roadSegment, _units]; // instance no, road segment, units
            _roadBlocks set [count _roadBlocks, _roadBlockItem];
            
            if (_debug) then {
                ["Road block created. Number of road blocks: " + str count _roadBlocks] call drn_fnc_CL_ShowDebugTextAllClients;
                ["drn_DebugMarker_RoadBlocks_" + str _instanceNo, getPos _roadSegment, "Dot", "ColorRed", "Road Block"] call drn_fnc_CL_SetDebugMarkerAllClients;
            };
        };
    };
    
    if (_debug) then {
        sleep 1;
    }
    else {
        sleep 60;
    };
    
    // Delete road blocks
    _tempRoadBlocks = [];
    _roadBlocksDeleted = 0;
    {
        private ["_roadBlockUnits"];
        
        _roadBlockItem = _x;
        _instanceNo = _roadBlockItem select 0;
        _roadSegment = _roadBlockItem select 1;
        _roadBlockUnits = _roadBlockItem select 2;
        
        _farAway = true;
        {
            private ["_referenceUnit"];
            
            _referenceUnit = vehicle _x;
            
            {
                if (_x distance _referenceUnit < _maxSpawnDistance) then {
                    _farAway = false;
                };
            } foreach _roadBlockUnits;
            
        } foreach units _referenceGroup;
        
        if (_farAway) then {
            private ["_groups", "_units"];
            
            _units = _roadBlockItem select 2;
            
            // Delete road block
            
            _groups = [];
            {
                _group = group _x;
                if (str _group != "<NULL-group>" && !(_group in _groups)) then {
                    _groups set [count _groups, _group];
                };
                
                deleteVehicle _x;
            } foreach _units;
            
            {
                deleteGroup _x;
            } foreach _groups;
             
             _roadBlocksDeleted = _roadBlocksDeleted + 1;
             
             if (_debug) then {
                 ["Road block deleted. Number of road blocks: " + str ((count _roadBlocks) - _roadBlocksDeleted)] call drn_fnc_CL_ShowDebugTextAllClients;
                 ["drn_DebugMarker_RoadBlocks_" + str _instanceNo] call drn_fnc_CL_DeleteDebugMarkerAllClients;
             };
        }
        else {
            _tempRoadBlocks set [count _tempRoadBlocks, _roadBlockItem];
        };
        
    } foreach _roadBlocks;
    
    _roadBlocks = _tempRoadBlocks;
    _firstLoop = false;
};








