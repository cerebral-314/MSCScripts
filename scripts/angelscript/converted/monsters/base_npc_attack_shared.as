#pragma context server

// Converted from monsters/base_npc_attack_shared.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/base_npc_attack_shared"]
class BaseNpcAttackShared : ScriptEntity
{
	// unnamed block (first think)
	void BaseNpcAttackShared_FirstThink()
	{
		bool doNadda = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcAttackShared_FirstThink();
	}
}
