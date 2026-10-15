#pragma context server

// Converted from edana/bryan.script by msc_transpiler.
// Town rattler

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"
#include "converted/monsters/base_xmass.as"

[script "edana/bryan"]
class Bryan : BaseNpcScript, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm, BaseXmass
{
	// Constants
	string SOUND_IDLE = "voices/human/male_idle4.wav";
	string SOUND_IDLE2 = "voices/human/male_idle5.wav";
	string SOUND_IDLE3 = "voices/human/male_idle6.wav";
	string STORE_NAME = "edana_merchant_3";
	bool NO_JOB = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store";
	int EVIDENCE_FOUND = 0;
	bool SAY_MAYOR_SENTENCE = false;
	int RATTING = 0;
	bool ASKED_APPLE = false;
	string ATTACK1_DAMAGE = "5";
	string ATTACK_PERCENTAGE = "60%";
	int CIDER = 0;
	int SPEECH_LINE = 0;
	int GOSSIP_LINE = 0;
	string WEATHER = "";

	// Variables declared by included files, with the value they start with in this script
	Bryan()
	{
		ATTACK_RANGE = 90.0f;
	}

	// unnamed block (first think)
	void Bryan_FirstThink()
	{
		STORE_TRIGGERTEXT = "storetradeapple"; // base_vendor
	}

	// unnamed block (timer)
	// Idling
	void Bryan_Timer()
	{
		CallEventDelayed(35.0f, "Bryan_Timer");

		PlayRandomSound(Int(Eval("const.snd.voice")), Eval("const.snd.maxvol"), SOUND_IDLE, SOUND_IDLE2, SOUND_IDLE3, "none");
	}

	// unnamed block (timer)
	void Bryan_Timer2()
	{
		// Advertise my apples
		CallEventDelayed(60.0f, "Bryan_Timer2");

		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		if (RATTING != 0)
			return;

		SPEECH_LINE = RandomInt(1, 2);
		if (SPEECH_LINE == 1)
		{
			SayText("Guards just love me [apples]. Keeps 'em strong. Care to try one, mate?");
			CallExternal(FindByName("mayorguard"), "bryan_said_so");
		}
		else
		{
			if (SPEECH_LINE == 2)
				SayText("Care to try an apple, mate?");

			ASKED_APPLE = true;
		}
	}

	// say_cider
	void Bryan_OnSayCider()
	{
		if (CIDER != 1)
			return;

		SayText("Oh! Sylphiel's cider? Well I had thought she'd gotten it already! Tell her the [cider] is on it's way.");
		Say("[.6]", "[.24]", "[.35]", "[.4]", "[.34]", "[.24]", "[.35]", "[.4]");
		PlayAnim("once", "converse1");
		CallExternal(FindByName("wench"), "cider2");
		CallEventDelayed(1.0f, "say_cider_2");
	}

	// say_cider
	void Bryan_OnSayCider_2()
	{
		if (CIDER != 2)
			return;
		SayText("Oh! She still hasn't gotten it? Well then you must head over to Krythos in the Merchant's Square immediately!");
		CallExternal(FindByName("krythos"), "cider4");
		CallEventDelayed(1.0f, "say_cider_2");
	}

	// say_cider
	void Bryan_OnSayCider_3()
	{
		if (CIDER != 3)
			return;
		SayText("Well? You should get going!");
	}

	// say_rumor
	// Rumours
	void OnSayRumor(CBasePlayer@ talkingPlayer = null)
	{
		BaseChat_OnSayRumor(talkingPlayer); // monsters/base_chat

		PlayAnim("once", "pondering");
		SayText("An old friend of mine, a hermit living in the Thornlands is looking for something precious.");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetUniqueName("bryan");
		SetHealth(25);
		SetGold(30);
		SetName("Bryan the grocer");
		// ov 180
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetInvincible(true);
		EVIDENCE_FOUND = 0;
		SAY_MAYOR_SENTENCE = false;
		RATTING = 0;
		ASKED_APPLE = false;
		ATTACK_RANGE = 90.0f;
		ATTACK1_DAMAGE = "5";
		ATTACK_PERCENTAGE = "60%";
		CIDER = 0;

		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
			SetModelBody(2, 1);
		CallEventDelayed(3.0f, "check_hat");

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet");
		CatchSpeech("respond_yes", "yes", "sure", "try", "give", "have", "buy");
		CatchSpeech("respond_no", "no");
		CatchSpeech("say_apple", "apple");

		CatchSpeech("say_job", "job", "work", "money", "gold");
		CatchSpeech("say_cider", "cider");

		CatchSpeech("say_mayor", "mayor", "know", "heard", "rumor");
		CatchSpeech("say_rumor", "quest", "news", "happenings");
	}

	// check_hat
	void OnCheckHat()
	{
		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
			SetModelBody(2, 1);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		SayText("'Ello there. Care for one of me delicious [apples]?");
		CallEventDelayed(2.0f, "say_hi2");
		ASKED_APPLE = true;
	}

	// say_hi2
	void OnSayHi2()
	{
		if (WEATHER == "clear")
			return;
		SayText("It'll keep you going in this poor weather we are having.");
	}

	// say_apple
	void OnSayApple()
	{
		SayText("Guards just love me [apples]. Keeps 'em strong. Care to try one, mate?");
		CallExternal(FindByName("mayorguard"), "bryan_said_so");
	}

	// say_mayor
	void OnSayMayor()
	{
		RATTING = 1;
		CallEventDelayed(1.0f, "say_mayor_delayed"); // Delay my response by a second, for realism
	}

	// say_mayor_delayed
	void OnSayMayorDelayed()
	{
		if (EVIDENCE_FOUND == 0)
		{
			GOSSIP_LINE = RandomInt(1, 3);

			if (GOSSIP_LINE == 1)
				SayText("Word is, the mayor ain't such a good fella.");
			else if (GOSSIP_LINE == 2)
				SayText("I hear Edrin's got a pretty colourful past.");
			else if (GOSSIP_LINE == 3)
				SayText("Maybe... with the proper incentive... I'd tell ya more.");
		}
		else
		{
			SayText("I heard the mayor's been caught, and will be spendin a good amount of time locked up.");
			PlayAnim("once", "yes");
		}

		RATTING = 0;
	}

	// worldevent_evidence_found
	void OnWorldeventEvidenceFound()
	{
		EVIDENCE_FOUND = 1;
	}

	// respond_yes
	void OnRespondYes()
	{
		if ((ASKED_APPLE ? 1 : 0) != 1)
			return;

		OnSayApple();
		ASKED_APPLE = false;
	}

	// respond_no
	void OnRespondNo()
	{
		if ((ASKED_APPLE ? 1 : 0) != 1)
			return;

		SayText("But have ya tried one traveler? They're great apples!");
		ASKED_APPLE = false;
	}

	// game_recvoffer_gold
	// //////////// Accept Bribe for info /////////////
	void OnGameRecvofferGold()
	{
		if (EVIDENCE_FOUND != 0)
			return;

		if (Float(Eval("game.offer.gold")) >= 15.0f)
		{
			ReceiveOffer("accept");
			SayText("Tat's a good lad. And here is what I know...");
			PlayAnim("once", "quicklook");
			RATTING = 1;

			CallEventDelayed(3.0f, "give_mayor_info_1");
		}
		else
		{
			ReceiveOffer("reject");
			SayText("A lowly begger wouldn't take that offer.");
			PlayAnim("once", "no");
		}
	}

	// give_mayor_info_1
	void OnGiveMayorInfo1()
	{
		SayText("Good, no one's around.");
		CallEventDelayed(2.0f, "give_mayor_info_2");
	}

	// give_mayor_info_2
	void OnGiveMayorInfo2()
	{
		SayText("I been seeing some unusual mail coming in to the mayor.");
		PlayAnim("once", "pondering3");
		CallEventDelayed(4.0f, "give_mayor_info_3");
	}

	// give_mayor_info_3
	void OnGiveMayorInfo3()
	{
		SayText("I been thinkin maybe him and the Orcs communicatin by letter.");
		PlayAnim("once", "converse2");
		CallEventDelayed(3.0f, "give_mayor_info_4");
	}

	// give_mayor_info_4
	void OnGiveMayorInfo4()
	{
		SayText("But I never had the gall to go check it out.");
		CallEventDelayed(4.0f, "give_mayor_info_5");
	}

	// give_mayor_info_5
	void OnGiveMayorInfo5()
	{
		SayText("The mayor is clever, if he's suspicious of you, he'll hide the evidence.");
		CallEventDelayed(3.0f, "give_mayor_info_6");
	}

	// give_mayor_info_6
	void OnGiveMayorInfo6()
	{
		SayText("So don't let 'em know you're lookin for it mate.");
		CallEventDelayed(3.0f, "give_mayor_info_7");
	}

	// give_mayor_info_7
	void OnGiveMayorInfo7()
	{
		SayText("Him and his guard's are so corrupt, it makes me sick...they'll do anythin' for money.");
		CallEventDelayed(3.0f, "give_mayor_info_8");
	}

	// give_mayor_info_8
	void OnGiveMayorInfo8()
	{
		SayText("I'm sure Edrin, the guard over there, will help us. Show him any evidence you find.");
		RATTING = 0;
	}

	// trade_done
	// //////////// Shop //////////////////
	void OnTradeDone()
	{
		SayText("Have a nice day.");
		Say("[.3]", "[.3]", "[.3]", "[.5]");
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  |Quantity| |cost%|
		AddStoreItem(STORE_NAME, "health_apple", 30, 100);
	}

	// cider
	// ////cider quest
	void OnCider()
	{
		CIDER = 1;
	}

	// say_cider
	void OnSayCider()
	{
		Bryan_OnSayCider();
		Bryan_OnSayCider_2();
		Bryan_OnSayCider_3();
	}

	// say_cider_2
	void OnSayCider22()
	{
		CIDER = 3;
	}

	// cider3
	void OnCider3()
	{
		CIDER = 2;
	}

	// worldevent_weather
	void OnWorldeventWeather(string weatherType = "")
	{
		WEATHER = weatherType;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
		BaseXmass_OnGameSpawn(playerRace, playerGender); // monsters/base_xmass
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
	}

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
		CallEventDelayed(35.0f, "Bryan_Timer");
		CallEventDelayed(60.0f, "Bryan_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bryan_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
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
		if (name == "check_hat") { OnCheckHat(); return true; }
		if (name == "cider") { OnCider(); return true; }
		if (name == "cider3") { OnCider3(); return true; }
		if (name == "game_recvoffer_gold") { OnGameRecvofferGold(); return true; }
		if (name == "give_mayor_info_1") { OnGiveMayorInfo1(); return true; }
		if (name == "give_mayor_info_2") { OnGiveMayorInfo2(); return true; }
		if (name == "give_mayor_info_3") { OnGiveMayorInfo3(); return true; }
		if (name == "give_mayor_info_4") { OnGiveMayorInfo4(); return true; }
		if (name == "give_mayor_info_5") { OnGiveMayorInfo5(); return true; }
		if (name == "give_mayor_info_6") { OnGiveMayorInfo6(); return true; }
		if (name == "give_mayor_info_7") { OnGiveMayorInfo7(); return true; }
		if (name == "give_mayor_info_8") { OnGiveMayorInfo8(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "respond_no") { OnRespondNo(); return true; }
		if (name == "respond_yes") { OnRespondYes(); return true; }
		if (name == "say_apple") { OnSayApple(); return true; }
		if (name == "say_cider") { OnSayCider(); return true; }
		if (name == "say_cider_2") { OnSayCider22(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "say_hi2") { OnSayHi2(); return true; }
		if (name == "say_mayor") { OnSayMayor(); return true; }
		if (name == "say_mayor_delayed") { OnSayMayorDelayed(); return true; }
		if (name == "say_rumor") { OnSayRumor(PlayerParam(params, 0)); return true; }
		if (name == "trade_done") { OnTradeDone(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "worldevent_evidence_found") { OnWorldeventEvidenceFound(); return true; }
		if (name == "worldevent_weather") { OnWorldeventWeather(Param(params, 0)); return true; }
		if (name == "Bryan_Timer") { Bryan_Timer(); return true; }
		if (name == "Bryan_Timer2") { Bryan_Timer2(); return true; }
		return BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| BaseXmass_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
