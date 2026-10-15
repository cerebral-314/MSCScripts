#pragma context server

// Converted from items/mana_flesheater1.script by msc_transpiler.
// Potion of Venom Claws (Slithar's Necrojuice) by CMD June 2010
// Well, cleveryly diguised as a potion, anyway. Runs similar to items/base_crystal

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ManaFlesheater1
{
	// Constants
	string ANIM_IDLE = "0";
	string ANIM_DRINK = "1";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "viewmodels/v_misc.mdl";
	int ITEM_MODEL_VIEW_IDX = 2;
	string SOUND_DRINK = "items/drink.wav";
	string MODEL_BODY_OFS = "39";
	string ANIM_PREFIX = "mana";
	float DRINK_TIME = 3.0f;
	int SKILL_REQ = 15;
	int AFFLIC_REQ = 10;
	string ITEM_TO_GIVE = "blunt_gauntlets_fe1";

	// Variables (an unset .script variable reads as its own name)
	int DRINK_AMOUNT = 1;
	bool ABORT_USE = false;
	float ATTACK_DELAY = 0.0f;

	// unnamed block (first think)
	void ManaFlesheater1_FirstThink()
	{
		ABORT_USE = false;

		DRINK_AMOUNT = 1;
	}

	// item_spawn
	void ManaFlesheater1_OnItemSpawn()
	{
		SetName("Venom Claw Potion");
		SetDescription("This potion infuses you with the power of a Flesheater.");
		SetWeight(1);
		SetValue(1500);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
		SetHand("both");
	}

	// game_spawn
	void ManaFlesheater1_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHand("any");
		SetAnimExtension("holditem");
		SetWorldModel(MODEL_WORLD);
		SetViewModel(MODEL_VIEW);

		OnItemSpawn();
	}

	// game_pickup
	void ManaFlesheater1_OnGamePickup()
	{
		PlayViewAnim(0);
	}

	// game_attack1
	void ManaFlesheater1_OnGameAttack1()
	{
		bool exitSub = false;

		if (!(GameTime() > ATTACK_DELAY))
			return;
		ATTACK_DELAY = GameTime() + DRINK_TIME;

		float ownerSkill = SkillOf(ENT_OWNER, "martialarts");
		if (ownerSkill < SKILL_REQ)
		{
			string sReq = "(" + SKILL_REQ + ")";
			PlayerMessageDark(ENT_OWNER, "You lack the Martial Arts skill to use the Flesheater Gauntlets. " + sReq);
			exitSub = true;
		}
		if (ownerSkill >= SKILL_REQ)
		{
			OnCheckUse();
			if (ABORT_USE)
			{
				ABORT_USE = false;
				exitSub = true;
			}
		}
		if (exitSub)
			return;
		CallEventDelayed(0.1f, "drink_pot");
	}

	// drink_pot
	void ManaFlesheater1_OnDrinkPot(string drinkType = "")
	{
		PlayItemViewAnim(ENT_ME, Int(ANIM_DRINK));
		CallEventDelayed(DRINK_TIME, "activate_pot");
	}

	// activate_pot
	void ManaFlesheater1_OnActivatePot()
	{
		CallExternal(GetVar("GAME_MASTER"), "give_item_delayed", @EntityOf(ENT_OWNER), ITEM_TO_GIVE, 0.5f);
		CallEventDelayed(0.1f, "remove_pot");
	}

	// remove_pot
	void ManaFlesheater1_OnRemovePot()
	{
		DeleteEntity(ENT_ME);
	}

	// check_use
	void ManaFlesheater1_OnCheckUse()
	{
		if (SkillOf(ENT_OWNER, "spellcasting.affliction") < AFFLIC_REQ)
		{
			ABORT_USE = true;
			string sReq = "(" + AFFLIC_REQ + ")";
			PlayerMessageDark(ENT_OWNER, "You lack the Affliction Magic skill to use the Flesheater Gauntlets. " + sReq);
		}
	}

	// game_deploy
	void ManaFlesheater1_OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += ItemHandIndex();
		SetModelBody(0, int(submodel));

		ATTACK_DELAY = GameTime() + 1.0f;
	}

	// game_fall
	void ManaFlesheater1_OnGameFall()
	{
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 2.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_pickup
	void OnGamePickup()
	{
		BaseMiscitem_OnGamePickup(); // items/base_miscitem
		ManaFlesheater1_OnGamePickup();
	}

	void OnItemSpawn() { ManaFlesheater1_OnItemSpawn(); } // item_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "") { ManaFlesheater1_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameAttack1() { ManaFlesheater1_OnGameAttack1(); } // game_attack1
	void OnDrinkPot(string drinkType = "") { ManaFlesheater1_OnDrinkPot(drinkType); } // drink_pot
	void OnActivatePot() { ManaFlesheater1_OnActivatePot(); } // activate_pot
	void OnRemovePot() { ManaFlesheater1_OnRemovePot(); } // remove_pot
	void OnCheckUse() { ManaFlesheater1_OnCheckUse(); } // check_use
	void OnGameDeploy() { ManaFlesheater1_OnGameDeploy(); } // game_deploy
	void OnGameFall() { ManaFlesheater1_OnGameFall(); } // game_fall
	void OnDrinkTime() {} // DRINK_TIME

	// This file's events and timers by their .script names
	bool ManaFlesheater1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_pot") { OnActivatePot(); return true; }
		if (name == "check_use") { OnCheckUse(); return true; }
		if (name == "drink_pot") { OnDrinkPot(Param(params, 0)); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "item_spawn") { OnItemSpawn(); return true; }
		if (name == "remove_pot") { OnRemovePot(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/mana_flesheater1"]
shared class ManaFlesheater1Script : BaseMiscitemScript, ManaFlesheater1
{
	// Variables declared by included files, with the value they start with in this script
	ManaFlesheater1Script()
	{
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		MODEL_BODY_OFS = "39";
		ANIM_PREFIX = "mana";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ManaFlesheater1_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ManaFlesheater1_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
