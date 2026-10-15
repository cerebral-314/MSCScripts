#pragma context server

// Converted from monsters/companion/spell_maker_divination.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_divination"]
class SpellMakerDivination : SpellMakerBaseScript
{
	// Constants
	string FX_SCRIPT = "monsters/companion/spell_maker_divination";
	string MODEL_OFSET = "0";
	string SOUND_SPAWN = "magic/heal_powerup.wav";
	float REMOVE_DELAY = 10.0f;
	bool SHOW_FX = true;
	bool NO_FADE = true;

	// Variables declared by included files, with the value they start with in this script
	SpellMakerDivination()
	{
		ANIM_IDLE = "";
		SPAWNER_MODEL = "none";
	}

	// unnamed block (first think)
	void SpellMakerDivination_FirstThink()
	{
		ANIM_IDLE = "";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpellMakerDivination_FirstThink();
	}
}
