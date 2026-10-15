#pragma context server

// Converted from monsters/summon/poison_cloud2.script by msc_transpiler.
// Thothie MAR2010_15
// - Sick of poison cloud doing weird shit, so redoing from scratch

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe2.as"

[script "monsters/summon/poison_cloud2"]
class PoisonCloud2 : BaseAoe2Script
{
	// Constants
	string SOUND_SPAWN = "ambience/steamburst1.wav";

	// Variables (an unset .script variable reads as its own name)
	float DMG_BASE = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	bool AOE_AFFECTS_WARY = false;

	// Variables declared by included files, with the value they start with in this script
	PoisonCloud2()
	{
		AOE_SCAN_TYPE = "rsphere";
	}

	// game_dynamically_created
	// PARAM1=Owner PARAM2=radius PARAM3=Damage PARAM4=Duration [PARAM5=skill]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseAoe2_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_aoe2
		AOE_OWNER = creatorValue1;
		AOE_RADIUS = creatorValue2;
		DMG_BASE = Float(damage);
		AOE_DURATION = skill;
		ACTIVE_SKILL = extraValue5;
		AOE_AFFECTS_WARY = true;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.affliction";

		ClientEvent("new", "all", "effects/sfx_cloud", OriginOf(ENT_ME), AOE_DURATION, AOE_RADIUS, Vector3(0, 255, 0), "poison_cloud.spr");
	}

	// aoe_end
	void OnAoeEnd()
	{
		BaseAoe2_OnAoeEnd(); // monsters/summon/base_aoe2
		CallEventDelayed(0.1f, "remove_me");
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// aoe_affect_target
	// <target>
	void OnAoeAffectTarget(string target = "")
	{
		ApplyEffect(target, "effects/dot_poison", 15.0f, AOE_OWNER, DMG_BASE, ACTIVE_SKILL);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		CallEventDelayed(AOE_SCAN_FREQ, "aoe_scan_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "aoe_affect_target") { OnAoeAffectTarget(Param(params, 0)); return true; }
		if (name == "aoe_end") { OnAoeEnd(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return BaseAoe2Script::DispatchEvent(name, params);
	}
}
