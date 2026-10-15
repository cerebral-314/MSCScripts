#pragma context server

// Converted from items/bows_telf1.script by msc_transpiler.
// Telf bows by Thothie, from Phoenix Bow by CMD

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BowsTelf1
{
	// Constants
	string BASE_LEVEL_REQ = "30";
	int MODEL_VIEW_IDX = 9;
	string MODEL_VIEW = "viewmodels/v_bows.mdl";
	string MODEL_HANDS = "weapons/p_weapons3.mdl";
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_WEAR = "weapons/p_weapons3.mdl";
	string SOUND_SHOOT = "weapons/bow/bow.wav";
	string ITEM_NAME = "longbow";
	string ANIM_PREFIX = "standard";
	string MODEL_BODY_OFS = "54";
	float RANGED_POSTFIRE_DELAY = 1.0f;
	string RANGED_ATK_DURATION = "1.0";
	Vector3 RANGED_AIMANGLE = Vector3();
	bool CUSTOM_ATTACK = true;
	string DAMAGE_TYPE = "fire_effect";
	string RANGED_HOLD_MINMAX = "1.1;1.3";
	string RANGED_STAT = "archery";
	float RANGED_PULLTIME = 1.0f;
	float DMG_ADJ = 0.65f;

	// Variables (an unset .script variable reads as its own name)
	string TORKIE_BOW_TYPE = "TORKIE_BOW_TYPE";

	// bow_spawn
	void BowsTelf1_OnBowSpawn()
	{
		SetName("Torkalath Fire Bow");
		SetDescription("Spiral flames are engraved in this ornate bow.");
		SetWeight(100);
		SetValue(1500);
		SetHudSprite("trade", "166");

		OnCustomRegister();
	}

	// game_deploy
	void BowsTelf1_OnGameDeploy()
	{
		OnSetBowType();
	}

	// set_bow_type
	void BowsTelf1_OnSetBowType()
	{
		float dmgAmt = SkillOf(ENT_OWNER, "spellcasting.fire") * DMG_ADJ;
		if (UNDER_SKILLED)
			dmgAmt *= 0.1f;
		TORKIE_BOW_TYPE = "fire";
		CallExternal(ENT_OWNER, "ext_set_spiral", TORKIE_BOW_TYPE, dmgAmt);
	}

	// custom_register
	void BowsTelf1_OnCustomRegister()
	{
		SetLocal("reg.attack.type", "charge-throw-projectile");
		SetLocal("reg.attack.keys", "+attack1");
		SetLocal("reg.attack.hold_min&max", RANGED_HOLD_MINMAX);
		SetLocal("reg.attack.dmg.type", DAMAGE_TYPE);
		SetLocal("reg.attack.dmg.multi", 1.0f);
		SetLocal("reg.attack.range", 512);
		SetLocal("reg.attack.energydrain", 1);
		SetLocal("reg.attack.stat", "archery");
		SetLocal("reg.attack.COF", "0.1;0.1");
		SetLocal("reg.attack.projectile", "proj_arrow_spiral");
		SetLocal("reg.attack.priority", 0);
		SetLocal("reg.attack.delay.strike", "RANGED_DMG_DELAY");
		SetLocal("reg.attack.delay.end", RANGED_ATK_DURATION);
		SetLocal("reg.attack.ofs.startpos", Vector3(0, 0, 10));
		SetLocal("reg.attack.ofs.aimang", RANGED_AIMANGLE);
		SetLocal("reg.attack.ammodrain", 0);
		SetLocal("reg.attack.callback", "ranged");
		SetLocal("reg.attack.noise", 1000);

		RegisterAttack();
	}

	// ranged_start
	void BowsTelf1_OnRangedStart()
	{
		float ownerSkill = SkillOf(ENT_OWNER, "spellcasting.fire");
		if (!(ownerSkill < 15.0f))
			return;
		PlayerMessageDark(ENT_OWNER, "You lack the fire affinity to activate this bow's magic.");
		CancelAttack();
	}

	// bow_underskilled
	void BowsTelf1_OnBowUnderskilled()
	{
		OnSetBowType();
	}

	// bow_underskilled_restore
	void BowsTelf1_OnBowUnderskilledRestore()
	{
		OnSetBowType();
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
		BaseRanged_OnGameDeploy(); // items/base_ranged
		BowsTelf1_OnGameDeploy();
	}

	// ranged_start
	void OnRangedStart()
	{
		BowsBase_OnRangedStart(); // items/bows_base
		BowsTelf1_OnRangedStart();
	}

	void OnBowSpawn() { BowsTelf1_OnBowSpawn(); } // bow_spawn
	void OnSetBowType() { BowsTelf1_OnSetBowType(); } // set_bow_type
	void OnCustomRegister() { BowsTelf1_OnCustomRegister(); } // custom_register
	void OnBowUnderskilled() { BowsTelf1_OnBowUnderskilled(); } // bow_underskilled
	void OnBowUnderskilledRestore() { BowsTelf1_OnBowUnderskilledRestore(); } // bow_underskilled_restore

	// This file's events and timers by their .script names
	bool BowsTelf1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "bow_underskilled") { OnBowUnderskilled(); return true; }
		if (name == "bow_underskilled_restore") { OnBowUnderskilledRestore(); return true; }
		if (name == "custom_register") { OnCustomRegister(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "set_bow_type") { OnSetBowType(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/bows_telf1"]
shared class BowsTelf1Script : BowsBaseScript, BowsTelf1
{
	// Variables declared by included files, with the value they start with in this script
	BowsTelf1Script()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_WEAR = "weapons/p_weapons3.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "standard";
		MODEL_BODY_OFS = "54";
		RANGED_ATK_DURATION = "1.0";
		RANGED_PULLTIME = 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_bows.mdl");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BowsTelf1_DispatchEvent(name, params)
			|| BowsBaseScript::DispatchEvent(name, params);
	}
}
