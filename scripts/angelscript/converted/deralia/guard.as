#pragma context server

// Converted from deralia/guard.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/human_guard.as"
#include "converted/monsters/base_chat.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DeraliaGuard
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;
	bool DERALIA_CHATTER = true;

	// npc_spawn
	void DeraliaGuard_OnNpcSpawn(string npc = "")
	{
		SetGold(10);
		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
	}

	// say_hi
	// Talk
	void DeraliaGuard_OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (DERALIA_CHATTER)
		{
			int greeting = RandomInt(0, 3); // Added more flavor to the greetings. greatguys1@October2018

			if (greeting == 0)
				SayText("Thordac's shop produces most of the weapons here.");
			else if (greeting == 1)
				SayText("I should've joined the army.");
			else if (greeting == 2)
				SayText("Brawls of opposing worshippers often break out near the temples.");
			else if (greeting == 3)
				SayText("If you're looking for work, I heard Gerald needed help with something.");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuard_OnNpcSpawn(npc); // NPCs/human_guard
		DeraliaGuard_OnNpcSpawn(npc);
	}

	void OnSayHi(CBasePlayer@ talkingPlayer = null) { DeraliaGuard_OnSayHi(talkingPlayer); } // say_hi

	// This file's events and timers by their .script names
	bool DeraliaGuard_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "deralia/guard"]
shared class DeraliaGuardScript : HumanGuardScript, DeraliaGuard, BaseChat
{
	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuard_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DeraliaGuard_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| HumanGuardScript::DispatchEvent(name, params);
	}
}
