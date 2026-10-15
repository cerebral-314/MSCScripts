#pragma context server

// Converted from items/smallarms_bone_blade.script by msc_transpiler.
// Boneblade by Thothie, from Sharp Finely crafted knife
// - Vampyric regen, up to 20hp or 1/5th damage

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"
#include "converted/items/base_varied_attacks.as"
#include "converted/items/base_vampire.as"

[script "items/smallarms_bone_blade"]
class SmallarmsBoneBlade : SmallarmsBaseScript, BaseVariedAttacks, BaseVampire
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	string MELEE_ALIGN_BASE = "4,-6";
	string MELEE_ALIGN_TIP = "0,6";

	// Variables (an unset .script variable reads as its own name)
	int SWING_ANIM = 0;

	// Variables declared by included files, with the value they start with in this script
	SmallarmsBoneBlade()
	{
		MELEE_DMG = 180;
		MELEE_DMG_RANGE = 70;
		MELEE_RANGE = "35";
		MELEE_ACCURACY = "77%";
		MODEL_VIEW = "viewmodels/v_1hswordssb.mdl";
		MODEL_VIEW_IDX = 7;
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 0;
		ANIM_UNWIELD = 0;
		ANIM_WIELDEDIDLE1 = 1;
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_PARRY_CHANCE = "30%";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "khopesh";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string SmallarmsBoneBlade_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// would use game_damaged_other, but doesnt return proper when used in weapons
		if (!hit)
			return result;

		float healAmt = Float(ScriptVarOf(ENT_LASTSTRUCKBYME, "LAST_STRUCK_FOR"));
		healAmt = Divide(healAmt, 5.0f);
		if (healAmt > 20.0f)
			healAmt = 20.0f;

		Effect("glow", ENT_OWNER, Vector3(0, 100, 0), 60, 1, 1);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(healAmt));
		return result;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Bone Blade");
		SetDescription("A wicked blade of cursed bone");
		SetWeight(3);
		SetValue(1000);
		SetHudSprite("hand", "106");
		SetHudSprite("trade", "106");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsBoneBlade_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// melee_start
	void OnMeleeStart()
	{
		PlaySound(1, 10, SOUND_SWIPE);

		PlayOwnerAnim("once", "sword_swing"); // global.anim.combatwalk 3
		OnCheckAttackAnim();
		SWING_ANIM = CUR_ATTACK_ANIM;
		PlayItemViewAnim(ENT_ME, SWING_ANIM);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_1hswordssb.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVariedAttacks_DispatchEvent(name, params)
			|| BaseVampire_DispatchEvent(name, params)
			|| SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
