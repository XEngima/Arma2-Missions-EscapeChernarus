if (!isServer) exitWith {};

private ["_chopper", "_dropPosition", "_onGroupDropped", "_debug", "_group", "_waypoint", "_dropUnits"];

_chopper = _this select 0;
_dropUnits = _this select 1;
_dropPosition = _this select 2;
if (count _this > 3) then {_onGroupDropped = _this select 3;} else {_onGroupDropped = {};};
if (count _this > 4) then {_debug = _this select 4;} else {_debug = false;};

_group = group _chopper;

if (_debug) then {
    player sideChat "Starting drop chopper script...";
};

if (vehicleVarName _chopper == "") exitWith {
	sleep 5;
	player sideChat "Drop chopper must have a name. Script exiting.";
};

_chopper setVariable ["waypointFulfilled", false];
_chopper setVariable ["missionCompleted", false];

[_chopper, _dropUnits, _dropPosition, _onGroupDropped, _debug] spawn {
	private ["_chopper", "_dropUnits", "_dropPosition", "_onGroupDropped", "_debug", "_i", "_dropGroup"];
    
    _chopper = _this select 0;
    _dropUnits = _this select 1;
    _dropPosition = _this select 2;
    _onGroupDropped = _this select 3;
    _debug = _this select 4;
    
	while {!(_chopper getVariable "waypointFulfilled")} do {
		sleep 1;
	};

	if (_debug) then {
		player sideChat "Drop chopper dropping cargo...";
	};

    _dropGroup = createGroup drn_var_enemySide;
    _i = 0;
    
    {
        private ["_parachute", "_dropUnit"];
        
        // This code is a workaround. An ArmA bug causes chutes to fall empty if commented code below is used. Problem is not completely solved, since chutes still are empty, but at least the AI units are not seen slammed to the ground.

        /*
        _x action ["eject", _chopper];
        unassignVehicle _x;
        
        waitUntil {vehicle _x != _chopper};
        */
        
        _parachute = "ParachuteEast" createVehicle position _chopper;
        _parachute setPosATL getPosATL _chopper;
        
        (typeof _x) createUnit [[0, 0, 100], _dropGroup, "", 0.5, "PRIVATE"];
        
        _dropUnit = units _dropGroup select _i;
        _dropUnit call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
        _dropUnit moveInDriver _parachute;
        _i = _i + 1;
        
        deleteVehicle _x;
        
        sleep 0.5;
    } foreach _dropUnits;

    _dropUnits = units _dropGroup;
    [_dropGroup, _dropPosition] call _onGroupDropped;
    
	while {!(_chopper getVariable "missionCompleted")} do {
		sleep 1;
	};

	if (_debug) then {
		player sideChat "Drop chopper terminating...";
	};

	{
		deleteVehicle _x;
	} foreach units group _chopper;
	deleteVehicle _chopper;
};

if (_debug) then {
	"SmokeShellRed" createVehicle _dropPosition;
	player sideChat "Drop chopper moving out...";
};

_chopper flyInHeight 250;
_chopper engineOn true;
_chopper move [position _chopper select 0, position _chopper select 1, 85];
while {(position _chopper) select 2 < 75} do {
	sleep 1;
};

_waypoint = _group addWaypoint [_dropPosition, 0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointStatements ["true", vehicleVarName _chopper + " setVariable [""waypointFulfilled"", true];"];

_waypoint = _group addWaypoint [getPos _chopper, 0];
_waypoint setWaypointType "MOVE";
_waypoint setWaypointBehaviour "SAFE";
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointStatements ["true", vehicleVarName _chopper + " setVariable [""missionCompleted"", true];"];


