/*
	Author: Zahiu Vlad

	Description:
	This file initializes the debug communication menu. This menu controls
	features such as AI behaviour or player invulnerability.
*/

#include ".\..\Headers\commMenu.hpp"

UTIL_DEBUG_MENU = [
	MENU_TITLE("Debug"),

	MENU_ITEM_BUTTON("Disable AI combat", hint 'Disabled AI combat'),
	MENU_ITEM_BUTTON("Enable God mode", hint 'Enabled God mode')
];
publicVariable "UTIL_DEBUG_MENU";

[player, "Debug"] call BIS_fnc_addCommMenuItem;