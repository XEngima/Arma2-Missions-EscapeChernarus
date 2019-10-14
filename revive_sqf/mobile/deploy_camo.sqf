/*
DEPLOY CAMO SCRIPT

© norrin, SEPTEMBER 2010 
***********************************************************************************************************************************
deploy_camo.sqf
*/

_vcl 				= _this select 0;
_pos_vcl 			= getPos _vcl;
_dir_vcl 			= getDir _vcl;
_camoNet			= "Land_CamoNetB_NATO_EP1";

switch (playerSide) do 
{
	case west: {"USBasicAmmunitionBox_EP1" createVehicle [_pos_vcl select 0, (_pos_vcl select 1) - 2, (_pos_vcl select 2) - 4];};
	case east: {"TKBasicAmmunitionBox_EP1" createVehicle [_pos_vcl select 0, (_pos_vcl select 1) - 2, (_pos_vcl select 2) - 4];};
	case resistance: {"GuerillaCacheBox_EP1" createVehicle [_pos_vcl select 0, (_pos_vcl select 1) - 2, (_pos_vcl select 2) - 4];};
};

_vcl setFuel 0;
_camo =  _camoNet createVehicle _pos_vcl;
_camo setDir (_dir_vcl + 90);
_camo setPos [(_pos_vcl select 0) + (sqrt (4) * cos (155 - _dir_vcl)), (_pos_vcl select 1) + (sqrt (4) * sin (155 - _dir_vcl)) , 0];

NORRN_camo_net = true;
publicVariable "NORRN_camo_net";
_vcl removeAction NORRN_l_spawn_act;

if (true) exitWith {}; 

