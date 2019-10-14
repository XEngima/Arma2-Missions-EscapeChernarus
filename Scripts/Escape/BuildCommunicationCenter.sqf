private ["_centerPos", "_rotateDir", "_staticWeaponClasses", "_parkedVehicleClasses"];
private ["_pos", "_dir", "_posX", "_posY", "_sectionDir", "_guns", "_gun", "_vehicle", "_powerGenerator"];
private ["_fnc_CreateObject"];

_centerPos = _this select 0;
_rotateDir = _this select 1;
if (count _this > 2) then { _staticWeaponClasses = _this select 2; } else { _staticWeaponClasses = []; };
if (count _this > 3) then { _parkedVehicleClasses = _this select 3; } else { _parkedVehicleClasses = []; };

_fnc_CreateObject = {
    private ["_className", "_relativePos", "_relativeDir", "_centerPos", "_rotateDir"];
    private ["_object", "_realPos", "_realDir"];
    
    _className = _this select 0;
    _relativePos = _this select 1;
    _relativeDir = _this select 2;
    _centerPos = _this select 3;
    _rotateDir = _this select 4;
    
    _realPos = ([_centerPos, [(_centerPos select 0) + (_relativePos select 0), (_centerPos select 1) + (_relativePos select 1)], _rotateDir] call drn_fnc_CL_RotatePosition);
    _realDir = _relativeDir + _rotateDir;
    _object = createVehicle [_className, _realPos, [], 0, "CAN_COLLIDE"];
    _object setDir _realDir;
    
    _object
};

// Bagfence

/*
// (North western corner)
_pos = [-18, 16.5];
_dir = 90;
["Land_fort_bagfence_corner", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
*/

//(North western wall)
_pos = [-18, 15.15];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// (Western wall)
_posX = -19.2;
_sectionDir = 270;

_pos = [_posX, 14];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -4];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -1];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 2];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 5];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 8];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 11];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -7];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -10];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// (Southern wall)
_posY = -11.2;

_pos = [-18, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [-15, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [-12, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [-9, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [-6, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [-3, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [0, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [3, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [6, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [9, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [12, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [15, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [18, _posY];
_dir = 0;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// (Eastern wall)
_posX = 19.2;
_sectionDir = 90;

_pos = [_posX, -10];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -7];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -4];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, -1];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 2];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 5];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 8];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 11];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [_posX, 14];
_dir = _sectionDir;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// (North eastern wall)
_pos = [18, 15.15];
_dir = 180;
["Land_fort_bagfence_long", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Barracks

_pos = [-13, -3];
_dir = 180;
["Barrack2", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Power Generator
_pos = [4, -7];
_dir = 90;
_powerGenerator = ["PowGen_Big", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
_powerGenerator setVehicleInit "this addAction [""Hijack communication center"", ""Scripts\Escape\Hijack.sqf""];";
processInitCommands;

// Antennas

_pos = [-4, -8];
_dir = 90;
["Land_Antenna", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [14, 2];
_dir = 90;
["Land_Antenna", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Toilet

_pos = [-8, -9];
_dir = 180;
["Land_Toilet", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Fuel Tank
_pos = [11, -7];
_dir = 90;
["Land_Ind_TankSmall2", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Camo Nets
_pos = [-13, -6];
_dir = 180;
["Land_CamoNetB_EAST", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [7, -9];
_dir = 180;
["Land_CamoNetB_EAST", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

_pos = [16, 9];
_dir = 90;
["Land_CamoNetVar_EAST", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Field Hospital
_pos = [-15.5, 9];
_dir = 90;
["MASH_EP1", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

// Flag
_pos = [0, 10];
_dir = 0;
["FlagCarrierINS", _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;

if (count _staticWeaponClasses > 0) then {
    // Statics
    _pos = [-17, 13.5];
    _dir = 0;
    
    _gun = _staticWeaponClasses select floor random count _staticWeaponClasses;
    [_gun, _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
    
    _pos = [17, -9.5];
    _dir = 135;
    
    //_guns = ["DSHkM_Mini_TriPod", "AGS_Ins", "DSHKM_Ins"];
    _guns = ["DSHKM_Ins"];
    _gun = _guns select floor random count _guns;
    [_gun, _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
};

if (count _parkedVehicleClasses > 0) then {
    // Cars
    _pos = [15.5, 12];
    _dir = 270;
    
    _vehicle = _parkedVehicleClasses select floor random count _parkedVehicleClasses;
    [_vehicle, _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
    
    _pos = [15.5, 6.5];
    _dir = 270;
    
    _vehicle = _parkedVehicleClasses select floor random count _parkedVehicleClasses;
    [_vehicle, _pos, _dir, _centerPos, _rotateDir] call _fnc_CreateObject;
};




