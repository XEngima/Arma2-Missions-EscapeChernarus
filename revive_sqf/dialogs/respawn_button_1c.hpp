/*

RESPAWN AT BASE DIALOG

© JULY 2007 - norrin
**********************************************************************************************************************************
respawn_button_1c.hpp
*/

class Respawn_button_1c 
{
  idd = -1;
  movingEnable = true;
  controlsBackground[] = {};
  objects[] = { };
  controls[] = {Respawn_1b};   


	class Respawn_1b : NORRNRscNavButton
	{
		idc = 1;
		x = (safeZoneX + safeZoneW/2)-0.25; y = safeZoneY +0.2;
		w = 0.11; h = 0.04;
		text = "Wash Ashore";
		action = "[player] execVM ""revive_sqf\respawn_at_base_water.sqf""";
	};

	
};