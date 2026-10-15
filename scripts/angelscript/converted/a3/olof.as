#pragma context server

// Converted from a3/olof.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "a3/olof"]
class Olof : BaseMonsterNewScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	bool NO_HAIL = true;
	bool NO_JOB = true;
	bool NO_RUMOR = true;
	string STORE_NAME = "olof_shop";
	string SND_SCREAM1 = "scientist/scream7.wav";
	string SND_SCREAM2 = "scientist/scream17.wav";
	string SND_SCREAM3 = "scientist/scream07.wav";

	// Variables (an unset .script variable reads as its own name)
	bool STORE_SELLMENU = true;
	string STORE_BUYMENU = "1";
	bool VENDOR_MENU_OFF = false;
	bool VENDOR_NOT_ON_USE = false;
	string SHOPPER_ID = "SHOPPER_ID";
	CBaseEntity@ VERIFY_TARGET = null;
	bool SAW_FIRST_PLAYER = false;
	string VENDOR_TARGET = "VENDOR_TARGET";
	string RING_BOY_ID = "RING_BOY_ID";
	bool AM_SCREAMING = false;
	CBaseEntity@ CALMER_ID = null;
	CBaseEntity@ HI_PLAYER = null;
	string CHAT_STEP1 = "CHAT_STEP1";
	string ANIM_STEP1 = "ANIM_STEP1";
	string CHAT_DELAY_STEP1 = "CHAT_DELAY_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string ANIM_STEP2 = "ANIM_STEP2";
	string CHAT_DELAY_STEP2 = "CHAT_DELAY_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_DELAY_STEP3 = "CHAT_DELAY_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string CHAT_DELAY_STEP4 = "CHAT_DELAY_STEP4";
	string ANIM_STEP4 = "ANIM_STEP4";
	bool MENTIONED_CURSE = false;
	int CHAT_STEPS = 0;
	string ANIM_STEP3 = "ANIM_STEP3";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	float NEXT_STORE_CHATTER = 0.0f;
	bool HAVE_RING = false;
	string QUEST_WINNER = "QUEST_WINNER";
	string CHAT_STEP5 = "CHAT_STEP5";
	string CHAT_DELAY_STEP5 = "CHAT_DELAY_STEP5";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";

	// Variables declared by included files, with the value they start with in this script
	Olof()
	{
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void Olof_FirstThink()
	{
		ANIM_RUN = "run1";
		ANIM_WALK = "walk_scared";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void Olof_FirstThink2()
	{
		NPC_NO_PLAYER_DMG = true;
		NO_STUCK_CHECKS = "1";

		NPC_NO_ATTACK = true;
		CANT_TURN = "1";

		VENDOR_MENU_OFF = true;
		VENDOR_NOT_ON_USE = true;
		STORE_SELLMENU = true;
		STORE_BUYMENU = "1";
	}

	// unnamed block (timer)
	void Olof_Timer()
	{
		CallEventDelayed(1.0f, "Olof_Timer");
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;

		CBaseEntity@ playerId = EntityOf(ENT_LASTSEEN);
		OnCheckPlayerStatus(playerId, 1);
	}

	// game_damaged
	string Olof_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (IsPlayer(attacker))
			return result;

		SetIdleAnim("walk_scared");
		SetRoam(true);
		SetMenuAutoOpen(false);
		OnNpcatkFlee(EntityId(attacker), "9999", "8.0");
		PlayRandomSound(0, 10, SND_SCREAM1, SND_SCREAM2, SND_SCREAM3);
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetName("Olof Odlaren");
		SetModel("npc/human1.mdl");
		SetHealth(30);
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false);
		SetIdleAnim("idle1");

		SetNoPush(true);

		CatchSpeech("say_yes", "yes", "yep", "yeah", "jawoll", "boo");
		CatchSpeech("say_no", "no", "not", "stop", "nope", "nah", "calm", "nein");
		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "j0", "wud", "gweets");
		CatchSpeech("say_curse", "curse", "people", "town", "help");

		SHOPPER_ID = "none";
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Olof_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;
		bool exitSub = false;
		bool secondRing = false;

		SetMoveDest(@player, 9999);

		VENDOR_TARGET = EntityId(player);

		string playerStatus = ScriptVarOf(player, "PLR_OLOF_STATUS");

		if (playerStatus == "PLR_OLOF_STATUS")
		{
			OnCheckPlayerStatus(player, 0);
			playerStatus = ScriptVarOf(player, "PLR_OLOF_STATUS");
		}

		if (player !is VERIFY_TARGET && playerStatus == "unknown")
			OnVerifyFriendly(player, 1);

		if (player is VERIFY_TARGET)
		{
			menuItem.title = "Yes!";
			menuItem.type = "callback";
			menuItem.callback = "say_yes";
			RegisterMenuItem(menuItem);

			menuItem.title = "No!";
			menuItem.type = "callback";
			menuItem.callback = "say_no";
			RegisterMenuItem(menuItem);

			exitSub = true;
		}
		if (exitSub)
			return;

		if (playerStatus == "evil" && AM_SCREAMING)
		{
			menuItem.title = "Wait! I'm NOT evil!";
			menuItem.type = "callback";
			menuItem.callback = "say_no";
			RegisterMenuItem(menuItem);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (playerStatus == "friendly")
		{
			menuItem.title = "Hail?";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);

			menuItem.title = "You have wares?";
			menuItem.type = "callback";
			menuItem.callback = "vendor_offerstore";
			RegisterMenuItem(menuItem);

			if (MENTIONED_CURSE)
			{
				menuItem.title = "Cursed?";
				menuItem.type = "callback";
				menuItem.callback = "say_curse";
				RegisterMenuItem(menuItem);
			}

			if (Truthy(ItemExists(player, "item_ring")) && Float(GetQuestData(player, "r")) == 0.0f)
			{
				if (HAVE_RING)
					secondRing = true;
				if (RING_BOY_ID != "RING_BOY_ID")
					secondRing = true;
				if (!secondRing)
				{
					if (!Truthy(ItemExists(player, "item_ring_percept")))
					{
						RING_BOY_ID = EntityId(player);
						OnNotMyRing();
						return;
					}
					else
					{
						menuItem.title = "Return ring";
						menuItem.type = "payment";
						menuItem.data = "item_ring";
						menuItem.callback = "got_ring";
						RegisterMenuItem(menuItem);
					}
				}
				else
				{
					menuItem.title = "Return ring";
					menuItem.type = "callback";
					menuItem.callback = "second_ring";
					RegisterMenuItem(menuItem);
				}
			}

			if (AM_SCREAMING)
				OnCalmDown("friendly_used", player);
		}
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		BaseNpcVendorConfirm_OnGameMenuCancel(player); // monsters/base_npc_vendor_confirm
		if (player !is VERIFY_TARGET)
			return;
		SayText("I... I won't talk until you answer me!");
		Say("[0.5]", "[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]");
		PlayAnim("once", "panic");
	}

	// check_player_status
	// <id> <react:0|1>
	void OnCheckPlayerStatus(CBaseEntity@ player = null, int react = 0)
	{
		string playerStatus = ScriptVarOf(player, "PLR_OLOF_STATUS");

		if (playerStatus == "PLR_OLOF_STATUS")
		{
			// dunno this guy, check him
			if (Float(GetQuestData(player, "r")) > 0.0f)
			{
				// I know this guy, gave ring quest
				CallExternal(player, "ext_olof_setstatus", "friendly");
				if (react != 0)
					OnCalmDown("ring_quest_started", player);
			}
			else if (Truthy(ItemExists(player, "item_ring_percept")))
			{
				// Has Galan's ring
				CallExternal(player, "ext_olof_setstatus", "friendly");
				OnCalmDown("ring_percept", player);
			}
			else if (Truthy(ItemExists(player, "item_ring")))
			{
				// this guy has my ring & doesn't have the bloodstone ring. Start bloodstone ring quest
				CallExternal(player, "ext_olof_setstatus", "friendly");
				OnCalmDown("my_ring", player);
			}
			else
			{
				// I dunno this guy :|
				CallExternal(player, "ext_olof_setstatus", "unknown");
				if (react != 0)
					OnVerifyFriendly(player, 0);
			}
		}
		else if (react != 0 && playerStatus == "evil" && !AM_SCREAMING)
		{
			OnStartScreaming();
			SayText("Get away from me you evil monster from hell!");
			Say("[0.5]", "[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]");
		}
	}

	// verify_friendly
	// <id> <from_menu:0|1>
	void OnVerifyFriendly(CBaseEntity@ playerId = null, int calledFromMenu = 0)
	{
		@VERIFY_TARGET = playerId;

		CallExternal(playerId, "ext_olof_setstatus", "unknown");

		if (!SAW_FIRST_PLAYER)
		{
			SayText("Halt! Are you one of the undead monsters?");
			Say("[0.5]", "[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]");
			SAW_FIRST_PLAYER = true;
		}
		else
		{
			SayText("And you? ...are YOU one of the evil ones?");
			Say("[0.5]", "[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]");
		}

		PlayAnim("once", "panic");

		if (calledFromMenu != 0)
			return;
		OpenMenu(playerId);
	}

	// say_yes
	void OnSayYes(CBasePlayer@ player = null)
	{
		CBaseEntity@ playerId = null;
		if (IsAlive(player))
			@playerId = player;
		else
			@playerId = EntityOf(ENT_LASTSPOKE);
		@VERIFY_TARGET = null;
		CallExternal(playerId, "ext_olof_setstatus", "evil");

		SayText("AAAAAAAAAAAAAAAAAAAAHHHHHHHHHHHHHHHHHHH!!!!!!!!");
		PlayAnim("once", "fear2");
		Say("[2]");

		AM_SCREAMING = true;
		CallEventDelayed(2.0f, "do_screaming");
	}

	// say_no
	void OnSayNo(CBasePlayer@ player = null)
	{
		CBaseEntity@ playerId = null;
		if (IsAlive(player))
			@playerId = player;
		else
			@playerId = EntityOf(ENT_LASTSPOKE);
		@CALMER_ID = playerId;
		CallExternal(playerId, "ext_olof_setstatus", "friendly");
		@VERIFY_TARGET = null;
		AM_SCREAMING = false;
		PlayAnim("once", "lean");
		SetMenuAutoOpen(true);
		CallEventDelayed(3.0f, "say_no2");
	}

	// say_no2
	void OnSayNo2()
	{
		OnCalmDown("said_no", CALMER_ID);
		@VERIFY_TARGET = null;
	}

	// start_screaming
	void OnStartScreaming()
	{
		AM_SCREAMING = true;
		OnDoScreaming();
	}

	// do_screaming
	void OnDoScreaming()
	{
		if (!AM_SCREAMING)
			return;

		int rndAnim = RandomInt(1, 4);
		if (rndAnim == 1)
			PlayAnim("once", "fear1");
		if (rndAnim == 2)
			PlayAnim("once", "fear2");
		if (rndAnim == 3)
			PlayAnim("once", "crouch_idle2");
		if (rndAnim == 4)
			PlayAnim("once", "crouch_idle2");

		PlayRandomSound(2, 8, SND_SCREAM1, SND_SCREAM2, SND_SCREAM3);
		SetIdleAnim("crouch_idle");

		CallEventDelayed(Random(5, 10), "do_screaming");
	}

	// calm_down
	// ============= Calm Down
	// <reason> <player>
	void OnCalmDown(string reason = "", CBaseEntity@ player = null)
	{
		string name = "L_NAME";
		SetRoam(false);
		AM_SCREAMING = false;
		SetIdleAnim("idle1");
		if (reason == "ring_quest_started")
		{
			SayText("Oh, it's you... I hope you got that ring back to Galan.");
			OnBchatAutoMouthMove("3.0");
		}

		if (reason == "my_ring")
		{
			name = NameOf(player) + ",";

			SayText(name + " have you found the ring yet?");
			Say("[0.5]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.2]");
			PlayAnim("once", "pondering3");
		}

		if (reason == "skull_blade")
		{
			name = NameOf(player) + ",";

			SayText("Ah, " + name + " Thank you for the nice ring.");
			Say("[0.5]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.2]");
			PlayAnim("once", "yes");
		}

		if (reason == "friendly_used")
		{
			SayText("Oh! It... It's you... What can I do for you?");
			OnBchatAutoMouthMove("3.0");
		}

		if (reason == "said_no")
		{
			SayText("...Ok, I believe you... for now...");
			Say("[0.2]", "[0.2]", "[0.1]", "[0.2]", "[0.1]", "[0.1]");
		}

		if (reason == "ring_percept")
		{
			SayText("I... I see you worked things out with Galan's ring.");
			Say("[0.2]", "[0.2]", "[0.1]", "[0.2]", "[0.1]", "[0.1]");
		}

		if (reason == "ring_boy")
			OnNotMyRing();
	}

	// say_hi
	// ============= Chatter
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ playerId = null;
		if (IsAlive(talkingPlayer))
			@playerId = talkingPlayer;
		else
			@playerId = EntityOf(ENT_LASTSPOKE);
		string playerStatus = ScriptVarOf(playerId, "PLR_OLOF_STATUS");

		if (!IsAlive(playerId))
			return;

		if (playerStatus == "PLR_OLOF_STATUS")
			playerStatus = "unknown";

		if (playerStatus == "unknown")
		{
			SayText("Stay away from me! You look like evil! Are you evil?!?");
			Say("[0.2]", "[0.1]", "[0.05]", "[0.05]", "[0.05]", "[0.05]", "[0.05]", "[0.1]");
			PlayAnim("once", "panic");
			OnVerifyFriendly(playerId, 0);
		}

		if (playerStatus == "evil")
		{
			SayText("The evil fiend tried to talk to me!!! No, my ears have been cursed!");
			Say("[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]", "[0.1]");

			PlayAnim("once", "fear1");
		}

		if (playerStatus == "friendly")
		{
			@HI_PLAYER = playerId;
			OnSayHi2();
		}
	}

	// say_hi2
	void OnSayHi2()
	{
		if (BUSY_CHATTING)
			PlayerMessageDark(HI_PLAYER, "Olof is busy babbling about something else...");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "..Are you really sure you are no monster? ";
		ANIM_STEP1 = "pondering3";
		CHAT_DELAY_STEP1 = "3.0";

		CHAT_STEP2 = "There is too much evil these days..";
		ANIM_STEP2 = "c1a0_catwalkidle";
		CHAT_DELAY_STEP2 = "2.0";

		CHAT_STEP3 = "If you really are a shining light, maybe you could help me?";
		CHAT_DELAY_STEP3 = "4.0";

		CHAT_STEP4 = "All of the people in this town have been [cursed]!";
		CHAT_DELAY_STEP4 = "3.0";
		ANIM_STEP4 = "startle";

		MENTIONED_CURSE = true;

		CHAT_STEPS = 4;
		OnChatLoop();
	}

	// say_curse
	void OnSayCurse(CBasePlayer@ player = null)
	{
		CBaseEntity@ playerId = null;

		if (IsAlive(player))
			@playerId = player;
		else
			@playerId = EntityOf(ENT_LASTSPOKE);
		string playerStatus = ScriptVarOf(playerId, "PLR_OLOF_STATUS");

		if (playerStatus != "friendly")
			return;

		if (BUSY_CHATTING)
			PlayerMessageDark(playerId, "Olof is busy babbling about something else...");
		if (BUSY_CHATTING)
			return;

		CHAT_STEP1 = "Yeah, horrible isn't it? ";
		ANIM_STEP1 = "eye_wipe";
		CHAT_DELAY_STEP1 = "2.0";

		CHAT_STEP2 = "The evil Lord Undamael has turned all the people in my town into books!";
		CHAT_DELAY_STEP2 = "4.0";

		CHAT_STEP3 = "I will need my ring to turn them back to normal again.";
		ANIM_STEP3 = "yes";
		CHAT_DELAY_STEP3 = "3.0";

		CHAT_STEP4 = "I will reward you if you find it, but you won't.. because I lost it in the..";
		ANIM_STEP4 = "no";
		CHAT_DELAY_STEP4 = "3.0";
		CHAT_EVENT_STEP4 = "say_curse2";

		CHAT_STEPS = 4;
		OnChatLoop();
	}

	// say_curse2
	void OnSayCurse2()
	{
		PlayAnim("critical", "fear1");
		CallEventDelayed(1.0f, "say_curse3");
	}

	// say_curse3
	void OnSayCurse3()
	{
		SayText("..H-A-U-N-T-E-D forest!");
		Say("[1]", "[0.2]", "[1]", "[0.2]");
	}

	// vendor_offerstore
	// ============= STORE
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		string playerStatus = ScriptVarOf(player, "PLR_OLOF_STATUS");
		if (playerStatus != "friendly")
			return;

		if (SHOPPER_ID != "none")
			return;

		if (GameTime() > NEXT_STORE_CHATTER)
		{
			int rndChat = RandomInt(1, 5);
			if (rndChat == 1)
				SayText("Demons leave the most interesting stuff lying around...");
			if (rndChat == 2)
				SayText("Don't tell anyone, but there's more downstairs...");
			if (rndChat == 3)
				SayText("All this stuff is cursed, you know...");
			if (rndChat == 4)
				SayText("I don't sell to demons, but I suppose you're ok.");
			if (rndChat == 5)
				SayText("I'll buy skins if ya have em, they keeps the demons away.");
			OnBchatAutoMouthMove("3.0");
			NEXT_STORE_CHATTER = GameTime() + 10.0f;
		}

		SHOPPER_ID = EntityId(player);
		CallEventDelayed(2.0f, "give_store");
	}

	// give_store
	void OnGiveStore()
	{
		OnBasevendorOfferstore(SHOPPER_ID);
		SHOPPER_ID = "none";
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  		|Quantity|	|cost%|		|Sell ratio|	|Bundle amt|
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(10, 20), 105);
		AddStoreItem(STORE_NAME, "health_apple", RandomInt(15, 25), 100);
		AddStoreItem(STORE_NAME, "proj_arrow_wooden", 120, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_poison", 120, 75, 0, 30);
		AddStoreItem(STORE_NAME, "proj_arrow_broadhead", 120, 100, 0, 60);
		AddStoreItem(STORE_NAME, "proj_arrow_silvertipped", 120, 100, 0, 60);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(0, 1), 110);
		AddStoreItem(STORE_NAME, "item_torch", RandomInt(10, 20), 75);

		AddStoreItem(STORE_NAME, "axes_scythe", RandomInt(0, 1), 90);
		AddStoreItem(STORE_NAME, "scroll2_glow", RandomInt(0, 1), 100);
		AddStoreItem(STORE_NAME, "scroll_glow", RandomInt(0, 1), 100);
		AddStoreItem(STORE_NAME, "scroll2_fire_dart", RandomInt(0, 1), 120);
		AddStoreItem(STORE_NAME, "sheath_spellbook", 2, 80);

		AddStoreItem(STORE_NAME, "skin_boar", 0, 150, 1.5f);
		AddStoreItem(STORE_NAME, "skin_ratpelt", 0, 250, 2.5f);
		AddStoreItem(STORE_NAME, "skin_bear", 0, 150, 1.5f);
		AddStoreItem(STORE_NAME, "skin_boar_heavy", 0, 150, 1.5f);

		if (RandomInt(1, 3) != 1)
			return;
		AddStoreItem(STORE_NAME, "sheath_back_holster", 1, 100, "SELL_RATIO");
	}

	// closetskel
	// ============== COMBAT (or lack thereof)
	// called from ms_npcscript on map
	void OnClosetskel()
	{
		SetMoveAnim("run1");
		SetIdleAnim("walk_scared");
	}

	// npcatk_settarget
	// I don't hunt
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
	}

	// got_ring
	// ============== Ring Quests
	void OnGotRing(CBasePlayer@ player = null)
	{
		HAVE_RING = true;
		SayText("What's that? Ohh, nice ring!");
		PlayAnim("once", "return_needle");
		Say("[0.2]", "[0.2]", "[0.05]", "[0.05]", "[0.05]", "[0.05]");
		QUEST_WINNER = EntityId(player);
		CallEventDelayed(2.0f, "got_ring2");
	}

	// got_ring2
	void OnGotRing2()
	{
		SayText("Don't know who it belongs to, but I'll trade it for one of my swords!");
		PlayAnim("once", "pull_needle");
		Say("[0.2", "[0.2]", "[0.1]", "[0.1]", "[0.1]", "[0.2]", "[0.2]", "[0.2]");
		CallEventDelayed(2.0f, "give_sword");
	}

	// give_sword
	void OnGiveSword()
	{
		Offer(QUEST_WINNER, "swords_skullblade4");
	}

	// second_ring
	void OnSecondRing()
	{
		SayText("Another... Ring? So...");
		PlayAnim("once", "dryhands");
		Say("[1]");
		CallEventDelayed(1.5f, "second_ring2");
	}

	// second_ring2
	void OnSecondRing2()
	{
		SayText("pretty....");
		Say("[1]");
		CallEventDelayed(2.0f, "second_ring3");
	}

	// second_ring3
	void OnSecondRing3()
	{
		SayText("No! I musn't be tempted!");
		Say("[0.2]", "[0.2]", "[0.2]", "[0.2]");
		PlayAnim("critical", "rflinch1");
	}

	// not_my_ring
	// called from calm_down if player has skull blade and ring, but no bloodstone ring quest
	void OnNotMyRing()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "not_my_ring");
		if (BUSY_CHATTING)
			return;

		SetMoveDest(RING_BOY_ID, 9999);
		CHAT_STEP1 = "Hey, that rr.r....ring you have there...";
		ANIM_STEP1 = "eye_wipe";
		CHAT_DELAY_STEP1 = "3.0";

		CHAT_STEP2 = "That one's not mine!";
		CHAT_DELAY_STEP2 = "2.0";

		CHAT_STEP3 = "But I bet I know who would know whose it is!";
		CHAT_DELAY_STEP3 = "3.0";

		CHAT_STEP4 = "Galan! In Gatecity...";
		CHAT_DELAY_STEP4 = "2.0";

		CHAT_STEP5 = "He and I were friends... Before... You know... The b..books....";
		CHAT_DELAY_STEP5 = "4.0";
		CHAT_EVENT_STEP5 = "not_my_ring2";

		CHAT_STEPS = 5;
		OnChatLoop();
	}

	// not_my_ring2
	void OnNotMyRing2()
	{
		Quest("set", RING_BOY_ID, "r", 1);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		BaseMonsterShared_OnGameTargetedByPlayer(player); // monsters/base_monster_shared
		FirstVendor_OnGameTargetedByPlayer(player); // help/first_vendor
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(1.0f, "Olof_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Olof_FirstThink();
		Olof_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseChat_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseNpcVendorConfirm_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "calm_down") { OnCalmDown(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "check_player_status") { OnCheckPlayerStatus(EntityParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "closetskel") { OnClosetskel(); return true; }
		if (name == "do_screaming") { OnDoScreaming(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "give_store") { OnGiveStore(); return true; }
		if (name == "give_sword") { OnGiveSword(); return true; }
		if (name == "got_ring") { OnGotRing(PlayerParam(params, 0)); return true; }
		if (name == "got_ring2") { OnGotRing2(); return true; }
		if (name == "not_my_ring") { OnNotMyRing(); return true; }
		if (name == "not_my_ring2") { OnNotMyRing2(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_curse") { OnSayCurse(PlayerParam(params, 0)); return true; }
		if (name == "say_curse2") { OnSayCurse2(); return true; }
		if (name == "say_curse3") { OnSayCurse3(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_no") { OnSayNo(PlayerParam(params, 0)); return true; }
		if (name == "say_no2") { OnSayNo2(); return true; }
		if (name == "say_yes") { OnSayYes(PlayerParam(params, 0)); return true; }
		if (name == "second_ring") { OnSecondRing(); return true; }
		if (name == "second_ring2") { OnSecondRing2(); return true; }
		if (name == "second_ring3") { OnSecondRing3(); return true; }
		if (name == "start_screaming") { OnStartScreaming(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		if (name == "verify_friendly") { OnVerifyFriendly(EntityParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "Olof_Timer") { Olof_Timer(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
