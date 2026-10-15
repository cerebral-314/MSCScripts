#pragma context server

// Converted from other/keyhole_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_ice"]
class KeyholeIce : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeIce()
	{
		KEY_NAME = "key_blue";
		KEYHOLE_NAME = "Ice Encrusted Keyhole";
		KEYHOLE_TITLE = "Use the Ice key";
	}

	// unnamed block (first think)
	void KeyholeIce_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeIce_FirstThink();
	}
}
