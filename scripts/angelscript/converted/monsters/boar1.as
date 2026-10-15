#pragma context server

// Converted from monsters/boar1.script by msc_transpiler.
// Goblin's Boar

#include "runtime/ScriptEntity.as"
#include "converted/monsters/boar.as"

[script "monsters/boar1"]
class Boar1 : BoarScript
{
	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BoarBase_OnNpcSpawn(npc); // monsters/boar_base
		Boar_OnNpcSpawn(npc); // monsters/boar

		SetHealth(15);
		// ov 120
		SetWidth(50);
		SetHeight(40);
		// NOV2014_21 - I think this is the wrong race, but not sure
		if (Contains(ToLowerCase(MapName()), "goblin"))
		{
			// maybe for goblintown
			SetRace("goblin");
		}
		else
		{
			SetRace("wildanimal");
		}
		SetName("Tamed Boar");
		SetRoam(true);
		SetHearingSensitivity(0);
		NPC_GIVE_EXP = 6.0f;

		SetModel("monsters/boar.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle1");
		SetMoveAnim("walk");
	}

	// npc_attack
	void OnNpcAttack()
	{
		BoarBase_OnNpcAttack(); // monsters/boar_base
	}

	// npc_enemysighted
	void OnNpcEnemysighted()
	{
		SetMoveSpeed(1);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "npc_attack") { OnNpcAttack(); return true; }
		if (name == "npc_enemysighted") { OnNpcEnemysighted(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BoarScript::DispatchEvent(name, params);
	}
}
