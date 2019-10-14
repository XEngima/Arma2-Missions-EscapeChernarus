/*
  HEAL_ACTION SCRIPT

  Causes the player to execute the medic animation when the heal action is chosen and resets dammage to 0.

  © AUGUST 2010 - norrin 

***********************************************************************************************************************
begin heal.sqf
*/

player playMove "AinvPknlMstpSlayWrflDnon_medic";
player setdammage 0;
if (NORRN_R_SP) then {player setVariable ["NORRN_totalDamage", 0, false]};
NORRN_healed = true;

sleep 8;
if (true) exitWith {};
//file last edited 130109