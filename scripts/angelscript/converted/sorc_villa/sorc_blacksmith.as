#pragma context server

// Converted from sorc_villa/sorc_blacksmith.script by msc_transpiler.
// probably best to make hostile a seperate script, use a manager script to deal with the monster spawns accross the villa
// forge ideas:
// (polearms)
// (some helms, some armor mods)
// (store items)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_chat.as"

[script "sorc_villa/sorc_blacksmith"]
class SorcBlacksmith : BaseNpcScript, BaseNpcVendor, FirstVendor, BaseChat
{
	// Constants
	string ANIM_HAMMER = "hammering";
	string ANIM_YES = "nod_yes";
	int SMITH_GOLD_REQ = 50000;
	bool VENDOR_MENU_OFF = true;
	bool VENDOR_NOT_ON_USE = true;
	bool NO_JOB = true;
	bool NO_HAIL = true;
	bool NO_RUMOR = true;
	bool CHAT_USE_CONV_ANIMS = false;
	bool NO_CLOSE_MOUTH = true;
	string BUSY_COMMENT = "Patients little pink one... Busy with this other wee one right now.";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle1";
	string STORE_NAME = "STORE_NAME";
	bool AM_HAMMERING = false;
	string MENU_TYPE = "MENU_TYPE";
	float HAMMER_YAW = 0.0f;
	int DID_INTRO = 0;
	string CHAT_STEP1 = "CHAT_STEP1";
	string CHAT_STEP2 = "CHAT_STEP2";
	string CHAT_STEP3 = "CHAT_STEP3";
	string CHAT_STEP4 = "CHAT_STEP4";
	string ANIM_STEP4 = "ANIM_STEP4";
	string CHAT_STEP5 = "CHAT_STEP5";
	int CHAT_STEPS = 0;
	float RESUME_HAMMERING = 0.0f;
	CBaseEntity@ FORGE_MENU_TARGET = null;
	string ANIM_STEP3 = "ANIM_STEP3";
	string CHAT_EVENT_STEP4 = "CHAT_EVENT_STEP4";
	string CHAT_EVENT_STEP2 = "CHAT_EVENT_STEP2";
	CBaseEntity@ LAST_PLAYER_FORGE_ID = null;
	string QUEST_CAT_DATA = "QUEST_CAT_DATA";
	float FINAL_GOLD_REQ = 0.0f;
	CBasePlayer@ SMITH_CUSTOMER = null;
	string SMITH_TYPE = "SMITH_TYPE";
	string SMITH_CL_TYPE = "SMITH_CL_TYPE";
	string SMITH_REQ = "SMITH_REQ";
	string CHAT_EVENT_STEP5 = "CHAT_EVENT_STEP5";
	string CHAT_STEP6 = "CHAT_STEP6";
	string CHAT_EVENT_STEP6 = "CHAT_EVENT_STEP6";
	CBaseEntity@ BLACKSMITH_FX_ID = null;

	// unnamed block (first think)
	void SorcBlacksmith_FirstThink()
	{
		ANIM_IDLE = "idle1";
	}

	// unnamed block (first think)
	void SorcBlacksmith_FirstThink2()
	{
		STORE_NAME = "sorc_blacksmith";
	}

	// unnamed block (timer)
	void SorcBlacksmith_Timer()
	{
		CallEventDelayed(10.0f, "SorcBlacksmith_Timer");
		// hammah loop
		if (!(GameTime() > RESUME_HAMMERING))
			return;
		SetAngle("face", Vector3(0, HAMMER_YAW, 0));
		if (AM_HAMMERING)
			return;
		OnStartHammering();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetName("Irunthar");
		SetModel("monsters/sorc.mdl");
		SetHealth(8000);
		SetDamageTaken("all", 0.5f);
		SetStat("parry", 110);
		SetRace("beloved");
		SetInvincible(true);
		PLAYING_DEAD = "1";

		SetNoPush(true);

		SetWidth(32);
		SetHeight(96);

		SetModelBody(0, 4); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer 4=Rust(%%add)
		SetModelBody(1, 0); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 10); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker 10=meat 11=hammah 12=drink

		CatchSpeech("say_forge", "forg");
		CatchSpeech("say_shop", "shop", "wares");

		AM_HAMMERING = true;
		MENU_TYPE = "normal";
		SetIdleAnim(ANIM_HAMMER);
		SetMoveAnim(ANIM_HAMMER);

		SetMenuAutoOpen(true);

		CallEventDelayed(0.1f, "get_yaw");

		OnNpcatkSuspendAi();
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		MenuItem menuItem;

		if (MENU_TYPE == "normal")
		{
			menuItem.title = "Hail";
			menuItem.type = "callback";
			menuItem.callback = "say_hi";
			RegisterMenuItem(menuItem);

			menuItem.title = "Browse Wares";
			menuItem.type = "callback";
			menuItem.callback = "vendor_offerstore";
			RegisterMenuItem(menuItem);

			menuItem.title = "Forge Item";
			menuItem.type = "callback";
			menuItem.callback = "say_forge";
			RegisterMenuItem(menuItem);

			menuItem.title = "Ask about Rumors";
			menuItem.type = "callback";
			menuItem.callback = "say_rumor";
			RegisterMenuItem(menuItem);

			if (Truthy(ItemExists(player, "smallarms_rd")))
			{
				menuItem.title = "Ask about rusty dagger";
				menuItem.type = "callback";
				menuItem.callback = "say_rdagger_excuse";
				RegisterMenuItem(menuItem);
			}
		}

		if (MENU_TYPE == "forge_type")
		{
			menuItem.title = "Weapons";
			menuItem.type = "callback";
			menuItem.callback = "say_forge_weapons";
			RegisterMenuItem(menuItem);
		}

		// Pending
		// local reg.mitem.title 	"Armor"
		// local reg.mitem.type 	callback
		// local reg.mitem.callback say_forge_armor
		// menuitem.register
		// local reg.mitem.title 	"Other"
		// local reg.mitem.type 	callback
		// local reg.mitem.callback say_forge_other
		// menuitem.register
		if (MENU_TYPE == "forge_weapon")
		{
			menuItem.title = "Shadowfire Blade";
			menuItem.type = "callback";
			menuItem.callback = "say_swords_sf";
			RegisterMenuItem(menuItem);

			// axed this axe
			// local reg.mitem.title 	"Shadowfire Axe"
			// local reg.mitem.type 	callback
			// local reg.mitem.callback say_axes_sf
			// menuitem.register
			menuItem.title = "Winter Cleaver";
			menuItem.type = "callback";
			menuItem.callback = "say_axes_df";
			RegisterMenuItem(menuItem);

			menuItem.title = "Unholy Blade";
			menuItem.type = "callback";
			menuItem.callback = "say_swords_ub";
			RegisterMenuItem(menuItem);

			menuItem.title = "Skull Scythe";
			menuItem.type = "callback";
			menuItem.callback = "say_axes_ss";
			RegisterMenuItem(menuItem);

			menuItem.title = "Vorpal Tongue";
			menuItem.type = "callback";
			menuItem.callback = "say_smallarms_vt";
			RegisterMenuItem(menuItem);

			menuItem.title = "Demon Bludgeon Hammer";
			menuItem.type = "callback";
			menuItem.callback = "say_blunt_db";
			RegisterMenuItem(menuItem);

			menuItem.title = "Infernal Claws";
			menuItem.type = "callback";
			menuItem.callback = "say_blunt_gauntlet_ic";
			RegisterMenuItem(menuItem);
		}

		// local reg.mitem.title 	"Shaddahar Prong"
		// local reg.mitem.type 	callback
		// local reg.mitem.callback say_pole_sp
		// menuitem.register
		// (ten max, can add one more)
		if (MENU_TYPE == "smith_confirm")
		{
			menuItem.title = "Yes";
			menuItem.type = "payment";
			menuItem.data = SMITH_REQ;
			menuItem.callback = "do_smithing";
			menuItem.cb_failed = "smithing_fail_payment";
			RegisterMenuItem(menuItem);

			menuItem.title = "No";
			menuItem.type = "callback";
			menuItem.callback = "smithing_cancel";
			RegisterMenuItem(menuItem);
		}
	}

	// say_rumor
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat
		if (BUSY_CHATTING)
			return;
		CHAT_STEP1 = "I hear that Runegahr and Thuldahr have been going at it again...";
		CHAT_STEP2 = "Thuldahr doesn't likes Runegahr's plans, being nice to the humans and all. Letting em keeps a village so close.";
		CHAT_STEP3 = "I tries not to thinks about politics much though. Too much smithings to doos.";
		CHAT_STEPS = 3;
		OnChatLoop();
	}

	// get_yaw
	void OnGetYaw()
	{
		HAMMER_YAW = AnglesOf(ENT_ME).y;
	}

	// say_shop
	void OnSayShop()
	{
		if (MENU_TYPE != "normal")
			return;
		OnVendorOfferstore(ToPlayer(EntityOf(ENT_LASTSPOKE)));
	}

	// smithing_cancel
	void OnSmithingCancel()
	{
		MENU_TYPE = "normal";
		SetMenuAutoOpen(true);
		SayText("Very well then, perhaps meez can interest you in something else?");
		CallEventDelayed(1.0f, "start_hammering");
	}

	// smithing_fail_payment
	void OnSmithingFailPayment()
	{
		MENU_TYPE = "normal";
		SetMenuAutoOpen(true);
		SayText("Bah, come back when yoos has the gold and ingredients I need.");
		CallEventDelayed(1.0f, "start_hammering");
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		MENU_TYPE = "normal";
		SetMenuAutoOpen(true);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		CBaseEntity@ currentSpeaker = null;
		if (BUSY_CHATTING)
			return;
		OnStopHammering();

		if (IsPlayer(talkingPlayer))
			@currentSpeaker = talkingPlayer;
		else
			@currentSpeaker = EntityOf(ENT_LASTSPOKE);
		OnFaceSpeaker(EntityId(currentSpeaker));

		if (DID_INTRO == 0)
		{
			DID_INTRO = 1;
			CHAT_STEP1 = "Hail! If it isn't our honored guests!";
			CHAT_STEP2 = "And what pretty shinies they bring!";
			CHAT_STEP3 = "We don't often see humans with pretty shinies in the villa - not breathing humans, anyways.";
			CHAT_STEP4 = "And meez must say, not often with so many pretty shinies either!";
			ANIM_STEP4 = ANIM_YES;
			CHAT_STEP5 = "Come, take a look at my wares. Maybe we can also work out a deal for use of the services of meez [forge]!";
			CHAT_STEPS = 5;
			OnChatLoop();
		}
		else
		{
			SayText("Back again? Perhaps yoos want more of my wares, or perhaps meez [forging] something new for yas.");
			PlayAnim("critical", ANIM_YES);
		}
	}

	// stop_hammering
	void OnStopHammering()
	{
		AM_HAMMERING = false;
		RESUME_HAMMERING = GameTime() + 50.0f;
		PlayAnim("break");
		PlayAnim("critical", ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);
	}

	// start_hammering
	void OnStartHammering()
	{
		AM_HAMMERING = true;
		SetAngle("face", Vector3(0, HAMMER_YAW, 0));

		SetIdleAnim(ANIM_HAMMER);
		SetMoveAnim(ANIM_HAMMER);
		PlayAnim("critical", ANIM_HAMMER);
	}

	// say_forge
	void OnSayForge(CBasePlayer@ speaker = null)
	{
		CBaseEntity@ currentSpeaker = null;

		if (BUSY_CHATTING)
			return;

		if (AM_HAMMERING)
			OnStopHammering();

		if (IsPlayer(speaker))
			@currentSpeaker = speaker;
		else
			@currentSpeaker = EntityOf(ENT_LASTSPOKE);
		OnFaceSpeaker(EntityId(currentSpeaker));

		@FORGE_MENU_TARGET = currentSpeaker;

		CHAT_STEP1 = "Well, well, well... My forging services are not for the faint of heart, nor the faint of coin...";
		if (LAST_PLAYER_FORGE_ID !is currentSpeaker)
		{
			CHAT_STEP2 = "But fear not, I'll not beez chargein yas anymores than I charges anyones elses.";
			CHAT_STEP3 = "Unlike some of my brothers, I care not of the color of my customer's skin - only of that of their coin! Hahaha!";
			ANIM_STEP3 = ANIM_YES;
			CHAT_STEP4 = "What mighty smithing feat doos yous wants to sees meez performs?";
			CHAT_EVENT_STEP4 = "give_forge_menu";
			MENU_TYPE = "forge_type";
			CHAT_STEPS = 4;
			OnChatLoop();
		}
		else
		{
			CHAT_STEP2 = "What mighty smithing feat doos yous wants to sees meez performs?";
			CHAT_EVENT_STEP2 = "give_forge_menu";
			MENU_TYPE = "forge_type";
			CHAT_STEPS = 2;
			OnChatLoop();
		}

		@LAST_PLAYER_FORGE_ID = currentSpeaker;
	}

	// give_forge_menu
	void OnGiveForgeMenu()
	{
		OpenMenu(FORGE_MENU_TARGET);
	}

	// say_forge_weapons
	void OnSayForgeWeapons(CBasePlayer@ target = null)
	{
		SayText("And which of my mighty shinies might yeez beez wanting to knows of?");
		@FORGE_MENU_TARGET = target;
		MENU_TYPE = "forge_weapon";
		CallEventDelayed(0.1f, "give_forge_menu");
	}

	// smith_confirm
	void OnSmithConfirm()
	{
		MENU_TYPE = "smith_confirm";
		OpenMenu(SMITH_CUSTOMER);
	}

	// do_smithing
	void OnDoSmithing()
	{
		MENU_TYPE = "suspend";
		OnStartHammering();
		CHAT_STEP1 = "Alright then! Just a moment while I put da magic hammer to works...";
		CHAT_STEP2 = "Here we go...";
		CHAT_STEP3 = "There, alls done.";
		CHAT_STEPS = 3;
		OnChatLoop();

		CallEventDelayed(2.0f, "smithing_cl_effects");
		CallEventDelayed(8.0f, "smith_finalize");
	}

	// smith_finalize
	void OnSmithFinalize()
	{
		MENU_TYPE = "normal";
		OnFaceSpeaker(EntityId(SMITH_CUSTOMER));
		Offer(SMITH_CUSTOMER, SMITH_TYPE);
		if (SMITH_TYPE == "swords_ub")
		{
			int questIdx = FindToken(QUEST_CAT_DATA, "sym1");
			if (questIdx > -1)
				QUEST_CAT_DATA = TokenRemove(QUEST_CAT_DATA, questIdx);
			questIdx = FindToken(QUEST_CAT_DATA, "sym2");
			if (questIdx > -1)
				QUEST_CAT_DATA = TokenRemove(QUEST_CAT_DATA, questIdx);
			questIdx = FindToken(QUEST_CAT_DATA, "sym3");
			if (questIdx > -1)
				QUEST_CAT_DATA = TokenRemove(QUEST_CAT_DATA, questIdx);
			questIdx = FindToken(QUEST_CAT_DATA, "sym4");
			if (questIdx > -1)
				QUEST_CAT_DATA = TokenRemove(QUEST_CAT_DATA, questIdx);
			questIdx = FindToken(QUEST_CAT_DATA, "sym5");
			if (questIdx > -1)
				QUEST_CAT_DATA = TokenRemove(QUEST_CAT_DATA, questIdx);
			Quest("set", SMITH_CUSTOMER, "f", QUEST_CAT_DATA);
		}
		SetMenuAutoOpen(true);
	}

	// say_swords_sf
	void OnSaySwordsSf(CBasePlayer@ customer = null)
	{
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 1.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "The Shadowfire Blade has the dark energy of the Blood Drinker, and new enhanced fire storms and stuffs.";
		CHAT_STEP2 = "To forge it, I needs a Blood Drinker, a Nova Blade, and three Fire Tomahawks.";
		CHAT_STEP3 = "I also charge a workmanship fee of " + Text(FINAL_GOLD_REQ) + " gold.";
		CHAT_STEP4 = "Do you wish meez to attempt this smithing feat for yoos?";
		CHAT_EVENT_STEP4 = "say_smith_confirm";
		CHAT_STEPS = 4;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "swords_sf";
		SMITH_CL_TYPE = "dark;fire";
		SMITH_REQ = "swords_blood_drinker;swords_novablade12;axes_tf:3;gold:" + Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_axes_df
	// { say_axes_sf
	// setvard FINAL_GOLD_REQ SMITH_GOLD_REQ
	// local SMITH_RATIO 0.75
	// multiply FINAL_GOLD_REQ SMITH_RATIO
	// setvard FINAL_GOLD_REQ $int(FINAL_GOLD_REQ)
	// setvard CHAT_STEP1 "For the Shadowfire Axe, We takes the light folded steel of the Torkalath for balance, and the fire-forge metals of the Tomahawks, coupled with some dark magics..."
	// setvard CHAT_STEP2 "So, I needs three good fire Tomahawks and two Torkalath Shortswords to whip one up."
	// setvard CHAT_STEP3 "I also charge a workmanship fee of "
	// stradd CHAT_STEP3 FINAL_GOLD_REQ
	// stradd CHAT_STEP3 " gold."
	// setvard CHAT_STEP4 "Do you wish meez to attempt this smithing feat for yoos?"
	// setvard CHAT_EVENT_STEP4 say_smith_confirm
	// setvard CHAT_STEPS 4
	// menu.autoopen 0 //lock menu until after confirm
	// setvard SMITH_CUSTOMER PARAM1
	// setvard SMITH_TYPE axes_sf
	// setvard SMITH_CL_TYPE "dark;fire"
	// setvard SMITH_REQ "swords_katana4:2;axes_tf:3;gold:"
	// stradd SMITH_REQ FINAL_GOLD_REQ
	// callevent chat_loop
	// local MENU_DELAY CHAT_STEPS
	// multiply MENU_DELAY CHAT_DELAY
	// callevent MENU_DELAY smith_confirm
	// }
	void OnSayAxesDf(CBasePlayer@ customer = null)
	{
		// 2xColdTomahawk + 2xTorkalathBlade = Winter Cleaver (Cold Dmg, balanced, 100% cold DOT, freeze burst)
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 1.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "For the Wintercleaver axe, we take the ice-metal of the Tomahawks and balance the beast with the Torkalath steel.";
		CHAT_STEP2 = "This makes for a beast of an axe that can create icy storms, yet is still light enough for humans to easily land blows with.";
		CHAT_STEP3 = "So, I needs two ice Tomahawks and two Torkalath Shortswords to slam one together.";
		CHAT_STEP4 = "I also charge a workmanship fee of " + Text(FINAL_GOLD_REQ) + " gold.";
		CHAT_STEP5 = "Do you wish meez to attempt this smithing feat for yoos?";
		CHAT_EVENT_STEP5 = "say_smith_confirm";
		CHAT_STEPS = 5;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "axes_df";
		SMITH_CL_TYPE = "ice";
		SMITH_REQ = "swords_katana4:2;axes_ti:2;gold:" + Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_swords_ub
	void OnSaySwordsUb(CBasePlayer@ customer = null)
	{
		// 5xFelewynBlade + 2xBlood Drinker = Unholy Blade (Dark dmg, vampyric, repell aura)
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 2.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "Ah, the Unholy Blade... I've been wanting to make one of these for a long time now!";
		CHAT_STEP2 = "Sadly, no one seems to be able to bring me the materials I need. Namely, five seperate shards of the legendary Felewyn Blade.";
		CHAT_STEP3 = "On top of that, I'll need two Blood Drinkers. Oh, but what a beast this sword will be...";
		CHAT_STEP4 = "I also charge a workmanship fee of " + Text(FINAL_GOLD_REQ) + " gold.";
		CHAT_STEP5 = "Do you wish meez to attempt this smithing feat for yoos?";
		CHAT_EVENT_STEP5 = "say_smith_confirm";
		CHAT_STEPS = 5;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "swords_ub";
		SMITH_CL_TYPE = "dark";
		SMITH_REQ = "swords_fshard1;swords_fshard2;swords_fshard3;swords_fshard4;swords_fshard5;swords_blood_drinker:2;gold:";
		SMITH_REQ += Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_blunt_db
	void OnSayBluntDb(CBasePlayer@ customer = null)
	{
		// Bludgeon Hammer + TorkalathBlade + 2xFire Tomahawk = Demon Bludgeon Hammer (Bludgeon Hammer + FireDOT 100%, +Accuracy%)
		// special event: Bludgeon summons forth - must be defeated before he'll give you the weapon
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 0.5f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "Ah, now this be pretty simple: we take the fire magic from two Tomahawks, two dark Tomahawks,";
		CHAT_STEP2 = "and two shortswords worth of Torkalath steel to hold it all together with. We work this all into your Bludgeon Hammer.";
		CHAT_STEP3 = "Only sticky bit is keeping the Bludgeon soul locked in there during the whole process.";
		CHAT_STEP4 = "I also charge a workmanship fee of " + Text(FINAL_GOLD_REQ) + " gold.";
		CHAT_STEP5 = "Do you wish meez to attempt this smithing feat for yoos?";
		CHAT_EVENT_STEP5 = "say_smith_confirm";
		CHAT_STEPS = 5;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "blunt_db";
		SMITH_CL_TYPE = "fire";
		SMITH_REQ = "axes_tf:2;axes_td:2;swords_katana4:2;blunt_mithral;gold:" + Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_axes_ss
	void OnSayAxesSs(CBasePlayer@ customer = null)
	{
		// 2xDarkTomahawk + 2xBloodAxe + x2TorkalathBlade = Skull Scythe (Vampyric + Dark + Range + Balance + Throw)
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 2.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "The Skull Scythe. Inspired by the Torkalath Scythe. It may even make a worthy sacrifice to the Father of Chaos himself!";
		CHAT_STEP2 = "This sweeping axe blade can lop off heads at a fair distance, drink the blood of your enemies, yet is light enough to throw.";
		CHAT_STEP3 = "To forge one, I need two dark tomahawks, two balanced axes, and two Torkalath short swords.... And one petrified human head.";
		CHAT_STEP4 = "Eh... Don't worry about the head... I got one... or three... I'll throw one in free of charge.";
		CHAT_STEP5 = "The workmanship fee comes to " + Text(FINAL_GOLD_REQ) + " gold.";
		CHAT_STEP6 = "Do you wish meez to attempt this smithing feat for yoos?";
		CHAT_EVENT_STEP6 = "say_smith_confirm";
		CHAT_STEPS = 6;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "axes_ss";
		SMITH_CL_TYPE = "dark";
		SMITH_REQ = "axes_b:2;swords_katana4:2;axes_td:2;gold:" + Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_smallarms_vt
	void OnSaySmallarmsVt(CBasePlayer@ customer = null)
	{
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 2.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "Ah, the Vorpal Tongue, not had a chance to make one of these in a long time.";
		CHAT_STEP2 = "I'd need an ethereal dagger, two actually, and really no one knows how to properly forge those anymore.";
		CHAT_STEP3 = "Then two Efreeti hearts, and Efreeti are very rare, for there aren't many wizards left who know how to make those either.";
		CHAT_STEP4 = "Combine all that with a pair of litchtounges, and we have a rare weapon indeed.";
		CHAT_STEP5 = "One capable of holding the magic of two elements: fire and ice, in one blade, thanks to the ethereal metal.";
		CHAT_STEP6 = "Price comes to " + Text(FINAL_GOLD_REQ);
		CHAT_STEP6 += " gold. I'll I have a go at it, should you have the ingredients.";
		CHAT_EVENT_STEP6 = "say_smith_confirm";
		CHAT_STEPS = 6;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "smallarms_vt";
		SMITH_CL_TYPE = "fire;ice";
		SMITH_REQ = "item_eh:2;smallarms_eth:2;smallarms_frozentongueonflagpole:2;gold:";
		SMITH_REQ += Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// say_blunt_gauntlet_ic
	void OnSayBluntGauntletIc(CBasePlayer@ customer = null)
	{
		FINAL_GOLD_REQ = SMITH_GOLD_REQ;
		float smithRatio = 1.0f;
		FINAL_GOLD_REQ *= smithRatio;
		FINAL_GOLD_REQ = int(FINAL_GOLD_REQ);

		CHAT_STEP1 = "Infernal claws. Vicious little things. A bit delicate for orc hands, but fine for the likes of yoos.";
		CHAT_STEP2 = "Pretty simple formula. Three fire Tomahawks, and two pair demon claws.";
		CHAT_STEP3 = "Final result is a set of claws coupled with various fire enchantments.";
		CHAT_STEP4 = "Price comes to " + Text(FINAL_GOLD_REQ);
		CHAT_STEP4 += " gold. I'll I have a go at it, should you have the ingredients.";
		CHAT_EVENT_STEP6 = "say_smith_confirm";
		CHAT_STEPS = 4;
		SetMenuAutoOpen(false); // lock menu until after confirm

		@SMITH_CUSTOMER = customer;

		SMITH_TYPE = "blunt_gauntlets_ic";
		SMITH_CL_TYPE = "fire";
		SMITH_REQ = "blunt_gauntlets_demon:2;axes_tf:3;gold:" + Text(FINAL_GOLD_REQ);

		OnChatLoop();

		float menuDelay = CHAT_STEPS * CHAT_DELAY;
		CallEventDelayed(menuDelay, "smith_confirm");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// <store_n>	<item_script>			<#toadd>	<pri%>	[sellr]	[bndl]
		AddStoreItem(STORE_NAME, "armor_dark", RandomInt(0, 2), 400, 0);
		AddStoreItem(STORE_NAME, "armor_helm_dark", RandomInt(0, 2), 400, 0);
		AddStoreItem(STORE_NAME, "armor_helm_golden", RandomInt(0, 2), 400, 0);
		AddStoreItem(STORE_NAME, "axes_thunder11", 5, 600, 0);
		AddStoreItem(STORE_NAME, "smallarms_k_fire", 1, 400, 0);
		AddStoreItem(STORE_NAME, "blunt_gauntlets_fire", 1, 600, 0);
		AddStoreItem(STORE_NAME, "blunt_darkmaul", 5, 600, 0);
		AddStoreItem(STORE_NAME, "smallarms_craftedknife4", 5, 200, 0);
		AddStoreItem(STORE_NAME, "smallarms_fangstooth", 5, 200, 0);
		AddStoreItem(STORE_NAME, "blunt_granitemace", 5, 200, 0);
		AddStoreItem(STORE_NAME, "blunt_granitemaul", 5, 200, 0);
		AddStoreItem(STORE_NAME, "shields_lironshield", 5, 100, 0);
		AddStoreItem(STORE_NAME, "axes_gthunder11", 1, "3000%", 0);
		AddStoreItem(STORE_NAME, "axes_greataxe", 1, "300%", 0);
		AddStoreItem(STORE_NAME, "axes_scythe", 1, "300%", 0);
		AddStoreItem(STORE_NAME, "armor_helm_dark", 1, "300%", 0);

		if (RandomInt(1, 40) <= ActivePlayerCount())
		{
			AddStoreItem(STORE_NAME, "shields_rf", 1, 500, 0);
			AddStoreItem(STORE_NAME, "shields_rl", 1, 500, 0);
		}
	}

	// say_rdagger_excuse
	void OnSayRdaggerExcuse()
	{
		if (BUSY_CHATTING)
			return;
		CHAT_STEP1 = "Oh wow... I knows what this is! That's an ethereal blade under all that rust!";
		CHAT_STEP2 = "Ones this old tend to get rusties - hides the blade, but restoring it is... Very delicate work.";
		CHAT_STEP3 = "I'm afraid meez hands are just too rough for that kind of jeweler's task.";
		CHAT_STEP4 = "Probably needs a human or elf smith. I know not where you'd find one who could handle that these days though.";
		CHAT_STEPS = 4;
		OnChatLoop();
	}

	// frame_hammer
	void OnFrameHammer()
	{
		if (!IsAlive(BLACKSMITH_FX_ID))
			OnGetBlacksmithFxId();
		else
			CallExternal(BLACKSMITH_FX_ID, "do_spark");
	}

	// get_blacksmith_fx_id
	void OnGetBlacksmithFxId()
	{
		@BLACKSMITH_FX_ID = FindByName("sfx_blacksmith");
	}

	// smithing_cl_effects
	void OnSmithingClEffects()
	{
		// call cl effects based on SMITH_CL_TYPE here (pass to cleffect script)
		if (!IsAlive(BLACKSMITH_FX_ID))
			OnGetBlacksmithFxId();
		CallExternal(BLACKSMITH_FX_ID, "do_forge_fx", SMITH_CL_TYPE, SMITH_TYPE);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
	}

	void OnBchatMouthMove() { BaseChat_OnBchatMouthMove(); } // bchat_mouth_move
	void OnMenuDelay() {} // MENU_DELAY

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
		CallEventDelayed(10.0f, "SorcBlacksmith_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcBlacksmith_FirstThink();
		SorcBlacksmith_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseChat_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_smithing") { OnDoSmithing(); return true; }
		if (name == "frame_hammer") { OnFrameHammer(); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "get_blacksmith_fx_id") { OnGetBlacksmithFxId(); return true; }
		if (name == "get_yaw") { OnGetYaw(); return true; }
		if (name == "give_forge_menu") { OnGiveForgeMenu(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "say_axes_df") { OnSayAxesDf(PlayerParam(params, 0)); return true; }
		if (name == "say_axes_ss") { OnSayAxesSs(PlayerParam(params, 0)); return true; }
		if (name == "say_blunt_db") { OnSayBluntDb(PlayerParam(params, 0)); return true; }
		if (name == "say_blunt_gauntlet_ic") { OnSayBluntGauntletIc(PlayerParam(params, 0)); return true; }
		if (name == "say_forge") { OnSayForge(PlayerParam(params, 0)); return true; }
		if (name == "say_forge_weapons") { OnSayForgeWeapons(PlayerParam(params, 0)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_rdagger_excuse") { OnSayRdaggerExcuse(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "say_shop") { OnSayShop(); return true; }
		if (name == "say_smallarms_vt") { OnSaySmallarmsVt(PlayerParam(params, 0)); return true; }
		if (name == "say_swords_sf") { OnSaySwordsSf(PlayerParam(params, 0)); return true; }
		if (name == "say_swords_ub") { OnSaySwordsUb(PlayerParam(params, 0)); return true; }
		if (name == "smith_confirm") { OnSmithConfirm(); return true; }
		if (name == "smith_finalize") { OnSmithFinalize(); return true; }
		if (name == "smithing_cancel") { OnSmithingCancel(); return true; }
		if (name == "smithing_cl_effects") { OnSmithingClEffects(); return true; }
		if (name == "smithing_fail_payment") { OnSmithingFailPayment(); return true; }
		if (name == "start_hammering") { OnStartHammering(); return true; }
		if (name == "stop_hammering") { OnStopHammering(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "SorcBlacksmith_Timer") { SorcBlacksmith_Timer(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
