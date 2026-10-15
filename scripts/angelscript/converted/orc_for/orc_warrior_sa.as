#pragma context server

// Converted from orc_for/orc_warrior_sa.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/tiers1.as"
#include "converted/monsters/orc_warrior.as"

[script "orc_for/orc_warrior_sa"]
class OrcWarriorSa : MonstersOrcWarriorScript, Tiers1
{
	// Variables declared by included files, with the value they start with in this script
	OrcWarriorSa()
	{
		ATTACK_ACCURACY = "80%";
		NPC_SELF_ADJUST = true; // from orc_for/tiers1
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;"; // from orc_for/tiers1
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;"; // from orc_for/tiers1
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Tiers1_FirstThink();
		MonstersOrcWarrior_FirstThink();
		OrcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		OrcBaseMelee_FirstThink();
	}
}
