#pragma context server

// Converted from other/keyhole_gold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_gold"]
class KeyholeGold : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeGold()
	{
		KEY_NAME = "key_gold";
		KEYHOLE_NAME = "Golden Keyhole";
		KEYHOLE_TITLE = "Use the gold key";
	}

	// unnamed block (first think)
	void KeyholeGold_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeGold_FirstThink();
	}
}
