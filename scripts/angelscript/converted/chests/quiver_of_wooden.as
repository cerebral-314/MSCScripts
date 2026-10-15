#pragma context server

// Converted from chests/quiver_of_wooden.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_quiver_of.as"

[script "chests/quiver_of_wooden"]
class QuiverOfWooden : BaseQuiverOfScript
{
	// Variables declared by included files, with the value they start with in this script
	QuiverOfWooden()
	{
		BQ_QUIVER_TYPE = "proj_arrow_wooden";
		BQ_BUNDLE_SIZE = "30";
	}

	// unnamed block (first think)
	void QuiverOfWooden_FirstThink()
	{
		BQ_QUIVER_TYPE = "proj_arrow_wooden";
		BQ_BUNDLE_SIZE = "30";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseQuiverOf_OnGameSpawn(playerRace, playerGender); // chests/base_quiver_of
		SetName("Quiver of Wooden Arrows");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuiverOfWooden_FirstThink();
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
