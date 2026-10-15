#pragma context server

// Converted from items/scroll_conjure_venom_claws.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

[script "items/scroll_conjure_venom_claws"]
class ScrollConjureVenomClaws : BaseTomeScript
{
	// Variables declared by included files, with the value they start with in this script
	ScrollConjureVenomClaws()
	{
		BASE_SPELL_SCRIPT = "magic_hand_conjure_venom_claws";
		BASE_SUMMON_TEXT = "You learn to conjure Venom Claws.";
		BASE_REQUIRED_SKILL = "skill.spellcasting.affliction";
		BASE_REQUIRED_LEVEL = 20;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome

		SetName("Venom Claws Tome");
		SetDescription("Evil runes are scrawled in these pages.");

		SetValue(2500);
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
