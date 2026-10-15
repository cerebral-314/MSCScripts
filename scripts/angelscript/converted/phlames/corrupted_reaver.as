#pragma context server

// Converted from phlames/corrupted_reaver.script by msc_transpiler.
// oversized corrupted reaver
// tried set_scale, but doesn't work nicely with default model

#include "runtime/ScriptEntity.as"
#include "converted/monsters/swamp_reaver.as"

[script "phlames/corrupted_reaver"]
class PhlamesCorruptedReaver : SwampReaverScript
{
	// Constants
	bool MIXED_REAVER = true;

	// Variables declared by included files, with the value they start with in this script
	PhlamesCorruptedReaver()
	{
		REAVER_NAME = "Corrupted Reaver";
		REAVER_MAXHP = 5000;
		REAVER_XP = 3750;
		REAVER_SKIN = 2;
		REAVER_MODEL = "monsters/firereaver2.mdl";
		REAVER_WIDTH = 90;
		REAVER_HEIGHT = 72;
		FIREBALL1_SCRIPT = "monsters/summon/fire_ball_guided";
		FIREBALL1_DURATION = 15.0f;
		FIREBALL2_DURATION = 8.0f;
	}

	// game_precache
	void PhlamesCorruptedReaver_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/fire_ball_guided");
		PrecacheFile("monsters/summon/acid_ball_guided");
		PrecacheFile("effects/sfx_acid_splash");
	}

	// game_precache
	void OnGamePrecache()
	{
		PhlamesCorruptedReaver_OnGamePrecache();
		SwampReaver_OnGamePrecache(); // monsters/swamp_reaver
	}

	// mixed_reaver_switch
	void OnMixedReaverSwitch()
	{
		MIX_COUNT += 1.0f;
		if (MIX_COUNT == 1.0f)
		{
			DOT_EFFECT = "effects/dot_fire"; // mix reaver varies
			DOT_DURATION = 5.0f; // mix reaver varies
			DOT_DMG = 60.0f; // mix reaver varies
			ERRUPT_TYPE = "fire";
			BREATH_TYPE = "fire";
			PROJECTILE_SCRIPT = "proj_fire_bomb";
			DOT_ACID_BOMB = 200;
			EFFECT_ACID_BOMB = "effects/dot_fire";
			SetBlood("red");
		}

		if (MIX_COUNT == 2.0f)
		{
			DOT_EFFECT = "effects/dot_poison"; // mix reaver varies
			DOT_DURATION = 10.0f; // mix reaver varies
			DOT_DMG = 30.0f; // mix reaver varies
			ERRUPT_TYPE = "poison";
			BREATH_TYPE = "poison";
			PROJECTILE_SCRIPT = "proj_acid_bomb";
			DOT_ACID_BOMB = 150;
			EFFECT_ACID_BOMB = "effects/dot_acid";
			SetBlood("green");
			MIX_COUNT = 0.0f;
		}
	}

	// reaver_immunes
	void OnReaverImmunes()
	{
		SetDamageTaken("lightning", 1.25f);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("acid", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("holy", 0.5f); // some magic involved in creation
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("monsters/firereaver2.mdl");
		Precache("magic/volcano_loop.wav");
		Precache("amb/amb_spa2.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "mixed_reaver_switch") { OnMixedReaverSwitch(); return true; }
		if (name == "reaver_immunes") { OnReaverImmunes(); return true; }
		return SwampReaverScript::DispatchEvent(name, params);
	}
}
