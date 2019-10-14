if (!isServer) exitWith {};

private ["_extractionPointNo"];
private ["_spawnMarkerName", "_extractionMarkerName", "_extractionMarkerName2", "_result", "_boat1", "_boat2", "_group1", "_group2", "_waypoint"];

_extractionPointNo = _this select 0;
_spawnMarkerName = "drn_Escape_ExtracionBoatSpawnPos" + str _extractionPointNo;
_extractionMarkerName = "drn_Escape_ExtractionPos" + str _extractionPointNo;
_extractionMarkerName2 = "drn_Escape_ExtractionPos" + str _extractionPointNo + "_1";

_result = [[((getMarkerPos _spawnMarkerName) select 0) + 15, ((getMarkerPos _spawnMarkerName) select 1) + 10, 0], 0, "RHIB2Turret", drn_var_playerSide] call BIS_fnc_spawnVehicle;
_boat1 = _result select 0;
_group1 = _result select 2;

_result = [[((getMarkerPos _spawnMarkerName) select 0) - 15, ((getMarkerPos _spawnMarkerName) select 1) - 10, 0], 0, "RHIB2Turret", drn_var_playerSide] call BIS_fnc_spawnVehicle;
_boat2 = _result select 0;
_group2 = _result select 2;

_waypoint = _group1 addWaypoint [getMarkerPos _extractionMarkerName, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";
_waypoint setWaypointFormation "WEDGE";

_waypoint = _group2 addWaypoint [getMarkerPos _extractionMarkerName2, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";
_waypoint setWaypointFormation "WEDGE";

sleep 1;

// Verkar inte funka...
(driver _boat1) action ["LightOff", _boat1];
(driver _boat2) action ["LightOff", _boat2];

if (isMultiplayer) then {
    waitUntil {{vehicle _x == _boat1 || vehicle _x == _boat2} count (call drn_fnc_Escape_GetPlayers) == count (call drn_fnc_Escape_GetPlayers)};
}
else {
    waitUntil {{vehicle _x == _boat1 || vehicle _x == _boat2} count units group ((call drn_fnc_Escape_GetPlayers) select 0) == count units group ((call drn_fnc_Escape_GetPlayers) select 0)};
};

_waypoint = _group1 addWaypoint [getMarkerPos _spawnMarkerName, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";

_waypoint = _group2 addWaypoint [getMarkerPos _spawnMarkerName, 0];
_waypoint setWaypointSpeed "FULL";
_waypoint setWaypointBehaviour "CARELESS";

sleep 10;

["Task complete: Rendesvouz with allied forces."] call drn_fnc_CL_ShowTitleTextAllClients;

sleep 25;

["drn_rendesvouzTasks", "SUCCEEDED"] call drn_SetTaskStateOnAllMachines;
drn_var_Escape_MissionComplete = true;
publicVariable "drn_var_Escape_MissionComplete";

