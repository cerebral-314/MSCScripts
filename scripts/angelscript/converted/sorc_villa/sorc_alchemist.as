#pragma context server

// Converted from sorc_villa/sorc_alchemist.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_chat_array.as"

[script "sorc_villa/sorc_alchemist"]
class SorcAlchemist : BaseNpcScript, BaseNpcVendor, FirstVendor, BaseChatArray
{
	// Constants
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHAT_NO_CLOSE_MOUTH = true;
	bool CHAT_NEVER_INTERRUPT = true;
	bool VEND_INDIVIDUAL = true;
	string BUSY_COMMENT = "Stupid impatient humans... One at a time!";

	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "sorc_pots";
	int DID_INTRO = 0;
	string PLR_INTRO = "PLR_INTRO";
	CBaseEntity@ SORC_CHIEF_ID = null;
	bool CHAT_TEMP_NO_AUTO_FACE = false;
	bool CHIEF_GONE = false;

	// unnamed block (first think)
	void SorcAlchemist_FirstThink()
	{
		STORE_NAME = "sorc_pots";
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		SetMenuAutoOpen(false);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetName("Easkhar");
		SetUniqueName("sorc_alchie");
		SetModel("monsters/sorc.mdl");
		SetHealth(5000);
		SetRace("beloved");
		SetInvincible(true);
		PLAYING_DEAD = "1";
		SetNoPush(true);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");

		SetWidth(32);
		SetHeight(96);

		SetHearingSensitivity(11);

		SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
		SetModelBody(1, 2); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
		SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker 10=meat 11=hammah 12=drink

		SetSayTextRange(1024);
		CallEventDelayed(0.1f, "crystal_complain");

		OnNpcatkSuspendAi();
		CallEventDelayed(0.1f, "scan_for_players");
	}

	// crystal_complain
	void OnCrystalComplain()
	{
		SayText("*sigh* Just because I make the glue, they want *me* to fix the damned crystals when *they* break them...");
	}

	// scan_for_players
	void OnScanForPlayers()
	{
		if (DID_INTRO != 0)
			return;
		CallEventDelayed(0.5f, "scan_for_players");
		if (!CanSee("player"))
			return;
		DID_INTRO = 1;
		PLR_INTRO = EntityId(EntityOf(ENT_LASTSEEN));
		OnDoIntro();
	}

	// do_intro
	void OnDoIntro()
	{
		OnChatAddText("intro_chat", "Humans!? I care not what Chief Runeghar says, I am NOT selling to humans!", "5.0", "neigh");
		OnChatAddText("intro_chat", "Go! Be gone with thee!", "2.0", "swordswing1_L");
		OnChatStartSequence("intro_chat", "add_to_que");
		CallEventDelayed(7.0f, "do_intro2");
	}

	// do_intro2
	void OnDoIntro2()
	{
		CreateNpc("sorc_villa/sorc_chief_image", Vector3(-1952, -3120, 48), self);
		// manual position, if need be: (-1952,-3120,48)
		@SORC_CHIEF_ID = EntityOf(ENT_LASTCREATED);
	}

	// ext_face_chief
	void OnExtFaceChief()
	{
		SetMoveDest(@SORC_CHIEF_ID, 9999);
		PlayAnim("critical", "flinch");
		CallEventDelayed(1.0f, "ext_face_chief2");
	}

	// ext_face_chief2
	void OnExtFaceChief2()
	{
		SetMoveDest(@SORC_CHIEF_ID, 9999);
		PlayAnim("critical", "kneeling");
		CallEventDelayed(0.5f, "ext_face_chief3");
	}

	// ext_face_chief3
	void OnExtFaceChief3()
	{
		SetMoveDest(@SORC_CHIEF_ID, 9999);
		PlayAnim("break");
		PlayAnim("hold", "kneel");
		SetIdleAnim("kneel");
		SetMoveAnim("kneel");
	}

	// ext_chief_done_berating
	void OnExtChiefDoneBerating()
	{
		bool exitSub = false;
		if (CHAT_BUSY)
		{
			CallEventDelayed(0.1f, "ext_chief_done_berating");
			exitSub = true;
		}
		if (exitSub)
			return;
		CHAT_TEMP_NO_AUTO_FACE = true;
		OnChatAddText("sry_chief", "I... I am sorry, warchief! I... I understand.", "3.0");
		OnChatAddText("sry_chief", "I will do as you say.", "3.0");
		OnChatStartSequence("sry_chief", "add_to_que");
	}

	// ext_chief_gone
	void OnExtChiefGone()
	{
		CHAT_TEMP_NO_AUTO_FACE = false;
		UseTrigger("twal_pot_block"); // remove the partition stopping players

		CHIEF_GONE = true;

		OnChatAddText("chief_gone", "Bah, I still don't like it.", "3.0", "neigh");
		OnChatAddText("chief_gone", "But fine, I will do business with you.", "3.0");
		OnChatAddText("chief_gone", "I warn you, however, it won't be cheap.", "3.0", "nod_yes");
		OnChatStartSequence("chief_gone", "add_to_que");

		string nearPlayer = FindInSphere("players", 128);
		nearPlayer = GetToken(nearPlayer, 0);

		if (RangeTo(nearPlayer) < RangeTo(PLR_INTRO))
			PLR_INTRO = nearPlayer;

		SetMoveDest(PLR_INTRO, 9999);

		SetMoveAnim("idle1");
		SetIdleAnim("idle1");

		SetMenuAutoOpen(true);
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		DebugPrint("vendor_addstoreitems");
		AddStoreItem(STORE_NAME, "health_mpotion", 30, 400, 0.0f);
		AddStoreItem(STORE_NAME, "health_lpotion", 30, 400, 0.0f);
		AddStoreItem(STORE_NAME, "mana_speed", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_gprotection", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_protection", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_resist_cold", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_cold", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_resist_fire", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_fire", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_immune_poison", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_vampire", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_forget", 5, 300, 0.0f);
		AddStoreItem(STORE_NAME, "mana_demon_blood", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_bravery", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_fbrand", 1, 500, 0.0f);
		AddStoreItem(STORE_NAME, "mana_faura", 1, 300, 0.0f);
		AddStoreItem(STORE_NAME, "mana_paura", 1, 300, 0.0f);
		AddStoreItem(STORE_NAME, "mana_font", 1, 500, 0.0f);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!CHIEF_GONE)
			return;
		if (VENDOR_STORE_ACTIVE)
			return;
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (!IsPlayer(lastHeard))
			return;
		if (!(RangeTo(lastHeard) < 256.0f))
			return;
		SetMoveDest(@lastHeard, 9999);
	}

	// ext_player_on_shelf
	void OnExtPlayerOnShelf()
	{
		if (CHAT_BUSY)
			return;
		PlayAnim("once", "warcry");
		OnChatNow("By the mighty Torkalath, you humans are like monkeys! GET OFF MY SHELVES!", "6.0", "add_to_que");
	}

	// ext_player_on_table
	void OnExtPlayerOnTable()
	{
		if (!CHIEF_GONE)
			return;
		if (CHAT_BUSY)
			OnChatNow("...and could you, please, *try* not standing on my table...", "4.0", "add_to_que");
		else
			OnChatNow("Could you, please, try *not* standing on my table...", "4.0", "add_to_que");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseChatArray_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_chat_array
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcAlchemist_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "crystal_complain") { OnCrystalComplain(); return true; }
		if (name == "do_intro") { OnDoIntro(); return true; }
		if (name == "do_intro2") { OnDoIntro2(); return true; }
		if (name == "ext_chief_done_berating") { OnExtChiefDoneBerating(); return true; }
		if (name == "ext_chief_gone") { OnExtChiefGone(); return true; }
		if (name == "ext_face_chief") { OnExtFaceChief(); return true; }
		if (name == "ext_face_chief2") { OnExtFaceChief2(); return true; }
		if (name == "ext_face_chief3") { OnExtFaceChief3(); return true; }
		if (name == "ext_player_on_shelf") { OnExtPlayerOnShelf(); return true; }
		if (name == "ext_player_on_table") { OnExtPlayerOnTable(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "scan_for_players") { OnScanForPlayers(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseChatArray_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
