#pragma context server

// Converted from thornlands_north/bandit_trap_disarmed.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit_hard_random.as"

[script "thornlands_north/bandit_trap_disarmed"]
class BanditTrapDisarmed : BanditHardRandomScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared

		CallEventDelayed(0.1f, "thorny");
		SetSayTextRange(500);
	}

	// thorny
	void OnThorny()
	{
		SetName("Thornlands Bandit");

		SayText("The traps been disarmed? How?!");
		PlaySound(0, 10, "voices/thornlands_north/shifty4.wav");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "thorny") { OnThorny(); return true; }
		return BanditHardRandomScript::DispatchEvent(name, params);
	}
}
