/*
	Author: Zahiu Vlad

	Description:
	This file initializes the debug communication menu. This menu controls
	features such as AI behaviour or player invulnerability.
*/

MENU_DEBUG = [
	["Debug", false],

	["Test", [2], "", -5,
		[["expression", "hint 'Hello, world!';"]], "1", "1"]
];
publicVariable "MENU_DEBUG";

[player, "Debug"] call BIS_fnc_addCommMenuItem;