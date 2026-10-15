#pragma context server

// Converted from items/swords_gb.script by msc_transpiler.
// The Gut Buster
// This sickly sword thrives on flesh.
// By greatguys1 and Darkfox
// ----------
// The Gut Buster is a two-handed massive sword that has a taste for blood. Chopping limbs off of your foe causes them
// to bleed, and cause the chunk of flesh to burst, damaging and bleeding other nearby enemies. Finishing off enemies
// that are bleeding causes various innards to burst out, also exploding, damaging and bleeding nearby enemies.
// ----------

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_gb"]
class SwordsGb : SwordsBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "37";
	int MODEL_VIEW_IDX = 10;
	int PMODEL_IDX_FLOOR = 63;
	string SOUND_SHOUT = "SOUND_SHOUT";
	bool SWORD_MANUAL_PARRY = false;
	string DOT_DAMAGE = "DOT_DAMAGE";
	string GIB_EXPLODE_DAMAGE = "GIB_EXPLODE_DAMAGE";

	// Variables (an unset .script variable reads as its own name)
	string POTENTIALLY_INACCURATE_GIB_DAMAGE = "POTENTIALLY_INACCURATE_GIB_DAMAGE";

	// Variables declared by included files, with the value they start with in this script
	SwordsGb()
	{
		ANIM_ATTACK2 = "2";
		ANIM_ATTACK3 = "2";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_HANDS = "weapons/p_weapons4.mdl";
		MODEL_WORLD = "weapons/p_weapons4.mdl";
		MODEL_BODY_OFS = "62";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		ANIM_PREFIX = "standard";
		PLAYERANIM_AIM = "axe_twohand";
		PLAYERANIM_SWING = "axe_twohand_swing";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.4f;
		MELEE_ENERGY = 10.0f;
		MELEE_DMG = 540;
		MELEE_DMG_RANGE = 150;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "15%";
	}

	// func_dot_damage
	// Dot damage calculation
	string SwordsGb_OnFuncDotDamage()
	{
		string result = "";

		float dmg = SkillOf(ENT_OWNER, "swordsmanship") - Float(BASE_LEVEL_REQ); // Get resulting levels left
		dmg = dmg * 4.0f; // Resulting level * 2 will give the dmg buff for surpassed level
		dmg = dmg + 55.0f; // Add the base dmg

		result = "";
		result = AppendResult(result, Text(dmg));
		return result;
	}

	// func_gib_damage
	// gib damage calculation
	string SwordsGb_OnFuncGibDamage()
	{
		string result = "";

		float dmg = SkillOf(ENT_OWNER, "swordsmanship") * 2.75f;

		POTENTIALLY_INACCURATE_GIB_DAMAGE = Text(dmg);

		result = "";
		result = AppendResult(result, Text(dmg));
		return result;
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall(); // items/base_weapon

		SetModelBody(0, PMODEL_IDX_FLOOR);
	}

	// weapon_spawn
	// Yeah, I know this is one handed... but the two handed swords base isn't pretty :(
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Gut Buster");
		SetDescription("The sickly sword thrives on flesh.");
		SetWeight(90);
		SetValue(2500);
		SetHudSprite("trade", "199");
		SetHand("both");
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee

		PlayViewAnim(8);
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// weapon_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type PARAM4=dmgevent
	void OnWeaponDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		if (BITEM_UNDERSKILLED)
			return;
		if (!(damage > 0.0f))
			return;

		// check if we're actually allowed to damage the target through some vars. this needs to be centralized somehow.
		if (Truthy(ScriptVarOf(target, "I_R_COMPANION"))) // companions shouldnt be damaged
			return;
		if (Truthy(ScriptVarOf(target, "NPC_NO_PLAYER_DMG"))) // those flagged no dmg should not be damaged
			return;

		// Apply the special gut buster effect that creates additional gibs on death
		OnInflictBleed(FindEntity(EntityId(target)));

		string blood = GetProp(target, "blood");
		if (blood == "none")
			return;

		string sound = "leech/leech_bite" + RandomInt(1, 2) + ".wav";
		PlaySound(0, 10, sound);

		// Throw a single gib
		Vector3 vel = RelativeVelocity(ViewAnglesOf(ENT_OWNER), Vector3(-35, 50, 350));
		// <owner> <velocity> <damage> <skill> <"green"|"red"> <sword_id>
		CreateNpc("effects/swords_gb/gb_gib_explode", OriginOf(target), @EntityOf(ENT_OWNER), vel, GIB_EXPLODE_DAMAGE, "swordsmanship", blood, self);
	}

	// gib_dodamage
	// Called from effects/swords_gb/gb_gib_explode
	void OnGibDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!Truthy(damageText))
			return;
		// <duration> <attacker> <damage> [activeSkill] [dmg type]
		OnInflictBleed(FindEntity(EntityId(target))); // Apply the special gut buster effect that creates additional gibs on death
	}

	// inflict_bleed
	// <target> //Apply the special gut buster effect that creates additional gibs on death
	void OnInflictBleed(CBaseEntity@ target = null)
	{
		string blood = GetProp(target, "blood");
		if (blood == "none")
			return;

		// <duration> <attacker> <damage> <activeSkill> <sword_id>
		ApplyEffect(target, "effects/swords_gb/gut_buster", 5, @EntityOf(ENT_OWNER), DOT_DAMAGE, "swordsmanship", self);
	}

	string OnFuncDotDamage() { return SwordsGb_OnFuncDotDamage(); } // func_dot_damage

	string OnFuncGibDamage() { return SwordsGb_OnFuncGibDamage(); } // func_gib_damage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons4.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
		Precache("gib_b_bone.mdl");
		Precache("gib_b_gib.mdl");
		Precache("gib_lung.mdl");
		Precache("gib_legbone.mdl");
		Precache("agibs.mdl");
		Precache("bloodspray.spr");
		Precache("char_breath.spr");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "func_dot_damage") { Return(OnFuncDotDamage()); return true; }
		if (name == "func_gib_damage") { Return(OnFuncGibDamage()); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "gib_dodamage") { OnGibDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "inflict_bleed") { OnInflictBleed(EntityParam(params, 0)); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_damaged_other") { OnWeaponDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
