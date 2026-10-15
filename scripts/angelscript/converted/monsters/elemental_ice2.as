#pragma context server

// Converted from monsters/elemental_ice2.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Lesser Fire Elemental by Thothie (From Screatch)
// - Throws three fire balls, approaches player, uses Circle of Fire spell, repeats

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/elemental_ice2"]
class ElementalIce2 : BaseMonsterNewScript
{
	// Constants
	int SWIPE_RANGE = 100;
	int SNOWBALL_RANGE = 600;
	int SNOWBALL_DAMAGE = 100;
	float SNOWBALL_FREQ = 45.0f;
	string SOUND_SNOWBALL = "zombie/claw_miss1.wav";
	string ATTACK_HITCHANCE = "0.8";
	int SWIPE_MOVERANGE = 65;
	int SWIPE_HITRANGE = 150;
	string ATTACK_ACCURACY = "80%";
	int CIRCLE_RANGE = 2048;
	int AIM_RATIO = 50;
	string AMB_FROST_DAMAGE = "$rand(30,60)";
	string FROST_DAMAGE = "$rand(60,80)";
	string STRIKE_DAMAGE = "$rand(100,250)";
	int ICESEAL_DAMAGE = 200;
	string ANIM_SWIPE = "attack1";
	string ANIM_BASEIDLE = "idle1";
	string ANIM_FLOAT = "idle1";
	string ANIM_BUGIDLE_A = "idle1";
	string ANIM_BUGIDLE_B = "idle2";
	string ANIM_BUGIDLE_C = "dunno";
	string ANIM_CHARGE = "float";
	string ANIM_ALERT = "yes";
	string ANIM_GLOAT = "no";
	string ANIM_SEARCH = "dunno";
	string ANIM_TOCHARGE = "tocharge";
	string ANIM_CHARGEIDLE = "charging";
	string ANIM_FROMCHARGE = "fromcharge";
	string SOUND_ALERT = "agrunt/ag_alert5.wav";
	string SOUND_IDLE1 = "agrunt/ag_alert1.wav";
	string SOUND_IDLE2 = "agrunt/ag_die1.wav";
	string SOUND_IDLE3 = "agrunt/ag_idle1.wav";
	string SOUND_SWIPE = "weapons/debris1.wav";
	string SOUND_SWIPEHIT = "magic/frost_reverse.wav";
	string SOUND_PAIN0 = "debris/glass1.wav";
	string SOUND_PAIN1 = "agrunt/ag_pain1.wav";
	string SOUND_PAIN2 = "agrunt/ag_pain4.wav";
	string SOUND_GLOAT = "x/x_laugh1.wav";
	string SOUND_CIRCLE_READY = "debris/beamstart1.wav";
	string SOUND_WAVE_GO = "ambience/flameburst1.wav";
	string SOUND_HOVER = "fans/fan3on.wav";
	float PLAYTIME_HOVER = 3.0f;
	float CIRCLE_FREQ = 30.0f;
	bool NO_VICTORY_HEAL = true;
	string CIRCLE_SCRIPT = "monsters/summon/ice_wave";
	bool I_AM_TURNABLE = false;
	int MOVE_FAST = 200;
	int MOVE_NORMAL = 100;
	string MONSTER_MODEL = "monsters/elementals_greater.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	float SNOWBALL_DURATION = 0.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	bool CIRCLE_DELAY = false;
	float MY_HURT_STAGE = 0.0f;
	bool USE_SWIPE_SOUND = false;
	bool SNOWBALL_DELAY = false;
	bool PREP_CIRCLE = false;
	string TEMP_MOVE_TARGET = "TEMP_MOVE_TARGET";
	bool CIRCLE_RUNNING = false;
	float FIRE_BALL_AMMO = 0.0f;
	bool DID_SHRUG = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool GLOAT_DELAY = false;
	bool DID_WARCRY = false;
	float HOVER_LOOP_DELAY = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ElementalIce2()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ElementalIce2_FirstThink()
	{
		AS_SUMMON_TELE_CHECK = true;

		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		ATTACK_RANGE = 1024.0f;
		SNOWBALL_DURATION = 10.0f; // read by proj_snow_ball
		ATTACK_HITRANGE = 150.0f;
		MOVE_RANGE = "65";

		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_FLINCH = "flinch";
		ANIM_DEATH = "die1";

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 10;
		DROP_GOLD_MAX = 40;
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL; // for basepropelled
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string ElementalIce2_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (CIRCLE_RUNNING && hit)
		{
			ApplyEffect(ENT_LASTSTRUCKBYME, "effects/dot_cold_freeze", 10.0f, LegacyFunction("get", ENT_ME));
			int throwDir = RandomInt(1, 2);
			if (throwDir == 1)
				AddVelocity(target, RelativeVelocity(Vector3(-100, 50, 30)));
			if (throwDir == 2)
				AddVelocity(target, RelativeVelocity(Vector3(100, 50, 30)));
		}

		if (hit && USE_SWIPE_SOUND)
		{
			ApplyEffect(target, "effects/dot_cold", 4, self, FROST_DAMAGE, "none");
			PlaySound(0, 10, SOUND_SWIPEHIT);
		}
		USE_SWIPE_SOUND = false;
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Greater Ice Elemental");
		SetHealth(1750);
		SetWidth(32);
		SetHeight(48);
		SetRace("demon");
		SetDamageTaken("all", 0.4f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("fire", 1.5f);
		SetDamageTaken("cold", 0);
		SetDamageTaken("poison", 0);
		// ov 80
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(3);
		SetModel(MONSTER_MODEL);
		SetModelBody(0, 1);
		SetBlood("none");

		CIRCLE_DELAY = true;
		CallEventDelayed(15.0f, "reset_circle_delay");

		NPC_GIVE_EXP = 400.0f;
		CallEventDelayed(1.0f, "idle_sounds");
		SetStat("parry", 40);

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (SUSPEND_AI)
			return;

		if (!CIRCLE_DELAY)
			ATTACK_RANGE = CIRCLE_RANGE;
		if (CIRCLE_DELAY)
			ATTACK_RANGE = SWIPE_RANGE;

		if (!SNOWBALL_DELAY && RangeTo(NPCATK_TARGET) > 256.0f && !CIRCLE_RUNNING && !PREP_CIRCLE)
		{
			PlayAnim("critical", "fireball");
			AS_ATTACKING = GameTime();
			SNOWBALL_DELAY = true;
			CallEventDelayed(SNOWBALL_FREQ, "reset_snowball");
		}
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (SUSPEND_AI)
			return;

		if (!IsPlayer(target))
			return;
		// callevent npcatk_setmovedest $get(ent_lastseen,id) ATTACK_RANGE
		if (DID_WARCRY)
			return;

		// callevent npcatk_faceattacker
		DID_WARCRY = true;
		PlayAnim("critical", ANIM_ALERT);
		PlaySound(0, 10, SOUND_ALERT);
	}

	// my_target_died
	// called from base_npc_attack
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		if (!GLOAT_DELAY)
		{
			PlayAnim("critical", ANIM_GLOAT);
			PlaySound(0, 10, SOUND_GLOAT);
			GLOAT_DELAY = true;
			CallEventDelayed(10.0f, "reset_gloat");
		}

		if (!CanSee("enemy"))
		{
			DID_WARCRY = false;
			DID_SHRUG = false;
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, ElementalIce2_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		// //dbg temp AtkRng ATTACK_RANGE
		if (CIRCLE_RUNNING)
			return;
		if (CIRCLE_DELAY)
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		if (!(RangeTo(NPCATK_TARGET) < CIRCLE_RANGE))
			return;
		PREP_CIRCLE = true;
		NO_STUCK_CHECKS = "1";
		AS_ATTACKING = GameTime();
		OnNpcatkSuspendAi();
		OnNpcatkClearMovedest();
		CallEventDelayed(0.1f, "circle_prep");
		CIRCLE_DELAY = true;
		CallEventDelayed(CIRCLE_FREQ, "reset_circle_delay");
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

		if (damage > 40.0f) // float around when struck hard
			AddVelocity(ENT_ME, RelativePosition(Vector3(1, -10, 1)));

		// If enemy that hit me is close, he will be frozen
		if (!(RangeTo(ENT_LASTSTRUCK) < Float(MOVE_RANGE)))
			return;
		ApplyEffect(ENT_LASTSTRUCK, "effects/dot_cold", 1, self, AMB_FROST_DAMAGE);
	}

	// idle_sounds
	void OnIdleSounds()
	{
		float nextSound = Random(5, 15);

		CallEventDelayed(nextSound, "idle_sounds");

		if (IS_HUNTING)
			return;
		int randAnim = RandomInt(1, 3);
		if (randAnim == 1) // was having some odd bug with idle anims, hence odd names
			PlayAnim("once", ANIM_BUGIDLE_A);
		if (randAnim == 2)
			PlayAnim("once", ANIM_BUGIDLE_B);
		if (randAnim == 3)
			PlayAnim("once", ANIM_BUGIDLE_C);

		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// circle_prep
	void OnCirclePrep()
	{
		// setbbox npcsize
		SetMoveSpeed(0);
		SetAnimMoveSpeed(0);
		NPC_HACKED_MOVE_SPEED = 0.0f;
		// setmovedest TEMP_MOVE_TARGET 0
		Effect("glow", ENT_ME, Vector3(0, 75, 255), 50, 5, 5);
		PlaySound(0, 10, SOUND_CIRCLE_READY);
		PlayAnim("critical", "tocharge");
	}

	// tocharge_done
	void OnTochargeDone()
	{
		if (CanSee("enemy"))
		{
			// setvard TEMP_MOVE_TARGET $get(ent_lastseen,origin) //blarg
			// setvard TEMP_MOVE_TARGET $relpos(0,9999,0) //works
			Vector3 traceStart = MyOrigin();
			Vector3 traceEnd = RelativePosition(Vector3(0, 9999, 0));
			TEMP_MOVE_TARGET = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly"); // w00t!
			// dbg temp tracesend TRACE_END result TEMP_MOVE_TARGET length $dist(TRACE_START,TEMP_MOVE_TARGET)
			SetMoveDest(TEMP_MOVE_TARGET, 10);
		}

		// setmovedest TEMP_MOVE_TARGET 0
		SetIdleAnim(ANIM_CHARGEIDLE);
		SetMoveAnim(ANIM_CHARGEIDLE);
		CallEventDelayed(2.0f, "circle_go");
	}

	// circle_go
	// called from model anim tocharge
	void OnCircleGo()
	{
		if (CIRCLE_RUNNING)
			return;

		// setvard DEST_ORIGIN $relpos(0,128,0)
		SetMoveAnim(ANIM_CHARGE);
		SetIdleAnim(ANIM_CHARGE);
		SetMoveSpeed(2);

		// charge with swipe
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 100, 0)));
		SetAnimMoveSpeed(MOVE_FAST);
		NPC_HACKED_MOVE_SPEED = MOVE_FAST;
		PlayAnim("critical", ANIM_CHARGE);
		CIRCLE_RUNNING = true;

		PlaySound(0, 10, SOUND_WAVE_GO);

		CreateNpc(CIRCLE_SCRIPT, RelativePosition(Vector3(0, 0, 0)), 3.0f, self);

		OnCircleCycle();
		CallEventDelayed(3.0f, "circle_done");
	}

	// circle_cycle
	void OnCircleCycle()
	{
		if (!CIRCLE_RUNNING)
			return;
		SetMoveDest(TEMP_MOVE_TARGET, 10);
		if (Distance(MyOrigin(), Vec(TEMP_MOVE_TARGET)) < 32.0f)
			OnCircleDone();
		OnNpcatkDodamage(Text(RelativePosition(Vector3(0, 32, 0))), "72", "0", "100", "0");

		CallEventDelayed(0.1f, "circle_cycle");
	}

	// circle_done
	void OnCircleDone()
	{
		if (!CIRCLE_RUNNING)
			return;
		OnNpcatkResumeAi();
		PREP_CIRCLE = false;
		SetMoveSpeed(1);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		ANIM_ATTACK = ANIM_SWIPE;
		SetAnimMoveSpeed(MOVE_NORMAL);
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
		CIRCLE_RUNNING = false;
		NO_STUCK_CHECKS = "0";
	}

	// reset_circle_delay
	void OnResetCircleDelay()
	{
		CIRCLE_DELAY = false;
	}

	// slow_down
	void OnSlowDown()
	{
		// setvard CAN_ATTACK 1
		NPC_HACKED_MOVE_SPEED = MOVE_NORMAL;
	}

	// ammo_up
	void OnAmmoUp()
	{
		FIRE_BALL_AMMO = 0.0f;
	}

	// npcatk_search_init_advanced
	void OnNpcatkSearchInitAdvanced()
	{
		if (CanSee("enemy"))
			return;

		if (DID_SHRUG)
			return;
		DID_SHRUG = true;

		NPC_DELAYING_UNSTUCK = "5.0";

		PlayAnim("critical", ANIM_SEARCH);
		PlaySound(0, 10, SOUND_IDLE3);
	}

	// reset_gloat
	void OnResetGloat()
	{
		GLOAT_DELAY = false; // this prevents sploiting with icewall/pets
	}

	// attack1_strike
	// called from anim attack1 @ frame12
	void OnAttack1Strike()
	{
		USE_SWIPE_SOUND = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), STRIKE_DAMAGE, ATTACK_ACCURACY);
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement

		if (int(HOVER_LOOP_DELAY) != 0)
			return;
		PlaySound(Int(GetVar("CHAN_BODY")), 8, SOUND_HOVER);
		HOVER_LOOP_DELAY = 1.0f;
		CallEventDelayed(PLAYTIME_HOVER, "hover_loop_reset");
	}

	// hover_loop_reset
	void OnHoverLoopReset()
	{
		HOVER_LOOP_DELAY = 0.0f;
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		SetAnimMoveSpeed(0); // Force Stop
	}

	// throw_fireball
	void OnThrowFireball()
	{
		PlaySound(0, 10, SOUND_SNOWBALL);

		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.pitch", aimAngle);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_snow_ball", RelativePosition(Vector3(0, 52, 24)), "none", 200, SNOWBALL_DAMAGE, 2, "none");
	}

	// reset_snowball
	void OnResetSnowball()
	{
		// dbg Temp Snowball Reset
		SNOWBALL_DELAY = false;
	}

	// npcatk_clear_movedest
	// only two scripts use this, so we took it out of the AI to save load time
	void OnNpcatkClearMovedest()
	{
		SetMoveDest("none");
		NPC_MOVEDEST_TARGET = "unset";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnCircleFreq() {} // CIRCLE_FREQ
	void OnNextSound() {} // NEXT_SOUND
	void OnPlaytimeHover() {} // PLAYTIME_HOVER
	void OnSnowballFreq() {} // SNOWBALL_FREQ

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_greater.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalIce2_FirstThink();
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
		if (name == "ammo_up") { OnAmmoUp(); return true; }
		if (name == "attack1_strike") { OnAttack1Strike(); return true; }
		if (name == "circle_cycle") { OnCircleCycle(); return true; }
		if (name == "circle_done") { OnCircleDone(); return true; }
		if (name == "circle_go") { OnCircleGo(); return true; }
		if (name == "circle_prep") { OnCirclePrep(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "hover_loop_reset") { OnHoverLoopReset(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_clear_movedest") { OnNpcatkClearMovedest(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "reset_circle_delay") { OnResetCircleDelay(); return true; }
		if (name == "reset_gloat") { OnResetGloat(); return true; }
		if (name == "reset_snowball") { OnResetSnowball(); return true; }
		if (name == "slow_down") { OnSlowDown(); return true; }
		if (name == "throw_fireball") { OnThrowFireball(); return true; }
		if (name == "tocharge_done") { OnTochargeDone(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
