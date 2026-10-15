#pragma context server

// Converted from sorc_villa/sorc_merc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_chat_array.as"
#include "converted/monsters/debug.as"

[script "sorc_villa/sorc_merc"]
class SorcMerc : BaseChatArrayScript, BaseNpcVendor, FirstVendor, Debug
{
	// Variables (an unset .script variable reads as its own name)
	string STORE_NAME = "STORE_NAME";
	string STORE_TRIGGERTEXT = "STORE_TRIGGERTEXT";
	bool VENDOR_MENU_OFF = false;
	bool VENDOR_NOT_ON_USE = false;
	float START_YAW = 0.0f;
	string LAST_PLAYER_USED = "LAST_PLAYER_USED";
	float NEXT_YAW_RESET = 0.0f;
	bool SORC_STORE_STOCKED = false;

	// unnamed block (first think)
	void SorcMerc_FirstThink()
	{
		STORE_NAME = "sorc_merc_" + Text(Random(-10000, 10000));
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	}

	// unnamed block (timer)
	void SorcMerc_Timer()
	{
		CallEventDelayed(60.0f, "SorcMerc_Timer");
		if (!(GameTime() > NEXT_YAW_RESET))
			return;
		SetAngle("face", Vector3(0, START_YAW, 0));
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseChatArray_OnGameSpawn(playerRace, playerGender); // monsters/base_chat_array
		SetName("Shadahar Merchant");
		SetModel("monsters/sorc.mdl");
		SetHealth(1);
		SetInvincible(true);
		SetWidth(32);
		SetHeight(72);
		SetRace("beloved");
		SetNoPush(true);

		SetIdleAnim("idle1");
		SetMoveAnim("idle1");
		PlayAnim("once", "idle1");

		if (RandomInt(1, 2) == 1)
		{
			SetModelBody(0, 1); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
			SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
			SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		}
		else
		{
			SetModelBody(0, 0); // body: 0=bare 1=bloody_shirt 2=gold_armor 3=archer
			SetModelBody(1, 4); // head: 0=hat_horns 1=hat_spiked 2=lizardskin_horned 3=gold_Chieftain 4=lizard_cap
			SetModelBody(2, 0); // weapon: 0=unarmed 1=axe 2=bow 3=steel_bow 4=sword 5=great_axe 6=sword_sheild 8=yellow_axe 9=blooddrinker
		}

		SetSayTextRange(1024);

		VENDOR_MENU_OFF = false;
		VENDOR_NOT_ON_USE = false;

		SetMenuAutoOpen(true);
		CallEventDelayed(0.1f, "get_yaw");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseChatArray_OnGameMenuGetoptions(player); // monsters/base_chat_array

		if (LAST_PLAYER_USED != EntityId(player))
		{
			int rndComment = RandomInt(1, 4);
			if (rndComment == 1)
				SayText("Runegahr says we sells to you, so we sells to you.");
			if (rndComment == 2)
				SayText("Me have many things skinny humans maybe interested in.");
			if (rndComment == 3)
				SayText("First time me getting gold from a human without killing him first.");
			if (rndComment == 4)
				SayText("Some of my stuff maybe too heavy for skinny human arms.");
			CallEventDelayed(Random(30, 60), "reset_comment_target");
		}
		LAST_PLAYER_USED = EntityId(player);

		NEXT_YAW_RESET = GameTime() + 30.0f;
	}

	// game_confirm_buy
	// <owner_id> <item_name> <scriptname> <skill_type>
	void OnGameConfirmBuy(CBasePlayer@ player = null, string itemName = "", string itemScript = "", string skill = "", string stat = "")
	{
		BaseNpcVendor_OnGameConfirmBuy(player, itemName, itemScript, skill, stat); // monsters/base_npc_vendor
		DebugPrint(EntityId(player) + " " + itemName + " " + itemScript + " " + skill);
	}

	// get_yaw
	void OnGetYaw()
	{
		START_YAW = AnglesOf(ENT_ME).y;
	}

	// reset_comment_target
	void OnResetCommentTarget()
	{
		LAST_PLAYER_USED = "-1";
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// shared with the human vendor
		if (SORC_STORE_STOCKED)
			return;
		SORC_STORE_STOCKED = true;
		AddStoreItem(STORE_NAME, "health_mpotion", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "health_spotion", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "mana_mpotion", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "drink_mead", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "drink_ale", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "shields_lironshield", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "pack_heavybackpack", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "pack_archersquiver", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "sheath_back_holster", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "swords_iceblade", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "axes_poison1", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "blunt_granitemace", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "blunt_granitemaul", RandomInt(0, 1), "150%", 0);
		AddStoreItem(STORE_NAME, "bows_swiftbow", RandomInt(0, 1), "150%", 0);

		AddStoreItem(STORE_NAME, "axes_thunder11", 1, "1000%", 0);
		AddStoreItem(STORE_NAME, "axes_gthunder11", RandomInt(0, 1), "5000%", 0);
		AddStoreItem(STORE_NAME, "axes_greataxe", RandomInt(0, 1), "300%", 0);
		AddStoreItem(STORE_NAME, "axes_scythe", RandomInt(0, 1), "300%", 0);
		AddStoreItem(STORE_NAME, "bows_orcbow", RandomInt(0, 1), "50%", 0);
		AddStoreItem(STORE_NAME, "armor_helm_dark", RandomInt(0, 1), "300%", 0);

		AddStoreItem(STORE_NAME, "mana_demon_blood", RandomInt(0, 1), "1000%", 0);
		AddStoreItem(STORE_NAME, "mana_vampire", RandomInt(0, 1), "1000%", 0);
		AddStoreItem(STORE_NAME, "mana_regen", RandomInt(0, 1), "1000%", 0);
		AddStoreItem(STORE_NAME, "armor_helm_bronze", RandomInt(0, 1), "300%", 0);
		AddStoreItem(STORE_NAME, "blunt_gauntlets_serpant", RandomInt(0, 1), "1000%", 0);
		if (RandomInt(1, 5) == 4)
			AddStoreItem(STORE_NAME, "axes_tl", RandomInt(0, 1), "10000%", 0);

		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "shields_rune", 1, "5000%", 0);
		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "armor_helm_gaz1", 1, "3000%", 0);
		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "armor_helm_gaz2", 1, "3000%", 0);
		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "armor_fireliz", 1, "3000%", 0);
		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "axes_vaxe", 1, "3000%", 0);
		if (RandomInt(1, 4) == 2)
			AddStoreItem(STORE_NAME, "mana_leadfoot", 1, "5000%", 0);
		if (RandomInt(1, 20) == 20)
			AddStoreItem(STORE_NAME, "swords_wolvesbane", 1, "10000%", 0);
		if (RandomInt(1, 10) == 2)
			AddStoreItem(STORE_NAME, "axes_tl", 1, "10000%", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/sorc.mdl");
		CallEventDelayed(60.0f, "SorcMerc_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcMerc_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
		BaseChatArray_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_confirm_buy") { OnGameConfirmBuy(PlayerParam(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_yaw") { OnGetYaw(); return true; }
		if (name == "reset_comment_target") { OnResetCommentTarget(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "SorcMerc_Timer") { SorcMerc_Timer(); return true; }
		return BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| Debug_DispatchEvent(name, params)
			|| BaseChatArrayScript::DispatchEvent(name, params);
	}
}
