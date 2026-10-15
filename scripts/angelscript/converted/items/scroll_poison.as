#pragma context server

// Converted from items/scroll_poison.script by msc_transpiler.
// Poison spell added by Thothie
// - No one ever makes it to spell casting 8
// - So I figure we need more spells to help get people there

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_poison"]
class ScrollPoison : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollPoison()
	{
		BASE_SPELL_SCRIPT = "magic_hand_poison";
		BASE_SUMMON_TEXT = "You learn how to afflict your enemies with debilitating poison.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.affliction";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Poison Tome");
		SetDescription("The method for instilling insidius poison by magic is described here.");

		SetValue(225);
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
