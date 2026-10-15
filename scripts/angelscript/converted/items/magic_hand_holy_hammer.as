#pragma context server

// Converted from items/magic_hand_holy_hammer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/magic_hand_holy_hammer"]
class MagicHandHolyHammer : BluntBaseOnehandedScript
{
	// Constants
	int SPELL_SKILL_REQUIRED = 5;
	string BASE_LEVEL_REQ = "5";
	int MODEL_VIEW_IDX = 2;

	// Variables declared by included files, with the value they start with in this script
	MagicHandHolyHammer()
	{
		MELEE_STAT = "spellcasting.divination";
		MODEL_VIEW = "viewmodels/v_1hblunts.mdl";
		MODEL_BODY_OFS = "71";
		ANIM_PREFIX = "maul";
		MELEE_RANGE = "80";
		MELEE_DMG_DELAY = 0.8f;
		MELEE_ATK_DURATION = 1.3f;
		MELEE_ENERGY = 2.0f;
		MELEE_DMG = 102;
		MELEE_DMG_RANGE = 5;
		MELEE_ACCURACY = "65%";
		MELEE_PARRY_AUGMENT = "10%";
		MELEE_DMG_TYPE = "holy";
	}

	// game_spawn
	// Registers the spell faster so it fizzles as soon as its thrown
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item

		SetLocal("reg.spell.reqskill", BASE_LEVEL_REQ);
		SetLocal("reg.spell.fizzletime", 9999999);
		SetLocal("reg.spell.castsuccess", "100%");
		SetLocal("reg.spell.preparetime", 3);
		LegacyCommand("registerspell");
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Holy Hammer");
		SetDescription("Can't touch this.");

		SetWeight(10);
		SetValue(270);

		SetHudSprite("hand", "hammer");
		SetHudSprite("trade", "maul");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons1.mdl");
		Precache("viewmodels/v_1hblunts.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
