#pragma context server

// Converted from old_helena/map_startup.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "old_helena/map_startup"]
class OldHelenaMapStartup : ScriptEntity
{
	// unnamed block (first think)
	void OldHelenaMapStartup_FirstThink()
	{
		SetGlobal("G_NO_DROP", 1);
		SetGlobal("G_EXP_MULTI", 1);
		SetGlobal("G_SIEGE_MAP", 1); // 1 in 3 monsters set to ignore players
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OldHelenaMapStartup_FirstThink();
	}
}
