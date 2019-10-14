/*

REVIVE CAMERA BLANK DIALOG

© JULY 2010 - norrin  
**********************************************************************************************************************************
rev_cam_dialog.hpp
*/

class rev_cam_dialog_blank 
{
	idd = 99993;   
	movingEnable = false;
	objects[] = {};
	controls[] = {mouse};
	controlsBackground[] = {};
	
	class mouse  : NORRNmouseHandler {};
	
};

