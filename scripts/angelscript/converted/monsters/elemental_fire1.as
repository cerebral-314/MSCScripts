#pragma context server

// Converted from monsters/elemental_fire1.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/elemental_fire1"]
class ElementalFire1 : BaseMonsterNewScript, BasePropelled
{
	// Constants
	string ANIM_TOCHARGE = "tocharge";
	string ANIM_CHARGEIDLE = "charging";
	string ANIM_FROMCHARGE = "fromcharge";
	string ANIM_FIRE_BALL = "fireball";
	string ANIM_SWIPE = "attack1";
	string ANIM_ALERT = "yes";
	string ANIM_GLOAT = "no";
	string ANIM_SEARCH = "dunno";
	int MOVE_FAST = 200;
	int MOVE_NORMAL = 100;
	int SWIPE_MOVERANGE = 65;
	string RAND_IDLE_ANIMS = "idle1;idle2;dunno";
	int LIGHT_RAD = 196;
	int CIRCLE_RANGE = 128;
	float FREQ_CIRCLE = 15.0f;
	float CIRCLE_DURATION = 8.0f;
	string PROJ_SCRIPT = "proj_fire_ball";
	int FIRE_BALL_RANGE = 2000;
	int FULL_FIRE_BALL_AMMO = 3;
	int AIM_RATIO = 50;
	int ATTACK_CONE_OF_FIRE = 2;
	int ATTACK_SPEED = 500;
	float DOT_FIRE = 0.0f;
	int DMG_SEAL = 200;
	int DMG_FIRE_BALL = 0;
	string DMG_SWIPE = "DMG_SWIPE";
	float FREQ_FIRE_BALL = 0.5f;
	string SOUND_ALERT = "agrunt/ag_alert5.wav";
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	string SOUND_SWIPE = "weapons/debris1.wav";
	string SOUND_SWIPEHIT = "ambience/steamburst1.wav";
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain4.wav";
	string SOUND_GLOAT = "x/x_laugh1.wav";
	string SOUND_FIRECHARGE = "magic/fireball_powerup.wav";
	string SOUND_FIRESHOOT = "magic/fireball_strike.wav";
	string SOUND_CIRCLE_READY = "debris/beamstart1.wav";
	string SOUND_HOVER = "fans/fan4on.wav";

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float FIRE_BALL_AMMO = 0.0f;
	bool IS_UNHOLY = false;
	float MY_HURT_STAGE = 0.0f;
	float NEXT_CIRCLE = 0.0f;
	bool FIREBALL_PREPPED = false;
	float NEXT_FIRE_BALL = 0.0f;
	bool SWIPE_ATTACK = false;
	string MY_OWNER = "MY_OWNER";
	bool AM_SUMMONED = false;
	bool COF_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ElementalFire1()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ElementalFire1_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die1";
	}

	// unnamed block (first think)
	void ElementalFire1_FirstThink2()
	{
		// used by base
		NPC_GIVE_EXP = 200.0f;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10";
		FLINCH_ANIM = "flinch";
		FLINCH_DELAY = "1";
		FLINCH_DMG_REQ = 30.0f;

		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 65.0f;
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;

		ATTACK_HITCHANCE = "80%";
	}

	// game_dodamage
	// ========== DOT
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ElementalFire1_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit && SWIPE_ATTACK)
			ApplyEffect(target, "effects/dot_fire", 5, self, DOT_FIRE);
		SWIPE_ATTACK = false;
		return result;
	}

	// unnamed block (timer)
	// ========== Cyclers
	void ElementalFire1_Timer()
	{
		CallEventDelayed(Random(5, 15), "ElementalFire1_Timer");
		if (!IsAlive(ENT_ME))
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
		if (!Contains(NPCATK_TARGET, "unset"))
			return;
		int rndPick = RandomInt(0, 2);
		string rndAnim = GetToken(RAND_IDLE_ANIMS, rndPick);
		PlayAnim("critical", rndAnim);
	}

	// unnamed block (timer)
	void ElementalFire1_Timer2()
	{
		CallEventDelayed(15.1f, "ElementalFire1_Timer2");
		if (!IsAlive(ENT_ME))
			return;
		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 64), LIGHT_RAD, 15.0f);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		ServerPlaySound(1, 0, SOUND_HOVER);
		ServerPlaySound(2, 0, "weapons/egon_run3.wav");

		if (!AM_SUMMONED)
			return;
		CallExternal(MY_OWNER, "elemental_died");
	}

	// game_dynamically_created
	// ========== Summoned
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		if (!IsAlive(MY_OWNER))
			return;
		SetRace(RaceOf(MY_OWNER));
		AM_SUMMONED = true;
		CallEventDelayed(0.1f, "summoned_sound");
		NO_SPAWN_STUCK_CHECK = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Fire Elemental");
		SetModel("monsters/elementals_lesser.mdl");
		SetHealth(500);
		SetWidth(32);
		SetHeight(48);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("poison", 0);
		// ov 80
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);

		FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
		SetBlood("none");

		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * 0.5f;

		ClientEvent("new", "all", "effects/sfx_follow_glow_cl", IndexOf(ENT_ME), Vector3(255, 128, 64), LIGHT_RAD, 15.0f);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (FIRE_BALL_AMMO > 0.0f)
			ATTACK_MOVERANGE = 512.0f;
		else
			ATTACK_MOVERANGE = SWIPE_MOVERANGE;

		if (NPCATK_TARGET == "unset")
			return;

		if (GameTime() > NEXT_CIRCLE)
		{
			ATTACK_MOVERANGE = SWIPE_MOVERANGE;
			if (RangeTo(NPCATK_TARGET) < CIRCLE_RANGE)
			{
				NEXT_CIRCLE = GameTime() + FREQ_CIRCLE;
				OnDoCof();
			}
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElementalFire1_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	// ========== Hunt Cycle
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		PlaySound(0, 10, SOUND_ALERT);
		PlayAnim("once", ANIM_ALERT);

		NEXT_CIRCLE = GameTime() + FREQ_CIRCLE;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		if (!(FIRE_BALL_AMMO > 0.0f))
			return;
		if (!FIREBALL_PREPPED)
			PlaySound(0, 10, SOUND_FIRECHARGE);
		FIREBALL_PREPPED = true;
		PlayAnim("once", ANIM_FIRE_BALL);
	}

	// throw_fireball
	// ========== Anim Events
	// anim event
	void OnThrowFireball()
	{
		FIREBALL_PREPPED = false;
		FIRE_BALL_AMMO -= 1.0f;
		PlaySound(0, 10, SOUND_FIRESHOOT);

		float aimAngle = DistanceTo(NPCATK_TARGET); // Aim up a bit
		DebugPrint("throw_fireball " + Text(aimAngle));
		aimAngle = Divide(aimAngle, AIM_RATIO);
		SetAngle("add_view.x", aimAngle);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile(PROJ_SCRIPT, RelativePosition(Vector3(0, 48, 24)), "none", ATTACK_SPEED, DMG_FIRE_BALL, ATTACK_CONE_OF_FIRE, "none");
		CallExternal(EntityOf(ENT_LASTPROJECTILE), "lighten", DOT_FIRE);

		NEXT_FIRE_BALL = GameTime() + FREQ_FIRE_BALL;
	}

	// attack1_strike
	void OnAttack1Strike()
	{
		SWIPE_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, "90%", "blunt");
	}

	// npc_struck
	// ========== Struck
	// called from base_npc_attack - param1 damage taken as of 22/Aug/2006 14:50
	void OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth <= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);

		// If enemy that hit me is close, he will be set on fire
		if (damage > 20.0f && myHealth > 0.0f)
			AddVelocity(ENT_ME, RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(Random(-100, 100), -500, 0)));

		// people who touch me get burned
		if (!(RangeTo(ENT_LASTSTRUCK) < Float(MOVE_RANGE)))
			return;
		ApplyEffect(ENT_LASTSTRUCK, "effects/dot_fire", 2, self, DOT_FIRE);
	}

	// 3.0
	void On_30()
	{
		if (!IsAlive(ENT_ME))
			return;
		ServerPlaySound(1, 8, SOUND_HOVER);
	}

	// summoned_sound
	void OnSummonedSound()
	{
		PlaySound(0, 10, "ambience/alien_humongo.wav");
	}

	// do_cof
	// ========== Circle o Fire
	void OnDoCof()
	{
		if (!IsAlive(ENT_ME))
			return;

		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) <= CIRCLE_RANGE))
			return;

		OnNpcatkSuspendAi();
		OnGameStopmoving();
		PlayAnim("critical", ANIM_TOCHARGE);
		PlaySound(0, 10, SOUND_CIRCLE_READY);
		CallEventDelayed(0.5f, "do_cof2");
	}

	// do_cof2
	void OnDoCof2()
	{
		OnNpcatkSuspendMovement(ANIM_CHARGEIDLE);
		ClientEvent("new", "all", "effects/sfx_circle_of_fire", OriginOf(ENT_ME), 64, 1, CIRCLE_DURATION);
		ServerPlaySound(2, 10, "weapons/egon_run3.wav");
		COF_ACTIVE = true;
		CallEventDelayed(CIRCLE_DURATION, "cof_end");
		OnDoCofLoop();
	}

	// cof_end
	void OnCofEnd()
	{
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		PlaySound(3, 10, "weapons/egon_off1.wav");
		ServerPlaySound(2, 0, "weapons/egon_run3.wav");
		COF_ACTIVE = false;
		FIRE_BALL_AMMO = FULL_FIRE_BALL_AMMO;
	}

	// do_cof_loop
	void OnDoCofLoop()
	{
		if (!COF_ACTIVE)
			return;
		if (!IsAlive(ENT_ME))
			return;
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), 128, DMG_SEAL, 0, ENT_ME, ENT_ME, "none", "fire_effect");
		CallEventDelayed(1.0f, "do_cof_loop");
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

	void OnCircleDuration() {} // CIRCLE_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_lesser.mdl");
		Precache("fans/fan4on.wav");
		Precache("weapons/egon_run3.wav");
		CallEventDelayed(Float(Eval("$randf(5,15)")), "ElementalFire1_Timer");
		CallEventDelayed(15.1f, "ElementalFire1_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalFire1_FirstThink();
		ElementalFire1_FirstThink2();
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
		if (name == "3.0") { On_30(); return true; }
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "cof_end") { OnCofEnd(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_cof") { OnDoCof(); return true; }
		if (name == "do_cof2") { OnDoCof2(); return true; }
		if (name == "do_cof_loop") { OnDoCofLoop(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "summoned_sound") { OnSummonedSound(); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		if (name == "ElementalFire1_Timer") { ElementalFire1_Timer(); return true; }
		if (name == "ElementalFire1_Timer2") { ElementalFire1_Timer2(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
