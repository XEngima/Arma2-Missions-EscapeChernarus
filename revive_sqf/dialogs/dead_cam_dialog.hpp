/*

Dead CAMERA DIALOG

© JULY 2009 - norrin  
**********************************************************************************************************************************
dead_cam_dialog.hpp
*/

class dead_cam_dialog 
{
	idd = 99128;   
	movingEnable = false;
	objects[] = {};
	controls[] = {mouse,TOP_BORDER,BOTTOM_BORDER,TITLE_DIALOG,PRESS_HELP,HELP_DIALOG,CAM_LIST,CAM_select,FRIEND_LIST,FRIEND_select};
	controlsBackground[] = {};
	
	class mouse  : NORRNmouseHandler {};
	
	class TOP_BORDER 
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_CENTER;
		x = -1.5; y = safeZoneY;
		w = 4.0; h = 0.26;
		font = "TahomaB";
		sizeEx = 0.04;
		colorText[] = { 1, 1, 1, 1 };
		colorBackground[] = {0,0,0,1};
		text = "";
	};

	class BOTTOM_BORDER	
	{
		idc = -1;
		type = CT_STATIC;
		style = ST_CENTER;
		x = -1.5; y = (safeZoneY + safeZoneH) -0.25;
		w = 4.0; h = 0.25;
		font = "TahomaB";
		sizeEx = 0.04;
		colorText[] = { 1, 1, 1, 1 };
		colorBackground[] = {0,0,0,1};
		text = "";
	};	

	class TITLE_DIALOG 
	{
		idc = -1;
		type = CT_ACTIVETEXT;
		style = ST_LEFT;
		x = (safeZoneX + safeZoneW/2)-0.1; y = 0.03 + safeZoneY;
		w = 0.4; h = 0.04;
		font = "TahomaB";
		sizeEx = 0.04;
		color[] = { 1, 1, 1, 1 };
		colorActive[] = { 1, 0.2, 0.2, 1 };
		colorText[] = { 1, 1, 1, 1 };
		colorBackground[] = {0,0,0,1};
		soundEnter[] = { "", 0, 1 };   // no sound
		soundPush[] = { "", 0, 1 };
		soundClick[] = { "", 0, 1 };
		soundEscape[] = { "", 0, 1 };
		action = "";
		text = "Spectate Camera";
		default = true;
	};
	
	class PRESS_HELP : NORRNRscText 
	{    
		idc = 10000;
		style = ST_MULTI; 
		linespacing = 1;
		x = (safeZoneX + safeZoneW) -0.25; y = (safeZoneY + safeZoneH) -0.18;
		w = 0.2; h = 0.1;  
		text = ""; 
	};
	
	class HELP_DIALOG : NORRNRscActiveText 
	{
		idc = -1;
		style = ST_LEFT; 
		linespacing = 1;	
		x = (safeZoneX + safeZoneW) -0.25; y = (safeZoneY + safeZoneH) -0.2;
		w = 0.4; h = 0.02;
		sizeEx = 0.02;
		action = "ctrlSetText [10000, ""Keyboard controls:\n A/D - Previous/Next target\n W/S - Previous/Next camera\n N - Toggle NV for Free Cam""]";
		text = "Press for Help";
	};
	
	class CAM_LIST: NORRNRscCombo  
	{
		idc = 10004;
		x = safeZoneX +0.09; y = safeZoneY +0.03;
		w = 0.15; h = 0.04;
		//sizeEx = 0.02; 
	};

	class CAM_select 
	{
		idc = 10001;
		type = CT_STATIC;        
		style = ST_LEFT; 
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		x = safeZoneX +0.02; y = safeZoneY +0.03;
		w = 0.08; h = 0.04;
		font = "TahomaB";
		sizeEx = 0.02;
		text = "Camera:";
		default = true;
	};

	class FRIEND_LIST: NORRNRscCombo  
	{
		idc = 10005;
		x = (safeZoneX + safeZoneW)-0.18; y = safeZoneY +0.03;
		w = 0.15; h = 0.04;
	};

	class FRIEND_select 
	{	
		idc = 10002;
		type = CT_STATIC;        
		style = ST_LEFT; 
		colorText[] = {1, 1, 1, 1};
		colorBackground[] = {0,0,0,0};
		x = (safeZoneX + safeZoneW)-0.25; y = safeZoneY +0.03;
		w = 0.08; h = 0.04;
		font = "TahomaB";
		sizeEx = 0.02;
		text = "Target:";
		default = true;
	};


};

