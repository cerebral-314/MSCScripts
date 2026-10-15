#pragma context server

// Converted from other/keyhole_blue.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/base_keyhole.as"

[script "other/keyhole_blue"]
class KeyholeBlue : BaseKeyholeScript
{
	// Variables declared by included files, with the value they start with in this script
	KeyholeBlue()
	{
		KEY_NAME = "key_blue";
		KEYHOLE_NAME = "Blue Keyhole";
		KEYHOLE_TITLE = "Use the sapphire key";
	}

	// unnamed block (first think)
	void KeyholeBlue_FirstThink()
	{
		RETURN_KEY = false;
	}

	// key_used
	// PARAM1 = PlayerID , PARAM2 = keyname
	void OnKeyUsed(CBasePlayer@ playerId = null)
	{
		BaseKeyhole_OnKeyUsed(playerId); // other/base_keyhole
		UseTrigger("ustart");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KeyholeBlue_FirstThink();
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
