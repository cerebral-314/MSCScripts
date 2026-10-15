#pragma context server

// Converted from sorc_villa/sorc_sitting.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "sorc_villa/sorc_sitting"]
class SorcSitting : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	string ANIM_ACTION = "ANIM_ACTION";

	// unnamed block (timer)
	void SorcSitting_Timer()
	{
		CallEventDelayed(Random(10, 20), "SorcSitting_Timer");
		PlayAnim("once", ANIM_ACTION);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Shadahar Orc");
		SetModel("monsters/sorc.mdl");
		SetHealth(2000);
		SetDamageTaken("all", 0.7f);
		SetStat("parry", 110);
		SetInvincible(true);
		SetRace("beloved");
		SetNoPush(true);
		SetRoam(false);

		SetWidth(32);
		SetHeight(96);

		SetIdleAnim("on_chair");
		SetMoveAnim("on_chair");
		PlayAnim("critical", "on_chair");

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=bow+arrow 4=sword 5=great_axe 6=sword_sheild 7=yellow_axe 8=blooddrinker 9=meat 10=hammer 11=beer

		SetSayTextRange(1024);
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		NPC_DO_EVENTS = params;
		if (params == "none")
			return;
		int count = GetTokenCount(NPC_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkDoEvents();
		}
	}

	// npcatk_do_events
	// run param events
	void OnNpcatkDoEvents()
	{
		string nextEvent = "NEXT_EVENT";
		float nEvent = loopIteration;
		string eventName = GetToken(NPC_DO_EVENTS, int(nEvent));
		nEvent += 1.0f;
		if (nEvent <= GetTokenCount(NPC_DO_EVENTS))
			nextEvent = GetToken(NPC_DO_EVENTS, int(nEvent));
		DebugPrint("doing token event " + eventName);
		CallEventOrDelay(eventName, nextEvent);
	}

	// set_eating
	void OnSetEating()
	{
		ANIM_ACTION = "eat";
		SetModelBody(2, 9);
	}

	// set_drinking
	void OnSetDrinking()
	{
		ANIM_ACTION = "drink";
		SetModelBody(2, 11);
		SetModelBody(0, 2);
		SetModelBody(1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEventName() {} // EVENT_NAME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
		CallEventDelayed(Float(Eval("$randf(10.0,20.0)")), "SorcSitting_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "set_drinking") { OnSetDrinking(); return true; }
		if (name == "set_eating") { OnSetEating(); return true; }
		if (name == "SorcSitting_Timer") { SorcSitting_Timer(); return true; }
		return false;
	}
}
