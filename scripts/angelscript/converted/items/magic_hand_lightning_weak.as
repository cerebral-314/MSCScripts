#pragma context server

// Converted from items/magic_hand_lightning_weak.script by msc_transpiler.
// greatguys1@May2018
// -Changed spell type to effect so it can no longer be parried
// Thothie - changed so the lightning ramp limit increases with skill

#include "runtime/ScriptEntity.as"
#include "converted/items/magic_hand_base.as"

[script "items/magic_hand_lightning_weak"]
class MagicHandLightningWeak : MagicHandBaseScript
{
	// Constants
	string MELEE_RANGE = "500";
	string MELEE_HITCHANCE = "100%";
	float MELEE_ATK_DURATION = 1.0f;
	string SPELL_DAMAGE_TYPE = "lightning_effect";
	int SPELL_MPDRAIN = 1;
	string SPELL_STAT = "spellcasting.lightning";
	string SCRIPT_SFX_CAST = "effects/sfx_lightning";
	float SCRIPT_SFX_DURATION = 0.5f;
	string LIGHT_COLOR = "LIGHT_COLOR";

	// Variables (an unset .script variable reads as its own name)
	int SPELL_SKILL_REQUIRED = 0;
	float LAST_CAST = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	MagicHandLightningWeak()
	{
		MELEE_TYPE = "strike-land";
		MELEE_DMG = 25;
		MELEE_DMG_RANGE = 15;
		MELEE_NOAUTOAIM = true;
		MELEE_DMG_DELAY = 0.4f;
		SPELL_PREPARE_TIME = 2.0f;
		SPELL_ENERGYDRAIN = 10;
		SCRIPT_SFX_PREP = "items/magic_hand_lightning_weak_cl";
	}

	// unnamed block (first think)
	void MagicHandLightningWeak_FirstThink()
	{
		// -------------------------------------------------------
		SPELL_SKILL_REQUIRED = 0;
	}

	// game_precache
	void MagicHandLightningWeak_OnGamePrecache()
	{
		PrecacheFile(SCRIPT_SFX_CAST);
	}

	// unnamed block (timer)
	void MagicHandLightningWeak_Timer()
	{
		// (never true here, the rest is skipped) if IS_NEW_ITEM == 1
	}

	// game_precache
	void OnGamePrecache()
	{
		MagicHandLightningWeak_OnGamePrecache();
		MagicHandBase_OnGamePrecache(); // items/magic_hand_base
	}

	// spell_casted
	// PARAM1: "none"/"npc"/"world"   2: Attack end Position   3: Entity hit (if any)
	void OnSpellCasted(string hitType = "", Vector3 endPosition = Vector3(), CBaseEntity@ target = null)
	{
		MagicHandBase_OnSpellCasted(hitType, endPosition, target); // items/magic_hand_base

		LAST_CAST = GameTime();

		Vector3 end = endPosition + Vector3(0, 0, 4096);
		float widthratio = Clamp(SkillOf(ENT_OWNER, "spellcasting.lightning.ratio") * 3.0f, 0.0f, 1.0f); // help out with ratio

		ClientEvent("new", "all_in_sight", SCRIPT_SFX_CAST, endPosition, end, SCRIPT_SFX_DURATION, widthratio);
		if (hitType == "npc")
		{
			Effect("glow", @target, LIGHT_COLOR, 128, 1, 1);
			SetVar("script.npc", @target);
		}
		else
		{
			SetVar("script.ramp", 1); // Hit nothing - reset damage ramp
		}
	}

	// spell_spawn
	void OnSpellSpawn()
	{
		SetName("Erratic Lightning");
		SetDescription("A highly erratic lightning bolt");
		SetVar("script.ramp", 1);
	}

	// cast_damaged_other
	// Ramp up damage
	void OnCastDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		if (!IsAlive("script.npc"))
			return;
		if ("script.npc" != EntityId(target)) // Hit new npc - reset damage ramp
			SetVar("script.ramp", 1);

		float dmg = damage * 0.0f;
		SetDamageInfo("dmg", dmg);

		float rampLimit = Divide(SkillOf(ENT_OWNER, "spellcasting.lightning"), 2.0f);
		if (rampLimit < 3.0f)
			rampLimit = 3.0f;

		if (!(0.0f < rampLimit))
			return;
		LegacyCommand("add", "script.ramp", 0.6f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("viewmodels/v_martialarts.mdl");
		CallEventDelayed(Float(Eval("$randf(4.0,8.0)")), "MagicHandLightningWeak_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MagicHandLightningWeak_FirstThink();
		MagicHandBase_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "cast_damaged_other") { OnCastDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "spell_casted") { OnSpellCasted(Param(params, 0), Vec(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "spell_spawn") { OnSpellSpawn(); return true; }
		if (name == "MagicHandLightningWeak_Timer") { MagicHandLightningWeak_Timer(); return true; }
		return MagicHandBaseScript::DispatchEvent(name, params);
	}
}
