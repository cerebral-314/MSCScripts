#pragma context server

// Converted from monsters/gbear_brown_hpoly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/gbear_brown_lpoly.as"

[script "monsters/gbear_brown_hpoly"]
class GbearBrownHpoly : GbearBrownLpolyScript
{
	// Variables declared by included files, with the value they start with in this script
	GbearBrownHpoly()
	{
		MONSTER_MODEL = "monsters/gbear_hipoly.mdl";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gbear_hipoly.mdl");
	}
}
