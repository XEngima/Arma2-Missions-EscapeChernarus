// NORRN_reviveDrag_C_keyDown.sqf

// ====================================================================================
private["_handled", "_ctrl", "_dikCode", "_shift", "_ctrl", "_alt"];
_ctrl = _this select 0;
_dikCode = _this select 1;
_shift = _this select 2;
_ctrl = _this select 3;
_alt = _this select 4;

if (!_shift && !_ctrl && !_alt) then
{
	if (_dikCode in ([DIK_C]+(actionKeys "NetworkStats"))) then
	{	
		hint "blogs";
		NORRN_noCkey = true;
		null = [] execVM "revive_sqf\functions\whileDragging_KEY_pressed.sqf";
	};
};
// ====================================================================================