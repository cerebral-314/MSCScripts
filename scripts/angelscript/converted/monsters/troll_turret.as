#pragma context server

// Converted from monsters/troll_turret.script by msc_transpiler.
// same concept as monsters/spider_turret - thows stones, does not move

#include "runtime/ScriptEntity.as"
#include "converted/monsters/troll_lobber.as"

[script "monsters/troll_turret"]
class TrollTurret : TrollLobberScript
{
	// Variables declared by included files, with the value they start with in this script
	TrollTurret()
	{
		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";
	}

	// unnamed block (first think)
	void TrollTurret_FirstThink()
	{
		ANIM_WALK = "idle0";
		ANIM_RUN = "idle1";
		NO_STUCK_CHECKS = "1"; // not stuck, I just don't move
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		TrollLobber_OnNpcSpawn(npc); // monsters/troll_lobber

		SetRoam(false);
		SetMoveSpeed(0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollTurret_FirstThink();
		TrollLobber_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return TrollLobberScript::DispatchEvent(name, params);
	}
}
