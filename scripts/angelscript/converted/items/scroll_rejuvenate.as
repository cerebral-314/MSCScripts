#pragma context server

// Converted from items/scroll_rejuvenate.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_rejuvenate"]
class ScrollRejuvenate : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollRejuvenate()
	{
		BASE_SPELL_SCRIPT = "magic_hand_div_rejuvenate";
		BASE_SUMMON_TEXT = "You learn how to replenish the mind, body, and soul.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.divination";
		BASE_REQUIRED_LEVEL = 5;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Rejuvenation Tome");
		SetDescription("The method for health replenishing magic is written here.");

		SetValue(1000);
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
