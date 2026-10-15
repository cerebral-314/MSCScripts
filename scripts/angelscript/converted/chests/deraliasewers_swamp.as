#pragma context server

// Converted from chests/deraliasewers_swamp.script by msc_transpiler.
// Extra hidden chest to spawn when the swamp critters are cleared

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/deraliasewers_swamp"]
class DeraliasewersSwamp : BaseTreasurechestScript
{
	// Constants
	string POT_LIST = "mana_speed;mana_immune_poison;mana_immune_cold;mana_immune_fire;mana_demon_blood;mana_gprotection;mana_bravery;mana_fbrand;mana_faura;mana_paura";

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnLAddEpicPotion();

		if (RandomInt(1, 4) == 1)
			OnLAddEpicPotion();
		if (RandomInt(1, 4) == 1)
			OnLAddEpicPotion();
	}

	// l_add_epic_potion
	void OnLAddEpicPotion()
	{
		float nPots = GetTokenCount(POT_LIST) - 1.0f;
		int rndPick = RandomInt(0, int(nPots));
		string rndPot = GetToken(POT_LIST, rndPick);
		AddStoreItem(STORENAME, rndPot, 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "l_add_epic_potion") { OnLAddEpicPotion(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
