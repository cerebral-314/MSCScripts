#pragma context server

// Converted from monsters/base_anti_stuck.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseAntiStuck
{
	// Constants
	float AS_MAX_ATTACK_TIME = 3.0f;
	float AS_STUCK_FREQ = 0.25f;
	float AS_WIGGLE_DURATION = 2.0f;
	int AS_TELE_THRESH = 10;
	int AS_CRITICAL_THRESH = 40;
	int AS_DIST_THRESH = 1;

	// Variables (an unset .script variable reads as its own name)
	float STUCK_COUNT = 0.0f;
	float AS_HITBACK_FRUST = 0.0f;
	float AS_UNSTUCK_ANG = 0.0f;
	float AS_IN_RANGE_CLICKS = 0.0f;
	float AS_MISS_COUNT = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	Vector3 AS_SPAWN_POINT = Vector3();
	string AS_MOVEPROX = "AS_MOVEPROX";
	bool AS_TELE_OUT = false;
	Vector3 AS_TELE_POINT = Vector3();
	bool NPC_FORCED_MOVEDEST = false;
	Vector3 AS_FLEE_POINT = Vector3();
	bool AS_STARTED = false;
	bool AS_LAST_POS_SET = false;
	float AS_NEXT_CHECK = 0.0f;
	bool AS_FIRST_STUCK = false;
	bool BAST_SPAWNCHECK = false;
	string AS_LAST_POS = "AS_LAST_POS";
	float AS_ATTACKING = 0.0f;
	float AS_LAST_HIT = 0.0f;
	float AS_HITBACK_FRUST_RUNS = 0.0f;
	float AS_LAST_STRIKE = 0.0f;
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool AS_CAN_MOVE = false;
	bool BAST_STUCK_DID_INIT = false;
	bool BAST_FIRST_TEST = false;
	float BAST_ROT = 0.0f;
	float BAST_FWD = 0.0f;
	float BAST_VFLOAT = 0.0f;
	Vector3 BAST_SPAWN_POS = Vector3();
	float BAST_MOB_HEIGHT_ADJ = 0.0f;
	string BAST_PLAYER_LIST = "BAST_PLAYER_LIST";
	bool BAST_TELEPORTING = false;
	bool BAST_DID_INIT = false;
	string BAST_TEST_PLAYER = "BAST_TEST_PLAYER";
	Vector3 L_TEST_POS_ADJ = Vector3();

	// npc_spawn
	// ============================================== STUCK INSIDE ALLY ON SPAWN
	void BaseAntiStuck_OnNpcSpawn(string npc = "")
	{
		STUCK_COUNT = 0.0f;
		AS_HITBACK_FRUST = 0.0f;
		AS_UNSTUCK_ANG = 0.0f;
		AS_IN_RANGE_CLICKS = 0.0f;
		AS_MISS_COUNT = 0.0f;
		if (Truthy(GetVar("I_R_PET")))
			NO_SPAWN_STUCK_CHECK = true;
		// if ( game.map.name equals skycastle ) setvard NO_SPAWN_STUCK_CHECK 1
		if (NO_SPAWN_STUCK_CHECK)
			return;
		AS_SPAWN_POINT = MyOrigin();
		CallEventDelayed(1.0f, "as_check_spawn_stuck");
	}

	// as_check_spawn_stuck
	void BaseAntiStuck_OnAsCheckSpawnStuck()
	{
		AS_MOVEPROX = Eval("game.monster.moveprox");

		// if $get(ent_me,movetype) == 4 //can't do fake moves on other movetypes
		// Thothie FEB2009 - allow spawn stuck check to be aborted by summons and the like
		if (NO_SPAWN_STUCK_CHECK)
			return;
	}

	// as_tell_allies_move
	void BaseAntiStuck_OnAsTellAlliesMove()
	{
		// dbg as_tell_allies_move
		string curTarg = GetToken("AS_ALLY_LIST", loopIteration);

		if (RelationshipOf(ENT_ME, curTarg) == "ally")
		{
			float asMoveprox = Float(AS_MOVEPROX);
			asMoveprox = Divide(asMoveprox, 3.0f);
			if (RangeTo(curTarg) < asMoveprox)
			{
				AS_TELE_OUT = true;
				// I've spawned inside an ally, tell him to move and blink out
				CallExternal(curTarg, "as_ally_stuck_so_move", AS_SPAWN_POINT);
			}
		}

		if (!NPC_NO_AUTO_ACTIVATE && IsPlayer(curTarg))
		{
			// spawned near a player, cycle up immediately
			OnCycleUp("spawned_near_player");
		}
	}

	// as_tele_out
	// <seconds> [(return_point)] teleport off map and return in PARAM1 secs
	void BaseAntiStuck_OnAsTeleOut(string seconds = "", string returnPoint = "")
	{
		if (returnPoint.isEmpty())
		{
			// no return origin provided, use current origin
			AS_TELE_POINT = OriginOf(ENT_ME);
		}
		else
		{
			AS_TELE_POINT = Vec(returnPoint);
		}
		// Tell nearby mobs to GTFO of my way, and hope they're gone by the time I get back
		float scanRange = Float(AS_MOVEPROX);
		scanRange *= 2.0f; // double my standard model reach
		// danger sound scares mobs away
		LegacyCommand("emitsound", ENT_ME, OriginOf(ENT_ME), AS_MOVEPROX, seconds, "danger", scanRange);
		SetOrigin(ENT_ME, Vector3(20000, 10000, -10000)); // waaaay off the map
		CallEventOrDelay(seconds, "as_tele_return");
	}

	// as_tele_return
	void BaseAntiStuck_OnAsTeleReturn()
	{
		DebugPrint("as_tele_return " + Text(AS_TELE_POINT));
		SetOrigin(ENT_ME, AS_TELE_POINT);
		CallEventDelayed(0.5f, "as_check_spawn_stuck"); // repeat, if needed
	}

	// as_ally_stuck_so_move
	void BaseAntiStuck_OnAsAllyStuckSoMove(Vector3 fleePoint = Vector3())
	{
		// dbg as_ally_stuck_so_move
		if (!Truthy(GetVar("SUSPEND_AI")))
			OnNpcatkSuspendAi("3.0", "allystuck");
		NPC_FORCED_MOVEDEST = true;
		Vector3 targetOrg = Vec(LegacyFunction("vec", AS_FLEE_POINT));
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		OnNpcatkSetmovedest(Text(RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 0))), "1");
		AS_FLEE_POINT = fleePoint;
		CallEventDelayed(0.1f, "as_flee_nudge");
	}

	// as_flee_nudge
	void BaseAntiStuck_OnAsFleeNudge()
	{
		// dbg as_flee_nudge AS_FLEE_POINT
		Vector3 targetOrg = Vec(LegacyFunction("vec", AS_FLEE_POINT));
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		int newYaw = int(targAng);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 200, 0)));
	}

	// npcatk_hunt
	// ============================================== STUCK WHILE NAVIGATING
	void BaseAntiStuck_OnNpcatkHunt()
	{
		if (!AS_STARTED)
		{
			// dont stuck check until at least 5 seconds post spawn
			float spawnTime = NPC_SPAWN_TIME + 5.0f;
			if (GameTime() > spawnTime)
				AS_STARTED = true;
		}
		else
		{
			OnNpcatkAntiStuck();
		}
	}

	// npcatk_anti_stuck
	// this will have to be called from the main think cycle
	void BaseAntiStuck_OnNpcatkAntiStuck()
	{
		string targCheck;
		bool inRange = false;
		bool exitSub = false;
		float gameTime = GameTime();
		// only stuck check so often
		if (!(gameTime > AS_NEXT_CHECK))
			return;

		if (Truthy(NO_STUCK_CHECKS))
		{
			AS_LAST_POS_SET = false;
			AS_NEXT_CHECK = gameTime + 3.0f;
		}

		if (Truthy(NO_STUCK_CHECKS))
			return;

		// set next stuck check time
		AS_NEXT_CHECK = gameTime + AS_STUCK_FREQ;

		if (!Truthy(GetVar("NEW_AI")))
			targCheck = GetVar("HUNT_LASTTARGET");
		else
			targCheck = NPCATK_TARGET;
		if (!IsAlive(targCheck))
			return;
		float targRange = RangeTo(NPCATK_TARGET);

		// have I attacked within the last 3 seconds
		float lastAtk = AS_ATTACKING + AS_MAX_ATTACK_TIME;

		if (targRange < ATTACK_HITRANGE)
		{
			inRange = true;
			AS_IN_RANGE_CLICKS += 1.0f;
		}
		else
		{
			AS_IN_RANGE_CLICKS = 0.0f;
		}

		// FEB2010_13 - In range, attacking, but can't reach, wiggle a bit
		if (AS_MISS_COUNT > 3.0f)
		{
			if (!Truthy(NPC_RANGED) && inRange && gameTime < lastAtk) // archers usually have internal meathod for this
			{
				DebugPrint("anti-stuck (can't reach)");

				OnChickenRun(1.0f);
				AS_MISS_COUNT = 0.0f;
			}
		}

		// otherwise, dont stuck check if doing attack anim
		if (!(gameTime > lastAtk))
			return;

		// dont stuck check if frozen, or under slowing influence
		if (I_R_FROZEN)
			return;

		// no stuck checking while fleeing or while AI suspended
		if (Truthy(GetVar("IS_FLEEING")))
			return;
		if (Truthy(GetVar("SUSPEND_AI")))
			return;

		// dont stuck check if teled out
		if (NPC_WINKED_OUT)
			return;

		// dont stuck check if dead
		if (!IsAlive(ENT_ME))
			return;

		// dont stuck check if in attack range or move range (thothie JAN2009)
		if (!Truthy(NPC_RANGED)) // Thothie FEB2009 - unless you are an archer, and thus have a huge move range
		{
			if (IsAlive(NPCATK_TARGET))
			{
				if (targRange < ATTACK_RANGE)
					exitSub = true;
				if (targRange < Float(GetVar("ATTACK_MOVERANGE")))
					exitSub = true;
			}
			if (!exitSub) {}
		}
		else
		{
			// FEB2009_16 - ranged folks don't anti-stuck if they can see their target
			if (Truthy(GetVar("NPC_CANSEE_TARGET")))
				exitSub = true;
		}
		if (exitSub)
			return;

		Vector3 myOrg = OriginOf(ENT_ME);

		// dont stuck check if I am within my movedest's range
		if (!(Distance(myOrg, Vec(Eval("game.monster.movedest.origin"))) >= Float(Eval("game.monster.movedest.prox"))))
			return;

		if (Distance(Vec(AS_LAST_POS), myOrg) < AS_DIST_THRESH)
		{
			// Stuck, add to stuck count and do wiggle
			if (AS_LAST_POS_SET)
			{
				DebugPrint("anti-stuck (no progress)");
				STUCK_COUNT += 1.0f;
				if (STUCK_COUNT >= 1.0f)
				{
					if (!AS_FIRST_STUCK)
					{
						// first time I've been stuck, try tele method, probably spawn stuck
						// (we'd do this on spawn, but seems that's a bit resource intensive.)
						DebugPrint("base_anti_stuck - first stuck");
						AS_FIRST_STUCK = true;

						Vector3 org = OriginOf(ENT_ME);
						string testpos = Text(org);
						SetOrigin(ENT_ME, Vec(testpos));
						SetLocal("reg.npcmove.endpos", testpos);
						LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 16, 0)));
						SetLocal("reg.npcmove.testonly", 1);
						NpcMove(ENT_ME);
						if (Float(Eval("game.ret.npcmove.dist")) == 0.0f)
						{
							// fake move failed, do tele stuck sequence
							BAST_SPAWNCHECK = true;
							OnAsTeleStuckCheck();
						}
						exitSub = true;
					}
					if (!exitSub)
					{
						if (Truthy(GetVar("AS_CUSTOM_UNSTUCK")))
							OnNpcStuck();
						else
							OnChickenRun(Random(0.5f, 1));
					}
				}
			}
		}
		else
		{
			// if ( !SUSPEND_AI ) callevent npcatk_suspend_ai AS_WIGGLE_DURATION wiggle
			// setvard NPC_FORCED_MOVEDEST 1
			// local MOVE_DEST MY_ORG
			// add AS_UNSTUCK_ANG 36
			// if ( AS_UNSTUCK_ANG > 359 ) subtract AS_UNSTUCK_ANG 359
			// //dbg npcatk_anti_stuck stuck_count STUCK_COUNT ang AS_UNSTUCK_ANG
			// vectoradd MOVE_DEST $relpos($vec(0,AS_UNSTUCK_ANG,0),$vec(0,1000,0))
			// callevent npcatk_setmovedest MOVE_DEST AS_MOVEPROX //I'd love to have them trace along a wall, but I can't figure how to pull that.
			// playanim once ANIM_RUN
			// Not stuck, reset stuck counter
			STUCK_COUNT = 0.0f;
		}

		AS_LAST_POS = Text(myOrg); // store position for next check
		AS_LAST_POS_SET = true;

		// second to last resort, wink out and hope whatever's blocking me is gone when I get back
		if (STUCK_COUNT == AS_TELE_THRESH)
		{
			DebugPrint("anti-stuck (tele)");
			if (!Truthy(GetVar("I_R_PET")))
				OnExtWinkOut(myOrg, Random(4, 5));
			STUCK_COUNT += 1.0f;
		}

		// last resort, tele home
		if (!(STUCK_COUNT >= AS_CRITICAL_THRESH))
			return;
		DebugPrint("anti-stuck (critical!) tele home");
		if (!Truthy(GetVar("I_R_PET")))
			OnExtWinkOut(NPC_SPAWN_LOC, Random(4, 5));
		STUCK_COUNT = 0.0f;
	}

	// npc_selectattack
	// { npcatk_suspend_ai
	// setvard AS_LAST_POS_SET 0
	// setvard AS_RESUSPEND 1
	// }
	// { npcatk_resume_ai
	// setvard AS_LAST_POS_SET 0
	// setvard AS_RESUSPEND 0
	// }
	// //JAN2011_13 Seperate Suspend AI routine to avoid conflicts
	// { as_npcatk_suspend_ai
	// if !SUSPEND_AI
	// setvard SUSPEND_AI 1
	// callevent PARAM1 as_npcatk_resume_ai
	// }
	// { as_npcatk_resume_ai
	// //if ( !AS_RESUSPEND )
	// //{
	// if game.time > NPC_RESUME_AI_TIME
	// setvard SUSPEND_AI 0
	// //}
	// }
	void BaseAntiStuck_OnNpcSelectattack()
	{
		AS_ATTACKING = GameTime();
	}

	// game_dynamically_created
	// SEP2009_23 - Thothie - Adding this to prevent summons from spawn stuck checking against nearby masters
	void BaseAntiStuck_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		NO_SPAWN_STUCK_CHECK = true;
	}

	// game_damaged_other
	string BaseAntiStuck_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		AS_LAST_HIT = GameTime();
		AS_MISS_COUNT = 0.0f;
		return result;
	}

	// game_dodamage
	string BaseAntiStuck_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (Truthy(NO_STUCK_CHECKS))
			return result;
		if (Truthy(GetVar("SUSPEND_AI")))
			return result;
		if (!hit)
		{
			AS_MISS_COUNT += 1.0f;
		}
		else
		{
			AS_MISS_COUNT = 0.0f;
			AS_HITBACK_FRUST = 0.0f;
			AS_HITBACK_FRUST_RUNS = 0.0f;
		}
		AS_LAST_STRIKE = GameTime();
		return result;
	}

	// game_damaged
	string BaseAntiStuck_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (Truthy(NO_STUCK_CHECKS))
			return result;
		if (Truthy(GetVar("SUSPEND_AI")))
			return result;
		if (GameTime() > AS_ATTACKING && GameTime() > NEXT_HITFRUST_RECORD)
		{
			NEXT_HITFRUST_RECORD = GameTime() + 1.0f; // max 1/second
			AS_HITBACK_FRUST += 1.0f;
		}

		if (AS_HITBACK_FRUST >= 7.0f)
		{
			float lsPlus5 = AS_LAST_STRIKE + 5.0f;
			if (GameTime() > AS_LAST_STRIKE)
			{
				AS_HITBACK_FRUST = 0.0f;
				AS_HITBACK_FRUST_RUNS += 1.0f;
				float maxRunTime = 3.0f * AS_HITBACK_FRUST_RUNS;
				OnChickenRun(Random(1, maxRunTime));
				DebugPrint("anti-stuck (hitback frust)");
			}
		}
		return result;
	}

	// game_stuck
	void BaseAntiStuck_OnGameStuck()
	{
		DebugPrint("game_stuck");
		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		PlaySound(0, 10, "amb/quest1.wav");
	}

	// npcatk_setmovedest
	void BaseAntiStuck_OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		// (never true here, the rest is skipped) if NPC_NO_AI
	}

	// as_check_can_move
	void BaseAntiStuck_OnAsCheckCanMove()
	{
		AS_CAN_MOVE = false;

		SetLocal("reg.npcmove.endpos", OriginOf(ENT_ME));
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 2)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) > 0.0f)
			AS_CAN_MOVE = true;
		if (AS_CAN_MOVE)
			return;
		// try another direction
		SetLocal("reg.npcmove.endpos", OriginOf(ENT_ME));
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 2, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) > 0.0f)
			AS_CAN_MOVE = true;
		if (AS_CAN_MOVE)
			return;
		// try another direction
		SetLocal("reg.npcmove.endpos", OriginOf(ENT_ME));
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 2)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) > 0.0f)
			AS_CAN_MOVE = true;
		if (AS_CAN_MOVE)
			return;
		// try another direction
		SetLocal("reg.npcmove.endpos", OriginOf(ENT_ME));
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -2)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) > 0.0f)
			AS_CAN_MOVE = true;
		if (AS_CAN_MOVE)
			return;
		// try another direction
		SetLocal("reg.npcmove.endpos", OriginOf(ENT_ME));
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, -2, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		LegacyCommand("npcmove", ENT_ME, NPCATK_TARGET); // be nice if I actually knew what this second param was supposed to be
		if (Float(Eval("game.ret.npcmove.dist")) > 0.0f)
			AS_CAN_MOVE = true;
		if (AS_CAN_MOVE)
			return;
	}

	// game_dynamically_created
	// ============================================== Teleporting Stuck Check
	// dynamic unstuckary for summoned mobs who might end up in walls (call from game_dynamically_created, if needed)
	// keeps spinning otuward, until a position where the critter is not stuck is found
	void BaseAntiStuck_OnGameDynamicallyCreated_2(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		if (!Truthy(GetVar("AS_SUMMON_TELE_CHECK")))
			return;
		OnAsTeleStuckCheck();
	}

	// as_tele_stuck_check
	void BaseAntiStuck_OnAsTeleStuckCheck()
	{
		if (!BAST_STUCK_DID_INIT)
		{
			BAST_STUCK_DID_INIT = true;
			BAST_FIRST_TEST = true;
			BAST_ROT = 0.0f;
			BAST_FWD = 0.0f;
			BAST_VFLOAT = 0.0f;
			BAST_SPAWN_POS = OriginOf(ENT_ME);

			if (Truthy(GetProp(ENT_ME, "fly")))
			{
				// fliers measure from center
				BAST_MOB_HEIGHT_ADJ = HeightOf(ENT_ME) * 1.1f;
			}
		}
		Vector3 testpos = BAST_SPAWN_POS;
		float vadj = BAST_MOB_HEIGHT_ADJ + BAST_VFLOAT;
		testpos += RelativePosition(Vector3(0, BAST_ROT, 0), Vector3(0, BAST_FWD, BAST_VFLOAT));
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string testposAdj = Text(testpos);
			testposAdj = Text(Vec(testposAdj) + Vector3(0.0f, 0.0f, 32.0f));
			Effect("beam", "point", "lgtning.spr", 20, testpos, testposAdj, Vector3(255, 0, 255), 200, 0, 0.1f);
		}
		SetOrigin(ENT_ME, testpos);
		SetLocal("reg.npcmove.endpos", testpos);
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, 0, 0), Vector3(0, 16, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		NpcMove(ENT_ME);
		if (Float(Eval("game.ret.npcmove.dist")) == 0.0f)
		{
			// if ( $get(ent_me,fly) )
			// {
			// setvard BAST_WAS_FLIER 1
			// fly 0 //this check cannot be performed on fliers
			// }
			DebugPrint("as_tele_stuck_check stuck @ " + Text(BAST_FWD) + " " + Text(BAST_MOB_HEIGHT_ADJ) + " " + Text(testpos));
			BAST_ROT += 15.0f;
			BAST_FWD += 4.0f;
			BAST_VFLOAT += 2.0f;
			if (BAST_VFLOAT > 64.0f)
				BAST_VFLOAT = -64.0f;
			if (BAST_ROT > 359.0f)
				BAST_ROT = 0.0f;
			SetOrigin(ENT_ME, BAST_SPAWN_POS);
			if (BAST_FWD < 640.0f)
			{
				BAST_FIRST_TEST = false;
				CallEventDelayed(0.1f, "as_tele_stuck_check");
			}
			else
			{
				// fuck this shit, try method 2
				if (BAST_SPAWNCHECK)
				{
					// surrender, dont want to tele to random players on spawn
					BAST_SPAWNCHECK = false;
					return;
				}
				BAST_STUCK_DID_INIT = false;
				BAST_PLAYER_LIST = "BAST_PLAYER_LIST"; // clear player list, case new ones show up, been a bit
				OnAsTeleToPlayerLoop();
			}
		}
		else
		{
			// if ( BAST_WAS_FLIER ) fly 1
			BAST_STUCK_DID_INIT = false;
			STUCK_COUNT = 0.0f; // think we're free
			if (!BAST_FIRST_TEST) // wasn't stuck to begin with
				SetOrigin(ENT_ME, testpos);
		}
	}

	// as_tele_to_player_loop
	void BaseAntiStuck_OnAsTeleToPlayerLoop(string player = "")
	{
		bool exitSub = false;
		// should method 1 fail, teleport near player - also general function for teleport hunters
		BAST_TELEPORTING = true;
		if (PlayerCount() == 0)
		{
			// well shit, I'm boned, wait for a player to show up, I guess
			DebugPrint("as_tele_to_player_loop noplayers");
			CallEventDelayed(20.0f, "as_tele_to_player_loop");
			BAST_DID_INIT = false;
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!BAST_DID_INIT)
		{
			DebugPrint("as_tele_to_player_loop init");
			BAST_DID_INIT = true;
			BAST_SPAWN_POS = OriginOf(ENT_ME);
			if (player.isEmpty())
			{
				BAST_PLAYER_LIST = GetPlayers();
				BAST_PLAYER_LIST = SortEntities(BAST_PLAYER_LIST, "range");
				BAST_TEST_PLAYER = GetToken(BAST_PLAYER_LIST, 0);
			}
			else
			{
				BAST_TEST_PLAYER = player;
			}

			if (Truthy(GetProp(ENT_ME, "fly")))
			{
				// fliers measure from center
				BAST_MOB_HEIGHT_ADJ = HeightOf(ENT_ME) * 1.1f;
			}

			DebugPrint("as_tele_to_player_loop init selecttarget " + NameOf(player));
		}

		// pick area randomly around target
		BAST_ROT += 5.0f;
		if (BAST_ROT > 359.0f)
			BAST_ROT = 0.0f;
		if (NPC_TELEHUNT)
			BAST_ROT = Random(0, 359.99f);
		float dist = WidthOf(ENT_ME) * 2.0f;
		if (dist < 48.0f) // at least be sure we cleared plr bounding box, if we're very small
			dist = 48.0f;
		if (NPC_TELEHUNT && Truthy(NPC_RANGED))
		{
			// dbg as_tele_to_player_loop ranged
			if (Truthy(GetVar("NPC_BATTLE_ALLY")))
			{
				if (IsPlayer(BAST_TEST_PLAYER)) // dun wanna be far from allies
					exitSub = true;
			}
			if (!exitSub)
			{
				dist = Random(384, 768); // wanna be pretty far from enemies
			}
		}
		Vector3 telePoint = OriginOf(BAST_TEST_PLAYER);
		telePoint += RelativePosition(Vector3(0, BAST_ROT, 0), Vector3(0, dist, BAST_MOB_HEIGHT_ADJ));
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			string telePointAdj = Text(telePoint);
			L_TEST_POS_ADJ.z += 64.0f;
			Effect("beam", "point", "lgtning.spr", 20, telePoint, telePointAdj, Vector3(255, 0, 255), 200, 0, 0.1f);
		}
		SetOrigin(ENT_ME, telePoint);
		SetLocal("reg.npcmove.endpos", telePoint);
		float myAng = AnglesOf(ENT_ME).y;
		LegacyCommand("vectoradd", "reg.npcmove.endpos", RelativePosition(Vector3(0, myAng, 0), Vector3(-16, 0, 0)));
		SetLocal("reg.npcmove.testonly", 1);
		NpcMove(ENT_ME);
		if (Float(Eval("game.ret.npcmove.dist")) == 0.0f)
		{
			// position failed, go back to where I was, try again next think
			DebugPrint("as_tele_to_player_loop stuck @ " + NameOf(BAST_TEST_PLAYER) + " " + Text(dist) + " " + Text(BAST_MOB_HEIGHT_ADJ) + " " + Text(telePoint));
			SetOrigin(ENT_ME, BAST_SPAWN_POS);

			if (!IsAlive(BAST_TEST_PLAYER))
			{
				BAST_DID_INIT = false;
				if (NPC_TELEHUNT)
				{
					BAST_TELEPORTING = false;
					exitSub = true; // target's no longer valid, quit trying
				}
			}
			if (!exitSub)
				CallEventDelayed(0.1f, "as_tele_to_player_loop");
		}
		else
		{
			// if ( BAST_WAS_FLIER ) fly 1
			DebugPrint("as_tele_to_player_loop success, exiting");
			STUCK_COUNT = 0.0f; // think we're free
			BAST_DID_INIT = false;
			BAST_TELEPORTING = false;
			SetOrigin(ENT_ME, telePoint);
			if (NPC_TELEHUNTER_FX != 0)
			{
				if (NPC_TELEHUNTER_FX == 1)
				{
					float scale1 = HeightOf(ENT_ME);
					if (scale1 > 256.0f)
						scale1 = 256.0f;
					float scaleRatio = scale1;
					string scaleRatioText;
					scaleRatio = Divide(scaleRatio, 256.0f);
					scaleRatioText = Text(scaleRatio);
					scale1 = Ratio(scaleRatio, 0.5f, 3);
					float scale2 = Ratio(scaleRatio, 1, 6);
					float lightRad1 = Ratio(scaleRatio, 64, 256);
					float lightRad2 = Ratio(scaleRatio, 128, 512);

					DebugPrint("as_tele_to_player_loop " + scaleRatioText);

					ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", BAST_SPAWN_POS, "xflare1.spr", 20, scale1, Vector3(255, 255, 255), lightRad1, "magic/teleport.wav");
					ClientEvent("new", "all", "effects/sfx_sprite_in_fancy", OriginOf(ENT_ME), "xflare1.spr", 20, scale2, Vector3(255, 255, 255), lightRad2, "magic/spawn.wav");
				}
				else if (NPC_TELEHUNTER_FX == 2)
				{
				}
				else
				{
					// sorc effect (todo)
					if (NPC_TELEHUNTER_FX > 2)
					{
						// custom effect
						OnNpcTeleportFx();
					}
				}
			}
			else
			{
				PlaySound(0, 10, "magic/spawn.wav");
			}
			OnNpcatkSettarget(BAST_TEST_PLAYER);
			OnNpcTeleported();
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnNpcSpawn(string npc = "") { BaseAntiStuck_OnNpcSpawn(npc); } // npc_spawn
	void OnAsCheckSpawnStuck() { BaseAntiStuck_OnAsCheckSpawnStuck(); } // as_check_spawn_stuck
	void OnAsTellAlliesMove() { BaseAntiStuck_OnAsTellAlliesMove(); } // as_tell_allies_move
	void OnAsTeleOut(string seconds = "", string returnPoint = "") { BaseAntiStuck_OnAsTeleOut(seconds, returnPoint); } // as_tele_out
	void OnAsTeleReturn() { BaseAntiStuck_OnAsTeleReturn(); } // as_tele_return
	void OnAsAllyStuckSoMove(Vector3 fleePoint = Vector3()) { BaseAntiStuck_OnAsAllyStuckSoMove(fleePoint); } // as_ally_stuck_so_move
	void OnAsFleeNudge() { BaseAntiStuck_OnAsFleeNudge(); } // as_flee_nudge
	void OnNpcatkHunt() { BaseAntiStuck_OnNpcatkHunt(); } // npcatk_hunt
	void OnNpcatkAntiStuck() { BaseAntiStuck_OnNpcatkAntiStuck(); } // npcatk_anti_stuck
	void OnNpcSelectattack() { BaseAntiStuck_OnNpcSelectattack(); } // npc_selectattack

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnGameStuck() { BaseAntiStuck_OnGameStuck(); } // game_stuck
	void OnNpcatkSetmovedest(string destination = "", string range = "") { BaseAntiStuck_OnNpcatkSetmovedest(destination, range); } // npcatk_setmovedest
	void OnAsCheckCanMove() { BaseAntiStuck_OnAsCheckCanMove(); } // as_check_can_move
	void OnAsTeleStuckCheck() { BaseAntiStuck_OnAsTeleStuckCheck(); } // as_tele_stuck_check
	void OnAsTeleToPlayerLoop(string player = "") { BaseAntiStuck_OnAsTeleToPlayerLoop(player); } // as_tele_to_player_loop
	void OnChickenRun(float duration = 0.0f) {} // chicken_run
	void OnCycleUp(string reason = "") {} // cycle_up
	void OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f) {} // ext_wink_out
	void OnNpcStuck() {} // npc_stuck
	void OnNpcTeleportFx() {} // npc_teleport_fx
	void OnNpcTeleported() {} // npc_teleported
	void OnNpcatkSettarget(string target = "", string debug = "") {} // npcatk_settarget
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool BaseAntiStuck_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "as_ally_stuck_so_move") { OnAsAllyStuckSoMove(Vec(Param(params, 0))); return true; }
		if (name == "as_check_can_move") { OnAsCheckCanMove(); return true; }
		if (name == "as_check_spawn_stuck") { OnAsCheckSpawnStuck(); return true; }
		if (name == "as_flee_nudge") { OnAsFleeNudge(); return true; }
		if (name == "as_tele_out") { OnAsTeleOut(Param(params, 0), Param(params, 1)); return true; }
		if (name == "as_tele_return") { OnAsTeleReturn(); return true; }
		if (name == "as_tele_stuck_check") { OnAsTeleStuckCheck(); return true; }
		if (name == "as_tele_to_player_loop") { OnAsTeleToPlayerLoop(Param(params, 0)); return true; }
		if (name == "as_tell_allies_move") { OnAsTellAlliesMove(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_stuck") { OnGameStuck(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_anti_stuck") { OnNpcatkAntiStuck(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_anti_stuck"]
shared class BaseAntiStuckScript : ScriptEntity, BaseAntiStuck
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	bool AM_FLANKING = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	float BMS_RENDERAMT = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	int DEF_STEP_SIZE = 0;
	bool DEMON_BLOOD = false;
	bool DID_HELP_TIP = false;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string DUMP_ARRAY_CALLER = "DUMP_ARRAY_CALLER";
	bool DUMP_ARRAY_GLOBAL = false;
	string DUMP_ARRAY_NAME = "DUMP_ARRAY_NAME";
	bool EFFECT_DAMAGE_DELAY = false;
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	float FD_LOOP_COUNT = 0.0f;
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	bool FREEZE_WAS_SUSPEND = false;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	bool HAS_INCLUDE_NPC = false;
	bool HIT_BY_MANABALL = false;
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IMMUNE_VAMPIRE = false;
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool I_R_FROZEN = false;
	float LAST_STRUCK_FOR = 0.0f;
	float MAKE_NOISE = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_WIDTH = 0;
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	string NEW_NAME = "NEW_NAME";
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	bool NO_STEP_ADJ = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "NPC_ADJ_DMG_MUTLI_TOKENS";
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	string NPC_ADJ_HP_MUTLI_TOKENS = "NPC_ADJ_HP_MUTLI_TOKENS";
	float NPC_ADJ_LEVEL = 0.0f;
	string NPC_ADJ_TIERS = "NPC_ADJ_TIERS";
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	CBaseEntity@ NPC_ALLY_TO_AID = null;
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_MISS = false;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
	float NPC_DIE_NT_BASE = 0.0f;
	bool NPC_DIE_NT_FIRST_RUN = false;
	float NPC_DIE_NT_NEXT_CHECK = 0.0f;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	float NPC_DMG_MULTI = 0.0f;
	bool NPC_DOT_COLD = false;
	float NPC_DOT_COLD_RATIO = 0.0f;
	bool NPC_DOT_FIRE = false;
	float NPC_DOT_FIRE_RATIO = 0.0f;
	bool NPC_DOT_LIGHTNING = false;
	float NPC_DOT_LIGHTNING_RATIO = 0.0f;
	bool NPC_DOT_POISON = false;
	float NPC_DOT_POISON_RATIO = 0.0f;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	float NPC_DO_ON_DIE = 0.0f;
	float NPC_DO_ON_SPOT = 0.0f;
	bool NPC_DO_SPAWN_SOUND = false;
	bool NPC_DUMP_XP = false;
	float NPC_EVENT_COUNTER = 0.0f;
	float NPC_EXP_FINAL = 0.0f;
	float NPC_EXP_REDUCT = 0.0f;
	int NPC_FADEIN_RATE = 0;
	bool NPC_FADEIN_SET = false;
	float NPC_FADE_IN_SPEED = 0.0f;
	bool NPC_FIGHTS_NPCS = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_GOING_HOME = false;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HEIGHT = 0.0f;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_IGNORE_PLAYERS = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	bool NPC_MADE_IT_HOME = false;
	float NPC_MAXHP = 0.0f;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool NPC_MOVEMENT_SUSPENDED = false;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
	float NPC_NEXT_RHOME_WIGGLE = 0.0f;
	int NPC_NO_AGRO = 0;
	bool NPC_NO_ATTACK = false;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_OLD_ANIM_IDLE = "NPC_OLD_ANIM_IDLE";
	string NPC_OLD_ANIM_RUN = "NPC_OLD_ANIM_RUN";
	string NPC_OLD_ANIM_WALK = "NPC_OLD_ANIM_WALK";
	string NPC_OLD_ROAM = "NPC_OLD_ROAM";
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROX_LOOP = false;
	bool NPC_QUED_FOR_DEATH = false;
	string NPC_RANGED = "NPC_RANGED";
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETURNING_HOME = false;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	Vector3 NPC_SPAWN_ANGLES = Vector3();
	Vector3 NPC_SPAWN_LOC = Vector3();
	float NPC_SPAWN_TIME = 0.0f;
	int NPC_SPRITE_IN = 0;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_WAS_IN_BATTLE = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	int OLD_NO_STUCK_CHECKS = 0;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_DEATH = "SOUND_DEATH";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseAntiStuck_DispatchEvent(name, params);
	}
}
