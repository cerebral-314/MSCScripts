#pragma context server

// Converted from NPCs/forsuth.script by msc_transpiler.
// Forsuth - the frosted dwarf, from gatecity./mayor by thothie

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"
#include "converted/monsters/base_npc_vendor.as"

[script "NPCs/forsuth"]
class NPCsForsuth : BaseMonsterScript, BaseNpcVendor, FirstVendor
{
	// Constants
	string SOUND_SWING = "weapons/swingsmall.wav";
	string ATTACK_DAMAGE = "30";
	string ATTACK_ACCURACY = "70%";
	bool STORE_RESTOCK = false;
	bool VENDOR_NOT_ON_USE = true;
	string STORE_NAME = "forsuths_store";
	bool STORE_SELLMENU = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "drink shop store cold ale bitter";
	float CHAT_SPEED = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool CAN_CHAT = false;
	Vector3 MY_START = Vector3();
	float ORC_STEP = 0.0f;
	float ICE_LORD_PLOT_STEP = 0.0f;
	float JOB_PLOT_STEP = 0.0f;
	string FACE_TARG = "FACE_TARG";
	bool INVITED = false;
	bool DID_HAIL = false;
	bool IN_CHAT = false;
	bool CLOSE_SHOP = false;
	bool DID_WARCRY = false;
	bool DID_PLAYER = false;
	bool NO_ROTATE = false;

	// Variables declared by included files, with the value they start with in this script
	NPCsForsuth()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "idle";
		ANIM_RUN = "idle";
	}

	// unnamed block (first think)
	void NPCsForsuth_FirstThink()
	{
		ATTACK_RANGE = 50.0f;
		ATTACK_HITRANGE = 100.0f;
		MONSTER_WIDTH = 32;
		NO_STUCK_CHECKS = "1";
		CHAT_SPEED = 5.0f;
		HUNT_AGRO = "0";

		ANIM_IDLE = "idle";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack";
		STORE_TRIGGERTEXT = "drink shop store cold ale bitter";

		CAN_HEAR = "0";
	}

	// npcatk_targetvalidate
	// ====== combat
	void NPCsForsuth_OnNpcatkTargetvalidate(string target = "")
	{
		if (!CanSee("enemy"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) < 200.0f))
			return;
		SetMoveDest(ENT_LASTSEEN, ATTACK_RANGE);
		SetMoveSpeed(1);

		CLOSE_SHOP = true;

		if (!DID_WARCRY)
		{
			DID_WARCRY = true;
			SayText("We'll be havin' none of that in here!");
			PlaySound(0, 10, "voices/ms_snow/forsuth/well_be_having.wav");
		}
	}

	// npcatk_targetvalidate
	void NPCsForsuth_OnNpcatkTargetvalidate_2(string target = "")
	{
		// ignore the stuff outside
		if (IS_HUNTING)
			return;
		if (!(RangeTo(target) > 100.0f))
			return;
		HUNT_LASTTARGET = "\xAFNONE\xAF";
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttack_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		if (!(RangeTo(ENT_LASTHEARD) < 100.0f))
			return;
		SetMoveDest(@EntityOf(ENT_LASTHEARD), 9999);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		NPCsForsuth_OnNpcatkTargetvalidate(target);
		NPCsForsuth_OnNpcatkTargetvalidate_2(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttack_OnMyTargetDied(offender); // monsters/base_npc_attack

		if (CanSee("enemy"))
			return;

		// playanim once nod
		SayText("There now, nice and peaceful again.");
		SetMoveDest(MY_START, 1);
		CLOSE_SHOP = false;
		PlaySound(0, 10, "voices/ms_snow/forsuth/there_now_nice.wav");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		ANIM_WALK = "idle";
		ANIM_RUN = "idle";

		SetHealth(200);
		SetGold(10);
		SetName("Forsuth, the Frosty");
		// ov 120
		SetWidth(32);
		SetHeight(72);
		SetHearingSensitivity(8);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("dwarf/male1.mdl");
		SetModelBody(0, 0); // 0-Elder 1-Youngin 2-Zombie
		SetModelBody(1, 1); // 0-Unarmed 1-smallaxe 2-battleaxe 3-bastardsword

		SetIdleAnim(ANIM_IDLE);

		SetMoveAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetMoveSpeed(0);
		SetHearingSensitivity(6);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "hey", "wuddup", "wassup", "j0");
		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_rumor", "rumour", "news", "happenings", "rumor", "icebone", "snow", "ice", "lord");
		CatchSpeech("npc_say_store", "drink", "shop", "store", "cold", "ale", "bitter");
		CatchSpeech("say_orcs", "marogar", "orcs");
		CatchSpeech("lor_lore", "malgoriand", "loridian", "Fate");
		CatchSpeech("debug_props", "debug");

		SetDamageTaken("cold", 0);

		CAN_CHAT = true;

		SetMenuAutoOpen(true);

		CallEventDelayed(1.0f, "get_pos");

		CallEventDelayed(1.0f, "watch_for_friends");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		MenuItem menuItem;
		menuItem.title = "Hail";
		menuItem.type = "callback";
		menuItem.callback = "say_hi";
		RegisterMenuItem(menuItem);

		if (!DID_HAIL)
			return;

		menuItem.title = "The Marogar?";
		menuItem.type = "callback";
		menuItem.callback = "say_orcs";
		RegisterMenuItem(menuItem);

		menuItem.title = "Ice Lord?";
		menuItem.type = "callback";
		menuItem.callback = "say_rumor";
		RegisterMenuItem(menuItem);

		menuItem.title = "Any jobs?";
		menuItem.type = "callback";
		menuItem.callback = "say_job";
		RegisterMenuItem(menuItem);
	}

	// vendor_offerstore
	// ====== shop
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor

		if (CLOSE_SHOP)
			return;
		if (IN_CHAT)
			return;

		SayText("What can I do ye for?");
		// playsound 0 10 SOUND_SERVICE
		NO_ROTATE = true;
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		CallEventDelayed(60.0f, "restore_rotate");
	}

	// debug_props
	void OnDebugProps()
	{
		SayText("Izhunting " + Text(IS_HUNTING));
	}

	// get_pos
	void OnGetPos()
	{
		MY_START = OriginOf(ENT_ME);
	}

	// reset_chat
	// ====== chat
	void OnResetChat()
	{
		if (IN_CHAT)
			CallEventDelayed(6.0f, "reset_chat");
		if (IN_CHAT)
			return;
		ORC_STEP = 0.0f;
		ICE_LORD_PLOT_STEP = 0.0f;
		JOB_PLOT_STEP = 0.0f;
	}

	// watch_for_friends
	void OnWatchForFriends()
	{
		if (INVITED)
			return;

		CallEventDelayed(5.0f, "watch_for_friends");

		if (!CanSee("ally"))
			return;

		FACE_TARG = EntityId(EntityOf(ENT_LASTSEEN));
		SetSayTextRange(2048);
		SayText("By Urdual's beard! Get in here where it's warm, ya young fool!");
		PlaySound(0, 10, "voices/ms_snow/forsuth/get_in_here.wav");
		INVITED = true;

		OnStartFacingTarg();
		CallEventDelayed(4.0f, "invite_in");
	}

	// start_facing_targ
	void OnStartFacingTarg()
	{
		CallEventDelayed(5.0f, "start_facing_targ");

		if (NO_ROTATE)
			return;
		SetMoveDest(FACE_TARG, 9999);
	}

	// invite_in
	void OnInviteIn()
	{
		SayText("That's better! You'll catch yer death of cold out there!");
		PlaySound(0, 10, "voices/ms_snow/forsuth/thats_better.wav");
		PlayAnim("critical", ANIM_IDLE);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		DID_HAIL = true;

		if (IsPlayer(ENT_LASTSPOKE))
			FACE_TARG = ENT_LASTSPOKE;

		// reset speeches
		OnResetChat();

		PlayAnim("once", "nod");
		// playsound 0 10 SOUND_INTRO
		if (IN_CHAT)
			return;
		IN_CHAT = true;
		SayText("Hello thar, they call me Frosty. Forsuth the Frosty.");
		PlaySound(0, 10, "voices/ms_snow/forsuth/hallo_thar.wav");
		CHAT_SPEED = 4.4f;
		CallEventDelayed(0.0f, Text(CHAT_SPEED));
	}

	// hailed2
	void OnHailed2()
	{
		SayText("Thar be all sorts of nasty things out in that thar cold.");
		PlaySound(0, 10, "voices/ms_snow/forsuth/there_be_all_sorts.wav");
		CHAT_SPEED = 3.8f;

		CallEventDelayed(0.0f, Text(CHAT_SPEED));
	}

	// hailed3
	void OnHailed3()
	{
		SayText("Didn't used to be this way though.");
		PlaySound(0, 10, "voices/ms_snow/forsuth/didnt_used_to_be.wav");
		CHAT_SPEED = 2.0f;

		CallEventDelayed(0.0f, Text(CHAT_SPEED));
	}

	// hailed4
	void OnHailed4()
	{
		SayText("Not until the [Ice Lord] woke up... And the [Marogar] ain't be helping much either.");
		PlaySound(0, 10, "voices/ms_snow/forsuth/not_until_the_ice_lord.wav");
		CHAT_SPEED = 4.5f;
		CallEventDelayed(0.0f, Text(CHAT_SPEED));
	}

	// hailed5
	void OnHailed5()
	{
		PlayAnim("critical", ANIM_IDLE);
		PlaySound(0, 10, "voices/ms_snow/forsuth/but_nevermind_that.wav");
		CHAT_SPEED = 3.8f;
		IN_CHAT = false;
		SayText("...but never mind ye that, I've got some things 'er that'll warm ya right up!");
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		if (IN_CHAT)
		{
			SayText("...Just a second, ask me about that when I'm done... Anyways... Where was I? Oh yes...");
			PlaySound(2, 10, "voices/ms_snow/forsuth/just_a_second.wav");
		}
		if (IN_CHAT)
			return;
		IN_CHAT = true;
		OnSayIcequeenLoop();
	}

	// say_icequeen_loop
	void OnSayIcequeenLoop()
	{
		if (IsPlayer(ENT_LASTSPOKE))
			FACE_TARG = ENT_LASTSPOKE;

		ICE_LORD_PLOT_STEP += 1.0f;
		if (ICE_LORD_PLOT_STEP == 1.0f)
		{
			PlayAnim("once", "nod");
			SayText("Well, truth be told, that thing, it's been here longer than I.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/well_truth_be.wav");
			CHAT_SPEED = 4.7f;
		}
		if (ICE_LORD_PLOT_STEP == 2.0f)
		{
			SayText("Longer than me folks too, who be long gone, and let it be known that I am a might older than you...");
			PlaySound(0, 10, "voices/ms_snow/forsuth/older_than_me_folks_too.wav");
			CHAT_SPEED = 6.3f;
		}
		if (ICE_LORD_PLOT_STEP == 3.0f)
		{
			SayText("But before that beast's arrival, you had to go quite a bit further north before it got cold.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/before_that_beasts_arrival.wav");
			CHAT_SPEED = 5.1f;
		}
		if (ICE_LORD_PLOT_STEP == 4.0f)
		{
			SayText("It's old, so very old, no one remembers its name - and it ain't tellin' neither.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/its_old_so_old.wav");
			CHAT_SPEED = 6.2f;
		}
		if (ICE_LORD_PLOT_STEP == 5.0f)
		{
			SayText("Legends been told that it was once a toy of the Loreldians' themselves, the masters of Fate.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/legends_have_been_told.wav");
			CHAT_SPEED = 6.1f;
		}
		if (ICE_LORD_PLOT_STEP == 6.0f)
		{
			PlayAnim("once", "nod");
			SayText("Now it plagues the livin' in retribution for its abandonment, or so it's said.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/now_it_plagues.wav");
			CHAT_SPEED = 5.1f;
		}
		if (ICE_LORD_PLOT_STEP == 7.0f)
		{
			SayText("We call it 'the Ice Bone Lord', but truth be told I know not whether it be lord or lady.. or somethin' else.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/we_call_it.wav");
			CHAT_SPEED = 7.5f;
		}
		if (ICE_LORD_PLOT_STEP == 8.0f)
		{
			SayText("Best be careful 'round these parts, lest you find yourselves face to face with it.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/best_be_careful.wav");
			CHAT_SPEED = 4.6f;
		}
		if (ICE_LORD_PLOT_STEP == 9.0f)
		{
			SayText("Thar's certainly no helpin' runnin into its creations.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/theres_certainly.wav");
			CHAT_SPEED = 3.5f;
		}
		if (ICE_LORD_PLOT_STEP == 10.0f)
		{
			SayText("But I shant complain, that's why I keep this shop here...");
			PlaySound(0, 10, "voices/ms_snow/forsuth/but_i_shant_complain.wav");
			CHAT_SPEED = 3.3f;
		}
		if (ICE_LORD_PLOT_STEP == 11.0f)
		{
			PlayAnim("critical", ANIM_IDLE);
			SayText("People need my wares just to survive in these parts!");
			PlaySound(0, 10, "voices/ms_snow/forsuth/people_need_my.wav");
			CHAT_SPEED = 3.4f;
			IN_CHAT = false;
		}

		if (ICE_LORD_PLOT_STEP < 11.0f)
			CallEventDelayed(CHAT_SPEED, "say_icequeen_loop");
		if (ICE_LORD_PLOT_STEP == 11.0f)
			ICE_LORD_PLOT_STEP = 0.0f;
	}

	// say_job
	void OnSayJob(CBasePlayer@ player = null)
	{
		if (IN_CHAT)
		{
			SayText("...Just a second, ask me about that when I'm done... Anyways... Where was I? Oh yes...");
			PlaySound(2, 10, "voices/ms_snow/forsuth/just_a_second.wav");
		}
		if (IN_CHAT)
			return;
		IN_CHAT = true;
		OnSayJobLoop();
	}

	// say_job_loop
	void OnSayJobLoop()
	{
		if (IsPlayer(ENT_LASTSPOKE))
			FACE_TARG = ENT_LASTSPOKE;

		JOB_PLOT_STEP += 1.0f;
		if (JOB_PLOT_STEP == 1.0f)
		{
			PlayAnim("once", "nod");
			SayText("Well, thar is one thing ye could do for me.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/well_theres_one.wav");
			CHAT_SPEED = 2.5f;
		}
		if (JOB_PLOT_STEP == 2.0f)
		{
			SayText("Out thar, in the colder parts, thar be some orcs. Talnorgah's boys, the [Marogar].");
			PlaySound(0, 10, "voices/ms_snow/forsuth/out_there_there.wav");
			CHAT_SPEED = 4.2f;
		}
		if (JOB_PLOT_STEP == 3.0f)
		{
			SayText("The stronger of em get have these beautiful ice blades.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/the_stronger_ones.wav");
			CHAT_SPEED = 4.0f;
		}
		if (JOB_PLOT_STEP == 4.0f)
		{
			SayText("They aren't nuthin' too fancy - I can't sell the really good ones...");
			PlaySound(0, 10, "voices/ms_snow/forsuth/they_aint.wav");
			CHAT_SPEED = 3.4f;
		}
		if (JOB_PLOT_STEP == 5.0f)
		{
			SayText("But these orc'ish ones - they sell like hotcakes when I visit Deralia, I'll tell ya that.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/but_these_orcish_ones.wav");
			CHAT_SPEED = 5.1f;
		}
		if (JOB_PLOT_STEP == 6.0f)
		{
			SayText("Bring some to me, and I'll give you a fair shake for em.");
			PlayAnim("critical", ANIM_IDLE);
			PlaySound(0, 10, "voices/ms_snow/forsuth/bring_some_to_me.wav");
			CHAT_SPEED = 3.1f;
			IN_CHAT = false;
		}

		if (JOB_PLOT_STEP < 6.0f)
			CallEventDelayed(CHAT_SPEED, "say_job_loop");
		if (JOB_PLOT_STEP == 6.0f)
			JOB_PLOT_STEP = 0.0f;
	}

	// say_orcs
	void OnSayOrcs()
	{
		if (IN_CHAT)
		{
			SayText("...Just a second, ask me about that when I'm done... Anyways... Where was I? Oh yes...");
			PlaySound(2, 10, "voices/ms_snow/forsuth/just_a_second.wav");
		}
		if (IN_CHAT)
			return;
		IN_CHAT = true;
		OnSayOrcLoop();
	}

	// say_orc_loop
	void OnSayOrcLoop()
	{
		if (IsPlayer(ENT_LASTSPOKE))
			FACE_TARG = ENT_LASTSPOKE;

		ORC_STEP += 1.0f;
		if (ORC_STEP == 1.0f)
		{
			PlayAnim("once", "nod");
			SayText("Ya look like ye are from down south, so let me warn ye...");
			PlaySound(0, 10, "voices/ms_snow/forsuth/you_look_like.wav");
			CHAT_SPEED = 3.2f;
		}
		if (ORC_STEP == 2.0f)
		{
			SayText("The orcs here, are not like the orcs where ye come from, these are the Marogar tribe.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/these_orcs_here.wav");
			CHAT_SPEED = 4.9f;
		}
		if (ORC_STEP == 3.0f)
		{
			SayText("When Lor Malgoriand setup, it was cold, so these were his first... Not the worst, but still the first.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/when_lor.wav");
			CHAT_SPEED = 6.6f;
		}
		if (ORC_STEP == 4.0f)
		{
			SayText("They dun like the heat, and they certainly dun like fire.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/they_dont_like_heat.wav");
			CHAT_SPEED = 3.1f;
		}
		if (ORC_STEP == 5.0f)
		{
			SayText("Ya can usually keep em at bay with it.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/you_can_usually.wav");
			CHAT_SPEED = 2.2f;
		}
		if (ORC_STEP == 6.0f)
		{
			SayText("Still, they've got shamans, and some good warriors.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/still_theyve.wav");
			CHAT_SPEED = 3.2f;
		}
		if (ORC_STEP == 7.0f)
		{
			SayText("Their chief, Talnorgah, is a beast indeed. Slow, but strong.");
			PlaySound(0, 10, "voices/ms_snow/forsuth/their_chief_talnorgah.wav");
			CHAT_SPEED = 5.1f;
		}
		if (ORC_STEP == 8.0f)
		{
			SayText("Word has it that he's waitin' on the return of Lor Malgoriand himself!");
			PlaySound(0, 10, "voices/ms_snow/forsuth/word_has_it.wav");
			CHAT_SPEED = 4.4f;
		}
		if (ORC_STEP == 9.0f)
		{
			SayText("So my advice to you is, if ya see him, keep running!");
			PlaySound(0, 10, "voices/ms_snow/forsuth/so_my_advice.wav");
			CHAT_SPEED = 4.4f;
			PlayAnim("critical", ANIM_IDLE);
			IN_CHAT = false;
		}

		if (ORC_STEP < 9.0f)
			CallEventDelayed(CHAT_SPEED, "say_orc_loop");
		if (ORC_STEP == 9.0f)
			ORC_STEP = 0.0f;
	}

	// lor_lore
	void OnLorLore()
	{
		if (IN_CHAT)
		{
			SayText("...Just a second, ask me about that when I'm done... Anyways... Where was I? Oh yes...");
			PlaySound(2, 10, "voices/ms_snow/forsuth/just_a_second.wav");
		}
		if (IN_CHAT)
			return;
		SayText("Hmmm... Already said too much about that. Better to ask a priest, for all I know of gods and demons.");
		PlaySound(0, 10, "voices/ms_snow/forsuth/ive_already_said.wav");
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";

		SetMoveSpeed(1);
		CLOSE_SHOP = true;
		SetMoveAnim(ANIM_RUN);

		if (!IsPlayer(ENT_LASTSTRUCK))
			return;

		if (!DID_PLAYER)
		{
			DID_PLAYER = true;
			SetRace("hguard");
			SayText("Argh! " + NameOf(ENT_LASTSTRUCK) + " ! Yer no better than the orcs!");
			HUNT_LASTTARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
			PlaySound(0, 10, "voices/ms_snow/forsuth/gah_youre_no_better.wav");
		}
	}

	// attack_1
	// called by modelanim attack @frame 6
	void OnAttack12()
	{
		PlaySound(0, 10, SOUND_SWING);
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|
		AddStoreItem(STORE_NAME, "drink_mead", 20, 100, 2.0f);
		AddStoreItem(STORE_NAME, "drink_ale", 20, 100, 2.0f);
		AddStoreItem(STORE_NAME, "drink_wine", 0, 100, 2.0f);
		AddStoreItem(STORE_NAME, "drink_forsuth", 10, 100, 0);
		AddStoreItem(STORE_NAME, "swords_liceblade", 1, 400, 0.5f);
		AddStoreItem(STORE_NAME, "swords_iceblade", 0, 150, 0.2f);
		AddStoreItem(STORE_NAME, "mana_resist_cold", 5, 150, 0);
		AddStoreItem(STORE_NAME, "mana_immune_cold", 1, 150, 0);
		AddStoreItem(STORE_NAME, "mana_mpotion", 1, 300, 0);
		AddStoreItem(STORE_NAME, "item_crystal_reloc", 5, 300, 0);
		AddStoreItem(STORE_NAME, "item_crystal_return", 10, 300, 0);
		AddStoreItem(STORE_NAME, "health_spotion", 1, 200, 0);
		AddStoreItem(STORE_NAME, "health_mpotion", 1, 200, 0);
		AddStoreItem(STORE_NAME, "scroll2_frost_xolt", 1, 400, 0);
		AddStoreItem(STORE_NAME, "sheath_spellbook", 1, 150, 0);
		AddStoreItem(STORE_NAME, "proj_arrow_fire", 180, 400, 0, 60);
		AddStoreItem(STORE_NAME, "item_torch", 180, 800, 0);
	}

	// restore_rotate
	void OnRestoreRotate()
	{
		NO_ROTATE = false;
	}

	// npcatk_faceattacker
	// PARAM1: Entity to face
	void OnNpcatkFaceattacker(string target = "")
	{
		if (IS_FLEEING)
			return;
		if (!IS_HUNTING)
			return;

		SetMoveDest(@EntityOf(target), 9999);
		Look(1024);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_attack
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
	}

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		BaseMonsterShared_OnGameTargetedByPlayer(player); // monsters/base_monster_shared
		FirstVendor_OnGameTargetedByPlayer(player); // help/first_vendor
	}

	void OnChatSpeed() {} // CHAT_SPEED

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("dwarf/male1.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
		CallEventDelayed(5.0f, "start_facing_targ");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		NPCsForsuth_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "debug_props") { OnDebugProps(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "get_pos") { OnGetPos(); return true; }
		if (name == "hailed2") { OnHailed2(); return true; }
		if (name == "hailed3") { OnHailed3(); return true; }
		if (name == "hailed4") { OnHailed4(); return true; }
		if (name == "hailed5") { OnHailed5(); return true; }
		if (name == "invite_in") { OnInviteIn(); return true; }
		if (name == "lor_lore") { OnLorLore(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_faceattacker") { OnNpcatkFaceattacker(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_chat") { OnResetChat(); return true; }
		if (name == "restore_rotate") { OnRestoreRotate(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_icequeen_loop") { OnSayIcequeenLoop(); return true; }
		if (name == "say_job") { OnSayJob(PlayerParam(params, 0)); return true; }
		if (name == "say_job_loop") { OnSayJobLoop(); return true; }
		if (name == "say_orc_loop") { OnSayOrcLoop(); return true; }
		if (name == "say_orcs") { OnSayOrcs(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "start_facing_targ") { OnStartFacingTarg(); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "vendor_offerstore") { OnVendorOfferstore(PlayerParam(params, 0)); return true; }
		if (name == "watch_for_friends") { OnWatchForFriends(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
