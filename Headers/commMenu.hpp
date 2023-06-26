/*
	Author: Zahiu Vlad

	Description:
	This file defines macros for facilitating the definition of custom
	communications menu. It uses the preprocessor counter for determining
	the menu item indexes.

	Example:
	UTIL_DEBUG_MENU = [
		MENU_TITLE("Debug"),

		MENU_ITEM_BUTTON("Disable AI combat", "hint 'Disabled AI combat'"),
		MENU_ITEM_BUTTON("Enable God mode", "hint 'Enabled God mode'")
	];
*/

#ifndef MENU_DEFINES_HPP
#define MENU_DEFINES_HPP

#include "utils.hpp"

__COUNTER_RESET__;	// reset counter to 0
__COUNTER__;		// count to 1
__COUNTER__;		// count to 2 - menu item index begins with 2

#define MENU_TITLE(title) [title, false]

#define MENU_ITEM_BUTTON(text, code) \
	[text, [__COUNTER__], "", -5, [["expression", STRINGIFY(code)]], "1", "1"]

#endif