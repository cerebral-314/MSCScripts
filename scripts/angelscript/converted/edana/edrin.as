#pragma context server

// Converted from edana/edrin.script by msc_transpiler.
// Edrin, captain of the guard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_xmass.as"

[script "edana/edrin"]
class Edrin : BaseNpcScript, BaseChat, BaseXmass
{
	// Constants
	bool NO_RUMOR = true;
	bool NO_HAIL = true;
	float CHAT_DELAY = 6.0f;
	bool XMASS_OLD_GUY = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	int THIEF_1 = 2;
	int QUEST_1 = 0;
	bool QUEST_1_ASKEDMAYOR = false;
	int REQ_QUEST_NOTDONE = 0;
	Vector3 HOME_LOC = Vector3();
	float HOME_YAW = 0.0f;
	bool QUEST_1_ACCEPTED = false;
	CBasePlayer@ QUEST_1_WINNER = null;
	bool GOT_HOME = false;

	// Variables declared by included files, with the value they start with in this script
	Edrin()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
	}

	// unnamed block (first think)
	void Edrin_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "swordswing1_L"; // future use
	}

	// say_thief
	// Thief Quest, part 2
	void Edrin_OnSayThief()
	{
		if (THIEF_1 != 2)
			return;
		THIEF_1 = 3;
		Say("suspicious");
		SayText("If you see anything suspicious around here, you let me know.");
	}

	// say_thief
	// After telling him about thieves one second time
	void Edrin_OnSayThief_2()
	{
		if (THIEF_1 != 3)
			return;
		THIEF_1 = 4;
		SayText("If you see any thieves, try bribing them for information, or give threats that I will lock them up for good.");
		CallEventDelayed(0.0f, "4");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		int rnd = 0;

		if (QUEST_1 == 0)
		{
			if (!QUEST_1_ASKEDMAYOR)
			{
				menuItem.title = "Say Hello";
				menuItem.type = "say";

				rnd = RandomInt(0, 3);
				if (rnd == 0)
					menuItem.data = "Hail!";
				else if (rnd == 1)
					menuItem.data = "Hello";
				else if (rnd == 2)
					menuItem.data = "Greetings";
				else if (rnd == 3)
					menuItem.data = "Hi";

				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Inquire About Mayor";
				menuItem.type = "say";

				rnd = RandomInt(0, 2);
				if (rnd == 0)
					menuItem.data = "Mayor?";
				else if (rnd == 1)
					menuItem.data = "What's the mayor done this time?";
				else if (rnd == 2)
					menuItem.data = "Damn the mayor?";

				RegisterMenuItem(menuItem);
			}
		}
		else if (QUEST_1 == 1)
		{
			if (!QUEST_1_ACCEPTED)
			{
				menuItem.title = "Accept";

				rnd = RandomInt(0, 3);
				if (rnd == 0)
					menuItem.data = "Aye!";
				else if (rnd == 1)
					menuItem.data = "Alright";
				else if (rnd == 2)
					menuItem.data = "Yes";
				else if (rnd == 3)
					menuItem.data = "Of course";
			}
			else
			{
				menuItem.title = "Ask About quest";
				menuItem.data = "What should I do?";
				menuItem.callback = "say_ok";
			}

			menuItem.type = "say";
			RegisterMenuItem(menuItem);

			if (QUEST_1_ACCEPTED && Truthy(ItemExists(player, "item_letter_mayor")))
			{
				menuItem.title = "Present Evidence";
				menuItem.type = "payment"; // _silent means don't say what's missing - (also crashes)
				menuItem.data = "item_letter_mayor";
				menuItem.callback = "mayorq_done";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		OnSayRumour(); // spellinx
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetHealth(700); // Guards are strong
		SetGold(50);
		SetName("Edrin, Captain of the Guard");
		// ov		359
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/guard1.mdl");
		SetMoveAnim("walk");
		SetInvincible(true);

		THIEF_1 = 2;
		QUEST_1 = 0;
		QUEST_1_ASKEDMAYOR = false;
		REQ_QUEST_NOTDONE = 1;

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("say_mayor", "mayor", "why");
		CatchSpeech("say_ok", "aye", "alright", "sure", "done", "yes", "accept", "of course");
		CatchSpeech("say_job", "job", "work", "money", "gold", "sewer");
		CatchSpeech("say_pretend", "pretend");
		CatchSpeech("say_thief", "cutpurse", "thieves", "bandit", "thief", "poacher");
		CatchSpeech("say_rumour", "rumour", "news", "happenings", "rumor");
		CatchSpeech("say_xmass", "christmas", "xmas", "holidays", "hogswatch", "x-mas");
		CallEventDelayed(1.0f, "set_home_loc");
	}

	// set_home_loc
	void OnSetHomeLoc()
	{
		HOME_LOC = MyOrigin();
		HOME_YAW = MyAngles().y;
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "npc/edrin1.wav");
		SayText("Hail, traveller.");
		CallEventDelayed(2.0f, "say_hi_2");
	}

	// say_hi_2
	void OnSayHi22()
	{
		if (!(QUEST_1 < 2))
			return;

		SayText("...damn that [mayor]!");
		QUEST_1_ASKEDMAYOR = true;
		CallEventDelayed(20.0f, "reset_askedmayor");
	}

	// reset_askedmayor
	void OnResetAskedmayor()
	{
		QUEST_1_ASKEDMAYOR = false;
	}

	// say_mayor
	void OnSayMayor()
	{
		if (!(QUEST_1 < 2))
			return;

		PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), "npc/edrin2.wav");
		SayText("I suspect the mayor is a traitor, working with the Orcs.");
		SetVar("script.targetplayer", @EntityOf(ENT_LASTSPOKE));
		CallEventDelayed(5.0f, "say_mayor_2");
	}

	// say_mayor_2
	void OnSayMayor22()
	{
		SayText("If you find evidence of this, you will be well rewarded. I will brief you through it. Is that all right?");
		QUEST_1 = 1;
		OpenMenu("script.targetplayer");
	}

	// say_ok
	void OnSayOk(CBasePlayer@ speaker = null)
	{
		if (!(QUEST_1 < 2))
			return;

		QUEST_1_ACCEPTED = true;
		SayText("Recently, there has been a courier passing in and out Edana, only delivering a letter to the mayor.");
		CallEventDelayed(4.0f, "say_brief");
	}

	// say_brief
	void OnSayBrief()
	{
		SayText("You'll have to pretend to be him. I've found out his name is Suliban, so that should be your answer should the mayor ask who you are.");
	}

	// game_recvoffer_item
	void OnGameRecvofferItem(string itemScript = "")
	{
		if (itemScript == "item_letter_mayor")
		{
			if (QUEST_1 == 1)
			{
				ReceiveOffer("accept");
				OnMayorqDone(ToPlayer(EntityOf(ENT_LASTGAVE)));
			}
		}
		else if (itemScript == "item_thiefmap" && THIEF_1 == 4)
		{
			ReceiveOffer("accept");
			PlayAnim("once", "return_needle");
			SayText("Ah, what's this? A map of the thieves whereabouts? You have done well, my friend.");
			CallEventDelayed(4.0f, "say_thiefloc");
		}
	}

	// mayorq_done
	void OnMayorqDone(CBasePlayer@ player = null)
	{
		SayText("Ahh! That will certainly be enough evidence... Thank you traveller..");
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, "npc/edrin3.wav");
		CallExternal("all", "worldevent_evidence_found");
		QUEST_1 = 2;
		REQ_QUEST_NOTDONE = 0;
		@QUEST_1_WINNER = player;
		CallEventDelayed(6.0f, "recvletter_2");
	}

	// mayorq_badevidence
	void OnMayorqBadevidence()
	{
		SayText("You'll need to return with solid evidence, worthy of a swift conviction.");
		PlayAnim("once", "no");
	}

	// recvletter_2
	void OnRecvletter2()
	{
		SayText("And please, take this gift.");
		Offer(QUEST_1_WINNER, "gold", RandomInt(12, 15));
		UseTrigger("evidence_found");
		CallExternal("all", "global_mayorquest_done");
	}

	// trig_flowercompliant
	void OnTrigFlowercompliant()
	{
		SayText("Hey! Stay out of there!");
		PlayAnim("once", "wave");
		CallEventDelayed(1.5f, "flowers_2");
	}

	// flowers_2
	// As of JUN2007b, Edrin picked up a bug where he refuses to walk home after his flowers are trampled
	// This forces him to do so, but it worries me that this has happened, as nothing in the script has changed
	// (the removal of the base AI was made after this started)
	void OnFlowers2()
	{
		// Stop waving
		PlayAnim("critical", "idle7");
		CallEventDelayed(0.2f, "go_home");
	}

	// go_home
	void OnGoHome()
	{
		GOT_HOME = false;
		SetMoveDest(HOME_LOC, 5);
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "check_home_loop");
	}

	// check_home_loop
	void OnCheckHomeLoop()
	{
		if (GOT_HOME)
			return;
		CallEventDelayed(1.0f, "check_home_loop");
		if (Distance(MyOrigin(), HOME_LOC) <= 5.0f)
		{
			SetMoveDest("none");
			SetAngle("face", Vector3(0, HOME_YAW, 0));
			GOT_HOME = true;
			SetMoveAnim("ANIM_IDLE");
		}

		if (!(Distance(MyOrigin(), HOME_LOC) > 5.0f))
			return;
		SetMoveAnim(ANIM_WALK);
		SetMoveDest(HOME_LOC, 1);
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		SayText("The sewers has been off limits to civilians for quite some time now, due to the aggressive bats that swarmed the place as of late...");
		CallEventDelayed(8.0f, "say_job2");
	}

	// say_job2
	void OnSayJob2(string target = "")
	{
		SayText("... and seeing as we're rather short on guards, perhaps you could help us out and clear the place?");
		CallEventDelayed(7.0f, "say_job3");
	}

	// say_job3
	void OnSayJob3()
	{
		SayText("Be sure to gear up with some proper weapons, though. Those bats rarely sleep alone...");
		CallEventDelayed(6.0f, "say_job4");
	}

	// say_job4
	void OnSayJob4()
	{
		PlayAnim("once", "talkright");
		SayText("You'll find the entrance to the sewers by the prison, down to the right, by the armorsmith.");
		CallEventDelayed(5.0f, "say_job5");
	}

	// say_job5
	void OnSayJob5()
	{
		SayText("Just move the hay we used to block the hatch.");
		CallEventDelayed(4.0f, "say_job6");
	}

	// say_job6
	void OnSayJob6()
	{
		SayText("Of course, we can't pay you, at the moment, but it is good training.");
	}

	// say_rumour
	// Rumours
	void OnSayRumour(string speaker = "")
	{
		PlayAnim("once", "pondering3");
		SayText("Do I look like a gossiping mongrel? Be off!");
	}

	// say_thief
	void OnSayThief()
	{
		Edrin_OnSayThief();
		Edrin_OnSayThief_2();
	}

	// say_thief2
	void OnSayThief2()
	{
		SayText("Aye, I will have them thieves locked up, if not killed should I get my hands on them.");
	}

	// say_thiefloc
	// After getting map
	void OnSayThiefloc()
	{
		SayText("Hmmmm... this map shows bandits in a few of the local areas, one being in the Thornlands.");
		CallEventDelayed(0.0f, "4");
	}

	// say_thiefloc2
	void OnSayThiefloc2()
	{
		SayText("There will probably be thieves around the area. If not, look in the caves near the road to Edana.");
		CallEventDelayed(4.0f, "say_thiefloc3");
	}

	// say_thiefloc3
	void OnSayThiefloc3()
	{
		SayText("Bring me proof that you've killed them and I'll reward you, if not killing them is reward enough.");
		CallEventDelayed(4.0f, "say_thiefloc4");
	}

	// say_thiefloc4
	void OnSayThiefloc4()
	{
		SetVolume(8);
		Say("guardwarn");
		SayText("Be wary, it is dangerous outside.");
	}

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		if (QUEST_1 < 2)
			OpenMenu(EntityOf(ENT_LASTUSED));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/suspicious.wav");
		Precache("npc/guardwarn.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Edrin_FirstThink();
		BaseChat_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_home_loop") { OnCheckHomeLoop(); return true; }
		if (name == "flowers_2") { OnFlowers2(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "game_recvoffer_item") { OnGameRecvofferItem(Param(params, 0)); return true; }
		if (name == "go_home") { OnGoHome(); return true; }
		if (name == "mayorq_badevidence") { OnMayorqBadevidence(); return true; }
		if (name == "mayorq_done") { OnMayorqDone(PlayerParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "recvletter_2") { OnRecvletter2(); return true; }
		if (name == "reset_askedmayor") { OnResetAskedmayor(); return true; }
		if (name == "say_brief") { OnSayBrief(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi_2") { OnSayHi22(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job2") { OnSayJob2(Param(params, 0)); return true; }
		if (name == "say_job3") { OnSayJob3(); return true; }
		if (name == "say_job4") { OnSayJob4(); return true; }
		if (name == "say_job5") { OnSayJob5(); return true; }
		if (name == "say_job6") { OnSayJob6(); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_mayor_2") { OnSayMayor22(); return true; }
		if (name == "say_ok") { OnSayOk(PlayerParam(params, 0)); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_rumour") { OnSayRumour(Param(params, 0)); return true; }
		if (name == "say_thief") { OnSayThief(); return true; }
		if (name == "say_thief2") { OnSayThief2(); return true; }
		if (name == "say_thiefloc") { OnSayThiefloc(); return true; }
		if (name == "say_thiefloc2") { OnSayThiefloc2(); return true; }
		if (name == "say_thiefloc3") { OnSayThiefloc3(); return true; }
		if (name == "say_thiefloc4") { OnSayThiefloc4(); return true; }
		if (name == "set_home_loc") { OnSetHomeLoc(); return true; }
		if (name == "trig_flowercompliant") { OnTrigFlowercompliant(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
