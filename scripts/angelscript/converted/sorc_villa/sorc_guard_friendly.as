#pragma context server

// Converted from sorc_villa/sorc_guard_friendly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_chat_array.as"

[script "sorc_villa/sorc_guard_friendly"]
class SorcGuardFriendly : BaseChatArrayScript
{
	// Constants
	string ANIM_NO = "neigh";
	string ANIM_YES = "nod_yes";

	// Variables (an unset .script variable reads as its own name)
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	CBaseEntity@ CUR_SPEAKER = null;
	bool SPOTTED_PLAYER = false;
	string SCAN_COMMENT = "SCAN_COMMENT";
	string SORC_TYPE = "SORC_TYPE";
	bool VENDOR_ALERT = false;
	CBaseEntity@ VEND_ID = null;
	string ANIM_RAND_IDLE = "ANIM_RAND_IDLE";
	bool GOT_RING = false;
	string QUEST_WINNER = "QUEST_WINNER";

	// Variables declared by included files, with the value they start with in this script
	SorcGuardFriendly()
	{
		CHAT_USE_CONV_ANIMS = false;
		CHAT_NO_CLOSE_MOUTH = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array

		SetName("Shadahar Guard");
		SetModel("monsters/sorc.mdl");
		SetHealth(2000);
		SetDamageTaken("all", 0.7f);
		SetStat("parry", 110);
		SetInvincible(true);
		SetRace("beloved");
		SetNoPush(true);

		SetWidth(32);
		SetHeight(96);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		PlayAnim("once", "idle1");

		SetModelBody(0, 2); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 7); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker

		SetSayTextRange(1024);

		CatchSpeech("say_hi", "hail", "hi", "greet", "gweet", "j0", "up");
		SetMenuAutoOpen(true);

		SetGlobal("G_GAVE_DIRECTIONS", 0);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;

		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		if (SORC_TYPE == "well")
			menuItem.callback = "say_well";
		RegisterMenuItem(menuItem);

		if (SORC_TYPE == "firstguard")
		{
			menuItem.title = "Directions";
			menuItem.type = "callback";
			menuItem.callback = "say_town";
			RegisterMenuItem(menuItem);
		}

		if (SORC_TYPE == "well")
		{
			menuItem.title = "About the well";
			menuItem.type = "callback";
			menuItem.callback = "say_well";
			RegisterMenuItem(menuItem);
		}

		if (SORC_TYPE == "troll1" && !GOT_RING)
		{
			menuItem.title = "Ask About Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_troll_rumors";
			RegisterMenuItem(menuItem);

			if (Truthy(ItemExists(player, "item_bulge")))
			{
				OnChatNow("You have Bulge's ring?");
				menuItem.title = "Give Ring";
				menuItem.type = "payment";
				menuItem.data = "item_bulge";
				menuItem.callback = "troll_got_ring";
				RegisterMenuItem(menuItem);
			}
		}
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		NPC_DO_EVENTS = params;
		if (params == "none")
			return;
		int count = GetTokenCount(NPC_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkDoEvents();
		}
	}

	// npcatk_do_events
	// run param events
	void OnNpcatkDoEvents()
	{
		string nextEvent = "NEXT_EVENT";
		float nEvent = loopIteration;
		string eventName = GetToken(NPC_DO_EVENTS, int(nEvent));
		nEvent += 1.0f;
		if (nEvent <= GetTokenCount(NPC_DO_EVENTS))
			nextEvent = GetToken(NPC_DO_EVENTS, int(nEvent));
		DebugPrint("doing token event " + eventName);
		CallEventOrDelay(eventName, nextEvent);
	}

	// check_face
	void OnCheckFace(CBaseEntity@ target = null)
	{
		if (IsAlive(target))
		{
			SetMoveDest(@target, 9999);
			@CUR_SPEAKER = target;
		}
		else if (IsAlive(ENT_LASTSPOKE))
		{
			SetMoveDest(ENT_LASTSPOKE, 9999);
			@CUR_SPEAKER = EntityOf(ENT_LASTSPOKE);
		}
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		OnCheckFace(talkingPlayer);

		if (SORC_TYPE == "firstguard")
			SayText("You be guests of the Warchief, but don't overstay your welcome.");

		if (SORC_TYPE == "caveguard")
			SayText("Move along. This cave is closed, for the moment.");

		if (SORC_TYPE == "archer" && IsAlive(CUR_SPEAKER) && RangeTo(CUR_SPEAKER) < 256.0f)
			SayText("Please don't be up heres. As a guest of the Warchief, I'm not supposeds to shoots yous, but it makes it looks like meez not doing meez job.");

		if (SORC_TYPE == "guard2")
			SayText("Nuttin to see up here, move along.");

		if (SORC_TYPE == "troll1")
		{
			SayText("Hiyaz, humans who be guests of Runegahr who me no supposed to kills.");
			PlayAnim("critical", "idle3");
		}
	}

	// say_town
	void OnSayTown(CBasePlayer@ target = null)
	{
		OnCheckFace(target);
		OnChatStartSequence("guard_direct");
		SetGlobal("G_GAVE_DIRECTIONS", 1);
	}

	// say_well
	void OnSayWell()
	{
		OnChatStartSequence("guard_well");
	}

	// say_apple
	void OnSayApple()
	{
		SayText("No thanks. Not while I'm on duty.");
	}

	// scan_players
	void OnScanPlayers()
	{
		if (SPOTTED_PLAYER)
			return;
		CallEventDelayed(1.0f, "scan_players");
		if (!Truthy(LegacyFunction("cansee", "player", 256)))
			return;
		SPOTTED_PLAYER = true;
		PlayAnim("once", "nod_yes");
		SayText(SCAN_COMMENT);
	}

	// player_ogre_hole
	void OnPlayerOgreHole()
	{
		bool wellComment = false;

		if (SORC_TYPE == "firstguard")
			wellComment = true;
		if (SORC_TYPE == "caveguard")
			wellComment = true;

		if (wellComment)
		{
			SPOTTED_PLAYER = false;
			SCAN_COMMENT = "Silly human jumped down the ogre well, did he? Hahahaha!";

			CallEventDelayed(0.1f, "scan_players");
		}
	}

	// set_first_guard
	void OnSetFirstGuard()
	{
		OnChatAddText("guard_direct", "Huh? Umm... Most of the shops are downstairs. Smith is at the front of town - opposite of here.", "4.0", "nod_yes");
		OnChatAddText("guard_direct", "Alchemist has a shop near the exit to the desert... There's an... Elf... Out there too. He's with Galat.", "5.0");
		OnChatAddText("guard_direct", "We, tollerate, having him there - but not in town.", "3.0");
		OnChatAddText("guard_direct", "Oh yeah, speaking of tollerate... Above and across from the Alchemist there's a human...", "4.0");
		OnChatAddText("guard_direct", "He's here a lot - sells yummy apples. You might wanna meet him. He's very... Nervous... *chuckle*", "4.0");

		CatchSpeech("say_apple", "apple");

		SCAN_COMMENT = "Stay out of trouble and we'll have no problems...";
		SORC_TYPE = "firstguard";
		CallEventDelayed(0.1f, "scan_players");
	}

	// set_cave_guard
	void OnSetCaveGuard()
	{
		SORC_TYPE = "caveguard";
	}

	// set_archer_roam
	void OnSetArcherRoam()
	{
		SetName("Shadahar Archer");
		SetModelBody(0, 3); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 2); // weapon: 0=unarmed 1=axe 2=bow_noarrow 3=bow_witharrow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		SORC_TYPE = "archer";
		SetRoam(true);
		SetMoveAnim("walk");
		SetStepSize(1);

		SetUniqueName("roof_archer");
	}

	// set_well_guard1
	void OnSetWellGuard1()
	{
		OnChatAddText("guard_well", "I knows how yous humans likes to explore, but don't be thinking about going down this well.", "4.0", ANIM_NO);
		OnChatAddText("guard_well", "We keeps the ogre-djinn down there, until they be old enough to train. Eat yous alive, they will.", "4.0");
		CatchSpeech("say_well", "well");

		SetModelBody(1, 1); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 6); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		SORC_TYPE = "well";
	}

	// set_guard2
	void OnSetGuard2()
	{
		SORC_TYPE = "guard2";
	}

	// ext_under_attack1
	void OnExtUnderAttack1(CBaseEntity@ attacker = null)
	{
		SetSayTextRange(1024);
		SetMoveAnim("run");
		VENDOR_ALERT = true;
		@VEND_ID = attacker;
		SetMoveDest(@VEND_ID, 768);
		PlaySound(0, 10, "monsters/orc/attack3.wav");
		PlaySound(1, 10, "voices/sorc_villa/archer_response1.wav");
		SayText("Those are Runegahr's guests, you stupid human, remember!?");
	}

	// game_reached_destination
	void OnGameReachedDestination()
	{
		if (!VENDOR_ALERT)
			return;
		DebugPrint("game_reached_destination");
		VENDOR_ALERT = false;
		SetMoveDest(@VEND_ID, 9999);
		SetRoam(false);
		SetMoveAnim("walk");
		PlayAnim("critical", "warcry");
	}

	// ext_under_attack2
	void OnExtUnderAttack2(string target = "")
	{
		PlayAnim("critical", ANIM_NO);
		SetMoveDest(target, 9999);
		SetMoveAnim("walk");
		SetRoam(true);
		PlaySound(0, 10, "voices/sorc_villa/archer_response2.wav");
		SayText("Stupid... Cowardly... Son of a boar...");
	}

	// set_troll1
	void OnSetTroll1()
	{
		SetName("Shadahar Lightning Djinn");
		SetModel("monsters/troll_shad.mdl");
		SetWidth(36);
		SetHeight(92);
		SetBoundingBox("npcsize");
		SORC_TYPE = "troll1";
		SetIdleAnim("idle0");
		SetMoveAnim("idle0");
		SetRoam(false);
		ANIM_RAND_IDLE = "idle1";
		CallEventDelayed(Random(20, 30), "rand_idle");
	}

	// rand_idle
	void OnRandIdle()
	{
		CallEventDelayed(Random(20, 30), "rand_idle");
		PlayAnim("once", ANIM_RAND_IDLE);
	}

	// say_troll_rumors
	void OnSayTrollRumors()
	{
		if (CHAT_BUSY)
			return;
		SetName("Lighting Bulge");
		OnChatNow("Hmmm... Maybe yoos humans can helps me with somethings...", "4.0", "idle1", "add_to_que");
		OnChatNow("The call me Bulge - Lighting Bulge... Or at least meez friends do.", "add_to_que");
		OnChatNow("Some mean orcees, who are not friends, stole Bulge's ring.", "5.0", "idle3", "add_to_que");
		OnChatNow("Buldge get ring for pretty girl - who live in that Sun place...", "add_to_que");
		OnChatNow("But mean orcees throw down well.", "add_to_que");
		OnChatNow("Bulge too big to go in well... Maybe you help Bulge get ring? Maybe Bulge gives you somethings he finds.", "add_to_que");
	}

	// troll_got_ring
	void OnTrollGotRing(CBasePlayer@ winner = null)
	{
		GOT_RING = true;
		OnChatNow("Yes! You got me ring back! Haha! Stupid mean orcees no count on skinny humans helpings meez!", "4.0", "idle2", "clear_que");
		OnChatNow("Okies, me give you somethings me find. Weird green-skull thingie. Me no knows what is.", "4.0", "idle1", "give_skull", "add_to_que");
		OnChatNow("Kinda purty, but too spooky for girl. You take, maybe find use for.", "add_to_que");
		QUEST_WINNER = EntityId(winner);
	}

	// give_skull
	void OnGiveSkull()
	{
		Offer(QUEST_WINNER, "item_js");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEventName() {} // EVENT_NAME

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
		Precache("monsters/troll_shad.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_face") { OnCheckFace(EntityParam(params, 0)); return true; }
		if (name == "ext_under_attack1") { OnExtUnderAttack1(EntityParam(params, 0)); return true; }
		if (name == "ext_under_attack2") { OnExtUnderAttack2(Param(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_reached_destination") { OnGameReachedDestination(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_skull") { OnGiveSkull(); return true; }
		if (name == "npcatk_do_events") { OnNpcatkDoEvents(); return true; }
		if (name == "player_ogre_hole") { OnPlayerOgreHole(); return true; }
		if (name == "rand_idle") { OnRandIdle(); return true; }
		if (name == "say_apple") { OnSayApple(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_town") { OnSayTown(PlayerParam(params, 0)); return true; }
		if (name == "say_troll_rumors") { OnSayTrollRumors(); return true; }
		if (name == "say_well") { OnSayWell(); return true; }
		if (name == "scan_players") { OnScanPlayers(); return true; }
		if (name == "set_archer_roam") { OnSetArcherRoam(); return true; }
		if (name == "set_cave_guard") { OnSetCaveGuard(); return true; }
		if (name == "set_first_guard") { OnSetFirstGuard(); return true; }
		if (name == "set_guard2") { OnSetGuard2(); return true; }
		if (name == "set_troll1") { OnSetTroll1(); return true; }
		if (name == "set_well_guard1") { OnSetWellGuard1(); return true; }
		if (name == "troll_got_ring") { OnTrollGotRing(PlayerParam(params, 0)); return true; }
		return BaseChatArrayScript::DispatchEvent(name, params);
	}
}
