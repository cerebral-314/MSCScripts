#pragma context server

// Converted from monsters/skeleton_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonBase
{
	// Constants
	string ANIM_DEATH_FAKE = "diesimple";
	string ANIM_GETUP = "getup";
	string SKEL_MODEL = "monsters/skeleton.mdl";
	int SKEL_WIDTH = 32;
	int SKEL_HEIGHT = 80;
	int SKEL_MOVE_RANGE = 32;
	int SKEL_ATTACK_RANGE = 64;
	int SKEL_ATTACK_HITRANGE = 127;
	bool NPC_HANDLES_SUMMON_CIRCLES = true;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "zombie/zo_pain2.wav";
	string SOUND_STRUCK5 = "zombie/zo_pain2.wav";
	string SOUND_ATTACK1 = "zombie/claw_miss1.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_DEATH = "zombie/zo_pain1.wav";
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLY_STRIKE = "doors/aliendoor1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_RESPAWN_DEADIDLE = "dead_on_stomach";
	string ANIM_IDLE = "idle1";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	bool AM_SKELETON = false;
	bool I_AM_TURNABLE = false;
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	bool STRUCK_HOLY = false;
	string SK_BASE_ANIM_RUN = "SK_BASE_ANIM_RUN";
	string SK_BASE_ANIM_WALK = "SK_BASE_ANIM_WALK";
	string SK_BASE_ANIM_IDLE = "SK_BASE_ANIM_IDLE";
	bool SET_GREEK = false;
	bool SLEEPER = false;
	bool DEEP_SLEEPER = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string MY_NAME = "MY_NAME";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	CBaseEntity@ SKEL_SLAYER = null;
	float NPC_GIVE_EXP = 0.0f;
	bool SKELE_TEMP_DEATH = false;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";

	// unnamed block (first think)
	void SkeletonBase_FirstThink()
	{
		ANIM_RESPAWN_DEADIDLE = "dead_on_stomach";

		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "dieheadshot";
	}

	// unnamed block (first think)
	void SkeletonBase_FirstThink2()
	{
		AM_SKELETON = true;
		I_AM_TURNABLE = true; // for monsters/exernals turn_undead
	}

	// npc_spawn
	void SkeletonBase_OnNpcSpawn(string npc = "")
	{
		if (ANIM_WALK == "ANIM_WALK")
			ANIM_WALK = "walk";
		if (ANIM_RUN == "ANIM_RUN")
			ANIM_RUN = "walk";

		SetModel(SKEL_MODEL);
		SetBlood("none");

		OnSkelGetSleeperProps();
		if (!DEEP_SLEEPER)
			SetHearingSensitivity(4);

		OnSkeletonSpawn();

		SetHealth(SKEL_HP);

		SetWidth(SKEL_WIDTH);
		SetHeight(SKEL_HEIGHT);
		MOVE_RANGE = SKEL_MOVE_RANGE;
		ATTACK_RANGE = SKEL_ATTACK_RANGE;
		ATTACK_HITRANGE = SKEL_ATTACK_HITRANGE;

		SetRoam(true);
		STRUCK_HOLY = false;

		if (SLEEPER)
		{
			OnMakeSleeper();
			if (!DEEP_SLEEPER) // light sleepers need to be able to hear approach
				SetHearingSensitivity(10);
		}
		else
		{
			SetRace("undead");
			SetMoveAnim(ANIM_WALK);
			OnSkeletonAttribs();
		}

		OnSkelSetupBody();
	}

	// npc_post_spawn
	void SkeletonBase_OnNpcPostSpawn()
	{
		// redundancy due to getup buggerups
		SK_BASE_ANIM_RUN = ANIM_RUN;
		SK_BASE_ANIM_WALK = ANIM_WALK;
		SK_BASE_ANIM_IDLE = ANIM_IDLE;
	}

	// go_greek
	void SkeletonBase_OnGoGreek()
	{
		SetModelBody(0, 10);
		SET_GREEK = true;
	}

	// skel_get_sleeper_props
	void SkeletonBase_OnSkelGetSleeperProps()
	{
		CBaseEntity@ sleeperId = FindByName("skels_sleep");
		if (IsAlive(sleeperId))
			SLEEPER = true;

		CBaseEntity@ sleeperTypeId = FindByName("skels_deep_sleep");
		if (IsAlive(sleeperTypeId))
		{
			SLEEPER = true;
			DEEP_SLEEPER = true;
		}
	}

	// skeleton_attribs
	void SkeletonBase_OnSkeletonAttribs()
	{
		if (SET_GREEK)
			SetModelBody(0, 10);

		SetDamageTaken("poison", 0);

		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetDamageTaken("slash", 0.7f);
			SetDamageTaken("pierce", 0.5f);
			SetDamageTaken("blunt", 1.2f);
			SetDamageTaken("fire", 1.5f);
			SetDamageTaken("holy", 3);
			SetDamageTaken("cold", 0.25f);
		}

		if (Truthy(GetVar("STONE_SKELETON")))
		{
			SetDamageTaken("holy", 2);
			SetDamageTaken("cold", 0.25f);
		}
	}

	// make_deep_sleeper
	void SkeletonBase_OnMakeDeepSleeper()
	{
		SLEEPER = true;
		DEEP_SLEEPER = true;

		SetAnimFrameRate(0);
		CallEventDelayed(0.2f, "hide_name");
		SetRoam(false);
		PLAYING_DEAD = "1";
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_RESPAWN_DEADIDLE);
			SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
		}
		if (Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_IDLE);
			SetIdleAnim(ANIM_IDLE);
		}
		SetInvincible(true);
		SetHearingSensitivity(0);
		OnNpcatkSuspendAi();
		NO_STUCK_CHECKS = "1";
		if (!DEEP_SLEEPER)
			SetHearingSensitivity(10);
	}

	// set_summon_circle2
	// from monsters/externals
	void SkeletonBase_OnSetSummonCircle2()
	{
		if (ANIM_RUN == "run")
			PlayAnim("critical", "sitstand");
		else
			PlayAnim("critical", "getup");
	}

	// skel_setup_body
	void SkeletonBase_OnSkelSetupBody()
	{
		// setmodelbody based on name (easier than going through each one, then screwing it up and having to repeat)
		// bodies
		// 0 - old default
		// 1 - bloody
		// 2 - green M
		// 3 - black armor
		// 4 - white armor
		// 5 - white brest, black hat
		// 6 - one-eye
		// 7 - frosted
		// 8 - Wassup-G
		// weapons
		// 0 - Unarmed
		// 1 - bone blade
		// 2 - double axes
		// 3 - double shields
		// 4 - sword
		MY_NAME = NameOf(ENT_ME);
		string skelName = "Skeleton Warrior"; // 0 0	monsters/skeleton
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 0);
			SetModelBody(1, 0);
		}
		skelName = "Walking Ashes"; // 6 0	monsters/skeleton2
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 6);
			SetModelBody(1, 0);
		}
		skelName = "Fragile Knight"; // 1 4	monsters/tcadaver
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 5);
			SetModelBody(1, 4);
		}
		skelName = "Ghastly Knight"; // 3 4	monsters/cadaver
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 3);
			SetModelBody(1, 4);
		}
		skelName = "Hungry Skeleton"; // 0 1	monsters/hunger
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 0);
			SetModelBody(1, 1);
		}
		skelName = "Enraged Skeleton"; // 1 2	calruin/corpse2
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 6);
			SetModelBody(1, 2);
		}
		skelName = "Awakened Guardian"; // 3 3	calruin/corpse
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 3);
			SetModelBody(1, 3);
		}
		skelName = "Living Dead"; // 6 2	calruin/livingdead
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 1);
			SetModelBody(1, 0);
		}
		skelName = "Fallen Knight"; // 4 4	calruin/undeadwarrior
		if (MY_NAME == skelName)
		{
			SetModelBody(0, 4);
			SetModelBody(1, 4);
		}
	}

	// game_heardsound
	// == Sleeper System ===========================================================
	void SkeletonBase_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!SLEEPER)
			return;
		if (DEEP_SLEEPER)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		if (!(RangeTo(ENT_LASTHEARD) < 128.0f))
			return;
		OnSkeletonWakeupCall();
	}

	// skeleton_wakeup_call
	void SkeletonBase_OnSkeletonWakeupCall()
	{
		if (!SLEEPER)
			return;
		SetName(MY_NAME);
		SetRace("undead");

		float awakeDelay = 1.5f; // give time to play getup anim
		if (Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
			OnAnimateStone();
			awakeDelay = 0.1f; // stone skeles pose as statues and do not play getup anim
		}
		if (BASE_FRAMERATE == "BASE_FRAMERATE")
			SetAnimFrameRate(1);
		if (BASE_FRAMERATE != "BASE_FRAMERATE")
			SetAnimFrameRate(Float(BASE_FRAMERATE));

		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_WALK);
			SetIdleAnim(ANIM_IDLE);
			PlayAnim("once", "getup");
		}
		CallEventDelayed(awakeDelay, "skeleton_awake");
	}

	// skeleton_awake
	void SkeletonBase_OnSkeletonAwake()
	{
		SetInvincible(false);
		SetRoam(true);
		CallEventDelayed(0.1f, "skeleton_attribs");
		SLEEPER = false;
		DEEP_SLEEPER = false;
		PLAYING_DEAD = "0";
		SetHearingSensitivity(10);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		NO_STUCK_CHECKS = "0";
		OnNpcatkResumeAi();
	}

	// game_heardsound
	void SkeletonBase_OnGameHeardsound_2(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!SLEEPER)
			return;
		if (DEEP_SLEEPER)
			return;
		if (!IsPlayer(ENT_LASTHEARD))
			return;
		if (!(RangeTo(ENT_LASTHEARD) < 128.0f))
			return;
		OnSkeletonWakeupCall();
	}

	// make_sleeper
	void SkeletonBase_OnMakeSleeper()
	{
		SLEEPER = true; // this is redundant unless called via params

		SetAnimFrameRate(0);
		CallEventDelayed(0.2f, "hide_name");
		SetRoam(false);
		PLAYING_DEAD = "1";
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_RESPAWN_DEADIDLE);
			SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
		}
		if (Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_IDLE);
			SetIdleAnim(ANIM_IDLE);
		}
		SetInvincible(true);
		SetHearingSensitivity(0);
		OnNpcatkSuspendAi();
		NO_STUCK_CHECKS = "1";
		if (!DEEP_SLEEPER)
			SetHearingSensitivity(10);
	}

	// make_deep_sleeper
	void SkeletonBase_OnMakeDeepSleeper_2()
	{
		SLEEPER = true;
		DEEP_SLEEPER = true;

		SetAnimFrameRate(0);
		CallEventDelayed(0.2f, "hide_name");
		SetRoam(false);
		PLAYING_DEAD = "1";
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_RESPAWN_DEADIDLE);
			SetIdleAnim(ANIM_RESPAWN_DEADIDLE);
		}
		if (Truthy(GetVar("STONE_SKELETON")))
		{
			SetMoveAnim(ANIM_IDLE);
			SetIdleAnim(ANIM_IDLE);
		}
		SetInvincible(true);
		SetHearingSensitivity(0);
		OnNpcatkSuspendAi();
		NO_STUCK_CHECKS = "1";
		if (!DEEP_SLEEPER)
			SetHearingSensitivity(10);
	}

	// turn_undead
	// == Turn Undead =================================================
	// rest handled by monsters/externals
	void SkeletonBase_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		SKELE_TURNED = true;
		STRUCK_HOLY = true;
		SKEL_RESPAWN_TIMES = 99.0f; // can't get up after turn_undead
	}

	// npc_death
	// == Death & Rebirth =============================================
	void SkeletonBase_OnNpcDeath()
	{
		bool noRebirth = false;

		if (Truthy(PLAYING_DEAD))
			return;

		if (SKELE_TURNED)
		{
			noRebirth = true;
			// be really nice to have some sort of disintegrate anim here
			CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);
		}

		int rndDeath = RandomInt(1, 4);
		if (rndDeath == 1)
			ANIM_DEATH = "dieheadshot2";
		if (rndDeath == 2)
			ANIM_DEATH = "diesimple";
		if (rndDeath == 3)
			ANIM_DEATH = "diebackward";
		if (rndDeath == 4)
			ANIM_DEATH = "dieforward";

		if (noRebirth)
			return;

		if (!(RandomInt(1, 100) <= Float(GetVar("SKEL_RESPAWN_CHANCE"))))
			return;
		if (!(SKEL_RESPAWN_TIMES < Float(GetVar("SKEL_RESPAWN_LIVES"))))
			return;

		SKEL_RESPAWN_TIMES += 1.0f;

		@SKEL_SLAYER = EntityOf(ENT_LASTSTRUCK);

		ANIM_DEATH = ANIM_DEATH_FAKE;
		OnSkelFakeDeath();
	}

	// skel_fake_death
	void SkeletonBase_OnSkelFakeDeath()
	{
		SetAlive(true);
		SetSolid("box");
		SetBoundingBox("npcsize");
		SetMoveDest("none");
		SetInvincible(true);
		// in case he gets put down again before he finishes getting up
		if (ANIM_RUN == ANIM_RESPAWN_DEADIDLE)
			ANIM_RUN = SK_BASE_ANIM_RUN;
		if (ANIM_WALK == ANIM_RESPAWN_DEADIDLE)
			ANIM_WALK = SK_BASE_ANIM_WALK;
		if (ANIM_IDLE == ANIM_RESPAWN_DEADIDLE)
			ANIM_IDLE = SK_BASE_ANIM_IDLE;
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_RESPAWN_DEADIDLE);
		NO_STUCK_CHECKS = "1";
		PLAYING_DEAD = "1";

		int rebirthTime = RandomInt(3, 5);
		float glowTime = rebirthTime + 1.0f;

		Effect("glow", ENT_ME, Vector3(0, 0, 0), 72, glowTime, glowTime);
		CallEventDelayed(rebirthTime, "skel_rebirth");
	}

	// skel_rebirth
	void SkeletonBase_OnSkelRebirth()
	{
		CallEventDelayed(1.0f, "skel_rebirth2");

		SetHealth(Divide(MaxHealthOf(ENT_ME), 2.0f)); // Sets max health with this cmd too, so very convenient

		NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f);
		SetSkillLevel(NPC_GIVE_EXP);

		SKELE_TEMP_DEATH = false;
	}

	// skel_rebirth2
	void SkeletonBase_OnSkelRebirth2()
	{
		SetInvincible(false);
		PlayAnim("critical", ANIM_GETUP);
		PLAYING_DEAD = "0";
		CallEventDelayed(1.0f, "npcatk_resume_movement");
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		CallEventDelayed(1.1f, "skel_rebirth3");
	}

	// skel_rebirth3
	void SkeletonBase_OnSkelRebirth3()
	{
		PlayAnim("break");
		SetMoveAnim(ANIM_RUN);

		NPC_PREV_TARGET = "unset"; // so we re-apply musak
		OnNpcatkSettarget(EntityId(SKEL_SLAYER));
	}

	// npc_struck
	// == Struck =====================================================================================
	// Hit by someone
	void SkeletonBase_OnNpcStruck(float damage = 0.0f)
	{
		if (!STRUCK_HOLY)
			PlayRandomSound(2, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
		if (STRUCK_HOLY)
			PlayRandomSound(2, 10, SOUND_HOLY_STRIKE);
		STRUCK_HOLY = false;
	}

	// attack_1
	// == Anim Events ===============================================================================
	// Deal damage
	void SkeletonBase_OnAttack12()
	{
		PlayRandomSound(1, 5, SOUND_ATTACK1, SOUND_ATTACK2, "none", "none");

		DoDamageEx(HUNT_LASTTARGET, ATTACK_HITRANGE, Random(Float(GetVar("ATTACK_DAMAGE_LOW")), Float(GetVar("ATTACK_DAMAGE_HIGH"))), ATTACK_HITCHANCE, ENT_ME, ENT_ME, "none", "slash", "dmgevent:skele_swing");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		SkeletonBase_OnTurnUndead(holyDamage, exorcist);
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
		SkeletonBase_OnNpcPostSpawn();
	}

	// set_summon_circle2
	void OnSetSummonCircle2()
	{
		MonstersExternals_OnSetSummonCircle2(); // monsters/externals
		SkeletonBase_OnSetSummonCircle2();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttack_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		SkeletonBase_OnGameHeardsound(soundType, origin, dangerRadius);
		SkeletonBase_OnGameHeardsound_2(soundType, origin, dangerRadius);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SkeletonBase_OnNpcSpawn(npc);
	}

	void OnGoGreek() { SkeletonBase_OnGoGreek(); } // go_greek
	void OnSkelGetSleeperProps() { SkeletonBase_OnSkelGetSleeperProps(); } // skel_get_sleeper_props
	void OnSkeletonAttribs() { SkeletonBase_OnSkeletonAttribs(); } // skeleton_attribs

	// make_deep_sleeper
	void OnMakeDeepSleeper()
	{
		SkeletonBase_OnMakeDeepSleeper();
		SkeletonBase_OnMakeDeepSleeper_2();
	}

	void OnSkelSetupBody() { SkeletonBase_OnSkelSetupBody(); } // skel_setup_body
	void OnSkeletonWakeupCall() { SkeletonBase_OnSkeletonWakeupCall(); } // skeleton_wakeup_call
	void OnSkeletonAwake() { SkeletonBase_OnSkeletonAwake(); } // skeleton_awake
	void OnMakeSleeper() { SkeletonBase_OnMakeSleeper(); } // make_sleeper
	void OnNpcDeath() { SkeletonBase_OnNpcDeath(); } // npc_death
	void OnSkelFakeDeath() { SkeletonBase_OnSkelFakeDeath(); } // skel_fake_death
	void OnSkelRebirth() { SkeletonBase_OnSkelRebirth(); } // skel_rebirth
	void OnSkelRebirth2() { SkeletonBase_OnSkelRebirth2(); } // skel_rebirth2
	void OnSkelRebirth3() { SkeletonBase_OnSkelRebirth3(); } // skel_rebirth3
	void OnNpcStruck(float damage = 0.0f) { SkeletonBase_OnNpcStruck(damage); } // npc_struck
	void OnAttack12() { SkeletonBase_OnAttack12(); } // attack_1
	void OnAwakeDelay() {} // AWAKE_DELAY
	void OnLRebirthTime() {} // L_REBIRTH_TIME
	void OnAnimateStone() {} // animate_stone
	void OnSkeletonSpawn() {} // skeleton_spawn

	// This file's events and timers by their .script names
	bool SkeletonBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "go_greek") { OnGoGreek(); return true; }
		if (name == "make_deep_sleeper") { OnMakeDeepSleeper(); return true; }
		if (name == "make_sleeper") { OnMakeSleeper(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "set_summon_circle2") { OnSetSummonCircle2(); return true; }
		if (name == "skel_fake_death") { OnSkelFakeDeath(); return true; }
		if (name == "skel_get_sleeper_props") { OnSkelGetSleeperProps(); return true; }
		if (name == "skel_rebirth") { OnSkelRebirth(); return true; }
		if (name == "skel_rebirth2") { OnSkelRebirth2(); return true; }
		if (name == "skel_rebirth3") { OnSkelRebirth3(); return true; }
		if (name == "skel_setup_body") { OnSkelSetupBody(); return true; }
		if (name == "skeleton_attribs") { OnSkeletonAttribs(); return true; }
		if (name == "skeleton_awake") { OnSkeletonAwake(); return true; }
		if (name == "skeleton_wakeup_call") { OnSkeletonWakeupCall(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_base"]
shared class SkeletonBaseScript : BaseMonsterScript, SkeletonBase
{
	// Variables every script that includes this file declares
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	int SKEL_HP = 0;

	// Variables declared by included files, with the value they start with in this script
	SkeletonBaseScript()
	{
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "zombie/zo_pain1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return SkeletonBase_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
