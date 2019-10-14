/*

RESPAWN AT BASE DIALOG - 4 Buttons

© JULY 2007 - norrin
**********************************************************************************************************************************
respawn_button_4.hpp
*/

class Respawn_button_4b 
{
  idd = -1;
  movingEnable = true;
  controlsBackground[] = {};
  objects[] = { };
  controls[] = {Respawn_1b, Respawn_2b, Respawn_3b, Respawn_4b};   


	class Respawn_1b : NORRNRscNavButton
	{
	idc = 1;
	x = (safeZoneX + safeZoneW/2)-0.25; y = safeZoneY +0.2;
	w = 0.11; h = 0.04;
	text = "RESPAWN 1";
	action = "[1,player] execVM ""revive_sqf\respawn_at_base_jip.sqf""";
	};

	class Respawn_2b : NORRNRscNavButton
	{
	idc = 2;
	x = (safeZoneX + safeZoneW/2)-0.12; y = safeZoneY +0.2;
	w = 0.11; h = 0.04;
	text = "RESPAWN 2";
	action = "[2,player] execVM ""revive_sqf\respawn_at_base_jip.sqf""";

	};

	class Respawn_3b : NORRNRscNavButton
	{
	idc = 3;
	x = (safeZoneX + safeZoneW/2)+0.01; y = safeZoneY +0.2;
	w = 0.11; h = 0.04;
	text = "RESPAWN 3";
	action = "[3,player] execVM ""revive_sqf\respawn_at_base_jip.sqf""";
	};
	
	class Respawn_4b : NORRNRscNavButton
	{
	idc = 4;
	x = (safeZoneX + safeZoneW/2)+0.14; y = safeZoneY +0.2;
	w = 0.11; h = 0.04;
	text = "RESPAWN 4";
	action = "[4,player] execVM ""revive_sqf\respawn_at_base_jip.sqf""";
	};
};