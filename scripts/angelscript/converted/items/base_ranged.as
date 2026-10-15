#pragma context server

// Converted from items/base_ranged.script by msc_transpiler.
// Basic Ranged Weapon
// REQ:
// MODEL_VIEW
// MODEL_HANDS
// RANGED_FORCE, RANGED_DMG, RANGED_DMG_RANGE, RANGED_DMG_TYPE
// RANGED_ENERGY, RANGED_STAT, RANGED_ACCURACY, RANGED_PROJECTILE
// RANGED_DMG_DELAY, RANGED_STARTPOS, RANGED_AIMANGLE, RANGED_NOISE

#include "runtime/ScriptEntity.as"
#include "converted/items/base_weapon.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseRanged
{
	// Constants
	bool NO_PARRY = true;
	int RANGED_NOISE = 650;
	string RANGED_DMG_TYPE = "pierce";

	// Variables (an unset .script variable reads as its own name)
	string WEAPON_PRIMARY_SKILL = "WEAPON_PRIMARY_SKILL";
	float WEAPON_DMG_MULTI = 0.0f;
	bool UNDER_SKILLED = false;

	// weapon_spawn
	// Normal swing attack
	void BaseRanged_OnWeaponSpawn()
	{
		if (Truthy(GetVar("CUSTOM_ATTACK")))
			return;

		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", RANGED_HOLD_MINMAX);
		SetLocal("reg.attack.dmg.type", RANGED_DMG_TYPE);
		SetLocal("reg.attack.dmg.multi", GetVar("RANGED_DMG_MULTI"));
		SetLocal("reg.attack.range", GetVar("RANGED_FORCE"));
		SetLocal("reg.attack.energydrain", GetVar("RANGED_ENERGY"));
		SetLocal("reg.attack.stat", RANGED_STAT);
		SetLocal("reg.attack.COF", GetVar("RANGED_ACCURACY"));
		SetLocal("reg.attack.projectile", RANGED_PROJECTILE);
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", GetVar("RANGED_DMG_DELAY"));
		SetLocal("reg.attack.delay.end", RANGED_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", "RANGED_STARTPOS");
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", RANGED_NOISE);

		WEAPON_PRIMARY_SKILL = "reg.attack.stat";
		WEAPON_DMG_MULTI = Float(GetVar("RANGED_DMG_MULTI"));

		RegisterAttack();
	}

	// game_dodamage
	string BaseRanged_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		return result;
	}

	// game_deploy
	void BaseRanged_OnGameDeploy()
	{
		if (!Truthy(ScriptVarOf(ENT_OWNER, "PLR_IN_WORLD")))
			return;

		CallEventDelayed(0.1f, "skill_check");
	}

	// skill_check
	void BaseRanged_OnSkillCheck()
	{
		string findMeleeStat = "skill." + RANGED_STAT;
		DebugPrint("game_deploy " + GetProp(ENT_OWNER, findMeleeStat) + " " + findMeleeStat + " " + GetVar("BASE_LEVEL_REQ"));
		if (Float(GetProp(ENT_OWNER, findMeleeStat)) < Float(GetVar("BASE_LEVEL_REQ")))
		{
			PlayerMessageDark(ENT_OWNER, "You lack the skill to properly wield this weapon!");
			string outStr = "You lack the proficiency to wield this weapon. ( requires: " + RANGED_STAT;
			outStr += " proficiency " + GetVar("BASE_LEVEL_REQ") + " )";
			InfoMessage(ENT_OWNER, "Insufficient Skill", outStr);
			SetAttackProp(ENT_ME, 0, "COF.l", 40);
			SetAttackProp(ENT_ME, 0, "COF.r", 40);
			SetAttackProp(ENT_ME, 0, "dmg.multi", 0.1f);
			SetAttackProp(ENT_ME, 1, "COF.l", 40);
			SetAttackProp(ENT_ME, 1, "COF.r", 40);
			SetAttackProp(ENT_ME, 1, "dmg.multi", 0.1f);
			WEAPON_DMG_MULTI = 0.1f;
			UNDER_SKILLED = true;
			DebugPrint("skill_check Underskilled");
			OnBowUnderskilled();
		}
		else
		{
			if (UNDER_SKILLED)
			{
				DebugPrint("skill_check ResetToNorm");
				SetAttackProp(ENT_ME, 0, "COF.l", RANGED_HOLD_MINMAX);
				SetAttackProp(ENT_ME, 0, "COF.r", RANGED_HOLD_MINMAX);
				SetAttackProp(ENT_ME, 0, "dmg.multi", GetVar("RANGED_DMG_MULTI"));
				SetAttackProp(ENT_ME, 1, "COF.l", RANGED_HOLD_MINMAX);
				SetAttackProp(ENT_ME, 1, "COF.r", RANGED_HOLD_MINMAX);
				SetAttackProp(ENT_ME, 1, "dmg.multi", GetVar("RANGED_DMG_MULTI"));
				WEAPON_DMG_MULTI = Float(GetVar("RANGED_DMG_MULTI"));
				UNDER_SKILLED = false;
				OnBowUnderskilledRestore();
			}
			UNDER_SKILLED = false; // redundant
			DebugPrint("skill_check restore");
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy(); // items/base_weapon
		BaseWeapon_OnGameDeploy_2(); // items/base_weapon
		BaseRanged_OnGameDeploy();
	}

	void OnWeaponSpawn() { BaseRanged_OnWeaponSpawn(); } // weapon_spawn
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseRanged_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnSkillCheck() { BaseRanged_OnSkillCheck(); } // skill_check
	void OnBowUnderskilled() {} // bow_underskilled
	void OnBowUnderskilledRestore() {} // bow_underskilled_restore

	// This file's events and timers by their .script names
	bool BaseRanged_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "skill_check") { OnSkillCheck(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_ranged"]
shared class BaseRangedScript : BaseWeaponScript, BaseRanged
{
	// Variables every script that includes this file declares
	string ANIM_DEPLOY = "ANIM_DEPLOY";
	string ANIM_FIRE = "ANIM_FIRE";
	string ANIM_PREFIX = "ANIM_PREFIX";
	int ANIM_STRETCH = 0;
	bool IS_BOW = false;
	string ITEM_NAME = "ITEM_NAME";
	string MODEL_BODY_OFS = "MODEL_BODY_OFS";
	string MODEL_WEAR = "MODEL_WEAR";
	Vector3 RANGED_AIMANGLE = Vector3();
	string RANGED_ATK_DURATION = "RANGED_ATK_DURATION";
	string RANGED_HOLD_MINMAX = "RANGED_HOLD_MINMAX";
	string RANGED_PROJECTILE = "RANGED_PROJECTILE";
	float RANGED_PULLTIME = 0.0f;
	string RANGED_STAT = "RANGED_STAT";
	string SOUND_SHOOT = "SOUND_SHOOT";
	bool STRETCHED = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseRanged_DispatchEvent(name, params)
			|| BaseWeaponScript::DispatchEvent(name, params);
	}
}
