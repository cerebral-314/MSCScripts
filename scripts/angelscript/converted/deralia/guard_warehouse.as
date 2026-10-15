#pragma context server

// Converted from deralia/guard_warehouse.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/deralia/guard.as"

[script "deralia/guard_warehouse"]
class GuardWarehouse : DeraliaGuardScript
{
	// Variables declared by included files, with the value they start with in this script
	GuardWarehouse()
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

		SetName("Warehouse Guard");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		DeraliaGuard_OnSayHi(talkingPlayer); // deralia/guard

		int greeting = RandomInt(0, 2); // Added more flavor to the greetings. greatguys1@October2018

		if (greeting == 0)
			SayText("We were expecting a shipment from Ara- should have been in weeks ago...");
		else if (greeting == 1)
			SayText("The man with the strange hat keeps trying to talk to me. I try to ignore him.");
		else if (greeting == 2)
			SayText("Shipments from all around Daragoth come through here.");
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
