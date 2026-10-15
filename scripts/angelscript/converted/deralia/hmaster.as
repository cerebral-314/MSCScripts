#pragma context server

// Converted from deralia/hmaster.script by msc_transpiler.
// Harbor Master

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "deralia/hmaster"]
class Hmaster : BaseChatScript
{
	// Variables (an unset .script variable reads as its own name)
	string SOUND_IDLE1 = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		menuItem.title = "Join Crew";
		menuItem.type = "callback";
		menuItem.callback = "vote_ara";
		RegisterMenuItem(menuItem);
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour(); // spellinks
	}

	// spawn
	void OnSpawn()
	{
		SetHealth(1);
		SetName("Captain Charon");
		// fov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		SetModelBody(0, 1);
		SetModelBody(1, 2);

		SOUND_IDLE1 = "voices/human/male_idle4.wav";
		SOUND_IDLE2 = "voices/human/male_idle5.wav";
		SOUND_IDLE3 = "voices/human/male_idle6.wav";

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "ello", "j0");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_ship", "boat", "ship");
		CatchSpeech("say_ara", "ara");
		CatchSpeech("say_rumour", "rumours", "news", "happenings", "rumour", "rumor");
	}

	// idle
	// Idling
	void OnIdle()
	{
		CallEventDelayed(Random(30, 40), "idle");
		PlayRandomSound(2, 3, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Ahoy! What you doin' around the harbor mate?");
	}

	// gossip_1
	void OnGossip1()
	{
		SayText("The winds be tellin' me about some trouble around here.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering");
		SayText("Rumour has it, the wind will be changing to the other side. Aye.");
	}

	// say_job
	// Job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("I've got a shipment to get to Ara, could always use some good hands.");
		CallEventDelayed(2.0f, "say_job2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("Business has been mighty slow, so the best I can offer for a wage is free passage.");
	}

	// say_ship
	// Ship
	void OnSayShip()
	{
		SayText("That ship can take you out into the sea if you want. Joins up with Ron's Galleon about 20 leagues out.");
		CallEventDelayed(0.0f, "4");
	}

	// say_ship2
	void OnSayShip2()
	{
		SayText("But beware, it be a crazy place out thar!");
		CallEventDelayed(0.0f, "2");
	}

	// say_ship3
	void OnSayShip3()
	{
		SayText("This time of year be icy, so the only place I can trade goods is Port Ara.");
		CallEventDelayed(0.0f, "2");
	}

	// say_ship4
	void OnSayShip4()
	{
		SayText("Ye are welcome to come along, if ye like.");
	}

	// vote_ara
	void OnVoteAra()
	{
		SayText("It'll be a fine thing indeed to have ye aboard.");
		CallExternal(GetVar("GAME_MASTER"), "gm_create_vote", "gm_votemap", "Yes!:oceancrossing;No!:0", "Do you wish to travel the ocean blue?");
		CallExternal("players", "ext_set_map", "oceancrossing", "from_deralia", "from_deralia");
	}

	// say_ara
	void OnSayAra()
	{
		SayText("It's a prosperous little trade town up the coast, last one before Verath.");
		CallEventDelayed(2.0f, "say_ara2");
	}

	// say_ara2
	void OnSayAra2()
	{
		SayText("Too dangerous to go any farther than that with the ice flows this time of year.");
		CallEventDelayed(2.0f, "say_ara3");
	}

	// say_ara3
	void OnSayAra3()
	{
		SayText("I could use a hand with the boat. Would ye be volunteering?");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(Float(Eval("$randf(30,40)")), "idle");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "gossip_1") { OnGossip1(); return true; }
		if (name == "idle") { OnIdle(); return true; }
		if (name == "say_ara") { OnSayAra(); return true; }
		if (name == "say_ara2") { OnSayAra2(); return true; }
		if (name == "say_ara3") { OnSayAra3(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_ship") { OnSayShip(); return true; }
		if (name == "say_ship2") { OnSayShip2(); return true; }
		if (name == "say_ship3") { OnSayShip3(); return true; }
		if (name == "say_ship4") { OnSayShip4(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "vote_ara") { OnVoteAra(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
