#pragma context server

// Converted from items/scroll_ice_lance.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_ice_lance"]
class ScrollIceLance : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollIceLance()
	{
		BASE_SPELL_SCRIPT = "magic_hand_ice_lance";
		BASE_SUMMON_TEXT = "You learn to create deep freezing icicles.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.ice";
		BASE_REQUIRED_LEVEL = 25;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Ice Lance Tome");
		SetDescription("The method to create deep freezing icicles is here.");

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
