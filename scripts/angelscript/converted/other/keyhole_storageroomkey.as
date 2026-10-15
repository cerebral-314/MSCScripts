#pragma context server

// Converted from other/keyhole_storageroomkey.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_storageroomkey"]
class KeyholeStorageroomkey : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeStorageroomkey()
	{
		KEY_NAME = "item_storageroomkey";
		KEYHOLE_NAME = "Storageroom Keyhole";
		KEYHOLE_TITLE = "Use the Storageroom key";
	}

	// unnamed block (first think)
	void KeyholeStorageroomkey_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeStorageroomkey_FirstThink();
	}
}
