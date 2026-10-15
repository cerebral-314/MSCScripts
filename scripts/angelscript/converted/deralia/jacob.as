#pragma context server

// Converted from deralia/jacob.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/deralia/guard.as"

[script "deralia/jacob"]
class Jacob : DeraliaGuardScript
{
	// Variables declared by included files, with the value they start with in this script
	Jacob()
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

		SetName("Bouncer Jacob");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
		CatchSpeech("say_hayy", "hayy");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		DeraliaGuard_OnSayHi(talkingPlayer); // deralia/guard
		string gender;

		if (talkingPlayer !is null)
			gender = GenderOf(talkingPlayer);
		else
			gender = GenderOf(ENT_LASTSPOKE);

		if (gender == "male")
		{
			SayText("I don't recognize you. You'll have to talk to my boss before I let you in.");
		}
		else
		{
			PlayAnim("once", "lean");

			SayText("If you're looking for work, I may have something for you. You've certainly got the looks, but it also requires some skills.");
		}
	}

	// say_hayy
	void OnSayHayy()
	{
		// I was talking with Dehoth about what the building Jacob guarding was. He said it was a "priviliged building for men ;)" which I misinterpreted as
		// some sort've gay club. I dunno what's worse; misinterpreting it that bad or not questioning it. I'm keeping this easter egg in regardless.
		if (GenderOf(ENT_LASTSPOKE) == "male")
			SayText("Hayy ;)");
		else
			SayText("I don't need this. Away with you.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hayy") { OnSayHayy(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return DeraliaGuardScript::DispatchEvent(name, params);
	}
}
