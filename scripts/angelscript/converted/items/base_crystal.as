#pragma context server

// Converted from items/base_crystal.script by msc_transpiler.
// Thothie - Base for crystals

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseCrystal
{
	// Variables (an unset .script variable reads as its own name)
	float ACTIVE_DELAY = 0.0f;
	float ATTACK_DELAY = 0.0f;
	bool CRYSTAL_ABORT_USE = false;

	// game_spawn
	void BaseCrystal_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		ACTIVE_DELAY = 5.0f;
		OnCrystalSpawn();
		SetAnimExtension(PLAYERANIM_AIM);
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);
		SetHudSprite("trade", "71");
	}

	// game_deploy
	void BaseCrystal_OnGameDeploy()
	{
		ATTACK_DELAY = GameTime() + 1.0f;
	}

	// game_attack1
	void BaseCrystal_OnGameAttack1()
	{
		bool exitSub = false;

		if (!(GameTime() > ATTACK_DELAY))
			return;
		ATTACK_DELAY = GameTime() + 1.0f;

		int ownerSkill = Int(GetProp(ENT_OWNER, SKILL_TYPE));

		if (ownerSkill < SKILL_LEVEL_REQ)
		{
			string sReq = "(" + SKILL_LEVEL_REQ + ")";
			PlayerMessageDark(ENT_OWNER, "You lack the arcane skills to activate this crystal's magic. " + sReq);
		}
		else
		{
			OnCheckUse();
			if (CRYSTAL_ABORT_USE)
			{
				CRYSTAL_ABORT_USE = false;
				exitSub = true;
			}
			if (!exitSub)
			{
				CallEventDelayed(0.1f, "break_crystal");
				CallEventDelayed(0.2f, "activate_crystal");
				CallEventDelayed(0.3f, "remove_crystal");
			}
		}
	}

	// break_crystal
	void BaseCrystal_OnBreakCrystal()
	{
		PlaySound(0, 5, "debris/bustglass2.wav");

		Effect("tempent", "gibs", "glassgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 0.3f, 30, 10, 5, 1.0f);
		CallEventDelayed(0.1f, "remove_crystal");
	}

	// remove_crystal
	void BaseCrystal_OnRemoveCrystal()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		BaseCrystal_OnGameSpawn(playerRace, playerGender);
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseCrystal_OnGameDeploy();
	}

	void OnGameAttack1() { BaseCrystal_OnGameAttack1(); } // game_attack1
	void OnBreakCrystal() { BaseCrystal_OnBreakCrystal(); } // break_crystal
	void OnRemoveCrystal() { BaseCrystal_OnRemoveCrystal(); } // remove_crystal
	void OnCheckUse() {} // check_use
	void OnCrystalSpawn() {} // crystal_spawn

	// This file's events and timers by their .script names
	bool BaseCrystal_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "break_crystal") { OnBreakCrystal(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_crystal") { OnRemoveCrystal(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_crystal"]
shared class BaseCrystalScript : BaseMiscitemScript, BaseCrystal
{
	// Variables every script that includes this file declares
	int SKILL_LEVEL_REQ = 0;
	string SKILL_TYPE = "SKILL_TYPE";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseCrystal_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
