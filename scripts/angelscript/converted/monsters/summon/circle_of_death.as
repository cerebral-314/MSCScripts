#pragma context server

// Converted from monsters/summon/circle_of_death.script by msc_transpiler.
// Circle of death, cast by gold forged skeletons.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe2.as"

[script "monsters/summon/circle_of_death"]
class CircleOfDeath : BaseAoe2Script
{
	// Constants
	string SOUND_PULSE = "ambience/pulsemachine.wav";

	// Variables (an unset .script variable reads as its own name)
	float DMG_BASE = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	bool AOE_AFFECTS_WARY = false;

	// Variables declared by included files, with the value they start with in this script
	CircleOfDeath()
	{
		AOE_SCAN_TYPE = "rsphere";
		AOE_SCAN_FREQ = 1.0f;
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

		PlaySound(1, 10, SOUND_PULSE);

		Vector3 ground = OriginOf(ENT_ME);
		ground.z = GroundHeight(ground);
		SetOrigin(ENT_ME, ground);

		ClientEvent("new", "all", "monsters/summon/circle_of_death_cl", ground, AOE_DURATION);
	}

	// aoe_end
	void OnAoeEnd()
	{
		BaseAoe2_OnAoeEnd(); // monsters/summon/base_aoe2

		PlaySound(1, 0, SOUND_PULSE);
		DeleteEntity(ENT_ME);
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// aoe_affect_target
	// <target>
	void OnAoeAffectTarget(string target = "")
	{
		DoDamageEx(target, "direct", DMG_BASE, "100%", AOE_OWNER, ENT_ME, ACTIVE_SKILL, "magic_effect"); // <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("skull.spr");
		Precache("weapons/magic/seals.mdl");
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
		return BaseAoe2Script::DispatchEvent(name, params);
	}
}
