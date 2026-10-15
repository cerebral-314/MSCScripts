#pragma context server

// Converted from nashalrath/brush_storm_cold.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/nashalrath/base_storm_brush.as"

[script "nashalrath/brush_storm_cold"]
class BrushStormCold : BaseStormBrushScript
{
	// unnamed block (first think)
	void BrushStormCold_FirstThink()
	{
		SetUniqueName("brush_storm_cold");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BrushStormCold_FirstThink();
	}
}
