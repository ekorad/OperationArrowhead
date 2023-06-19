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
	_this select 0: STRING - Current task name

	Returns:
	NOTHING
*/

/*******************************************************************************
 *                               ARGUMENT CHECKS                               *
 *******************************************************************************/

private _currentSubTaskName = param[0, nil, [""]];

if (isNil "_currentSubTaskName") exitWith {
	["invalid argument: task name is nil"] call BIS_fnc_error;
};

if (!([_currentSubTaskName] call BIS_fnc_taskExists)) exitWith {
	["invalid argument: no task with name '%1'", _currentSubTaskName] call BIS_fnc_error;
};

private _parentTaskName = _currentSubTaskName call BIS_fnc_taskParent;
if (isNil "_parentTaskName") exitWith {
	["invalid argument: task '%1' has no parent task"] call BIS_fnc_error;
};

/*******************************************************************************
 *                                FUNCTION LOGIC                               *
 *******************************************************************************/

private _subTasks = [_parentTaskName] call BIS_fnc_taskChildren;
private _incompleteSubTasks = _subTasks select { !([_x] call BIS_fnc_taskCompleted) };
private _isLastSubTask = (count _incompleteSubTasks) == 1;

// if only one incomplete task left, force success; otherwise, roll dice
private _taskSuccessful = if (_isLastSubTask) then { 
	true
} else {
	([1, 1] call BIS_fnc_randomInt) == 1
};

if (_taskSuccessful) then {
	// remove remaining subtask markers
	{
		private _subTaskMarkerName = ((_x call BIS_fnc_taskDescription) select 2) select 0;
		deleteMarker _subTaskMarkerName;
	} forEach _incompleteSubTasks;

	[_parentTaskName, "SUCCEEDED"] call BIS_fnc_taskSetState;
} else {
	[_currentSubTaskName, "FAILED"] call BIS_fnc_taskSetState;

	// delete associated subtask marker
	private _subTaskMarkerName = ((_currentSubTaskName call BIS_fnc_taskDescription) select 2) select 0;
	deleteMarker _subTaskMarkerName;

	// refresh incomplete subtask array after setting subtask state
	_incompleteSubTasks = _subTasks select { !([_x] call BIS_fnc_taskCompleted) };

	// assign next random incomplete task
	private _nextSubtaskIndex = [_incompleteSubTasks] call BIS_fnc_randomIndex;
	[_incompleteSubTasks select _nextSubtaskIndex, "ASSIGNED", true] call BIS_fnc_taskSetState;
};