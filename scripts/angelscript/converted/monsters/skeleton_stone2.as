#pragma context server

// Converted from monsters/skeleton_stone2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

[script "monsters/skeleton_stone2"]
class SkeletonStone2 : SkeletonBaseScript
{
	// Constants
	float ATTACK_DAMAGE_LOW = 16.0f;
	float ATTACK_DAMAGE_HIGH = 26.0f;
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	string SOUND_STUN = "zombie/claw_strike2.wav";
	string SOUND_SUMMON = "monsters/skeleton/calrain3.wav";
	string ROCK_DAMAGE = "ROCK_DAMAGE";
	int STUN_ATK_CHANCE = 10;
	bool STONE_SKELETON = true;
	float ROCK_FREQ = 15.0f;

	// Variables (an unset .script variable reads as its own name)
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	bool WAS_SLEEPING = false;
	bool STUN_ATTACK = false;
	bool ROCK_DELAY = false;
	bool ROCK_ON = false;
	string ROCK_TARGET = "ROCK_TARGET";
	string MY_ROCK = "MY_ROCK";
	Vector3 ROCK_POS = Vector3();
	float ROCK_X = 0.0f;
	float ROCK_Y = 0.0f;
	float ROCK_Z = 0.0f;
	float ROCK_RAISE_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SkeletonStone2()
	{
		ANIM_RUN = "run";
		SKEL_HP = 1000;
		ATTACK_HITCHANCE = "85%";
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void SkeletonStone2_FirstThink()
	{
		ANIM_RUN = "run";
		NPC_GIVE_EXP = 150.0f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 25;
		DROP_GOLD_MAX = 55;
	}

	// game_dodamage
	// 1:AttackHit(1/0)  2:EntityHit  3:StartOrigin  4:EndOrigin
	string SkeletonStone2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			return result;
		if (!STUN_ATTACK)
			return result;
		PlaySound(0, 10, SOUND_STUN);
		ApplyEffect(target, "effects/debuff_stun", Random(5, 10), self);
		STUN_ATTACK = false;
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
		if (Exists(MY_ROCK))
			CallExternal(MY_ROCK, "toss_rock", @EntityOf(ENT_LASTSTRUCK), ROCK_DAMAGE);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttack_OnCycleUp(reason); // monsters/base_npc_attack
		ROCK_ON = true;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonStone2_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (IS_FLEEING)
			return;

		if (ROCK_ON && !ROCK_DELAY)
		{
			ROCK_DELAY = true;
			CallEventDelayed(ROCK_FREQ, "rock_delay_reset");
			PlayAnim("break");
			CallEventDelayed(0.1f, "summon_rock");
		}
	}

	// attack_1
	void OnAttack12()
	{
		SkeletonBase_OnAttack12(); // monsters/skeleton_base

		STUN_ATTACK = false;

		if (!(RandomInt(1, 100) < STUN_ATK_CHANCE))
			return;
		ANIM_ATTACK = "attack2";
	}

	// skeleton_spawn
	void OnSkeletonSpawn()
	{
		SetModel("monsters/skeleton_boss1.mdl");
		SetModelBody(0, 7); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
		SetModelBody(1, 3); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
		SetWidth(32);
		SetHeight(80);
		if (!SLEEPER)
			OnAnimateStone();
		if (SLEEPER)
		{
			SetInvincible(true);
			WAS_SLEEPING = true;
			OnNpcatkSuspendAi();
			SetIdleAnim(ANIM_IDLE);
			SetMoveAnim(ANIM_IDLE);
			SetAnimFrameRate(0);
		}

		if (ToLowerCase(MapName()) == "thanatos")
			SET_GREEK = true;
		if (SET_GREEK)
			SetModelBody(0, 10);
	}

	// animate_stone
	void OnAnimateStone()
	{
		SetName("Lesser Stone Mason");
		SetRoam(true);

		SetBlood("none");

		SetDamageTaken("all", 0.6f);

		SetHearingSensitivity(3);

		if (WAS_SLEEPING)
		{
			SetMoveAnim(ANIM_WALK);
			SetAnimFrameRate(1);
			OnNpcatkResumeAi();
		}
	}

	// rock_delay_reset
	void OnRockDelayReset()
	{
		ROCK_DELAY = false;
	}

	// attack_2
	void OnAttack22()
	{
		STUN_ATTACK = true;
		OnAttackSnd();
		DoDamage(ENTITY_ENEMY, ATTACK_HITRANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
		ANIM_ATTACK = "attack1";
	}

	// summon_rock
	void OnSummonRock(Vector3 location = Vector3())
	{
		AS_ATTACKING = GameTime() + 20.0f; // tells anti-stuck he's attacking
		PlaySound(0, 10, SOUND_SUMMON);
		ROCK_TARGET = HUNT_LASTTARGET;
		OnNpcatkSuspendAi();
		PlayAnim("critical", "castspell");
		CreateNpc("monsters/summon/rock", RelativePosition(Vector3(0, 30, -64)), self);
		MY_ROCK = ENT_LASTCREATED;
		ROCK_POS = OriginOf(MY_ROCK);
		ROCK_X = ROCK_POS.x;
		ROCK_Y = ROCK_POS.y;
		ROCK_Z = ROCK_POS.z;
		ROCK_RAISE_COUNT = 0.0f;
		SetMoveDest(ROCK_TARGET, 999);
		CallEventDelayed(0.1f, "raise_rock");
	}

	// raise_rock
	void OnRaiseRock()
	{
		ROCK_RAISE_COUNT += 1.0f;
		ROCK_Z += 4.0f;
		SetOrigin(MY_ROCK, Vector3(ROCK_X, ROCK_Y, ROCK_Z));
		if (ROCK_RAISE_COUNT >= 15.0f)
			OnThrowRock();
		if (!(ROCK_RAISE_COUNT < 15.0f))
			return;
		CallEventDelayed(0.1f, "raise_rock");
	}

	// throw_rock
	void OnThrowRock()
	{
		DeleteEntity(MY_ROCK);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_troll_rock", RelativePosition(Vector3(0, 30, 8)), "none", 800, ROCK_DAMAGE, 0.75f, "none");
		CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0);
		CallEventDelayed(0.1f, "npcatk_resume_ai");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnRockFreq() {} // ROCK_FREQ
	void OnAttackSnd() {} // attack_snd

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonStone2_FirstThink();
		SkeletonBase_FirstThink();
		SkeletonBase_FirstThink2();
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
		if (name == "animate_stone") { OnAnimateStone(); return true; }
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "raise_rock") { OnRaiseRock(); return true; }
		if (name == "rock_delay_reset") { OnRockDelayReset(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "summon_rock") { OnSummonRock(Vec(Param(params, 0))); return true; }
		if (name == "throw_rock") { OnThrowRock(); return true; }
		return SkeletonBaseScript::DispatchEvent(name, params);
	}
}
