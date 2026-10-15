#pragma context server

// Converted from monsters/skeleton_archer_base.script by msc_transpiler.
// Skeleton Archers by Thothie
// Going to try avoiding using the buggy-as-hell skeleton base for this, but its gonna mean a lot more work :/

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SkeletonArcherBase
{
	// Constants
	string ANIM_ARROW = "shootarrow";
	string ANIM_SWIPE = "attack1";
	string ANIM_DEATH_IDLE = "dead_on_stomach";
	string ANIM_REBIRTH = "getup";
	string ANIM_SIT_IDLE = "sitidle";
	string ANIM_SIT_STAND = "sitstand";
	bool CUSTOM_TURN_UNDEAD = true;
	Vector3 SKELE_ARROW_OFS = Vector3();
	int DMG_ARROW = 5;
	string DMG_SWIPE = "3";
	int SWIPE_RANGE = 70;
	int SWIPE_HITRANGE = 120;
	int SKELE_ARROW_RANGE = 1024;
	string SKELE_ARROW_SCRIPT = "proj_arrow_npc_dyn";
	int SKELE_ARROW_SPEED = 800;
	string ATTACK_HITCHANCE = "70%";
	int SKELE_START_LIVES = 0;
	int C_SKELE_PUSH_STRENGTH = 200;
	int SKELE_HEARING = 10;
	int MIDX_SHOW_ARROW = 11;
	int MIDX_HIDE_ARROW = 10;
	string SOUND_STRETCH = "monsters/archer/stretch.wav";
	string SOUND_SHOOT = "monsters/archer/bow.wav";
	string SOUND_SWIPE = "zombie/claw_miss1.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_DEATH = "zombie/zo_pain1.wav";
	string SOUND_TURNED1 = "ambience/the_horror1.wav";
	string SOUND_TURNED2 = "ambience/the_horror2.wav";
	string SOUND_TURNED3 = "ambience/the_horror3.wav";
	string SOUND_TURNED4 = "ambience/the_horror4.wav";
	string SOUND_HOLY_STRIKE = "doors/aliendoor1.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_RUN = "run";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string NPC_RANGED = "NPC_RANGED";
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	int DROP_GOLD = 0;
	bool AM_SKELETON = false;
	float SKELE_COF_A = 0.0f;
	float SKELE_COF_B = 0.0f;
	float SKELE_MISS_COUNT = 0.0f;
	float SKELE_LIVES = 0.0f;
	string SKELE_DEFAULT_ANIM_WALK = "SKELE_DEFAULT_ANIM_WALK";
	string SKELE_DEFAULT_ANIM_RUN = "SKELE_DEFAULT_ANIM_RUN";
	string SKELE_DEFAULT_ANIM_IDLE = "SKELE_DEFAULT_ANIM_IDLE";
	float DROP_GOLD_AMT = 0.0f;
	bool SKELE_BASE_ROAM = false;
	string SKELE_TARGET_LIST = "SKELE_TARGET_LIST";
	float BASE_MOVESPEED = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool AM_TURRET = false;
	bool NPC_IS_TURRET = false;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROXACT_IFSEEN = false;
	bool NPC_PROX_ACTIVATE = false;
	string NPC_PROXACT_RANGE = "NPC_PROXACT_RANGE";
	string NPC_PROXACT_EVENT = "NPC_PROXACT_EVENT";
	bool NPC_PROXACT_FOV = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	int NPC_PROXACT_CONE = 0;
	float AS_ATTACKING = 0.0f;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	bool SKELE_FIRST_RAISE = false;
	string SKELE_ORG_NAME = "SKELE_ORG_NAME";
	bool SKELE_STRUCK_BY_TURN_UNDEAD = false;
	bool SKELE_TURN_UNDEAD_SOUND = false;
	string SKELE_REBIRTH_SCAN = "SKELE_REBIRTH_SCAN";
	bool SKELE_CANT_GET_UP = false;
	bool SKELE_REALLY_CANT_GET_UP = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	int SKELE_ARROW_KNOCKBACK = 0;
	int SKELE_PUSH_STRENGTH = 0;
	bool SKELE_ARROW_NOPUSHIE = false;
	bool SKELE_PUNCH_NOPUSHIE = false;

	// unnamed block (first think)
	// weird arse sh*t going on here with missing anim vars, so sharing the anims
	void SkeletonArcherBase_FirstThink()
	{
		// base anims
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		ANIM_ATTACK = "shootarrow";
		ANIM_DEATH = "dieforward";
	}

	// unnamed block (first think)
	void SkeletonArcherBase_FirstThink2()
	{
		// base stats
		NPC_RANGED = "1";
		ATTACK_MOVERANGE = 512.0f;
		ATTACK_RANGE = 1024.0f;
		ATTACK_HITRANGE = 1024.0f;
		DROP_GOLD = 1;
		AM_SKELETON = true;
		SKELE_COF_A = 0.0f;
		SKELE_COF_B = 1.0f;
	}

	// npc_spawn
	// ================================================================================ Initiate
	void SkeletonArcherBase_OnNpcSpawn(string npc = "")
	{
		SetModel("monsters/skeleton_boss1.mdl");

		OnSkeletonAttribs();
		OnSkeleSpawn();

		SetRoam(true);
		SetHearingSensitivity(SKELE_HEARING);
		SetBlood("none");
		SetRace("undead");

		SKELE_MISS_COUNT = 0.0f;
		SKELE_LIVES = SKELE_START_LIVES;

		SKELE_DEFAULT_ANIM_WALK = ANIM_WALK;
		SKELE_DEFAULT_ANIM_RUN = ANIM_RUN;
		SKELE_DEFAULT_ANIM_IDLE = ANIM_IDLE;

		DROP_GOLD_AMT = SKELE_GOLD;

		SKELE_BASE_ROAM = true;

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		CBaseEntity@ sleeperType = FindByName("skels_sleep");
		CBaseEntity@ sleeperId = sleeperType;
		if (IsAlive(sleeperId))
			OnMakeSleeper();

		@sleeperType = FindByName("skels_deep_sleep");
		@sleeperId = sleeperType;
		if (IsAlive(sleeperId))
			OnMakeDeepSleeper();
	}

	// skeleton_attribs
	void SkeletonArcherBase_OnSkeletonAttribs()
	{
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetDamageTaken("slash", 0.7f);
			SetDamageTaken("pierce", 0.5f);
			SetDamageTaken("blunt", 1.2f);
			SetDamageTaken("fire", 1.25f);
			SetDamageTaken("holy", 1.5f);
			SetDamageTaken("cold", 0.1f);
			SetDamageTaken("poison", 0);
		}
		else
		{
			SetDamageTaken("all", 0.5f);
			SetDamageTaken("holy", 1.5f);
			SetDamageTaken("poison", 0);
			SetDamageTaken("cold", 0.1f);
		}
	}

	// npc_selectattack
	// ============================================================================ Attack Range
	void SkeletonArcherBase_OnNpcSelectattack()
	{
		if (RangeTo(NPCATK_TARGET) < SWIPE_RANGE)
			ANIM_ATTACK = ANIM_SWIPE;
		else
			ANIM_ATTACK = ANIM_ARROW;
	}

	// attack_1
	// ======================================================================== Animation Events
	// swipe attack
	void SkeletonArcherBase_OnAttack12()
	{
		PlayRandomSound(0, 5, SOUND_SWIPE);
		DoDamage(NPCATK_TARGET, SWIPE_HITRANGE, DMG_SWIPE, ATTACK_HITCHANCE);

		if (!(SKELE_PUSH_STRENGTH > 0))
			return;
		if (SKELE_PUNCH_NOPUSHIE)
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, SKELE_PUSH_STRENGTH, 110)));
	}

	// frame_grab_arrow
	void SkeletonArcherBase_OnFrameGrabArrow()
	{
		SetModelBody(1, MIDX_SHOW_ARROW);
	}

	// frame_draw_bow
	void SkeletonArcherBase_OnFrameDrawBow()
	{
		PlaySound(0, 10, SOUND_STRETCH);
	}

	// frame_shoot_bow
	void SkeletonArcherBase_OnFrameShootBow()
	{
		Vector3 pos;
		PlaySound(2, 10, SOUND_SHOOT);
		SetModelBody(1, MIDX_HIDE_ARROW);
		SKELE_MISS_COUNT += 1.0f;

		if (!Truthy(GetVar("SKELE_ARROW_ARC")))
		{
			// dis skele aint got no bbox!
			pos = OriginOf(ENT_ME) + RelativePosition(AnglesOf(ENT_ME), SKELE_ARROW_OFS);

			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile(SKELE_ARROW_SCRIPT, pos, NPCATK_TARGET, SKELE_ARROW_SPEED, DMG_ARROW, SKELE_COF_A, "none");
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0, GetVar("SKELE_ARROW_GLOW"), GetVar("SKELE_ARROW_GLOW_COLOR"));
		}
		else
		{
			Vector3 targOrg = OriginOf(NPCATK_TARGET);
			if (Float(GetVar("SKELE_ARROW_AOE")) > 0.0f)
			{
				// for AOE arrows, shoot around the target randomly
				float halfAoe = Float(GetVar("SKELE_ARROW_AOE"));
				halfAoe = Divide(halfAoe, 2.0f);
				targOrg += RelativePosition(Vector3(0, Random(0, 359.99f), 0), Vector3(0, halfAoe, 0));
			}
			if (!IsPlayer(Text(targOrg)))
				targOrg.z += HeightOf(NPCATK_TARGET);
			float targDist = Divide(Distance(targOrg, MyOrigin()), 25.0f);
			SetAngle("add_view.pitch", targDist);

			// dis skele aint got no bbox!
			pos = OriginOf(ENT_ME) + RelativePosition(AnglesOf(ENT_ME), SKELE_ARROW_OFS);

			TossProjectile(SKELE_ARROW_SCRIPT, pos, "none", SKELE_ARROW_SPEED, DMG_ARROW, SKELE_COF_B, "none");
			float gravAdj = 0.4f;
			// don't think this is working (also logic is likely plain wrong)
			// if ( $vec.z(TARG_ORG) < game.monster.origin.z )
			// {
			// local ADJ_RATIO $vec.z(TARG_ORG)
			// divide ADJ_RATIO game.monster.origin.z
			// local GRAV_ADJ $get_skill_ratio(ADJ_RATIO,0.4,2.0)
			// dbg adjusting down GRAV_ADJ ( ADJ_RATIO )
			// }
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", gravAdj, GetVar("SKELE_ARROW_GLOW"), GetVar("SKELE_ARROW_GLOW_COLOR"));
		}

		// dbg frame_shoot_bow SKELE_MISS_COUNT
		if (SKELE_MISS_COUNT > 4.0f)
		{
			// if you miss a bunch, twitch a bit in hopes for a better angle
			if (!AM_TURRET)
			{
				SKELE_MISS_COUNT = 2.0f;
				PlayAnim("break");
				OnChickenRun(1.5f);
			}
			else
			{
				SKELE_COF_A += 1.0f;
				SKELE_COF_B += 2.0f;
			}
		}
	}

	// game_dodamage
	// ======================================================================== Damage Modifiers
	string SkeletonArcherBase_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (IsAlive(target) && RelationshipOf(target, ENT_ME) == "enemy")
		{
			SKELE_MISS_COUNT = 0.0f;
			if (AM_TURRET)
			{
				SKELE_COF_A = 0.0f;
				SKELE_COF_B = 1.0f;
			}
		}
		return result;
	}

	// ext_arrow_hit
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) - called from proj_arrow_npc_dyn
	void SkeletonArcherBase_OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3())
	{
		bool hitEnemy = false;
		int count;

		// dbg ext_arrow_hit hit: PARAM1 targ: $get(PARAM2,name) start: PARAM3 end: PARAM4
		bool targAlive = IsAlive(hitEntity);
		if (RelationshipOf(hitEntity, ENT_ME) == "enemy" && targAlive)
			hitEnemy = true;

		if (SKELE_ARROW_KNOCKBACK > 0 && !SKELE_ARROW_NOPUSHIE && hitEnemy)
			AddVelocity(hitEntity, RelativeVelocity(Vector3(0, SKELE_ARROW_KNOCKBACK, 110)));

		if (GetVar("SKELE_ARROW_EFFECT") != "SKELE_ARROW_EFFECT" && hitEnemy && Truthy(hit))
		{
			if (!Truthy(GetVar("SKELE_ARROW_EFFECT_HANDLED")))
			{
				ApplyEffect(hitEntity, GetVar("SKELE_ARROW_EFFECT"), GetVar("SKELE_DOT_DUR"), self, GetVar("SKELE_DOT_DMG"));
			}
			else
			{
				CBaseEntity@ outTarg = hitEntity;
				OnSkeleHandleEffect(outTarg);
			}
		}

		if (Float(GetVar("SKELE_ARROW_AOE")) > 0.0f)
		{
			Vector3 arrowPos = startPosition;
			if (hitEnemy)
				arrowPos = OriginOf(hitEntity);
			arrowPos.z = GroundHeight(arrowPos);
			OnSkeleArrowFx(Text(arrowPos)); // handle client effects in top script
			SKELE_TARGET_LIST = LegacyFunction("get_tsphere", "enemy", GetVar("SKELE_ARROW_AOE"), arrowPos);
			if (SKELE_TARGET_LIST != "none")
			{
				count = GetTokenCount(SKELE_TARGET_LIST);
				for (int i = 0; i < count; i++)
				{
					loopIteration = i;
					OnSkeleAffectTargets();
				}
			}
		}
	}

	// skele_affect_targets
	void SkeletonArcherBase_OnSkeleAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SKELE_TARGET_LIST, loopIteration));
		ApplyEffect(curTarg, GetVar("SKELE_ARROW_EFFECT"), GetVar("SKELE_DOT_DUR"), self, GetVar("SKELE_DOT_DMG"));
		SKELE_MISS_COUNT = 0.0f;
	}

	// set_turret
	// ============================================================================== Add Params
	void SkeletonArcherBase_OnSetTurret()
	{
		SetMoveSpeed(0);
		BASE_MOVESPEED = 0.0f;
		SetMoveAnim(ANIM_IDLE);
		SetRoam(false);
		SKELE_BASE_ROAM = false;
		NO_STUCK_CHECKS = "1";
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		SKELE_DEFAULT_ANIM_WALK = ANIM_IDLE;
		SKELE_DEFAULT_ANIM_RUN = ANIM_IDLE;
		AM_TURRET = true;
		NPC_IS_TURRET = true;
		CallEventDelayed(0.1f, "set_turret2");
	}

	// set_turret2
	void SkeletonArcherBase_OnSetTurret2()
	{
		// enforcer - it's either the weirdness of xetvar or something getting reset somewhere
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		SetMoveAnim(ANIM_IDLE);
	}

	// set_no_fake_death
	// additional parameter
	void SkeletonArcherBase_OnSetNoFakeDeath()
	{
		SKELE_LIVES = 1.0f;
	}

	// set_rebirths
	// <#lives> //additional parameter
	void SkeletonArcherBase_OnSetRebirths(float lives = 0.0f)
	{
		SKELE_LIVES = lives + 1.0f;
	}

	// skeleton_wakeup_call
	// ms_npcscript event - wake up all sleeping skeles
	void SkeletonArcherBase_OnSkeletonWakeupCall()
	{
		OnSkeletonWakeUp();
	}

	// make_sleeper
	// additional parameter - play dead until player near
	void SkeletonArcherBase_OnMakeSleeper()
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		SetInvincible(true);
		SetMoveDest("none");
		OnNpcatkSuspendAi();
		NPC_PROXACT_TRIPPED = false;
		NPC_PROXACT_IFSEEN = false;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "128";
		NPC_PROXACT_EVENT = "skeleton_wake_up";
		NPC_PROXACT_FOV = false;
		PLAYING_DEAD = "1";

		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetSolid("none");
			SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
			SetIdleAnim(ANIM_DEATH_IDLE);
			SetMoveAnim(ANIM_DEATH_IDLE);
			PlayAnim("critical", ANIM_DEATH_IDLE);
		}
		else
		{
			OnSkeleStoneSleep();
		}
	}

	// make_sitter
	// additional paramter - sit until player near
	void SkeletonArcherBase_OnMakeSitter()
	{
		SetHearingSensitivity(0);
		SetRoam(false);
		SetMoveDest("none");
		NPC_PROXACT_TRIPPED = false;
		NPC_PROXACT_IFSEEN = false;
		NPC_PROX_ACTIVATE = true;
		NPC_PROXACT_RANGE = "128";
		NPC_PROXACT_EVENT = "skeleton_sit_up";
		NPC_PROXACT_FOV = true;
		NPC_PROXACT_CONE = 90;
		SetIdleAnim(ANIM_SIT_IDLE);
		SetMoveAnim(ANIM_SIT_IDLE);
		PlayAnim("critical", ANIM_SIT_IDLE);
		OnNpcatkSuspendAi();
	}

	// skeleton_sit_up
	void SkeletonArcherBase_OnSkeletonSitUp()
	{
		NPC_PROXACT_TRIPPED = true;
		PlayAnim("critical", ANIM_SIT_STAND);
		SetHearingSensitivity(SKELE_HEARING);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		SetRoam(SKELE_BASE_ROAM);
		AS_ATTACKING = GameTime();

		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		CallEventDelayed(1.1f, "skele_target_disturber");
	}

	// skele_target_disturber
	void SkeletonArcherBase_OnSkeleTargetDisturber()
	{
		if (!IsAlive(NPC_PROXACT_PLAYERID))
			return;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkSettarget(EntityId(NPC_PROXACT_PLAYERID));
		@NPC_PROXACT_PLAYERID = null;
	}

	// skeleton_wake_up
	void SkeletonArcherBase_OnSkeletonWakeUp()
	{
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SKELE_FIRST_RAISE = true;
			OnSkeleRebirth();
		}
		else
		{
			SetHearingSensitivity(SKELE_HEARING);
			ANIM_RUN = SKELE_DEFAULT_ANIM_RUN;
			ANIM_WALK = SKELE_DEFAULT_ANIM_WALK;
			ANIM_IDLE = SKELE_DEFAULT_ANIM_IDLE;
			SetMoveAnim(ANIM_IDLE);
			SetIdleAnim(ANIM_WALK);
			SetInvincible(false);
			PLAYING_DEAD = "0";
			if (BASE_FRAMERATE == "BASE_FRAMERATE")
				SetAnimFrameRate(1);
			else
				SetAnimFrameRate(Float(BASE_FRAMERATE));
			SetRoam(SKELE_BASE_ROAM);
			OnNpcatkResumeAi();
			OnSkeleRefreshName();
			DebugPrint("Stone Skeleton Awaken ( " + NameOf(NPC_PROXACT_PLAYERID) + " )");

			if (IsAlive(NPC_PROXACT_PLAYERID))
				CallEventDelayed(1.1f, "skele_target_disturber");
		}
	}

	// skele_hide_name
	void SkeletonArcherBase_OnSkeleHideName()
	{
		SKELE_ORG_NAME = Eval("game.monster.name.full");
		SetRace("none");
		SetName("");
	}

	// skele_refresh_name
	void SkeletonArcherBase_OnSkeleRefreshName()
	{
		if (SKELE_ORG_NAME != "SKELE_ORG_NAME")
		{
			SetName(SKELE_ORG_NAME);
			SetRace("undead");
		}
	}

	// make_deep_sleeper
	// additional paramater - play dead until awakened via event
	void SkeletonArcherBase_OnMakeDeepSleeper()
	{
		if (!Truthy(GetVar("STONE_SKELETON")))
		{
			SetHearingSensitivity(0);
			SetRoam(false);
			PLAYING_DEAD = "1";
			SetSolid("none");
			SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
			SetMoveDest("none");
			SKELE_FIRST_RAISE = true;
			SetIdleAnim(ANIM_DEATH_IDLE);
			SetMoveAnim(ANIM_DEATH_IDLE);
			PlayAnim("critical", ANIM_DEATH_IDLE);
			OnNpcatkSuspendAi();
		}
		else
		{
			OnSkeleStoneSleep();
		}
		SetInvincible(true);
	}

	// skele_stone_sleep
	void SkeletonArcherBase_OnSkeleStoneSleep()
	{
		SetHearingSensitivity(0);
		PLAYING_DEAD = "1";
		OnSkeleHideName();
		ANIM_RUN = ANIM_IDLE;
		ANIM_WALK = ANIM_IDLE;
		SetMoveAnim(ANIM_IDLE);
		SetIdleAnim(ANIM_IDLE);
		SetAnimFrameRate(0);
		SetInvincible(true);
		SetRoam(false);
		OnNpcatkSuspendAi();
		PlayAnim("hold", ANIM_IDLE);
		SetMoveDest("none");
	}

	// turn_undead
	// ============================================================================= Turn Undead
	// <dmg> <attacker>
	void SkeletonArcherBase_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		if (!IsAlive(ENT_ME))
			return;
		if (Truthy(PLAYING_DEAD))
			return;

		SKELE_LIVES = 0.0f;
		SKELE_STRUCK_BY_TURN_UNDEAD = true;
		SKELE_TURN_UNDEAD_SOUND = true;

		float casterFaith = SkillOf(exorcist, "spellcasting.divination");

		DoDamageEx(self, "direct", holyDamage, 100, @exorcist, @exorcist, "spellcasting.divination", "holy");
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 512, 1, 1);

		float percentHealthLeft = Divide(HealthOf(ENT_ME), MaxHealthOf(ENT_ME)) * 100.0f;

		if (!(casterFaith > percentHealthLeft))
			return;

		if (IS_FLEEING)
			return;

		// Minimum Turn Duration 5 seconds, max 20
		float turnDuration = SkillOf("THE_EXCORCIST", "spellcasting.divination");
		if (turnDuration < 5.0f)
			turnDuration = 5.0f;
		if (turnDuration > 15.0f)
			turnDuration = 15.0f;

		PlayRandomSound(1, 10, SOUND_TURNED1, SOUND_TURNED2, SOUND_TURNED3, SOUND_TURNED4);
		OnNpcatkFlee(EntityId(exorcist), "1024", Text(turnDuration));
	}

	// game_struck
	void SkeletonArcherBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (SKELE_TURN_UNDEAD_SOUND)
		{
			SKELE_TURN_UNDEAD_SOUND = false;
			PlayRandomSound(0, 10, SOUND_HOLY_STRIKE);
		}
		else
		{
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		}
	}

	// npc_death
	// ========================================================================= Death & Rebirth
	void SkeletonArcherBase_OnNpcDeath()
	{
		// this has to be handled special, as otherwise he'll drop a container every time he dies, if he has multiple lives
		if (SKELE_LIVES <= 1.0f && Truthy(GetVar("SKELE_DROPS_CONTAINER")) && RandomInt(1, 100) <= Float(GetVar("SKELE_DROPS_CONTAINER_CHANCE")))
			CreateNpc(GetVar("SKELE_CONTAINER_SCRIPT"), RelativePosition(Vector3(0, 0, 0)), "CONTAINER_PARAM1", "CONTAINER_PARAM2", "CONTAINER_PARAM3", "CONTAINER_PARAM4");

		if (SKELE_STRUCK_BY_TURN_UNDEAD)
			return;
		if (!(SKELE_LIVES > 1.0f))
			return;
		SetRace("undead"); // in case was killed by slay command (sets hated)
		SKELE_LIVES -= 1.0f;
		PLAYING_DEAD = "1";
		SetHearingSensitivity(0);
		SetSolid("none");
		SetBoundingBox(Vector3(0, 0, 0), Vector3(0, 0, 0));
		SetInvincible(true);
		SetMoveDest("none");
		ANIM_RUN = ANIM_DEATH_IDLE;
		ANIM_WALK = ANIM_DEATH_IDLE;
		ANIM_IDLE = ANIM_DEATH_IDLE;
		SetIdleAnim(ANIM_DEATH_IDLE);
		SetMoveAnim(ANIM_DEATH_IDLE);
		SetAlive(true);
		OnNpcatkSuspendAi();
		SetRoam(false);
		CallEventDelayed(RandomInt(5, 15), "skele_rebirth_check");
	}

	// skele_rebirth_check
	void SkeletonArcherBase_OnSkeleRebirthCheck()
	{
		int count;
		SKELE_REBIRTH_SCAN = FindInSphere("any", 96);

		if (SKELE_REBIRTH_SCAN != "none")
		{
			SKELE_CANT_GET_UP = true;
			SKELE_REALLY_CANT_GET_UP = false;
			count = GetTokenCount("MUMMY_REBIRTH_SCAN");
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnSkeleRebirthScanLoop();
			}
		}

		if (SKELE_REBIRTH_SCAN == "none")
			SKELE_CANT_GET_UP = false;

		if (SKELE_CANT_GET_UP)
			CallEventDelayed(1.0f, "skele_rebirth_check");
		else
			OnSkeleRebirth();
	}

	// skele_rebirth_scan_loop
	void SkeletonArcherBase_OnSkeleRebirthScanLoop()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SKELE_REBIRTH_SCAN, loopIteration));
		if (Contains(ItemNameOf(curTarg), "skeleton_archer"))
		{
			// this maybe another arhcer also trying to get up
			if (Truthy(ScriptVarOf(curTarg, "PLAYING_DEAD")))
			{
				// it is, get up, but hold all other dead zombies down a bit
				if (GameTime() > Float(GetVar("G_SKELE_NEXT_REBIRTH")))
				{
					SetGlobal("G_SKELE_NEXT_REBIRTH", GameTime());
					LegacyCommand("add", "G_SKELE_NEXT_REBIRTH", 5.0f);
					SKELE_CANT_GET_UP = false;
					DebugPrint("can get up " + Text(GameTime()) + " vs. " + GetVar("G_SKELE_NEXT_REBIRTH"));
				}
			}
			else
			{
				SKELE_CANT_GET_UP = true;
				SKELE_REALLY_CANT_GET_UP = true;
				DebugPrint("can't get up - friend not playing dead");
			}
		}
		else
		{
			SKELE_CANT_GET_UP = true;
			SKELE_REALLY_CANT_GET_UP = true; // this is in case I see a player earlier in the scan, but a dead friend later, and think I can get up
			DebugPrint("can't get up - non-skelearcher nearby");
		}
	}

	// skele_rebirth
	void SkeletonArcherBase_OnSkeleRebirth()
	{
		SetSolid("box");
		SetBoundingBox("npcsize");
		SetHealth(MaxHealthOf(ENT_ME));

		if (!SKELE_FIRST_RAISE)
		{
			NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f);
			SetSkillLevel(NPC_GIVE_EXP);
		}

		SKELE_FIRST_RAISE = false; // in case skele playing dead on spawn
		SetHearingSensitivity(SKELE_HEARING);

		PLAYING_DEAD = "0";
		CallEventDelayed(1.0f, "skele_rebirth2");
	}

	// skele_rebirth2
	void SkeletonArcherBase_OnSkeleRebirth2()
	{
		SetInvincible(false);
		ANIM_RUN = SKELE_DEFAULT_ANIM_RUN;
		ANIM_WALK = SKELE_DEFAULT_ANIM_WALK;
		ANIM_IDLE = SKELE_DEFAULT_ANIM_IDLE;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_REBIRTH);
		CallEventDelayed(1.0f, "npcatk_resume_ai");
		CallEventDelayed(1.1f, "skele_rebirth3");
	}

	// skele_rebirth3
	void SkeletonArcherBase_OnSkeleRebirth3()
	{
		SetRoam(SKELE_BASE_ROAM);
		NPC_PREV_TARGET = "unset"; // so we re-apply musak
		OnSkeleTargetDisturber(); // in case skele playing dead on spawn
	}

	// ext_setmodelbody
	// =============================================================================== Debuggary
	// debuggary
	void SkeletonArcherBase_OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0)
	{
		SetModelBody(bodyGroup, submodel);
	}

	// set_pushamt
	// { game_dynamically_created //debuggary (not setup for summon)
	// if G_DEVELOPER_MODE
	// if ( PARAM1 startswith 'PARAM' ) local EXIT_SUB 1
	// if !EXIT_SUB
	// setvard NPC_DO_EVENTS PARAM1
	// calleventloop $get_token_amt(NPC_DO_EVENTS) npcatk_do_events
	// }
	void SkeletonArcherBase_OnSetPushamt(int pushAmount = 0)
	{
		SKELE_ARROW_KNOCKBACK = pushAmount;
		SKELE_PUSH_STRENGTH = pushAmount;
		DebugPrint("set_pushamt " + pushAmount + " [ " + SKELE_ARROW_KNOCKBACK + " " + SKELE_PUSH_STRENGTH + " ]");
	}

	// set_np
	void SkeletonArcherBase_OnSetNp()
	{
		SKELE_ARROW_KNOCKBACK = -1;
		SKELE_PUSH_STRENGTH = -1;
		DebugPrint("set_np " + SKELE_ARROW_KNOCKBACK + " " + SKELE_PUSH_STRENGTH);
		SKELE_ARROW_NOPUSHIE = true;
		SKELE_PUNCH_NOPUSHIE = true;
	}

	// dbg_kb
	void SkeletonArcherBase_OnDbgKb()
	{
		DebugPrint("set_np " + SKELE_ARROW_KNOCKBACK + " " + SKELE_PUSH_STRENGTH);
	}

	// unnamed block (first think)
	void SkeletonArcherBase_FirstThink3()
	{
		// undoing const_ovrd
		SKELE_ARROW_KNOCKBACK = Int(GetVar("C_SKELE_ARROW_KNOCKBACK"));
		SKELE_PUSH_STRENGTH = C_SKELE_PUSH_STRENGTH;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals
		SkeletonArcherBase_OnTurnUndead(holyDamage, exorcist);
	}

	// ext_setmodelbody
	void OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0)
	{
		MonstersExternals_OnExtSetmodelbody(bodyGroup, submodel); // monsters/externals
		SkeletonArcherBase_OnExtSetmodelbody(bodyGroup, submodel);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SkeletonArcherBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SkeletonArcherBase_OnNpcSpawn(npc);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, SkeletonArcherBase_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		SkeletonArcherBase_OnNpcSelectattack();
	}

	void OnSkeletonAttribs() { SkeletonArcherBase_OnSkeletonAttribs(); } // skeleton_attribs
	void OnAttack12() { SkeletonArcherBase_OnAttack12(); } // attack_1
	void OnFrameGrabArrow() { SkeletonArcherBase_OnFrameGrabArrow(); } // frame_grab_arrow
	void OnFrameDrawBow() { SkeletonArcherBase_OnFrameDrawBow(); } // frame_draw_bow
	void OnFrameShootBow() { SkeletonArcherBase_OnFrameShootBow(); } // frame_shoot_bow
	void OnExtArrowHit(string hit = "", CBaseEntity@ hitEntity = null, Vector3 startPosition = Vector3()) { SkeletonArcherBase_OnExtArrowHit(hit, hitEntity, startPosition); } // ext_arrow_hit
	void OnSkeleAffectTargets() { SkeletonArcherBase_OnSkeleAffectTargets(); } // skele_affect_targets
	void OnSetTurret() { SkeletonArcherBase_OnSetTurret(); } // set_turret
	void OnSetTurret2() { SkeletonArcherBase_OnSetTurret2(); } // set_turret2
	void OnSetNoFakeDeath() { SkeletonArcherBase_OnSetNoFakeDeath(); } // set_no_fake_death
	void OnSetRebirths(float lives = 0.0f) { SkeletonArcherBase_OnSetRebirths(lives); } // set_rebirths
	void OnSkeletonWakeupCall() { SkeletonArcherBase_OnSkeletonWakeupCall(); } // skeleton_wakeup_call
	void OnMakeSleeper() { SkeletonArcherBase_OnMakeSleeper(); } // make_sleeper
	void OnMakeSitter() { SkeletonArcherBase_OnMakeSitter(); } // make_sitter
	void OnSkeletonSitUp() { SkeletonArcherBase_OnSkeletonSitUp(); } // skeleton_sit_up
	void OnSkeleTargetDisturber() { SkeletonArcherBase_OnSkeleTargetDisturber(); } // skele_target_disturber
	void OnSkeletonWakeUp() { SkeletonArcherBase_OnSkeletonWakeUp(); } // skeleton_wake_up
	void OnSkeleHideName() { SkeletonArcherBase_OnSkeleHideName(); } // skele_hide_name
	void OnSkeleRefreshName() { SkeletonArcherBase_OnSkeleRefreshName(); } // skele_refresh_name
	void OnMakeDeepSleeper() { SkeletonArcherBase_OnMakeDeepSleeper(); } // make_deep_sleeper
	void OnSkeleStoneSleep() { SkeletonArcherBase_OnSkeleStoneSleep(); } // skele_stone_sleep
	void OnNpcDeath() { SkeletonArcherBase_OnNpcDeath(); } // npc_death
	void OnSkeleRebirthCheck() { SkeletonArcherBase_OnSkeleRebirthCheck(); } // skele_rebirth_check
	void OnSkeleRebirthScanLoop() { SkeletonArcherBase_OnSkeleRebirthScanLoop(); } // skele_rebirth_scan_loop
	void OnSkeleRebirth() { SkeletonArcherBase_OnSkeleRebirth(); } // skele_rebirth
	void OnSkeleRebirth2() { SkeletonArcherBase_OnSkeleRebirth2(); } // skele_rebirth2
	void OnSkeleRebirth3() { SkeletonArcherBase_OnSkeleRebirth3(); } // skele_rebirth3
	void OnSetPushamt(int pushAmount = 0) { SkeletonArcherBase_OnSetPushamt(pushAmount); } // set_pushamt
	void OnSetNp() { SkeletonArcherBase_OnSetNp(); } // set_np
	void OnDbgKb() { SkeletonArcherBase_OnDbgKb(); } // dbg_kb
	void OnSkeleArrowFx(string arrowOrigin = "") {} // skele_arrow_fx
	void OnSkeleHandleEffect(CBaseEntity@ target = null) {} // skele_handle_effect
	void OnSkeleSpawn() {} // skele_spawn

	// This file's events and timers by their .script names
	bool SkeletonArcherBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "dbg_kb") { OnDbgKb(); return true; }
		if (name == "ext_arrow_hit") { OnExtArrowHit(Param(params, 0), EntityParam(params, 1), Vec(Param(params, 2))); return true; }
		if (name == "ext_setmodelbody") { OnExtSetmodelbody(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "frame_draw_bow") { OnFrameDrawBow(); return true; }
		if (name == "frame_grab_arrow") { OnFrameGrabArrow(); return true; }
		if (name == "frame_shoot_bow") { OnFrameShootBow(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "make_deep_sleeper") { OnMakeDeepSleeper(); return true; }
		if (name == "make_sitter") { OnMakeSitter(); return true; }
		if (name == "make_sleeper") { OnMakeSleeper(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "set_no_fake_death") { OnSetNoFakeDeath(); return true; }
		if (name == "set_np") { OnSetNp(); return true; }
		if (name == "set_pushamt") { OnSetPushamt(Int(Param(params, 0))); return true; }
		if (name == "set_rebirths") { OnSetRebirths(Float(Param(params, 0))); return true; }
		if (name == "set_turret") { OnSetTurret(); return true; }
		if (name == "set_turret2") { OnSetTurret2(); return true; }
		if (name == "skele_affect_targets") { OnSkeleAffectTargets(); return true; }
		if (name == "skele_hide_name") { OnSkeleHideName(); return true; }
		if (name == "skele_rebirth") { OnSkeleRebirth(); return true; }
		if (name == "skele_rebirth2") { OnSkeleRebirth2(); return true; }
		if (name == "skele_rebirth3") { OnSkeleRebirth3(); return true; }
		if (name == "skele_rebirth_check") { OnSkeleRebirthCheck(); return true; }
		if (name == "skele_rebirth_scan_loop") { OnSkeleRebirthScanLoop(); return true; }
		if (name == "skele_refresh_name") { OnSkeleRefreshName(); return true; }
		if (name == "skele_stone_sleep") { OnSkeleStoneSleep(); return true; }
		if (name == "skele_target_disturber") { OnSkeleTargetDisturber(); return true; }
		if (name == "skeleton_attribs") { OnSkeletonAttribs(); return true; }
		if (name == "skeleton_sit_up") { OnSkeletonSitUp(); return true; }
		if (name == "skeleton_wake_up") { OnSkeletonWakeUp(); return true; }
		if (name == "skeleton_wakeup_call") { OnSkeletonWakeupCall(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/skeleton_archer_base"]
shared class SkeletonArcherBaseScript : BaseMonsterNewScript, SkeletonArcherBase
{
	// Variables every script that includes this file declares
	int SKELE_GOLD = 0;

	// Variables declared by included files, with the value they start with in this script
	SkeletonArcherBaseScript()
	{
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		ANIM_RUN = "run";
		SOUND_DEATH = "zombie/zo_pain1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/skeleton_boss1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkeletonArcherBase_FirstThink();
		SkeletonArcherBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SkeletonArcherBase_FirstThink3();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SkeletonArcherBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
