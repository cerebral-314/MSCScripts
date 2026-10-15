#pragma context server

// Converted from items/axes_b.script by msc_transpiler.
// Axe o Balance from Great Axe by Thothie

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_twohanded.as"

[script "items/axes_b"]
class AxesB : AxesBaseTwohandedScript
{
	// Constants
	string ANIM_ATTACK3 = "4";
	int ANIM_SHEATH = 5;

	// Variables declared by included files, with the value they start with in this script
	AxesB()
	{
		BASE_LEVEL_REQ = "18";
		ANIM_IDLE1 = "1";
		ANIM_ATTACK1 = "2";
		ANIM_ATTACK2 = "3";
		MODEL_VIEW = "viewmodels/v_2haxesgreat.mdl";
		MODEL_VIEW_IDX = 5;
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "51";
		ANIM_PREFIX = "standard";
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.5f;
		MELEE_ENERGY = 3.0f;
		MELEE_DMG = 375;
		MELEE_DMG_RANGE = 150;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "65%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Axe of Balance");
		SetDescription("This ornate axe is forged to favor accuracy over damage");
		SetWeight(90);
		SetValue(1200);
		SetHudSprite("hand", "137");
		SetHudSprite("trade", "137");
	}

	// ---- Engine wiring (generated) ----

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
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseTwohandedScript::DispatchEvent(name, params);
	}
}
