#pragma context server

// Converted from helena/erkold.script by msc_transpiler.
// Thothie - hopefully no longer sits there, waiting for you to kill him

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "helena/erkold"]
class HelenaErkold : BaseChatScript
{
	// Constants
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	bool FRIGHTENED = false;
	int QUEST_3 = 0;
	bool SEE_ENEMY = false;
	bool CAN_SCREAM = true;
	bool CAN_RUN = true;
	int ASKED = 1;
	string FLEE_DISTANCE = "FLEE_DISTANCE";

	// spawn
	void OnSpawn()
	{
		SetHealth(25);
		SetGold(0);
		SetName("Erkold");
		// ov		128
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 2);
		FRIGHTENED = false;
		QUEST_3 = 0;
		SEE_ENEMY = false;
		CAN_SCREAM = true;
		CAN_RUN = true;

		SetBlood("red");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");

		CatchSpeech("say_sniff", "dorfgan", "erkold", "serrold");

		CatchSpeech("say_job", "orc");

		CatchSpeech("say_kidnapped", "kidnapped", "help");

		CatchSpeech("say_yes", "yes", "sure", "yeah", "ok");

		CatchSpeech("say_no", "no", "never");
		SetAngle("face", Vector3(0, 90, 0));
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("..*sniff* ..hi there..");
		CallEventDelayed(1.0f, "say_sniff");
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		PlayAnim("once", "panic1");
		SayText("Don't.. talk about those.. ..they [kidnapped] my wife and children..");
	}

	// say_sniff
	void OnSaySniff()
	{
		if (QUEST_3 == 0)
		{
			PlayAnim("once", "eye_wipe");
			SayText("...");
		}
		if (QUEST_3 == 1)
			OnSayQuest2();
		if (QUEST_3 == 2)
			OnSayQuest3();
	}

	// say_kidnapped
	void OnSayKidnapped()
	{
		if (QUEST_3 == 0)
		{
			PlayAnim("once", "eye_wipe");
			SayText("The orcs.. they took my wife and children.. I don't know if they are alive..");
			CallEventDelayed(0.0f, "5");
		}
		if (QUEST_3 == 1)
			OnSayQuest2();
		if (QUEST_3 == 2)
			OnSayQuest3();
	}

	// say_quest1
	void OnSayQuest1()
	{
		SayText("Perhaps... *sniff ...you could find them for me?");
		InfoMessage(EntityOf(ENT_LASTSPOKE), "DEVELOPER MESSAGE: QUEST NOT FINISHED", "Sorry, this quest can't be completed, yet.");
		ASKED = 1;
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		if (ASKED != 1)
			return;
		if (QUEST_3 == 0)
		{
			SayText("You will?! Thank you! Thank you!");
			QUEST_3 = 1;
		}
		if (QUEST_3 == 1)
			OnSayQuest2();
		if (QUEST_3 == 2)
			OnSayQuest3();
	}

	// say_quest2
	void OnSayQuest2()
	{
		PlayAnim("once", "eye_wipe");
		SayText("Please don't return without them...");
	}

	// say_quest3
	void OnSayQuest3()
	{
		PlayAnim("once", "eye_wipe");
		SayText("If you do not want to [help] me, then please leave! *sniff*");
	}

	// game_recvoffer_gold
	void OnGameRecvofferGold()
	{
		ReceiveOffer("accept");
		SayText("..thank you, but nothing.. .. can replace.. *sniff*");
		PlayAnim("once", "eye_wipe");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// Thothie - RUN AWAY!
		FLEE_DISTANCE = "2048";
		OnRunAway(ENT_LASTSTRUCK, FLEE_DISTANCE);
	}

	// run_away
	// PARAM1: Threatning Entity  2: Dist to flee  3: Time to stop fleeing (optional)
	void OnRunAway(string threatEntity = "", string fleeDistance = "")
	{
		PlayAnim("break");
		SetMoveDest(threatEntity, fleeDistance, "flee");
		SetMoveAnim("run1");

		CallEventDelayed(15.0f, "stop_flee");
	}

	// stop_flee
	void OnStopFlee()
	{
		SetMoveAnim("walk_scared");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "run_away") { OnRunAway(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_kidnapped") { OnSayKidnapped(); return true; }
		if (name == "say_quest1") { OnSayQuest1(); return true; }
		if (name == "say_quest2") { OnSayQuest2(); return true; }
		if (name == "say_quest3") { OnSayQuest3(); return true; }
		if (name == "say_sniff") { OnSaySniff(); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "spawn") { OnSpawn(); return true; }
		if (name == "stop_flee") { OnStopFlee(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
