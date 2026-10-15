#pragma context server

// Converted from items/magic_hand_summon_rat.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_summon_base.as"

[script "items/magic_hand_summon_rat"]
class MagicHandSummonRat : MagicHandSummonBaseScript
{
	// Constants
	string EFFECT_SCRIPT2 = "monsters/summon/giant_rat";

	// Variables declared by included files, with the value they start with in this script
	MagicHandSummonRat()
	{
		SPELL_NAME = "Summon Rat";
		SPELL_DESC = "Summon a giant rat";
		SPELL_SKILL_REQUIRED = 3;
		EFFECT_SCRIPT = "monsters/summon/rat";
	}

	// unnamed block (first think)
	void MagicHandSummonRat_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 3;

		PrecacheFile(EFFECT_SCRIPT2);
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		if (Float(GetVar("CURRENT_SUMMONS")) >= Float(GetVar("MAX_SUMMONS")))
			OwnerMessage("Too many summoned monsters present, cannot create more.");

		if (!(Float(GetVar("CURRENT_SUMMONS")) < Float(GetVar("MAX_SUMMONS"))))
			return;

		float sumDmg = Divide(SkillOf(ENT_OWNER, "spellcasting"), 5.0f);

		float sumLevel = SkillOf(ENT_OWNER, "spellcasting");

		// //dbg RatDmg SUM_DMG RatHP EFFECT_DURATION

		// allow stacking
		// vectorset SPAWN_ORG z $get_ground_height(SPAWN_ORG)
		// vectoradd SPAWN_ORG z 5
		if (sumLevel < 8.0f)
			CreateNpc(EFFECT_SCRIPT, endPosition, @EntityOf(ENT_OWNER), EFFECT_DURATION, sumDmg);
		if (sumLevel >= 8.0f)
			CreateNpc("monsters/summon/giant_rat", endPosition, @EntityOf(ENT_OWNER), EFFECT_DURATION, sumDmg);

		OnSummonCheck(Text(endPosition));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandSummonRat_FirstThink();
		MagicHandSummonBase_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		return MagicHandSummonBaseScript::DispatchEvent(name, params);
	}
}
