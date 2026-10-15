#pragma context server

// Converted from chests/bag_o_gold_25.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/bag_o_gold_base.as"

[script "chests/bag_o_gold_25"]
class BagOGold25 : BagOGoldBaseScript
{
	// unnamed block (first think)
	void BagOGold25_FirstThink()
	{
		GOLD_AMT = RandomInt(20, 25);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BagOGold25_FirstThink();
		BagOGoldBase_FirstThink();
	}
}
