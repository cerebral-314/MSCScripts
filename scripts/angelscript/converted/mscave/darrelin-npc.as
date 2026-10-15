#pragma context server

// Converted from mscave/darrelin-npc.script by msc_transpiler.
// *** This script is for Darrelin in the Dark Caves ***
// Spawn properties

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat.as"

[script "mscave/darrelin-npc"]
class DarrelinNpc : BaseChatScript
{
	// Constants
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	bool NO_HAIL = true;

	// Variables (an unset .script variable reads as its own name)
	int CANCHAT = 1;
	int REQ_QUEST_NOTDONE = 0;
	bool NO_MOUTH_MOVE = false;
	CBasePlayer@ QUEST_COMPLETER = null;
	float NEXT_CHAT_WARN = 0.0f;

	// game_spawn
	void DarrelinNpc_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		REQ_QUEST_NOTDONE = 1;

		SetHealth(20);
		SetGold(3);
		SetName("Darrelin");
		// ov 30
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetModel("npc/human1.mdl");
		SetMoveAnim("walk");
		SetInvincible(true);
		CANCHAT = 1;

		CatchSpeech("say_hi", "hello", "hail", "greet", "hi");

		CatchSpeech("say_orc", "orc");

		CatchSpeech("say_myth", "myth");

		CatchSpeech("say_acting", "act");

		CatchSpeech("say_orc", "orc");

		CatchSpeech("say_myth", "myth");

		CatchSpeech("say_acting", "act");

		CatchSpeech("say_name", "name");

		CatchSpeech("say_goblins", "goblin");

		CatchSpeech("say_river", "river");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		DarrelinNpc_OnGameSpawn(playerRace, playerGender);
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;
		menuItem.title = "Say Hello";
		menuItem.type = "say";

		int say = RandomInt(1, 4);
		if (say == 1)
			menuItem.data = "Hello";
		else if (say == 2)
			menuItem.data = "Hi";
		else if (say == 3)
			menuItem.data = "Hail";
		else if (say == 4)
			menuItem.data = "Greetings!";
		RegisterMenuItem(menuItem);

		if (Truthy(ItemExists(player, "item_manuscript")))
		{
			menuItem.title = "Return manuscript";
			menuItem.type = "payment";
			menuItem.data = "item_manuscript";
			menuItem.callback = "give_manuscript";
			RegisterMenuItem(menuItem);
		}
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ lastSpoke = null;
		if (IsPlayer(talkingPlayer))
			@lastSpoke = talkingPlayer;
		else
			@lastSpoke = EntityOf(ENT_LASTSPOKE);

		if (BUSY_CHATTING)
		{
			// callevent 1.0 say_hi
			OnChatWarning(lastSpoke);
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_hi.wav");

		NO_MOUTH_MOVE = true;
		Say("[.3]", "[.1]", "[.1]", "[.3]", "[.02]", "[.2]", "[.1]", "[.3]", "[.3]", "[.3]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]", "[.1]");

		CHAT_STEP1 = "Hail Traveller! Welcome to... THE DARK CAVES......!";
		ANIM_STEP1 = "studycart";
		CHAT_DELAY_STEP1 = "9.4";

		CallEventDelayed(9.3f, "restore_mouth_move");

		CHAT_STEP2 = "Sorry about that, I used to be an [actor]... I still am, in a way.";
		CHAT_DELAY_STEP2 = "4.7";

		CHAT_STEP3 = "Anyway, the [Orcs] have taken over the caves, so be careful if you plan on going through them.";
		CHAT_DELAY_STEP3 = "7.0";

		CHAT_STEP4 = "You may also be interested to hear about a [goblin] town near here.";
		CHAT_DELAY_STEP4 = "3.0";

		CHAT_STEPS = 4;

		OnChatLoop();
	}

	// restore_mouth_move
	void OnRestoreMouthMove()
	{
		NO_MOUTH_MOVE = false;
		OnBchatAutoMouthMove("4.7");
	}

	// say_orc
	void OnSayOrc()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_orc");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_orc.wav");

		CHAT_STEP1 = "Well, as you probably know, the Orcs have been growing in number faster than usual.";
		CHAT_DELAY_STEP1 = "5.4";

		CHAT_STEP2 = "Since they therefor need more land they use shamans to come in and lock down an area using magic.";
		CHAT_DELAY_STEP2 = "5.0";

		CHAT_STEP3 = "This allows their warriors to march in and absolutely massacre all the men, women, and children of entire towns. It's terribly frightful!";
		CHAT_DELAY_STEP3 = "8.6";

		CHAT_STEP4 = "Unfortunately for us, this is a rather successful tactic, except... Eh, there is one thing...";
		CHAT_DELAY_STEP4 = "7.6";

		CHAT_STEP5 = "Theres a [myth] of sorts surrounding these caves, and I don't think the orcs are using the caves just to store their loot.";
		ANIM_STEP5 = "pondering";
		CHAT_DELAY_STEP5 = "6.3";

		CHAT_STEPS = 5;

		OnChatLoop();
	}

	// say_myth
	void OnSayMyth()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_myth");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_myth.wav");

		CHAT_STEP1 = "Well, theres supposed to be some kind of building that's tucked away deep inside the caverns.";
		CHAT_DELAY_STEP1 = "6.3";

		CHAT_STEP2 = "It's probably ancient history now, but it was a fortress literally powered by magic itself, except...";
		CHAT_DELAY_STEP2 = "5.7";

		CHAT_STEP3 = "I can't help wondering why it isn't active... Nobody seems to know why...";
		CHAT_DELAY_STEP3 = "4.9";

		CHAT_STEP4 = "Though the path to the fort is clear, its silent, closed, so I guess whatever's in there, we're doomed to it... I guess.";
		CHAT_DELAY_STEP4 = "6.4";

		CHAT_STEPS = 4;

		OnChatLoop();
	}

	// say_acting
	void OnSayActing()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_acting");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_acting.wav");

		CHAT_STEP1 = "Oh I'm sure you must've heard the [name] of Darrelino the Greatest Actor in ALL of Daragoth, nay the WORLD!";
		ANIM_STEP1 = "converse1";
		CHAT_DELAY_STEP1 = "5.5";

		CHAT_STEP2 = "You haven't!?!...";
		CHAT_DELAY_STEP2 = "2.5";

		CHAT_STEP3 = "Oh well, that's your loss then.";
		ANIM_STEP3 = "no";
		CHAT_DELAY_STEP3 = "2.8";

		CHAT_STEPS = 3;

		OnChatLoop();
	}

	// say_name
	void OnSayName()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_name");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_name-say_script.wav");

		CHAT_STEP1 = "Well, my stage name is Darrelino Var and I happen to think it's a very good name, thank you very much!";
		CHAT_DELAY_STEP1 = "5.6";

		CHAT_STEP2 = "Too bad I can't practice for the big performance! I don't have my script anymore! I used to go practice my lines in the forest, you see.";
		CHAT_DELAY_STEP2 = "8.4";

		CHAT_STEP3 = "...and then one night, as I was practicing my lines... Something attacked me!";
		CHAT_DELAY_STEP3 = "4.3";

		CHAT_STEP4 = "It lunged at me! I had no idea what it was. I thought it was a thief, maybe waiting in the shadows to steal all my belongings!";
		CHAT_DELAY_STEP4 = "5.9";

		CHAT_STEP5 = "So I managed to run, away from it, but then I heard all kinds of sounds rustling behind me in the bushes.";
		CHAT_DELAY_STEP5 = "5.4";

		CHAT_STEP6 = "So did the first thing that came to mind: I hid all my belongings in a hollow tree, and covered it with some leaves.";
		CHAT_DELAY_STEP6 = "6.1";

		CHAT_STEP7 = "But, on the way out, nobody came and attacked me! I turned around to look, and I could swear I saw pale figures walking in the forest. So I turned and ran away.";
		CHAT_DELAY_STEP7 = "9.2";

		CHAT_STEP8 = "I hear it's really dangerous in the forest now. It turns out that what attacked me wasn't actually a thief, but the living dead itself!"; // had to cut this one short, message too long
		CHAT_DELAY_STEP8 = "12.3";

		CHAT_STEP9 = "Oh do you think you could find my manuscript for me? I'm sure it's still in that hollow tree covered by the leaves."; // same here
		CHAT_DELAY_STEP9 = "10.1";

		CHAT_STEPS = 9;

		OnChatLoop();
	}

	// say_goblins
	void OnSayGoblins()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_goblins");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_goblins.wav");

		CHAT_STEP1 = "The Goblins have a town carved into the mountains through the caves, near a [river] dried up by a dam.";
		CHAT_DELAY_STEP1 = "6.0";

		CHAT_STEP2 = "You'll find one of the goblins to be an extremely tough opponent.... He seems to be their leader, of sorts";
		CHAT_DELAY_STEP2 = "5.8";

		CHAT_STEP3 = "It wouldn't be so bad but they like attacking in large groups! So, do be careful.";
		CHAT_DELAY_STEP3 = "6.4";

		CHAT_STEPS = 3;

		OnChatLoop();
	}

	// say_river
	void OnSayRiver()
	{
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "say_river");
			OnChatWarning(EntityOf(ENT_LASTSPOKE));
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(2, 10, "voices/mscave/actor-say_river.wav");

		CHAT_STEP1 = "I learnt recently that the Orcs have decided to block the river. It's a prelude to invading the Goblins to weaken them.";
		CHAT_DELAY_STEP1 = "5.4";

		CHAT_STEP2 = "I don't know which is worse... Those damned Goblins or the Orcs!";
		CHAT_DELAY_STEP2 = "3.0";

		CHAT_STEPS = 2;

		OnChatLoop();
	}

	// give_manuscript
	void OnGiveManuscript(CBasePlayer@ completer = null)
	{
		if (IsAlive(completer))
		{
			@QUEST_COMPLETER = completer;
			REQ_QUEST_NOTDONE = 0;
		}
		if (BUSY_CHATTING)
		{
			CallEventDelayed(1.0f, "give_manuscript");
			OnChatWarning(completer);
		}
		if (BUSY_CHATTING)
			return;

		PlaySound(0, 10, "voices/mscave/actor-give_manuscript.wav");

		CHAT_STEP1 = "You found my manuscript! Thank you so much, " + NameOf(QUEST_COMPLETER);
		CHAT_STEP1 += ", I can continue practicing!";
		ANIM_STEP1 = "eye_wipe";
		CHAT_DELAY_STEP1 = "4.5";

		CHAT_STEP2 = "Oh, I should reward you... Wait... Here, take this... It's a gold pouch. It's not much, but it's the best I can do.";
		CHAT_DELAY_STEP2 = "6.4";
		CHAT_EVENT_STEP2 = "give_manuscript_reward";

		CHAT_STEPS = 2;

		OnChatLoop();
	}

	// give_manuscript_reward
	void OnGiveManuscriptReward()
	{
		Offer(QUEST_COMPLETER, "gold", RandomInt(30, 60));
	}

	// chat_warning
	void OnChatWarning(CBaseEntity@ player = null)
	{
		if (!(GameTime() > NEXT_CHAT_WARN))
			return;
		NEXT_CHAT_WARN = GameTime() + 20.0f;
		PlayerMessageDark(player, "Darrelin is still chatting about something else...");
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
		if (name == "chat_warning") { OnChatWarning(EntityParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_manuscript") { OnGiveManuscript(PlayerParam(params, 0)); return true; }
		if (name == "give_manuscript_reward") { OnGiveManuscriptReward(); return true; }
		if (name == "restore_mouth_move") { OnRestoreMouthMove(); return true; }
		if (name == "say_acting") { OnSayActing(); return true; }
		if (name == "say_goblins") { OnSayGoblins(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_myth") { OnSayMyth(); return true; }
		if (name == "say_name") { OnSayName(); return true; }
		if (name == "say_orc") { OnSayOrc(); return true; }
		if (name == "say_river") { OnSayRiver(); return true; }
		return BaseChatScript::DispatchEvent(name, params);
	}
}
