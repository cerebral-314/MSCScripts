#pragma context server

// Converted from monsters/base_npc_attack_new.script by msc_transpiler.
// Thothie - Sick of this, starting over from scratch
// - This is not 100% backwards compatible, rather it is intended for future monsters where I dun wanna deal with the old stuff
// - Total overhaul on this one
// Definitions required:
// ANIM_RUN  [setvar] def run anim
// ANIM_ATTACK [servard] def attack anim
// NPC_NO_ATTACK [any] defaults to 0, set to prevent monster automatically playing attack anim when within ATTACK_RANGE of target
// ATTACK_MOVERANGE [setvard] how close try to get, defaults to monster width (should < ATTACK_RANGE)
// - you'll see this as MOVE_RANGE in the script in some places, due to possibility of ATTACK_MOVERANGE being preserved but the vars are mirrored
// ATTACK_RANGE [setvard] how close need to swing, defaults to monster width x3 (should < ATTACK_HITRANGE). If target is above/below monster, monster will substitute with ATTACK_HITRANGE to extend reach.
// ATTACK_HITRANGE [setvard] how close need to actually hit, defaults to monster width x4 ( must > ATTACK_RANGE )
// MONSTER_WIDTH [setvard] cannot be automatically calculated on models without a bounding box (rare)
// FLEE_HEALTH [any] def 0 (ie. won't flee from dmg)
// FLEE_CHANCE [any] def unset (effective 0) - chance of fleeing when struck and health below FLEE_HEALTH
// FLEE_STUCKCHECK_FREQ [setvard] def 0.2 - raise for slow running mons
// FLEE_DISTANCE [setvard] def 1000 - max distance to flee when fleeing for low health
// FLEE_TIME [setvard] def 10.0 - max time to flee when fleeing for low health
// CANT_FLEE [any] def unset (effective 0) - won't flee, even if in danger from volcano, etc.
// CAN_HEAR [setvard] def 1
// CAN_RETALIATE [setvard] def 1 - can change targets in favor of agressor
// RETALIATE_CHANCE [setvard] def 75 - chance of changing target in favor of agressor
// CAN_FLINCH [setvard] def 0 - can flinch from damage
// FLINCH_ANIM [setvard] anim to play when flinching (Can also set through ANIM_FLINCH)
// FLINCH_CHANCE [any] % chance to flinch when struck for at least:
// FLINCH_DAMAGE_THRESHOLD [servard] this much damage, def 10% of monster hp
// FLINCH_DELAY [setvard] delay between flinches, def 5.0
// FLINCH_HEALTH [servard] no flinching until less than this amount of health (def maxhp)
// HEAR_RANGE_MAX [servard] (def: 1024) hearingsensitivity is hard to predict, this lets you set how close something must be to be "heard"
// HEAR_RANGE_PLAYER [servard] (def: 800) you can adjust this to make it more or less sensitive to players, usually set lower so monsters dont cycle up for no reason
// NPC_MUST_SEE_TARGET [servard] (def: 1) set to 0 and monster will always attack when within range, regardless if it can see target
// - This is useful if the monster is so tall that he may need to strike over the heads of other monsters to reach his opponents
// - You must also use direct damage in this case, as traceline dodamage will not pass through minions
// NO_VICTORY_HEAL [any] (def unset, effective 0) do not heal self after slaying player
// useful called events:
// npcatk_hunt - goes off every think cycle
// cycle_up - called when player first spotted
// cycle_down - called when monster calms after losing or slaying player
// my_target_died - called when monster slays target
// npc_targetsighted - fires every think cycle a target is in sight
// npc_selectattack - fires every think cycle target is in range (just before playing def attack anim, so you can change it here)
// npcatk_setmovedest <target|origin> <range> - called every time AI sets a destination
// useful executable events:
// npcatk_flee <target> <max_distance> <duration> - run away from <target>
// chicken_run <duration> - flees in random random dir for <duration> seconds
// npcatk_suspend_ai [duration] - suspend ai (no hunting, internal attacking, or stuck checks)
// npcatk_resume_ai - resume ai
// npcatk_settarget <target> - targets <target> if valid
// npcatk_setmovedest <target|origin> <range> - Move close to specific target or origin
// useful flags:
// CANT_DAMAGE 1 - suspends ability to damage (useful for playin dead)
// CANT_TURN 1 - disables all facetarget calls
// NPC_IGNORE_PLAYERS 1 - ignores players until struck, but is still agro vs. npcs (good for siege maps)
// PLAYING_DEAD 1 - invalidates this target for other monsters
// NPC_NO_MOVE 1 - stops npc from using npcatk_setmovedest (but will continue to last destination)
// status flags:
// IS_FLEEING - Is fleeing
// SUSPEND_AI - AI suspended
// NPC_HUNTING_BLIND - Cant see target, moving to last seen position
// Planned:
// NPC_PATROL - patrols around spawn
// NPC_PATROL_RANGE - max distance he will roam from spawn
// NPC_PATROL_CHASERANGE - max distance he will chase a target from spawn before going home
// major changes:
// JUL2007a did away with NPC_MOVING_LAST_KNOWN - monster now always moves to last seen position

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNpcAttackNew
{
	// Constants
	int NPC_FRUST_THRESHOLD = 4;
	float MAX_ADV_SEARCHTIME = 45.0f;
	float HACK_ATTACK_DELAY = 1.0f;
	float HACK_DAMAGE_DELAY = 0.1f;
	int NPC_WANDER_RANGE = 1024;
	float NPC_SPAWN_PRED1 = 0.5f;
	float NPC_SPAWN_PRED2 = 0.75f;
	float CYCLE_TIME_BATTLE = 0.1f;
	float CYCLE_TIME_IDLE = 2.0f;
	float CYCLE_TIME_NPC = 0.8f;
	string NPC_RANGE_TYPE = "range";
	float NPC_DELAY_RETALITATE = 0.0f;

	// Variables (an unset .script variable reads as its own name)
	bool HAS_AI = true;
	bool NEW_AI = false;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	string NPC_MOVEPROX = "NPC_MOVEPROX";
	float NPC_DBL_MOVEPROX = 0.0f;
	string CYCLE_TIME = "CYCLE_TIME";
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string CHASE_RANGE = "CHASE_RANGE";
	int NPC_CHASE_RANGE = 0;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string FLINCH_ANIM = "FLINCH_ANIM";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float FLEE_TIME = 0.0f;
	float FLEE_STUCKCHECK_FREQ = 0.0f;
	bool IS_FLEEING = false;
	bool HAVE_TARGET = false;
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool SEARCH_ROTATION = false;
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	string NPC_LOST_TARGET = "NPC_LOST_TARGET";
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	int MONSTER_ID = 0;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HEIGHT = 0.0f;
	float NPC_HALF_WIDTH = 0.0f;
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	float FLINCH_HEALTH = 0.0f;
	float FLINCH_DMG_REQ = 0.0f;
	int MONSTER_WIDTH = 0;
	float ATTACK_MOVERANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string NPC_RANGED = "NPC_RANGED";
	float NPC_MAX_RANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float NPC_CLOSEIN_RANGE = 0.0f;
	Vector3 NPC_LAST_ORIGIN = Vector3();
	float NPC_STORE_HP = 0.0f;
	float ORIG_MOVERANGE = 0.0f;
	bool NPC_CANSEE_TARGET = false;
	bool NPC_COULD_SEE_TARGET = false;
	bool NPC_HUNTING_BLIND = false;
	bool NPC_VADJSTING = false;
	bool NPC_ROAMING_HOME = false;
	bool CYCLED_UP = false;
	bool HUNTING_PLAYER = false;
	bool IS_HUNTING = false;
	string ENTITY_ENEMY = "ENTITY_ENEMY";
	bool NPC_HAS_TARGET = false;
	bool NPC_FORCED_MOVEDEST = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	bool NPC_STUCK_TELEPORT = false;
	int ATTACK_ANIMINDEX = 0;
	bool HACK_DELAYING_ATTACK = false;
	string FLEE_TARGET = "FLEE_TARGET";
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";
	int FLEE_STUCK_COUNT = 0;
	Vector3 FLEESTUCK_OLDPOS = Vector3();
	bool RE_FLEE_DELAY = false;
	bool CHICKEN_RUN = false;
	float CKN_STUCK_COUNTER = 0.0f;
	int FLEE_DIR = 0;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	CBaseEntity@ I_HEARD = null;
	bool HEARD_VERIFY = false;
	bool HEARD_PLAYER = false;
	float NPC_NEXT_RETALITATE = 0.0f;
	bool NPC_RETALIATING = false;
	float AS_ATTACKING = 0.0f;
	bool FLINCHED_RECENTLY = false;
	bool SUSPEND_AI = false;
	string NPC_STORE_TARGET = "NPC_STORE_TARGET";
	string NPC_STORE_LOST_TARGET = "NPC_STORE_LOST_TARGET";
	string NPC_STOREHUNTSTATE_ADVANCED = "NPC_STOREHUNTSTATE_ADVANCED";
	string NPC_STOREHUNTSTATE_MLK = "NPC_STOREHUNTSTATE_MLK";
	bool NPC_INALLY = false;
	bool ALLY_RESPONSE_DELAY = false;
	bool NPC_DID_STEP_ADJ = false;

	// unnamed block (first think)
	void BaseNpcAttackNew_FirstThink()
	{
		NEW_AI = true;
		HAS_AI = true;
	}

	// npcatk_post_load
	void BaseNpcAttackNew_OnNpcatkPostLoad()
	{
		NPC_LASTSEEN_POS = Vec("unset");
		NPC_MOVEPROX = Eval("game.monster.moveprox");
		NPC_DBL_MOVEPROX = Float(NPC_MOVEPROX);
		NPC_DBL_MOVEPROX *= 2.0f;

		// post load defaults
		if (Float(CYCLE_TIME) == 0.0f) // some npc's are pre-cycled
			CYCLE_TIME = Text(CYCLE_TIME_IDLE);
		if (Float(HEAR_RANGE_MAX) == 0.0f)
			HEAR_RANGE_MAX = "1024";
		if (Float(HEAR_RANGE_PLAYER) == 0.0f)
			HEAR_RANGE_PLAYER = "800";
		if (Float(RETALIATE_CHANCE) == 0.0f) // chance of monster turning on a new opponent when struck from behind (damage much excede FLINCH_DAMAGE_THRESHOLD)
			RETALIATE_CHANCE = "75";
		if (Float(CHASE_RANGE) == 0.0f) // max distance to chase opponent
			CHASE_RANGE = "4000";
		NPC_CHASE_RANGE = Int(CHASE_RANGE);

		// default dependant vars
		if (NPC_MUST_SEE_TARGET == "NPC_MUST_SEE_TARGET")
			NPC_MUST_SEE_TARGET = "1";
		if (CAN_RETALIATE == "CAN_RETALIATE") // if set to 0, monster will never turn on new opponents
			CAN_RETALIATE = "1";
		if (CAN_HEAR == "CAN_HEAR")
			CAN_HEAR = "1";
		if (CAN_FLEE == "CAN_FLEE")
			CAN_FLEE = "1";
		if (CAN_FLINCH == "CAN_FLINCH")
			CAN_FLINCH = "0";
		if (FLINCH_DELAY == "FLINCH_DELAY")
			FLINCH_DELAY = "5.0";
		if (GetVar("ANIM_FLINCH") != "ANIM_FLINCH")
			FLINCH_ANIM = GetVar("ANIM_FLINCH");
		if (Float(FLEE_DISTANCE) == 0.0f)
			FLEE_DISTANCE = "1000";
		if (FLEE_TIME == 0.0f)
			FLEE_TIME = 10.0f;
		if (FLEE_STUCKCHECK_FREQ == 0.0f)
			FLEE_STUCKCHECK_FREQ = 1.0f;

		// post load inits
		IS_FLEEING = false;
		HAVE_TARGET = false;
		// setvard ADVANCED_STACK 0
		NPCATK_TARGET = "unset"; // targeted enemy will be stored here  ( I was using 'none' but it seems to be a reserverd word (odd behavior) )
		NPC_MOVEDEST_TARGET = "unset"; // move location will be stored here
		SEARCH_ROTATION = false;
		EXT_DAMAGE_ADJUSTMENT = "1.0";
		EXT_HITCHANCE_ADJUSTMENT = "1.0";
		NPC_LOST_TARGET = "unset";
		HUNT_LASTTARGET = "\xEF\xBF\xBDNONE\xEF\xBF\xBD"; // backwards compatibility (�NONE� is v. hard to type ^_^)
	}

	// npc_spawn
	// never [override] this
	void BaseNpcAttackNew_OnNpcSpawn(string npc = "")
	{
		CallEventDelayed(NPC_SPAWN_PRED1, "npcatk_get_postspawn_properties");
		CallEventDelayed(NPC_SPAWN_PRED2, "npcatk_hunt");
		// setvard NPC_FRUSTRATION 0
		MONSTER_ID = RandomInt(1000, 9999); // this is STRICTLY for debugging, so it doesnt matter much if a match up occurs
	}

	// npcatk_get_postspawn_properties
	void BaseNpcAttackNew_OnNpcatkGetPostspawnProperties()
	{
		OnNpcatkPostLoad();

		NPC_HALF_HEIGHT = HeightOf(ENT_ME);
		NPC_HEIGHT = NPC_HALF_HEIGHT; // there's a vadj function that checks this a lot
		NPC_HALF_HEIGHT *= 0.5f;

		NPC_HALF_WIDTH = WidthOf(ENT_ME) * 0.5f;

		if (Text(FLINCH_DAMAGE_THRESHOLD) == "FLINCH_DAMAGE_THRESHOLD")
			FLINCH_DAMAGE_THRESHOLD = MyMaxHealth() * 0.1f;
		if (Text(FLINCH_HEALTH) == "FLINCH_HEALTH")
			FLINCH_HEALTH = MyMaxHealth();
		if (Text(FLINCH_DMG_REQ) == "FLINCH_DMG_REQ") // for compatibility
			FLINCH_DMG_REQ = FLINCH_DAMAGE_THRESHOLD;

		if (MONSTER_WIDTH == 0)
			MONSTER_WIDTH = Int(Eval("game.monster.moveprox"));
		if (Text(ATTACK_MOVERANGE) == "ATTACK_MOVERANGE")
		{
			if (MOVE_RANGE != "MOVE_RANGE")
			{
				ATTACK_MOVERANGE = Float(MOVE_RANGE);
			}
			else
			{
				ATTACK_MOVERANGE = MONSTER_WIDTH;
				MOVE_RANGE = MONSTER_WIDTH;
			}
		}

		if (MOVE_RANGE == "MOVE_RANGE")
		{
			if (Text(ATTACK_MOVERANGE) != "ATTACK_MOVERANGE")
				MOVE_RANGE = Text(ATTACK_MOVERANGE);
			else
				MOVE_RANGE = MONSTER_WIDTH;
		}

		if (ATTACK_MOVERANGE > 300.0f)
		{
			NPC_RANGED = "1";
			DebugPrint("npcatk_get_postspawn_properties moveange > 300, setting ranged flag");
			NPC_MAX_RANGE = ATTACK_MOVERANGE;
		}
		if (Text(ATTACK_RANGE) == "ATTACK_RANGE")
			ATTACK_RANGE = MONSTER_WIDTH * 2.5f;
		if (Text(ATTACK_HITRANGE) == "ATTACK_HITRANGE")
			ATTACK_HITRANGE = MONSTER_WIDTH * 4.0f;

		// attempting to substitute with MONSTER_WIDTH
		NPC_CLOSEIN_RANGE = MONSTER_WIDTH * 2.0f; // this is because ATTACK_RANGE is higher with archers

		NPC_LAST_ORIGIN = MyOrigin();

		if (Truthy(GetVar("NO_VICTORY_HEAL")))
			NPC_STORE_HP = MyHealth();

		ORIG_MOVERANGE = ATTACK_MOVERANGE;
	}

	// npcatk_hunt
	// ========= HUNT AND COMBAT ===============================================================================================
	// ===== Hunt Loop (main hunt cycle)
	void BaseNpcAttackNew_OnNpcatkHunt()
	{
		bool exitSub = false;

		CallEventOrDelay(CYCLE_TIME, "npcatk_hunt");

		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;

		if (NPCATK_TARGET == "unset" && CanSee("enemy"))
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)), "saw_new_enemy");

		if (NPCATK_TARGET == "unset")
			return;

		Vector3 myOrg = OriginOf(ENT_ME);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);

		// validate target
		OnNpcatkTargetvalidate(NPCATK_TARGET);

		// Thothie FEB2010_04 switching this up - some NPC's not realizing target is dead
		if (NPCATK_TARGET == "unset")
		{
			OnNpcatkClearTargets("no_longer_valid");
		}
		else
		{
			if (Distance(myOrg, targOrg) > NPC_CHASE_RANGE)
				OnNpcatkClearTargets("out_of_range");
			OnNpcatkCheckForVictory(NPCATK_TARGET);
		}

		if (NPCATK_TARGET == "unset")
			return;

		// target passed validation, chase
		NPC_CANSEE_TARGET = CanSee(NPCATK_TARGET);

		if (!NPC_CANSEE_TARGET)
		{
			// cant see target, if see other enemy, favor it as new target
			if (NPC_COULD_SEE_TARGET)
			{
				OnNpcatkLostSight(); // MAR2010_18 Thothie - Restoring hunt-blind functionality
				NPC_COULD_SEE_TARGET = false;
			}
			if (CanSee("enemy"))
			{
				string oldTarget = NPCATK_TARGET;
				OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)), "favor_new_enemy");
				if (oldTarget != NPCATK_TARGET) // pick up new target on next cycle
					exitSub = true;
			}
			if (!exitSub)
			{
				// see no other enemies, move to last known enemy position
				if (Text(NPC_LASTSEEN_POS) == "unset")
				{
					OnNpcatkSetmovedest(NPCATK_TARGET, Text(ATTACK_MOVERANGE));
				}
				else
				{
					if (!NPC_IS_TURRET)
						OnNpcatkSetmovedest(Text(NPC_LASTSEEN_POS), "1");
					// reached last known position, unset
					// dbg hunting_blind dist $dist(MY_ORG,NPC_LASTSEEN_POS) vs. NPC_MOVEPROX
					if (Distance(myOrg, NPC_LASTSEEN_POS) <= NPC_DBL_MOVEPROX)
					{
						// this is where he last was, move randomly towards him instead
						// dbg reached_blind_spot
						NPC_LASTSEEN_POS = OriginOf(NPCATK_TARGET);
						NPC_LASTSEEN_POS += RelativePosition(Vector3(0, Random(0, 359.99f), 0), Vector3(0, 128, 0));
					}
				}
			}
		}
		else
		{
			// I see target, approach
			NPC_COULD_SEE_TARGET = true; // store that I saw him recently, so I dont repeat 'lost sight' event
			NPC_HUNTING_BLIND = false; // MAR2010_18 Thothie - Restoring hunt-blind functionality
			OnNpcTargetsighted(NPCATK_TARGET); // compatability
			OnNpcatkSetmovedest(NPCATK_TARGET, Text(ATTACK_MOVERANGE));
			NPC_LASTSEEN_POS = targOrg;

			if (CanSee("enemy"))
			{
				// if I see an enemy closer than my target, make him my new target
				if (Truthy(CAN_RETALIATE) && Float(GetProp(NPCATK_TARGET, NPC_RANGE_TYPE)) > Float(GetProp(ENT_LASTSEEN, NPC_RANGE_TYPE))) // Thothie FEB2009_13 - but only if I'm smart enough to retaliate
				{
					if (IsPlayer(ENT_LASTSEEN)) // and its a player
						OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSEEN)));
				}
			}
		}
		if (exitSub)
			return;

		// target maybe in range, attack if so
		// Thothie JAN2009 - bug fixes/optimize in this conditional
		if (NPC_NO_ATTACK)
			return;
		int targRange = Int(GetProp(NPCATK_TARGET, NPC_RANGE_TYPE));
		if (targRange < ATTACK_HITRANGE)
		{
			// note: when using NPC_MUST_SEE_TARGET 0, creature must do direct damage or AOE
			// as he will not be allowed to do traceline damage through allies
			if (Truthy(NPC_MUST_SEE_TARGET) && !NPC_CANSEE_TARGET)
				exitSub = true;
			if (!exitSub)
			{
				// extend range to full hit if target above/below to deal with players on my head, etc.
				float finalAttackRange = ATTACK_RANGE;
				if (!Truthy(GetVar("NPC_NO_VADJ")))
				{
					// DEC2012_22 - measuring from head+forward when oponent above me
					NPC_VADJSTING = false;
					if (targRange > ATTACK_RANGE && Range2DTo(NPCATK_TARGET) < ATTACK_HITRANGE)
					{
						float myZPlus = myOrg.z + NPC_HALF_HEIGHT;
						if (targOrg.z > myZPlus)
						{
							// target is indeed above me, see if I could reach it, tracing from my head + forward
							Vector3 atkStart = myOrg;
							atkStart.z += NPC_HEIGHT;
							atkStart += RelativePosition(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(0, NPC_HALF_WIDTH, 0));
							if (Distance(atkStart, targOrg) < ATTACK_HITRANGE)
							{
								// yes I can, swing, and hope still in my dodamage's hitrange
								finalAttackRange = ATTACK_HITRANGE + NPC_HEIGHT;
								NPC_VADJSTING = true;
							}
						}
					}
				}

				// older methods
				// dbg vadj FINAL_ATTACK_RANGE
				// old method
				// dbg npcatk_hunt vadj FINAL_ATTACK_RANGE
				// local TARG_Z $vec.z(TARG_ORG)
				// if ( $get(NPCATK_TARGET,isplayer) ) subtract TARG_Z 38 //player origin compensation
				// local MY_Z $vec.z(MY_ORG)
				// local Z_DIFF TARG_Z
				// subtract Z_DIFF MY_Z
				// if ( Z_DIFF < 0 ) local Z_DIFF $neg(Z_DIFF)
				// if ( Z_DIFF > $get(ent_me,height) )
				// {
				// //SEP2009 - Switched this from NPC_HALFHEIGHT to 10, as it's too easy to sploit monsters by crouching on ramps
				// //dbg extending range ( Z_DIFF )
				// add FINAL_ATTACK_RANGE $get(ent_me,height) //ATTACK_HITRANGE
				// }
				// dbg npcatk_hunt frange FINAL_ATTACK_RANGE trange TARG_RANGE 2drange $get(NPCATK_TARGET,range2D)
				if (targRange < finalAttackRange)
					OnNpcatkAttack();
			}
		}
	}

	// npcatk_setmovedest
	void BaseNpcAttackNew_OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		if (Truthy(GetVar("NPC_NO_MOVE")))
			return;
		SetMoveDest(destination, range);
	}

	// npcatk_target
	// backwards compatability
	void BaseNpcAttackNew_OnNpcatkTarget2(string target = "", string debug = "")
	{
		OnNpcatkSettarget(target, debug);
	}

	// npcatk_settarget
	// ===== Validate and Set Target
	// PARAM1 = target ent PARAM2 = debug[calling proc]
	void BaseNpcAttackNew_OnNpcatkSettarget(string target = "", string debug = "")
	{
		bool exitSub = false;

		// dbg temp npcatk_settarget [entered] $get(PARAM1,name) PARAM2
		if (IS_FLEEING)
			return;
		CBaseEntity@ checkTarget = EntityOf(target);
		bool isPlayer = IsPlayer(checkTarget);

		// dbg temp npcatk_settarget [flee_check] IS_FLEEING
		if (EntityId(checkTarget) == NPCATK_TARGET)
			return;

		if (Truthy(GetVar("G_SIEGE_MAP")) && NPC_IGNORE_PLAYERS && isPlayer)
			exitSub = true;

		// redundant, handled under validate
		if (RelationshipOf(target, ENT_ME) == "ally") // ignore allies
			exitSub = true;
		if (Float(ScriptVarOf(target, "PLAYING_DEAD")) == 1.0f) // ignore invalid targets (such as prone skeletons)
			exitSub = true;

		// dbg temp npcatk_settarget [flee_check] $get(PARAM1,relationship,ent_me) $get(PARAM1,scriptvar,'PLAYING_DEAD')
		// favor players over non-players, unless on siege map
		if (!Truthy(GetVar("G_SIEGE_MAP")) && IsPlayer(NPCATK_TARGET) && Float(CYCLE_TIME) != CYCLE_TIME_BATTLE)
			OnCycleUp(debug);
		// if ( !IS_PLAYER ) local EXIT_SUB 1
		if (exitSub)
			return;

		string oldAttackTarget = NPCATK_TARGET;

		NPC_ROAMING_HOME = false;

		// setvard ADVANCED_SEARCHING 0
		// setvard NPC_MOVING_LAST_KNOWN 0
		NPCATK_TARGET = EntityId(checkTarget);

		OnNpcatkTargetvalidate(NPCATK_TARGET); // do I really wanna attack this? (if not setvard NPCATK_TARGET unset)

		// dbg temp Validated ( $get(NPCATK_TARGET,name) )
		if (NPCATK_TARGET == "unset")
		{
			// if ( OLD_ATTACK_TARGET equals unset ) callevent npcatk_clear_targets "got_invalid_target" //clear targets if invalid //causing BD
			// restore previous target if near and alive
			if (IsAlive(oldAttackTarget) && Float(GetProp(oldAttackTarget, NPC_RANGE_TYPE)) < 1024.0f)
			{
				// FEB2010_04 - Thothie An event cant call itself without delay
				// callevent npcatk_settarget OLD_ATTACK_TARGET "bad_new_target-restoring_old"
				NPCATK_TARGET = oldAttackTarget;
			}
		}

		if (NPCATK_TARGET == "unset")
			return;

		// Thothie JAN2013_09 - moved cycle up check to after target validated
		if (Float(CYCLE_TIME) != CYCLE_TIME_BATTLE)
		{
			if (isPlayer)
			{
				CYCLED_UP = false;
				OnCycleUp(debug);
				HUNTING_PLAYER = true;
			}
			else
			{
				// //dbg temp MONSTER_ID CycledHIGHFor $get(PARAM1,name) ( type: PARAM2 )
				// if $get(PARAM1,NPC_RANGE_TYPE) < ATTACK_RANGE
				// callevent npcatk_attack
				// FEB2010_04 - cycle up
				if (!NPC_FIGHTS_NPCS)
					OnCycleNpc(debug);
				else
					OnCycleUp(debug);
			}
		}

		// //dbg temp MONSTER_ID CycledNPCFor $get(PARAM1,name) ( type: PARAM2 )
		if (Eval("game.monster.race") == "hguard")
			OnCycleUp("hguard_saw_npc");

		NPC_LASTSEEN_POS = OriginOf(NPCATK_TARGET);

		if (NPCATK_TARGET != oldAttackTarget) // external
			OnNpcFoundNewTarget(NPCATK_TARGET);

		// //dbg MONSTER_ID set_new_target $get(PARAM1,name) PARAM2
		// Thothie JAN2009 - moving ally alert system to base_monster_shared and optimizing
		OnNpcatkRun();
		SetAngle("view.yaw", NPCATK_TARGET);

		// callevent npcatk_setmovedest NPCATK_TARGET ATTACK_MOVERANGE "new_target"
		// backwards compatibility
		IS_HUNTING = true;
		HUNT_LASTTARGET = NPCATK_TARGET;
		ENTITY_ENEMY = NPCATK_TARGET;
	}

	// npcatk_targetvalidate
	void BaseNpcAttackNew_OnNpcatkTargetvalidate(string target = "")
	{
		// some older scripts expect this to be called every time the creature spots an enemy
		// in this version, it is only called on the intial spotting before chase ensues (ie. every npcatk_settarget)
		string oldAttackTarget = NPCATK_TARGET;

		if (!CanDamage(NPCATK_TARGET))
		{
			// invulnerable target, ignore
			if (!Truthy(ScriptVarOf(NPCATK_TARGET, "NPC_ATTACK_INVULN"))) // unless special
				NPCATK_TARGET = "unset";
		}

		if (!IsAlive(NPCATK_TARGET))
			NPCATK_TARGET = "unset";

		if (Float(ScriptVarOf(NPCATK_TARGET, "PLAYING_DEAD")) == 1.0f)
		{
			// fooled by feigning skeletons
			NPCATK_TARGET = "unset";
		}

		// callevent npcatk_clear_targets
		// callevent npcatk_walk "target_playingdead"
		if (RelationshipOf(NPCATK_TARGET, ENT_ME) == "ally")
			NPCATK_TARGET = "unset";

		OnNpcTargetvalidate();

		if (NPCATK_TARGET != "unset")
		{
			NPC_HAS_TARGET = true;
		}
		else if (NPC_HAS_TARGET)
		{
			NPC_HAS_TARGET = false;
			if (Exists(oldAttackTarget) && !IsAlive(oldAttackTarget))
				OnMyTargetDied(oldAttackTarget);
		}
	}

	// npcatk_check_for_victory
	// ===== Other
	// check if I won PARAM1 = target to check (would be NPCATK_TARGET or NPC_LOST_TARGET)
	void BaseNpcAttackNew_OnNpcatkCheckForVictory(string target = "")
	{
		bool targetDead = false;

		if (Truthy(ScriptVarOf(target, "PLAYING_DEAD")))
			OnNpcatkClearTargets("target_playing_dead");
		if (!IsAlive(target))
			targetDead = true;
		if (!Exists(target))
			targetDead = true;
		if (!targetDead)
			return;
		// //dbg temp VICTORY! PARAM2 //param2=calling sub
		OnNpcatkClearTargets("target_died");
	}

	// npcatk_faceattacker
	// PARAM1 = target to face, if not set, faces attack target
	void BaseNpcAttackNew_OnNpcatkFaceattacker(string target = "")
	{
		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;

		// //dbg crash npcatk_faceattacker
		if (Truthy(CANT_TURN))
			return;
		NPC_FORCED_MOVEDEST = true; // prevent stack
		if (target.isEmpty())
			OnNpcatkSetmovedest(NPCATK_TARGET, "9999");
		if (!target.isEmpty())
		{
			string param = target;
			OnNpcatkSetmovedest(param, "9999");
		}
	}

	// npcatk_vanish
	// ===== ANTI-STUCK SYSTEM ===============================================================================================
	// most of this has been moved to monsters/base_anti_stuck
	// param1 = time - if unset monster will not return until npcatk_vanish_return is called
	void BaseNpcAttackNew_OnNpcatkVanish(string time = "")
	{
		OnNpcatkSuspendAi("vanish");
		NPC_VANISHED_AT = MyOrigin();
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));

		if (NPC_VANISH_RETURN_TIME == "NPC_VANISH_RETURN_TIME")
			NPC_VANISH_RETURN_TIME = time;
		// //dbg Winking out from NPC_VANISHED_AT , be back in NPC_VANISH_RETURN_TIME
		CallEventOrDelay(NPC_VANISH_RETURN_TIME, "npcatk_vanish_return");
	}

	// npcatk_vanish_return
	void BaseNpcAttackNew_OnNpcatkVanishReturn()
	{
		// //dbg winking in to NPC_VANISHED_AT
		SetOrigin(ENT_ME, NPC_VANISHED_AT);
		OnNpcatkResumeAi();
		if (NPC_STUCK_TELEPORT) // repeat
			CallEventDelayed(Random(0.1f, 1), "npcatk_stuck_check_inally");
		NPC_STUCK_TELEPORT = false;
	}

	// npcatk_attack
	// ======= Attack & Hack ===================================================================================================
	// ( [override] npcatk_attack callevent npcatk_attack_hack - if you need atack hack, see below )
	void BaseNpcAttackNew_OnNpcatkAttack()
	{
		if (NPC_NO_ATTACK)
			return;
		OnNpcSelectattack(); // give chance for mon to chose an anim (external) (old naming convention for compatiblity)
		if (NPC_MOVEDEST_TARGET != NPCATK_TARGET) // keep moving towards him until in moverange
			OnNpcatkFaceattacker(NPCATK_TARGET);
		PlayAnim("once", GetVar("ANIM_ATTACK"));
		ATTACK_ANIMINDEX = AnimIndexOf(ENT_ME);
	}

	// npcatk_attack_hack
	// for models with no event 600
	void BaseNpcAttackNew_OnNpcatkAttackHack()
	{
		// override npcatk_attack and call this if you need attack hack (ie. no event 600 in model attack anim)
		// set HACK_ATTACK_DELAY or defaults to 1.0, set HACK_DAMAGE_DELAY to simulate model's actual hit time (def 0.1)
		OnNpcatkFaceattacker();
		if (HACK_DELAYING_ATTACK)
			return;
		PlayAnim("once", GetVar("ANIM_ATTACK"));
		ATTACK_ANIMINDEX = AnimIndexOf(ENT_ME); // JUN2007b, store attack anim for use with anti-stuck and others
		HACK_DELAYING_ATTACK = true;
		CallEventDelayed(HACK_DAMAGE_DELAY, "npcatk_attack_hack_dodamage"); // put your dodamage here on your script's side
		CallEventDelayed(HACK_ATTACK_DELAY, "npcatk_attack_hack_reset");
	}

	// npcatk_attack_hack_reset
	// for models with no event 600
	void BaseNpcAttackNew_OnNpcatkAttackHackReset()
	{
		HACK_DELAYING_ATTACK = false;
	}

	// npcatk_lost_sight
	// ======= SEARCH SYSTEM ====================================================================================================
	// { npcatk_search_look_lost_targ //no longer used?
	// if ( $cansee(enemy) )
	// {
	// ////dbg EndSearch: spotted enemy
	// callevent npcatk_settarget $get(ent_lastseen,id) "searching_for_lost"
	// }
	// if ( $cansee(NPC_LOST_TARGET) )
	// {
	// ////dbg EndSearch: target reacquired
	// callevent npcatk_settarget $get(ent_lastseen,id) "found_lost"
	// }
	// }
	// lost target, move to last seen location
	void BaseNpcAttackNew_OnNpcatkLostSight()
	{
		NPC_HUNTING_BLIND = true;
	}

	// npcatk_clear_targets
	// { npcatk_move_last_known //param1 = target that was lost (not used here)
	// ////dbg crash setdest moving to last known
	// add MLK_FAILEDCOUNT 1
	// //callevent npcatk_setmovedest NPC_LASTSEEN_LOC ATTACK_MOVERANGE "npcatk_move_last_known"
	// }
	// { npcatk_search_init_advanced
	// add ADVANCED_STACK 1 //this is to prevent mon from giving up prematurely after losing target multiple times
	// ////dbg AdvSearch Init ( Stack ADVANCED_STACK ) ( reason PARAM1 )
	// //setvard NPC_MOVING_LAST_KNOWN 0
	// setvard ADVANCED_SEARCHING 1
	// setvard AXIS_SEARCH 0
	// setvard SEARCHING_OLDLOC game.monster.origin
	// setvard ADV_SEARCH_RADIUS 64
	// local MY_ANGLE game.monster.angles
	// setvard ADV_SEARCH_ANGLE $vec.yaw(MY_ANGLE)
	// ////dbg AdvSearch Initial Angle ADV_SEARCH_ANGLE
	// callevent npcatk_searching "init"
	// callevent npcatk_search_checkdist
	// callevent SEARCH_THIS_ANGLE_MAX npcatk_searching_angle_done
	// callevent MAX_ADV_SEARCHTIME npcatk_giveup_search "time_out"
	// }
	// { npcatk_searching //PARAM1 = caller proc (for debug)
	// if ADVANCED_SEARCHING
	// //everything this is called, mon will pick random angles reletive to the target to move to
	// add ADV_SEARCH_RADIUS 10
	// add ADV_SEARCH_ANGLE 10
	// if  ( ADV_SEARCH_RADIUS > 1024 ) setvard ADV_SEARCH_RADIUS 0
	// if ( ADV_SEARCH_ANGLE > 359 ) setvard ADV_SEARCH_ANGLE 0
	// local ACT_ORIGIN $get(NPC_LOST_TARGET,origin)
	// setvard TWEAKED_DEST ACT_ORIGIN
	// //local RANDOM_ANGLE $randf(0,359)
	// local RANDOM_DISTANCE $randf(0,ADV_SEARCH_RADIUS)
	// setvard NPC_LAST_STORE_DISTANCE $get(NPC_LOST_TARGET,NPC_RANGE_TYPE)
	// vectoradd TWEAKED_DEST $relpos($vec(0,ADV_SEARCH_RADIUS,0),$vec(0,RANDOM_DISTANCE,0))
	// ////dbg crash AdvSearch
	// if ( $dist(game.monster.origin,TWEAKED_DEST) > ATTACK_RANGE ) callevent npcatk_setmovedest TWEAKED_DEST ATTACK_MOVERANGE "advanded_search"
	// ////dbg AdvSearchChangeAngles called from PARAM1 ( Angls ADV_SEARCH_ANGLE rad ADV_SEARCH_RADIUS )
	// if ( $get(NPC_LOST_TARGET,NPC_RANGE_TYPE) > CHASE_RANGE ) callevent npcatk_giveup_search "too_far"
	// }
	// { npcatk_search_checkdist
	// if ADVANCED_SEARCHING
	// callevent 1.0 npcatk_search_checkdist
	// if !IS_FLEEING
	// if ( $get(NPC_LOST_TARGET,NPC_RANGE_TYPE) > NPC_LAST_STORE_DISTANCE )
	// {
	// callevent npcatk_searching "farther_ratherthan_nearer"
	// }
	// }
	// { npcatk_searching_angle_done
	// if ADVANCED_SEARCHING
	// callevent SEARCH_THIS_ANGLE_MAX npcatk_searching_angle_done
	// callevent npcatk_searching_new_angle "angle_timeout"
	// }
	// { npcatk_giveup_search //PARAM1 = debug reason
	// if ADVANCED_SEARCHING
	// ////dbg Gave up search PARAM1 ( ADVANCED_STACK Searches Pending )
	// if ( ADVANCED_SEARCHING ) subtract ADVANCED_STACK 1
	// if ADVANCED_STACK <= 0
	// callevent npcatk_clear_targets
	// }
	// ===== Reset targeting
	void BaseNpcAttackNew_OnNpcatkClearTargets(string reason = "")
	{
		if (reason == EntityId(self))
			return;

		DebugPrint("npcatk_clear_targets " + reason);

		NPCATK_TARGET = "unset";
		NPC_MOVEDEST_TARGET = "unset";
		NPC_LOST_TARGET = "unset";
		// setvard NPC_MOVING_LAST_KNOWN 0
		// setvard ADVANCED_SEARCHING 0
		HUNT_LASTTARGET = "\xEF\xBF\xBDNONE\xEF\xBF\xBD";
		NPC_ROAMING_HOME = true;
		IS_HUNTING = false; // backwards compatibility
		HUNTING_PLAYER = false;

		OnNpcatkWalk();
		OnCycleDown();
	}

	// npcatk_flee
	// ======= FLEE SYSTEM ======================================================================================================
	// PARAM1: Threatning Entity  2: Dist to flee  3: Time to stop fleeing (optional)
	void BaseNpcAttackNew_OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		// dbg npcatk_flee $get(PARAM1,name) PARAM2 PARAM3
		if (EntityOf(threatEntity) is self) // don't flee own danger sounds
			return;

		if (!Truthy(CAN_FLEE)) // backwards compatible
			return;
		if (IS_FLEEING)
			return;
		if (Truthy(GetVar("CANT_FLEE")))
			return;
		if (RE_FLEE_DELAY) // delay between failed flees to cut down on sploits
			return;

		OnNpcPreFlee(); // external - anything you need to set before flee begins can be done here, set ABORT_FLEE to cancel a flee

		IS_FLEEING = true;

		OnNpcatkRun();
		PlayAnim("break");
		PlayAnim("critical", ANIM_RUN); // come out of attack

		OnNpcatkStoreTarget();

		FLEE_TARGET = threatEntity;
		TOFLEE_DISTANCE = fleeDistance; // not used?
		FLEE_STUCK_COUNT = 0;

		// //dbg Fleeing $get(FLEE_TARGET,name) Dist FLEE_DISTANCE for PARAM3
		// //dbg crash on flee
		NPC_FORCED_MOVEDEST = true;
		// dbg temp flee $get(FLEE_TARGET,name) dist FLEE_DISTANCE
		// setvard FLEE_TARGET $get(FLEE_TARGET,origin)
		SetMoveDest(FLEE_TARGET, FLEE_DISTANCE, "flee");
		if (CanSee(FLEE_TARGET))
		{
			float myYaw = Float(Eval("game.monster.angles.yaw"));
			myYaw += 180.0f;
			if (myYaw > 359.0f)
				myYaw -= 359.0f;
			SetAngle("face", Vector3(0, myYaw, 0));
		}

		// addvelocity ent_me $relvel(0,-200,110)
		FLEESTUCK_OLDPOS = MyOrigin();

		CallEventDelayed(FLEE_STUCKCHECK_FREQ, "npcatk_flee_stuck_check");
		string fleeTimeText = fleeDuration;
		float fleeTime = Float(fleeTimeText);
		if (fleeTime < 1.0f)
			fleeTime = 5.0f;
		if (fleeTime > 10.0f)
		{
			// dbg got flee time over 10.0  ( PARAM3 )
			fleeTime = 10.0f;
		}

		CallEventDelayed(fleeTime, "npcatk_stopflee");
	}

	// npcatk_flee_stuck_check
	void BaseNpcAttackNew_OnNpcatkFleeStuckCheck()
	{
		if (!IS_FLEEING)
			return;
		CallEventDelayed(FLEE_STUCKCHECK_FREQ, "npcatk_flee_stuck_check");

		OnNpcatkSetmovedest(FLEE_TARGET, FLEE_DISTANCE);
		if (CanSee(FLEE_TARGET))
		{
			float npcFleeYaw = Float(Eval("game.monster.angles.yaw"));
			npcFleeYaw += 180.0f;
			if (npcFleeYaw > 359.0f)
				npcFleeYaw -= 359.0f;
			SetAngle("face", Vector3(0, npcFleeYaw, 0));
			PlayAnim("critical", ANIM_RUN);
		}

		if (STUCK_COUNT > 2.0f)
			OnNpcatkStopflee();
	}

	// npcatk_stopflee
	// PARAM1 = reason (prob PARAM3 if delay)
	void BaseNpcAttackNew_OnNpcatkStopflee()
	{
		if (!IS_FLEEING)
			return;
		if (FLEE_STUCK_COUNT > 5) // stuck more than 5 times during flee = someone holding me in place, just fight back
		{
			// //dbg Re-fleedelay stuck FLEE_STUCK_COUNT times during flee
			RE_FLEE_DELAY = true;
			CallEventDelayed(2.5f, "npcatk_reset_flee_delay");
		}
		if (Float(GetProp(FLEE_TARGET, NPC_RANGE_TYPE)) <= ATTACK_RANGE) // bugger is still close, so I guess I can't get away
		{
			// //dbg Re-fleedelay 10.0 never got away from target
			RE_FLEE_DELAY = true;
			CallEventDelayed(10.0f, "npcatk_reset_flee_delay");
		}
		// dbg Stopped_flee_cuz PARAM1
		IS_FLEEING = false;
		OnNpcatkRestoreTarget();
	}

	// npcatk_reset_flee_delay
	void BaseNpcAttackNew_OnNpcatkResetFleeDelay()
	{
		RE_FLEE_DELAY = false;
	}

	// chicken_run
	// ======== CHICKEN RUN (alternate flee)
	// chicken run ignores convention accross the board
	// runs in random direction for x seconds (will stop if stuck)
	// { npcatk_chicken_run //convention
	// callevent chicken_run PARAM1 PARAM2
	// }
	// { npcatk_chickenrun //convention alias
	// callevent chicken_run PARAM1 PARAM2
	// }
	// param =1 duration //param2 = ////dbg reason
	void BaseNpcAttackNew_OnChickenRun(float duration = 0.0f)
	{
		// Effort to get around buggy hesitations in npcatk_flee
		// run in a random direction for xx seconds (pick another dir if can't move)
		if (IS_FLEEING)
			return;
		if (Truthy(GetVar("CANT_FLEE"))) // not really needed, as only called externally - but just in case
			return;

		OnNpcPreFlee(); // external - anything you need to set before flee begins can be done here, set ABORT_FLEE to cancel a flee

		// //dbg MONSTER_ID chicken_run > PARAM2 for PARAM1
		IS_FLEEING = true;
		CHICKEN_RUN = true;
		OnNpcatkStoreTarget();

		OnNpcatkRun();

		CKN_STUCK_COUNTER = 0.0f;

		FLEE_DIR = RandomInt(1, 359);

		NPC_FORCED_MOVEDEST = true;
		OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, FLEE_DIR, 0), Vector3(0, 500, 0))), "0");

		CKN_MY_OLD_POS = Text(OriginOf(ENT_ME));

		CallEventDelayed(0.5f, "chicken_run_stuckcheck");

		CallEventDelayed(duration, "chicken_run_end");
	}

	// chicken_run_stuckcheck
	void BaseNpcAttackNew_OnChickenRunStuckcheck()
	{
		if (!CHICKEN_RUN)
			return;

		float cknMoveDist = Distance(MyOrigin(), Vec(CKN_MY_OLD_POS));

		if (cknMoveDist == 0.0f)
		{
			FLEE_DIR = RandomInt(1, 359);
			// //dbg crash chicken_run_stuckcheck
			// setmovedest none
			NPC_FORCED_MOVEDEST = true;
			OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, FLEE_DIR, 0), Vector3(0, 500, 0))), "0");

			PlayAnim("once", ANIM_RUN);
			CKN_STUCK_COUNTER += 1.0f;
		}
		CKN_MY_OLD_POS = "CKN_MY_POS";

		if (cknMoveDist > 0.0f)
			CKN_STUCK_COUNTER = 0.0f;
		if (CKN_STUCK_COUNTER > 4.0f)
			OnChickenRunEnd();

		CallEventDelayed(0.25f, "chicken_run_stuckcheck");
	}

	// chicken_run_end
	void BaseNpcAttackNew_OnChickenRunEnd()
	{
		if (!CHICKEN_RUN)
			return;

		// //dbg CHICKEN RUN ENDED PARAM1
		CHICKEN_RUN = false;
		IS_FLEEING = false;

		// setmoveanim ANIM_WALK
		OnNpcatkRestoreTarget();
	}

	// game_heardsound
	// ========== Hearing ====================================================================================================
	// PARAM1: Sound type   2: Sound Origin   3: Danger radius
	void BaseNpcAttackNew_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		bool exitSub = false;

		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;
		if (!Truthy(CAN_HEAR))
			return;

		// see if can make other sound types
		// //dbg temp HEAR Type PARAM1 with PARAM3 From $get(ent_lastheard,name)
		@I_HEARD = EntityOf(ENT_LASTHEARD); // prevents relationship hearing issue
		int heardRange = Int(GetProp(ENT_LASTHEARD, NPC_RANGE_TYPE));

		HEARD_VERIFY = true;
		if (Truthy(GetVar("NPC_VALIDATE_HEARING")))
			OnNpcValidateHeard();
		if (!HEARD_VERIFY)
			return;

		string hearRelationship = RelationshipOf(I_HEARD, ENT_ME);

		// //dbg temp heard $get(I_HEARD,name) targ NPCATK_TARGET relate HEAR_RELATIONSHIP type PARAM1 rng HEARD_RANGE ( HEAR_RANGE_MAX ) invalid $get(I_HEARD,scriptvar,PLAYING_DEAD)
		if (NPCATK_TARGET == "unset" && soundType != "danger")
		{
			// if !NPC_MOVING_LAST_KNOWN
			if (hearRelationship == "enemy" && !NPC_IGNORE_PLAYERS)
			{
				HEARD_PLAYER = IsPlayer(I_HEARD);
				if (HEARD_PLAYER)
				{
					if (Eval("game.monster.race") == "hguard")
						exitSub = true;
					if (NPC_IGNORE_PLAYERS)
						exitSub = true;
				}
				if (!exitSub && heardRange < Float(HEAR_RANGE_MAX) && !Truthy(ScriptVarOf(I_HEARD, "PLAYING_DEAD")))
				{
					// callevent npcatk_run "heard_nme" //setmoveanim ANIM_RUN //should be an event
					// callevent npcatk_faceattacker $get(ent_lastheard,id)
					if (!NPC_HUNTING_BLIND)
					{
						NPC_FORCED_MOVEDEST = true;
						OnNpcatkSetmovedest(Text(OriginOf(I_HEARD)), Text(ATTACK_MOVERANGE));
						if (HEARD_PLAYER)
						{
							OnNpcHeardPlayer(); // Thothie OCT2009_5 - added external event for reactions
							if (heardRange < Float(HEAR_RANGE_PLAYER) && Float(CYCLE_TIME) != CYCLE_TIME_BATTLE)
							{
								CYCLED_UP = false;
								OnCycleUp("heard_player");
								// Thothie OCT2009_5 this are fubar - monster will never cycle down
								// if !HEARD_PLAYER
								// setvard HEARD_PLAYER 1
								CallEventDelayed(5.0f, "heard_cycle_down");
							}
						}
					}
				}
			}
		}

		OnNpcHeardsound(); // this can be used to cancel above effects in includer
	}

	// game_struck
	// ======= STRUCK CHECKS ==================================================================================================
	// Thothie FEB2009 - optimization here
	// PARAM1 = damage ent_laststruck = offender
	void BaseNpcAttackNew_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		bool firstStruck = false;

		if (SUSPEND_AI)
			return;

		// //dbg Health game.monster.hp
		if (Truthy(GetVar("NO_VICTORY_HEAL")))
			NPC_STORE_HP = MyHealth();

		// check if this is first time npc is struck.
		if (IsPlayer(NPCATK_TARGET))
			firstStruck = true;
		if (NPCATK_TARGET == "unset")
			firstStruck = true;

		if (firstStruck)
		{
			if (!IS_FLEEING && RelationshipOf(ENT_LASTSTRUCK, ENT_ME) == "wary")
				OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)), "struck_by_enemy");
		}
		else if (EntityId(EntityOf(ENT_LASTSTRUCK)) != NPCATK_TARGET)
			OnNpcatkRetaliate();

		OnNpcatkCheckflee();
		OnNpcatkCheckflinch(Text(damage));
		OnNpcStruck(damage); // used by too many scripts to omit
	}

	// npcatk_retaliate
	void BaseNpcAttackNew_OnNpcatkRetaliate()
	{
		bool exitSub = false;

		if (IS_FLEEING)
			return;
		if (!Truthy(CAN_RETALIATE))
			return;

		// //dbg temp Checking vs. Retalite
		int retaliateChance = Int(RETALIATE_CHANCE);

		if (NPC_DELAY_RETALITATE > 0.0f)
		{
			if (GameTime() < NPC_NEXT_RETALITATE)
				NPC_NEXT_RETALITATE = GameTime() + NPC_DELAY_RETALITATE;
			else
				exitSub = true;
		}
		if (exitSub)
			return;

		if (!IsPlayer(NPCATK_TARGET) && !Truthy(ScriptVarOf(NPCATK_TARGET, "NPC_CRITICAL")) && !Truthy(ScriptVarOf(NPCATK_TARGET, "IS_PET")))
		{
			// target is not critical nor summon, and a player hit me, 100% retaliate
			retaliateChance = 101;
		}

		if (RandomInt(1, 100) <= retaliateChance)
		{
			// Thothie AUG2013_19 - undone, depending on NPC_DELAY_RETALITATE instead
			// if !NPC_RETALIATING
			// setvard NPC_RETALIATING 1 //this also prevents mon from favoring closer enemies for a bit (axe that, too easy to 'ping pong' monsters)
			// callevent 5.0 reset_retaliate
			// //dbg NPC_RETALIATING against $get(ent_laststruck,name)
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)), "NPC_RETALIATING");
		}
	}

	// reset_retaliate
	void BaseNpcAttackNew_OnResetRetaliate()
	{
		NPC_RETALIATING = false;
	}

	// npcatk_checkflee
	void BaseNpcAttackNew_OnNpcatkCheckflee()
	{
		if (Truthy(GetVar("CANT_FLEE")))
			return;

		if (Float(GetVar("FLEE_HEALTH")) > 0.0f && MyHealth() < Float(GetVar("FLEE_HEALTH")))
		{
			// MAY2010_21 fixed syntax in this function
			if (RandomInt(1, 100) <= Float(GetVar("FLEE_CHANCE")))
				OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), FLEE_DISTANCE, Text(FLEE_TIME));
		}
	}

	// npcatk_checkflinch
	// PARAM1 = incoming damage amt
	void BaseNpcAttackNew_OnNpcatkCheckflinch(string incomingDamage = "")
	{
		if (SUSPEND_AI) // no flinchie while AI suspended
			return;

		if (Truthy(CAN_FLINCH) && !FLINCHED_RECENTLY)
		{
			// local MY_HP $get(ent_me,hp)
			if (MyHealth() < FLINCH_HEALTH && Float(incomingDamage) > FLINCH_DAMAGE_THRESHOLD)
			{
				if (RandomInt(1, 100) <= Float(GetVar("FLINCH_CHANCE")))
				{
					OnNpcFlinch(); // external - can be used to select flinch anim
					PlayAnim("break");
					PlayAnim("critical", FLINCH_ANIM);
					AS_ATTACKING = GameTime();
				}
				FLINCHED_RECENTLY = true;
				CallEventOrDelay(FLINCH_DELAY, "npcatk_reset_flinch");
			}
		}
	}

	// npcatk_reset_flinch
	void BaseNpcAttackNew_OnNpcatkResetFlinch()
	{
		FLINCHED_RECENTLY = false;
	}

	// game_reached_dest
	void BaseNpcAttackNew_OnGameReachedDest()
	{
		// dbg reached dest $get(NPCATK_TARGET,name) rng $get(NPCATK_TARGET,NPC_RANGE_TYPE) vs ATTACK_RANGE
		if (SUSPEND_AI)
			return;

		if (CHICKEN_RUN)
		{
			// //dbg crash Chickenrunning game_reached_dest
			OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, 50, 0))), "0");
		}
	}

	// my_target_died
	// PARAM1 = offendner
	void BaseNpcAttackNew_OnMyTargetDied(string offender = "")
	{
		DebugPrint("my_target_died " + NameOf(offender) + " " + offender);

		if (Truthy(GetVar("NO_VICTORY_HEAL")))
			SetHealth(NPC_STORE_HP);
	}

	// npcatk_suspend_ai
	// param1 seconds, if omitted ai suspends until npcatk_resume_ai called if omitted
	void BaseNpcAttackNew_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		// dbg npcatk_suspend_ai PARAM1 PARAM2
		// //dbg suspend AI PARAM2
		if (SUSPEND_AI)
			return;
		OnNpcatkStoreTarget();
		SUSPEND_AI = true;
		CallEventOrDelay(seconds, "npcatk_resume_ai");
	}

	// npcatk_resume_ai
	void BaseNpcAttackNew_OnNpcatkResumeAi(string target = "")
	{
		// dbg npcatk_resume_ai PARAM1
		// //dbg resume AI PARAM2
		if (!SUSPEND_AI)
			return;
		if (NPC_STORE_TARGET != "unset")
			OnNpcatkRestoreTarget();
		SUSPEND_AI = false;
	}

	// npcatk_store_target
	void BaseNpcAttackNew_OnNpcatkStoreTarget()
	{
		NPC_STORE_TARGET = NPCATK_TARGET;
		NPC_STORE_LOST_TARGET = NPC_LOST_TARGET;
	}

	// npcatk_restore_target
	void BaseNpcAttackNew_OnNpcatkRestoreTarget()
	{
		bool exitSub = false;

		// setvard ADVANCED_SEARCHING NPC_STOREHUNTSTATE_ADVANCED
		// setvard NPC_MOVING_LAST_KNOWN NPC_STOREHUNTSTATE_MLK
		NPCATK_TARGET = NPC_STORE_TARGET;
		NPC_LOST_TARGET = NPC_STORE_LOST_TARGET;

		NPC_STORE_TARGET = "unset";
		NPC_STORE_LOST_TARGET = "unset";
		NPC_STOREHUNTSTATE_ADVANCED = "unset";
		NPC_STOREHUNTSTATE_MLK = "unset";

		// dbg temp REstoring Atk NPCATK_TARGET Lost NPC_LOST_TARGET StatAdv ADVANCED_SEARCHING StateMLK NPC_MOVING_LAST_KNOWN
		if (NPCATK_TARGET == "unset" && NPC_LOST_TARGET == "unset")
		{
			// returning from flee where there was I had target to begin with
			NPC_MOVEDEST_TARGET = "unset";
			OnNpcatkWalk();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (NPCATK_TARGET == "unset")
			return;
		OnNpcatkSettarget(NPCATK_TARGET, "restore_standard");
	}

	// game_dodamage
	// ==== DEBUGGARY =====================================================================================================
	// { setmovedest_debug //makes a sprite at mons act move dest so you can see it
	// if G_DEVELOPER >= 1
	// local BEAM_COLOR (255,0,255)
	// local BEAM_DURATION 0.5
	// if ( IS_FLEEING ) local BEAM_COLOR (255,0,0)
	// if ( ADVANCED_SEARCHING ) local BEAM_COLOR (255,255,0)
	// if ( NPC_MOVING_LAST_KNOWN )
	// {
	// local BEAM_COLOR (0,255,255)
	// local BEAM_DURATION 2.0
	// }
	// local BEAM_START game.monster.movedest.origin
	// if ( G_DEVELOPER == 2 )
	// {
	// ////dbg Dest game.monster.movedest.origin adv ADVANCED_SEARCHING mov NPC_MOVING_LAST_KNOWN chk CHICKEN_RUN
	// }
	// local BEAM_END BEAM_START
	// vectoradd BEAM_END $relpos($vec(0,0,0),$vec(0,0,64))
	// effect beam point laserbeam.spr 20 BEAM_START BEAM_END BEAM_COLOR 255 0.7 BEAM_DURATION
	// }
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Origin  4:  End Origin
	string BaseNpcAttackNew_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// setvard NPC_FRUSTRATION 0
		return result;
	}

	// npcatk_reset_ally_resp_delay
	void BaseNpcAttackNew_OnNpcatkResetAllyRespDelay()
	{
		ALLY_RESPONSE_DELAY = false;
	}

	// super_lure
	// called externally by super lure, param1 target param2 race to lure (ommit for all)
	void BaseNpcAttackNew_OnSuperLure(CBaseEntity@ target = null, string lureRace = "")
	{
		// //dbg temp superlure from $get(PARAM1,name) PARAM2 but game.monster.race $get(NPCATK_TARGET,name) NPC_MOVING_LAST_KNOWN
		string targRace = Eval("game.monster.race");
		if (!lureRace.isEmpty())
			targRace = lureRace;

		if (Eval("game.monster.race") != targRace)
			return;
		if (NPCATK_TARGET != "unset")
			return;
		// //dbg temp Superlure called from $get(PARAM1,name)
		OnNpcatkSetmovedest(Text(OriginOf(target)), Text(ATTACK_MOVERANGE));
		OnNpcatkSettarget(EntityId(target), "super_lure");
	}

	// cycle_up
	void BaseNpcAttackNew_OnCycleUp(string reason = "")
	{
		DebugPrint("cycled_up " + reason + " " + Text(SUSPEND_AI));
		if (CYCLED_UP)
			return;
		CYCLED_UP = true;
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		// callevent npc_sensed_player //nothing uses this, axing
		OnNpcAlert(); // JAN2009 Thothie - external used on initial encounter with any enemy

		if (NO_STEP_ADJ)
			return;
		if (NPC_DID_STEP_ADJ)
			return;
		NPC_DID_STEP_ADJ = true;
		OnAdjStepSize(); // shared
	}

	// cycle_down
	void BaseNpcAttackNew_OnCycleDown()
	{
		CYCLED_UP = false;
		CYCLE_TIME = Text(CYCLE_TIME_IDLE);
	}

	// cycle_npc
	void BaseNpcAttackNew_OnCycleNpc(string mode = "")
	{
		CYCLED_UP = false;
		CYCLE_TIME = Text(CYCLE_TIME_NPC);
		OnNpcAlert(); // JAN2009 Thothie - external used on initial encounter with any enemy
	}

	// heard_cycle_down
	void BaseNpcAttackNew_OnHeardCycleDown()
	{
		if (IsPlayer(NPCATK_TARGET))
			return;
		if (HUNTING_PLAYER)
			return;
		// //dbg Calming down, heard player but never found
		HEARD_PLAYER = false;
		OnCycleDown();
		if (NPCATK_TARGET == "unset")
			OnNpcatkWalk();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttackNew_OnNpcatkGetPostspawnProperties();
	}

	void OnNpcatkPostLoad() { BaseNpcAttackNew_OnNpcatkPostLoad(); } // npcatk_post_load
	void OnNpcSpawn(string npc = "") { BaseNpcAttackNew_OnNpcSpawn(npc); } // npc_spawn
	void OnNpcatkHunt() { BaseNpcAttackNew_OnNpcatkHunt(); } // npcatk_hunt
	void OnNpcatkSetmovedest(string destination = "", string range = "") { BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); } // npcatk_setmovedest
	void OnNpcatkTarget2(string target = "", string debug = "") { BaseNpcAttackNew_OnNpcatkTarget2(target, debug); } // npcatk_target
	void OnNpcatkSettarget(string target = "", string debug = "") { BaseNpcAttackNew_OnNpcatkSettarget(target, debug); } // npcatk_settarget
	void OnNpcatkTargetvalidate(string target = "") { BaseNpcAttackNew_OnNpcatkTargetvalidate(target); } // npcatk_targetvalidate
	void OnNpcatkCheckForVictory(string target = "") { BaseNpcAttackNew_OnNpcatkCheckForVictory(target); } // npcatk_check_for_victory
	void OnNpcatkFaceattacker(string target = "") { BaseNpcAttackNew_OnNpcatkFaceattacker(target); } // npcatk_faceattacker
	void OnNpcatkVanish(string time = "") { BaseNpcAttackNew_OnNpcatkVanish(time); } // npcatk_vanish
	void OnNpcatkVanishReturn() { BaseNpcAttackNew_OnNpcatkVanishReturn(); } // npcatk_vanish_return
	void OnNpcatkAttack() { BaseNpcAttackNew_OnNpcatkAttack(); } // npcatk_attack
	void OnNpcatkAttackHack() { BaseNpcAttackNew_OnNpcatkAttackHack(); } // npcatk_attack_hack
	void OnNpcatkAttackHackReset() { BaseNpcAttackNew_OnNpcatkAttackHackReset(); } // npcatk_attack_hack_reset
	void OnNpcatkLostSight() { BaseNpcAttackNew_OnNpcatkLostSight(); } // npcatk_lost_sight
	void OnNpcatkClearTargets(string reason = "") { BaseNpcAttackNew_OnNpcatkClearTargets(reason); } // npcatk_clear_targets
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { BaseNpcAttackNew_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnNpcatkFleeStuckCheck() { BaseNpcAttackNew_OnNpcatkFleeStuckCheck(); } // npcatk_flee_stuck_check
	void OnNpcatkStopflee() { BaseNpcAttackNew_OnNpcatkStopflee(); } // npcatk_stopflee
	void OnNpcatkResetFleeDelay() { BaseNpcAttackNew_OnNpcatkResetFleeDelay(); } // npcatk_reset_flee_delay
	void OnChickenRun(float duration = 0.0f) { BaseNpcAttackNew_OnChickenRun(duration); } // chicken_run
	void OnChickenRunStuckcheck() { BaseNpcAttackNew_OnChickenRunStuckcheck(); } // chicken_run_stuckcheck
	void OnChickenRunEnd() { BaseNpcAttackNew_OnChickenRunEnd(); } // chicken_run_end
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnNpcatkRetaliate() { BaseNpcAttackNew_OnNpcatkRetaliate(); } // npcatk_retaliate
	void OnResetRetaliate() { BaseNpcAttackNew_OnResetRetaliate(); } // reset_retaliate
	void OnNpcatkCheckflee() { BaseNpcAttackNew_OnNpcatkCheckflee(); } // npcatk_checkflee
	void OnNpcatkCheckflinch(string incomingDamage = "") { BaseNpcAttackNew_OnNpcatkCheckflinch(incomingDamage); } // npcatk_checkflinch
	void OnNpcatkResetFlinch() { BaseNpcAttackNew_OnNpcatkResetFlinch(); } // npcatk_reset_flinch
	void OnGameReachedDest() { BaseNpcAttackNew_OnGameReachedDest(); } // game_reached_dest
	void OnMyTargetDied(string offender = "") { BaseNpcAttackNew_OnMyTargetDied(offender); } // my_target_died
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") { BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); } // npcatk_suspend_ai
	void OnNpcatkResumeAi(string target = "") { BaseNpcAttackNew_OnNpcatkResumeAi(target); } // npcatk_resume_ai
	void OnNpcatkStoreTarget() { BaseNpcAttackNew_OnNpcatkStoreTarget(); } // npcatk_store_target
	void OnNpcatkRestoreTarget() { BaseNpcAttackNew_OnNpcatkRestoreTarget(); } // npcatk_restore_target
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnNpcatkResetAllyRespDelay() { BaseNpcAttackNew_OnNpcatkResetAllyRespDelay(); } // npcatk_reset_ally_resp_delay
	void OnSuperLure(CBaseEntity@ target = null, string lureRace = "") { BaseNpcAttackNew_OnSuperLure(target, lureRace); } // super_lure
	void OnCycleUp(string reason = "") { BaseNpcAttackNew_OnCycleUp(reason); } // cycle_up
	void OnCycleDown() { BaseNpcAttackNew_OnCycleDown(); } // cycle_down
	void OnCycleNpc(string mode = "") { BaseNpcAttackNew_OnCycleNpc(mode); } // cycle_npc
	void OnHeardCycleDown() { BaseNpcAttackNew_OnHeardCycleDown(); } // heard_cycle_down
	void OnCycleTime() {} // CYCLE_TIME
	void OnFleeStuckcheckFreq() {} // FLEE_STUCKCHECK_FREQ
	void OnFlinchDelay() {} // FLINCH_DELAY
	void OnHackAttackDelay() {} // HACK_ATTACK_DELAY
	void OnHackDamageDelay() {} // HACK_DAMAGE_DELAY
	void OnLFleeTime() {} // L_FLEE_TIME
	void OnNpcSpawnPred1() {} // NPC_SPAWN_PRED1
	void OnNpcSpawnPred2() {} // NPC_SPAWN_PRED2
	void OnNpcVanishReturnTime() {} // NPC_VANISH_RETURN_TIME
	void OnAdjStepSize() {} // adj_step_size
	void OnNpcAlert() {} // npc_alert
	void OnNpcFlinch(float damage = 0.0f) {} // npc_flinch
	void OnNpcFoundNewTarget(string target = "") {} // npc_found_new_target
	void OnNpcHeardPlayer() {} // npc_heard_player
	void OnNpcHeardsound() {} // npc_heardsound
	void OnNpcPreFlee() {} // npc_pre_flee
	void OnNpcSelectattack() {} // npc_selectattack
	void OnNpcStruck(float damage = 0.0f) {} // npc_struck
	void OnNpcTargetsighted(string target = "") {} // npc_targetsighted
	void OnNpcTargetvalidate(CBaseEntity@ target = null) {} // npc_targetvalidate
	void OnNpcValidateHeard() {} // npc_validate_heard
	void OnNpcatkRun() {} // npcatk_run
	void OnNpcatkWalk() {} // npcatk_walk

	// This file's events and timers by their .script names
	bool BaseNpcAttackNew_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "chicken_run_end") { OnChickenRunEnd(); return true; }
		if (name == "chicken_run_stuckcheck") { OnChickenRunStuckcheck(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_npc") { OnCycleNpc(Param(params, 0)); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "heard_cycle_down") { OnHeardCycleDown(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_attack_hack") { OnNpcatkAttackHack(); return true; }
		if (name == "npcatk_attack_hack_reset") { OnNpcatkAttackHackReset(); return true; }
		if (name == "npcatk_check_for_victory") { OnNpcatkCheckForVictory(Param(params, 0)); return true; }
		if (name == "npcatk_checkflee") { OnNpcatkCheckflee(); return true; }
		if (name == "npcatk_checkflinch") { OnNpcatkCheckflinch(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_faceattacker") { OnNpcatkFaceattacker(Param(params, 0)); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "npcatk_flee_stuck_check") { OnNpcatkFleeStuckCheck(); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "npcatk_post_load") { OnNpcatkPostLoad(); return true; }
		if (name == "npcatk_reset_ally_resp_delay") { OnNpcatkResetAllyRespDelay(); return true; }
		if (name == "npcatk_reset_flee_delay") { OnNpcatkResetFleeDelay(); return true; }
		if (name == "npcatk_reset_flinch") { OnNpcatkResetFlinch(); return true; }
		if (name == "npcatk_restore_target") { OnNpcatkRestoreTarget(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_retaliate") { OnNpcatkRetaliate(); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_store_target") { OnNpcatkStoreTarget(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_target") { OnNpcatkTarget2(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "npcatk_vanish") { OnNpcatkVanish(Param(params, 0)); return true; }
		if (name == "npcatk_vanish_return") { OnNpcatkVanishReturn(); return true; }
		if (name == "reset_retaliate") { OnResetRetaliate(); return true; }
		if (name == "super_lure") { OnSuperLure(EntityParam(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_npc_attack_new"]
shared class BaseNpcAttackNewScript : BaseNpcScript, BaseNpcAttackNew
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	bool AM_FLANKING = false;
	string ANIM_IDLE = "ANIM_IDLE";
	bool AS_CAN_MOVE = false;
	int AS_CRITICAL_THRESH = 0;
	int AS_DIST_THRESH = 0;
	bool AS_FIRST_STUCK = false;
	Vector3 AS_FLEE_POINT = Vector3();
	float AS_HITBACK_FRUST = 0.0f;
	float AS_HITBACK_FRUST_RUNS = 0.0f;
	float AS_IN_RANGE_CLICKS = 0.0f;
	float AS_LAST_HIT = 0.0f;
	string AS_LAST_POS = "AS_LAST_POS";
	bool AS_LAST_POS_SET = false;
	float AS_LAST_STRIKE = 0.0f;
	float AS_MAX_ATTACK_TIME = 0.0f;
	float AS_MISS_COUNT = 0.0f;
	string AS_MOVEPROX = "AS_MOVEPROX";
	float AS_NEXT_CHECK = 0.0f;
	Vector3 AS_SPAWN_POINT = Vector3();
	bool AS_STARTED = false;
	float AS_STUCK_FREQ = 0.0f;
	bool AS_TELE_OUT = false;
	Vector3 AS_TELE_POINT = Vector3();
	int AS_TELE_THRESH = 0;
	float AS_UNSTUCK_ANG = 0.0f;
	float AS_WIGGLE_DURATION = 0.0f;
	bool BAST_DID_INIT = false;
	bool BAST_FIRST_TEST = false;
	float BAST_FWD = 0.0f;
	float BAST_MOB_HEIGHT_ADJ = 0.0f;
	string BAST_PLAYER_LIST = "BAST_PLAYER_LIST";
	float BAST_ROT = 0.0f;
	bool BAST_SPAWNCHECK = false;
	Vector3 BAST_SPAWN_POS = Vector3();
	bool BAST_STUCK_DID_INIT = false;
	bool BAST_TELEPORTING = false;
	string BAST_TEST_PLAYER = "BAST_TEST_PLAYER";
	float BAST_VFLOAT = 0.0f;
	float BMS_RENDERAMT = 0.0f;
	int DEF_STEP_SIZE = 0;
	bool DID_HELP_TIP = false;
	float FD_LOOP_COUNT = 0.0f;
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MIN_ATTACK_RANGE = 0.0f;
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	float NEXT_HITFRUST_RECORD = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	CBaseEntity@ NPC_ALLY_TO_AID = null;
	bool NPC_ATTACK_MISS = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	bool NPC_GOING_HOME = false;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	bool NPC_IGNORE_PLAYERS = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	bool NPC_MADE_IT_HOME = false;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	bool NPC_MOVEMENT_SUSPENDED = false;
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
	float NPC_NEXT_RHOME_WIGGLE = 0.0f;
	bool NPC_NO_ATTACK = false;
	string NPC_OLD_ANIM_IDLE = "NPC_OLD_ANIM_IDLE";
	string NPC_OLD_ANIM_RUN = "NPC_OLD_ANIM_RUN";
	string NPC_OLD_ANIM_WALK = "NPC_OLD_ANIM_WALK";
	string NPC_OLD_ROAM = "NPC_OLD_ROAM";
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROX_LOOP = false;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETURNING_HOME = false;
	Vector3 NPC_SPAWN_ANGLES = Vector3();
	Vector3 NPC_SPAWN_LOC = Vector3();
	float NPC_SPAWN_TIME = 0.0f;
	bool NPC_TARGET_INVALID = false;
	bool NPC_WAS_IN_BATTLE = false;
	int OLD_NO_STUCK_CHECKS = 0;
	string PARRY_TYPE = "PARRY_TYPE";
	float STUCK_COUNT = 0.0f;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNpcAttackNew_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
