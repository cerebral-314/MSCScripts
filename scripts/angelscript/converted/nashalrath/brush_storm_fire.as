#pragma context server

// Converted from nashalrath/brush_storm_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_storm_brush.as"

[script "nashalrath/brush_storm_fire"]
class BrushStormFire : BaseStormBrushScript
{
	// unnamed block (first think)
	void BrushStormFire_FirstThink()
	{
		SetUniqueName("brush_storm_fire");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BrushStormFire_FirstThink();
	}
}
