#pragma context server

// Converted from NPCs/beggar.script by msc_transpiler.
// *** Default human script ***

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/beggar"]
class Beggar : BaseNpcScript
{
	// unnamed block (timer)
	void Beggar_Timer()
	{
		CallEventDelayed(30.0f, "Beggar_Timer");

		SetVolume(2);
		Say("chitchat[50]", "*[20]", "*[55]", "*[55]", "*[23]", "*[22]");
		SayText("Alms for the poor...");
		CallEventDelayed(0.0f, "2");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(1);
		// ov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Beggar");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetModelBody(0, RandomInt(0, 2));
		SetModelBody(1, RandomInt(0, 5));
		SetIdleAnim("cowering_in_corner");
		SetInvincible(true);
	}

	// say_alms
	void OnSayAlms()
	{
		SayText("Please... save a beggar a few coins...");
	}

	// recvoffer_gold
	void OnRecvofferGold()
	{
		ReceiveOffer("accept");
		SayText("Thank you...");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/chitchat.wav");
		CallEventDelayed(30.0f, "Beggar_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "recvoffer_gold") { OnRecvofferGold(); return true; }
		if (name == "say_alms") { OnSayAlms(); return true; }
		if (name == "Beggar_Timer") { Beggar_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
