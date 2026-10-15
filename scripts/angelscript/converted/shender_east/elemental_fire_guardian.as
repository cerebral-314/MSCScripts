#pragma context server

// Converted from shender_east/elemental_fire_guardian.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/shender_east/elemental_ice_guardian.as"

[script "shender_east/elemental_fire_guardian"]
class ShenderEastElementalFireGuardian : ShenderEastElementalIceGuardianScript
{
	// Variables declared by included files, with the value they start with in this script
	ShenderEastElementalFireGuardian()
	{
		ICE_GUARD_NAME = "Lesser Nightmare of Fire";
		ICE_GUARD_MODEL = "monsters/fire_guardian.mdl";
		NPC_BASE_EXP = "500";
		GUARD_ELEMENT = "fire";
		ICE_GUARD_ICE_VULN = 1.5f;
		ICE_GUARD_FIRE_VULN = 0.0f;
		ICE_GUARD_DOT_EFFECT = "effects/dot_fire";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
		DOT_FROST = 60;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/fire_guardian.mdl");
		Precache("magic/bolt_loop.wav");
	}
}
