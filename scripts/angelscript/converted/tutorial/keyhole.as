#pragma context server

// Converted from tutorial/keyhole.script by msc_transpiler.
// Keyhole for Tutorial map. CMD

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "tutorial/keyhole"]
class TutorialKeyhole : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	TutorialKeyhole()
	{
		KEY_NAME = "tutorial_key";
		KEYHOLE_NAME = "keyhole";
		KEYHOLE_TITLE = "Use Key";
	}

	// unnamed block (first think)
	void TutorialKeyhole_FirstThink()
	{
		RETURN_KEY = false;
	}

	// spawn
	void OnSpawn()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TutorialKeyhole_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spawn") { OnSpawn(); return true; }
		return BaseKeyholeScript::DispatchEvent(name, params);
	}
}
