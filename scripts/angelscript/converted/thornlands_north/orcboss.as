#pragma context server

// Converted from thornlands_north/orcboss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/orcflayer.as"

[script "thornlands_north/orcboss"]
class Orcboss : MonstersOrcflayerScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared

		CallEventDelayed(0.1f, "thorny");
		SetSayTextRange(1000);
	}

	// thorny
	void OnThorny()
	{
		SetName("|Vakgar the Guardian");

		SayText("What's going on here? Humans!? Destroy them!");
		PlaySound(0, 10, "voices/thornlands_north/orcforboss.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "thorny") { OnThorny(); return true; }
		return MonstersOrcflayerScript::DispatchEvent(name, params);
	}
}
