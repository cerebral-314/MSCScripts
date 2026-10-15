#pragma context server

// Converted from items/crest_gow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_crest.as"

[script "items/crest_gow"]
class CrestGow : BaseCrestScript
{
	// Variables declared by included files, with the value they start with in this script
	CrestGow()
	{
		MODEL_CREST_OFS = 18;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseCrest_OnGameSpawn(playerRace, playerGender); // items/base_crest

		SetName("Crest of the Gods of War");
		SetDescription("Crest of the Gods of War Guild");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseCrestScript::DispatchEvent(name, params);
	}
}
