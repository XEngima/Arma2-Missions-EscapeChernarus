/*
  HEAL_ACTION SCRIPT

  Causes the unit to execute the medic animation when the revive action is chosen

  © OCTOBER 2010 - norrin 

***********************************************************************************************************************
begin heal.sqf
*/
_array				= _this select 3;
_name				= _array select 0;
_wounded			= _array select 1;				
_QG_animation		= NORRN_revive_array select 54;
_medpacks			= NORRN_revive_array select 80;
_reward_function 	= NORRN_revive_array select 96;

_wounded setVariable ["NORRN_unit_dragged", true, true];
if (_QG_animation == 1) then {_wounded playMoveNow "ainjppnemstpsnonwrfldnon"};
sleep 1; 

if (!isplayer _name) then
{
	_name playMove "AinvPknlMstpSlayWrflDnon_medic";
} else {
	if (_QG_animation == 1) then 
	{
		_wounded attachTo [_name,[0,1.1,0]];
		sleep 0.02;
		_wounded setVehicleInit "this setDir 170;";
		processInitCommands;
		_name playMoveNow "ainvpknlmstpsnonwnondr_medic3";
	} else {
		_name playMove "AinvPknlMstpSlayWrflDnon_medic";
	};		
};
if (_medpacks == 1) then
{
	_var = _name getVariable "Norrn_medpacks";
	_name setVariable ["Norrn_medpacks", (_var - 1), true];	
	if (_name == player) then
	{
		_med_supplies = format ["Medpacks Remaining: %1\nBandages  Remaining: %2", _name getVariable "Norrn_medpacks", _name getVariable "Norrn_bandages"];
		hint _med_supplies;
	};
};
sleep 9;
if (_reward_function == 1) then
{
	_var = _name getVariable "NORRN_bonus_life";
	_name setVariable ["NORRN_bonus_life", _var + 1, false];
};
if (_QG_animation == 1 && isplayer _name) then
{
	sleep 2;
	_name playMoveNow "ainvpknlmstpsnonwnondr_medic0";
	sleep 9;
	_name playMoveNow "ainvpknlmstpslaywrfldnon_1";
	detach _wounded;
};
_name SetVariable ["Norrn_heyImBusy", false, true];
if (true) exitWith {};

//020709