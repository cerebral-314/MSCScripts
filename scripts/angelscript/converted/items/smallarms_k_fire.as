#pragma context server

// Converted from items/smallarms_k_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

[script "items/smallarms_k_fire"]
class SmallarmsKFire : SmallarmsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "15";
	bool CUSTOM_REGISTER_CHARGE1 = true;
	bool CUSTOM_REGISTER_SECONDARY = true;
	string RANGED_ATK_DURATION = "0.1s";
	string RANGED_DMG_TYPE = "fire";
	string RANGED_STAT = "smallarms";
	string RANGED_PROJECTILE = "proj_k_knife";
	Vector3 RANGED_AIMANGLE = Vector3();
	Vector3 RANGED_STARTPOS = Vector3();
	float RANGED_PULLTIME = 0.1f;
	string SOUND_RETURN = "weapons/dagger/dagger2.wav";
	string EFFECT_TYPE = "effects/dot_fire";
	string EFFECT_SKILL = "skill.spellcasting.fire";
	string EFFECT_DURATION = "5";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";

	// Variables (an unset .script variable reads as its own name)
	bool KNIFE_RESTORED = false;

	// Variables declared by included files, with the value they start with in this script
	SmallarmsKFire()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_VIEW_IDX = 5;
		ANIM_LIFT1 = 0;
		ANIM_IDLE1 = "1";
		ANIM_WIELD = 2;
		ANIM_UNWIELD = 3;
		ANIM_WIELDEDIDLE1 = 4;
		ANIM_ATTACK1 = "5";
		ANIM_ATTACK2 = "6";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 225;
		MELEE_DMG_RANGE = 75;
		MELEE_ACCURACY = "80%";
		MELEE_PARRY_CHANCE = "25%";
		SOUND_HITWALL2 = "ambience/steamburst1.wav";
		MODEL_BODY_OFS = "32";
		ANIM_PREFIX = "firedagger";
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string SmallarmsKFire_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (!hit)
			return result;

		if (RandomInt(1, 5) != 1)
			return result;

		float burnDamage = Float(GetProp(ENT_OWNER, EFFECT_SKILL));
		burnDamage = Divide(burnDamage, 3.0f);
		burnDamage += Random(1, 3);
		if (burnDamage < 5.0f)
			burnDamage = 5.0f;
		if (IsPlayer(target) && (IsPvp() ? 1 : 0) < 1)
			exitSub = true;
		if (exitSub)
			return result;

		ApplyEffect(target, EFFECT_TYPE, EFFECT_DURATION, @EntityOf(ENT_OWNER), burnDamage, "smallarms");
		return result;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseMelee_OnGameDeploy(); // items/base_melee
		SmallarmsBase_OnGameDeploy(); // items/smallarms_base
		CallExternal(ENT_OWNER, "ext_set_alco_type", "fire", self);
	}

	// weapon_spawn
	// Called whenever the dagger spawns
	// Setup the basic info specific to this weapon
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base

		SetName("Kharaztorant Fire Blade");
		SetDescription("A enchanted throwing knife used by the Kharaztorant cult");
		SetWeight(3);
		SetValue(800);
		SetHudSprite("trade", "107");
	}

	// register_charge1
	void OnRegisterCharge1()
	{
		BaseMelee_OnRegisterCharge1(); // items/base_melee

		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.dmg.type", "fire");
		SetLocal("reg.attack.energydrain", MELEE_ENERGY);
		SetLocal("reg.attack.stat", "smallarms");
		SetLocal("reg.attack.noise", MELEE_NOISE);
		SetLocal("reg.attack.mpdrain", 0);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.projectile", "proj_k_knife");

		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.hold_min&max", "0.1;0.1");
		SetLocal("reg.attack.dmg.type", "fire");
		SetLocal("reg.attack.range", 600); // projectile speed
		SetLocal("reg.attack.COF", 0);
		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.delay.strike", 0.1f);
		SetLocal("reg.attack.delay.end", 0.1f);
		SetLocal("reg.attack.ofs.startpos", RANGED_STARTPOS);
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);

		SetLocal("reg.attack.priority", 1);
		SetLocal("reg.attack.keys", "-attack1");
		SetLocal("reg.attack.callback", "tossknife");
		SetLocal("reg.attack.chargeamt", "100%");
		SetLocal("reg.attack.reqskill", 17);
		RegisterAttack();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		SmallarmsBase_OnMeleeStart(); // items/smallarms_base
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		KNIFE_RESTORED = true;
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return SmallarmsKFire_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// tossknife_start
	void OnTossknifeStart()
	{
		SetModel("none");
		SetWorldModel("none");
		SetViewModel("none");
		PlayViewAnim(4);
		KNIFE_RESTORED = false;

		PlaySound(0, 8, ScriptVarOf(ENT_OWNER, "PLR_SOUND_JAB2"));
		CallEventDelayed(0.1f, "lock_weapon");
		// (never true here, the rest is skipped) if game.clientside
	}

	// lock_weapon
	void OnLockWeapon()
	{
		ApplyEffect(ENT_OWNER, "effects/effect_templock");

		CallEventDelayed(0.25f, "knife_return");
	}

	// tossknife_strike
	void OnTossknifeStrike(string hitType = "", Vector3 endPos = Vector3(), CBaseEntity@ hitEntity = null, bool hit = false)
	{
		PlayOwnerAnim("critical", "bow_release");
	}

	// knife_return
	// called externally from projectile or one second after throw
	void OnKnifeReturn()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);

		PlaySound(2, 8, SOUND_RETURN);

		CallExternal(ENT_OWNER, "ext_end_templock");
	}

	// knife_restore_cl
	void OnKnifeRestoreCl()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_WORLD);
		SetWorldModel(MODEL_WORLD);
		if (KNIFE_RESTORED)
			return;
		PlayViewAnim(ANIM_LIFT1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "knife_restore_cl") { OnKnifeRestoreCl(); return true; }
		if (name == "knife_return") { OnKnifeReturn(); return true; }
		if (name == "lock_weapon") { OnLockWeapon(); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "register_charge1") { OnRegisterCharge1(); return true; }
		if (name == "tossknife_start") { OnTossknifeStart(); return true; }
		if (name == "tossknife_strike") { OnTossknifeStrike(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2), Truthy(Param(params, 3))); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
