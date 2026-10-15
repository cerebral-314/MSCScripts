#pragma context server

// Converted from monsters/companion/spell_maker_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_fire"]
class SpellMakerFire : SpellMakerBaseScript
{
	// Constants
	string FX_SCRIPT = "none";
	string MODEL_OFSET = "50";
	string SOUND_SPAWN = "scream/battlecry.wav";
	float REMOVE_DELAY = 5.0f;
	bool SHOW_FX = false;
	bool NO_FADE = false;

	// Variables declared by included files, with the value they start with in this script
	SpellMakerFire()
	{
		SPAWNER_MODEL = "weapons/projectiles.mdl";
		ANIM_IDLE = "stukabat_Hover";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
	}
}
