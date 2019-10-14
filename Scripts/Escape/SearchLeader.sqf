if (!isServer) exitWith {};

private ["_searchAreaMarkerName", "_debug"];
private ["_trigger", "_marker", "_state", "_timeUntilMarkerSizeMediumMin", "_timeUntilMarkerSizeLargeMin", "_searchStartTimeSek", "_markerState", "_lostContactTimeSek", "_maxKnowledge", "_detectedUnit"];
private ["_unitIsDetected", "_enemyUnit", "_knowledge", "_detectedUnitsPosition", "_unitThatDetected", "_unitThatDetectedPositionAccuracy", "_minTimeUntilReportToHQSec", "_maxTimeUntilReportToHQSec", "_timeUntilReportToHQSec"];
private ["_reportingUnit", "_debugMsg", "_lastDebugMsg", "_reportingStartTime", "_worldSizeXY", "_searchAreaDiamSmall", "_searchAreaDiamMedium", "_searchAreaDiamLarge", "_searchAreaMarkerCreated"];

_searchAreaMarkerName = _this select 0;
if (count _this > 1) then {_debug = _this select 1;} else {_debug = false;};

_marker = "";
_worldSizeXY = 20000;
_searchAreaDiamSmall = 200;
_searchAreaDiamMedium = 700;
_searchAreaDiamLarge = 1500;
_timeUntilMarkerSizeMediumMin = 1;
_timeUntilMarkerSizeLargeMin = 3;
_minTimeUntilReportToHQSec = 0;
_maxTimeUntilReportToHQSec = 12;

drn_var_SearchLeader_Detected = false;
drn_var_Escape_SearchLeader_civilianReporting = false;
_lostContactTimeSek = 0;
_lastDebugMsg = "";
_searchAreaMarkerCreated = false;

_state = "KNOW NOTHING";
_searchStartTimeSek = diag_tickTime;
_lostContactTimeSek = _searchStartTimeSek;
_markerState = "SMALL";

_timeUntilReportToHQSec = _minTimeUntilReportToHQSec + random (_maxTimeUntilReportToHQSec - _minTimeUntilReportToHQSec);

if (_debug) then {
    player sideChat "Starting search leader...";
};

// Create detection trigger

_trigger = createTrigger["EmptyDetector", [_worldSizeXY / 2, _worldSizeXY / 2, 0]];
_trigger setTriggerArea[_worldSizeXY, _worldSizeXY, 0, true];
_trigger setTriggerActivation[str drn_var_playerSide, (str drn_var_enemySide) + " D", false];
_trigger setTriggerStatements["this", "drn_var_SearchLeader_Detected = true;", ""];

// Start thread that sets detected by civilian
[] spawn {
    while {true} do {
        if (drn_var_Escape_SearchLeader_civilianReporting) then {
            {
                if (side _x == civilian && _x distance ((call drn_fnc_Escape_GetPlayers) select 0) <300) exitWith {
                    drn_var_SearchLeader_Detected = true;
                    drn_var_Escape_SearchLeader_ReportingCivilian = _x;
                };
            } foreach allUnits;
        };
        
        sleep 5;
    };
};

//waitUntil {drn_var_SearchLeader_Detected};

_detectedUnitsPosition = [0, 0, 0];

while {1 == 1} do {
	if (drn_var_SearchLeader_Detected) then {

		deleteVehicle _trigger;

		// Find the enemy that detected us

		_maxKnowledge = 0;
		_detectedUnit = objNull;
		_unitIsDetected = false;
		_unitThatDetected = "";
		_unitThatDetectedPositionAccuracy = 100;

		{
			scopeName "scopeAllGroups";

			private ["_leader"];
			private ["_nearestEnemy"];
			private ["_positionAccuracy"];

			_leader = leader _x;
			{
				if (alive _leader) exitWith {};
				_leader = _x;
			} foreach units _x;

            if (alive _leader && side _x == drn_var_enemySide) then {
				_nearestEnemy = _leader findNearestEnemy position _leader;
				
                if (!isNull _nearestEnemy) then {
                    {
                        _enemyUnit = (_x select 4);
                        if (_enemyUnit == _nearestEnemy && _enemyUnit in (units (call drn_fnc_Escape_GetPlayerGroup))) then {
                            private ["_enemysSupposedPos"];
                            
                            _enemysSupposedPos = (_x select 0);
                            _positionAccuracy = (_x select 5);
                            
                            {
                                _knowledge = (_leader knowsAbout _x);
                                if (alive _x && _knowledge > _maxKnowledge && _positionAccuracy < 5) then {
                                    _maxKnowledge = _knowledge;
                                    _unitIsDetected = true;
                                    _detectedUnit = _x;
                                    _detectedUnitsPosition = _enemysSupposedPos;
                                    _unitThatDetected = _leader;
                                    _reportingUnit = (units group _unitThatDetected) select floor random count (units group _unitThatDetected);
                                    _unitThatDetectedPositionAccuracy = _positionAccuracy;
                                    
                                    //"SmokeShellGreen" createVehicle _enemysSupposedPos;
                                };
                            } foreach (call drn_fnc_Escape_GetPlayers);
                            
                            breakTo "scopeAllGroups";
                        };
                    } foreach (_leader nearTargets (_leader distance _nearestEnemy) + 100);
                };
            };
        } foreach allGroups;
        
        // Check if detected by civilian
        if (drn_var_Escape_SearchLeader_civilianReporting && !_unitIsDetected) then {
            _unitIsDetected = true;
            _detectedUnit = (call drn_fnc_Escape_GetPlayers) select 0;
            _unitThatDetected = drn_var_Escape_SearchLeader_ReportingCivilian;
            _reportingUnit = _unitThatDetected;
            _unitThatDetectedPositionAccuracy = 0;
            _maxKnowledge = 4;
            _detectedUnitsPosition = getPos _detectedUnit;
        };

		if (_unitIsDetected) then {
			_lostContactTimeSek = diag_tickTime;

			if (_debug) then {
                _debugMsg = (name _unitThatDetected) + "(" + str side _unitThatDetected + ")" + " detected " + (name _detectedUnit) + "(Position accuracy: " + str _unitThatDetectedPositionAccuracy + ").";
				if (_debugMsg != _lastDebugMsg) then {
					player sideChat _debugMsg;
					_lastDebugMsg = _debugMsg;
				};
			};

            if (_state == "KNOW NOTHING") then {
                _state = "REPORTING";
                _reportingStartTime = diag_tickTime;
                if (drn_var_Escape_SearchLeader_civilianReporting) then {
                    _timeUntilReportToHQSec = 1;
                }
                else {
                    _timeUntilReportToHQSec = _minTimeUntilReportToHQSec + random (_maxTimeUntilReportToHQSec - _minTimeUntilReportToHQSec);
                };
            };
		}
		else {
			drn_var_SearchLeader_Detected = false;

			_trigger = createTrigger["EmptyDetector", [_worldSizeXY / 2, _worldSizeXY / 2, 0]];
			_trigger setTriggerArea[_worldSizeXY, _worldSizeXY, 0, true];
			_trigger setTriggerActivation[str drn_var_playerSide, (str drn_var_enemySide) + " D", false];
			_trigger setTriggerStatements["this", "drn_var_SearchLeader_Detected = true;", ""];

			if (_debug) then {
				_debugMsg = "Enemy lost contact of player group.";
				if (_debugMsg != _lastDebugMsg) then {
					player sideChat _debugMsg;
					_lastDebugMsg = _debugMsg;
				};
			};
		};
	};

	if (_state == "KNOW NOTHING") then {
	
		// If there has been more than X minutes since lost contact, enlarge the search area to size MEDIUM
		if (diag_tickTime > _lostContactTimeSek + _timeUntilMarkerSizeMediumMin * 60 && _markerState == "SMALL") then {

			if (_searchAreaMarkerCreated) then {

				_markerState = "MEDIUM";
				_marker setMarkerSize [_searchAreaDiamMedium / 2, _searchAreaDiamMedium / 2];

				if (_debug) then {
					_debugMsg = "Search area has expanded to size MEDIUM.";
					if (_debugMsg != _lastDebugMsg) then {
						player sideChat _debugMsg;
						_lastDebugMsg = _debugMsg;
					};
				};
			};
		};

		// If there has been more than X+Y minutes since lost contact, enlarge the search area to size LARGE
		if (diag_tickTime > _lostContactTimeSek + _timeUntilMarkerSizeLargeMin * 60 && _markerState == "MEDIUM") then {
            if (_searchAreaMarkerCreated) then {
                _markerState = "LARGE";
                _marker setMarkerSize [_searchAreaDiamLarge / 2, _searchAreaDiamLarge / 2];
                
                if (_debug) then {
                    _debugMsg = "Search area has expanded to size LARGE.";
                    if (_debugMsg != _lastDebugMsg) then {
                        player sideChat _debugMsg;
                        _lastDebugMsg = _debugMsg;
                    };
                };
            };
        };
    };
    
    if (_state == "REPORTING") then {
        if (alive _reportingUnit) then {
            if (diag_tickTime > _reportingStartTime + _timeUntilReportToHQSec) then {
                
                _state = "KNOW NOTHING";
                
                // Reveal players for enemy units in the vicinity (if its not dark)
                if ((date select 3) > 6 && (date select 3) < 18) then {
                    {
                        if (side _x == drn_var_enemySide && count units _x > 0) then {
                            if (((units _x) select 0) distance _detectedUnit < (350 * (1 - fog))) then {
                                _x reveal _detectedUnit;
                            };
                        };
                    } foreach allGroups;
                };
                
				// If search area marker is not yet created, create it.
				if (!_searchAreaMarkerCreated) then {
					_marker = createMarkerLocal [_searchAreaMarkerName, _detectedUnitsPosition];
					_marker setMarkerShapeLocal "RECTANGLE";
					_marker setMarkerSizeLocal [_searchAreaDiamSmall, _searchAreaDiamSmall];
					_searchAreaMarkerCreated = true;

					if (!_debug) then {
						_marker setMarkerAlphaLocal 0;
					};
				};

				_marker setMarkerPosLocal _detectedUnitsPosition;
				_markerState = "SMALL";
				_marker setMarkerSize [_searchAreaDiamSmall / 2, _searchAreaDiamSmall / 2];

				if (_debug) then {
					_debugMsg = name _reportingUnit + " has reported in to HQ.";
					if (_debugMsg != _lastDebugMsg) then {
						player sideChat _debugMsg;
						_lastDebugMsg = _debugMsg;
					};
				};

				_timeUntilReportToHQSec = _minTimeUntilReportToHQSec + random (_maxTimeUntilReportToHQSec - _minTimeUntilReportToHQSec);
			};
		}
		else { // if reporting unit is not still alive
			_state = "KNOW NOTHING";

			if (_debug) then {
				_debugMsg = name _reportingUnit + " is dead and cannot report in to HQ.";
				if (_debugMsg != _lastDebugMsg) then {
					player sideChat _debugMsg;
					_lastDebugMsg = _debugMsg;
				};
			};

			_timeUntilReportToHQSec = _minTimeUntilReportToHQSec + random (_maxTimeUntilReportToHQSec - _minTimeUntilReportToHQSec);
		};
	};

	sleep 1;
};
