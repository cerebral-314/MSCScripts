#pragma context server

// Converted from other/keyhole_sewer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_sewer"]
class KeyholeSewer : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeSewer()
	{
		KEY_NAME = "item_key_sewer";
		KEYHOLE_NAME = "Sewer Maintenance Keyhole";
		KEYHOLE_TITLE = "Use the maintenance key";
	}

	// unnamed block (first think)
	void KeyholeSewer_FirstThink()
	{
		RETURN_KEY = false;
	}

	// key_used
	void OnKeyUsed(CBasePlayer@ playerId = null)
	{
		BaseKeyhole_OnKeyUsed(playerId); // other/base_keyhole

		UseTrigger("ustart"); // MSR has old deraliasewers source, so this trigger is required to open the door.
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeSewer_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "key_used") { OnKeyUsed(PlayerParam(params, 0)); return true; }
		return BaseKeyholeScript::DispatchEvent(name, params);
	}
}
