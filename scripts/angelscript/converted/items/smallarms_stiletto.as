#pragma context server

// Converted from items/smallarms_stiletto.script by msc_transpiler.
// Stiletto

#include "runtime/ScriptEntity.as"
#include "converted/items/item_precache.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_stiletto"]
class SmallarmsStiletto : SmallarmsBaseScript, ItemPrecache
{
	// Constants
	string BASE_LEVEL_REQ = "3";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";
	string ANIM_PARRY = "6";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsStiletto()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 2;
		ANIM_UNWIELD = 3;
		ANIM_WIELDEDIDLE1 = 4;
		ANIM_ATTACK1 = "5";
		ANIM_ATTACK2 = "6";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "40";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 1.0f;
		MELEE_DMG = 140;
		MELEE_DMG_RANGE = 100;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "75%";
		MODEL_BODY_OFS = "4";
		ANIM_PREFIX = "dagger";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Stiletto");
		SetDescription("A pointed stiletto, taking advantage of exposed gaps on armored enemies");
		SetWeight(3);
		SetValue(30);
		SetHudSprite("trade", "169");
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlaySound(1, 10, "SOUND_HITMETAL1");

		PlayOwnerAnim("break");
		PlayViewAnim(Int(ANIM_PARRY));

		OnWeaponParry();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles2.mdl");
		Precache("poison_cloud.spr");
		Precache("laserbeam.spr");
		Precache("weapons/magic/seals.mdl");
		Precache("3dmflaora.spr");
		Precache("lgtning.spr");
		Precache("fire1_fixed.spr");
		Precache("null.mdl");
		Precache("xsmoke3.spr");
		Precache("weapons/p_weapons1.mdl");
		Precache("weapons/p_weapons2.mdl");
		Precache("weapons/p_weapons3.mdl");
		Precache("weapons/p_weapons4.mdl");
		Precache("glassgibs.mdl");
		Precache("weapons/projectiles.mdl");
		Precache("bigsmoke.spr");
		Precache("fire1_fixed2.spr");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ItemPrecache_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return ItemPrecache_DispatchEvent(name, params)
			|| SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
