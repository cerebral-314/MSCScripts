#pragma context server

// Converted from items/scroll_ice_shield.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_ice_shield"]
class ScrollIceShield : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollIceShield()
	{
		BASE_SPELL_SCRIPT = "magic_hand_ice_shield";
		BASE_SUMMON_TEXT = "You learn to create protective shields of ice.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.ice";
		BASE_REQUIRED_LEVEL = 5;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Ice Shield Tome ");
		SetDescription("The method to create protective layer of ice is written here.");

		SetValue(380);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTomeScript::DispatchEvent(name, params);
	}
}
