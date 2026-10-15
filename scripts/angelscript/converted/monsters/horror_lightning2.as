#pragma context server

// Converted from monsters/horror_lightning2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HorrorLightning2
{
	// Constants
	string ANIM_FLY = "fly1";
	string ANIM_ROLL = "fly2";
	string ANIM_BITE1 = "bite1";
	string ANIM_BITE2 = "bite2";
	string ANIM_BREATH = "breath";
	string ANIM_HOVER = "hover";
	int DMG_PROJECTILE = 100;
	string PROJ_SCRIPT = "proj_lightning_ball";
	float PROJ_SPEED = 200.0f;
	float PROJ_FOV = 0.5f;
	string FX_BURST_SCRIPT = "effects/sfx_shock_burst";
	string EFFECT_DOT = "effects/dot_lightning";
	float DUR_DOT = 5.0f;
	int DMG_DOT = 30;
	float DMG_BITE = 100.0f;
	int DMG_BLAST = 200;
	Vector3 ELEMENT_COLOR = Vector3();
	string BURST_ELEMENT = "lightning_effect";
	int MAX_SPIT_AMMO = 3;
	float FREQ_HORROR_BOOST = 0.0f;
	string ATTACK_HITCHANCE = "80%";
	string SOUND_IDLE1 = "controller/con_idle1.wav";
	string SOUND_IDLE2 = "controller/con_idle2.wav";
	string SOUND_IDLE3 = "controller/con_idle3.wav";
	string SOUND_SPIT1 = "bullchicken/bc_attack3.wav";
	string SOUND_SPIT2 = "bullchicken/bc_attack2.wav";
	string SOUND_ATTACK1 = "controller/con_attack1.wav";
	string SOUND_ATTACK2 = "controller/con_attack2.wav";
	string SOUND_ATTACK3 = "controller/con_attack3.wav";
	string SOUND_DEATH = "controller/con_die1.wav";
	string SOUND_PAIN0 = "debris/bustflesh2.wav";
	string SOUND_PAIN1 = "controller/con_pain1.wav";
	string SOUND_PAIN2 = "controller/con_die2.wav";
	string SOUND_SPRAY = "controller/con_attack3.wav";
	string SOUND_FLAP1 = "monsters/bat/flap_big1.wav";
	string SOUND_FLAP2 = "monsters/bat/flap_big2.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "fly1";
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "fly1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool AS_SUMMON_TELE_CHECK = true;
	bool IS_UNHOLY = true;
	int DROP_GOLD = 0;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	float NPC_GIVE_EXP = 0.0f;
	float SPIT_AMMO = 0.0f;
	float BREATH_AMMO = 0.0f;
	float BALL_SIZE = 0.0f;
	float BALL_DMG = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float BASE_MOVESPEED = 0.0f;
	float NPC_HALF_HEALTH = 0.0f;
	bool PROJECTILE_ATTACK = false;
	bool BREATH_ATTACK = false;
	bool BFLY_AGRESSIVE = false;
	float NEXT_HORROR_BOOST = 0.0f;
	Vector3 BURST_POS = Vector3();
	string BURST_TARGS = "BURST_TARGS";

	// unnamed block (first think)
	void HorrorLightning2_FirstThink()
	{
		ANIM_WALK = "fly1";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "fly1";
		ANIM_ATTACK = "bite1"; // attack1
		ANIM_DEATH = "die";
	}

	// unnamed block (first think)
	void HorrorLightning2_FirstThink2()
	{
		AS_SUMMON_TELE_CHECK = true;

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

	// npc_spawn
	void HorrorLightning2_OnNpcSpawn(string npc = "")
	{
		OnHorrorSpawn();
	}

	// horror_spawn
	void HorrorLightning2_OnHorrorSpawn()
	{
		SetName("Enraged Electrical Horror");

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
		SetModelBody(0, 2);
		SetMoveSpeed(3);
		BASE_MOVESPEED = 3.0f;

		PlayAnim("once", ANIM_WALK);

		CallEventDelayed(1.0f, "idle_sounds");
		SetDamageTaken("poison", 2);
		SetDamageTaken("holy", 2);
		SetDamageTaken("lightning", 0);

		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;
	}

	// npc_post_spawn
	void HorrorLightning2_OnNpcPostSpawn()
	{
		NPC_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// idle_sounds
	void HorrorLightning2_OnIdleSounds()
	{
		if (!IsAlive(ENT_ME))
			return;

		float nextSound = Random(3, 10);

		CallEventDelayed(nextSound, "idle_sounds");

		if (NPCATK_TARGET != "none")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// npc_targetsighted
	void HorrorLightning2_OnNpcTargetsighted(string target = "")
	{
		bool exitSub = false;
		if (SPIT_AMMO > 0.0f)
		{
			ANIM_ATTACK = ANIM_BREATH;
			PROJECTILE_ATTACK = true;
			BREATH_ATTACK = false;
			ANIM_WALK = ANIM_FLY;
			ANIM_RUN = ANIM_FLY;
			PlayAnim("once", ANIM_ATTACK);
			BFLY_AGRESSIVE = false;
			exitSub = true;
		}
		else
		{
			// consider adding to base_flyer_grav under setvard BF_AGRESSIVE 1|0
			BFLY_AGRESSIVE = true;
			if (BREATH_AMMO > 0.0f)
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

	// breath_attack
	// called by model anim: breath
	void HorrorLightning2_OnBreathAttack()
	{
		int count;
		if (PROJECTILE_ATTACK)
		{
			// lightning ball
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile(PROJ_SCRIPT, "view", "none", PROJ_SPEED, DMG_PROJECTILE, PROJ_FOV, "none");
			PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
			SPIT_AMMO -= 1.0f;
			if (SPIT_AMMO <= 0.0f)
				CallEventDelayed(30.0f, "reload_spit");
		}

		if (BREATH_ATTACK)
		{
			// lightning burst
			CallEventDelayed(15.0f, "reload_breath");
			Effect("glow", ENT_ME, ELEMENT_COLOR, 768, 2, 2);
			PlaySound(0, 10, SOUND_SPRAY);
			BURST_POS = OriginOf(ENT_ME);
			BURST_POS.z = GroundHeight(BURST_POS);
			ClientEvent("new", "all", FX_BURST_SCRIPT, BURST_POS, 256, 1, ELEMENT_COLOR);
			DoDamage(Text(BURST_POS), 256, DMG_BLAST, "100%", 0, "reflective", BURST_ELEMENT);
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

	// reload_breath
	void HorrorLightning2_OnReloadBreath()
	{
		BREATH_AMMO = 1.0f;
	}

	// burst_affect_targets
	void HorrorLightning2_OnBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		ApplyEffect(curTarg, EFFECT_DOT, DUR_DOT, self, DMG_DOT);
		if (!Truthy(GetVar("BURST_PUSH")))
			return;
		OnRepelTarget(curTarg, Text(Vector3(0, 1000, 110)), BURST_POS);
	}

	// repel_target
	// <target> <strength> <from_origin>
	void HorrorLightning2_OnRepelTarget(string target = "", string strength = "", Vector3 fromOrigin = Vector3())
	{
		Vector3 targOrg = OriginOf(target);
		float targAng = AnglesTo(fromOrigin, targOrg);
		int newYaw = int(targAng);
		SetVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vec(strength)));
	}

	// attack1
	// called by model anim: bite1
	void HorrorLightning2_OnAttack1()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		if (RandomInt(1, 2) == 1)
			ANIM_ATTACK = ANIM_BITE2;
	}

	// attack2
	// called by model anim: bite2
	void HorrorLightning2_OnAttack2()
	{
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, ATTACK_HITCHANCE);

		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);

		ANIM_ATTACK = ANIM_BITE1;

		ApplyEffect(NPCATK_TARGET, EFFECT_DOT, DUR_DOT, self, DMG_DOT);

		if (!(RangeTo(NPCATK_TARGET) <= ATTACK_HITRANGE))
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(-550, 50, 10)));
	}

	// spiral_charge
	// called by model anim: fly2
	void HorrorLightning2_OnSpiralCharge()
	{
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// turret_horror
	// called by model anim: hover
	void HorrorLightning2_OnTurretHorror()
	{
		PlayRandomSound(0, 10, SOUND_FLAP1, SOUND_FLAP2);
	}

	// npc_struck
	void HorrorLightning2_OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= NPC_HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth < NPC_HALF_HEALTH)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);
	}

	// my_target_died
	void HorrorLightning2_OnMyTargetDied(string offender = "")
	{
		SPIT_AMMO = 3.0f;
		BREATH_AMMO = 1.0f;
	}

	// reload_spit
	void HorrorLightning2_OnReloadSpit()
	{
		if (!(SPIT_AMMO < MAX_SPIT_AMMO))
			return;
		SPIT_AMMO += 1.0f;
		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) < 200.0f))
			return;
		OnNpcatkFlee(NPCATK_TARGET, "512", "1.0");
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
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
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
		HorrorLightning2_OnNpcPostSpawn();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		HorrorLightning2_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		HorrorLightning2_OnMyTargetDied(offender);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		HorrorLightning2_OnNpcTargetsighted(target);
	}

	void OnHorrorSpawn() { HorrorLightning2_OnHorrorSpawn(); } // horror_spawn
	void OnIdleSounds() { HorrorLightning2_OnIdleSounds(); } // idle_sounds
	void OnBreathAttack() { HorrorLightning2_OnBreathAttack(); } // breath_attack
	void OnReloadBreath() { HorrorLightning2_OnReloadBreath(); } // reload_breath
	void OnBurstAffectTargets() { HorrorLightning2_OnBurstAffectTargets(); } // burst_affect_targets
	void OnRepelTarget(string target = "", string strength = "", Vector3 fromOrigin = Vector3()) { HorrorLightning2_OnRepelTarget(target, strength, fromOrigin); } // repel_target
	void OnAttack1() { HorrorLightning2_OnAttack1(); } // attack1
	void OnAttack2() { HorrorLightning2_OnAttack2(); } // attack2
	void OnSpiralCharge() { HorrorLightning2_OnSpiralCharge(); } // spiral_charge
	void OnTurretHorror() { HorrorLightning2_OnTurretHorror(); } // turret_horror
	void OnNpcStruck(float damage = 0.0f) { HorrorLightning2_OnNpcStruck(damage); } // npc_struck
	void OnReloadSpit() { HorrorLightning2_OnReloadSpit(); } // reload_spit
	void OnNextSound() {} // NEXT_SOUND

	// This file's events and timers by their .script names
	bool HorrorLightning2_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "breath_attack") { OnBreathAttack(); return true; }
		if (name == "burst_affect_targets") { OnBurstAffectTargets(); return true; }
		if (name == "horror_spawn") { OnHorrorSpawn(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reload_breath") { OnReloadBreath(); return true; }
		if (name == "reload_spit") { OnReloadSpit(); return true; }
		if (name == "repel_target") { OnRepelTarget(Param(params, 0), Param(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "spiral_charge") { OnSpiralCharge(); return true; }
		if (name == "turret_horror") { OnTurretHorror(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/horror_lightning2"]
shared class HorrorLightning2Script : BaseMonsterNewScript, HorrorLightning2, BaseFlyerGrav
{
	// Variables declared by included files, with the value they start with in this script
	HorrorLightning2Script()
	{
		ANIM_WALK = "fly1";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "fly1";
		SOUND_DEATH = "controller/con_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/edwardgorey2.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HorrorLightning2_FirstThink();
		HorrorLightning2_FirstThink2();
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
		return HorrorLightning2_DispatchEvent(name, params)
			|| BaseFlyerGrav_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
