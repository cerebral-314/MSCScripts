#pragma context server

// Converted from NPCs/feldagor.script by msc_transpiler.
// Feldagor for Gurluas's Demon Campaign (by Thothie, untested)
// - Thothie: Model needs more animations (prefer to have new model entirely)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

[script "NPCs/feldagor"]
class Feldagor : BaseNpcScript
{
	// Variables (an unset .script variable reads as its own name)
	int SAID_HI = 0;
	int HIRE_PRICE = 0;

	// unnamed block (first think)
	void Feldagor_FirstThink()
	{
		SAID_HI = 0;
	}

	// unnamed block (timer)
	void Feldagor_Timer()
	{
		CallEventDelayed(10.0f, "Feldagor_Timer");

		if (SAID_HI != 0)
			return;

		SetRace("human");
		if (!CanSee("ally"))
			return;

		SetVolume(2);
		SAID_HI = 1;
		PlayAnim("once", "eye_weep");
		SayText("Huh?...an adventurer?");
		CallEventDelayed(0.0f, "2");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		MenuItem menuItem;

		SetHealth(1);
		// ov		180
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetName("Feldagor the wise");
		SetRoam(false);
		SetModel("monsters/bludgeon_warrior.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 1);
		SetIdleAnim("stand");
		SetInvincible(true);

		HIRE_PRICE = RandomInt(1, 10);
		menuItem.id = "hire";
		SetLocal("reg.mitem.access", "all");
		menuItem.title = "Offer: ";
		LegacyCommand("stradd", "reg.mitem.title", HIRE_PRICE);
		LegacyCommand("stradd", "reg.mitem.title", " gold");
		menuItem.type = "payment";
		menuItem.data = "gold:";
		LegacyCommand("stradd", "reg.mitem.data", HIRE_PRICE);
		menuItem.callback = "recvoffer_gold";

		CatchSpeech("say_hi", "hail", "hi", "hello", "greetings", "yo", "waddup");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("Hello...i am Feldagor the wise...i have been living down here for over 120 years...yes i got a spell so the undead cant see me");
		CallEventDelayed(0.0f, "2");
	}

	// say_hi2
	void OnSayHi2()
	{
		PlayAnim("once", "pondering2");
		SayText("This was once our capital...before Lor Malgoriand...enslaved us...only a few escaped...give me gold and il tell you something.");
	}

	// recvoffer_gold
	void OnRecvofferGold()
	{
		ReceiveOffer("accept");
		PlayAnim("once", "yes");
		SayText("Thank you...anyway further down the hallway is a big room...it has a chest with valuable items...but it is guarded by the remains of our king.");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		menuItem.id = "payment";
		menuItem.title = "Offer " + HIRE_PRICE + " gold";
		menuItem.type = "payment";
		menuItem.data = "gold:" + HIRE_PRICE;
		menuItem.callback = "menu_recv_payment";
		menuItem.cb_failed = "menu_recv_payment_failed";
		RegisterMenuItem(menuItem);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bludgeon_warrior.mdl");
		CallEventDelayed(10.0f, "Feldagor_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Feldagor_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "recvoffer_gold") { OnRecvofferGold(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "Feldagor_Timer") { Feldagor_Timer(); return true; }
		return BaseNpcScript::DispatchEvent(name, params);
	}
}
