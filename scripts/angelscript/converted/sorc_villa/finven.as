#pragma context server

// Converted from sorc_villa/finven.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_chat_array.as"

[script "sorc_villa/finven"]
class Finven : BaseChatArrayScript, BaseNpcVendor, FirstVendor
{
	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "finven";
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool NPC_CHECK_LEVEL = true;
	bool VENDOR_MENU_OFF = false;
	bool VENDOR_NOT_ON_USE = false;
	int DID_INTRO = 0;
	CBaseEntity@ PLAYER_ID = null;
	CBaseEntity@ ARCHER_ID = null;

	// Variables declared by included files, with the value they start with in this script
	Finven()
	{
		CHAT_AUTO_HAIL = true;
		CHAT_NEVER_INTERRUPT = true;
	}

	// unnamed block (first think)
	void Finven_FirstThink()
	{
		STORE_NAME = "finven";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";

		NPC_CHECK_LEVEL = true;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Finven");
		SetUniqueName("human_vendor");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetModel("npc/human1.mdl");
		SetModelBody(0, 3);
		SetNoPush(true);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");

		SetSayTextRange(768);

		VENDOR_MENU_OFF = true;
		VENDOR_NOT_ON_USE = true;

		OnScanForPlayers();

		OnChatAddText("the_elf", "Oh, the elf, just outside the villa, his name's Varondo... He's with Galat.", "6.2", "none", "1");
		OnChatAddText("the_elf", "They won't let him in, but seem fine with setting up shop there. They haven't killed him yet, at least.", "6.4", "talkleft", "1");
		OnChatAddText("the_elf", "Leave it to Galat to have a representative, even way out here in this gods foresaken place, eh?", "5.2", "none", "1");

		OnChatAddText("say_hi", "Hi there, I'm the merchant. The only one in town - or at least, the only one without tusks.", "5.9", "none", "1");
		OnChatAddText("say_hi", "The orcs used to raid our village all the time, but then Chief Runegahr got it into his head we'd be more useful alive than dead.", "7.5", "none", "1");
		OnChatAddText("say_hi", "So here I am, selling stuff in a town... Full of orcs... Heh... It's a funny thing, really...", "7.1", "panic", "1");

		OnChatAddText("intro_talk", "*cough* Sorry... We don't get many humans in these parts...", "4.3", "none", "1");
		OnChatAddText("intro_talk", "Especially not ones carrying swords... It's just, me, really.", "3.8", "none", "1");
		OnChatAddText("intro_talk", "I'm Finven, the merchant. The orcs they, umm... Let me sell my wares here, at a discount...", "7.1", "none", "1");
		OnChatAddText("intro_talk", "Our village, Sunden-dal, lies deep in the desert. We produce several, commodities, there, that the orcs cannot.", "6.9", "none", "1");
		OnChatAddText("intro_talk", "So, in exchange for my services, they allow the village to survive. They even help us out from time to time.", "6.5", "none", "1");
		OnChatAddText("intro_talk", "It's hard, maintaining such a small community in such a dangerous place, you see...", "4.4", "none", "1");
		OnChatAddText("intro_talk", "Now, let's see what I can do for you.", "1.8", "none", "1");

		CatchSpeech("say_hi", "hi", "hail", "greet", "gweet", "j0", "up");
		CatchSpeech("say_elf", "elf", "galat", "varon", "rumor", "rumour");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
		MenuItem menuItem;
		if (!Truthy(GetVar("G_GAVE_DIRECTIONS")))
			menuItem.title = "Rumors";
		else
			menuItem.title = "About the Elf";
		menuItem.type = "callback";
		menuItem.callback = "say_elf";
		RegisterMenuItem(menuItem);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (DID_INTRO == 0)
			return;
		OnChatStartSequence("say_hi");
	}

	// say_elf
	void OnSayElf()
	{
		if (DID_INTRO == 0)
			return;
		OnChatStartSequence("the_elf");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(1.0f, "scan_for_players");
		if (!Truthy(LegacyFunction("cansee", "player", 128)))
			return;
		DID_INTRO = 1;
		@PLAYER_ID = EntityOf(ENT_LASTSEEN);
		OnDoIntro();
	}

	// do_intro
	void OnDoIntro()
	{
		PlayAnim("critical", "fear1");
		SetIdleAnim("crouch_idle");
		OnChatNow("By the gods, HUMANS! WE'RE UNDER ATTACK!!!", "3.0", "fear1", "clear_que");
		PlaySound(0, 10, "voices/sorc_villa/finven_startle1.wav");
		CallEventDelayed(3.3f, "do_intro2");
	}

	// do_intro2
	void OnDoIntro2()
	{
		@ARCHER_ID = FindByName("roof_archer");
		CallExternal(ARCHER_ID, "ext_under_attack1", self);
		CallEventDelayed(4.0f, "do_intro3");
	}

	// do_intro3
	void OnDoIntro3()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_startle2.wav");
		OnChatNow("Oh... Yes... Silly me... Eh, greetings, great travelers.", "add_to_que");
		// playsound 0 10 scientist/greetings.wav
		SetIdleAnim("idle1");
		PlayAnim("critical", "crouch_idle2");
		CallEventDelayed(4.3f, "do_intro4");
	}

	// do_intro4
	void OnDoIntro4()
	{
		CallExternal(ARCHER_ID, "ext_under_attack2");
		CallEventDelayed(2.0f, "do_intro5");
	}

	// do_intro5
	void OnDoIntro5()
	{
		OnOpenStore();
		OnChatStartSequence("intro_talk", "prioritize", "add_to_que");
	}

	// open_store
	void OnOpenStore()
	{
		VENDOR_MENU_OFF = false;
		VENDOR_NOT_ON_USE = false;
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		AddStoreItem(STORE_NAME, "health_apple", 15, "50%");
		AddStoreItem(STORE_NAME, "health_mpotion", 4, "50%");
		AddStoreItem(STORE_NAME, "health_spotion", 4, "50%");
		AddStoreItem(STORE_NAME, "mana_mpotion", 4, "50%");
		AddStoreItem(STORE_NAME, "drink_mead", 20, "50%");
		AddStoreItem(STORE_NAME, "drink_ale", 20, "50%");
		AddStoreItem(STORE_NAME, "scroll2_summon_rat", 2, "50%");
		AddStoreItem(STORE_NAME, "scroll2_rejuvenate", 2, "50%");
		AddStoreItem(STORE_NAME, "scroll2_glow", 5, "50%");
		AddStoreItem(STORE_NAME, "scroll2_fire_ball", 1, "50%");
		AddStoreItem(STORE_NAME, "scroll2_poison", 1, "50%");
		AddStoreItem(STORE_NAME, "armor_mongol", 1, "50%");
		AddStoreItem(STORE_NAME, "armor_helm_golden", 1, "300%");
		AddStoreItem(STORE_NAME, "armor_salamander", 1, "3000%");
		AddStoreItem(STORE_NAME, "shields_lironshield", 3, "50%");
		AddStoreItem(STORE_NAME, "pack_heavybackpack", 5, "50%");
		AddStoreItem(STORE_NAME, "pack_archersquiver", 5, "100%");
		AddStoreItem(STORE_NAME, "sheath_back_holster", 1, "50%");
		AddStoreItem(STORE_NAME, "sheath_spellbook", 3, "50%");
		AddStoreItem(STORE_NAME, "swords_iceblade", 1, "50%");
		AddStoreItem(STORE_NAME, "axes_poison1", 1, "100%");
		AddStoreItem(STORE_NAME, "smallarms_huggerdagger4", 1, "50%");
		AddStoreItem(STORE_NAME, "smallarms_craftedknife4", 1, "50%");
		AddStoreItem(STORE_NAME, "blunt_granitemace", 1, "100%");
		AddStoreItem(STORE_NAME, "blunt_granitemaul", 1, "100%");
		AddStoreItem(STORE_NAME, "bows_swiftbow", 1, "50%");
		AddStoreItem(STORE_NAME, "item_light_crystal", 10, "100%");
		AddStoreItem(STORE_NAME, "item_charm_w1", 1, "300%");
		AddStoreItem(STORE_NAME, "polearms_qs", 5, "100%");
		AddStoreItem(STORE_NAME, "polearms_sp", 2, "100%");
		AddStoreItem(STORE_NAME, "polearms_tri", 1, "100%");
		if (RandomInt(1, 16) == 16)
			AddStoreItem(STORE_NAME, "polearms_nag", 1, "500%");
	}

	// ext_player_got_item
	// item_id owner_id
	void OnExtPlayerGotItem(CBaseEntity@ itemEntity = null, CBaseEntity@ owner = null)
	{
		string iname = NameOf(itemEntity);
		iname = ToLowerCase(iname);
		if (!Contains(iname, "ice"))
			return;
		OnChatNow("Those are good for keeping you cool, if you are, ummm, very, careful with them.", "4.0", "add_to_que");
	}

	// voice_galat1
	void OnVoiceGalat1()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_galat1.wav");
	}

	// voice_galat2
	void OnVoiceGalat2()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_galat2.wav");
	}

	// voice_galat3
	void OnVoiceGalat3()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_galat3.wav");
	}

	// voice_hail1
	void OnVoiceHail1()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_hail1.wav");
	}

	// voice_hail2
	void OnVoiceHail2()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_hail2.wav");
	}

	// voice_hail3
	void OnVoiceHail3()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_hail3.wav");
	}

	// voice_intro1
	void OnVoiceIntro1()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro1.wav");
	}

	// voice_intro2
	void OnVoiceIntro2()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro2.wav");
	}

	// voice_intro3
	void OnVoiceIntro3()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro3.wav");
	}

	// voice_intro4
	void OnVoiceIntro4()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro4.wav");
	}

	// voice_intro5
	void OnVoiceIntro5()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro5.wav");
	}

	// voice_intro6
	void OnVoiceIntro6()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro6.wav");
	}

	// voice_intro7
	void OnVoiceIntro7()
	{
		PlaySound(0, 10, "voices/sorc_villa/finven_intro7.wav");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Finven_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "do_intro3") { OnDoIntro3(); return true; }
		if (name == "do_intro4") { OnDoIntro4(); return true; }
		if (name == "do_intro5") { OnDoIntro5(); return true; }
		if (name == "ext_player_got_item") { OnExtPlayerGotItem(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "open_store") { OnOpenStore(); return true; }
		if (name == "say_elf") { OnSayElf(); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "voice_galat1") { OnVoiceGalat1(); return true; }
		if (name == "voice_galat2") { OnVoiceGalat2(); return true; }
		if (name == "voice_galat3") { OnVoiceGalat3(); return true; }
		if (name == "voice_hail1") { OnVoiceHail1(); return true; }
		if (name == "voice_hail2") { OnVoiceHail2(); return true; }
		if (name == "voice_hail3") { OnVoiceHail3(); return true; }
		if (name == "voice_intro1") { OnVoiceIntro1(); return true; }
		if (name == "voice_intro2") { OnVoiceIntro2(); return true; }
		if (name == "voice_intro3") { OnVoiceIntro3(); return true; }
		if (name == "voice_intro4") { OnVoiceIntro4(); return true; }
		if (name == "voice_intro5") { OnVoiceIntro5(); return true; }
		if (name == "voice_intro6") { OnVoiceIntro6(); return true; }
		if (name == "voice_intro7") { OnVoiceIntro7(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
