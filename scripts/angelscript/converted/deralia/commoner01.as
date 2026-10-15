#pragma context server

// Converted from deralia/commoner01.script by msc_transpiler.
// *** Sitting human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "deralia/commoner01"]
class Commoner01 : BaseNpcScript
{
	// Constants
	bool NO_CHAT = true;

	// unnamed block (timer)
	void Commoner01_Timer()
	{
		CallEventDelayed(30.0f, "Commoner01_Timer");

		SetMoveDest(ENT_LASTSEEN, 128);
		SetVolume(2);
		Say("chitchat[50]", "*[20]", "*[55]", "*[55]", "*[23]", "*[22]");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Commoner");
		SetRoam(true);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetMoveAnim("coffee");
		SetInvincible(true);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/chitchat.wav");
		CallEventDelayed(30.0f, "Commoner01_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "Commoner01_Timer") { Commoner01_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
