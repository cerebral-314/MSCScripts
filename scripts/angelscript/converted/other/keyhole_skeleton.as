#pragma context server

// Converted from other/keyhole_skeleton.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_skeleton"]
class KeyholeSkeleton : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeSkeleton()
	{
		KEY_NAME = "key_skeleton";
		KEYHOLE_NAME = "Keyhole carved from bones";
		KEYHOLE_TITLE = "Use the skeleton key";
	}

	// unnamed block (first think)
	void KeyholeSkeleton_FirstThink()
	{
		RETURN_KEY = false;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeSkeleton_FirstThink();
	}
}
