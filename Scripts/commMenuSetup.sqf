/*
	Author: Zahiu Vlad

	Description:
	This file initializes the custom communication menu. Multiple submenus can
	exist, each with its own setup SQF file.
*/

// The "Debug" menu should only be enabled during mission development
if (UTIL_missionInDevelopment) then {
	call compile preprocessFile "Scripts\debugMenuSetup.sqf";
};