#pragma context server

// Converted from helena/old_harry.script by msc_transpiler.
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "helena/old_harry"]
class OldHarry : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	bool SAY_SO = false;
	bool FRIGHTENED = false;
	bool SEE_ENEMY = false;
	bool CAN_SCREAM = true;
	bool CAN_RUN = true;
	string STORENAME = "harrys_inn";

	// unnamed block (timer)
	// -------------------------------------------------------------
	// Flee from monsters
	// -------------------------------------------------------------
	void OldHarry_Timer()
	{
		CallEventDelayed(0.2f, "OldHarry_Timer");

		if ((SEE_ENEMY ? 1 : 0) != 0)
			return;

		OnFlee();
		OnShiver();
		OnScream();
	}

	// spawn
	void OnSpawn()
	{
		// eventname MUST be the first field!
		SetHealth(150);
		SetGold(1);
		SetName("Harry");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 1);
		SAY_SO = false;
		FRIGHTENED = false;
		SEE_ENEMY = false;
		CAN_SCREAM = true;
		CAN_RUN = true;
		STORENAME = "harrys_inn";
		OnCreatemystore();

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_quiet", "quiet");

		CatchSpeech("say_orcs", "orcs");
		CatchSpeech("say_dorfgan", "dorfgan");
		CatchSpeech("say_erkold", "erkold");
		CatchSpeech("say_serrold", "serrold");

		CatchSpeech("say_thanks", "ok");
		CatchSpeech("say_thanks", "okay");
		CatchSpeech("say_thanks", "sure");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlayAnim("once", "pondering3");
		SayText("Greetings to you adventurer!");
		CallEventDelayed(0.0f, "3");
	}

	// say_hi2test
	void OnSayHi2test()
	{
		SayText("I am Harry, your humble innkeeper. If you want to stay here you will have to be [quiet].");

		OnSetsayso();
	}

	// satsayso
	void OnSatsayso()
	{
		SAY_SO = true;
	}

	// say_quiet
	void OnSayQuiet()
	{
		PlayAnim("once", "pondering2");

		SayText("I'm not really allowed to give booze to the adventurers.. Serrold said it would deterioate their performance and then he gave order to barricade the door..");
		CallEventDelayed(0.0f, "4");
	}

	// say_quiet2
	void OnSayQuiet2()
	{
		PlayAnim("once", "pondering1");

		SayText("If would have stopped as he said, i would be ruined by now! So I made a small hole in the wall.. you probably saw it on your way in!");
	}

	// say_orcs
	void OnSayOrcs()
	{
		SayText("They disappear after 10 drinks!");
	}

	// say_dorfgan
	void OnSayDorfgan()
	{
		PlayAnim("once", "yes");
		SayText("Nice guy, he keeps order when my customers get a little fuzzy");
	}

	// say_erkold
	void OnSayErkold()
	{
		PlayAnim("once", "yes");
		SayText("Poor man.. Lost everything..Except his armor, which he sent to Dorfgan for repairs, if I recall him correctly.");
	}

	// say_serrold
	void OnSaySerrold()
	{
		PlayAnim("once", "no");
		SayText("Hmf. Our village elder . Never sat his foot in my beutiful Inn.");
	}

	// recvoffer_gold
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	void OnRecvofferGold()
	{
		OnRecvEnoughgold();
		OnRecvNotenoughgold();
	}

	// recv_enoughgold
	void OnRecvEnoughgold()
	{
		SayText("Last time Erkold was here, he said he was looking for someone to take care of his [armor].");
		PlayAnim("once", "yes");
	}

	// recv_notenoughgold
	void OnRecvNotenoughgold()
	{
		SayText("I am quite well off without your charity.");
		PlayAnim("once", "no");
	}

	// playerused
	// /////////////////////////////////////////////////////////////////////////////////7
	void OnPlayerused()
	{
		SetVolume(4);
		LegacyCommand("offerstore", STORENAME, "buysell", "trade");
	}

	// createmystore
	void OnCreatemystore()
	{
		LegacyCommand("createstore", STORENAME);

		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|	|Bundle amt|
		AddStoreItem(STORENAME, "health_apple", 15, 100);
		AddStoreItem(STORENAME, "health_mpotion", 4, 100, 0.2f);
		AddStoreItem(STORENAME, "proj_arrow_wooden", 300, 90, 0, 25);
		AddStoreItem(STORENAME, "drink_mead", 20, 20);
		AddStoreItem(STORENAME, "drink_ale", 20, 20);
		AddStoreItem(STORENAME, "drink_wine", 20, 20);
	}

	// flee
	void OnFlee()
	{
		if ((CAN_RUN ? 1 : 0) != 1)
			return;

		SetMoveAnim("run1");
		SetMoveDest("flee", ENT_LASTSEEN, 128);
		SEE_ENEMY = true;
		CAN_RUN = true;
		CallEventDelayed(0.0f, Text(RandomInt(0, 4)));
	}

	// shiver
	void OnShiver()
	{
		PlayAnim("once", "crouch_idle3");

		if ((CAN_SCREAM ? 1 : 0) != 1)
			return;
		PlaySound(1, 8, "player/fallpain4.wav");
		Say("*[100]");
		CallEventDelayed(0.0f, "2");
	}

	// stopmoving
	void OnStopmoving()
	{
		if ((SEE_ENEMY ? 1 : 0) != 1)
			return;

		SEE_ENEMY = false;
	}

	// scream
	void OnScream()
	{
		if ((CAN_SCREAM ? 1 : 0) != 1)
			return;

		PlayRandomSound(2, 8, "scientist/scream07.wav", "scientist/scream10.wav", "scientist/scream12.wav", "scientist/scream13.wav");
		CAN_SCREAM = false;
		Say("*[200]");
		CallEventDelayed(0.0f, Text(RandomInt(2, 6)));
	}

	// resetscream
	void OnResetscream()
	{
		CAN_SCREAM = true;
	}

	// resetflee
	void OnResetflee()
	{
		CAN_RUN = true;
	}

	// struck
	void OnStruck()
	{
		PlaySound(1, 8, "player/fallpain4.wav");
		OnFlee();
	}

	// parry
	void OnParry()
	{
		PlayAnim("once", "flinch");
		OnFlee();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnSetsayso() {} // setsayso

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(0.2f, "OldHarry_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "createmystore") { OnCreatemystore(); return true; }
		if (name == "flee") { OnFlee(); return true; }
		if (name == "parry") { OnParry(); return true; }
		if (name == "playerused") { OnPlayerused(); return true; }
		if (name == "recv_enoughgold") { OnRecvEnoughgold(); return true; }
		if (name == "recv_notenoughgold") { OnRecvNotenoughgold(); return true; }
		if (name == "recvoffer_gold") { OnRecvofferGold(); return true; }
		if (name == "resetflee") { OnResetflee(); return true; }
		if (name == "resetscream") { OnResetscream(); return true; }
		if (name == "satsayso") { OnSatsayso(); return true; }
		if (name == "say_dorfgan") { OnSayDorfgan(); return true; }
		if (name == "say_erkold") { OnSayErkold(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2test") { OnSayHi2test(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_quiet") { OnSayQuiet(); return true; }
		if (name == "say_quiet2") { OnSayQuiet2(); return true; }
		if (name == "say_serrold") { OnSaySerrold(); return true; }
		if (name == "scream") { OnScream(); return true; }
		if (name == "shiver") { OnShiver(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "stopmoving") { OnStopmoving(); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "OldHarry_Timer") { OldHarry_Timer(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
