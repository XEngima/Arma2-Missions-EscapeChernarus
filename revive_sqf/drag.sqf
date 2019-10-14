/*

 DRAG BODY SCRIPT

 Allows players to drag unconscious bodies 

 JULY 2010 - norrin
*****************************************************************************************************************************
Start drag.sqf
*/

private ["_unit","_dragee","_pos","_dir"];
_dragee				= _this select 3;
_can_be_revived 	= NORRN_revive_array select 20;
_can_be_revived_2 	= NORRN_revive_array select 21;
_unit  				= player;

if (isNull _dragee) exitWith {}; 

// Add "C" key down eventhandler
NORRN_noCkey  = false;
NORRN_reviveDrag_C_keyDownEHId = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this call NORRN_reviveDrag_C_keyDown"];

//player assumes dragging posture
_dragee setVariable ["NORRN_unit_dragged", true, true]; 
_unit playMove "acinpknlmstpsraswrfldnon";
sleep 2;

//unconscious unit assumes dragging posture
//public EH 
norrnRaDrag = _dragee;
publicVariable "norrnRaDrag";
_dragee switchmove "ainjppnemstpsnonwrfldb_still";
_dragee attachto [_unit,[0.1, 1.01, 0]];
sleep 0.02;
//rotate wounded units so that it is facing the correct direction
norrnR180 = _dragee;
publicVariable "norrnR180";
_dragee  setDir 180;
r_drag_sqf 	= true;

//Uneccesary actions removed & drop body added 
player removeAction Norrn_dragAction;
player removeAction Norrn_reviveAction;
NORRN_dropAction = player addAction ["Drop body", "revive_sqf\drop_body.sqf",_dragee, 0, false, true];
sleep 1;

while {r_drag_sqf} do
{	
	_anim_name = animationstate _unit; 
	if (!alive _dragee ||  !((animationstate _unit) in ["acinpknlmstpsraswrfldnon","acinpknlmwlksraswrfldb"])  || !(_dragee getVariable "NORRN_AIunconscious" || NORRN_noCkey)) exitWith
	{ 
		player removeAction NORRN_dropAction;
		detach _dragee; 
		sleep 0.5;
		_unit switchMove "";
		sleep 1;
		r_drag_sqf = false;
	};	 

	//if unconcious unit
	if (_unit getVariable "NORRN_unconscious") exitWith 
	{	
		player removeAction NORRN_dropAction;
		detach _unit;
		detach _dragee;
		sleep 1;
		r_drag_sqf = false;
	}; 	
	sleep 0.1;
};
if (alive _dragee && (_dragee getVariable "NORRN_AIunconscious")) then 
{	
	//public EH
	norrinRAlie = _dragee;
	publicVariable "norrinRAlie";
	_dragee switchMove "ainjppnemstpsnonwrfldnon";
};

// Remove "C" key down eventhandler
(findDisplay 46) displayRemoveEventHandler ["KeyDown", NORRN_reviveDrag_C_keyDownEHId];

if (true) exitWith {};
