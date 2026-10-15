#pragma context server

// Converted from roghan/slow_walk.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "roghan/slow_walk"]
class SlowWalk : BaseMonsterNewScript
{
	// Constants
	string ANIM_KICK = "kick";
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string ATTACK_HITCHANCE = "100";
	string DMG_KICK = "DMG_KICK";
	string MONSTER_MODEL = "monsters/Orc.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float CUR_PLAYERS = 0.0f;
	float TIMES_HIT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SlowWalk()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "voices/orc/die.wav";
	}

	// unnamed block (first think)
	void SlowWalk_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = ANIM_KICK;
		ANIM_DEATH = "die_fallback";
		ANIM_IDLE = "idle1";

		CAN_FLINCH = "0";

		DROP_GOLD = 0;

		MOVE_RANGE = "64"; // Greater than monster width
		ATTACK_RANGE = 90.0f; // Bit more than move range
		ATTACK_HITRANGE = 120.0f; // Monster height +38 and 150% ATTACK_RANGE
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string SlowWalk_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		TIMES_HIT += 1.0f;
		if (TIMES_HIT == CUR_PLAYERS)
			SetHealth(0);
		PlayRandomSound(0, 8, SOUND_PAIN, "none");
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Frozen Spirit");
		SetRace("evil");

		SetHealth(10000);

		SetModel(MONSTER_MODEL);
		SetWidth(32);
		SetHeight(72);

		SetDamageTaken("all", 0.5f);

		CUR_PLAYERS = PlayerCount() * 4.0f;
		TIMES_HIT = 0.0f;

		SetAnimMoveSpeed(0.5f);
		SetAnimFrameRate(0.5f);
		BASE_MOVESPEED = 0.5f;
		BASE_FRAMERATE = "0.5";
		LegacyCommand("hearingsensitivity");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SlowWalk_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// kick_land
	void OnKickLand()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), DMG_KICK, ATTACK_HITCHANCE, "slash");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/Orc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlowWalk_FirstThink();
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
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
