#pragma context server

// Converted from other/keyhole_red.script by msc_transpiler.
// Thothie - This keyhole only takes red keys, it will not return them

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_red"]
class KeyholeRed : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeRed()
	{
		KEY_NAME = "key_red";
		KEYHOLE_NAME = "Blood Stained Keyhole";
		KEYHOLE_TITLE = "Use the crimson key";
	}

	// unnamed block (first think)
	void KeyholeRed_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeRed_FirstThink();
	}
}
