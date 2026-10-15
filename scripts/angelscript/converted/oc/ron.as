#pragma context server

// Converted from oc/ron.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc_vendor.as"

[script "oc/ron"]
class Ron : BaseNpcVendorScript
{
	// Constants
	string SOUND_DEATH = "none";
	bool NO_JOB = true;
	bool NO_RUMOR = true;

	// Variables (an unset .script variable reads as its own name)
	string STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
	bool SAY_SO = false;
	string ANIM_DEATH = "ANIM_DEATH";
	bool NO_SPAWN_STUCK_CHECK = false;
	bool VENDOR_NOT_ON_USE = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool MENU_OPEN = false;
	bool GAVE_INTRO = false;
	bool SET_DESTINATION = false;
	string TRIGGER_OUT = "TRIGGER_OUT";

	// Variables declared by included files, with the value they start with in this script
	Ron()
	{
		STORE_NAME = "rons_shop";
	}

	// unnamed block (first think)
	void Ron_FirstThink()
	{
		ANIM_DEATH = "diesimple";

		// base_vendor
		STORE_NAME = "rons_shop";
		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		SAY_SO = false;

		NO_SPAWN_STUCK_CHECK = true;

		VENDOR_NOT_ON_USE = true;
		NPC_NO_PLAYER_DMG = true;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type Param4=AccuracyRoll
	string Ron_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (IsPlayer(attacker)) // Dont take dmg from players
			result = AppendResult(result, "0");
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor

		SetHealth(100); // 30 is too low. Changed to 100
		SetName("Captain Ron");
		SetWidth(32);
		SetHeight(72);
		SetRace("human");
		SetRoam(false); // Don't go roaming around
		SetModel("npc/human1.mdl");
		SetModelBody(1, 1);
		SetNoPush(true);

		SetDamageTaken("holy", 0);

		CatchSpeech("say_hi", "hi", "hello", "hail", "greet", "j0", "wassup");
		SetMenuAutoOpen(true);
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		MenuItem menuItem;

		MENU_OPEN = true;

		if (!SET_DESTINATION)
		{
			PlayAnim("once", "converse1");

			if (!GAVE_INTRO)
			{
				SayText("Ahoy there! Welcome to Captain Ron's pleasure cruise slash high seas adventure! Where be ye travelin' lad?");
				GAVE_INTRO = true;
			}

			menuItem.title = "To Deralia";
			menuItem.type = "callback";
			menuItem.callback = "set_sail";
			menuItem.data = "deralia";
			RegisterMenuItem(menuItem);

			menuItem.title = "To Port Ara";
			menuItem.type = "callback";
			menuItem.callback = "set_sail";
			menuItem.data = "ara";
			RegisterMenuItem(menuItem);

			menuItem.title = "To The Isles of Dread";
			menuItem.type = "callback";
			menuItem.callback = "set_sail";
			menuItem.data = "isles";
			RegisterMenuItem(menuItem);

			menuItem.title = "To The Tundra";
			menuItem.type = "callback";
			menuItem.callback = "set_sail";
			menuItem.data = "tundra";
			RegisterMenuItem(menuItem);
		}
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// |Store name|  |Item name|  	|Quantity| |cost%|   |Sell ratio|	|Bundle amt|
		AddStoreItem(STORE_NAME, "health_apple", 15, 100);
		AddStoreItem(STORE_NAME, "health_mpotion", 20, 100, 0);
		AddStoreItem(STORE_NAME, "mana_mpotion", 20, 100, 0);
		AddStoreItem(STORE_NAME, "drink_mead", 20, 100);
		AddStoreItem(STORE_NAME, "drink_ale", 20, 100);
		AddStoreItem(STORE_NAME, "drink_wine", 20, 100);
	}

	// say_hi
	void OnSayHi(CBasePlayer@ talkingPlayer = null)
	{
		if (SET_DESTINATION)
			return;
		if (MENU_OPEN)
			return;
		OpenMenu(EntityOf(ENT_LASTSPOKE));
	}

	// set_sail
	void OnSetSail(CBasePlayer@ value = null, string destination = "")
	{
		if (SET_DESTINATION)
			return;
		SET_DESTINATION = true;
		VENDOR_NOT_ON_USE = false;
		TRIGGER_OUT = destination + "_start";

		PlayAnim("once", "converse2");

		if (destination == "deralia")
			SayText("Ah yes, Deralia, jewel of Daragoth, ne're a safer port there be. Off we go!");
		if (destination == "ara")
			SayText("Hmm... I think I saw some orcs rowin' towards Ara. Don't be too surprised if we catch up with 'em.");
		if (destination == "isles")
			SayText("Isles of Dread? I'd charge extra for that, were I not already on the King's commission.");
		if (destination == "tundra")
			SayText("Brrrr... cold up there. Alright - just mind the orca when you step off!");

		// screenfade <target/"all"> <duration> <holdtime> <(r,g,b)> <alpha> <fadein|fadeout|noblend|perm>
		Effect("screenfade", "all", 4, 10, Vector3(1, 1, 1), 255, "fadeout");
		CallEventDelayed(10.0f, "delay_sailing");
	}

	// delay_sailing
	void OnDelaySailing()
	{
		Effect("screenfade", "all", 4, 0, Vector3(1, 1, 1), 255, "fadein");
		UseTrigger(TRIGGER_OUT);
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		SetMenuAutoOpen(true);
		MENU_OPEN = false;
	}

	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return Ron_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/human1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Ron_FirstThink();
		BaseNpcVendor_FirstThink();
		BaseNpcVendor_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "delay_sailing") { OnDelaySailing(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "say_hi") { OnSayHi(PlayerParam(params, 0)); return true; }
		if (name == "set_sail") { OnSetSail(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		return BaseNpcVendorScript::DispatchEvent(name, params);
	}
}
