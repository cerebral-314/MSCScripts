#pragma context server

// Converted from monsters/snake_lord.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/slithar/slithar.as"

[script "monsters/snake_lord"]
class SnakeLord : SlitharScript
{
	// Variables declared by included files, with the value they start with in this script
	SnakeLord()
	{
		GENERIC_LORD = true;
		ANIM_RUN = "ANIM_RUN";
	}

	// unnamed block (first think)
	void SnakeLord_FirstThink()
	{
		NPC_GIVE_EXP = 400.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Slithar_OnNpcSpawn(npc); // slithar/slithar

		SetName("Snake Lord");
		SetRace("demon");
		SetHealth(3000);
		SetWidth(32);
		SetHeight(84);
		SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetIdleAnim(ANIM_IDLE);
		SetHearingSensitivity(10);

		SetInvincible(false);

		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("holy", 1.5f);

		SNAKE_SLOT = 0.0f;

		LOOKING_FOR_PLAYERS = false;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		ANIM_RUN = ANIM_RUNFAST;
		SetMoveAnim(ANIM_RUN);
		SUMMON_SNAKE_FREQ = 5.0f;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		SUMMON_SNAKE_FREQ = 30.0f;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		SUMMON_SNAKE_FREQ = 2.0f;
		ANIM_RUN = ANIM_RUNFAST;
		CallEventDelayed(25.0f, "snake_slowdown");
		CallEventDelayed(5.0f, "summon_snake");
	}

	// look_for_players
	void OnLookForPlayers()
	{
		LOOKING_FOR_PLAYERS = false;
	}

	// me_pouncie
	void OnMePouncie(CBaseEntity@ firstTarget = null)
	{
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SnakeLord_FirstThink();
		Slithar_FirstThink();
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
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "look_for_players") { OnLookForPlayers(); return true; }
		if (name == "me_pouncie") { OnMePouncie(EntityParam(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		return SlitharScript::DispatchEvent(name, params);
	}
}
