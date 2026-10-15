#pragma context server

// Converted from items/scroll2_summon_guard.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_scroll.as"

[script "items/scroll2_summon_guard"]
class Scroll2SummonGuard : BaseScrollScript
{
	// Variables declared by included files, with the value they start with in this script
	Scroll2SummonGuard()
	{
		BASE_SPELL_SCRIPT = "magic_hand_summon_guard";
		BASE_REQUIRED_SKILL = "skill.spellcasting";
		BASE_REQUIRED_LEVEL = 13;
		SPELL_MAKER_SCRIPT = "monsters/companion/spell_maker_summoning";
		SPELL_MAKER_HEIGHT = 48;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender); // items/base_scroll

		SetName("Undead Guardian Scroll");
		SetDescription("A compendium of greater summoning magics.");

		SetHudSprite("trade", "223");

		SetValue(2550);
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
