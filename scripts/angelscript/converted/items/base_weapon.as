#pragma context server

// Converted from items/base_weapon.script by msc_transpiler.
// Thothie - added tweak to deal with worldmodel weapons with no idle anims
// Weapons
// REQ:
// MODEL_VIEW
// MODEL_HANDS

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseWeapon
{
	// Constants
	string PLAYERANIM_AIM = "blunt";

	// Variables (an unset .script variable reads as its own name)
	bool IS_WEAPON = true;

	// unnamed block (first think)
	void BaseWeapon_FirstThink()
	{
		IS_WEAPON = true;
	}

	// item_spawn
	void BaseWeapon_OnItemSpawn()
	{
		SetAnimExtension(PLAYERANIM_AIM);
		SetHand("right");

		OnWeaponSpawn();
	}

	// game_sheath
	void BaseWeapon_OnGameSheath()
	{
		// playviewanim  ANIM_SHEATH
		SetModelBody(0, 2);

		OnWeaponSheath();
	}

	// game_parry
	void BaseWeapon_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlaySound(1, 10, "weapons/cbar_miss1.wav");

		OnWeaponParry();
	}

	// game_deploy
	void BaseWeapon_OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);

		float submodel = Float(GetVar("MODEL_BODY_OFS"));
		submodel += 1.0f;
		submodel -= ItemHandIndex();

		SetModelBody(0, int(submodel));

		if (!Truthy(GetVar("BASEWEAPON_NO_HAND_IDLE")))
		{
			string anim = GetVar("ANIM_PREFIX") + "_idle";
			if (GetVar("ANIM_PREFIX") == "ANIM_PREFIX")
				anim = "idle";
			if (GetVar("ANIM_PREFIX") == "none")
				anim = "idle";
			PlayAnim(anim);
		}

		OnWeaponDeploy();
		CallEventDelayed(8.0f, "item_idle");
	}

	// game_fall
	void BaseWeapon_OnGameFall()
	{
		float submodel = Float(GetVar("MODEL_BODY_OFS"));
		submodel += 2.0f;
		if (Truthy(GetVar("NO_WORLD_MODEL")))
			submodel -= 1.0f;
		// add		L_SUBMODEL 2
		string anim = GetVar("ANIM_PREFIX") + "_floor_idle";

		// //dbg temp playinbg L_ANIM
		SetModelBody(0, int(submodel));
		if (GetVar("ANIM_PREFIX") == "ANIM_PREFIX")
			anim = "idle";
		if (GetVar("ANIM_PREFIX") == "none")
			anim = "idle";
		PlayAnim(anim);

		OnWeaponFall();
	}

	// game_deploy
	void BaseWeapon_OnGameDeploy_2()
	{
		// popup setviewmodelprop MODEL_VIEW_IDX
		if (!(Float(GetVar("MODEL_VIEW_IDX")) > 0.0f))
			return;
		CallEventDelayed(0.01f, "bw_setup_model");
	}

	// bw_setup_model
	void BaseWeapon_OnBwSetupModel()
	{
		SetViewModelProp(ENT_ME, "submodel", ScriptVarOf(ENT_OWNER, "PLR_HAND_SET"), GetVar("MODEL_VIEW_IDX"));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseWeapon_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseWeapon_OnGameDeploy();
		BaseWeapon_OnGameDeploy_2();
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseWeapon_OnGameSheath();
	}

	void OnItemSpawn() { BaseWeapon_OnItemSpawn(); } // item_spawn
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f) { BaseWeapon_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); } // game_parry
	void OnBwSetupModel() { BaseWeapon_OnBwSetupModel(); } // bw_setup_model
	void OnWeaponDeploy() {} // weapon_deploy
	void OnWeaponFall() {} // weapon_fall
	void OnWeaponParry() {} // weapon_parry
	void OnWeaponSheath() {} // weapon_sheath
	void OnWeaponSpawn() {} // weapon_spawn

	// This file's events and timers by their .script names
	bool BaseWeapon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bw_setup_model") { OnBwSetupModel(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_sheath") { OnGameSheath(); return true; }
		if (name == "item_spawn") { OnItemSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_weapon"]
shared class BaseWeaponScript : BaseItemScript, BaseWeapon
{
	// Variables every script that includes this file declares
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	string MODEL_WORLD = "MODEL_WORLD";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseWeapon_DispatchEvent(name, params)
			|| BaseItemScript::DispatchEvent(name, params);
	}
}
