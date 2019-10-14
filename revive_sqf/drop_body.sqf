/*
 DROP BODY SCRIPT

 Allows players to drop unconscious bodies

 JULY 2010 - norrin
*****************************************************************************************************************************
Start drop_body.sqf
*/

_dragee	= _this select 3; 

player removeAction NORRN_dropAction; 
NORRN_remove_drag = true;  
r_drag_sqf = false;
_unit = player;

detach _unit;
detach _dragee;
_unit switchMove "";
NORRN_Dragged_body = objNull;
_dragee setVariable ["NORRN_unit_dragged", false, true]; 
sleep 8;

if (true) exitWith {};