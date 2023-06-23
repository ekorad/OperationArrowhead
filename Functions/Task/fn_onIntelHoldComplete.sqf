/*
	Author: Zahiu Vlad

	Description:
	This function is part of the "Find Intel" task and should be called on every
	completion of the intel object hold action. After completing a hold action,
	there is a chance that the current subtask will fail, in which case the next
	available (incomplete) subtask will be assigned. In case of success, the
	parent task will be completed. Markers will be removed for every subtask
	accordingly.

	Parameter(s):
	_this select 0: STRING - current task name

	Returns:
	NOTHING
*/

/*******************************************************************************
 *                                   DEFINES                                   *
 *******************************************************************************/

#define DESCRIPTION_MARKER_INDEX 	2
#define GLOBAL_TASK_VAR_NAME_SUFFIX	"_successfulTask"

/*******************************************************************************
 *                                  ARGUMENTS                                  *
 *******************************************************************************/

private _currentTask = param[0, nil, [""]];

if (isNil "_currentTask") exitWith {
	["invalid argument: task name is nil"] call BIS_fnc_error;
};
if (_currentTask isEqualTo "") exitWith {
	["invalid argument: task name is empty"] call BIS_fnc_error;
};
if (!([_currentTask] call BIS_fnc_taskExists)) exitWith {
	["invalid argument: no task with name '%1'", _currentTask]
		call BIS_fnc_error;
};

private _parentTask = _currentTask call BIS_fnc_taskParent;
if (isNil "_parentTask") exitWith {
	["invalid argument: task with name '%1' has no parent task"]
		call BIS_fnc_error;
};

/*******************************************************************************
 *                                FUNCTION LOGIC                               *
 *******************************************************************************/

private _globalTaskVarName = _parentTask + GLOBAL_TASK_VAR_NAME_SUFFIX;
private _subTasks = _parentTask call BIS_fnc_taskChildren;
// "static" variable
private _successfulTask = missionNamespace getVariable [_globalTaskVarName,
	nil];
if (isNil "_successfulTask") then {
	_successfulTask = (_subTasks select (_subTasks call BIS_fnc_randomIndex));
	missionNamespace setVariable [_globalTaskVarName, _successfulTask, true];
};

if (_currentTask isEqualTo _successfulTask) then {
	{
		if (!(_x call BIS_fnc_taskCompleted)) then {
			private _subTaskMarker = ((_x call BIS_fnc_taskDescription)
				select DESCRIPTION_MARKER_INDEX) select 0;
			deleteMarker _subTaskMarker;
		};
	} forEach _subTasks;
	[_parentTask, "SUCCEEDED"] call BIS_fnc_taskSetState;
} else {
	private _subTaskMarker = ((_currentTask call BIS_fnc_taskDescription)
		select DESCRIPTION_MARKER_INDEX) select 0;
	deleteMarker _subTaskMarker;
	[_currentTask, "FAILED"] call BIS_fnc_taskSetState;

	private _incompleteSubTasks = _subTasks
		select { !([_x] call BIS_fnc_taskCompleted) };
	private _nextTask = _incompleteSubTasks
		select (_incompleteSubTasks call BIS_fnc_randomIndex);
	[_nextTask, "ASSIGNED"] call BIS_fnc_taskSetState;
};