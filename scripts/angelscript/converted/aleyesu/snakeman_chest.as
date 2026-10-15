#pragma context server

// Converted from aleyesu/snakeman_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "aleyesu/snakeman_chest"]
class SnakemanChest : BaseTreasurechestScript
{
	// Constants
	string SCROLL_LIST = "scroll2_fire_ball;scroll2_blizzard;scroll2_poison;scroll2_frost_xolt;scroll2_fire_wall;scroll2_lightning_storm;scroll_summon_undead";

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(RandomInt(25, 300)); // <min_amt> <max_amt> <quant_per_pouch> //add gold pouches to chest

		AddStoreItem(STORENAME, "key_blue", 1, 0);

		OnAddASpell();
		if (RandomInt(0, 1) != 0)
			OnAddASpell();
		if (RandomInt(1, 4) == 1)
			OnAddASpell();
	}

	// add_a_spell
	void OnAddASpell()
	{
		float nScrolls = GetTokenCount(SCROLL_LIST) - 1.0f;
		int rndPick = RandomInt(0, int(nScrolls));
		string scrollName = GetToken(SCROLL_LIST, rndPick);
		AddStoreItem(STORENAME, scrollName, 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_a_spell") { OnAddASpell(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
