#pragma context server

// Converted from orc_for/orc_poisoner.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/dq/voldar.as"

[script "orc_for/orc_poisoner"]
class OrcPoisoner : VoldarScript
{
	// Variables declared by included files, with the value they start with in this script
	OrcPoisoner()
	{
		NPC_SELF_ADJUST = true;
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.0;1.5;2.0;2.5;3.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;1.0;1.5;2.0;4.0;5.0;";
	}

	// unnamed block (first think)
	void OrcPoisoner_FirstThink()
	{
		NPC_SELF_ADJUST = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		OrcPoisoner_FirstThink();
		Voldar_FirstThink();
		OrcBaseMelee_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
