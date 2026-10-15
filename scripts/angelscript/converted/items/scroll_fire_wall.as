#pragma context server

// Converted from items/scroll_fire_wall.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_fire_wall"]
class ScrollFireWall : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollFireWall()
	{
		BASE_SPELL_SCRIPT = "magic_hand_fire_wall";
		BASE_SUMMON_TEXT = "You learn to create walls of flame.";
		BASE_REQUIRED_LEVEL = 13;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Fire Wall Tome");
		SetDescription("The method to create walls of flame is written here.");

		SetValue(855);
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
