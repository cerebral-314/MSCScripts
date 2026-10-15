#pragma context server

// Converted from monsters/slime_green_large.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/slime_green_large"]
class SlimeGreenLarge : BaseMonsterNewScript
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
	int SPIT_RANGE = 1024;
	float SPIT_ROF = 2.0f;
	int SPIT_DAMAGE = 0;
	float CLOUD_DELAY = 15.0f;
	int CLOUD_DAMAGE = 0;
	float CLOUD_DURATION = 10.0f;
	float FREQ_SPIT = 1.0f;
	float FREQ_SPIT_SCAN = 2.0f;
	float FREQ_CLOUD = 30.0f;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NEXT_SPIT_SCAN = 0.0f;
	string SPIT_TARGETS = "SPIT_TARGETS";
	int N_SPIT_TARGETS = 0;
	float NEXT_SPIT = 0.0f;
	string SPIT_TARGET = "SPIT_TARGET";
	float NEXT_CLOUD = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SlimeGreenLarge()
	{
		SOUND_DEATH = "monsters/sludge/bio.wav";
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void SlimeGreenLarge_FirstThink()
	{
		ANIM_IDLE = "walk";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attack";
		ANIM_DEATH = "die";
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 120.0f;
	}

	// game_damaged_other
	string SlimeGreenLarge_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2);
		if (RandomInt(1, 10) != 1)
			return result;
		if (!(RangeTo(ENT_LASTSTRUCK) < ATTACK_HITRANGE))
			return result;
		ApplyEffect(ENT_LASTSTRUCK, "effects/dot_poison", Random(3, 5), self, POISON_DAMAGE);
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SlimeGreenLarge_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);

		if (!(GameTime() > NEXT_CLOUD))
			return;
		NEXT_CLOUD = GameTime() + FREQ_CLOUD;
		CreateNpc("monsters/summon/npc_poison_cloud2", OriginOf(ENT_ME), self, CLOUD_DAMAGE, CLOUD_DURATION, 1);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Large Green Slime");
		SetHealth(800);
		SetWidth(70);
		SetHeight(64);
		SetModel("monsters/slime_large.mdl");
		// setmodelbody 0 ???
		SetRace("demon");
		SetRoam(true);
		NPC_GIVE_EXP = 450.0f;

		SetDamageTaken("pierce", 0.25f);
		SetDamageTaken("slash", 0.75f);
		SetDamageTaken("blunt", 1);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("poison", 0);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (I_R_FROZEN)
			return;
		if (NPCATK_TARGET == "none")
			return;
		if (!(N_SPIT_TARGETS > 0))
			return;
		if (!(GameTime() > NEXT_SPIT))
			return;
		NEXT_SPIT = GameTime() + FREQ_SPIT;
		if (N_SPIT_TARGETS > 1)
		{
			// multiple targets - spit at random target
			float nMinus = N_SPIT_TARGETS - 1.0f;
			int rndTarget = RandomInt(0, int(nMinus));
			SPIT_TARGET = GetToken(SPIT_TARGETS, rndTarget);
		}
		else
		{
			// otherwise just the guy I'm pissed at
			SPIT_TARGET = NPCATK_TARGET;
		}

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 0, -16)), SPIT_TARGET, 300, SPIT_DAMAGE, 0.1f, "none");
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(GameTime() > NEXT_SPIT_SCAN))
			return;
		NEXT_SPIT_SCAN = GameTime() + FREQ_SPIT_SCAN;

		SPIT_TARGETS = FindInSphere("enemy", 512);
		// calleventloop $get_token_amt(SPIT_TARGETS) filter_spit_targets
		N_SPIT_TARGETS = GetTokenCount(SPIT_TARGETS);
	}

	// bite1
	// called from model
	void OnBite1()
	{
		// damage all in area
		OnNpcatkDodamage(Text(RelativePosition(Vector3(0, 0, 0))), Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, "0.0", "reflective", "acid");
	}

	// $randf(3,10)
	void OnRandf310()
	{
		if (NPCATK_TARGET != "unset")
			return;
		PlaySound(0, 10, SOUND_IDLE);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/slime_large.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SlimeGreenLarge_FirstThink();
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
		if (name == "$randf(3,10)") { OnRandf310(); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
