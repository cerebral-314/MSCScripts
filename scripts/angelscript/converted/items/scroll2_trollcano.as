#pragma context server

// Converted from items/scroll2_trollcano.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_scroll.as"

[script "items/scroll2_trollcano"]
class Scroll2Trollcano : BaseScrollScript
{
	// Variables declared by included files, with the value they start with in this script
	Scroll2Trollcano()
	{
		BASE_SPELL_SCRIPT = "magic_hand_trollcano";
		BASE_REQUIRED_SKILL = "skill.spellcasting";
		SPELL_MAKER_SCRIPT = "monsters/companion/spell_maker_fire";
		SPELL_MAKER_HEIGHT = 48;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender); // items/base_scroll

		SetName("Trollcano Scroll");
		SetDescription("Be careful what you wish for.");

		SetValue(0);
		SetHudSprite("trade", "21");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseScrollScript::DispatchEvent(name, params);
	}
}
