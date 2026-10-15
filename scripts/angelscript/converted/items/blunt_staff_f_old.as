#pragma context server

// Converted from items/blunt_staff_f_old.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_elemental_resist.as"
#include "converted/items/blunt_base_twohanded.as"

[script "items/blunt_staff_f_old"]
class BluntStaffFOld : BluntBaseTwohandedScript, BaseElementalResist
{
	// Constants
	string BASE_LEVEL_REQ = "30";
	string ELM_NAME = "phlame";
	string ELM_TYPE = "cold";
	float ELM_AMT = 20.0f;
	bool ELM_WEAPON = true;
	int MODEL_VIEW_IDX = 12;

	// Variables declared by included files, with the value they start with in this script
	BluntStaffFOld()
	{
		MELEE_RANGE = "110";
		MELEE_DMG_DELAY = 0.4f;
		MELEE_ATK_DURATION = 1.0f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 300;
		MELEE_DMG_RANGE = 20;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_AUGMENT = "20%";
		MELEE_DMG_TYPE = "fire";
		MELEE_STAT = "spellcasting.fire";
		MODEL_VIEW = "viewmodels/v_2hblunts.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "standard";
		PLAYERANIM_AIM = "sword_double_idle";
		PLAYERANIM_SWING = "pole_swing";
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee

		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;
		OnClRefreshLoop();
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded
		BluntBaseTwohanded_OnWeaponSpawn(); // items/blunt_base_twohanded

		SetName("Phlame's Staff");
		SetDescription("A demonic staff of fire");
		SetWeight(60);
		SetValue(7000);
		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "52");
	}

	// cl_refresh_loop
	void OnClRefreshLoop()
	{
		bool bewIsWeilded = false;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_LEFT_HAND"))
			bewIsWeilded = true;
		if (EntityId(self) == ScriptVarOf(ENT_OWNER, "PLR_RIGHT_HAND"))
			bewIsWeilded = true;
		// if ( !$get(ent_owner,isalive) ) local BEW_IS_WEILDED 0
		if (bewIsWeilded)
		{
			ClientEvent("update", ENT_OWNER, Eval("const.localplayer.scriptID"), "phlames_viewfinder_on", IndexOf(ENT_OWNER));
			CallEventDelayed(5.0f, "cl_refresh_loop");
		}
		else
		{
			ClientEvent("update", ENT_OWNER, Eval("const.localplayer.scriptID"), "phlames_viewfinder_off");
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
	}

	// game_drop
	void OnGameDrop()
	{
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseItem_OnGameDrop(); // items/base_item
	}

	// game_remove
	void OnGameRemove()
	{
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
	}

	// game_fall
	void OnGameFall()
	{
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseWeapon_OnGameSheath(); // items/base_weapon
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseMelee_OnGameWear(race, gender, source); // items/base_melee
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2hblunts.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseElementalResist_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cl_refresh_loop") { OnClRefreshLoop(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| BluntBaseTwohandedScript::DispatchEvent(name, params);
	}
}
