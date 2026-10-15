#pragma context server

// Converted from items/swords_dynamic.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_melee.as"

[script "items/swords_dynamic"]
class SwordsDynamic : BaseMeleeScript
{
	// Variables (an unset .script variable reads as its own name)
	float CUR_PROP = 0.0f;
	string ANIM_USE = "ANIM_USE";
	float PRESS_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwordsDynamic()
	{
		MODEL_VIEW = "weapons/1hbigsword_rview.mdl";
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		MODEL_WORLD = "weapons/p_weapons1.mdl";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "shortsword";
	}

	// unnamed block (first think)
	void SwordsDynamic_FirstThink()
	{
		MODEL_VIEW = "weapons/1hbigsword_rview.mdl";
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
		SetViewModelProp(ENT_OWNER, "submodel", 0);
		CUR_PROP = 0.0f;
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Dynamic Sword");
		SetDescription("Special developer tool, does no damage command: . dsword <sub> <anim>");
		SetWeight(30);
		SetValue(15);
		SetHudSprite("trade", "shortsword");
	}

	// register_normal
	void OnRegisterNormal()
	{
	}

	// ext_sub
	void OnExtSub(float submodel = 0.0f, string animation = "")
	{
		ConsoleMessage(ENT_OWNER, "setviewmodelprop " + ENT_OWNER + " submodel 1 " + Text(submodel));
		SetViewModelProp(ENT_OWNER, "submodel", submodel);
		CUR_PROP = submodel;
		ANIM_USE = animation;
		PlayItemViewAnim(ENT_ME, Int(ANIM_USE));
	}

	// game_attack1
	void OnGameAttack1()
	{
		PlayItemViewAnim(ENT_ME, Int(ANIM_USE));
	}

	// game_+attack2
	void OnGamePressAttack2()
	{
		if (!(GameTime() > PRESS_DELAY))
			return;
		PRESS_DELAY = GameTime() + 0.25f;
		CUR_PROP += 1.0f;
		SetViewModelProp(ENT_OWNER, "submodel", CUR_PROP);
		ConsoleMessage(ENT_OWNER, "using " + Text(CUR_PROP));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SwordsDynamic_FirstThink();
		BaseWeapon_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_sub") { OnExtSub(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "game_+attack2") { OnGamePressAttack2(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "register_normal") { OnRegisterNormal(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BaseMeleeScript::DispatchEvent(name, params);
	}
}
