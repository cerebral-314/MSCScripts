#pragma context server

// Converted from thornlands_north/bgoblin_apple.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/m2_quest/bgoblin_weak.as"

[script "thornlands_north/bgoblin_apple"]
class BgoblinApple : BgoblinWeakScript
{
	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared

		CallEventDelayed(2.0f, "start_apple_chatter");
		SetSayTextRange(900);
	}

	// start_apple_chatter
	void OnStartAppleChatter()
	{
		if (int(APPLE_CHATTER) == 0)
		{
			SetName("Blood Goblin");
			SayText("You took an apple?? Apple is worthless!");
			PlaySound(0, 10, "voices/thornlands_north/gobapple1.wav");
			CallEventDelayed(4.0f, "start_apple_chatter");
		}
		else if (APPLE_CHATTER == 1.0f)
		{
			SetName("Goblin Needler");
			SayText("A human had this apple, it must be valuable.");
			PlaySound(0, 10, "voices/thornlands_north/gobapple2.wav");
			CallEventDelayed(4.0f, "start_apple_chatter");
		}
		else if (APPLE_CHATTER == 2.0f)
		{
			SetName("Blood Goblin");
			SayText("A human picked this apple from a TREE!");
			PlaySound(0, 10, "voices/thornlands_north/gobapple3.wav");
			CallEventDelayed(3.0f, "start_apple_chatter");
		}
		else if (APPLE_CHATTER == 3.0f)
		{
			SetName("Goblin Needler");
			SayText("Show me trees with apples. I've seen none!");
			PlaySound(0, 10, "voices/thornlands_north/gobapple4.wav");
			CallEventDelayed(4.0f, "start_apple_chatter");
		}
		else if (APPLE_CHATTER == 4.0f)
		{
			SetName("Blood Goblin");
			UseTrigger("gobwall2stop");
		}

		APPLE_CHATTER += 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "start_apple_chatter") { OnStartAppleChatter(); return true; }
		return BgoblinWeakScript::DispatchEvent(name, params);
	}
}
