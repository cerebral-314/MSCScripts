#pragma context server

// Converted from items/axes_runeaxe.script by msc_transpiler.
// Rune Axe by Thothie
// - Based on Great Axe - I've re-added this due to complaints of lack of axes
// - Plus we have that really nifty looking rune axe model!
// - Differences from Great Axe - <damage <accuracy >speed
// Great Axe

#include "runtime/ScriptEntity.as"
#include "converted/items/axes_base_onehanded.as"

[script "items/axes_runeaxe"]
class AxesRuneaxe : AxesBaseOnehandedScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";

	// Variables declared by included files, with the value they start with in this script
	AxesRuneaxe()
	{
		ANIM_ATTACK1 = "9";
		ANIM_ATTACK2 = "10";
		ANIM_ATTACK3 = "11";
		MODEL_VIEW = "viewmodels/v_1haxes.mdl";
		MODEL_VIEW_IDX = 4;
		MODEL_HANDS = "weapons/p_weapons1.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "95";
		ANIM_PREFIX = "axe";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 0.7f;
		MELEE_ENERGY = 4.0f;
		MELEE_DMG = 160;
		MELEE_DMG_RANGE = 70;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "75%";
		MELEE_STAT = "axehandling";
		MELEE_PARRY_CHANCE = "25%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Rune Axe");
		SetDescription("An axe hastened by ancient magiks");
		SetWeight(90);
		SetValue(2500);
		SetHudSprite("hand", "axe");
		SetHudSprite("trade", "runeaxe");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_1haxes.mdl");
		Precache("weapons/p_weapons1.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return AxesBaseOnehandedScript::DispatchEvent(name, params);
	}
}
