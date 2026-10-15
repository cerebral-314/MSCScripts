#pragma context server

// Converted from monsters/eagle_demon.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/eagle_base.as"

[script "monsters/eagle_demon"]
class EagleDemon : EagleBaseScript
{
	// Constants
	int DMG_DOT_BURN = 0;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	bool AM_PHLAMES = false;

	// Variables declared by included files, with the value they start with in this script
	EagleDemon()
	{
		NO_DIVE = true;
	}

	// unnamed block (first think)
	void EagleDemon_FirstThink()
	{
		IS_UNHOLY = true;
		NPC_GIVE_EXP = 250.0f;
	}

	// game_dodamage
	string EagleDemon_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		DebugPrint("game_dodamage");

		if (MELEE_ATTACK && hit)
		{
			if (RandomInt(1, 5) == 1)
				ApplyEffect(target, "effects/dot_fire", 5, self, DMG_DOT_BURN);

			AddVelocity(target, RelativeVelocity(Vector3(20, 200, 10)));
		}
		MELEE_ATTACK = false;
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		EagleBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/eagle_base
		LegacyCommand("subtract", "G_FLAMES_EAGLES", 1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleBase_OnNpcSpawn(npc); // monsters/eagle_base

		SetName("Fowl Demon");
		SetRace("demon");
		SetHealth(600);
		SetWidth(32);
		SetHeight(32);
		SetModel("monsters/eagle.mdl");
		SetIdleAnim("flapping");
		SetMoveAnim("flapping");
		SetHearingSensitivity(11);
		SetRoam(true);
		SetFly(true);
		SetDamageTaken("poison", 1);
		SetDamageTaken("cold", 3);
		SetDamageTaken("holy", 3);
		SetDamageTaken("fire", 0);
		SetProp(ENT_ME, "skin", 1);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleDemon_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// phlames_eagle
	void OnPhlamesEagle()
	{
		AM_PHLAMES = true;
		LegacyCommand("add", "G_FLAMES_EAGLES", 1);
		LegacyCommand("add", "G_NPC_SUMMON_COUNT", 1);
		NPC_SUMMON = true;
		DebugPrint("set_summon " + GetVar("G_NPC_SUMMON_COUNT"));
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EagleDemon_FirstThink();
		EagleBase_FirstThink();
		BaseFlyer_FirstThink();
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
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "phlames_eagle") { OnPhlamesEagle(); return true; }
		return EagleBaseScript::DispatchEvent(name, params);
	}
}
