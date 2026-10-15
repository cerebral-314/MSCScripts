#pragma context server

// Converted from slithar/slithar.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// Slithar, the Necromancer's Apprentice by Thothie from scratch
// - Summons highly poisonus snakes (up to 5 active)
// - Summons poisoned bone series (random, 1 active)
// - Poisoned staff
// - Jumps away periodically / when heavily damaged

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class Slithar
{
	// Constants
	float NPC_BOSS_RESTORATION = 1.0f;
	float JUMP_FREQ = 3.0f;
	string ANIM_CRAWL = "crawl";
	string ANIM_SEARCH = "looK_idle";
	string ANIM_HOP = "jump";
	string ANIM_JUMP = "long_jump";
	int JUMP_AWAY_RANGE = 160;
	int ANIM_MOVERANGE = 30;
	int ANIM_HITRANGE = 120;
	int ANIM_RANGE = 80;
	string ATTACK_HITCHANCE = "80%";
	string ANIM_SUMMON = "cast_serpentstaff";
	string STAFF_DAMAGE = "$rand(10,30)";
	string POISON_DAMAGE = "$randf(20,30)";
	string POISON_DURATION = "$randf(3,8)";
	string SKELETON_SCRIPT = "monsters/skeleton_poison_random";
	string SNAKE_SCRIPT = "monsters/snake_cursed";
	string SOUND_ALERT = "monsters/snakeman/sm_alert2.wav";
	string SOUND_ATTACK1 = "monsters/snakeman/sm_attack1.wav";
	string SOUND_ATTACK2 = "monsters/snakeman/sm_attack2.wav";
	string SOUND_ATTACK3 = "monsters/snakeman/sm_attack3.wav";
	string SOUND_IDLE1 = "monsters/snakeman/sm_idle1.wav";
	string SOUND_IDLE2 = "monsters/snakeman/sm_idle2.wav";
	string SOUND_IDLE3 = "monsters/snakeman/sm_idle3.wav";
	string SOUND_IDLE4 = "monsters/snakeman/sm_alert3.wav";
	string SOUND_PAIN1 = "monsters/snakeman/sm_pain1.wav";
	string SOUND_PAIN2 = "monsters/snakeman/sm_pain2.wav";
	string SOUND_PAIN_WEAK1 = "monsters/snakeman/sm_pain3.wav";
	string SOUND_PAIN_WEAK2 = "monsters/snakeman/sm_die2.wav";
	string SOUND_CHANT = "monsters/snakeman/sm_summon.wav";
	string SOUND_DEATH = "monsters/snakeman/sm_die1.wav";
	string SOUND_SUMMON = "magic/spawn.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STAFF_MISS = "zombie/claw_miss1.wav";
	string SOUND_STAFF_HIT = "zombie/claw_strike1.wav";
	float SUMMON_SKEL_FREQ = 90.0f;
	bool I_AM_TURNABLE = false;
	string MONSTER_MODEL = "monsters/snakeman.mdl";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_IDLE = "deep_idle";
	string ANIM_IDLE_NORM = "deep_idle";
	string ANIM_IDLE_CROUCH = "crouch_aim_serpentstaff";
	string ANIM_WALK = "walk2handed";
	string ANIM_RUN = "walk2handed";
	string ANIM_WALKSLOW = "walk2handed";
	string ANIM_RUNFAST = "run2";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_ATTACK_STAND = "ANIM_ATTACK_STAND";
	string ANIM_ATTACK_CROUCH = "ANIM_ATTACK_CROUCH";
	float SUMMON_SNAKE_FREQ = 0.0f;
	bool LOOKING_FOR_PLAYERS = false;
	float SNAKE_SLOT = 0.0f;
	string FIRST_VICTIM = "FIRST_VICTIM";
	int DID_INTRO = 0;
	string CYCLE_TIME = "CYCLE_TIME";
	bool STRIKE_STUN = false;
	bool SUMMON_SNAKE = false;
	bool SUMMON_SKELETON = false;
	bool SUMMONING = false;
	CBaseEntity@ MY_SKELETON = null;
	CBaseEntity@ SNAKE_SLOT1 = null;
	CBaseEntity@ SNAKE_SLOT2 = null;
	CBaseEntity@ SNAKE_SLOT3 = null;
	CBaseEntity@ SNAKE_SLOT4 = null;
	CBaseEntity@ SNAKE_SLOT5 = null;
	bool STAFF_STRIKE = false;
	bool DID_ESCAPE = false;
	bool TELED_OUT = false;
	CBaseEntity@ LURE_NAME = null;
	CBaseEntity@ LURE_ID = null;
	Vector3 LURE_ANG = Vector3();
	float LURE_YAW = 0.0f;
	bool SAID_ESCAPE = false;
	bool ESCAPE_SCENE = false;
	float FADE_OUT_COUNT = 0.0f;
	float BEAM_STAGE = 0.0f;
	Vector3 ESCAPE_START = Vector3();
	float FADE_COUNT = 0.0f;
	bool SUSPEND_AI = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	bool LURE_JUMP_DELAY = false;
	int FLEE_DIR = 0;

	// unnamed block (first think)
	void Slithar_FirstThink()
	{
		// crashes
		// recachefile monsters/skeleton_poison_random
		// recachefile monsters/snake_cursed
		IS_UNHOLY = true;

		if (ToLowerCase(MapName()) == "bloodrose")
		{
			NPC_GIVE_EXP = 1500.0f;
			NPC_IS_BOSS = true;
		}
		else
		{
			NPC_GIVE_EXP = 400.0f;
		}

		OnPrecacheSummons();
		ANIM_IDLE = "deep_idle";
		ANIM_IDLE_NORM = "deep_idle";
		ANIM_IDLE_CROUCH = "crouch_aim_serpentstaff";
		ANIM_DEATH = "headshot";
		ANIM_WALK = "walk2handed"; // sometimes switches to crawl
		ANIM_RUN = "walk2handed"; // only runs under certain circumstances (usually jumps)
		ANIM_WALKSLOW = "walk2handed";
		ANIM_RUNFAST = "run2";

		ANIM_ATTACK = "ref_shoot_serpentstaff"; // sometimes switches to crawl
		ANIM_ATTACK_STAND = "ref_shoot_serpentstaff"; // event staff_strike
		ANIM_ATTACK_CROUCH = "crouch_shoot_serpentstaff"; // event crouch_strike
		SUMMON_SNAKE_FREQ = 7.0f;
	}

	// npc_spawn
	void Slithar_OnNpcSpawn(string npc = "")
	{
		if (GENERIC_LORD)
			return;

		SetUniqueName("snake_lord");

		SetName("Slithar, the Snake Lord");
		SetRace("demon");
		SetHealth(3000);
		if (MapName() == "slithar_test")
			SetHealth(1501);
		SetWidth(32);
		SetHeight(84);
		SetRoam(false);
		SetModel(MONSTER_MODEL);
		SetIdleAnim(ANIM_IDLE_CROUCH);
		SetHearingSensitivity(10);
		SetInvincible(true); // invincible until intro over

		SetDamageTaken("poison", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("holy", 1.5f);

		if (MapName() != "slithar_test") // do not give to generic version
			GiveItem("blunt_snake_staff");

		OnNpcatkSuspendAi(npc, "start");

		LOOKING_FOR_PLAYERS = true;
		OnLookForPlayers();

		SNAKE_SLOT = 0.0f;
	}

	// look_for_players
	void Slithar_OnLookForPlayers()
	{
		if (!LOOKING_FOR_PLAYERS)
			return;
		if (DID_INTRO == 0)
		{
			if (Truthy(LegacyFunction("cansee", "enemy", 300))) // wait till close enough to pounce on
			{
				OnMePouncie(EntityOf(ENT_LASTSEEN));
				bool exitSub = true;
			}
		}
		CallEventDelayed(1.0f, "look_for_players");
	}

	// game_heardsound
	void Slithar_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (GENERIC_LORD)
			return;
		if (!LOOKING_FOR_PLAYERS)
			return;
		CBaseEntity@ lastheardId = EntityOf(ENT_LASTHEARD);
		if (!IsPlayer(lastheardId))
			return;
		if (!(RangeTo(lastheardId) < 300.0f))
			return;
		OnMePouncie(lastheardId);
	}

	// me_pouncie
	// PARAM1 first target
	void Slithar_OnMePouncie(CBaseEntity@ firstTarget = null)
	{
		if (!LOOKING_FOR_PLAYERS)
			return;
		LOOKING_FOR_PLAYERS = false;
		SetMoveDest(@firstTarget, 9999);
		PlaySound(0, 10, SOUND_ALERT);
		SetSayTextRange(2048);
		SayText("Ahhhh my childrensss you have come to die, yessss?");
		CallEventDelayed(3.0f, "intro_jump_down");
		FIRST_VICTIM = EntityId(firstTarget) + "first_target";
	}

	// intro_jump_down
	void Slithar_OnIntroJumpDown()
	{
		SetMoveAnim(ANIM_HOP);
		SetIdleAnim(ANIM_IDLE);
		PlaySound(0, 10, SOUND_IDLE2);
		SetMoveDest(RelativePosition(Vector3(0, 128, 0)), MONSTER_WIDTH);
		CallEventDelayed(0.1f, "hop_boost");
		PlayAnim("critical", ANIM_HOP);
	}

	// hop_boost
	void Slithar_OnHopBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 300, 40)));
	}

	// jump_done
	void Slithar_OnJumpDone(string npc = "")
	{
		if (DID_INTRO != 0)
			return;
		OnGoStand();
		ANIM_RUN = ANIM_RUNFAST;
		SetMoveAnim(ANIM_RUNFAST);
		DID_INTRO = 1;
		SetSayTextRange(2048);
		SayText("Thissss can be arranged. Yessss....");
		SetInvincible(false);
		SetRoam(true);
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		OnNpcatkResumeAi(npc);
		OnNpcatkSettarget(FIRST_VICTIM);
		SUMMON_SNAKE_FREQ = 2.0f;
		CallEventDelayed(25.0f, "snake_slowdown");
		CallEventDelayed(30.0f, "summon_skeleton"); // remove from generic version
		CallEventDelayed(5.0f, "summon_snake");
		OnIdleSounds();
	}

	// snake_slowdown
	void Slithar_OnSnakeSlowdown()
	{
		ANIM_WALK = ANIM_WALKSLOW;
		ANIM_RUN = ANIM_WALKSLOW;
		if (!ESCAPE_SCENE)
			SetMoveAnim(ANIM_WALK);
		SUMMON_SNAKE_FREQ = 5.0f;
	}

	// idle_sounds
	void Slithar_OnIdleSounds()
	{
		CallEventDelayed(Random(5, 10), "idle_sounds");
		if (!CanSee("enemy"))
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE1, SOUND_IDLE3, SOUND_IDLE4);
	}

	// summon_snake
	void Slithar_OnSummonSnake()
	{
		bool exitSub = false;

		OnGoStand();
		if (Truthy(LegacyFunction("cansee", "enemy", JUMP_AWAY_RANGE)) && !SUMMON_SKELETON)
		{
			OnJumpAway();
			STRIKE_STUN = true;
			CallEventDelayed(1.0f, "summon_snake");
			exitSub = true;
		}
		if (exitSub)
			return;
		STRIKE_STUN = false;

		CallEventDelayed(SUMMON_SNAKE_FREQ, "summon_snake");

		if (NPCATK_TARGET == "unset")
		{
			// if not attacking, keep summoning until I have a full set
			float totalSnakes = 0.0f;
			if (IsAlive(SNAKE_SLOT1))
				totalSnakes += 1.0f;
			if (IsAlive(SNAKE_SLOT2))
				totalSnakes += 1.0f;
			if (IsAlive(SNAKE_SLOT3))
				totalSnakes += 1.0f;
			if (IsAlive(SNAKE_SLOT4))
				totalSnakes += 1.0f;
			if (IsAlive(SNAKE_SLOT5))
				totalSnakes += 1.0f;
			if (totalSnakes >= 5.0f)
				exitSub = true;
		}
		if (exitSub)
			return;

		if (SUMMON_SKELETON)
			return;
		if (SUMMONING)
			return;
		if (ESCAPE_SCENE)
			return;
		SUMMON_SNAKE = true;
		PlaySound(0, 10, SOUND_CHANT);
		PlayAnim("critical", ANIM_SUMMON);
	}

	// summon_skeleton
	void Slithar_OnSummonSkeleton()
	{
		bool exitSub = false;

		OnGoStand();
		if (Truthy(LegacyFunction("cansee", "enemy", JUMP_AWAY_RANGE)))
		{
			OnJumpAway();
			STRIKE_STUN = true;
			CallEventDelayed(1.0f, "summon_skeleton");
			exitSub = true;
		}
		if (exitSub)
			return;

		STRIKE_STUN = false;
		CallEventDelayed(SUMMON_SKEL_FREQ, "summon_skeleton");

		SUMMON_SNAKE = false; // prioritize skeleton over snake
		SUMMON_SKELETON = true;
		if (ESCAPE_SCENE)
			return;
		PlaySound(0, 10, SOUND_CHANT);
		PlayAnim("critical", ANIM_SUMMON);
	}

	// spell_strike
	// called from ANIM_SUMMON
	void Slithar_OnSpellStrike()
	{
		bool exitSub = false;

		if (ESCAPE_SCENE)
			return;

		if (SUMMON_SKELETON)
		{
			SUMMON_SKELETON = false;
			SUMMONING = true;
			CallEventDelayed(3.0f, "reset_summoning");
			PlaySound(0, 10, SOUND_SUMMON);

			if (IsAlive(MY_SKELETON))
				CallExternal(MY_SKELETON, "npc_fade_away");

			CreateNpc(SKELETON_SCRIPT, RelativePosition(Vector3(0, 48, 5)), self);
			Effect("glow", ENT_LASTCREATED, Vector3(0, 255, 0), 200, 2, 2);
			@MY_SKELETON = EntityOf(ENT_LASTCREATED);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (SUMMON_SNAKE)
		{
			SUMMON_SNAKE = false;
			SUMMONING = true;
			CallEventDelayed(3.0f, "reset_summoning");
			PlaySound(0, 10, SOUND_SUMMON);

			SNAKE_SLOT += 1.0f;

			if (SNAKE_SLOT > 5.0f)
				SNAKE_SLOT = 1.0f;

			// unsummon any active snake in same slot
			if (SNAKE_SLOT == 1.0f && IsAlive(SNAKE_SLOT1))
				CallExternal(SNAKE_SLOT1, "npc_fade_away");

			if (SNAKE_SLOT == 2.0f && IsAlive(SNAKE_SLOT2))
				CallExternal(SNAKE_SLOT2, "npc_fade_away");

			if (SNAKE_SLOT == 3.0f && IsAlive(SNAKE_SLOT3))
				CallExternal(SNAKE_SLOT3, "npc_fade_away");

			if (SNAKE_SLOT == 4.0f && IsAlive(SNAKE_SLOT4))
				CallExternal(SNAKE_SLOT4, "npc_fade_away");

			if (SNAKE_SLOT == 5.0f && IsAlive(SNAKE_SLOT5))
				CallExternal(SNAKE_SLOT5, "npc_fade_away");

			CreateNpc(SNAKE_SCRIPT, RelativePosition(Vector3(0, 64, 5)));
			Effect("glow", ENT_LASTCREATED, Vector3(0, 255, 0), 100, 1, 1);
			CallExternal(ENT_LASTCREATED, "npcatk_settarget", NPCATK_TARGET, "my_master");

			// store active snake
			if (SNAKE_SLOT == 1.0f)
				@SNAKE_SLOT1 = EntityOf(ENT_LASTCREATED);
			if (SNAKE_SLOT == 2.0f)
				@SNAKE_SLOT2 = EntityOf(ENT_LASTCREATED);
			if (SNAKE_SLOT == 3.0f)
				@SNAKE_SLOT3 = EntityOf(ENT_LASTCREATED);
			if (SNAKE_SLOT == 4.0f)
				@SNAKE_SLOT4 = EntityOf(ENT_LASTCREATED);
			if (SNAKE_SLOT == 5.0f)
				@SNAKE_SLOT5 = EntityOf(ENT_LASTCREATED);
		}

		if (RandomInt(1, 2) == 1)
			OnGoCrawl();
	}

	// reset_summoning
	void Slithar_OnResetSummoning()
	{
		SUMMONING = false;
	}

	// jump_away
	void Slithar_OnJumpAway()
	{
		if (ESCAPE_SCENE)
			return;

		OnGoStand();
		SetMoveAnim(ANIM_JUMP);
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		SetMoveDest(@EntityOf(NPCATK_TARGET), 9999, "flee");
		// dbg temp Relvel $relvel(0,100,20)
		CallEventDelayed(0.1f, "long_jump_boost");
		OnNpcatkSuspendAi("1.5", "jump_away");
	}

	// long_jump_boost
	void Slithar_OnLongJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 400, 50)));
	}

	// long_jump_done
	// not getting called :\
	void Slithar_OnLongJumpDone(string npc = "")
	{
		OnNpcatkResumeAi(npc);
		OnNpcatkSettarget(NPCATK_TARGET);
	}

	// skeleton_died
	// called externally by skeleton
	void Slithar_OnSkeletonDied()
	{
		PlaySound(0, 10, "monsters/snakeman/sm_alert4.wav");
		SetSayTextRange(2048);
		SayText("Curse you!");
	}

	// skeleton_stuck
	void Slithar_OnSkeletonStuck()
	{
		// dbg My skele is stuck, resummoning
		OnSummonSkeleton();
	}

	// staff_strike
	void Slithar_OnStaffStrike()
	{
		OnNpcatkDodamage("NPCATK_ATARGET", Text(ATTACK_HITRANGE), STAFF_DAMAGE, ATTACK_HITCHANCE, ENT_ME);
		STAFF_STRIKE = true;
		if (RandomInt(1, 10) == 1)
			OnGoCrawl();
	}

	// crouch_strike
	void Slithar_OnCrouchStrike()
	{
		OnNpcatkDodamage("NPCATK_ATARGET", Text(ATTACK_HITRANGE), STAFF_DAMAGE, ATTACK_HITCHANCE, ENT_ME);
		STAFF_STRIKE = true;
		if (RandomInt(1, 5) == 1)
			OnGoStand();
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Origin  4:  End Origin
	string Slithar_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!STAFF_STRIKE)
			return result;
		if (hit)
		{
			PlaySound(0, 10, SOUND_STAFF_HIT);
			if (!STRIKE_STUN)
				ApplyEffect(NPCATK_TARGET, "effects/dot_poison", POISON_DURATION, self, POISON_DAMAGE);
			if (STRIKE_STUN)
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
		}
		if (!hit)
			PlaySound(0, 10, SOUND_STAFF_MISS);
		STAFF_STRIKE = false;
		return result;
	}

	// go_crawl
	void Slithar_OnGoCrawl()
	{
		ANIM_ATTACK = ANIM_ATTACK_CROUCH;
		ANIM_WALK = ANIM_WALKSLOW;
		ANIM_RUN = ANIM_CRAWL;
		ANIM_IDLE = ANIM_IDLE_CROUCH;
		if (!ESCAPE_SCENE)
			SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
	}

	// go_stand
	void Slithar_OnGoStand()
	{
		ANIM_ATTACK = ANIM_ATTACK_STAND;
		ANIM_WALK = ANIM_WALKSLOW;
		ANIM_RUN = ANIM_WALKSLOW;
		if (MyHealth() < 2000.0f)
			ANIM_RUN = ANIM_RUNFAST;
		ANIM_IDLE = ANIM_IDLE_NORM;
		if (!ESCAPE_SCENE)
			SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
	}

	// npc_pre_flee
	void Slithar_OnNpcPreFlee()
	{
		OnGoStand();
		ANIM_RUN = ANIM_RUNFAST;
	}

	// npcatk_stopflee
	void Slithar_OnNpcatkStopflee()
	{
		ANIM_RUN = ANIM_WALKSLOW;
		if (!ESCAPE_SCENE)
			SetMoveAnim(ANIM_WALK);
		OnGoStand();
	}

	// chicken_run_end
	void Slithar_OnChickenRunEnd()
	{
		ANIM_RUN = ANIM_WALKSLOW;
		if (!ESCAPE_SCENE)
			SetMoveAnim(ANIM_WALK);
		OnGoStand();
	}

	// game_struck
	void Slithar_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (MyHealth() < 1500.0f)
		{
			// this teleports slithar to his escape dest
			if (!GENERIC_LORD && !DID_ESCAPE)
			{
				DID_ESCAPE = true;
				SetInvincible(true);
				if (!GENERIC_LORD)
					UseTrigger("slithar_half");
			}
		}

		if (!(damage > 30.0f))
			return;
		if (damage < 100.0f)
			PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK1, SOUND_STRUCK2);
		if (damage >= 100.0f)
		{
			PlayRandomSound(0, 10, SOUND_PAIN_WEAK1, SOUND_PAIN_WEAK2);
			CallEventDelayed(1.0f, "jump_away");
		}
	}

	// game_death
	void Slithar_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetSayTextRange(2048);
		if (!GENERIC_LORD)
			UseTrigger("flesheater_door");

		CBaseEntity@ findle = FindByName("npc_findlebind");
		if (Exists(findle))
			CallExternal(findle, "slithar_died");

		CallExternal(SNAKE_SLOT1, "npc_fade_away");
		CallExternal(SNAKE_SLOT2, "npc_fade_away");
		CallExternal(SNAKE_SLOT3, "npc_fade_away");
		CallExternal(SNAKE_SLOT4, "npc_fade_away");
		CallExternal(SNAKE_SLOT5, "npc_fade_away");
		CallExternal(MY_SKELETON, "npc_fade_away");
	}

	// precache_summons
	void Slithar_OnPrecacheSummons()
	{
	}

	// slithar_escape
	void Slithar_OnSlitharEscape(string delay = "")
	{
		TELED_OUT = true;

		@LURE_NAME = FindByName("slithar_lure");
		@LURE_ID = LURE_NAME;
		LURE_ANG = AnglesOf(LURE_ID);
		LURE_YAW = LURE_ANG.y;

		// dbg temp got escape command from slithar_lure LURE_ID
		if (!SAID_ESCAPE)
		{
			SAID_ESCAPE = true;
			SayText("I'll not make it that eassssy for you...");
		}
		OnNpcatkSuspendAi(delay, "escape1");
		ESCAPE_SCENE = true;
		SetInvincible(true);

		// setsolid none
		FADE_OUT_COUNT = 200.0f;
		OnSlitharFadeOut();

		SetMoveAnim(ANIM_IDLE_NORM);
		SetIdleAnim(ANIM_IDLE_NORM);
		ANIM_RUN = ANIM_IDLE_NORM;
		ANIM_WALK = ANIM_IDLE_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;

		PlayAnim("break");
		PlayAnim("critical", ANIM_SUMMON);

		BEAM_STAGE = 0.0f;
		ESCAPE_START = MyOrigin();
		OnSlitharBeamCycle();
		PlaySound(0, 10, SOUND_SUMMON);

		SetMoveAnim(ANIM_SUMMON);
		SetIdleAnim(ANIM_SUMMON);
		SetMoveDest(@LURE_ID, 10);

		CallEventDelayed(0.25f, "slithar_beams");
	}

	// slithar_beams
	void Slithar_OnSlitharBeams()
	{
		string beamSprite = "lgtning.spr";

		float startX = ESCAPE_START.x;
		float startY = ESCAPE_START.y;
		float startZ = ESCAPE_START.z - 64.0f;

		// start beam tpower
		int beamWidth = 200;
		Vector3 beamStart = Vector3(startX, startY, startZ);
		string beamEnd = Text(beamStart);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 256)));
		Vector3 beamColor = Vector3(255, 255, 255);
		int beamBrightness = 200;
		int beamNoise = 30;
		float beamDuration = 4.0f;
		Effect("beam", "point", beamSprite, beamWidth, beamStart, beamEnd, beamColor, beamBrightness, beamNoise, beamDuration);

		Vector3 endPos = OriginOf(LURE_ID);
		startX = endPos.x;
		startY = endPos.y;
		startZ = endPos.z - 64.0f;

		// end beam tower
		beamWidth = 200;
		beamStart = Vector3(startX, startY, startZ);
		beamEnd = Text(beamStart);
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 256)));
		beamColor = Vector3(255, 255, 255);
		beamBrightness = 200;
		beamNoise = 30;
		beamDuration = 4.0f;
		Effect("beam", "point", beamSprite, beamWidth, beamStart, beamEnd, beamColor, beamBrightness, beamNoise, beamDuration);
	}

	// slithar_beam_cycle
	void Slithar_OnSlitharBeamCycle()
	{
		int beamBrightness = 0;

		if (!(BEAM_STAGE < 6.0f))
			return;
		BEAM_STAGE += 1.0f;
		CallEventDelayed(0.4f, "slithar_beam_cycle");

		string beamSprite = "lgtning.spr";
		int beamWidth = 200;
		Vector3 beamStart = ESCAPE_START;
		Vector3 beamEnd = OriginOf(LURE_ID) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 32));
		Vector3 beamColor = Vector3(0, 255, 0);
		if (BEAM_STAGE == 1.0f)
			beamBrightness = 20;
		if (BEAM_STAGE == 2.0f)
			beamBrightness = 100;
		if (BEAM_STAGE == 3.0f)
			beamBrightness = 255;
		if (BEAM_STAGE == 4.0f)
			beamBrightness = 100;
		if (BEAM_STAGE == 5.0f)
			beamBrightness = 50;
		int beamNoise = 5;
		float beamDuration = 0.5f;

		// <spritename> <width>   <startpos> <endpos> <(r,g,b)>  <brightness>    <noise>    <duration>
		Effect("beam", "point", beamSprite, beamWidth, beamStart, beamEnd, beamColor, beamBrightness, beamNoise, beamDuration);
		Effect("tempent", "trail", "poison.spr", RelativePosition(Vector3(0, 0, 64)), RelativePosition(Vector3(0, 0, 96)), 20, 1, 1, 20, 5);
	}

	// slithar_fade_out
	void Slithar_OnSlitharFadeOut()
	{
		if (FADE_OUT_COUNT <= 0.0f)
		{
			SetMoveAnim(ANIM_IDLE_NORM);
			SetIdleAnim(ANIM_IDLE_NORM);
			OnSlitharEscapeTele();
		}
		if (!(FADE_OUT_COUNT > 0.0f))
			return;
		CallEventDelayed(0.1f, "slithar_fade_out");
		FADE_OUT_COUNT -= 10.0f;
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", FADE_OUT_COUNT);
	}

	// slithar_escape_tele
	void Slithar_OnSlitharEscapeTele()
	{
		// dbg temp slithar_escape_tele idle
		SetMoveAnim(ANIM_IDLE_NORM);
		SetIdleAnim(ANIM_IDLE_NORM);
		ANIM_RUN = ANIM_IDLE_NORM;
		ANIM_WALK = ANIM_IDLE_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		PlayAnim("break");
		PlayAnim(ANIM_IDLE_NORM);
		OnStopMovingDamnit();
		SetMoveSpeed(0);
		SetRoam(false);
		SetOrigin(ENT_ME, OriginOf(LURE_ID));
		SetAngle("face", Vector3(0, LURE_YAW, 0));
		FADE_COUNT = 0.0f;
		PlaySound(0, 10, SOUND_SUMMON);
		OnSlitharFadeIn();

		Vector3 splugeStart = OriginOf(LURE_ID);
		string splugeDest = Text(splugeStart);
		splugeDest = Text(Vec(splugeDest) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 200)));

		Effect("tempent", "trail", "poison.spr", splugeStart, splugeDest, 20, 1, 5, 20, 5);

		UseTrigger("slithar_escaped");

		DeleteEntity(LURE_ID);
	}

	// stop_moving_damnit
	void Slithar_OnStopMovingDamnit()
	{
		if (!ESCAPE_SCENE)
			return;
		SetAngle("face", Vector3(0, LURE_YAW, 0));
		CallEventDelayed(1.0f, "stop_moving_damnit");
		// //dbg told to stop walking ( ANIM_IDLE_NORM )
		SetMoveAnim(ANIM_IDLE_NORM);
		SetIdleAnim(ANIM_IDLE_NORM);
		ANIM_RUN = ANIM_IDLE_NORM;
		ANIM_WALK = ANIM_IDLE_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		PlayAnim("once", ANIM_IDLE_NORM);
	}

	// slithar_fade_in
	void Slithar_OnSlitharFadeIn()
	{
		if (FADE_COUNT >= 250.0f)
		{
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 0);
		}
		if (!(FADE_COUNT < 250.0f))
			return;
		CallEventDelayed(0.1f, "slithar_fade_in");
		FADE_COUNT += 10.0f;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", FADE_COUNT);
	}

	// slithar_resume
	void Slithar_OnSlitharResume()
	{
		// dbg Resuming combat
		SetInvincible(false);
		// setsolid 1
		ESCAPE_SCENE = false;
		OnNpcatkResumeAi();
		SetMoveAnim(ANIM_RUNFAST);
		SetIdleAnim(ANIM_IDLE_NORM);
		SetMoveSpeed(1);
		SetRoam(true);
		ANIM_RUN = ANIM_RUNFAST;
		ANIM_WALK = ANIM_WALKSLOW;
		ANIM_IDLE = ANIM_IDLE_NORM;
		SUMMON_SKELETON = false;
		SUMMON_SNAKE = false;
		SUMMONING = false;
		CallEventDelayed(3.0f, "reset_summoning");
	}

	// npcatk_suspend_ai
	// param1 seconds, if omitted ai suspends until npcatk_resume_ai called if omitted
	void Slithar_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
	}

	// npcatk_resume_ai
	void Slithar_OnNpcatkResumeAi(string target = "")
	{
		// this has to be overriden in case escape scene starts mid-jump
		if (ESCAPE_SCENE)
			return;

		// dbg resume AI PARAM2
		if (!SUSPEND_AI)
			return;
		if (NPC_STORE_TARGET != "unset")
			OnNpcatkRestoreTarget();
		SUSPEND_AI = false;
	}

	// slithar_to_me
	// PARAM1 dest PARAM2 range PARAM3 calling ent
	void Slithar_OnSlitharToMe(Vector3 destination = Vector3(), string range = "", CBaseEntity@ caller = null)
	{
		bool reachedLure = false;

		if (TELED_OUT)
			return;

		if (!SUSPEND_AI)
			OnNpcatkSuspendAi();
		if (!ESCAPE_SCENE)
		{
			// anti-stuck doesn't work while AI is suspended, so we need our own, local anti-stuck (ripped from chicken_run)
			CKN_MY_OLD_POS = Text(OriginOf(ENT_ME));
			ESCAPE_SCENE = true;
			CallEventDelayed(0.1f, "lure_stuck_check");
		}
		SetMoveAnim(ANIM_RUNFAST);
		if (!LURE_JUMP_DELAY)
		{
			PlayAnim("critical", ANIM_JUMP);
			LURE_JUMP_DELAY = true;
			CallEventDelayed(0.1f, "long_jump_boost");
			CallEventDelayed(JUMP_FREQ, "reset_lure_jump_delay");
		}

		SetMoveDest(destination, MOVE_RANGE);
		if (Float(range) < Float(MOVE_RANGE))
			reachedLure = true;
		if (Distance(destination, MyOrigin()) < Float(MOVE_RANGE))
			reachedLure = true;

		if (!reachedLure)
			return;
		ESCAPE_SCENE = false;
		OnNpcatkResumeAi();
		CallExternal(caller, "slithar_made_it");
		UseTrigger("slithar_escaped");
		OnSlitharResume();
	}

	// reset_lure_jump_delay
	void Slithar_OnResetLureJumpDelay()
	{
		LURE_JUMP_DELAY = false;
	}

	// lure_stuck_check
	void Slithar_OnLureStuckCheck()
	{
		// attempt to run around players/obsticles while moving to lure
		if (TELED_OUT)
			return;
		if (!ESCAPE_SCENE)
			return;

		float cknMoveDist = Distance(MyOrigin(), Vec(CKN_MY_OLD_POS));

		if (cknMoveDist == 0.0f)
		{
			// I've not moved since the last check, pick a random dir and move there for a sec
			FLEE_DIR = RandomInt(1, 359);
			SetMoveDest(RelativePosition(Vector3(0, FLEE_DIR, 0), Vector3(0, 500, 0)), 0);

			PlayAnim("loop", ANIM_RUNFAST);
		}
		CKN_MY_OLD_POS = Text(MyOrigin());

		CallEventDelayed(0.25f, "lure_stuck_check");
	}

	// slithar_stop
	// PARAM1 = activator's yaw
	void Slithar_OnSlitharStop(float yaw = 0.0f)
	{
		// dbg Got stop command, will not resume until slithar/resume spawns
		ESCAPE_SCENE = true;
		SetInvincible(true);
		LURE_YAW = yaw;
		OnStopMovingDamnit();
	}

	// npc_suicide
	void Slithar_OnNpcSuicide(string suicideMode = "")
	{
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
		Slithar_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Slithar_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		Slithar_OnNpcSpawn(npc);
	}

	// npcatk_stopflee
	void OnNpcatkStopflee()
	{
		BaseNpcAttackNew_OnNpcatkStopflee(); // monsters/base_npc_attack_new
		Slithar_OnNpcatkStopflee();
	}

	// chicken_run_end
	void OnChickenRunEnd()
	{
		BaseNpcAttackNew_OnChickenRunEnd(); // monsters/base_npc_attack_new
		Slithar_OnChickenRunEnd();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		Slithar_OnGameHeardsound(soundType, origin, dangerRadius);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		Slithar_OnNpcatkSuspendAi(seconds, debugTag);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, Slithar_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	void OnLookForPlayers() { Slithar_OnLookForPlayers(); } // look_for_players
	void OnMePouncie(CBaseEntity@ firstTarget = null) { Slithar_OnMePouncie(firstTarget); } // me_pouncie
	void OnIntroJumpDown() { Slithar_OnIntroJumpDown(); } // intro_jump_down
	void OnHopBoost() { Slithar_OnHopBoost(); } // hop_boost
	void OnJumpDone(string npc = "") { Slithar_OnJumpDone(npc); } // jump_done
	void OnSnakeSlowdown() { Slithar_OnSnakeSlowdown(); } // snake_slowdown
	void OnIdleSounds() { Slithar_OnIdleSounds(); } // idle_sounds
	void OnSummonSnake() { Slithar_OnSummonSnake(); } // summon_snake
	void OnSummonSkeleton() { Slithar_OnSummonSkeleton(); } // summon_skeleton
	void OnSpellStrike() { Slithar_OnSpellStrike(); } // spell_strike
	void OnResetSummoning() { Slithar_OnResetSummoning(); } // reset_summoning
	void OnJumpAway() { Slithar_OnJumpAway(); } // jump_away
	void OnLongJumpBoost() { Slithar_OnLongJumpBoost(); } // long_jump_boost
	void OnLongJumpDone(string npc = "") { Slithar_OnLongJumpDone(npc); } // long_jump_done
	void OnSkeletonDied() { Slithar_OnSkeletonDied(); } // skeleton_died
	void OnSkeletonStuck() { Slithar_OnSkeletonStuck(); } // skeleton_stuck
	void OnStaffStrike() { Slithar_OnStaffStrike(); } // staff_strike
	void OnCrouchStrike() { Slithar_OnCrouchStrike(); } // crouch_strike
	void OnGoCrawl() { Slithar_OnGoCrawl(); } // go_crawl
	void OnGoStand() { Slithar_OnGoStand(); } // go_stand
	void OnNpcPreFlee() { Slithar_OnNpcPreFlee(); } // npc_pre_flee
	void OnPrecacheSummons() { Slithar_OnPrecacheSummons(); } // precache_summons
	void OnSlitharEscape(string delay = "") { Slithar_OnSlitharEscape(delay); } // slithar_escape
	void OnSlitharBeams() { Slithar_OnSlitharBeams(); } // slithar_beams
	void OnSlitharBeamCycle() { Slithar_OnSlitharBeamCycle(); } // slithar_beam_cycle
	void OnSlitharFadeOut() { Slithar_OnSlitharFadeOut(); } // slithar_fade_out
	void OnSlitharEscapeTele() { Slithar_OnSlitharEscapeTele(); } // slithar_escape_tele
	void OnStopMovingDamnit() { Slithar_OnStopMovingDamnit(); } // stop_moving_damnit
	void OnSlitharFadeIn() { Slithar_OnSlitharFadeIn(); } // slithar_fade_in
	void OnSlitharResume() { Slithar_OnSlitharResume(); } // slithar_resume
	void OnNpcatkResumeAi(string target = "") { Slithar_OnNpcatkResumeAi(target); } // npcatk_resume_ai
	void OnSlitharToMe(Vector3 destination = Vector3(), string range = "", CBaseEntity@ caller = null) { Slithar_OnSlitharToMe(destination, range, caller); } // slithar_to_me
	void OnResetLureJumpDelay() { Slithar_OnResetLureJumpDelay(); } // reset_lure_jump_delay
	void OnLureStuckCheck() { Slithar_OnLureStuckCheck(); } // lure_stuck_check
	void OnSlitharStop(float yaw = 0.0f) { Slithar_OnSlitharStop(yaw); } // slithar_stop
	void OnNpcSuicide(string suicideMode = "") { Slithar_OnNpcSuicide(suicideMode); } // npc_suicide
	void OnJumpFreq() {} // JUMP_FREQ
	void OnSummonSkelFreq() {} // SUMMON_SKEL_FREQ
	void OnSummonSnakeFreq() {} // SUMMON_SNAKE_FREQ

	// This file's events and timers by their .script names
	bool Slithar_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chicken_run_end") { OnChickenRunEnd(); return true; }
		if (name == "crouch_strike") { OnCrouchStrike(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "go_crawl") { OnGoCrawl(); return true; }
		if (name == "go_stand") { OnGoStand(); return true; }
		if (name == "hop_boost") { OnHopBoost(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "intro_jump_down") { OnIntroJumpDown(); return true; }
		if (name == "jump_away") { OnJumpAway(); return true; }
		if (name == "jump_done") { OnJumpDone(Param(params, 0)); return true; }
		if (name == "long_jump_boost") { OnLongJumpBoost(); return true; }
		if (name == "long_jump_done") { OnLongJumpDone(Param(params, 0)); return true; }
		if (name == "look_for_players") { OnLookForPlayers(); return true; }
		if (name == "lure_stuck_check") { OnLureStuckCheck(); return true; }
		if (name == "me_pouncie") { OnMePouncie(EntityParam(params, 0)); return true; }
		if (name == "npc_pre_flee") { OnNpcPreFlee(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "precache_summons") { OnPrecacheSummons(); return true; }
		if (name == "reset_lure_jump_delay") { OnResetLureJumpDelay(); return true; }
		if (name == "reset_summoning") { OnResetSummoning(); return true; }
		if (name == "skeleton_died") { OnSkeletonDied(); return true; }
		if (name == "skeleton_stuck") { OnSkeletonStuck(); return true; }
		if (name == "slithar_beam_cycle") { OnSlitharBeamCycle(); return true; }
		if (name == "slithar_beams") { OnSlitharBeams(); return true; }
		if (name == "slithar_escape") { OnSlitharEscape(Param(params, 0)); return true; }
		if (name == "slithar_escape_tele") { OnSlitharEscapeTele(); return true; }
		if (name == "slithar_fade_in") { OnSlitharFadeIn(); return true; }
		if (name == "slithar_fade_out") { OnSlitharFadeOut(); return true; }
		if (name == "slithar_resume") { OnSlitharResume(); return true; }
		if (name == "slithar_stop") { OnSlitharStop(Float(Param(params, 0))); return true; }
		if (name == "slithar_to_me") { OnSlitharToMe(Vec(Param(params, 0)), Param(params, 1), EntityParam(params, 2)); return true; }
		if (name == "snake_slowdown") { OnSnakeSlowdown(); return true; }
		if (name == "spell_strike") { OnSpellStrike(); return true; }
		if (name == "staff_strike") { OnStaffStrike(); return true; }
		if (name == "stop_moving_damnit") { OnStopMovingDamnit(); return true; }
		if (name == "summon_skeleton") { OnSummonSkeleton(); return true; }
		if (name == "summon_snake") { OnSummonSnake(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "slithar/slithar"]
shared class SlitharScript : BaseMonsterNewScript, Slithar
{
	// Variables every script that includes this file declares
	bool CYCLES_ON = false;
	bool GENERIC_LORD = false;

	// Variables declared by included files, with the value they start with in this script
	SlitharScript()
	{
		NPC_BOSS_RESTORATION = 1.0f;
		ANIM_IDLE = "deep_idle";
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "walk2handed";
		SOUND_DEATH = "monsters/snakeman/sm_die1.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/snakeman.mdl");
		Precache("monsters/csnake.mdl");
		Precache("monsters/skeleton_enraged.mdl");
		Precache("monsters/skeleton.mdl");
		Precache("poison_cloud.spr");
		Precache("cactusgibs.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Slithar_FirstThink();
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
		return Slithar_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
