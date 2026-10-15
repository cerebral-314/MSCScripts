#pragma context server

// Converted from monsters/companion/spell_maker_invisible.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_invisible"]
class SpellMakerInvisible : SpellMakerBaseScript
{
	// Constants
	float REMOVE_DELAY = 5.0f;
	bool SHOW_FX = false;
	bool NO_FADE = true;

	// Variables declared by included files, with the value they start with in this script
	SpellMakerInvisible()
	{
		ANIM_IDLE = "";
		SPAWNER_MODEL = "none";
	}

	// unnamed block (first think)
	void SpellMakerInvisible_FirstThink()
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
		SpellMakerInvisible_FirstThink();
	}
}
