#pragma context server

// Converted from monsters/fire_reaver.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/swamp_reaver.as"

[script "monsters/fire_reaver"]
class FireReaver : SwampReaverScript
{
	// Constants
	string BLOOD_COLOR = "red";

	// Variables declared by included files, with the value they start with in this script
	FireReaver()
	{
		REAVER_NAME = "Fire Reaver";
		REAVER_XP = 1500;
		REAVER_SKIN = 0;
		FREQ_ERRUPT = 20.0f;
		FIREBALL1_SCRIPT = "monsters/summon/fire_ball_guided";
		FIREBALL2_SCRIPT = "monsters/summon/fire_ball_guided";
		FIREBALL1_DURATION = 15.0f;
		FIREBALL2_DURATION = 15.0f;
		BOMB_DMG_TYPE = "blunt";
	}

	// game_precache
	void FireReaver_OnGamePrecache()
	{
		PrecacheFile("monsters/summon/fire_ball_guided");
	}

	// game_precache
	void OnGamePrecache()
	{
		FireReaver_OnGamePrecache();
		SwampReaver_OnGamePrecache(); // monsters/swamp_reaver
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		DOT_EFFECT = "effects/dot_fire";
		DOT_DURATION = 5.0f;
		DOT_DMG = 45.0f;
		ERRUPT_TYPE = "fire";
		BREATH_TYPE = "fire";
		PROJECTILE_SCRIPT = "proj_fire_bomb";
		DOT_ACID_BOMB = 200;
		EFFECT_ACID_BOMB = "effects/dot_fire";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xfireball3.spr");
		Precache("monsters/firereaver.mdl");
		Precache("magic/volcano_loop.wav");
		Precache("amb/amb_spa2.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		return SwampReaverScript::DispatchEvent(name, params);
	}
}
