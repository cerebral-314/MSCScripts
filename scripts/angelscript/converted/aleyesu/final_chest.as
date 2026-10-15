#pragma context server

// Converted from aleyesu/final_chest.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "aleyesu/final_chest"]
class AleyesuFinalChest : BaseTreasurechestScript
{
	// Constants
	string TOME_LIST = "scroll_fire_wall;scroll_lightning_storm;scroll_acid_xolt;scroll_ice_blast;scroll_volcano;scroll_healing_wave";
	string SCROLL_LIST = "scroll2_fire_wall;scroll2_lightning_storm;scroll2_acid_xolt;scroll2_ice_blast;scroll2_volcano;scroll2_healing_wave";

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OnAddGold(800.0f);

		OnOfferFelewynSymbol(100);

		AddStoreItem(STORENAME, "item_charm_w2", 1, 0);

		if (RandomInt(1, 10) == 1)
			AddStoreItem(STORENAME, "armor_paura", 1, 0);

		// if ( $rand(1,2) == 1 ) addstoreitem STORENAME key_blue 1 0
		OnAddEpicItem();
		OnAddRandomSpell();

		if (RandomInt(1, 8) == 1)
			OnAddRandomSpell();
		if (RandomInt(1, 8) == 1)
			OnAddRandomSpell();

		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 8) == 1)
			OnAddEpicItem();
	}

	// add_random_spell
	void OnAddRandomSpell()
	{
		int list = RandomInt(0, 1);
		string listText;
		if (list == 0)
			listText = TOME_LIST;
		else
			listText = SCROLL_LIST;

		float nScrolls = GetTokenCount(listText) - 1.0f;
		int rndPick = RandomInt(0, int(nScrolls));
		string scrollName = GetToken(listText, rndPick);
		AddStoreItem(STORENAME, scrollName, 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_random_spell") { OnAddRandomSpell(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
