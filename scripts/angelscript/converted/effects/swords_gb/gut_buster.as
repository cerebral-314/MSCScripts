#pragma context server

// Converted from effects/swords_gb/gut_buster.script by msc_transpiler.
// Copied from effect_shock_damage. By greatguys1
// Main effect for the Gut Buster sword, handles the sounds, sfx, dot, and causes gibs on death
// PARAMS:
// PARAM5 = <gut buster sword id>

#include "runtime/ScriptEntity.as"
#include "converted/effects/dot_bleed.as"

[script "effects/swords_gb/gut_buster"]
class GutBuster : DotBleedScript
{
	// Variables declared by included files, with the value they start with in this script
	GutBuster()
	{
		EFFECT_ID = "gb";
		EFFECT_FLAGS = "nostack";
		DOT_IM_AFFECTED = "Your flesh is defiled by the evil sword.";
	}

	// unnamed block (first think)
	void GutBuster_FirstThink()
	{
		// Tracks if the gibs have been bursted
		DID_PROC = false;
	}

	// get_num_gibs
	string GutBuster_OnGetNumGibs()
	{
		string result = "";

		// Size can add up to 2 additional gibs
		float numGibs = HeightOf(ENT_ME) + WidthOf(ENT_ME); // height + width
		numGibs = Divide(numGibs, 150.0f); // 1 gib per each 150 units
		numGibs = Clamp(numGibs, 0.0f, 2.0f);

		// Health can add up to 3 additional gibs
		L_HP_GIBS += Divide(MaxHealthOf(ENT_ME), 1750.0f); // additional gib per 1750 hp
		L_HP_GIBS = Clamp(L_HP_GIBS, 0.0f, 3.0f);

		numGibs += L_HP_GIBS;
		numGibs += 1.0f;

		result = "";
		result = AppendResult(result, Text(numGibs));
		return result;
	}

	// game_activate
	// <duration> <attacker> <damage> <activeSkill> <sword_id>
	void OnGameActivate(string duration = "", string amount = "", string damage = "", string skill = "", string extraValue5 = "", string falloff = "")
	{
		BaseEffect_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_effect
		BaseDot_OnGameActivate(duration, amount, damage, skill, extraValue5, falloff); // effects/base_dot

		// -Applies bleed fx and vars
		SWORD_ID = extraValue5;
		MY_BLOOD = GetProp(ENT_ME, "blood");
	}

	// game_death
	// -Causes gib burst proc
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseDot_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // effects/base_dot

		// Cause gib burst
		OnProcDeath();
	}

	// dot_start
	void OnDotStart()
	{
		BaseDot_OnDotStart(); // effects/base_dot
		DotBleed_OnDotStart(); // effects/dot_bleed
		// Apply blood fx
		LegacyCommand("bleed", ENT_ME, MY_BLOOD, 10000);
	}

	// proc_death
	// -Causes gib burst and applies relating fx
	void OnProcDeath()
	{
		int count;

		if (!DID_PROC)
		{
			DID_PROC = true;

			count = int(NUM_GIBS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnCreateGib();
			}

			// And apply some fx
			PlaySound(0, 10, "common/bodysplat.wav");

			// Monsters with a combined height and width of greater than 230 will not go invisible on death.
			if (!IsAlive(ENT_ME) && HeightOf(ENT_ME) + WidthOf(ENT_ME) < 150.0f) // Some enemies come back alive, double check if they did. In those events, I still want gibs, but the enemy shouldn't turn invisible.
			{
				SetProp(ENT_ME, "rendermode", 5);
				SetProp(ENT_ME, "renderamt", 0);
			}
		}
	}

	// create_gib
	// for looping
	void OnCreateGib()
	{
		Vector3 ang = Vector3(Random(70, 95), RandomInt(0, 359), 0);
		float force = 400.0f * loopIteration + 400.0f;

		Vector3 vec = RelativeVelocity(ang, Vector3(0, force, 0));
		// <owner> <velocity> <damage> <skill> <"green"|"red"> <sword_id>
		CreateNpc("effects/swords_gb/gb_gib_explode", OriginOf(ENT_ME), DOT_ATTACKER, vec, 0, "swordsmanship", MY_BLOOD, SWORD_ID);
	}

	string OnGetNumGibs() { return GutBuster_OnGetNumGibs(); } // get_num_gibs

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GutBuster_FirstThink();
		BaseDot_FirstThink();
		BaseEffect_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "create_gib") { OnCreateGib(); return true; }
		if (name == "dot_start") { OnDotStart(); return true; }
		if (name == "game_activate") { OnGameActivate(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_num_gibs") { Return(OnGetNumGibs()); return true; }
		if (name == "proc_death") { OnProcDeath(); return true; }
		return DotBleedScript::DispatchEvent(name, params);
	}
}
