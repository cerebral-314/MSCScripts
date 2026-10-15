#pragma context server

// Converted from monsters/morc_shaman_ice_turret.script by msc_transpiler.
// same concept as monsters/spider_turret - thows fireballs, does not move

#include "runtime/ScriptEntity.as"
#include "converted/monsters/morc_shaman_ice.as"

[script "monsters/morc_shaman_ice_turret"]
class MorcShamanIceTurret : MorcShamanIceScript
{
	// Variables declared by included files, with the value they start with in this script
	MorcShamanIceTurret()
	{
		ANIM_WALK = "idle1";
		ANIM_RUN = "warcry";
	}

	// unnamed block (first think)
	void MorcShamanIceTurret_FirstThink()
	{
		ANIM_WALK = "idle1";
		ANIM_RUN = "warcry";
		NO_STUCK_CHECKS = "1"; // not stuck, I just don't move
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OrcBase_OnNpcSpawn(npc); // monsters/orc_base

		SetRoam(false);
		SetMoveSpeed(0);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MorcShamanIceTurret_FirstThink();
		MorcShamanIce_FirstThink();
		OrcBaseRanged_FirstThink();
		OrcBase_FirstThink();
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
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return MorcShamanIceScript::DispatchEvent(name, params);
	}
}
