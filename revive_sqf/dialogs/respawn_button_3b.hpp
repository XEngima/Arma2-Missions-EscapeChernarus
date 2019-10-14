/*

RESPAWN AT BASE DIALOG - 3 buttons

© JULY 2009 - norrin
**********************************************************************************************************************************
respawn_button_3.hpp
*/

class Respawn_button_3b {
  idd = -1;
  movingEnable = true;
  controlsBackground[] = {};
  objects[] = { };
  controls[] = {Respawn_1b, Respawn_2b, Respawn_3b};   


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
};