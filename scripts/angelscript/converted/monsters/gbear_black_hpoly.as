#pragma context server

// Converted from monsters/gbear_black_hpoly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/gbear_black_lpoly.as"

[script "monsters/gbear_black_hpoly"]
class GbearBlackHpoly : GbearBlackLpolyScript
{
	// Variables declared by included files, with the value they start with in this script
	GbearBlackHpoly()
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
