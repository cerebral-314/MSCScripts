#pragma context server

// Converted from monsters/summon/circle_of_ice_sword.script by msc_transpiler.
// Variant of lesser circle of ice spawned by Hoarfrost Shard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/circle_of_ice_lesser.as"

[script "monsters/summon/circle_of_ice_sword"]
class CircleOfIceSword : CircleOfIceLesserScript
{
	// Variables declared by included files, with the value they start with in this script
	CircleOfIceSword()
	{
		FX_SPRITE = "glassgibs.mdl";
		NO_RAIN_FX = true;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("glassgibs.mdl");
	}
}
