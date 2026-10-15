#pragma context server

// Converted from other/keyhole_rusty.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_rusty"]
class KeyholeRusty : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeRusty()
	{
		KEY_NAME = "item_key_rusty";
		KEYHOLE_NAME = "Rusty Keyhole";
		KEYHOLE_TITLE = "Use the rusty key";
	}

	// unnamed block (first think)
	void KeyholeRusty_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeRusty_FirstThink();
	}
}
