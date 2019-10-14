// createBody.sqf
// © AUGUST 2010 - norrin

_name 			= _this select 0;
_magazines		= _this select 1;
_weapons		= _this select 2;
_dir			= _this select 3;
_bag			= _this select 4;
_bagMags		= _this select 5;
_bagWeps		= _this select 6;
_pos 			= _name getVariable "NORRN_uncPos";
_unit_type 		= typeOf _name;
call compile format ["norrn_dead_%1 = nullObj", _name];

call compile format ["_unit_type createUnit [(getMarkerPos 'Boot_hill'), group server, 'this setcaptive true;
										    this switchMove ''DeadState'';
											this disableAI ''ANIM'';
											this setVehicleVarName ''norrn_dead_%1'';											    
											norrn_dead_%1 = this;
											removeAllItems this; 
											removeAllWeapons this;
											{this addMagazine _x;} forEach %2;
											{this addWeapon _x;} forEach %3;']", _name, _magazines,_weapons];
waitUntil {!isNull (call compile format ["norrn_dead_%1", _name])};											
_deadUnit = call compile format ["norrn_dead_%1", _name];
_deadUnit setDir _dir;
_deadUnit setPos _pos;

if (!isNull (unitBackpack _deadUnit)) then 
{
	removeBackpack _deadUnit;
};
if (!isNull _bag) then
{
	_bagType = typeOf _bag;
	_deadUnit addBackpack _bagType;
	sleep 0.1;
	_bag = unitBackpack _deadUnit;
	clearMagazineCargo _bag;
	clearWeaponCargo _bag;
	if (count _bagMags > 0) then
	{	
		_magTypes = _bagMags select 0;
		_noMags	  = _bagMags select 1;
		for [{ _loop = 0 },{ _loop < count _magTypes},{ _loop = _loop + 1}] do
		{
			_magType = _magTypes select _loop;
			_noMag	 = _noMags select _loop;
			_bag addMagazineCargo [_magType, _noMag];
			sleep 0.01;
		};
	};
	if (count _bagWeps > 0) then
	{	
		_wepTypes = _bagWeps select 0;
		_noWeps	  = _bagWeps select 1;
		for [{ _loop = 0 },{ _loop < count _wepTypes},{ _loop = _loop + 1}] do
		{
			_wepType = _wepTypes select _loop;
			_noWep	 = _noWeps select _loop;
			_bag addWeaponCargo [_wepType, _noWep];
			sleep 0.01;
		};
	};
};
sleep 1;
_deadUnit setdamage 1.0;
