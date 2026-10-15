#pragma context server

// Converted from items/swords_lostblade.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "items/swords_lostblade"]
class SwordsLostblade : ScriptEntity
{
	// unnamed block (first think)
	void SwordsLostblade_FirstThink()
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SwordsLostblade_FirstThink();
	}
}
