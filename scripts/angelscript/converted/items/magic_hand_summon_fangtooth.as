#pragma context server

// Converted from items/magic_hand_summon_fangtooth.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_summon_base.as"

[script "items/magic_hand_summon_fangtooth"]
class MagicHandSummonFangtooth : MagicHandSummonBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	MagicHandSummonFangtooth()
	{
		SPELL_NAME = "Summon Fangtooth";
		SPELL_DESC = "Summons a fast moving plague rat";
		SPELL_SKILL_REQUIRED = 12;
		SPELL_MPDRAIN = 30;
		EFFECT_SCRIPT = "monsters/summon/fangtooth";
	}

	// unnamed block (first think)
	void MagicHandSummonFangtooth_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 12;

		PrecacheFile(EFFECT_SCRIPT);
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		if (Float(GetVar("CURRENT_SUMMONS")) >= Float(GetVar("MAX_SUMMONS")))
			OwnerMessage("Too many summoned monsters present, cannot create more.");

		if (!(Float(GetVar("CURRENT_SUMMONS")) < Float(GetVar("MAX_SUMMONS"))))
			return;

		float sumDmg = Divide(SkillOf(ENT_OWNER, "spellcasting"), 2.0f);

		float sumLevel = SkillOf(ENT_OWNER, "spellcasting");

		float sumDuration = Float(EFFECT_DURATION);
		sumDuration *= 2.0f;

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
		MagicHandSummonFangtooth_FirstThink();
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
