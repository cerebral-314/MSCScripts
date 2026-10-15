#pragma context server

// Converted from sorc_villa/sorc_idle.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "sorc_villa/sorc_idle"]
class SorcIdle : ScriptEntity
{
	// Constants
	string ANIM_RECLINE_IDLE = "on_chair2";
	string ANIM_SIT_IDLE = "on_chair";
	string ANIM_DRINK = "drink";
	string ANIM_EAT = "eat";
	string ANIM_ACHE = "sit_ground";
	string ANIM_WAVE = "waving";

	// Variables (an unset .script variable reads as its own name)
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	string SORC_TYPE = "SORC_TYPE";

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

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		PlayAnim("once", "idle1");

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker

		CatchSpeech("say_hi", "hail", "j0", "hi", "waddup", "hello", "gweets", "greet");

		SetMenuAutoOpen(true);

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

	// set_recline1
	void OnSetRecline1()
	{
		SORC_TYPE = "recline1";
		SetModelBody(0, 0);
		SetModelBody(1, 4);
		SetModelBody(2, 0);
		SetIdleAnim("on_chair2");
		SetMoveAnim("on_chair2");
		PlayAnim("once", "on_chair2");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;
		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (SORC_TYPE == "recline1")
		{
			PlayAnim("critical", "on_chair2");
			SayText("Oh, it's Runegahr's 'guests'. Don't mind meez, I is just sunnings.");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEventName() {} // EVENT_NAME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "set_recline1") { OnSetRecline1(); return true; }
		return false;
	}
}
