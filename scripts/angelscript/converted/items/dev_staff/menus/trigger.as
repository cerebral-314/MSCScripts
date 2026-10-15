#pragma context server

// Converted from items/dev_staff/menus/trigger.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Trigger
{
	// Variables (an unset .script variable reads as its own name)
	bool LISTENING_FOR_TRIGGER = false;
	float STARTED_LISTENING = 0.0f;
	string TRIG_QUEST = "TRIG_QUEST";
	string RECENT_TRIGGERS = "RECENT_TRIGGERS";
	string MENU_TYPE = "MENU_TYPE";

	// unnamed block (first think)
	void Trigger_FirstThink()
	{
		LISTENING_FOR_TRIGGER = false;
	}

	// menu_trigger
	void Trigger_OnMenuTrigger()
	{
		MenuItem menuItem;

		LISTENING_FOR_TRIGGER = true;
		STARTED_LISTENING = GameTime();
		CallEventDelayed(10.0f, "stop_listening");

		CallExternal(MY_OWNER, "ext_saytextrange", 10000);

		menuItem.title = "Speak the [trigger]";
		menuItem.type = "disabled";

		TRIG_QUEST = "trig_" + ToLowerCase(MapName());
		RECENT_TRIGGERS = GetQuestData(MY_OWNER, TRIG_QUEST);

		if (RECENT_TRIGGERS == "0")
			RECENT_TRIGGERS = "";
		if (RECENT_TRIGGERS == "")
			return;

		int count = GetTokenCount(RECENT_TRIGGERS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnLoopTriggerHistory();
		}
	}

	// loop_trigger_history
	void Trigger_OnLoopTriggerHistory()
	{
		MenuItem menuItem;

		string trig = GetToken(RECENT_TRIGGERS, loopIteration);

		menuItem.title = trig;
		menuItem.type = "callback";
		menuItem.callback = "use_trigger";
		menuItem.data = trig;
	}

	// use_trigger
	void Trigger_OnUseTrigger(string owner = "", string trigger = "")
	{
		UseTrigger(trigger);
		LISTENING_FOR_TRIGGER = false;

		MENU_TYPE = "11";
		CallEventDelayed(0.1f, "ext_menu_open");

		CallExternal(MY_OWNER, "ext_playsound_kiss", 0, 5, "weapons/357_cock1.wav");
	}

	// game_heardtext
	void Trigger_OnGameHeardtext(string text = "", CBasePlayer@ speaker = null)
	{
		if (!LISTENING_FOR_TRIGGER)
			return;
		if (EntityId(speaker) != MY_OWNER)
			return;

		int idx = FindToken(RECENT_TRIGGERS, text);
		if (idx == -1) // Trig not saved, save it.
		{
			if (GetTokenCount(RECENT_TRIGGERS) >= 6) // If saved trigs is filling up too much
			{
				RECENT_TRIGGERS = TokenRemove(RECENT_TRIGGERS, 0); // Remove the oldest one
			}

			RECENT_TRIGGERS = TokenAdd(RECENT_TRIGGERS, text);

			Quest("set", MY_OWNER, TRIG_QUEST, RECENT_TRIGGERS);
		}

		OnUseTrigger(MY_OWNER, text);
	}

	// stop_listening
	void Trigger_OnStopListening()
	{
		if (!(STARTED_LISTENING <= GameTime() - 10.0f))
			return;
		LISTENING_FOR_TRIGGER = false;
	}

	// menu_trigger_successful
	void Trigger_OnMenuTriggerSuccessful()
	{
		MenuItem menuItem;
		menuItem.title = "Trigger Fired!";
		menuItem.type = "disabled";
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnMenuTrigger() { Trigger_OnMenuTrigger(); } // menu_trigger
	void OnLoopTriggerHistory() { Trigger_OnLoopTriggerHistory(); } // loop_trigger_history
	void OnUseTrigger(string owner = "", string trigger = "") { Trigger_OnUseTrigger(owner, trigger); } // use_trigger
	void OnGameHeardtext(string text = "", CBasePlayer@ speaker = null) { Trigger_OnGameHeardtext(text, speaker); } // game_heardtext
	void OnStopListening() { Trigger_OnStopListening(); } // stop_listening
	void OnMenuTriggerSuccessful() { Trigger_OnMenuTriggerSuccessful(); } // menu_trigger_successful

	// This file's events and timers by their .script names
	bool Trigger_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_heardtext") { OnGameHeardtext(Param(params, 0), PlayerParam(params, 1)); return true; }
		if (name == "loop_trigger_history") { OnLoopTriggerHistory(); return true; }
		if (name == "menu_trigger") { OnMenuTrigger(); return true; }
		if (name == "menu_trigger_successful") { OnMenuTriggerSuccessful(); return true; }
		if (name == "stop_listening") { OnStopListening(); return true; }
		if (name == "use_trigger") { OnUseTrigger(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/dev_staff/menus/trigger"]
shared class TriggerScript : ScriptEntity, Trigger
{
	// Variables every script that includes this file declares
	string AFF_1 = "AFF_1";
	string AFF_2 = "AFF_2";
	string AFF_3 = "AFF_3";
	string MY_ITEM = "MY_ITEM";
	string MY_OWNER = "MY_OWNER";
	int TELEPORT_MODE = 0;
	string WAYPOINT_QUEST = "WAYPOINT_QUEST";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Trigger_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return Trigger_DispatchEvent(name, params);
	}
}
