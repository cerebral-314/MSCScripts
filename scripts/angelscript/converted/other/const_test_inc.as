#pragma context server

// Converted from other/const_test_inc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ConstTestInc
{
	// Constants
	int BOTTOM_CONST = 2;
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/const_test_inc"]
shared class ConstTestIncScript : ScriptEntity, ConstTestInc
{
	// Variables every script that includes this file declares
	bool TOP_CONST = false;
}
