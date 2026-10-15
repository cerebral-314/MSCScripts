#pragma context server

// Converted from other/keyhole_treasury.script by msc_transpiler.
// Thothie - This keyhole only takes treasury keys, it will not return them

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_treasury"]
class KeyholeTreasury : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeTreasury()
	{
		KEY_NAME = "key_treasury";
		KEYHOLE_NAME = "Keyhole for the Treasury";
		KEYHOLE_TITLE = "Use the treasury key";
	}

	// unnamed block (first think)
	void KeyholeTreasury_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeTreasury_FirstThink();
	}
}
