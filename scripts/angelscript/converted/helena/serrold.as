#pragma context server

// Converted from helena/serrold.script by msc_transpiler.
// Thothie - for compatability - from old beta scripts
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "helena/serrold"]
class HelenaSerrold : BaseChatScript
{
	// Constants
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	bool INN_CLOSED = false;
	bool SEE_ENEMY = false;
	bool CAN_SCREAM = true;
	bool CAN_RUN = true;
	bool GAVE_MONEY = false;
	bool GAVE_GOLD = true;

	// unnamed block (timer)
	// -------------------------------------------------------------
	// Flee from monsters
	// -------------------------------------------------------------
	void HelenaSerrold_Timer()
	{
		CallEventDelayed(0.2f, "HelenaSerrold_Timer");

		if ((SEE_ENEMY ? 1 : 0) != 0)
			return;

		OnFlee();
		OnShiver();
		OnScream();
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		PlayAnim("once", "idle3");
		SayText("[Serrold], [Dorfgan] and [Erkold] are the only ones who can run this village! If we all die, the village will die with us!");
	}

	// spawn
	void OnSpawn()
	{
		// eventname MUST be the first field!
		SetHealth(125);
		SetGold(2);
		SetName("Serrold");
		// ov 360
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 0);
		INN_CLOSED = false;
		SEE_ENEMY = false;
		CAN_SCREAM = true;
		CAN_RUN = true;
		GAVE_MONEY = false;

		CatchSpeech("say_hi", "hi");
		CatchSpeech("say_hi", "hello");
		CatchSpeech("say_hi", "hail");
		CatchSpeech("say_hi", "greet");

		CatchSpeech("say_orcs", "orcs");
		CatchSpeech("say_rumor", "people");
		CatchSpeech("say_dorfgan", "dorfgan");
		CatchSpeech("say_erkold", "erkold");
		CatchSpeech("say_serrold", "serrold");
		CatchSpeech("say_harry", "harry");

		CatchSpeech("say_innopen", "open");
		CatchSpeech("say_innopen", "hole");

		CatchSpeech("say_thanks", "ok");
		CatchSpeech("say_thanks", "okay");
		CatchSpeech("say_thanks", "sure");
	}

	// greet_players
	void OnGreetPlayers()
	{
		SetVolume(10);
		Say("oldvillager1[50]", "*[180]", "*[80]", "*[80]", "*[150]", "*[50]", "*[50]", "*[50]", "*[50]");
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlayAnim("once", "panic");
		SayText("Please help our town! The [orcs] are attacking!");
		CallEventDelayed(0.0f, "2");
	}

	// say_hi2
	void OnSayHi2()
	{
		SayText("Even if we survive the attack, we still need [people] to keep order in the town!");
	}

	// say_orcs
	void OnSayOrcs()
	{
		PlayAnim("once", "fear1");
		SayText("Evil creatures spawned from hell!");
	}

	// say_dorfgan
	void OnSayDorfgan()
	{
		PlayAnim("once", "yes");
		SayText("The blacksmith. He is a good man, not even in times like this does he stop forgeing!");
	}

	// say_erkold
	void OnSayErkold()
	{
		PlayAnim("once", "yes");
		SayText("The man at the burnt down house. He and his family used to supply the village with food, but I am not sure how it will go now when the family has been kidnapped..");
	}

	// say_serrold
	void OnSaySerrold()
	{
		PlayAnim("once", "yes");
		SayText("I am Serrold, the town elder.");
	}

	// say_harry
	void OnSayHarry()
	{
		PlayAnim("once", "no");
		SayText("That man is good for nothing. I closed down his Inn but I still get the feeling that something is going on in there..");
	}

	// say_innopen
	void OnSayInnopen()
	{
		if ((GAVE_GOLD ? 1 : 0) != 0)
			return;
		PlayAnim("once", "no");
		SayText("What! He opened it up again! Well.. I guess I can't stop him. Here's some gold for telling me.");
		GAVE_GOLD = true;
		Offer(ENT_LASTSPOKE, "gold", RandomInt(1, 3));
	}

	// say_thanks
	void OnSayThanks()
	{
		PlayAnim("once", "yes");
		SayText("Thank you! Now go out and kick some green butt!");
	}

	// robbed
	// ///////////////////////////////////////////////////////////////////////////////////////////////
	void OnRobbed()
	{
		PlayAnim("once", "beatdoor");
	}

	// recvoffer_gold
	void OnRecvofferGold()
	{
		OnRecvEnoughgold();
		OnRecvNotenoughgold();
	}

	// recv_enoughgold
	void OnRecvEnoughgold()
	{
		SayText("I know Harry knows something...");
		PlayAnim("once", "yes");
	}

	// recv_notenoughgold
	void OnRecvNotenoughgold()
	{
		SayText("I am quite well off without your charity.");
		PlayAnim("once", "no");
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
		SetRoam(true);
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

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		Precache("npc/oldvillager1.wav");
		CallEventDelayed(0.2f, "HelenaSerrold_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "flee") { OnFlee(); return true; }
		if (name == "greet_players") { OnGreetPlayers(); return true; }
		if (name == "parry") { OnParry(); return true; }
		if (name == "recv_enoughgold") { OnRecvEnoughgold(); return true; }
		if (name == "recv_notenoughgold") { OnRecvNotenoughgold(); return true; }
		if (name == "recvoffer_gold") { OnRecvofferGold(); return true; }
		if (name == "resetflee") { OnResetflee(); return true; }
		if (name == "resetscream") { OnResetscream(); return true; }
		if (name == "robbed") { OnRobbed(); return true; }
		if (name == "say_dorfgan") { OnSayDorfgan(); return true; }
		if (name == "say_erkold") { OnSayErkold(); return true; }
		if (name == "say_harry") { OnSayHarry(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_innopen") { OnSayInnopen(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_serrold") { OnSaySerrold(); return true; }
		if (name == "say_thanks") { OnSayThanks(); return true; }
		if (name == "scream") { OnScream(); return true; }
		if (name == "shiver") { OnShiver(); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "stopmoving") { OnStopmoving(); return true; }
		if (name == "struck") { OnStruck(); return true; }
		if (name == "HelenaSerrold_Timer") { HelenaSerrold_Timer(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
