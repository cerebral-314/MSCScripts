#pragma context server

// Converted from items/magic_hand_ice_shield_lesser.script by msc_transpiler.
// Thothie - lesser ice shield for nubs

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_ice_shield.as"

[script "items/magic_hand_ice_shield_lesser"]
class MagicHandIceShieldLesser : MagicHandIceShieldScript
{
	// Variables declared by included files, with the value they start with in this script
	MagicHandIceShieldLesser()
	{
		CSKILL_REQ = true;
		SPELL_ENERGYDRAIN = 25;
		SPELL_MPDRAIN = 20;
		MANA_COST = 20;
		ICESHIELD_FORMULA = 0.75f;
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		MagicHandIceShield_OnSpellSpawn(); // items/magic_hand_ice_shield

		SetName("Lesser Ice Shield");
		SetDescription("Provides 25% damage reduction for you or allies, for a time.");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		return MagicHandIceShieldScript::DispatchEvent(name, params);
	}
}
