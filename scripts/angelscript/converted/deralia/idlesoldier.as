#pragma context server

// Converted from deralia/idlesoldier.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
// #include monsters/base - not found
#include "converted/monsters/base_chat.as"

[script "deralia/idlesoldier"]
class Idlesoldier : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(300);
		SetWidth(32);
		SetHeight(72);
		SetRace("human_guard");
		SetName("Soldier");
		SetModel("npc/guard1.mdl");
		SetRoam(false);
		SetInvincible(true);
		SetIdleAnim("idle7");
	}

	// say_hi
	// Talk
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Sorry adeventurer, we're too busy to talk.");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
