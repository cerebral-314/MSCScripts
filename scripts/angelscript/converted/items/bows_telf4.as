#pragma context server

// Converted from items/bows_telf4.script by msc_transpiler.
// Telf bows by Thothie, from Phoenix Bow by CMD

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_telf1.as"

[script "items/bows_telf4"]
class BowsTelf4 : BowsTelf1Script
{
	// Variables (an unset .script variable reads as its own name)
	string SKILL_TYPE = "SKILL_TYPE";

	// Variables declared by included files, with the value they start with in this script
	BowsTelf4()
	{
		DAMAGE_TYPE = "dark";
		DMG_ADJ = 0.75f;
	}

	// ranged_start
	void OnRangedStart()
	{
		BowsBase_OnRangedStart(); // items/bows_base
		BowsTelf1_OnRangedStart(); // items/bows_telf1
		OnSetBowType();
	}

	// bow_spawn
	void OnBowSpawn()
	{
		BowsTelf1_OnBowSpawn(); // items/bows_telf1

		SetName("Torkalath Chaos Bow");
		SetDescription("An enchanted bow oft wielded by the dark elves of Torkalath.");
		SetWeight(100);
		SetValue(1750);
		SetHudSprite("trade", "166");

		OnCustomRegister();
	}

	// set_bow_type
	void OnSetBowType()
	{
		float dmgAmt = 0.0f;

		int rndArrow = RandomInt(1, 3);
		if (rndArrow == 1)
		{
			TORKIE_BOW_TYPE = "fire";
			dmgAmt = SkillOf(ENT_OWNER, "spellcasting.fire");
			SKILL_TYPE = "fire";
			if (dmgAmt < 15.0f)
				OnMagicSkillCancel();
			dmgAmt *= DMG_ADJ;
		}
		if (rndArrow == 2)
		{
			TORKIE_BOW_TYPE = "cold";
			dmgAmt = SkillOf(ENT_OWNER, "spellcasting.ice");
			SKILL_TYPE = "ice";
			if (dmgAmt < 15.0f)
				OnMagicSkillCancel();
			dmgAmt *= DMG_ADJ;
		}
		if (rndArrow == 3)
		{
			TORKIE_BOW_TYPE = "lightning";
			dmgAmt = SkillOf(ENT_OWNER, "spellcasting.lightning");
			SKILL_TYPE = "lightning";
			if (dmgAmt < 15.0f)
				OnMagicSkillCancel();
			dmgAmt *= DMG_ADJ;
		}

		if (UNDER_SKILLED)
			dmgAmt *= 0.1f;

		CallExternal(ENT_OWNER, "ext_set_spiral", TORKIE_BOW_TYPE, dmgAmt);
	}

	// magic_skill_cancel
	void OnMagicSkillCancel()
	{
		PlayerMessageDark(ENT_OWNER, "The projectile fails to form due to your lack of " + SKILL_TYPE + " affinity.");
		CancelAttack();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		if (name == "magic_skill_cancel") { OnMagicSkillCancel(); return true; }
		if (name == "ranged_start") { OnRangedStart(); return true; }
		if (name == "set_bow_type") { OnSetBowType(); return true; }
		return BowsTelf1Script::DispatchEvent(name, params);
	}
}
