#pragma context server

// Converted from monsters/slime_green.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/slime_green"]
class SlimeGreen : BaseMonsterNewScript
{
	// Constants
	string SOUND_STRUCK1 = "barnacle/bcl_bite3.wav";
	string SOUND_STRUCK2 = "barnacle/bcl_die3.wav";
	string SOUND_IDLE = "barnacle/bcl_alert2.wav";
	string SOUND_ATTACK1 = "barnacle/bcl_tongue1.wav";
	string SOUND_ATTACK2 = "barnacle/bcl_chew3.wav";
	string ATTACK_HITCHANCE = "75%";
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string POISON_DAMAGE = "POISON_DAMAGE";
	float FREQ_SPIT = 2.0f;
	int SPIT_DAMAGE = 0;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SPIT_TARGET = "SPIT_TARGET";
	bool SPIT_DELAY = false;

	// Variables declared by included files, with the value they start with in this script
	SlimeGreen()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void SlimeGreen_FirstThink()
	{
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		MOVE_RANGE = "256";
		ATTACK_MOVERANGE = 256.0f;
		MOVE_RANGE = "256";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		ATTACK_RANGE = 40.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// game_damaged_other
	string SlimeGreen_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (RandomInt(1, 10) != 1)
			return result;
		if (!(RangeTo(ENT_LASTSTRUCK) < ATTACK_HITRANGE))
			return result;
		ApplyEffect(ENT_LASTSTRUCK, "effects/dot_poison", Random(3, 5), self, POISON_DAMAGE);
		return result;
	}

	// unnamed block (timer)
	void SlimeGreen_Timer()
	{
		CallEventDelayed(Random(3, 10), "SlimeGreen_Timer");
		if (NPCATK_TARGET != "unset")
			return;
		PlaySound(0, 10, SOUND_IDLE);
	}

	// unnamed block (timer)
	void SlimeGreen_Timer2()
	{
		CallEventDelayed(FREQ_SPIT, "SlimeGreen_Timer2");
		if (!IsAlive(SPIT_TARGET))
			return;
		Vector3 targOrg = OriginOf(SPIT_TARGET);
		string targTrace = LegacyFunction("get_traceline", MyOrigin(), targOrg, "worldonly");
		// dbg spit_loop TARG_TRACE vs TARG_ORG
		if (targTrace != Text(targOrg))
			return;

		PlaySound(0, 10, SOUND_ATTACK1);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison", RelativePosition(Vector3(0, 0, -8)), SPIT_TARGET, 300, SPIT_DAMAGE, 2, "none");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SlimeGreen_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SPIT_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "512", "1.0");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lesser Green Slime");
		SetHealth(200);
		SetWidth(32);
		SetHeight(32);
		SetModel("monsters/slime.mdl");
		// setsolid trigger
		SetModelBody(0, 0);
		SetRace("demon");
		SetBlood("green");
		SetRoam(true);
		NPC_GIVE_EXP = 80.0f;

		SetHearingSensitivity(10);

		SetDamageTaken("pierce", 0.25f);
		SetDamageTaken("slash", 0.75f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("poison", 0);

		NPC_RANGED = "0"; // don't reset move range if can't see nme
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		CBaseEntity@ slimeHeard = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(slimeHeard, ENT_ME) == "enemy")
			SPIT_TARGET = EntityId(slimeHeard);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_MOVERANGE))
			return;
		if (RandomInt(1, 5) != 1)
			return;
		if (IS_FLEEING)
			return;
		SPIT_TARGET = NPCATK_TARGET;
		OnNpcatkFlee(NPCATK_TARGET, "512", "2.0");
	}

	// bite1
	// called from model
	void OnBite1()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_HITCHANCE, "acid");
	}

	// spit_delay_reset
	void OnSpitDelayReset()
	{
		SPIT_DELAY = false;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime.mdl");
		CallEventDelayed(Float(Eval("$randf(3,10)")), "SlimeGreen_Timer");
		CallEventDelayed(FREQ_SPIT, "SlimeGreen_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeGreen_FirstThink();
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
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "spit_delay_reset") { OnSpitDelayReset(); return true; }
		if (name == "SlimeGreen_Timer") { SlimeGreen_Timer(); return true; }
		if (name == "SlimeGreen_Timer2") { SlimeGreen_Timer2(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
