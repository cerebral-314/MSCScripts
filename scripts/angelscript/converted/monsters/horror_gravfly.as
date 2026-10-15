#pragma context server

// Converted from monsters/horror_gravfly.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"

[script "monsters/horror_gravfly"]
class HorrorGravfly : BaseMonsterNewScript, BaseFlyerGrav
{
	// Constants
	string ANIM_FLY = "fly1";
	string ANIM_ROLL = "fly2";
	string ANIM_BITE1 = "bite1";
	string ANIM_BITE2 = "bite2";
	string ANIM_BREATH = "breath";
	string ANIM_HOVER = "hover";
	int MAX_SPIT_AMMO = 3;
	int DMG_PROJECTILE = 100;
	string PROJ_SCRIPT = "proj_poison_spit2";
	float PROJ_SPEED = 500.0f;
	float PROJ_FOV = 0.5f;
	float FREQ_HORROR_BOOST = 0.0f;
	float DOT_SHOCK = 15.0f;
	int DMG_BLAST = 100;
	string ATTACK_HITCHANCE = "80%";
	float DMG_BITE = 100.0f;
	string SOUND_IDLE1 = "controller/con_idle1.wav";
	string SOUND_IDLE2 = "controller/con_idle2.wav";
	string SOUND_IDLE3 = "controller/con_idle3.wav";
	string SOUND_SPIT1 = "bullchicken/bc_attack3.wav";
	string SOUND_SPIT2 = "bullchicken/bc_attack2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_ATTACK3 = "controller/con_attack3.wav";
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "controller/con_pain1.wav";
	string SOUND_PAIN2 = "controller/con_die2.wav";
	string SOUND_SPRAY = "controller/con_attack3.wav";
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string SOUND_SHOCK1 = "bullchicken/bc_attack1.wav";
	string SOUND_SHOCK2 = "bullchicken/bc_attack2.wav";
	string SOUND_SHOCK3 = "bullchicken/bc_attack3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_UNHOLY = true;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float SPIT_AMMO = 0.0f;
	float BREATH_AMMO = 0.0f;
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;
	float NPC_HALF_HEALTH = 0.0f;
	bool PROJECTILE_ATTACK = false;
	bool BREATH_ATTACK = false;
	float NEXT_HORROR_BOOST = 0.0f;
	Vector3 BURST_POS = Vector3();
	string BURST_TARGS = "BURST_TARGS";

	// Variables declared by included files, with the value they start with in this script
	HorrorGravfly()
	{
		ANIM_WALK = "fly1";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "fly1";
		SOUND_DEATH = "controller/con_die1.wav";
	}

	// unnamed block (first think)
	void HorrorGravfly_FirstThink()
	{
		ANIM_WALK = "fly1";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "fly1";
		ANIM_ATTACK = "bite1"; // attack1
		ANIM_DEATH = "die";
	}

	// unnamed block (first think)
	void HorrorGravfly_FirstThink2()
	{
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 40;
		DROP_GOLD_MAX = 200;
		NPC_GIVE_EXP = 400.0f;

		IS_UNHOLY = true;

		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;

		BALL_SIZE = 5.0f;
		BALL_DMG = 100.0f;

		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 60.0f;
	}

	// unnamed block (timer)
	void HorrorGravfly_Timer()
	{
		CallEventDelayed(30.0f, "HorrorGravfly_Timer");
		if (!(SPIT_AMMO < MAX_SPIT_AMMO))
			return;
		if (SPIT_AMMO == 0.0f && NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) < 200.0f)
			OnNpcatkFlee(NPCATK_TARGET, "512", "1.0");

		SPIT_AMMO += 1.0f;
	}

	// unnamed block (timer)
	void HorrorGravfly_Timer2()
	{
		CallEventDelayed(60.0f, "HorrorGravfly_Timer2");
		if (!(BREATH_AMMO <= 0.0f))
			return;
		BREATH_AMMO = 1.0f;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		NPC_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Enraged Horror");

		SetHealth(1000); // hi HP, no armor
		SetWidth(32);
		SetHeight(32);
		SetBoundingBox("npcsize");
		SetRoam(true);
		SetRace("demon");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(11);
		SetModel("monsters/edwardgorey2.mdl");
		// setmodelbody 0 2
		SetMoveSpeed(3);
		BASE_MOVESPEED = 3.0f;

		PlayAnim("once", ANIM_WALK);

		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);

		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		bool exitSub = false;
		if (SPIT_AMMO > 0.0f)
		{
			ANIM_ATTACK = ANIM_BREATH;
			PROJECTILE_ATTACK = true;
			BREATH_ATTACK = false;
			ANIM_WALK = ANIM_FLY;
			ANIM_RUN = ANIM_FLY;
			PlayAnim("once", ANIM_ATTACK);
			exitSub = true;
		}
		else if (BREATH_AMMO > 0.0f)
		{
			ANIM_ATTACK = ANIM_BREATH;
			ANIM_WALK = ANIM_ROLL;
			ANIM_RUN = ANIM_ROLL;
			PROJECTILE_ATTACK = false;
			BREATH_ATTACK = true;
			exitSub = true;
		}
		else
		{
			if (ANIM_ATTACK != ANIM_BITE1 && ANIM_ATTACK != ANIM_BITE2)
				ANIM_ATTACK = ANIM_BITE1;
			ANIM_WALK = ANIM_FLY;
			ANIM_RUN = ANIM_FLY;
			BREATH_ATTACK = false;
			PROJECTILE_ATTACK = false;
		}
		if (exitSub)
			return;

		if (!(GameTime() > NEXT_HORROR_BOOST))
			return;
		NEXT_HORROR_BOOST = GameTime() + FREQ_HORROR_BOOST;
		PlaySound(0, 10, "SOUND_FLAP");
		PlayAnim("once", ANIM_ROLL);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 0)));
	}

	// idle_sounds
	void OnIdleSounds()
	{
		if (!IsAlive(ENT_ME))
			return;

		float nextSound = Random(3, 10);

		CallEventDelayed(nextSound, "idle_sounds");

		if (NPCATK_TARGET != "none")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// breath_attack
	// called by model anim: breath
	void OnBreathAttack()
	{
		int count;
		if (PROJECTILE_ATTACK)
		{
			// lightning ball
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile(PROJ_SCRIPT, "view", "none", PROJ_SPEED, DMG_PROJECTILE, PROJ_FOV, "none");
			PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
			SPIT_AMMO -= 1.0f;
		}

		if (BREATH_ATTACK)
		{
			// lightning burst
			Effect("glow", ENT_ME, Vector3(255, 255, 0), 768, 2, 2);
			PlaySound(0, 10, SOUND_SPRAY);
			BURST_POS = OriginOf(ENT_ME);
			BURST_POS.z = GroundHeight(BURST_POS);
			ClientEvent("new", "all", "effects/sfx_poison_burst", BURST_POS, 256, 1, Vector3(0, 255, 0));
			DoDamage(Text(BURST_POS), 256, DMG_BLAST, "100%", 0, "reflective", "poison_effect");
			BREATH_AMMO -= 1.0f;
			BURST_TARGS = LegacyFunction("get_tsphere", "enemy", 256, BURST_POS);
			if (BURST_TARGS != "none")
			{
				count = GetTokenCount(BURST_TARGS);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnBurstAffectTargets();
					if (breakLoop)
					{
						breakLoop = false;
						break;
					}
				}
			}
		}
	}

	// burst_affect_targets
	void OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		ApplyEffect(curTarg, "effects/dot_poison", 5.0f, self, DOT_SHOCK);
	}

	// attack1
	// called by model anim: bite1
	void OnAttack1()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (RandomInt(1, 5) == 1)
			ANIM_ATTACK = ANIM_BITE2;
	}

	// attack2
	// called by model anim: bite2
	void OnAttack2()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE);

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		ANIM_ATTACK = ANIM_BITE1;

		if (!(RangeTo(NPCATK_TARGET) <= ATTACK_HITRANGE))
			return;
		ApplyEffect(NPCATK_TARGET, "effects/dot_poison_blind", 5.0f, self, DOT_SHOCK);
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(-550, 50, 10)));
	}

	// spiral_charge
	// called by model anim: fly2
	void OnSpiralCharge()
	{
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// turret_horror
	// called by model anim: hover
	void OnTurretHorror()
	{
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= NPC_HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth < NPC_HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
	}

	void OnNextSound() {} // NEXT_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/edwardgorey2.mdl");
		CallEventDelayed(30.0f, "HorrorGravfly_Timer");
		CallEventDelayed(60.0f, "HorrorGravfly_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HorrorGravfly_FirstThink();
		HorrorGravfly_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "breath_attack") { OnBreathAttack(); return true; }
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "spiral_charge") { OnSpiralCharge(); return true; }
		if (name == "turret_horror") { OnTurretHorror(); return true; }
		if (name == "HorrorGravfly_Timer") { HorrorGravfly_Timer(); return true; }
		if (name == "HorrorGravfly_Timer2") { HorrorGravfly_Timer2(); return true; }
		return BaseFlyerGrav_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
