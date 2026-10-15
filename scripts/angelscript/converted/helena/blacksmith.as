#pragma context server

// Converted from helena/blacksmith.script by msc_transpiler.
// Blacksmith - Dorfgan fights back

#include "runtime/ScriptEntity.as"
#include "converted/NPCs/human_guard_sword.as"
#include "converted/helena/helena_npc.as"
#include "converted/monsters/base_chat.as"
#include "converted/monsters/base_npc_vendor.as"
#include "converted/monsters/base_npc_vendor_confirm.as"

[script "helena/blacksmith"]
class HelenaBlacksmith : HumanGuardSwordScript, HelenaNpc, BaseChat, BaseNpcVendor, FirstVendor, BaseNpcVendorConfirm
{
	// Variables declared by included files, with the value they start with in this script
	HelenaBlacksmith()
	{
		CUSTOM_GUARD = true;
		BG_MAX_HEAR_CIV = 400;
		NO_CHAT = true;
		VEND_ARMORER = true;
		HAS_BASE_CHAT_INCLUDE = true; // from monsters/base_chat
		CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;"; // from monsters/base_chat
		CHAT_DELAY = 3.0f; // from monsters/base_chat
		RQUEST_NAMES = "0;Galan;Narad;Darrelin;Rudolf;Vadrel;Edrin;Thordac;Slinker;Slinker;Gerald;Mosor;Cathain;"; // from monsters/base_chat
		HAS_INCLUDE_VENDOR = true; // from monsters/base_npc_vendor
		STORE_RESTOCK = true; // from monsters/base_npc_vendor
		STORE_RESTOCK_TIME_LO = 300; // from monsters/base_npc_vendor
		STORE_RESTOCK_TIME_HI = 600; // from monsters/base_npc_vendor
		BUSY_COMMENT = "One at a time, please."; // from monsters/base_npc_vendor
		HAS_INCLUDE_VENDOR_CONFIRM = true; // from monsters/base_npc_vendor_confirm
		FREQ_HINT_TEXT = 120.0f; // from monsters/base_npc_vendor_confirm
	}

	// unnamed block (first think)
	void HelenaBlacksmith_FirstThink()
	{
		ANIM_DEATH = "dieforward";
		ANIM_ATTACK = "beatdoor";
		MADE_IT_HOME = true;

		COUNT = 0.0f;
		REST = 10.0f;

		DELAY = 1.05f;

		STORE_NAME = "helena_bs";
		STORE_SELLMENU = true;

		STORE_TRIGGERTEXT = "store trade buy sell purchase sale offer";
		STORE_NAME = "helena_general_store";
		CANCHAT = 1;
		OVERCHARGE = "150%";

		ANIM_DEATH = "dieforward";
		SELL_WEAPON_LEVEL = "6,12";
	}

	// unnamed block (timer)
	void HelenaBlacksmith_Timer()
	{
		CallEventDelayed(DELAY, "HelenaBlacksmith_Timer");

		if (!MADE_IT_HOME)
			return;
		if (COUNT < 8.0f)
		{
			PlayAnim("critical", "smith_hammer_time");
			COUNT += 1.0f;
		}

		if (COUNT == 8.0f && REST > 0.0f)
		{
			if (DELAY == 8.36f)
			{
				PlayAnim("critical", "smith_hammer_look");
				COUNT = 0.0f;
				DELAY = 1.05f;
				REST -= 1.0f;
			}
			else
			{
				DELAY = 8.36f;
			}
		}

		if (REST == 0.0f)
		{
			if (DELAY == 10.86f)
			{
				PlayAnim("critical", "smith_hammer_idle");
				REST = 10.0f;
				COUNT = 0.0f;
				DELAY = 1.05f;
			}
			else
			{
				DELAY = 10.86f;
			}
		}
	}

	// unnamed block (timer)
	void HelenaBlacksmith_Timer2()
	{
		CallEventDelayed(1.0f, "HelenaBlacksmith_Timer2");

		// attack hack
		if (!IsAlive(ENT_ME))
			return;

		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_RANGE))
			return;
		PlayAnim("once", ANIM_ATTACK);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), "20.0", "80%", "blunt");

		if (!CanSee("enemy"))
			return;
		OnNpcatkSetmovedest(ENT_LASTSEEN, "32");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseGuardFriendlyNew_OnNpcSpawn(npc); // monsters/base_guard_friendly_new
		HumanGuardSword_OnNpcSpawn(npc); // NPCs/human_guard_sword
		BaseNpcVendor_OnNpcSpawn(npc); // monsters/base_npc_vendor

		SetHealth(550);
		SetName("Dorfgan");
		SetWidth(20);
		SetHeight(72);
		SetRoam(false);
		SetRace("hguard");
		SetModel("npc/blacksmith.mdl");
		SetModelBody(0, 1);
		SetModelBody(1, 2);
		SetIdleAnim("smith_hammer_time");
		SetAngle("face", Vector3(0, -180, 0));
	}

	// baseguard_tobattle
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		BaseGuardFriendlyNew_OnBaseguardTobattle(enemy); // monsters/base_guard_friendly_new
		HumanGuardSword_OnBaseguardTobattle(enemy); // NPCs/human_guard_sword

		SetModelBody(0, 0);
		SetModelBody(1, 0);

		SetIdleAnim("idle1");

		// close shop
		SetMenuAutoOpen(false);
		STORE_CLOSED = 1;
	}

	// going_home
	void OnGoingHome(string phase = "")
	{
		BaseGuardFriendlyNew_OnGoingHome(phase); // monsters/base_guard_friendly_new

		CallEventDelayed(30.0f, "check_at_home");
	}

	// basevendor_offerstore
	void OnBasevendorOfferstore(string target = "")
	{
		HelenaNpc_OnBasevendorOfferstore(target); // helena/helena_npc
		BaseNpcVendor_OnBasevendorOfferstore(target); // monsters/base_npc_vendor
		if (HELENA_SAVED)
			return;
		SayText("I'll buy any good animal skins you have as well.");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		BaseChat_OnGameMenuGetoptions(player); // monsters/base_chat
		BaseNpcVendor_OnGameMenuGetoptions(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameMenuGetoptions(player); // monsters/base_npc_vendor_confirm
		MenuItem menuItem;
		if (!Truthy(ItemExists(player, "smallarms_rd")))
			return;
		menuItem.title = "About Rusted Dagger";
		menuItem.type = "callback";
		menuItem.callback = "dagger_chat";
		RegisterMenuItem(menuItem);
	}

	// game_playerused
	void OnGamePlayerused(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnGamePlayerused(player); // monsters/base_npc_vendor
		if (!Truthy(ItemExists(player, "smallarms_rd")))
			return;

		if (!(GameTime() > NEXT_DAGGER_CHAT))
			return;
		NEXT_DAGGER_CHAT = GameTime() + 60.0f;
		OnDaggerChat();
	}

	// trade_success
	void OnTradeSuccess()
	{
		BaseNpcVendor_OnTradeSuccess(); // monsters/base_npc_vendor

		if (CANCHAT != 1)
			return;

		Say("goods[.56]", "[.4]", "[.58]", "[.66]");
		CANCHAT = 0;
	}

	// hammer_sound
	void OnHammerSound()
	{
		PlaySound(0, 10, "amb/fx_anvil.wav");
	}

	// npc_death
	void OnNpcDeath()
	{
		SetModelBody(0, 0);
		SetModelBody(1, 0);
	}

	// helena_flee
	void OnHelenaFlee(CBaseEntity@ attacker = null)
	{
	}

	// helena_raid_end
	// called by helena/helena when all bad guys are dead
	void OnHelenaRaidEnd()
	{
		HELENA_SAVED = true;
	}

	// check_at_home
	void OnCheckAtHome()
	{
		if (MADE_IT_HOME)
			return;
		SetOrigin(ENT_ME, MY_GUARD_POST);
		SetAngle("face", Vector3(0, HOME_YAW, 0));
	}

	// baseguard_made_it_home
	void OnBaseguardMadeItHome()
	{
		SetModelBody(0, 1);
		SetModelBody(1, 2);
		SetIdleAnim("smith_hammer_time");

		if (HELENA_SAVED)
		{
			// re-open store at reduced prices
			LegacyCommand("npcstore.remove", STORE_NAME, "allitems");
			OVERCHARGE = "75%";
			SELL_RATIO = 1.0f;
			OnVendorAddstoreitems();
		}

		SetMenuAutoOpen(true);
		STORE_CLOSED = 0;
	}

	// vendor_addstoreitems
	void OnVendorAddstoreitems()
	{
		// from edana/armorer
		// |Store name|   |Item name|	       |Quantity|	|cost| |Sell ratio|
		AddStoreItem(STORE_NAME, "skin_ratpelt", 0, 100, 1.0f);
		AddStoreItem(STORE_NAME, "skin_boar", 0, 100, 1.0f);
		AddStoreItem(STORE_NAME, "skin_boar_heavy", 0, 100, 1.0f);
		AddStoreItem(STORE_NAME, "skin_bear", 0, 100, 1.0f);

		AddStoreItem(STORE_NAME, "armor_leather_torn", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather", RandomInt(1, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_leather_studded", RandomInt(0, 1), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_plate", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_plate", RandomInt(0, 2), OVERCHARGE, SELL_RATIO);
		AddStoreItem(STORE_NAME, "shields_ironshield", RandomInt(0, 3), OVERCHARGE, 0.25f);
		AddStoreItem(STORE_NAME, "shields_buckler", RandomInt(0, 3), OVERCHARGE, SELL_RATIO);

		AddStoreItem(STORE_NAME, "armor_golden", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_golden", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_dark", 0, 100, SELL_RATIO);
		AddStoreItem(STORE_NAME, "armor_helm_dark", 0, 100, SELL_RATIO);
	}

	// helena_raid_go
	// called by helena/helena when bad guys come to down
	void OnHelenaRaidGo()
	{
		OnBaseguardTobattle();
	}

	// npcatk_ally_alert
	void OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
	{
	}

	// dagger_chat
	void OnDaggerChat()
	{
		if (BUSY_CHATTING)
			CallEventDelayed(1.0f, "dagger_chat");
		if (BUSY_CHATTING)
			return;
		CHAT_STEP1 = "Oh wow, I think that rusted dagger you have there might be one of those ancient ether daggers.";
		CHAT_STEP2 = "Back in the Age of Blood, some of the elvish armies used those. The blade passes through armor as if it weren't even there.";
		CHAT_STEP3 = "I wish I could fix it up for you, but alas, my elbow joints can't take that kind of stress anymore.";
		CHAT_STEP4 = "If only I was young again...";
		CHAT_STEPS = 4;
		OnChatLoop();
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
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseChat_OnGameSpawn(playerRace, playerGender); // monsters/base_chat
		BaseNpcVendor_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnGameSpawn(playerRace, playerGender); // monsters/base_npc_vendor_confirm
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseGuardFriendlyNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_guard_friendly_new
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4); // helena/helena_npc
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		HelenaNpc_OnGameHeardsound(soundType, origin, dangerRadius); // helena/helena_npc
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

	// vendor_offerstore
	void OnVendorOfferstore(CBasePlayer@ player = null)
	{
		BaseNpcVendor_OnVendorOfferstore(player); // monsters/base_npc_vendor
		BaseNpcVendorConfirm_OnVendorOfferstore(player); // monsters/base_npc_vendor_confirm
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/guard1.mdl");
		Precache("npc/blacksmith.mdl");
		Precache("npc/goods.wav");
		CallEventDelayed(DELAY, "HelenaBlacksmith_Timer");
		CallEventDelayed(1.0f, "HelenaBlacksmith_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HumanGuardSword_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseGuardFriendlyNew_FirstThink();
		HelenaBlacksmith_FirstThink();
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
		if (name == "baseguard_made_it_home") { OnBaseguardMadeItHome(); return true; }
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "check_at_home") { OnCheckAtHome(); return true; }
		if (name == "dagger_chat") { OnDaggerChat(); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_playerused") { OnGamePlayerused(PlayerParam(params, 0)); return true; }
		if (name == "going_home") { OnGoingHome(Param(params, 0)); return true; }
		if (name == "hammer_sound") { OnHammerSound(); return true; }
		if (name == "helena_flee") { OnHelenaFlee(EntityParam(params, 0)); return true; }
		if (name == "helena_raid_end") { OnHelenaRaidEnd(); return true; }
		if (name == "helena_raid_go") { OnHelenaRaidGo(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_ally_alert") { OnNpcatkAllyAlert(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "trade_success") { OnTradeSuccess(); return true; }
		if (name == "vendor_addstoreitems") { OnVendorAddstoreitems(); return true; }
		if (name == "HelenaBlacksmith_Timer") { HelenaBlacksmith_Timer(); return true; }
		if (name == "HelenaBlacksmith_Timer2") { HelenaBlacksmith_Timer2(); return true; }
		return HelenaNpc_DispatchEvent(name, params)
			|| BaseChat_DispatchEvent(name, params)
			|| BaseNpcVendor_DispatchEvent(name, params)
			|| FirstVendor_DispatchEvent(name, params)
			|| BaseNpcVendorConfirm_DispatchEvent(name, params)
			|| HumanGuardSwordScript::DispatchEvent(name, params);
	}
}
