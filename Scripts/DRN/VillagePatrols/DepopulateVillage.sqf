if (!isServer) exitWith {};

private ["_village", "_markerName", "_debug", "_soldiers", "_soldier", "_spawned", "_damage", "_soldierObj"];
private ["_groups", "_soldierPos", "_group", "_hasScript"];
private ["_deleteGroupDelayed"];

_village = _this select 0;
if (count _this > 1) then {_debug = _this select 1;} else {_debug = false;};

_markerName = _village select 0;
_groups = _village select 2;

if (_debug) then {
    player sideChat "Depopulating village (" + _markerName + ")";
};

_deleteGroupDelayed = {
    private ["_group"];
    
    _group = _this select 0;

/*
    {
        _x setPos [-1000, -1000, 0];
    } foreach units _group;
    
    sleep 15;
*/
    
    {
        deleteVehicle _x;
    } foreach units _group;
    deleteGroup _group;
};

{
	_soldiers = _x;

	_soldier = _soldiers select 0;
	_soldierObj = _soldier select 3;
	_group = group _soldierObj;
	_soldierObj = leader _group;
	//_script = _soldierObj getVariable "activeScript";
	//_script = _soldier select 4;
	_hasScript = _soldier select 9;

	if (_hasScript) then {
		//terminate _script;
		//(group _soldier) setVariable ["UPSMON_exit", true];
	};

	{
		_soldier = _x;
		//_soldier = [_soldierType, _damage, _spawned, _soldierObj, _script, _soldierPos, _skill, _ammo, _rank, _hasScript];

		_spawned = _soldier select 2;
		_soldierObj = _soldier select 3;
		//_script = _soldier select 4;
		_hasScript = _soldier select 9;

		if (_spawned) then {
			_damage = damage _soldierObj;
			_soldierPos = getPos _soldierObj;
			//_ammo = ammo _soldierObj;
			
			if (!canStand _soldierObj) then {
				_damage = 1;
			};

			if (_hasScript) then {
				//terminate _script;
			};

			//deleteVehicle _soldierObj;
			//(group _soldier) setVariable ["UPSMON_exit", true];

			_soldier set [1, _damage];
			_soldier set [2, false];
			_soldier set [3, objNull];
			_soldier set [4, objNull];
			_soldier set [5, _soldierPos];
			//_soldier set [7, _ammo];
		};

	} foreach _soldiers;

	//_group setVariable ["UPSMON_exit", true];
	//deleteGroup _group;
    
    [_group] spawn _deleteGroupDelayed;
    sleep 0.5;
} foreach _groups;



