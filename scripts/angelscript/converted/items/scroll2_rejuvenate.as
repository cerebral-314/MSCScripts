#pragma context server

// Converted from items/scroll2_rejuvenate.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_scroll.as"

[script "items/scroll2_rejuvenate"]
class Scroll2Rejuvenate : BaseScrollScript
{
	// Variables declared by included files, with the value they start with in this script
	Scroll2Rejuvenate()
	{
		BASE_SPELL_SCRIPT = "magic_hand_div_rejuvenate";
		BASE_REQUIRED_SKILL = "skill.spellcasting.divination";
		BASE_REQUIRED_LEVEL = 5;
		SPELL_MAKER_SCRIPT = "monsters/companion/spell_maker_divination";
		SPELL_MAKER_HEIGHT = 64;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender); // items/base_scroll

		SetName("Rejuvenation Scroll");
		SetDescription("A compendium of divine healing magics.");

		SetHudSprite("trade", "219");

		SetValue(1000);
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
