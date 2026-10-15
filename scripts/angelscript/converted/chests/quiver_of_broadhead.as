#pragma context server

// Converted from chests/quiver_of_broadhead.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_quiver_of.as"

[script "chests/quiver_of_broadhead"]
class QuiverOfBroadhead : BaseQuiverOfScript
{
	// Variables declared by included files, with the value they start with in this script
	QuiverOfBroadhead()
	{
		BQ_QUIVER_TYPE = "proj_arrow_broadhead";
		BQ_BUNDLE_SIZE = "60";
	}

	// unnamed block (first think)
	void QuiverOfBroadhead_FirstThink()
	{
		BQ_QUIVER_TYPE = "proj_arrow_broadhead";
		BQ_BUNDLE_SIZE = "60";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseQuiverOf_OnGameSpawn(playerRace, playerGender); // chests/base_quiver_of
		SetName("Quiver of Broadhead Arrows");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuiverOfBroadhead_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseQuiverOfScript::DispatchEvent(name, params);
	}
}
