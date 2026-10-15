#pragma context server

// Converted from monsters/eagle_metal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/eagle_base.as"

[script "monsters/eagle_metal"]
class EagleMetal : EagleBaseScript
{
	// Constants
	int DMG_DOT_BURN = 0;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;

	// Variables declared by included files, with the value they start with in this script
	EagleMetal()
	{
		NO_DIVE = true;
		SOUND_STRUCK = "weapons/axemetal1.wav";
		SOUND_PAIN = "weapons/axemetal2.wav";
		SOUND_PAIN2 = "doors/doorstop5.wav";
	}

	// unnamed block (first think)
	void EagleMetal_FirstThink()
	{
		IS_UNHOLY = true;
		NPC_GIVE_EXP = 400.0f;
	}

	// game_dodamage
	string EagleMetal_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (MELEE_ATTACK && hit)
		{
			if (RandomInt(1, 10) == 1)
				ApplyEffect(target, "effects/debuff_stun", 5, self);

			AddVelocity(target, RelativeVelocity(Vector3(30, 300, 30)));
		}
		MELEE_ATTACK = false;
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		EagleBase_OnNpcSpawn(npc); // monsters/eagle_base

		SetName("Eagle made of metal");
		SetRace("demon");
		SetHealth(800);
		SetBlood("none");
		SetWidth(32);
		SetHeight(32);
		SetModel("monsters/eagle.mdl");
		SetIdleAnim("flapping");
		SetMoveAnim("flapping");
		SetHearingSensitivity(11);
		SetRoam(true);
		SetFly(true);
		SetDamageTaken("all", 0.25f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
		SetDamageTaken("lightning", 3);
		SetProp(ENT_ME, "skin", 5);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, EagleMetal_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		EagleMetal_FirstThink();
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
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return EagleBaseScript::DispatchEvent(name, params);
	}
}
