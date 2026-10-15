#pragma context server

// Converted from nashalrath/lift_check_left.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_pillar_check.as"

[script "nashalrath/lift_check_left"]
class LiftCheckLeft : BasePillarCheckScript
{
	// unnamed block (first think)
	void LiftCheckLeft_FirstThink()
	{
		SetUniqueName("lift_pillar_left");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		LiftCheckLeft_FirstThink();
	}
}
