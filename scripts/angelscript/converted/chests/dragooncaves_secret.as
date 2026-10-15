#pragma context server

// Converted from chests/dragooncaves_secret.script by msc_transpiler.
// sekrat chest (requires most of map complete, but not boss)

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/dragooncaves_secret"]
class DragooncavesSecret : BaseTreasurechestScript
{
	// Constants
	string EPIC_POTION_LIST = "mana_faura;mana_paura;mana_speed;mana_gprotection;mana_immune_cold;mana_immune_fire;mana_immune_poison;mana_demon_blood;mana_regen;mana_leadfoot;mana_immune_lightning";
	string GOOD_POTION_LIST = "mana_resist_cold;mana_resist_cold;mana_resist_fire;mana_vampire;mana_prot_spiders";

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest

		OnAddGold(550.0f);

		OnAddNoobItem();

		OnDraAddRandomPot();
		OnDraAddRandomPot();

		float nPotions = GetTokenCount(EPIC_POTION_LIST) - 1.0f;
		int rndPotion = RandomInt(0, int(nPotions));
		AddStoreItem(STORENAME, GetToken(EPIC_POTION_LIST, rndPotion), 1, 0);

		if (RandomInt(1, 3) != 1)
			return;

		OnDraAddRandomPot();
	}

	// dra_add_random_pot
	void OnDraAddRandomPot()
	{
		float nPotions = GetTokenCount(GOOD_POTION_LIST) - 1.0f;
		int rndPotion = RandomInt(0, int(nPotions));
		AddStoreItem(STORENAME, GetToken(GOOD_POTION_LIST, rndPotion), 1, 0);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "dra_add_random_pot") { OnDraAddRandomPot(); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
