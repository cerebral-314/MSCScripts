#pragma context server

// Converted from other/keyhole_green.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_green"]
class KeyholeGreen : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeGreen()
	{
		KEY_NAME = "key_green";
		KEYHOLE_NAME = "Jade Keyhole";
		KEYHOLE_TITLE = "Use the jade key";
	}

	// unnamed block (first think)
	void KeyholeGreen_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeGreen_FirstThink();
	}
}
