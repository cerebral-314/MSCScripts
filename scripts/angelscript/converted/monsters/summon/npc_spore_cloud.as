#pragma context server

// Converted from monsters/summon/npc_spore_cloud.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/npc_poison_cloud.as"

[script "monsters/summon/npc_spore_cloud"]
class NpcSporeCloud : NpcPoisonCloudScript
{
	// Variables declared by included files, with the value they start with in this script
	NpcSporeCloud()
	{
		EFFECT_SCRIPT = "effects/poison_spore";
		CHECK_EFFECT = "DOT_gpoison";
	}
}
