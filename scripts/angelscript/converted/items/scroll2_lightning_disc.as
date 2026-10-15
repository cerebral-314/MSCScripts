#pragma context server

// Converted from items/scroll2_lightning_disc.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_scroll.as"

[script "items/scroll2_lightning_disc"]
class Scroll2LightningDisc : BaseScrollScript
{
	// Variables declared by included files, with the value they start with in this script
	Scroll2LightningDisc()
	{
		BASE_SPELL_SCRIPT = "magic_hand_lightning_disc";
		BASE_REQUIRED_SKILL = "skill.spellcasting.lightning";
		BASE_REQUIRED_LEVEL = 25;
		SPELL_MAKER_SCRIPT = "monsters/companion/spell_maker_lightning";
		SPELL_MAKER_HEIGHT = 18;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender); // items/base_scroll

		SetName("Lightning Disc Scroll");
		SetDescription("A magical compendium of strong lightning enchantments.");

		SetHudSprite("trade", "214");

		SetValue(800);
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
