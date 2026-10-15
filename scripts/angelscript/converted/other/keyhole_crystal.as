#pragma context server

// Converted from other/keyhole_crystal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_crystal"]
class KeyholeCrystal : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeCrystal()
	{
		KEY_NAME = "key_crystal";
		KEYHOLE_NAME = "Crystal Keyhole.";
		KEYHOLE_TITLE = "Use the crystal key.";
	}

	// unnamed block (first think)
	void KeyholeCrystal_FirstThink()
	{
		RETURN_KEY = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeCrystal_FirstThink();
	}
}
