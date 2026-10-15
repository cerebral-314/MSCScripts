#pragma context server

// Converted from monsters/skeleton_poison_random.script by msc_transpiler.
// Poison Bones by Thothie
// - Randomizer with 3 types
// - 1 Envenomed Bones - mostly reliant on poison bolt attacks
// - 2 Vampyric Poisoner - regens damage on sucseful strikes
// - 3 Poisoned Spore - eplodes at 100hp or if struck for more than 30hp
// - not implemented::
// - 4 Envenomed Blade - Sword applies poison effect
// - 5 Enraged Venom - Twin axes + crack (not quite ice enraged level though) [no roam when spawned direct]
// - 6 Poisoned Guardian - High damage resistance, low damage output, perodic poison cloud [no roam when spawned direct]

#include "runtime/ScriptEntity.as"
#include "converted/monsters/skeleton_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonPoisonRandom
{
	// Constants
	int SKEL_HP = 350;
	string ATTACK_HITCHANCE = "85%";
	string SKEL_RESPAWN_CHANCE = "0%";
	int SKEL_RESPAWN_LIVES = 0;
	float FART_FREQ = 20.0f;
	string GUARD_STRUCK1 = "body/armour1.wav";
	string GUARD_STRUCK2 = "body/armour2.wav";
	string GUARD_STRUCK3 = "body/armour3.wav";
	string SOUND_BOLTCHARGE = "bullchicken/bc_attack1.wav";
	float BOLT_DAMAGE = 20.0f;
	string SOUND_BOLT1 = "bullchicken/bc_attack2.wav";
	string SOUND_BOLT2 = "bullchicken/bc_attack3.wav";
	string BOLT_FREQUENCY = "5.0";

	// Variables (an unset .script variable reads as its own name)
	float ATTACK_DAMAGE_LOW = 0.0f;
	float ATTACK_DAMAGE_HIGH = 0.0f;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	float BOLT_FREQ = 0.0f;
	string APPLY_EFFECT = "APPLY_EFFECT";
	string POISON_TYPE = "POISON_TYPE";
	bool IS_BOLTER = false;
	float NPC_GIVE_EXP = 0.0f;
	bool IS_VAMPIRE = false;
	bool SET_GREEK = false;
	bool IS_BOMBER = false;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	bool POISON_BLADE = false;
	bool ENRAGED = false;
	bool FARTS = false;
	bool GUARDIAN = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool BOLT_DELAY = false;
	bool FLINCH_DELAYING = false;
	bool SPLODIE = false;
	bool POISON_ATTACK = false;
	bool FART_DELAY = false;
	bool I_R_SUMMONED = false;
	string MY_MASTER = "MY_MASTER";
	Vector3 SUMMON_OLD_LOC = Vector3();
	bool NO_SPAWN_STUCK_CHECK = false;
	float SUMMON_DELAY_STUCK_CHECK = 0.0f;
	string CYCLE_TIME = "CYCLE_TIME";

	// unnamed block (first think)
	void SkeletonPoisonRandom_FirstThink()
	{
		ATTACK_DAMAGE_LOW = 5.5f;
		ATTACK_DAMAGE_HIGH = 15.5f;

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 20;

		ANIM_FLINCH = "bigflinch";

		ANIM_ATTACK = "attack1";
	}

	// skeleton_spawn
	void SkeletonPoisonRandom_OnSkeletonSpawn()
	{
		SetRace("undead");
		SetRoam(true);
		// takedmg all .7
		SetDamageTaken("fire", 1.2f);
		SetDamageTaken("cold", 0.25f);
		SetHearingSensitivity(5);
		BOLT_FREQ = 3.0f;
		APPLY_EFFECT = "effects/dot_poison";

		ANIM_WALK = "walk";
		ANIM_RUN = "walk";

		if (POISON_TYPE == "POISON_TYPE") // developer - will be 1,6
			POISON_TYPE = RandomInt(1, 6);

		if (Float(POISON_TYPE) == 1.0f)
		{
			SetModel("monsters/skeleton.mdl");
			SetModelBody(0, 2);
			SetName("Envenomed Bones");
			IS_BOLTER = true;
			NPC_GIVE_EXP = 100.0f;
		}

		if (Float(POISON_TYPE) == 2.0f)
		{
			SetName("Vampyric Poisoner");
			SetModel("monsters/skeleton.mdl");
			SetModelBody(0, 2);
			IS_VAMPIRE = true;
			SetModelBody(1, 1);
			// setvard DROP_ITEM1 smallarms_bone_blade
			// setvard DROP_ITEM1_CHANCE 1%
			NPC_GIVE_EXP = 125.0f;
		}

		if (Float(POISON_TYPE) == 3.0f)
		{
			SetName("Poisoned Spore");
			SetModel("monsters/skeleton_enraged.mdl");
			SetModelBody(0, 2); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 0); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
			if (ToLowerCase(MapName()) == "thanatos")
				SET_GREEK = true;
			if (SET_GREEK)
				SetModelBody(0, 10);

			IS_BOMBER = true;
			ANIM_RUN = "run";
			ANIM_WALK = "run";
			SetMoveAnim(ANIM_RUN);
			SetMoveSpeed(2);
			SetAnimMoveSpeed(2);
			// setanim.framerate 1.5
			BASE_FRAMERATE = "1.5";
			BASE_MOVESPEED = 1.5f;
			NPC_GIVE_EXP = 100.0f;
		}

		if (Float(POISON_TYPE) == 4.0f)
		{
			SetName("Envenomed Blade");
			SetModel("monsters/skeleton.mdl");
			SetModelBody(0, 2);
			SetModelBody(1, 4);
			POISON_BLADE = true;
			NPC_GIVE_EXP = 120.0f;
		}

		if (Float(POISON_TYPE) == 5.0f)
		{
			SetName("Enraged Poisoner");
			SetModel("monsters/skeleton_enraged.mdl");
			SetModelBody(0, 2); // 0=standard 1=ash 2=green 3=bloody 4=decayed 5=ice 6=gold 7=stone 8=crystal 9=weirdgel
			SetModelBody(1, 3); // 0=Unarmed 1=darkmace 2=sword 3=hammahs 4=bigsword+shield 5=iceclubs 6=fireclubs 7=highsword 8=wand
			ANIM_RUN = "run";
			ANIM_WALK = "run";
			SetMoveAnim(ANIM_RUN);
			SetMoveSpeed(1.5f);
			SetAnimMoveSpeed(1.5f);

			// setanim.framerate 3.0
			// setvard BASE_FRAMERATE 3.0
			ATTACK_DAMAGE_LOW = 2.5f;
			ATTACK_DAMAGE_HIGH = 10.0f;
			POISON_BLADE = true;
			ENRAGED = true;
			NPC_GIVE_EXP = 150.0f;
		}

		if (Float(POISON_TYPE) == 6.0f)
		{
			SetName("Poisonous Guardian");
			SetModel("monsters/skeleton.mdl");
			// movespeed 0.75
			SetAnimMoveSpeed(0.5f);
			SetAnimFrameRate(0.5f);
			SetModelBody(0, 2);
			SetModelBody(1, 3);
			SetDamageTaken("all", 0.3f);
			SetStat("parry", 40);
			FARTS = true;
			GUARDIAN = true;
			ATTACK_DAMAGE_LOW = 0.5f;
			ATTACK_DAMAGE_HIGH = 5.5f;
			NO_STUCK_CHECKS = "1";
			NPC_GIVE_EXP = 200.0f;
		}
	}

	// npcatk_targetvalidate
	// Bolter & Enraged
	void SkeletonPoisonRandom_OnNpcatkTargetvalidate(string target = "")
	{
		if (ENRAGED)
		{
			// setanim.framerate 1.5
			BASE_FRAMERATE = "1.5";
		}
		if (GUARDIAN)
		{
			// setanim.framerate 0.5
			BASE_FRAMERATE = "0.5";
		}
		if (IS_VAMPIRE)
		{
			// setanim.framerate 0.75
			BASE_FRAMERATE = "0.75";
		}
		if (FARTS && !FART_DELAY)
			OnDoFart();

		if (!IS_BOLTER)
			return;
		if (BOLT_DELAY)
			return;
		if (!CanSee("enemy"))
			return;
		if (!(RangeTo(ENT_LASTSEEN) > 192.0f))
			return;
		OnTossBolt();
	}

	// toss_bolt
	void SkeletonPoisonRandom_OnTossBolt()
	{
		BOLT_DELAY = true;
		CallEventDelayed(BOLT_FREQ, "reset_bolt");
		PlayAnim("critical", "attack2");
		PlaySound(0, 10, SOUND_BOLTCHARGE);
	}

	// reset_bolt
	void SkeletonPoisonRandom_OnResetBolt()
	{
		BOLT_DELAY = false;
	}

	// attack_2
	// called from model anim attack2
	void SkeletonPoisonRandom_OnAttack22()
	{
		if (!IS_BOLTER)
			return;
		PlayRandomSound(0, 10, SOUND_BOLT1, SOUND_BOLT2);
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 15, 8)), "none", 300, BOLT_DAMAGE, 0.5f, "none");
	}

	// npc_struck
	// Bomber
	void SkeletonPoisonRandom_OnNpcStruck(float damage = 0.0f)
	{
		if (GUARDIAN)
		{
			PlayRandomSound(0, 8, GUARD_STRUCK1, GUARD_STRUCK2, GUARD_STRUCK3);
			if (damage > 30.0f)
			{
				// handling flinch this side due to odd behavior
				if (!FLINCH_DELAYING)
				{
					PlayAnim("critical", ANIM_FLINCH);
					FLINCH_DELAYING = true;
					CallEventDelayed(5.0f, "reset_flinch");
				}
			}
		}

		if (!IS_BOMBER)
			return;
		if (SPLODIE)
			return;

		if (Float(Eval("game.monster.health")) < 100.0f)
		{
			PlaySound(0, 10, "debris/bustflesh1.wav");
			SPLODIE = true;
			PlayAnim("critical", "ANIM_SPLODE");
			CallEventDelayed(0.5f, "go_splodie");
		}

		if (SPLODIE)
			return;

		if (damage > 30.0f)
		{
			PlaySound(0, 10, "debris/bustflesh1.wav");
			SPLODIE = true;
			PlayAnim("critical", "ANIM_SPLODE");
			CallEventDelayed(0.5f, "go_splodie");
		}
	}

	// reset_flinch
	void SkeletonPoisonRandom_OnResetFlinch()
	{
		FLINCH_DELAYING = false;
	}

	// go_splodie
	void SkeletonPoisonRandom_OnGoSplodie()
	{
		// playsound 0 10 ambience/steamburst1.wav
		SetBoundingBox("none");
		SetSolid("none");
		// tempent gibs <modelname/spritename> <position> <size> <velocity> <randomness> <amount> <duration>
		Effect("tempent", "gibs", "cactusgibs.mdl", RelativePosition(Vector3(0, 0, 0)), 1.0f, 50, 50, 15, 2.0f);

		Vector3 cloudPos = OriginOf(ENT_ME);
		float grndCloud = GroundHeight(cloudPos) + 24.0f;
		cloudPos.z = grndCloud;
		CreateNpc("monsters/summon/npc_poison_cloud2", cloudPos, self, RandomInt(10, 15), 30.0f, 1);
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));
		SetRace("hated");
		CallEventDelayed(20.0f, "me_suicide");
	}

	// me_suicide
	void SkeletonPoisonRandom_OnMeSuicide()
	{
		DoDamage(ENT_ME, "direct", 1000, "100%", ENT_ME);
	}

	// game_damaged_other
	// vampire
	// P1 = target P2= damage
	string SkeletonPoisonRandom_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// //dbg temp Damaged other got PARAM1 PARAM2 PARAM3 PARAM4 PARAM5
		if (!IS_VAMPIRE)
			return result;
		// dbg temp MyHP game.monster.hp
		float maxCheck = MyHealth() + damage;
		if (!(maxCheck < MyMaxHealth()))
			return result;
		GiveHealth(damage);
		Effect("glow", ENT_ME, Vector3(0, 255, 0), 80, 0.5f, 0.5f);
		PlaySound(0, 10, "player/heartbeat_noloop.wav");
		return result;
	}

	// game_damaged_other
	// Envenomed Blade
	string SkeletonPoisonRandom_OnGameDamagedOther_2(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!POISON_ATTACK)
			return result;
		ApplyEffect(target, APPLY_EFFECT, RandomInt(10, 15), self, Random(1, 4));
		POISON_ATTACK = false;
		return result;
	}

	// attack_1
	void SkeletonPoisonRandom_OnAttack12()
	{
		if (POISON_BLADE)
		{
			APPLY_EFFECT = "effects/dot_poison";
			if (RandomInt(1, 3) == 3)
				POISON_ATTACK = true;
		}

		if (!ENRAGED && RandomInt(1, 3) == 1)
			ANIM_ATTACK = "attack2";

		OnAttackSnd();

		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, Random(ATTACK_DAMAGE_LOW, ATTACK_DAMAGE_HIGH), ATTACK_HITCHANCE);
	}

	// attack_2
	void SkeletonPoisonRandom_OnAttack22_2()
	{
		if (POISON_BLADE)
		{
			APPLY_EFFECT = "effects/dot_poison";
			POISON_ATTACK = true;
		}

		DoDamage(ENT_LASTSEEN, ATTACK_RANGE, ATTACK_DAMAGE_HIGH, ATTACK_HITCHANCE);
		ANIM_ATTACK = "attack1";
	}

	// do_fart
	// guardian
	void SkeletonPoisonRandom_OnDoFart()
	{
		FART_DELAY = true;
		CallEventDelayed(FART_FREQ, "reset_fart");
		if (!(RangeTo(ENT_LASTSEEN) < 256.0f))
			return;
		PlayAnim("critical", "attack2");
		PlaySound(0, 10, "ambience/steamburst1.wav");
		Vector3 spawnOrigin = OriginOf(ENT_LASTSEEN) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 32));
		CreateNpc("monsters/summon/npc_poison_cloud2", spawnOrigin, self, RandomInt(10, 15), 5.0f, 1);
	}

	// reset_fart
	void SkeletonPoisonRandom_OnResetFart()
	{
		FART_DELAY = false;
	}

	// game_death
	// summon handling
	void SkeletonPoisonRandom_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// setanim.framerate 1.0
		if (!I_R_SUMMONED)
			return;
		CallExternal(MY_MASTER, "skeleton_died");
	}

	// game_dynamically_created
	void SkeletonPoisonRandom_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// //dbg temp MyMasterIs $get(ent_creationowner,name)
		I_R_SUMMONED = true;
		MY_MASTER = EntityId(EntityOf(ENT_CREATIONOWNER));
		SUMMON_OLD_LOC = MyOrigin();
		NO_SPAWN_STUCK_CHECK = true;
		SUMMON_DELAY_STUCK_CHECK = 0.0f;
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		CallEventDelayed(3.0f, "summon_stuck_checks");
	}

	// summon_stuck_checks
	void SkeletonPoisonRandom_OnSummonStuckChecks()
	{
		CallEventDelayed(2.0f, "summon_stuck_checks");

		SUMMON_DELAY_STUCK_CHECK -= 1.0f;
		if (SUMMON_DELAY_STUCK_CHECK < 0.0f)
			SUMMON_DELAY_STUCK_CHECK = 0.0f;

		if (SUMMON_DELAY_STUCK_CHECK != 0.0f)
			return;
		if (Distance(MyOrigin(), SUMMON_OLD_LOC) == 0.0f)
			CallExternal(MY_MASTER, "skeleton_stuck");
		SUMMON_OLD_LOC = MyOrigin();
	}

	// npc_selectattack
	void SkeletonPoisonRandom_OnNpcSelectattack()
	{
		if (!I_R_SUMMONED)
			return;
		SUMMON_DELAY_STUCK_CHECK = 5.0f;
	}

	// game_damaged_other
	string SkeletonPoisonRandom_OnGameDamagedOther_3(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!I_R_SUMMONED)
			return result;
		SUMMON_DELAY_STUCK_CHECK = 5.0f;
		return result;
	}

	// check_attack
	void SkeletonPoisonRandom_OnCheckAttack()
	{
		bool attack = false;

		if (IS_FLEEING)
			return;

		if (!IsAlive(HUNT_LASTTARGET))
			return;

		if (RangeTo(HUNT_LASTTARGET) <= ATTACK_RANGE)
			attack = true;

		if (!attack)
			return;
		OnNpcatkAttackenemy();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SkeletonPoisonRandom_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SkeletonPoisonRandom_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SkeletonPoisonRandom_OnGameDamagedOther_2(target, damage, damageType, damageEvent));
		result = AppendResult(result, SkeletonPoisonRandom_OnGameDamagedOther_3(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		SkeletonPoisonRandom_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttack_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack
		SkeletonPoisonRandom_OnNpcatkTargetvalidate(target);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		SkeletonPoisonRandom_OnNpcSelectattack();
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SkeletonBase_OnNpcStruck(damage); // monsters/skeleton_base
		SkeletonPoisonRandom_OnNpcStruck(damage);
	}

	void OnSkeletonSpawn() { SkeletonPoisonRandom_OnSkeletonSpawn(); } // skeleton_spawn
	void OnTossBolt() { SkeletonPoisonRandom_OnTossBolt(); } // toss_bolt
	void OnResetBolt() { SkeletonPoisonRandom_OnResetBolt(); } // reset_bolt

	// attack_2
	void OnAttack22()
	{
		SkeletonPoisonRandom_OnAttack22();
		SkeletonPoisonRandom_OnAttack22_2();
	}

	void OnResetFlinch() { SkeletonPoisonRandom_OnResetFlinch(); } // reset_flinch
	void OnGoSplodie() { SkeletonPoisonRandom_OnGoSplodie(); } // go_splodie
	void OnMeSuicide() { SkeletonPoisonRandom_OnMeSuicide(); } // me_suicide
	void OnAttack12() { SkeletonPoisonRandom_OnAttack12(); } // attack_1
	void OnDoFart() { SkeletonPoisonRandom_OnDoFart(); } // do_fart
	void OnResetFart() { SkeletonPoisonRandom_OnResetFart(); } // reset_fart
	void OnSummonStuckChecks() { SkeletonPoisonRandom_OnSummonStuckChecks(); } // summon_stuck_checks
	void OnCheckAttack() { SkeletonPoisonRandom_OnCheckAttack(); } // check_attack
	void OnBoltFreq() {} // BOLT_FREQ
	void OnFartFreq() {} // FART_FREQ
	void OnAttackSnd() {} // attack_snd

	// This file's events and timers by their .script names
	bool SkeletonPoisonRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "do_fart") { OnDoFart(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "go_splodie") { OnGoSplodie(); return true; }
		if (name == "me_suicide") { OnMeSuicide(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_bolt") { OnResetBolt(); return true; }
		if (name == "reset_fart") { OnResetFart(); return true; }
		if (name == "reset_flinch") { OnResetFlinch(); return true; }
		if (name == "skeleton_spawn") { OnSkeletonSpawn(); return true; }
		if (name == "summon_stuck_checks") { OnSummonStuckChecks(); return true; }
		if (name == "toss_bolt") { OnTossBolt(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_poison_random"]
shared class SkeletonPoisonRandomScript : SkeletonBaseScript, SkeletonPoisonRandom
{
	// Variables declared by included files, with the value they start with in this script
	SkeletonPoisonRandomScript()
	{
		SKEL_HP = 350;
		ATTACK_HITCHANCE = "85%";
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		Precache("cactusgibs.mdl");
		Precache("monsters/skeleton.mdl");
		Precache("monsters/skeleton_enraged.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonPoisonRandom_FirstThink();
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
		return SkeletonPoisonRandom_DispatchEvent(name, params)
			|| SkeletonBaseScript::DispatchEvent(name, params);
	}
}
