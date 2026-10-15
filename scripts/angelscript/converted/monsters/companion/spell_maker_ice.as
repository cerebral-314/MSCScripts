#pragma context server

// Converted from monsters/companion/spell_maker_ice.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/spell_maker_base.as"

[script "monsters/companion/spell_maker_ice"]
class SpellMakerIce : SpellMakerBaseScript
{
	// Constants
	string FX_SCRIPT = "none";
	string MODEL_OFSET = "8";
	string SOUND_SPAWN = "magic/ice_powerup.wav";
	float REMOVE_DELAY = 5.0f;
	bool SHOW_FX = false;
	bool NO_FADE = false;
	bool FX_GLOW = true;
	Vector3 GLOW_COLOR = Vector3();

	// Variables declared by included files, with the value they start with in this script
	SpellMakerIce()
	{
		ANIM_IDLE = "iceblade_idle";
		SPAWNER_MODEL = "weapons/P_weapons1.mdl";
		SPELL_MAKER_HEIGHT = 32;
	}

	// unnamed block (first think)
	void SpellMakerIce_FirstThink()
	{
		ANIM_IDLE = "iceblade_idle";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/P_weapons1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SpellMakerIce_FirstThink();
	}
}
