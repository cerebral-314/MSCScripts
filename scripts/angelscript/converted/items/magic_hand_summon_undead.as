#pragma context server

// Converted from items/magic_hand_summon_undead.script by msc_transpiler.
// Thothie - Summoned skeleton doing no damage, so changing stats

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_summon_base.as"

[script "items/magic_hand_summon_undead"]
class MagicHandSummonUndead : MagicHandSummonBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	MagicHandSummonUndead()
	{
		SPELL_NAME = "Summon Undead";
		SPELL_DESC = "Summon an undead minion";
		SPELL_SKILL_REQUIRED = 8;
		SPELL_PREPARE_TIME = 5.0f;
		SPELL_MPDRAIN = 10;
		EFFECT_MAXDURATION = 360;
		EFFECT_MINDURATION = 30.0f;
		EFFECT_MAX_DMG = 20;
		EFFECT_MIN_DMG = 5.0f;
		EFFECT_SCRIPT = "monsters/summon/skeleton";
	}

	// unnamed block (first think)
	void MagicHandSummonUndead_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 8;
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		if (Float(GetVar("CURRENT_SUMMONS")) >= Float(GetVar("MAX_SUMMONS")))
			OwnerMessage("Too many summoned monsters present, cannot create more.");

		if (!(Float(GetVar("CURRENT_SUMMONS")) < Float(GetVar("MAX_SUMMONS"))))
			return;

		float sumDmg = Divide(SkillOf(ENT_OWNER, "spellcasting"), 4.0f);

		float sumDuration = Float(EFFECT_DURATION);
		sumDuration *= 1.5f;

		float sumLevel = SkillOf(ENT_OWNER, "spellcasting");

		// //dbg SkeleDmg SUM_DMG SkeleHP EFFECT_DURATION

		// allow stacking
		// vectorset SPAWN_ORG z $get_ground_height(SPAWN_ORG)
		// vectoradd SPAWN_ORG z 5
		CreateNpc(EFFECT_SCRIPT, endPosition, @EntityOf(ENT_OWNER), sumDuration, sumDmg);

		OnSummonCheck(Text(endPosition));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandSummonUndead_FirstThink();
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
