#pragma context server

// Converted from cleicert/fpriest.script by msc_transpiler.
// MiB for Cleicert Temple

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"

[script "cleicert/fpriest"]
class Fpriest : BaseNpcScript, BaseChat
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	float CHAT_DELAY = 5.75f;

	// Variables (an unset .script variable reads as its own name)
	int ALREADYTALKING = 0;
	float MY_YAW = 0.0f;
	bool IS_ACTIVE = false;
	string PLAYER_DETECT = "PLAYER_DETECT";
	float FADE_LOOP = 0.0f;
	bool FADING_IN = false;
	bool BREAK_FADE = false;
	bool BUSY_CHATTING = false;
	float CHAT_STEP = 0.0f;
	string CHAT_TYPE = "CHAT_TYPE";
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_STEP7 = "CHAT_STEP7";
	string CHAT_STEP8 = "CHAT_STEP8";
	string CHAT_STEP9 = "CHAT_STEP9";
	string CHAT_STEP10 = "CHAT_STEP10";
	int CHAT_STEPS = 0;
	bool FADING_OUT = false;
	bool USED_TRIGGER = false;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";

	// chat_loop
	void OnChatLoop()
	{
		BaseChat_OnChatLoop(); // monsters/base_chat
		if (CHAT_TYPE == "intro")
		{
			if (CHAT_STEP != 9.0f)
				OnFaceSpeaker(PLAYER_DETECT);
			if (CHAT_STEP == 1.0f)
				PlayAnim("critical", "comehere");
			if (CHAT_STEP == 3.0f)
				PlayAnim("critical", "converse1");
			if (CHAT_STEP == 5.0f)
				PlayAnim("critical", "converse2");
			if (CHAT_STEP == 7.0f)
				PlayAnim("critical", "talkright");
			if (CHAT_STEP == 8.0f)
				PlayAnim("critical", "pondering2");
			if (CHAT_STEP == 9.0f)
			{
				SetAngle("face", Vector3(0, MY_YAW, 0));
				PlayAnim("critical", "dryhands");
				CallEventDelayed(0.25f, "use_trig");
			}

			if (CHAT_STEP == 10.0f)
			{
				PlayAnim("critical", "wave");
				SetMoveAnim("none");
				SetIdleAnim("none");
				FADING_OUT = true;
				BREAK_FADE = false;
				CallEventDelayed(2.0f, "fade_out");
			}
			if (FADING_OUT && BREAK_FADE && !FADING_IN)
				OnFadeInLoop();
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(40);
		SetGold(0);
		SetName("Ghostly Priest");
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/balancepriest1.mdl");
		SetInvincible(true);
		SetModelBody(1, 3);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		ALREADYTALKING = 0;

		SetSayTextRange(2048);

		CatchSpeech("say_hi", "hi", "hail", "heil", "yo", "hello", "sup");
		CatchSpeech("say_stfu", "stfu", "STFU", "fuck");

		CallEventDelayed(0.1f, "scan_for_players");
		CallEventDelayed(0.1f, "get_angles");
	}

	// get_angles
	void OnGetAngles()
	{
		MY_YAW = Float(Eval("game.monster.angles.yaw"));
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (IS_ACTIVE)
			return;
		CallEventDelayed(0.25f, "scan_for_players");
		SetVar("PLAYER_LIST", GetActivePlayers());
		int count = GetTokenCount("PLAYER_LIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnCheckNear();
			if (breakLoop)
			{
				breakLoop = false;
				break;
			}
		}
	}

	// check_near
	void OnCheckNear()
	{
		string curPlayer = GetToken("PLAYER_LIST", loopIteration);
		if (!(RangeTo(curPlayer) < 512.0f))
			return;
		IS_ACTIVE = true;
		PLAYER_DETECT = curPlayer;
		OnDoIntro();
	}

	// do_intro
	void OnDoIntro()
	{
		OnLightUp();
		OnFaceSpeaker(PLAYER_DETECT);
		PlayAnim("critical", "comehere");
		PlaySound(0, 10, "magic/spawn.wav");
		FADE_LOOP = 0.0f;
		OnFadeInLoop();
		SayText("Pssst... Over here.");
		CallEventDelayed(5.0f, "say_hi");
	}

	// fade_in_loop
	void OnFadeInLoop()
	{
		FADE_LOOP += 1.0f;
		FADING_IN = true;
		if (FADE_LOOP == 255.0f)
			FADING_IN = false;
		if (!(FADE_LOOP < 255.0f))
			return;
		CallEventDelayed(0.1f, "fade_in_loop");
		SetProp(ENT_ME, "renderamt", FADE_LOOP);
	}

	// fade_out
	void OnFadeOut()
	{
		FADE_LOOP -= 1.0f;
		if (FADE_LOOP == 0.0f)
			DeleteEntity(ENT_ME);
		if (FADE_LOOP == 1.0f)
			OnRemoveLight();
		if (!(FADE_LOOP > 0.0f))
			return;
		if (!BREAK_FADE)
			CallEventDelayed(0.1f, "fade_out");
		SetProp(ENT_ME, "renderamt", FADE_LOOP);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (BUSY_CHATTING)
			return;

		BREAK_FADE = true;

		BUSY_CHATTING = true;

		CHAT_STEP = 0.0f;
		CHAT_TYPE = "intro";
		CHAT_STEP1 = "Thank the gods! You've come just in time... I've not much time to explain...";
		CHAT_STEP2 = "Long ago we imprisoned a great evil in this temple: a dreaded lightning Djinn of the Shadahar Orc Tribe.";
		CHAT_STEP3 = "We were able to weaken him, and seal him here inside the temple, but we lacked the power to slay him.";
		CHAT_STEP4 = "...As such, we felt the only option, to prevent his escape, was to fortify the temple's defenses and seal it, from the inside.";
		CHAT_STEP5 = "As you can see by my current, ghostly state, that was quite some time ago, and alas, we have all long since perished.";
		CHAT_STEP6 = "My spirit was bound here in hopes that I could somehow influence someone of power to the temple, to finish our task, and destroy the Djinn.";
		CHAT_STEP7 = "However, it maybe too late, it seems the Shadahar Orcs have also found our temple, and are breaking in as we speak!";
		CHAT_STEP8 = "If they find the Djinn first, they will be able to rejuvenate and release him at full power! You must find the Djinn before they do, and destroy it!";
		CHAT_STEP9 = "There are four crystals that lock the beast in its cage within the temple - find them, use them to release him.";
		CHAT_STEP10 = "You MAY be able to defeat him while he is still in his weakened state! My time here has nearly ended, so hurry! You are now our only hope!";
		CHAT_STEPS = 10;
		OnChatLoop();
	}

	// use_trig
	void OnUseTrig()
	{
		if (USED_TRIGGER)
			return;
		USED_TRIGGER = true;
		UseTrigger("GiveCrystalOne");
	}

	// light_up
	// call at spawn or cycle_up
	void OnLightUp()
	{
		Vector3 lightColor = Vector3(200, 200, 255);
		int lightRad = 128;
		ClientEvent("persist", "all", "monsters/lighted_cl", IndexOf(ENT_ME), lightColor, lightRad);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// remove_light
	void OnRemoveLight()
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		ClientEvent("update", "all", MY_LIGHT_SCRIPT, "remove_me");
	}

	// say_hi_old
	// =============== OLD INTRO
	void OnSayHiOld()
	{
		if (ALREADYTALKING == 0)
		{
			ALREADYTALKING = 1;
			PlayAnim("critical", "crouch");
			SayText("Cowards! Cowards you all are! Oh, you are not one of those [orcs], are you?");
			CallEventDelayed(0.0f, "5");
		}
	}

	// greet1
	void OnGreet1()
	{
		SayText("Well, this certainly changes things. Anyone who fights against those creatures certainly deserves my help.");
		CallEventDelayed(0.0f, "5");
	}

	// greet2
	void OnGreet2()
	{
		SayText("I am unsure as to who their master is or what their master plan is, but I think I know why they're here.");
		CallEventDelayed(0.0f, "5");
	}

	// greet3
	void OnGreet3()
	{
		SayText("Our temple worshipped lightning, perhaps more than we should have.");
		CallEventDelayed(0.0f, "5");
	}

	// greet4
	void OnGreet4()
	{
		SayText("For our 100 year celebration, we thought that we should create a symbol for ourselves.");
		CallEventDelayed(0.0f, "5");
	}

	// greet5
	void OnGreet5()
	{
		SayText("We wanted something powerful, something moving. We didn't count on it actually moving..");
		CallEventDelayed(0.0f, "greet6");
	}

	// greet6
	void OnGreet6()
	{
		SayText("We created a being of pure lightning, and during our celebrations, it started killing.");
		CallEventDelayed(0.0f, "greet7");
	}

	// greet7
	void OnGreet7()
	{
		SayText("It took our strongest mages to stop the beast. They managed to drain it's magic into [crystals].");
		CallEventDelayed(0.0f, "greet8");
	}

	// greet8
	void OnGreet8()
	{
		SayText("The process drained them so much that they died in the process. I fear that these orcs are intending");
		CallEventDelayed(0.0f, "greet9");
	}

	// greet9
	void OnGreet9()
	{
		SayText("to return the beast's magic and release him into the world. Here, take this crystal and do with it what you will.");
		UseTrigger("GiveCrystalOne");
		CallEventDelayed(0.0f, "greet10");
	}

	// greet10
	void OnGreet10()
	{
		SayText("I fear that the orcs may continue to try to release him if something isn't done...");
		ALREADYTALKING = 0;
	}

	// crystal
	void OnCrystal()
	{
		if (ALREADYTALKING == 0)
		{
			ALREADYTALKING = 1;
			SayText("Ah, yes. The magic crystals contain all of the beast's powers. They have been scattered through the temple, but");
			CallEventDelayed(0.0f, "5");
		}
	}

	// crystal1
	void OnCrystal1()
	{
		SayText("I fear the orcs may be attempting to gather them to release the monster. When the crystals have");
		CallEventDelayed(0.0f, "5");
	}

	// crystal2
	void OnCrystal2()
	{
		SayText("been placed into the base of the monster's statue, he will be released.");
		ALREADYTALKING = 0;
	}

	// say_stfu
	// === STFU (new)
	void OnSayStfu()
	{
		if (USED_TRIGGER)
			return;
		// setvard CHAT_STEP 10
		SayText("My werd, so rude...");
		CallEventDelayed(1.0f, "use_trig");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chat_loop") { OnChatLoop(); return true; }
		if (name == "check_near") { OnCheckNear(); return true; }
		if (name == "crystal") { OnCrystal(); return true; }
		if (name == "crystal1") { OnCrystal1(); return true; }
		if (name == "crystal2") { OnCrystal2(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "fade_in_loop") { OnFadeInLoop(); return true; }
		if (name == "fade_out") { OnFadeOut(); return true; }
		if (name == "get_angles") { OnGetAngles(); return true; }
		if (name == "greet1") { OnGreet1(); return true; }
		if (name == "greet10") { OnGreet10(); return true; }
		if (name == "greet2") { OnGreet2(); return true; }
		if (name == "greet3") { OnGreet3(); return true; }
		if (name == "greet4") { OnGreet4(); return true; }
		if (name == "greet5") { OnGreet5(); return true; }
		if (name == "greet6") { OnGreet6(); return true; }
		if (name == "greet7") { OnGreet7(); return true; }
		if (name == "greet8") { OnGreet8(); return true; }
		if (name == "greet9") { OnGreet9(); return true; }
		if (name == "light_up") { OnLightUp(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "remove_light") { OnRemoveLight(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi_old") { OnSayHiOld(); return true; }
		if (name == "say_stfu") { OnSayStfu(); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "use_trig") { OnUseTrig(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
