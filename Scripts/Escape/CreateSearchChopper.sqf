/*
	Creating a manned search chopper, and runs the script SearchChopper.sqf on it.

	Arguments:
		_homePos: Choppers spawn position.
		_side: Chopper's side.
		_searchAreaMarker: Search area marker.
		_searchTimeMin: Optional. Search time in minutes, starting when chopper leaving home position.
		_refuelTimeMin: Optional. Refuel time in minutes, starting when chopper has returned to base and start refueling.
		_chopperType: Optional. Class name of chopper to use.
		_minSkill: Optional. Skill for the different units in the group is a random value between this value and _maxSkill.
		_maxSkill: Optional. Skill for the different units in the group is a random value between _minSkill and this value.
		_unitArray: Optional. All created man units will be appended to this array.
		_debug: Optional. true if you want to monitor the chopper's different states through the player's side chat.
*/

if (!isServer) exitWith {};

private ["_homePos", "_side", "_searchAreaMarker", "_searchTimeMin", "_refuelTimeMin", "_minSkill", "_maxSkill", "_unitArray", "_debug"];
private ["_chopper", "_group", "_pilot", "_gunner1", "_gunner2"];
private ["_vehicleVarName", "_vehicleVarNameBase", "_vehicleVarNameNo"];

_homePos = _this select 0;
_side = _this select 1;
_searchAreaMarker = _this select 2;
if (count _this > 3) then {_searchTimeMin = _this select 3;} else {_searchTimeMin = 15};
if (count _this > 4) then {_refuelTimeMin = _this select 4;} else {_refuelTimeMin = 10};
if (count _this > 5) then {_minSkill = _this select 5;} else {_minSkill = 0.3;};
if (count _this > 6) then {_maxSkill = _this select 6;} else {_maxSkill = 0.6;};
if (count _this > 7) then {_unitArray = _this select 7;} else {_unitArray = [];};
if (count _this > 8) then {_debug = _this select 8;} else {_debug = false;};

//waituntil {!isnil "bis_fnc_init"};

if (_debug) then {
    player sideChat "Creating search chopper...";
};

/*
_result = [[_homePos select 0, _homePos select 1, 0], 0, _chopperType, _side] call BIS_fnc_spawnVehicle;
_chopper = _result select 0;
_crew = _result select 1;

// Set crew skill
{
	_skill = _minSkill + random (_maxSkill - _minSkill);
	_x setSkill _skill;
} foreach _crew;
*/

// Find a free vehicle variable name
_vehicleVarNameBase = "drn_searchChopper";
_vehicleVarNameNo = 1;
_vehicleVarName = _vehicleVarNameBase + str _vehicleVarNameNo;
while {!(isNil _vehicleVarName)} do {
	_vehicleVarNameNo = _vehicleVarNameNo + 1;
	_vehicleVarName = _vehicleVarNameBase + str _vehicleVarNameNo;
};

_chopper = "Mi17_Ins" createVehicle _homePos;
_chopper lock false;
_chopper setVehicleVarName _vehicleVarName;
_chopper call compile format ["%1=_this;", _vehicleVarName];

_group = createGroup _side;

"Ins_Soldier_Pilot" createUnit [position player, _group, "", (_minSkill + random (_maxSkill - _minSkill)), "LIEUTNANT"];
"Ins_Soldier_Pilot" createUnit [position player, _group, "", (_minSkill + random (_maxSkill - _minSkill)), "LIEUTNANT"];
"Ins_Soldier_Pilot" createUnit [position player, _group, "", (_minSkill + random (_maxSkill - _minSkill)), "LIEUTNANT"];

_unitArray = _unitArray + units _group;

_pilot = (units _group) select 0;
_gunner1 = (units _group) select 1;
_gunner2 = (units _group) select 2;

_pilot assignAsDriver _chopper;
_pilot moveInDriver _chopper;
_gunner1 assignAsGunner _chopper;
_gunner1 moveInTurret [_chopper, [0]];
_gunner2 assignAsGunner _chopper;
_gunner2 moveInTurret [_chopper, [1]];

{
    _x call drn_fnc_Escape_OnSpawnGeneralSoldierUnit;
} foreach units _group;

[_chopper, _searchAreaMarker, _searchTimeMin, _refuelTimeMin, _debug] execVM "Scripts\DRN\SearchChopper\SearchChopper.sqf";


