#pragma context server

// Converted from items/magic_hand_summon_bear1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_summon_base.as"

[script "items/magic_hand_summon_bear1"]
class MagicHandSummonBear1 : MagicHandSummonBaseScript
{
	// Constants
	bool SUMMON_UNQIUE = true;
	string SUMMON_UNIQUE_TAG = "bear1";
	string SUMMON_UNIQUE_NAME = "Bear Guardian";

	// Variables declared by included files, with the value they start with in this script
	MagicHandSummonBear1()
	{
		SPELL_NAME = "Summon Bear";
		SPELL_DESC = "Summons a Bear Guardian";
		SPELL_SKILL_REQUIRED = 20;
		SPELL_MPDRAIN = 30;
		EFFECT_SCRIPT = "monsters/summon/bear1";
	}

	// unnamed block (first think)
	void MagicHandSummonBear1_FirstThink()
	{
		SPELL_SKILL_REQUIRED = 20;

		PrecacheFile(EFFECT_SCRIPT);
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		bool exitSub = false;

		if (Float(GetVar("CURRENT_SUMMONS")) >= Float(GetVar("MAX_SUMMONS")))
			OwnerMessage("Too many summoned monsters present, cannot create more.");

		if (!(Float(GetVar("CURRENT_SUMMONS")) < Float(GetVar("MAX_SUMMONS"))))
			return;

		if (SUMMON_UNQIUE && Contains(ScriptVarOf(ENT_OWNER, "PLR_UNIQUE_SUMMONS"), SUMMON_UNIQUE_TAG))
		{
			PlayerMessageDark(ENT_OWNER, "You may only summon one " + SUMMON_UNIQUE_NAME + " at a time.");
			GiveMana(ENT_OWNER, SPELL_MPDRAIN);
			exitSub = true;
		}
		if (exitSub)
			return;

		float sumDuration = Float(EFFECT_DURATION);
		sumDuration *= 2.0f;

		Vector3 spawnOrg = endPosition;
		spawnOrg.z = GroundHeight(spawnOrg);
		spawnOrg.z += 5.0f;
		CreateNpc(EFFECT_SCRIPT, spawnOrg, @EntityOf(ENT_OWNER), sumDuration);

		OnSummonCheck(Text(spawnOrg));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandSummonBear1_FirstThink();
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
