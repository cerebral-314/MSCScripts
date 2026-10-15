#pragma context server

// Converted from monsters/elemental_fire2.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/elemental_fire2"]
class ElementalFire2 : BaseMonsterNewScript, BasePropelled
{
	// Constants
	string ANIM_PROJECTILE = "fireball";
	int MOVESPEED_SLOW = 100;
	int MOVESPEED_FAST = 200;
	int DMG_STRIKE = 0;
	int DOT_STRIKE = 0;
	string ACCURACY_STRIKE = "80%";
	int DMG_AMB_BURN = 0;
	int DMG_FIRE_BALL = 100;
	int DMG_FIRE_BOLT = 20;
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	string SOUND_SWIPE = "weapons/debris1.wav";
	string SOUND_SWIPEHIT = "ambience/steamburst1.wav";
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain4.wav";
	string SOUND_GLOAT = "x/x_laugh1.wav";
	string SOUND_HOVER = "fans/fan4on.wav";
	float HURT_THRESHOLD = 0.5f;
	float PLAYTIME_HOVER = 3.0f;

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float FREQ_SPECIAL = 0.0f;
	float MY_HURT_STAGE = 0.0f;
	float CUR_SPELL = 0.0f;
	Vector3 NPC_MOVE_DEST = Vector3();
	float NEXT_GLOAT = 0.0f;
	float HOVER_LOOP_DELAY = 0.0f;
	bool STRIKE_ATTACK = false;
	bool CYCLES_ON = false;
	float BREATH_COUNT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ElementalFire2()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ElementalFire2_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		// base anims
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die1";
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10";
		FLINCH_ANIM = "flinch";
		ANIM_ATTACK = "attack1";

		// base stats
		IS_UNHOLY = true;
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		MOVE_RANGE = "65";
		NPC_HACKED_MOVE_SPEED = 100.0f;
		FREQ_SPECIAL = 5.0f;
		IMMUNE_VAMPIRE = true;
	}

	// game_dodamage
	string ElementalFire2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (hit && STRIKE_ATTACK)
		{
			STRIKE_ATTACK = false;
			ApplyEffect(target, "effects/dot_fire", 3, self, DOT_STRIKE);
		}
		return result;
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string ElementalFire2_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(RangeTo(attacker) < ATTACK_RANGE))
			return result;
		ApplyEffect(attacker, "effects/dot_fire", 2, self, "DOT_AMB_BURN");
		return result;
	}

	// unnamed block (timer)
	void ElementalFire2_Timer()
	{
		CallEventDelayed(15.1f, "ElementalFire2_Timer");
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 0, 0), 196, 15.0f);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/fire_ball_guided");
		PrecacheFile("monsters/summon/fire_wave");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		NO_SPAWN_STUCK_CHECK = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Greater Fire Elemental");
		SetHealth(2500);
		SetWidth(48);
		SetHeight(80);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0);

		SetRoam(false);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModel("monsters/elementals_greater.mdl");
		SetModelBody(0, 0);
		NPC_GIVE_EXP = 500.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		SetBlood("none");

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * HURT_THRESHOLD;

		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 0, 0), 196, 15.0f);

		CUR_SPELL = 0.0f;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		NPC_MOVE_DEST = Vec("unset");

		if (!(GameTime() > NEXT_GLOAT))
			return;
		NEXT_GLOAT = GameTime() + 0.0f;
		PlayAnim("critical", "idle2");
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElementalFire2_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		CallEventDelayed(FREQ_SPECIAL, "pick_spell");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, ElementalFire2_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		BasePropelled_OnGameMovingtoDest(angles); // monsters/base_propelled

		if (!(GameTime() > HOVER_LOOP_DELAY))
			return;
		PlaySound(Int(GetVar("CHAN_BODY")), 8, SOUND_HOVER);
		HOVER_LOOP_DELAY = GameTime() + 3.0f;
	}

	// npc_struck
	// called from base_npc_attack - param1 damage taken as of 22/Aug/2006 14:50
	void OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth <= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);

		if (damage > 40.0f)
		{
			float lrFling = 200.0f;
			if (RandomInt(1, 2) == 1)
				lrFling = -lrFling;
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(lrFling, 0, 0))); // float around when struck hard
		}
	}

	// attack1_strike
	// called from anim attack1 @ frame12
	void OnAttack1Strike()
	{
		STRIKE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_STRIKE), ACCURACY_STRIKE);
	}

	// do_fire_ball
	void OnDoFireBall()
	{
		if (!CanSee(NPCATK_TARGET))
			return;
		AS_ATTACKING = GameTime();
		PlayAnim("critical", ANIM_PROJECTILE);
		CallEventDelayed(0.5f, "do_fire_ball1");
		CallEventDelayed(0.7f, "do_fire_ball2");
	}

	// do_fire_ball1
	void OnDoFireBall1()
	{
		CreateNpc("monsters/summon/fire_ball_guided", RelativePosition(Vector3(-32, 0, 64)), self, DMG_FIRE_BALL, 10.0f, 200);
	}

	// do_fire_ball2
	void OnDoFireBall2()
	{
		CreateNpc("monsters/summon/fire_ball_guided", RelativePosition(Vector3(32, 0, 64)), self, DMG_FIRE_BALL, 10.0f, 200);
	}

	// do_fire_wave
	void OnDoFireWave(Vector3 startPosition = Vector3())
	{
		if (!CYCLED_UP)
			return;
		SetMoveDest(NPCATK_TARGET, 9999);
		OnNpcatkSuspendAi("1.0");
		PlayAnim("critical", "block");
		CallEventDelayed(0.5f, "do_fire_wave2");
	}

	// do_fire_wave2
	void OnDoFireWave2()
	{
		CreateNpc("monsters/summon/fire_wave", RelativePosition(Vector3(0, 0, 0)), self, 100, 100, 5);
	}

	// idle_sounds
	void OnIdleSounds()
	{
		float nextSound = Random(5, 15);

		CallEventDelayed(nextSound, "idle_sounds");

		if (NPCATK_TARGET != "unset")
			return;

		// local RAND_ANIM $rand(1,3)
		// if ( RAND_ANIM == 1 ) playanim once ANIM_BUGIDLE_A	//was having some odd bug with idle anims, hence odd names
		// if ( RAND_ANIM == 2 ) playanim once ANIM_BUGIDLE_B
		// if ( RAND_ANIM == 3 ) playanim once ANIM_BUGIDLE_C
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// do_fire_breath
	// not what I originally had in mind
	void OnDoFireBreath()
	{
		if (!IsAlive(NPCATK_TARGET))
			return;

		OnNpcatkSuspendAi();
		SetMoveAnim("charging");
		SetIdleAnim("charging");
		PlayAnim("critical", "charging");
		BREATH_COUNT = 0.0f;
		OnDoFireBreathLoop();
	}

	// do_fire_breath_loop
	void OnDoFireBreathLoop()
	{
		BREATH_COUNT += 1.0f;
		if (BREATH_COUNT < 30.0f)
		{
			CallEventDelayed(0.1f, "do_fire_breath_loop");
			SetMoveDest(NPCATK_TARGET, 9999);

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_fire_bolt", RelativePosition(Vector3(0, 0, 24)), "none", 300, DMG_FIRE_BOLT, 30, "none");
		}
		else
		{
			OnNpcatkResumeAi();
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
		}
	}

	// pick_spell
	void OnPickSpell()
	{
		CUR_SPELL += 1.0f;
		if (CUR_SPELL > 4.0f)
			CUR_SPELL = 1.0f;

		if (CUR_SPELL == 1.0f)
		{
			OnDoFireBall();
			FREQ_SPECIAL = 10.0f;
		}
		if (CUR_SPELL == 2.0f)
		{
			OnDoFireWave();
			FREQ_SPECIAL = 10.0f;
		}
		if (CUR_SPELL == 3.0f)
		{
			if (RangeTo(NPCATK_TARGET) < 768.0f)
			{
				OnDoFireBreath();
				FREQ_SPECIAL = 5.0f;
			}
			else
			{
				OnDoFireBall();
				FREQ_SPECIAL = 10.0f;
			}
		}
		CallEventDelayed(FREQ_SPECIAL, "pick_spell");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	void OnFreqSpecial() {} // FREQ_SPECIAL
	void OnNextSound() {} // NEXT_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_greater.mdl");
		CallEventDelayed(15.1f, "ElementalFire2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalFire2_FirstThink();
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
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_fire_ball") { OnDoFireBall(); return true; }
		if (name == "do_fire_ball1") { OnDoFireBall1(); return true; }
		if (name == "do_fire_ball2") { OnDoFireBall2(); return true; }
		if (name == "do_fire_breath") { OnDoFireBreath(); return true; }
		if (name == "do_fire_breath_loop") { OnDoFireBreathLoop(); return true; }
		if (name == "do_fire_wave") { OnDoFireWave(Vec(Param(params, 0))); return true; }
		if (name == "do_fire_wave2") { OnDoFireWave2(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "pick_spell") { OnPickSpell(); return true; }
		if (name == "ElementalFire2_Timer") { ElementalFire2_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
