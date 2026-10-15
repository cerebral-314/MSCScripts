#pragma context server

// Converted from other/keyhole_brass.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_brass"]
class KeyholeBrass : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeBrass()
	{
		KEY_NAME = "key_brass";
		KEYHOLE_NAME = "Brass Keyhole";
		KEYHOLE_TITLE = "Use the brass key";
	}

	// unnamed block (first think)
	void KeyholeBrass_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeBrass_FirstThink();
	}
}
