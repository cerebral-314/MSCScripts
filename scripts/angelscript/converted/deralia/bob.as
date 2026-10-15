#pragma context server

// Converted from deralia/bob.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/deralia/guard.as"

[script "deralia/bob"]
class Bob : DeraliaGuardScript
{
	// Variables declared by included files, with the value they start with in this script
	Bob()
	{
		DERALIA_CHATTER = false;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuard_OnNpcSpawn(npc); // NPCs/human_guard
		DeraliaGuard_OnNpcSpawn(npc); // deralia/guard

		SetName("Bob, the Bouncer");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		DeraliaGuard_OnSayHi(talkingPlayer); // deralia/guard

		int greeting = RandomInt(0, 2); // Added more flavor to the greetings. greatguys1@October2018

		if (greeting == 0)
			SayText("Gerald wants me to take care of his rat problem. That's not what I get paid for.");
		else if (greeting == 1)
			SayText("Don't make any trouble.");
		else if (greeting == 2)
			SayText("I drink elsewhere because of the rats here.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return DeraliaGuardScript::DispatchEvent(name, params);
	}
}
