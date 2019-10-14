/* AmbientInfantry.sqf
 * Summary: Makes a group of infantry units to search an area and engage detected enemies. The infantry group will move at "normal" speed to a search area (marker)
 * and then patrol that area until enemies are detected. If the search area marker moves to another place, they will again move at "normal" speed to the new area.
 * Arguments:
 *   _referenceGroup: Ambient infantry groups will be spawned around the units in this group (preferrably the player's group).
 *   _side: Side of spawned units.
 *   _infantryClasses: Array of classes to randomly spawn, e.g. ["USMC_Soldier_AA", "USMC_Soldier_MG"] will spawn 50% AA units and 50% MG units. It's also possible so send in name of a faction, e.g. "USMC" to spawn random infantry units from that faction.
 *   [_groupsCount]: How many active groups inside outer radius.
 *   [_minSpawnDistance]: Minimum spawn distance from nearest reference units in meters.
 *   [_maxSpawnDistance]: Maximum spawn distance from nearest reference unit in meters.
 *   [_minUnitsInGroup]: Minimum number of units in a group.
 *   [_maxUnitsInGroup]: Maximum number of units in a group.
 *   [_minSkill]: Skill of spawned unit is selected randomly between values _minSkill and _maxSkill.
 *   [_maxSkill]: Skill of spawned unit is selected randomly between values _minSkill and _maxSkill.
 *   [_garbageCollectDistance]: Dead units at this distance from _referenceGroup will be deleted.
 *   [_fnc_OnSpawnUnit]: Code run once for every spawned unit (after the whole group is created). The unit can be accessed through "_this". Default value is {}.
 *   [_fnc_OnSpawnGroup]: Code run once for every spawned group (after the whole group is created). The group can be accessed through "_this". Default value is {};
 *   [_debug]: true if debugmessages and areas will be shown for player. Default false.
 * Dependencies: CommonLib v1.01
 */

if (!isServer) exitWith {};

private ["_referenceGroup", "_side", "_groupsCount", "_minSpawnDistance", "_maxSpawnDistance", "_infantryClasses", "_minSkill", "_maxSkill", "_garbageCollectDistance", "_debug"];
private ["_activeGroups", "_activeUnits", "_spawnPos", "_group", "_possibleInfantryTypes", "_infantryType", "_minDistance", "_skill", "_vehicleVarName"];
private ["_minUnitsInGroup", "_maxUnitsInGroup", "_i", "_atScriptStartUp", "_currentEntityNo", "_debugMsg", "_farAwayUnits", "_farAwayUnitsCount", "_unitsToDeleteCount", "_groupsToDeleteCount"];
private ["_debugMarkers", "_debugMarkerNo", "_debugMarkerName", "_isFaction", "_unitsToDelete", "_groupsToDelete", "_tempGroups", "_tempGroupsCount"];
private ["_fnc_OnSpawnUnit", "_fnc_OnSpawnGroup", "_fnc_GetRandomSpawnPos"];

_referenceGroup = _this select 0;
_side = _this select 1;
_infantryClasses = _this select 2;
if (count _this > 3) then {_groupsCount = _this select 3;} else {_groupsCount = 10;};
if (count _this > 4) then {_minSpawnDistance = _this select 4;} else {_minSpawnDistance = 1500;};
if (count _this > 5) then {_maxSpawnDistance = _this select 5;} else {_maxSpawnDistance = 2000;};
if (count _this > 6) then {_minUnitsInGroup = _this select 6;} else {_minUnitsInGroup = 4;};
if (count _this > 7) then {_maxUnitsInGroup = _this select 7;} else {_maxUnitsInGroup = 6;};
if (count _this > 8) then {_minSkill = _this select 8;} else {_minSkill = 0.4;};
if (count _this > 9) then {_maxSkill = _this select 9;} else {_maxSkill = 0.6;};
if (count _this > 10) then {_garbageCollectDistance = _this select 10;} else {_garbageCollectDistance = 750;};
if (count _this > 11) then {_fnc_OnSpawnUnit = _this select 11;} else {_fnc_OnSpawnUnit = {};};
if (count _this > 12) then {_fnc_OnSpawnGroup = _this select 12;} else {_fnc_OnSpawnGroup = {};};
if (count _this > 13) then {_debug = _this select 13;} else {_debug = false;};

if (isNil "drn_var_commonLibInitialized") then {
    [] spawn {
        while {true} do { player sideChat "Script AmbientInfantry.sqf needs CommonLib version 1.02"; sleep 5; };
    };
};

if (_debug) then {
    ["Starting script Ambient Infantry..."] call drn_fnc_CL_ShowDebugTextAllClients;
};

_activeGroups = [];
_activeUnits = [];
_debugMarkers = [];
_debugMarkerNo = 0;

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

_fnc_GetRandomSpawnPos = {
    private ["_referenceUnits", "_minSpawnDistance", "_maxSpawnDistance"];
    private ["_spawnPos", "_posOk", "_direction", "_distance", "_spawnX", "_spawnY", "_referenceUnit"];
    
    _referenceUnits = _this select 0;
    _minSpawnDistance = _this select 1;
    _maxSpawnDistance = _this select 2;
    
    _referenceUnit = _referenceUnits select floor random count _referenceUnits;
    
    _posOk = false;
    while {!_posOk} do {
        _direction = random 360;
        _distance = _minSpawnDistance + (random (_maxSpawnDistance - _minSpawnDistance));
        _spawnX = (getPos _referenceUnit select 0) + ((sin _direction) * _distance);
        _spawnY = (getPos _referenceUnit select 1) + ((cos _direction) * _distance);
        _spawnPos = [_spawnX, _spawnY, 0];
        
        _posOk = true;
        {
            if ((surfaceIsWater _spawnPos) || (_spawnPos distance (vehicle _x) < _minSpawnDistance)) then {
                _posOk = false;
            };
        } foreach _referenceUnits;
    };
    
    _spawnPos
};

_atScriptStartUp = true;

while {true} do {
	scopeName "mainScope";

	// While there are too few active groups, add a group

    while {count _activeGroups < _groupsCount} do {
        private ["_spawnX", "_spawnY","_unitsInGroup"];

        if (_atScriptStartUp) then {
            _minDistance = 350;
            if (_minDistance > _maxSpawnDistance) then {
                _minDistance = _minSpawnDistance / 5;
            };
        }
        else {
            _minDistance = _minSpawnDistance;
        };
        
        // Get a random spawn position
        _spawnPos = [units _referenceGroup, _minDistance, _maxSpawnDistance] call _fnc_GetRandomSpawnPos;
        _skill = _minSkill + random (_maxSkill - _minSkill);
        
        // Create group
        _unitsInGroup = _minUnitsInGroup + floor (random (_maxUnitsInGroup - _minUnitsInGroup));
        _group = createGroup _side;
        
        for [{_i = 0}, {_i < _unitsInGroup}, {_i = _i + 1}] do {
            _infantryType = _possibleInfantryTypes select floor (random count _possibleInfantryTypes);
            _infantryType createUnit [_spawnPos, _group,"", _skill, "PRIVATE"];
        };
        
        // Run custom code for units and group
        {
            _x setVariable ["drn_scriptHandle", _x spawn _fnc_OnSpawnUnit]; // Squint complaining, but is ok.
        } foreach units _group;
        
        _group setVariable ["drn_scriptHandle", _group spawn _fnc_OnSpawnGroup]; // Squint complaining, but is ok.
        
        // Name group
        sleep random 0.05;
        if (isNil "drn_AmbientInfantry_CurrentEntityNo") then {
            drn_AmbientInfantry_CurrentEntityNo = 0
        };

        _currentEntityNo = drn_AmbientInfantry_CurrentEntityNo;
        drn_AmbientInfantry_CurrentEntityNo = drn_AmbientInfantry_CurrentEntityNo + 1;
        
        _vehicleVarName = "drn_AmbientInfantry_Entity_" + str _currentEntityNo;
        ((units _group) select 0) setVehicleVarName _vehicleVarName;
        ((units _group) select 0) call compile format ["%1=_this;", _vehicleVarName];
        
        // Start group
        [((units _group) select 0), _debug] execVM "Scripts\DRN\AmbientInfantry\MoveInfantryGroup.sqf";
        _activeGroups set [count _activeGroups, _group];
        _activeUnits = _activeUnits + units _group;

        if (_debug) then {
            ["Infantry group created! Total groups = " + str count _activeGroups] call drn_fnc_CL_ShowDebugTextAllClients;
        };
	};
    
    _atScriptStartUp = false;

	if (_debug) then {
        private ["_debugMarkerColor"];
        
        {
            [_x] call drn_fnc_CL_DeleteDebugMarkerAllClients;
        } foreach _debugMarkers;

		_debugMarkers = [];

        {
            _group = _x;
            _debugMarkerNo = _debugMarkerNo + 1;
            
            _debugMarkerName = "drn_debugMarker" + str _side + str _debugMarkerNo;
            if (_side == west) then {
                _debugMarkerColor = "ColorBlue";
            };
            if (_side == east) then {
                _debugMarkerColor = "ColorRed";
            };
            if (_side == civilian) then {
                _debugMarkerColor = "ColorWhite";
            };
            if (_side == resistance) then {
                _debugMarkerColor = "ColorYellow";
            };
            
            [_debugMarkerName, getPos ((units _group) select 0), "Dot", _debugMarkerColor] call drn_fnc_CL_SetDebugMarkerAllClients;
            
            _debugMarkers set [count _debugMarkers, _debugMarkerName];
        } foreach _activeGroups;
    };
	
    _farAwayUnits = [];
    _farAwayUnitsCount = 0;
    
    // If any group is too far away, delete it
    {
        private ["_unit"];
        private ["_unitIsFarAway"];
        _unit = _x;

        _unitIsFarAway = true;
        {
            private ["_hasGroup", "_group", "_groupUnit", "_referenceUnit"];
            _referenceUnit = vehicle _x;
            
            // A unit is far away if its alive and beyond max spawn distance, or if it's dead and beyond garbage collect distance.
            if ((((alive _unit) && (_referenceUnit distance _unit < _maxSpawnDistance)) || ((!alive _unit) && (_referenceUnit distance _unit < _garbageCollectDistance)))) exitWith {
                _unitIsFarAway = false;
            };
        } foreach units _referenceGroup;
        
        if (_unitIsFarAway) then {
            _farAwayUnits set [_farAwayUnitsCount, _unit];
            _farAwayUnitsCount = _farAwayUnitsCount + 1;
        };

    } foreach _activeUnits;
    
    _unitsToDelete = [];
    _groupsToDelete = [];
    _unitsToDeleteCount = 0;
    _groupsToDeleteCount = 0;
    {
        private ["_unit"];
        private ["_hasGroup", "_wholeGroupFarAway"];
        _unit = _x;
        
        _group = group _unit;
        _hasGroup = false;
        if (str _group != "<NULL-group>") then {
            _hasGroup = true;
        };
        
        if (_hasGroup) then {
            // Delete all units in the group, if all units are far away
            _wholeGroupFarAway = true;
            {
                if  (!(_x in _farAwayUnits)) then {
                    _wholeGroupFarAway = false;
                };
            } foreach units group _unit;
            
            if (_wholeGroupFarAway) then {
                _unitsToDelete set [_unitsToDeleteCount, _unit];
                _unitsToDeleteCount = _unitsToDeleteCount + 1;
                
                if (!(_group in _groupsToDelete)) then {
                    _groupsToDelete set [_groupsToDeleteCount, _group];
                    _groupsToDeleteCount = _groupsToDeleteCount + 1;
                };
            };
        }
        else {
            _unitsToDelete set [count _unitsToDelete, _unit];
            _unitsToDeleteCount = _unitsToDeleteCount + 1;
        };
    } foreach _farAwayUnits;
    
    // Delete units that are marked for delete
    _activeUnits = + _activeUnits - _unitsToDelete;
    _activeGroups = + _activeGroups - _groupsToDelete;
    
    {
        private ["_scriptHandle"];
        
        _scriptHandle = _x getVariable "drn_scriptHandle";
        if (!(scriptDone _scriptHandle)) then {
            terminate _scriptHandle;
        };
        
        deleteVehicle _x;
    } foreach _unitsToDelete;
    
    {
        private ["_scriptHandle"];
        
        _scriptHandle = _x getVariable "drn_scriptHandle";
        if (!(scriptDone _scriptHandle)) then {
            terminate _scriptHandle;
        };
        
        deleteGroup _x;
    } foreach _groupsToDelete;
    
    _debugMsg = "";
    if (count _unitsToDelete > 0) then {
        _debugMsg = str (count _unitsToDelete) + " units deleted by Ambient Infantry. ";
    };
    
    if (count _groupsToDelete > 0) then {
        _debugMsg = _debugMsg + str (count _groupsToDelete) + " groups deleted by Ambient Infantry. ";
    };
    
    if (_debug && _debugMsg != "") then {
        [_debugMsg] call drn_fnc_CL_ShowDebugTextAllClients;
    };

    _tempGroupsCount = 0;
    _tempGroups = [];
    
    // Remove dead groups from active groups list
    {
        private ["_activeGroup"];
        _activeGroup = _x;

        if (({alive _x} count units _activeGroup) > 0) then {
            _tempGroups set [_tempGroupsCount, _activeGroup];
            _tempGroupsCount = _tempGroupsCount + 1;
        }
        else {
            if (_debug) then {
                ["Ambient Infantry deleting group with all dead units."] call drn_fnc_CL_ShowDebugTextAllClients;
            };
        };
        
    } foreach _activeGroups;
    
    _activeGroups = _tempGroups;
    
    if (_debug) then {
        sleep 1;
    }
    else {
        sleep 60;
    };
};


