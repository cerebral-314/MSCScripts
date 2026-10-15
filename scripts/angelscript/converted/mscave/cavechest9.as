#pragma context server

// Converted from mscave/cavechest9.script by msc_transpiler.
// Thothie - Dun think we need TWO chests passing out FCK's... nerfing - making archer chest

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "mscave/cavechest9"]
class Cavechest9 : BaseTreasurechestScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(RandomInt(5, 20));
		// |Store name|  |Item name|  			|Quantity| |cost|	|Buy|	|Bundles of|
		AddStoreItem(STORENAME, "health_mpotion", 1, 0);
		AddStoreItem(STORENAME, "blunt_hammer2", 1, 0);
		AddStoreItem(STORENAME, "proj_arrow_wooden", 120, 0, 0, 60);

		OnGetChance(); // <single_player%> <%chance_per_player> [max_chance] [hp_req] - returns GIVE_PRIZE (1|0) and TC_CHANCE (Total %Chance)

		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "proj_arrow_broadhead", 120, 0, 0, 60);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "proj_arrow_poison", 120, 0, 0, 60);
		if (RandomInt(1, 100) <= 5)
			AddStoreItem(STORENAME, "proj_arrow_jagged", 120, 0, 0, 60);

		if (RandomInt(1, 50) == 1)
			AddStoreItem(STORENAME, "armor_helm_golden", 1, 0);
		if (RandomInt(1, 3) == 1)
			AddStoreItem(STORENAME, "pack_archersquiver", 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnGetChance() {} // get_chance

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
