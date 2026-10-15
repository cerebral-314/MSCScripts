#pragma context server

// Converted from chests/bag_o_gold_10.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/bag_o_gold_base.as"

[script "chests/bag_o_gold_10"]
class BagOGold10 : BagOGoldBaseScript
{
	// unnamed block (first think)
	void BagOGold10_FirstThink()
	{
		GOLD_AMT = RandomInt(7, 10);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BagOGold10_FirstThink();
		BagOGoldBase_FirstThink();
	}
}
