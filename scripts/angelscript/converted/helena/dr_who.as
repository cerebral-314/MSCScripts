#pragma context server

// Converted from helena/dr_who.script by msc_transpiler.
// Keeper of Time by Thothie for Helena2

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "helena/dr_who"]
class DrWho : BaseChatScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	string SPELL_PATIENTS = "SPELL_PATIENTS";
	bool HEARD_APPLE = false;
	int DID_INTRO = 0;
	bool DID_CONFUSED = false;
	bool RESPONDED_NO = false;
	float RANT_STEP = 0.0f;
	bool PORTAL_OPEN = false;

	// Variables declared by included files, with the value they start with in this script
	DrWho()
	{
		CHAT_DELAY = 4.0f;
	}

	// unnamed block (first think)
	void DrWho_FirstThink()
	{
		SetName("Torwhodoc Sa'thraz, Keeper of Time");
		SetHealth(1);
		SetInvincible(true);
		SetNoPush(true);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/balancepriest2.mdl"); // need new wizard
		SetWidth(32);
		SetHeight(72);
		SetBoundingBox("npcsize");

		SetSayTextRange(512);

		SetIdleAnim("idle1");

		CatchSpeech("say_hi", "hail", "hi", "howdy", "hello", "greet", "gweet", "j0", "waddup", "wassup");
		CatchSpeech("hear_no", "no", "uh", "what");
		CatchSpeech("hear_apple", "apple");

		SPELL_PATIENTS = "";

		CallEventDelayed(1.0f, "scan_for_ally");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (PORTAL_OPEN)
			return;

		menuItem.title = "Give 1000 gold";
		menuItem.type = "payment";
		menuItem.data = "gold:1000";
		menuItem.callback = "open_portal";
		menuItem.cb_failed = "payment_failed";
		RegisterMenuItem(menuItem);

		if (!HEARD_APPLE)
			return;
		if (!Truthy(ItemExists(player, "health_apple")))
			return;
		menuItem.title = "Give Apple";
		menuItem.type = "payment";
		menuItem.data = "health_apple";
		menuItem.callback = "open_portal";
		RegisterMenuItem(menuItem);
	}

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat

		if (CHAT_STEP == 2.0f)
			OnConvoAnim();
		if (CHAT_STEP == 4.0f)
			OnConvoAnim();
		if (CHAT_STEP == 6.0f)
			OnConvoAnim();
		if (CHAT_STEP == 8.0f)
			OnConvoAnim();
		if (CHAT_STEP == 10.0f)
			OnConvoAnim();
	}

	// hear_apple
	void OnHearApple()
	{
		if (PORTAL_OPEN)
			return;
		PlayAnim("critical", "eye_wipe");
		SayText("An... An apple you say?");
		HEARD_APPLE = true;
	}

	// scan_for_ally
	void OnScanForAlly()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(2.0f, "scan_for_ally");
		if (!CanSee("ally"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) < 512.0f))
			return;
		DID_INTRO = 1;
		OnSayHi();
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		bool exitSub = false;

		if (!IsAlive(talkingPlayer) && IsAlive(ENT_LASTSPOKE) && RangeTo(ENT_LASTSPOKE) > 256.0f)
			exitSub = true;
		if (exitSub)
			return;

		if (BUSY_CHATTING)
			return;
		if (!DID_CONFUSED)
		{
			PlayAnim("critical", "eye_wipe");
			CHAT_STEPS = 3;
			CHAT_STEP = 0.0f;
			BUSY_CHATTING = true;
			CHAT_STEP1 = "At last, we meet! ...or is this the second time...?";
			CHAT_STEP2 = "I'm always getting confused about these things you see...";
			CHAT_STEP3 = "You'd be confused too, if you were as unstuck in time as I...";
			OnChatLoop();
			DID_CONFUSED = true;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (DID_CONFUSED)
		{
			CHAT_STEPS = 8;
			CHAT_STEP = 0.0f;
			BUSY_CHATTING = true;
			CHAT_STEP1 = "Huh? Oh, yes, sorry... I am Torwhodoc Sa'thraz - last of the time wizards!";
			CHAT_STEP2 = "...and you... You are the one who was... or is... or will be... or...";
			CHAT_STEP3 = "No matter, you'll have to do, assuming, you have the gold I asked for...";
			CHAT_STEP4 = "Surely you remember, after you saved Helena? I asked for... Oh nevermind.";
			CHAT_STEP5 = "It doesn't matter if you remember or not, I need 1000 gold to eat *cough* I mean, open the portal.";
			CHAT_STEP6 = "Granted, if you don't go through the portal and save the town, there'll be no place to eat at...";
			CHAT_STEP7 = "...but if I don't get the gold, I'll have nothing to eat with so....";
			CHAT_STEP8 = "Don't worry, I gave you something to make it worth the money. Remember?";
			OnChatLoop();
		}
	}

	// hear_no
	void OnHearNo()
	{
		if (RESPONDED_NO)
			return;
		SayText("Oh, you will.... You will... Or... Maybe you already have?");
		RESPONDED_NO = true;
	}

	// open_portal
	// PARAM1 = customer
	void OnOpenPortal(CBasePlayer@ customer = null)
	{
		string nameStr = NameOf(customer) + "!";
		SayText("Quickly " + nameStr + " This time portal, it will not last long!");
		RANT_STEP = 0.0f;
		CallEventDelayed(20.0f, "timer_rant_loop");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetSolid("none");
		PORTAL_OPEN = true;
		UseTrigger("time_tele");
	}

	// payment_failed
	void OnPaymentFailed()
	{
		PlayAnim("critical", "no");
		int rndResp = RandomInt(1, 2);
		if (rndResp == 1)
			SayText("Come now, the last of the time wizards deserves better food than that will buy.");
		if (rndResp == 2)
			SayText("Now what sort of apples am I going to buy with that sort of cash? Bryan's of Edana, mayhaps?");
	}

	// timer_rant_loop
	void OnTimerRantLoop()
	{
		SetSayTextRange(200);
		float rndDelay = Random(40, 80);
		CallEventDelayed(rndDelay, "timer_rant_loop");
		RANT_STEP += 1.0f;
		if (RANT_STEP > 9.0f)
			RANT_STEP = 1.0f;
		OnConvoAnim();
		if (RANT_STEP == 1.0f)
			SayText("Actually, now that I think of it.... Take your time.");
		if (RANT_STEP == 2.0f)
			SayText("I mean, cannot run out of time. After all, time is infinite...");
		if (RANT_STEP == 3.0f)
			SayText("You are finite, Torwhodoc is finite... This... This is wrong tool.");
		if (RANT_STEP == 4.0f)
			SayText("Do you know I had five brothers?");
		if (RANT_STEP == 5.0f)
			SayText("You would say we all have the same name, but all pronounced slightly differently...");
		if (RANT_STEP == 6.0f)
			SayText("TorwhoDOC... TORwhodoc... TorWHOdoc... TORwhoDOC... TorWHODOC.... TORWHOdoc...");
		if (RANT_STEP == 7.0f)
			SayText("So, you see, how I am become so very easily confused...");
		if (RANT_STEP == 8.0f)
			SayText("Torwhodoc have very sad life, probably have very sad death, but at least, there is symmetry.");
		if (RANT_STEP == 9.0f)
			SayText("Wow, you're still here!? Comeon' I gotta eat sometime!");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnRndDelay() {} // RND_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseChat_FirstThink();
		DrWho_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "hear_apple") { OnHearApple(); return true; }
		if (name == "hear_no") { OnHearNo(); return true; }
		if (name == "open_portal") { OnOpenPortal(PlayerParam(params, 0)); return true; }
		if (name == "payment_failed") { OnPaymentFailed(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "scan_for_ally") { OnScanForAlly(); return true; }
		if (name == "timer_rant_loop") { OnTimerRantLoop(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
