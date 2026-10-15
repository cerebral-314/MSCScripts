#pragma context server

// Converted from chests/bag_o_gold_50.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/bag_o_gold_base.as"

[script "chests/bag_o_gold_50"]
class BagOGold50 : BagOGoldBaseScript
{
	// unnamed block (first think)
	void BagOGold50_FirstThink()
	{
		GOLD_AMT = RandomInt(40, 50);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BagOGold50_FirstThink();
		BagOGoldBase_FirstThink();
	}
}
