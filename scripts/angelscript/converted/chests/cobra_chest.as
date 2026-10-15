#pragma context server

// Converted from chests/cobra_chest.script by msc_transpiler.
// Gert_Caves final chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/cobra_chest"]
class CobraChest : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	float L_DAXE_CHANCE_MULT = 0.0f;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest

		int daxeChance = 5;
		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "BGOBLIN_CHIEF_SLAIN")))
			L_DAXE_CHANCE_MULT += 4.0f;
		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "VGOBLIN_CHIEF_SLAIN")))
			L_DAXE_CHANCE_MULT += 4.0f;

		OnTcAddArtifact("axes_dragon", daxeChance);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(500, 1000));
		OnAddEpicItem();
		if (RandomInt(1, 8) <= ActivePlayerCount())
			OnAddEpicItem();
		OnAddGreatItem();
		OnAddGreatItem();
		OnAddGreatItem();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
