#pragma context server

// Converted from items/bows_telf2.script by msc_transpiler.
// Telf bows by Thothie, from Phoenix Bow by CMD

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_telf1.as"

[script "items/bows_telf2"]
class BowsTelf2 : BowsTelf1Script
{
	// Variables declared by included files, with the value they start with in this script
	BowsTelf2()
	{
		DAMAGE_TYPE = "cold_effect";
		DMG_ADJ = 0.55f;
	}

	// ranged_start
	void OnRangedStart()
	{
		BowsBase_OnRangedStart(); // items/bows_base
		BowsTelf1_OnRangedStart(); // items/bows_telf1
		float ownerSkill = SkillOf(ENT_OWNER, "spellcasting.ice");
		if (!(ownerSkill < 15.0f))
			return;
		PlayerMessageDark(ENT_OWNER, "You lack the ice affinity to activate this bow's magic.");
		CancelAttack();
	}

	// bow_spawn
	void OnBowSpawn()
	{
		BowsTelf1_OnBowSpawn(); // items/bows_telf1

		SetName("Torkalath Frost Bow");
		SetDescription("This enchanted bow is cold to the touch.");
		SetWeight(100);
		SetValue(1500);
		SetHudSprite("trade", "166");

		OnCustomRegister();
	}

	// set_bow_type
	void OnSetBowType()
	{
		float dmgAmt = SkillOf(ENT_OWNER, "spellcasting.ice") * DMG_ADJ;
		if (UNDER_SKILLED)
			dmgAmt *= 0.1f;
		TORKIE_BOW_TYPE = "cold";
		CallExternal(ENT_OWNER, "ext_set_spiral", TORKIE_BOW_TYPE, dmgAmt);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "set_bow_type") { OnSetBowType(); return true; }
		return BowsTelf1Script::DispatchEvent(name, params);
	}
}
