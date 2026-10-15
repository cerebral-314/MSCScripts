#pragma context server

// Converted from orc_for/orc_sniper_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers2.as"
#include "converted/monsters/orc_sniper.as"

[script "orc_for/orc_sniper_sa"]
class OrcSniperSa : OrcSniperScript, Tiers2
{
	// Constants
	string ARROW_PUSH_VEL = "ARROW_PUSH_VEL";

	// Variables declared by included files, with the value they start with in this script
	OrcSniperSa()
	{
		NPC_SELF_ADJUST = true; // from orc_for/tiers2
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000"; // from orc_for/tiers2
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;15.0;"; // from orc_for/tiers2
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;"; // from orc_for/tiers2
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tiers2_FirstThink();
		OrcSniper_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}
}
