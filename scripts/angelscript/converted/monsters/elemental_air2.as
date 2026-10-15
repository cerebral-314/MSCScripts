#pragma context server

// Converted from monsters/elemental_air2.script by msc_transpiler.
// This is an older script and may have some bad conventions as a result.
// idears:
// - teleport dodge (go invisible, push in random dir)
// - *guided lightning balls (just use g.fireballs)
// - *chain lightning (from target to target)
// - pick up and throw a random opponent
// - *hurricane with spawn delay
// features:
// - *passive flight AI

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/elemental_air2"]
class ElementalAir2 : BaseMonsterNewScript, BasePropelled
{
	// Constants
	int MOVESPEED_SLOW = 100;
	int MOVESPEED_FAST = 200;
	float FREQ_CHAIN = 0.0f;
	float FREQ_GLOAT = 10.0f;
	float FREQ_BALLS = 30.0f;
	float FREQ_TORNADO = 0.0f;
	int DMG_CHAIN_DOT = 100;
	int DMG_CHAIN_DRAIN = 50;
	int DMG_BALL = 200;
	float FREQ_TELEPORT = 0.0f;
	string SOUND_THUNDER = "magic/bolt_end.wav";
	string SOUND_THUNDER_CHARGE = "magic/bolt_start.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
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
	float MY_HURT_STAGE = 0.0f;
	Vector3 NPC_MOVE_DEST = Vector3();
	float ROAM_ROT = 0.0f;
	string BEAM_LIST = "BEAM_LIST";
	float NEXT_GLOAT = 0.0f;
	bool NO_MOVE = false;
	Vector3 OLD_POS = Vector3();
	float HOVER_LOOP_DELAY = 0.0f;
	bool CYCLES_ON = false;
	string CHAIN_TARGETS = "CHAIN_TARGETS";
	float BEAM_STEP = 0.0f;
	string BEAM_ID = "BEAM_ID";
	string BALL_TARGETS = "BALL_TARGETS";
	bool AM_SUMMONED = false;
	bool TELEPORT_ENABLED = false;

	// Variables declared by included files, with the value they start with in this script
	ElementalAir2()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "idle1";
		ANIM_RUN = "idle1";
		SOUND_DEATH = "garg/gar_die1.wav";
	}

	// unnamed block (first think)
	void ElementalAir2_FirstThink()
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

		// base stats
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		ATTACK_RANGE = 100.0f;
		ATTACK_HITRANGE = 150.0f;
		MOVE_RANGE = "65";
		NPC_HACKED_MOVE_SPEED = 100.0f;
	}

	// unnamed block (timer)
	void ElementalAir2_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(1.0f, "ElementalAir2_Timer");
		// main movement cycle
		if (NO_MOVE)
		{
			SetMoveDest("none");
			NPC_HACKED_MOVE_SPEED = 0.0f;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Text(NPC_MOVE_DEST) == "unset")
		{
			// no target, circle around spawn point
			ROAM_ROT += 10.0f;
			if (ROAM_ROT > 359.0f)
				ROAM_ROT -= 359.0f;
			Vector3 moveDest = MyOrigin() + RelativePosition(Vector3(0, ROAM_ROT, 0), Vector3(0, 128, 0));
			SetMoveDest(moveDest, 0);
			NPC_HACKED_MOVE_SPEED = MOVESPEED_SLOW;
		}
		else
		{
			NPC_HACKED_MOVE_SPEED = MOVESPEED_FAST;
			SetMoveDest(NPC_MOVE_DEST, ATTACK_MOVERANGE);
		}

		if (I_R_FROZEN)
		{
			SetMoveDest("none");
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, -200)));
			NPC_HACKED_MOVE_SPEED = 0.0f;
		}
		else
		{
			if (Distance(OLD_POS, MyOrigin()) < 5.0f)
			{
				// stuck, jerk around a bit
				int rndRl = RandomInt(-100, 100);
				int rndFb = RandomInt(-100, 100);
				int rndUd = RandomInt(-100, 100);
				AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndRl, rndFb, rndUd)));
			}
			OLD_POS = MyOrigin();
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/tornado");
		PrecacheFile("monsters/summon/lightning_ball_guided");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnRemoveBeamsLoop();
		}
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		AM_SUMMONED = true;
		NO_SPAWN_STUCK_CHECK = true;

		TELEPORT_ENABLED = true;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Greater Air Elemental");
		SetHealth(4000);
		SetWidth(64);
		SetHeight(64);
		SetRace("demon");
		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 0);
		SetDamageTaken("acid", 0);
		SetDamageTaken("lightning", 0);

		SetBlood("none");

		SetRoam(false);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(11);
		SetModel("monsters/elementals_greater_flyer.mdl");
		SetModelBody(0, 3);
		NPC_GIVE_EXP = 600.0f;
		CallEventDelayed(1.0f, "idle_sounds");

		SetFly(true);

		MY_HURT_STAGE = MaxHealthOf(ENT_ME) * HURT_THRESHOLD;

		NPC_MOVE_DEST = Vec("unset");
		ROAM_ROT = 0.0f;

		BEAM_LIST = "";
		CallEventDelayed(0.1f, "init_beam1");
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		NPC_MOVE_DEST = Vec("unset");

		if (!(GameTime() > NEXT_GLOAT))
			return;
		NEXT_GLOAT = GameTime() + FREQ_GLOAT;
		PlayAnim("critical", "idle2");
		OnSuspendMove(1.0f);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		OnStartCycles();
	}

	// cycle_npc
	void OnCycleNpc(string mode = "")
	{
		BaseNpcAttackNew_OnCycleNpc(mode); // monsters/base_npc_attack_new
		OnStartCycles();
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

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		CBaseEntity@ lastSeenNme = null;
		CallEventDelayed(0.1f, "npcatk_hunt");

		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;

		if (CanSee("enemy"))
			@lastSeenNme = EntityOf(ENT_LASTSEEN);

		if (NPCATK_TARGET == "unset")
			OnNpcatkSettarget(EntityId(lastSeenNme));

		if (RangeTo(NPCATK_TARGET) > RangeTo(lastSeenNme))
		{
			// favor closer player targets
			if (IsPlayer(lastSeenNme))
				OnNpcatkSettarget(EntityId(lastSeenNme));
		}

		if (NPCATK_TARGET != "unset")
		{
			NPC_MOVE_DEST = OriginOf(NPCATK_TARGET); // stay above target, hover front to back
			NPC_MOVE_DEST.z += 128.0f;
			float rndFb = Random(-128, 128);
			NPC_MOVE_DEST.x += rndFb;
		}
	}

	// game_heardsound
	// PARAM1: Sound type   2: Sound Origin   3: Danger radius
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (NPCATK_TARGET != "unset")
			return;

		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(ENT_ME, @lastHeard) != "enemy")
			return;
		OnNpcatkSettarget(NPCATK_TARGET);
	}

	// suspend_move
	void OnSuspendMove(float resumeDelay = 0.0f)
	{
		NO_MOVE = true;
		CallEventDelayed(resumeDelay, "resume_move");
	}

	// resume_move
	void OnResumeMove()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		NO_MOVE = false;
	}

	// npc_struck
	// called from base_npc_attack - param1 damage taken as of 22/Aug/2006 14:50
	void OnNpcStruck(float damage = 0.0f)
	{
		float myHealth = HealthOf(ENT_ME);

		if (myHealth >= MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN1);
		if (myHealth < MY_HURT_STAGE)
			PlayRandomSound(0, 10, SOUND_PAIN0, SOUND_PAIN0, SOUND_PAIN2);
	}

	// start_cycles
	void OnStartCycles()
	{
		if (CYCLES_ON)
			return;
		CYCLES_ON = true;
		CallEventDelayed(FREQ_CHAIN, "do_chain");
		CallEventDelayed(FREQ_BALLS, "do_balls");
		CallEventDelayed(FREQ_TORNADO, "do_tornado");

		if (!TELEPORT_ENABLED)
			return;
		CallEventDelayed(FREQ_TELEPORT, "do_teleport");
	}

	// do_chain
	void OnDoChain()
	{
		CallEventDelayed(FREQ_CHAIN, "do_chain");
		if (NPCATK_TARGET == "unset")
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < 2048.0f))
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		OnSuspendMove(2.0f);

		PlaySound(0, 10, SOUND_THUNDER_CHARGE);

		PlayAnim("critical", "tocharge");
		SetIdleAnim("charging");
		SetMoveAnim("charging");
		Vector3 targetOrg = OriginOf(NPCATK_TARGET);
		CHAIN_TARGETS = LegacyFunction("get_tsphere", "enemy", 1024, targetOrg);

		// first two beams go from hands to NPCATK_TARGET
		Effect("beam", "update", GetToken(BEAM_LIST, 0), "end_target", NPCATK_TARGET, 0);
		Effect("beam", "update", GetToken(BEAM_LIST, 1), "end_target", NPCATK_TARGET, 0);
		Effect("beam", "update", GetToken(BEAM_LIST, 0), "brightness", 200);
		Effect("beam", "update", GetToken(BEAM_LIST, 1), "brightness", 200);
		DoDamage(NPCATK_TARGET, "direct", DMG_CHAIN_DRAIN, "100%", ENT_ME, "lightning");
		ApplyEffect(NPCATK_TARGET, "effects/dot_lightning", 5, self, DMG_CHAIN_DOT);

		BEAM_STEP = 0.0f;
		CallEventDelayed(0.5f, "setup_beams");

		CallEventDelayed(2.0f, "clear_beams");
	}

	// setup_beams
	void OnSetupBeams()
	{
		DebugPrint("setup_beams stp " + Text(BEAM_STEP) + " targs " + CHAIN_TARGETS);

		BEAM_STEP += 1.0f;
		float curIdx = BEAM_STEP;
		if (!(curIdx < 5.0f))
			return;
		if (!(curIdx < GetTokenCount(CHAIN_TARGETS)))
			return;
		CallEventDelayed(0.25f, "setup_beams"); // keep setting up beams until you have 4 or are out of tokens
		float beamIdx = curIdx + 1.0f;
		CBaseEntity@ curBeam = FindEntity(GetToken(BEAM_LIST, int(curIdx)));
		CBaseEntity@ curTarget = FindEntity(GetToken(CHAIN_TARGETS, int(curIdx)));
		float prevIdx = curIdx - 1.0f;
		string prevTarget = GetToken(CHAIN_TARGETS, int(prevIdx));
		if (prevIdx == 0.0f)
			prevTarget = NPCATK_TARGET;

		Effect("beam", "update", @curBeam, "start_target", prevTarget, 0);
		Effect("beam", "update", @curBeam, "end_target", @curTarget, 0);
		Effect("beam", "update", @curBeam, "brightness", 200);
		ApplyEffect(curTarget, "effects/dot_lightning", 5, self, DMG_CHAIN_DOT);
		DoDamage(curTarget, "direct", DMG_CHAIN_DRAIN, "100%", ENT_ME, "lightning");
		CallExternal(curTarget, "ext_playsound_kiss", 0, 10, SOUND_THUNDER);
	}

	// clear_beams
	void OnClearBeams()
	{
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnClearBeamsLoop();
		}
	}

	// clear_beams_loop
	void OnClearBeamsLoop()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "brightness", 0);
	}

	// init_beam1
	// =========== BEAM INIT
	void OnInitBeam1()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 1, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
		DebugPrint("init_beam1 " + BEAM_ID);
		CallEventDelayed(0.1f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam2 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 1, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam3 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam4 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam5");
	}

	// init_beam5
	void OnInitBeam5()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam4 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam6");
	}

	// init_beam6
	void OnInitBeam6()
	{
		Effect("beam", "ents", "lgtning.spr", 60, ENT_ME, 2, ENT_ME, 0, Vector3(200, 200, 255), 0, 20, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam4 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
	}

	// do_balls
	void OnDoBalls()
	{
		CallEventDelayed(FREQ_BALLS, "do_balls");

		if (NPCATK_TARGET == "unset")
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < 2048.0f))
			return;

		if (0.0f == CYCLE_TIME_IDLE)
			return;

		BALL_TARGETS = TokenShuffle(LegacyFunction("get_tsphere", "enemy", 2048, MyOrigin()));

		if (!(GetTokenCount(BALL_TARGETS) > 0))
			return;

		PlayAnim("critical", "block");

		CreateNpc("monsters/summon/lightning_ball_guided", RelativePosition(Vector3(0, 64, 0)), self, DMG_BALL, 30.0f, 192, GetToken(BALL_TARGETS, 0));

		if (GetTokenCount(BALL_TARGETS) == 1)
		{
			// do three balls anyways
			CallEventDelayed(0.1f, "do_balls2");
			CallEventDelayed(0.2f, "do_balls3");
		}

		if (!(GetTokenCount(BALL_TARGETS) > 1))
			return;
		CallEventDelayed(0.1f, "do_balls2");

		if (!(GetTokenCount(BALL_TARGETS) > 2))
			return;
		CallEventDelayed(0.2f, "do_balls3");

		if (!(GetTokenCount(BALL_TARGETS) > 3))
			return;
		CallEventDelayed(0.3f, "do_balls4");
	}

	// do_balls2
	void OnDoBalls2()
	{
		CreateNpc("monsters/summon/lightning_ball_guided", RelativePosition(Vector3(0, -64, 0)), self, DMG_BALL, 30.0f, 192, GetToken(BALL_TARGETS, 1));
	}

	// do_balls3
	void OnDoBalls3()
	{
		CreateNpc("monsters/summon/lightning_ball_guided", RelativePosition(Vector3(64, 64, 0)), self, DMG_BALL, 30.0f, 192, GetToken(BALL_TARGETS, 2));
	}

	// do_balls4
	void OnDoBalls4()
	{
		CreateNpc("monsters/summon/lightning_ball_guided", RelativePosition(Vector3(-64, 64, 0)), self, DMG_BALL, 30.0f, 192, GetToken(BALL_TARGETS, 3));
	}

	// do_tornado
	void OnDoTornado()
	{
		CallEventDelayed(FREQ_TORNADO, "do_tornado");
		if (NPCATK_TARGET == "unset")
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;
		if (!(RangeTo(NPCATK_TARGET) < 2048.0f))
			return;

		PlayAnim("critical", "block");
		CreateNpc("monsters/summon/tornado", RelativePosition(Vector3(0, 72, 0)), self, 300, 20.0f);
	}

	// remove_beams_loop
	void OnRemoveBeamsLoop()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "remove", 0.1f);
	}

	// idle_sounds
	void OnIdleSounds()
	{
		float nextSound = Random(5, 15);

		CallEventDelayed(nextSound, "idle_sounds");

		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3);
	}

	// do_teleport
	void OnDoTeleport(string reason = "", string option = "")
	{
		bool teleCheck = false;
		bool teleFail = false;
		int count;
		// if can't see target, or target is very far, see if can safely teleport to
		if (!CanSee(NPCATK_TARGET))
			teleCheck = true;
		if (RangeTo(NPCATK_TARGET) > 1024.0f)
			teleCheck = true;

		DebugPrint("do_teleport " + Text(RangeTo(NPCATK_TARGET)) + " " + Text(teleCheck));

		if (!teleCheck) // no need, check later
			CallEventDelayed(FREQ_TELEPORT, "do_teleport");

		if (!teleCheck)
			return;

		Vector3 telePoint = OriginOf(NPCATK_TARGET);
		float rndAng = Random(0, 359.99f);
		telePoint += RelativePosition(Vector3(0, rndAng, 0), Vector3(0, 192, 34));

		Vector3 curPos = OriginOf(ENT_ME);
		SetOrigin(ENT_ME, telePoint);
		SetLocal("reg.npcmove.endpos", telePoint);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(-16, 0, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET);
		if (Float(Eval("game.ret.npcmove.dist")) <= 0.0f)
		{
			DebugPrint("do_teleport fail @ " + Text(telePoint));
			teleFail = true;
			SetOrigin(ENT_ME, curPos);
		}
		else
		{
			CallEventDelayed(FREQ_TELEPORT, "do_teleport");
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", telePoint, "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
			ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", curPos, "c-tele1.spr", 25, 2.0f, Vector3(255, 255, 255), 512, "magic/teleport.wav");
			// re init beams
			count = GetTokenCount(BEAM_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnRemoveBeamsLoop();
			}
			BEAM_LIST = "";
			CallEventDelayed(0.1f, "init_beam1");
		}

		if (!teleFail)
			return;
		CallEventDelayed(5.0f, "do_teleport"); // try again soon
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

	void OnFreqBalls() {} // FREQ_BALLS
	void OnFreqChain() {} // FREQ_CHAIN
	void OnFreqTeleport() {} // FREQ_TELEPORT
	void OnFreqTornado() {} // FREQ_TORNADO
	void OnNextSound() {} // NEXT_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/elementals_greater_flyer.mdl");
		CallEventDelayed(1.0f, "ElementalAir2_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ElementalAir2_FirstThink();
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
		if (name == "clear_beams") { OnClearBeams(); return true; }
		if (name == "clear_beams_loop") { OnClearBeamsLoop(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_balls") { OnDoBalls(); return true; }
		if (name == "do_balls2") { OnDoBalls2(); return true; }
		if (name == "do_balls3") { OnDoBalls3(); return true; }
		if (name == "do_balls4") { OnDoBalls4(); return true; }
		if (name == "do_chain") { OnDoChain(); return true; }
		if (name == "do_teleport") { OnDoTeleport(Param(params, 0), Param(params, 1)); return true; }
		if (name == "do_tornado") { OnDoTornado(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "init_beam5") { OnInitBeam5(); return true; }
		if (name == "init_beam6") { OnInitBeam6(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "remove_beams_loop") { OnRemoveBeamsLoop(); return true; }
		if (name == "resume_move") { OnResumeMove(); return true; }
		if (name == "setup_beams") { OnSetupBeams(); return true; }
		if (name == "start_cycles") { OnStartCycles(); return true; }
		if (name == "suspend_move") { OnSuspendMove(Float(Param(params, 0))); return true; }
		if (name == "ElementalAir2_Timer") { ElementalAir2_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
