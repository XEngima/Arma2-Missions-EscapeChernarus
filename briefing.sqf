private ["_isJipPlayer"];

_isJipPlayer = _this select 0;

drn_rendesvouzTasks = [];
drn_hijackTasks = [];

drn_SetTaskStateEventArgs = []; // taskName, state

drn_SetTaskStateLocal = {
	private ["_taskList", "_state"];
	private ["_code"];

	_taskList = _this select 0;
	_state = _this select 1;
	
	_code = "{_x setTaskState """ + _state + """} foreach " + _taskList + ";";
    diag_log _code;
	call compile _code;

	if (isServer) then {
		private ["_code2"];

		_code2 = _taskList + "Status = """ + _state + """; publicVariable """ + _taskList + "Status"";";
        diag_log _code2;
		call compile _code2;
	};
};

"drn_SetTaskStateEventArgs" addPublicVariableEventHandler {
	drn_SetTaskStateEventArgs call drn_SetTaskStateLocal;
};

drn_SetTaskStateOnAllMachines = {
	private ["_taskList", "_state"];

	_taskList = _this select 0;
	_state = _this select 1;

	drn_SetTaskStateEventArgs = [_taskList, _state];
	publicVariable "drn_SetTaskStateEventArgs";
	drn_SetTaskStateEventArgs call drn_SetTaskStateLocal;
};

if (isServer) then {
    drn_rendesvouzTasksStatus = "CREATED";
    publicVariable "drn_rendesvouzTasksStatus";
    
    drn_hijackTasksStatus = "CREATED";
    publicVariable "drn_hijackTasksStatus";
};

{
    if (!isNil "_x") then {
        private ["_task"];
        
        _task = _x createSimpleTask ["Rendesvouz with allied forces."];
        _task setSimpleTaskDescription ["Rendesvouz with allied forces.", "Rendesvouz with allied forces.", ""];
        drn_rendesvouzTasks set [count drn_rendesvouzTasks, _task];
        
        _task = _x createSimpleTask ["Hijack a communication center"];
        _task setSimpleTaskDescription ["Hijack a communication center.", "Hijack a communication center", ""];
        drn_hijackTasks set [count drn_hijackTasks, _task];
        
        _x createDiaryRecord ["Diary", ["Mission *important*", "The guards took everything you had, weapons, maps, compasses, everything.<br /><br />If you manage to escape from the temporary prison, be sure the insurgents will send what they have to try to find you.<br /><br />All enemy units have heard about your activities and capture. If you are detected by an enemy unit, the unit will contact its headquarter within seconds (so if you take action quickly, the information may never reach the headquarter).<br /><br />If your position is reported to headquarter, the insurgent search leader will focus the search in an area close to the reported position. If they lose track of you, they will assume you are still in the vicinity, and widen the search area after some amount of time.<br /><br />Chernarus is full of innocent civilians that are already oppressed by the Red Star Movement and currently not interested regarding your presence. However, if they feel threatened (that is if you kill one) they will turn against you and help the Red Start Movement by reporting in your position whenever they see you. You will also get a minus five points punishment.<br /><br />To find your way home you will need to establish radio contact with your own HQ. The enemy communication centers can be hijacked! (Communication centers are marked on map as insurgent flag).<br /><br />The enemy communication centers are heavily guarded and take some time to hijack. You are lucky to have a talented FAC Operator in your group, who can handle such tasks quicker. To get near a communication center you will need heavy weapons.<br /><br />The Red Star Movement stores heavy weapons in its ammunition depots (marked on map as depot marker).<br /><br />To find the ammunition depots and communication centers you must first find an insurgent map.<br /><br />You never die, you only get unconscious, and your skillful teammates can fix you in almost any shape. Some wounds can only be healed by the corpsman.<br /><br />The brotherhood among you is a strength that increases to your chances, so beware of killing each other (which will result in a minus ten points punishment)."]];
        _x createDiaryRecord ["Diary", ["Situation", "You are held prisoner in an outdoor temporary prison. Armed guards are watching your every move while waiting for higher ranked insurgent army soldiers to arrive for your questioning. Since the guards that captured you by now know too much of your intentions, you are already treated as a high priority target. At best you will be treated as a prisoner of war, but having heard of the Red Star Movement's interrogation methods, you suspect that the questioning will not follow conventional methods. Add the value of the intelligence you have, which will be of enormous importance for the upcoming invasion, and you surely want to keep your eyes open for a good occasion to escape. Maybe you will have your window of opportunity. The guard standing on your side of the walls doesn't seem to look very well, does he...?"]];
        _x createDiaryRecord ["Diary", ["Intelligence Revealed", "The Red Star Movement seems to know about the upcoming invasion, and works hard with defensive preparations. They have stationed ammunition depots all over Chernarus, as well as advanced communication centers guarded by heavy armor."]];
        _x createDiaryRecord ["Diary", ["Background", "Before the invasion of Chernarus a group of highly skilled army specialists were sent into the heart of the enemy's territory. The goal of their mission was to gather intelligence, classified as top priority information, of the Red Star Movement's defensive structures. While the mission in itself was very successful and revealed even more useful information than hoped for, the withdrawal from Chernarus was not. On the small and snaky roads of Chernarus they made one single mistake and suddenly found themselves lost. If even just for a minute, it was enough to shortly thereafter run straight into a heavily guarded road block. Without a chance to fight they were caught and taken prisoners to a temporary outdoor prison."]];
        _x createDiaryRecord ["Diary", ["Global Background", "The United States has secretly and for some time been planning the invasion of Chernarus beginning in a couple of weeks."]];
        
    };
} foreach call drn_fnc_Escape_GetPlayers;

// If JIP player then set completed tasks
if (_isJipPlayer) then {
    diag_log "DEBUG START";
    if (!isNil "drn_rendesvouzTasksStatus") then {
        diag_log ("[drn_rendesvouzTasks, " + str drn_rendesvouzTasksStatus + "]");
        ["drn_rendesvouzTasks", drn_rendesvouzTasksStatus] call drn_SetTaskStateLocal;
    };
    
    if (!isNil "drn_hijackTasksStatus") then {
        diag_log ("[drn_hijackTasks, " + str drn_hijackTasksStatus + "]");
        ["drn_hijackTasks", drn_hijackTasksStatus] call drn_SetTaskStateLocal;
    };
};



