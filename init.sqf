private ["_useRevive"];
private ["_volume", "_dynamicWeather", "_isJipPlayer"];
private ["_showIntro", "_showPlayerMapAndCompass", "_fog", "_playerIsImmortal", "_playersEnteredWorld"];

_isJipPlayer = false;
if (!isServer && isNull player) then
{
    _isJipPlayer = true;
};

// Developer Variables

_useRevive = false;
_showIntro = false;

// Debug Variables

_showPlayerMapAndCompass = true;
_playerIsImmortal = true; // Only works for unit p1

// Initialization

drn_var_Escape_firstPreloadDone = false;
drn_var_Escape_playerEnteredWorld = false;

onPreloadFinished {
	if (!drn_var_Escape_firstPreloadDone) then {
		drn_var_Escape_firstPreloadDone = true;

		if (!isNull player) then {
            drn_var_Escape_playerEnteredWorld = true;
		};
	};
};

if (isServer) then {
    drn_var_Escape_hoursSkipped = 0;
    
    if (isMultiplayer) then {
        private ["_hour"];
        
        if (paramsArray select 2 == 24) then {
            _hour = floor random 24;
        }
        else {
            _hour = paramsArray select 2;
        };
        
        drn_var_Escape_hoursSkipped = _hour - (date select 3);
        publicVariable "drn_var_Escape_hoursSkipped";
        setDate [date select 0, date select 1, date select 2, _hour, 0];
    };
};

_volume = soundVolume;
enableSaving [false, false];
0 fadeSound 0;
enableRadio false;
0 cutText ["", "BLACK FADED"];

if (isDedicated && _useRevive) then {
    server execVM "revive_init.sqf";
};

if (!isDedicated) then {
    waitUntil {!isNull player};
    player setCaptive true;
};

if (_playerIsImmortal) then {
    p1 allowDamage false;
};

// Initialization
drn_arr_JipSpawnPos = [];
call compile preprocessFileLineNumbers "Scripts\DRN\CommonLib\CommonLib.sqf";
call drn_fnc_CL_InitParams;

call compile preprocessFileLineNumbers "Scripts\Escape\Functions.sqf";

[_isJipPlayer] call compile preprocessFileLineNumbers "Briefing.sqf";
call compile preprocessFileLineNumbers "scripts\Init_UPSMON.sqf";

_dynamicWeather = (paramsArray select 3);
setTerrainGrid (paramsArray select 4);

switch (_dynamicWeather) do {
    case 0: { execVM "Scripts\Escape\StaticWeatherEffects.sqf"; }; // Dynamic weather off
    case 1: { [0.1, 0.1, 0, [random 8, random 8]] execVM "Scripts\DRN\DynamicWeatherEffects\DynamicWeatherEffects.sqf"; }; // Dynamic weather (start clear)
    default {
         // Dynamic weather (start random)
        if (random 100 < 50) then {
            _fog = random 0.2;
        }
        else {
            _fog = random 0.9;
        };
        
        [_fog] execVM "Scripts\DRN\DynamicWeatherEffects\DynamicWeatherEffects.sqf";
    };
};

// Server Initialization

if (isServer) then {
    execVM "InitServer.sqf";
    if (isDedicated) exitWith {};
};

waitUntil {drn_var_Escape_playerEnteredWorld};

// Report to all other clients (and server) that player has entered the world
if (isNil "drn_var_Escape_syncronizationDone") then {
    switch (str player) do {
        case "p1": {
            drn_var_Escape_playerEnteredWorld_p1 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p1";
        };
        case "p2": {
            drn_var_Escape_playerEnteredWorld_p2 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p2";
        };
        case "p3": {
            drn_var_Escape_playerEnteredWorld_p3 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p3";
        };
        case "p4": {
            drn_var_Escape_playerEnteredWorld_p4 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p4";
        };
        case "p5": {
            drn_var_Escape_playerEnteredWorld_p5 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p5";
        };
        case "p6": {
            drn_var_Escape_playerEnteredWorld_p6 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p6";
        };
        case "p7": {
            drn_var_Escape_playerEnteredWorld_p7 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p7";
        };
        case "p8": {
            drn_var_Escape_playerEnteredWorld_p8 = true;
            publicVariable "drn_var_Escape_playerEnteredWorld_p8";
        };
        default {
            player sideChat "This should never happen!";
        };
    };
    
    _playersEnteredWorld = 1;
    while {(count call drn_fnc_Escape_GetPlayers != _playersEnteredWorld)} do {
        
        if (_showIntro) then {
            0 cutText ["", "BLACK FADED"];
        };
        
        sleep 0.5;
        
        _playersEnteredWorld = 0;
        if (!isNil "drn_var_Escape_playerEnteredWorld_p1") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p2") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p3") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p4") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p5") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p6") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p7") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
        if (!isNil "drn_var_Escape_playerEnteredWorld_p8") then {
            _playersEnteredWorld = _playersEnteredWorld + 1;
        };
    };
};

drn_var_Escape_syncronizationDone = true;
publicVariable "drn_var_Escape_syncronizationDone";

waitUntil {!isNil "drn_var_Escape_FunctionsInitializedOnServer"};
[] call drn_fnc_Escape_AskForTimeSynchronization;

// Player Initialization

removeAllWeapons player;
removeAllItems player;
player addWeapon "ItemRadio";
player addWeapon "ItemWatch";
player addWeapon "ItemMap";

drn_fnc_Escape_DisableLeaderSetWaypoints = {
    if (!visibleMap) exitwith {};
    
    {
        player groupSelectUnit [_x, false]; 
    } foreach units group player;
};

// If multiplayer, then disable the cheating "move to" waypoint feature.
if (isMultiplayer) then {
    [] spawn {
        waitUntil {!isNull(findDisplay 46)}; 
        // (findDisplay 46) displayAddEventHandler ["KeyDown","_nil=[_this select 1] call drn_fnc_Escape_DisableLeaderSetWaypoints"];
        (findDisplay 46) displayAddEventHandler ["MouseButtonDown","_nil=[_this select 1] call drn_fnc_Escape_DisableLeaderSetWaypoints"];
    };
};

if (!isMultiplayer) then {
    {
        /*
        _x setCaptive true;
        
        removeAllWeapons _x;
        removeAllItems _x;
        _x addWeapon "ItemRadio";
        _x addWeapon "ItemWatch";
        _x addWeapon "ItemMap";
        */
        
        if (_x != p1) then {
            deleteVehicle _x;
        };
    } foreach units group player;
};

// Run start sequence for all players
if (!isNull player) then {
    [_volume, _showIntro, _showPlayerMapAndCompass, _isJipPlayer, _useRevive] spawn {
        private ["_volume", "_showIntro", "_showPlayerMapAndCompass", "_isJipPlayer", "_useRevive"];
        private ["_marker"];
        
        _volume = _this select 0;
        _showIntro = _this select 1;
        _showPlayerMapAndCompass = _this select 2;
        _isJipPlayer = _this select 3;
        _useRevive = _this select 4;
        
        waitUntil {!(isNil "drn_startPos")};
        waitUntil {!(isNil "drn_fenceIsCreated")};
        
        if (_isJipPlayer) then {
            private ["_anotherPlayer"];
            
            _anotherPlayer = (call drn_fnc_Escape_GetPlayers) select 0;
            if (player == _anotherPlayer) then {
                _anotherPlayer = (call drn_fnc_Escape_GetPlayers) select 1;
            };
            
            "drn_arr_JipSpawnPos" addPublicVariableEventHandler {
                private ["_unitID", "_pos"];
                
                _unitID = drn_arr_JipSpawnPos select 0;
                _pos = drn_arr_JipSpawnPos select 1;

                if (_unitID == str player) then {
                    player setPos _pos;
                };
            };
            
            drn_fnc_Escape_AskForJipPos = [str player];
            publicVariable "drn_fnc_Escape_AskForJipPos";
            
            [] spawn {
                private ["_marker"];
                
                // Communication center markers
                waitUntil {!isNil "drn_var_Escape_communicationCenterPositions"};
                
                for "_i" from 0 to (count drn_var_Escape_communicationCenterPositions) - 1 do {
                    _marker = createMarkerLocal ["drn_Escape_ComCenJipMarker" + str _i, (drn_var_Escape_communicationCenterPositions select _i)];
                    _marker setMarkerType "Faction_INS";
                };
                
                // Ammo depot markers
                waitUntil {!isNil "drn_var_Escape_ammoDepotPositions"};
                
                for "_i" from 0 to (count drn_var_Escape_ammoDepotPositions) - 1 do {
                    _marker = createMarkerLocal ["drn_Escape_AmmoDepotJipMarker" + str _i, (drn_var_Escape_ammoDepotPositions select _i)];
                    _marker setMarkerType "Depot";
                };
                
                // Extraction marker
                if (!isNil "drn_var_Escape_ExtractionMarkerPos") then {
                    _marker = createMarkerLocal ["drn_visibleGoalJipMarker", drn_var_Escape_ExtractionMarkerPos];
                    _marker setMarkerType "Faction_US";
                };
            };
        }
        else {
            sleep 1;
            if (_showIntro) then {
                ["<t size='0.9'>" + "Engima of Ostgota Ops presents" + "</t>",0.02,0.3,2,-1,0,3010] spawn bis_fnc_dynamicText;
            };
            
            if (isMultiplayer) then {
                player setPos [(drn_startPos select 0) + (random 4) - 2, (drn_startPos select 1) + (random 6) - 3, 0];
            }
            else {
                {
                    _x setPos [(drn_startPos select 0) + (random 4) - 2, (drn_startPos select 1) + (random 6) - 3, 0];
                    _x disableAI "MOVE";
                } foreach units group player;
            };
            
            while {!([drn_startPos] call drn_fnc_Escape_AllPlayersOnStartPos) && !drn_escapeHasStarted} do {
                sleep 0.1;
            };
            
            if (_showIntro) then {            
                0 cutText ["", "BLACK FADED"];
                sleep 2.75;
                0 cutText ["", "BLACK FADED"];
                sleep 2.75;
            
                ["<t size='0.9'>" + "Escape Chernarus" + "</t>",0.02,0.3,2,-1,0,3011] spawn bis_fnc_dynamicText;
                
                0 cutText ["", "BLACK FADED"];
                sleep 2.75;
                0 cutText ["", "BLACK FADED"];
                sleep 2.75;
                
                0 cutText ["", "BLACK FADED"];
                ["Somewhere in Chernarus", str (date select 2) + "/" + str (date select 1) + "/" + str (date select 0) + " " + str (date select 3) + ":00"] spawn BIS_fnc_infoText;
            };
        };

        1 fadeSound _volume;
        
        if (_showIntro && !_isJipPlayer) then {
            sleep 2;
        };
        
        if (_showPlayerMapAndCompass) then {
            _marker = createMarkerLocal ["drn_startPosMarker", drn_startPos];
            _marker setMarkerType "Warning";
            player addWeapon "ItemCompass";
        }
        else {
            player removeWeapon "ItemMap";
        };
        
        enableRadio true;
        
        if (!_isJipPlayer) then {
            [_useRevive] spawn {
                private ["_useRevive"];
                
                _useRevive = _this select 0;
                
                sleep 10;
                if (_useRevive && !isDedicated) then {
                    server execVM "revive_init.sqf";
                }; 
                
                // Only show this on non ported missions
                if (worldName == "Chernarus") then {
                    sleep 20;
                    [name player + "! Please tell me about your Escape Chernarus experience on the BIS Forum or at Armaholic.com! Thank you, and enjoy the mission!", true] call drn_fnc_CL_ShowTitleTextLocal;
                };
            };
        };

        // Set position again (a fix for the bug that makes players run away after server restart and before fence is built by server)
        player setPos [(drn_startPos select 0) + (random 4) - 2, (drn_startPos select 1) + (random 6) - 3, 0];
        sleep 0.1;
        
        player setVariable ["drn_var_initializing", false, true];
        waitUntil {!(isNil "drn_escapeHasStarted")};
        
        if (_isJipPlayer && _useRevive) then {
            server execVM "revive_init.sqf";
        }; 
        
        {
            _x setCaptive false;
            _x enableAI "MOVE";
        } foreach units group player;
    };
};

if (true) exitWith {};


