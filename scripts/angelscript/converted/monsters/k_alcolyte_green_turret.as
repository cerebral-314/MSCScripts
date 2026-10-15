#pragma context server

// Converted from monsters/k_alcolyte_green_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/k_alcolyte.as"

[script "monsters/k_alcolyte_green_turret"]
class KAlcolyteGreenTurret : KAlcolyteScript
{
	// Constants
	int OVERRIDE_TYPE = 1;
	bool AM_TURRET = true;
	bool NO_JUMPS = true;

	// Variables (an unset .script variable reads as its own name)
	string MOVE_TYPE = "MOVE_TYPE";

	// Variables declared by included files, with the value they start with in this script
	KAlcolyteGreenTurret()
	{
		ANIM_WALK_NORM = "crouch_idle";
		ANIM_RUN_NORM = "crouch_idle";
		ANIM_IDLE_NORM = "crouch_idle";
		ANIM_HOP = "crouch_idle";
		ANIM_JUMP = "crouch_idle";
		ANIM_CRAWL = "crouch_idle";
		ANIM_ATTACK_NORM = "crouch_shoot_knife";
	}

	// unnamed block (first think)
	void KAlcolyteGreenTurret_FirstThink()
	{
		ALCO_TYPE = "3";
		NO_STUCK_CHECKS = "1";
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
		KAlcolyte_OnNpcPostSpawn(); // monsters/k_alcolyte
		CallEventDelayed(1.0f, "crawl_mode");
		MOVE_TYPE = "crawl";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KAlcolyte_OnNpcSpawn(npc); // monsters/k_alcolyte
		SetRoam(false);
		SetMoveSpeed(0);
		CallEventDelayed(0.5f, "crawl_mode");
	}

	// run_mode
	// fucker keeps getting out of crawl mode, no idea how
	void OnRunMode()
	{
		OnCrawlMode();
	}

	// walk_mode
	void OnWalkMode()
	{
		OnCrawlMode();
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KAlcolyteGreenTurret_FirstThink();
		KAlcolyte_FirstThink();
		KAlcolyte_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "run_mode") { OnRunMode(); return true; }
		if (name == "walk_mode") { OnWalkMode(); return true; }
		return KAlcolyteScript::DispatchEvent(name, params);
	}
}
