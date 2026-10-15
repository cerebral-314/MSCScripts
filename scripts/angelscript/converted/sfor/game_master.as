#pragma context server

// Converted from sfor/game_master.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "sfor/game_master"]
class SforGameMaster : ScriptEntity
{
	// undamael_reward_victor
	void OnUndamaelRewardVictor(string swordLocation = "")
	{
		if (MaxHealthOf(GetVar("FSHARD_STARTED")) >= 700.0f)
			CreateNpc("monsters/summon/felewyn_shard", Vec(swordLocation), GetVar("FSHARD_STARTED"));
	}

	// undamael_reward_victor2
	void OnUndamaelRewardVictor2()
	{
		OnUndamaelRewardVictor("GM_TEMP_SWORD_LOC");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "undamael_reward_victor") { OnUndamaelRewardVictor(Param(params, 0)); return true; }
		if (name == "undamael_reward_victor2") { OnUndamaelRewardVictor2(); return true; }
		return false;
	}
}
