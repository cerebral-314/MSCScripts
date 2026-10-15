#pragma context server

// Converted from effects/sfx_beam_cage.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "effects/sfx_beam_cage"]
class SfxBeamCage : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	float ROCK_CLIMB_STEP = 0.0f;

	// unnamed block (first think)
	void SfxBeamCage_FirstThink()
	{
		ROCK_CLIMB_STEP = 1.0f;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SfxBeamCage_FirstThink();
	}
}
