#pragma context server

// Converted from monsters/companion/spell_maker_affliction.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_affliction"]
class SpellMakerAffliction : SpellMakerBaseScript
{
	// Constants
	string FX_SCRIPT = "none";
	string MODEL_OFSET = "8";
	string SOUND_SPAWN = "x/x_laugh1.wav";
	float REMOVE_DELAY = 5.0f;
	bool SHOW_FX = false;
	bool NO_FADE = false;
	bool FX_GLOW = true;
	Vector3 GLOW_COLOR = Vector3();

	// Variables declared by included files, with the value they start with in this script
	SpellMakerAffliction()
	{
		ANIM_IDLE = "idle_standard";
		SPAWNER_MODEL = "weapons/projectiles.mdl";
		SPELL_MAKER_HEIGHT = 72;
		GLOW_AMT = 255;
	}

	// unnamed block (first think)
	void SpellMakerAffliction_FirstThink()
	{
		ANIM_IDLE = "idle_standard";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpellMakerAffliction_FirstThink();
	}
}
