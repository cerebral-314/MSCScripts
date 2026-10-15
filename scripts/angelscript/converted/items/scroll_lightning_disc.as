#pragma context server

// Converted from items/scroll_lightning_disc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_lightning_disc"]
class ScrollLightningDisc : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollLightningDisc()
	{
		BASE_SPELL_SCRIPT = "magic_hand_lightning_disc";
		BASE_SUMMON_TEXT = "You learn to create lightning discs.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.lightning";
		BASE_REQUIRED_LEVEL = 25;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Lightning Disc Tome");
		SetDescription("The method to cast Lightning Discs is written here.");

		SetValue(800);
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
