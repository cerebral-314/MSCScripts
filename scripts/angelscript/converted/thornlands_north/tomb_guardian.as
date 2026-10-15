#pragma context server

// Converted from thornlands_north/tomb_guardian.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/corpse_once.as"

[script "thornlands_north/tomb_guardian"]
class TombGuardian : CorpseOnceScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared

		CallEventDelayed(0.1f, "thorny");
		SetSayTextRange(1000);
	}

	// thorny
	void OnThorny()
	{
		SetName("Guardian of the Tomb");

		SayText("We protect our Master with our unlives, you shall not disturb his torpor.");
		PlaySound(0, 10, "voices/thornlands_north/wwprotector.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "thorny") { OnThorny(); return true; }
		return CorpseOnceScript::DispatchEvent(name, params);
	}
}
