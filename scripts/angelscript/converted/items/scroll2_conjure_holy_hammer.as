#pragma context server

// Converted from items/scroll2_conjure_holy_hammer.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_scroll.as"

[script "items/scroll2_conjure_holy_hammer"]
class Scroll2ConjureHolyHammer : BaseScrollScript
{
	// Variables declared by included files, with the value they start with in this script
	Scroll2ConjureHolyHammer()
	{
		BASE_SPELL_SCRIPT = "magic_hand_holy_hammer";
		BASE_REQUIRED_SKILL = "skill.spellcasting.divination";
		SPELL_MAKER_SCRIPT = "monsters/companion/spell_maker_lightning";
		SPELL_MAKER_HEIGHT = 48;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender); // items/base_scroll

		SetName("MSC Hammer Scroll");
		SetDescription("Can't touch this.");

		SetValue(2500);
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
