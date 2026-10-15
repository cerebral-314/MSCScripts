#pragma context server

// Converted from dq/voldararcher_turret.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/dq/voldararcher.as"

[script "dq/voldararcher_turret"]
class VoldararcherTurret : VoldararcherScript
{
	// Variables declared by included files, with the value they start with in this script
	VoldararcherTurret()
	{
		ANIM_WALK = "idle1";
		ANIM_RUN = "warcry";
	}

	// unnamed block (first think)
	void VoldararcherTurret_FirstThink()
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

		SetProp(ENT_ME, "skin", 3);
	}

	// back_off
	void OnBackOff()
	{
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VoldararcherTurret_FirstThink();
		OrcSniper_FirstThink();
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
		if (name == "back_off") { OnBackOff(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return VoldararcherScript::DispatchEvent(name, params);
	}
}
