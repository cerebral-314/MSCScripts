#pragma context server

// Converted from nashalrath/lift_check_right.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_pillar_check.as"

[script "nashalrath/lift_check_right"]
class LiftCheckRight : BasePillarCheckScript
{
	// unnamed block (first think)
	void LiftCheckRight_FirstThink()
	{
		SetUniqueName("lift_pillar_right");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LiftCheckRight_FirstThink();
	}
}
