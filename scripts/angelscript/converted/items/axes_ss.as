#pragma context server

// Converted from items/axes_ss.script by msc_transpiler.
// Skull Scythe (Vampyric + Dark + Range + Balance + Throw)
// get back to this after you have an xtossprojectile function

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"
#include "converted/items/base_vampire.as"

[script "items/axes_ss"]
class AxesSs : AxesBaseTwohandedScript, BaseVampire
{
	// Constants
	int RANGED_MP = 30;
	float THROW_ATTACK_DELAY = 0.5f;
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables (an unset .script variable reads as its own name)
	float NEXT_THROW_ATTEMPT = 0.0f;
	string SHADOW_PROJ_ID = "SHADOW_PROJ_ID";

	// Variables declared by included files, with the value they start with in this script
	AxesSs()
	{
		BASE_LEVEL_REQ = "30";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 7;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "74";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "120";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 450;
		MELEE_DMG_RANGE = 100;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// game_dodamage
	// Vampire
	string AxesSs_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;

		float healAmt = Float(ScriptVarOf(ENT_LASTSTRUCKBYME, "LAST_STRUCK_FOR"));
		healAmt = Divide(healAmt, 3.0f);

		OnTryVampireTarget(EntityOf(ENT_OWNER), target, Text(healAmt));
		return result;
	}

	// bweapon_effect_remove
	void OnBweaponEffectRemove(string reason = "")
	{
		BaseItemExtras_OnBweaponEffectRemove(reason); // items/base_item_extras
		DebugPrint("bweapon_effect_remove");
		OnReturnThrow("bweapon_effect_remove");
		SetViewModelProp(ENT_ME, "rendermode", 1);
		SetViewModelProp(ENT_ME, "renderamt", 255);
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Skull Scythe");
		SetDescription("A scythe imbued with magics of destruction");
		SetWeight(90);
		SetValue(700);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "145");
		OnCustomRegister();
	}

	// melee_start
	void OnMeleeStart()
	{
		BaseMelee_OnMeleeStart(); // items/base_melee
		OnReturnThrow("melee_start");
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee
		OnReturnThrow("special_01_start");
	}

	// special_02_start
	void OnSpecial02Start()
	{
		AxesBaseTwohanded_OnSpecial02Start(); // items/axes_base_twohanded
		OnReturnThrow("special_02_start");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return AxesSs_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// game_+attack2
	void OnGamePressAttack2()
	{
		bool exitSub = false;

		if (Truthy(Eval("game.item.attacking")))
			return;
		if (!CanAttack(ENT_OWNER))
			return;

		if (!(GameTime() > NEXT_THROW_ATTEMPT))
			return;
		NEXT_THROW_ATTEMPT = GameTime() + 1.0f;

		if (ManaOf(ENT_OWNER) < RANGED_MP)
		{
			PlayerMessageDark(ENT_OWNER, "Scull Scythe: Not enough mana to throw.");
			exitSub = true;
		}

		if (SkillOf(ENT_OWNER, "axehandling") < 34.0f)
		{
			PlayerMessageDark(ENT_OWNER, "Scull Scythe: Insufficient Axehandling Proficiency to throw (34)");
			exitSub = true;
		}

		if (exitSub)
			return;

		GiveMana(ENT_OWNER, -RANGED_MP);

		PlayItemViewAnim(ENT_ME, Int(ANIM_ATTACK2));

		CallEventDelayed(THROW_ATTACK_DELAY, "throw_weapon");
	}

	// throw_weapon
	void OnThrowWeapon()
	{
		SetViewModelProp(ENT_ME, "renderamt", 1);
		SetViewModelProp(ENT_ME, "rendermode", 1);
		if (Exists(SHADOW_PROJ_ID))
			OnReturnThrow("new_throw");

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		CallExternal(ENT_OWNER, "ext_tossprojectile", "proj_ss", "view", "none", 200, 100, 1, "axehandling"); // Converted to use new tossprojectile //greatguys1@FEB2022
		SHADOW_PROJ_ID = ScriptVarOf(ENT_OWNER, "PLR_LAST_PROJECTILE");
	}

	// ext_projectile_landed
	void OnExtProjectileLanded(string landingSource = "")
	{
		OnReturnThrow("ext_projectile_landed");
	}

	// return_throw
	void OnReturnThrow(string reason = "")
	{
		if (reason == "ext_projectile_landed")
			PlayItemViewAnim(ENT_ME, Int(ANIM_IDLE1));
		else if (Exists(SHADOW_PROJ_ID))
			CallExternal(SHADOW_PROJ_ID, "remove_me", "remote");
		if (reason == "new_throw")
			return;
		DebugPrint("return_throw " + reason + " (restore)");
		SetViewModelProp(ENT_ME, "rendermode", 1);
		SetViewModelProp(ENT_ME, "renderamt", 255);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnThrowAttackDelay() {} // THROW_ATTACK_DELAY
	void OnCustomRegister() {} // custom_register

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_2haxesgreat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bweapon_effect_remove") { OnBweaponEffectRemove(Param(params, 0)); return true; }
		if (name == "ext_projectile_landed") { OnExtProjectileLanded(Param(params, 0)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "melee_start") { OnMeleeStart(); return true; }
		if (name == "return_throw") { OnReturnThrow(Param(params, 0)); return true; }
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "special_02_start") { OnSpecial02Start(); return true; }
		if (name == "throw_weapon") { OnThrowWeapon(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseVampire_DispatchEvent(name, params)
			|| AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
