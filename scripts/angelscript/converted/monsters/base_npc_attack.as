#pragma context server

// Converted from monsters/base_npc_attack.script by msc_transpiler.
// Thothie JAN2009 - made sure HUNT_LASTTARGET is mirrfored in NPCATK_TARGET here to ensure forward compatibility

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseNpcAttack
{
	// Variables (an unset .script variable reads as its own name)
	bool HAS_AI = true;
	float CYCLE_TIME_IDLE = 0.0f;
	float CYCLE_TIME_BATTLE = 0.0f;
	string CYCLE_TIME = "CYCLE_TIME";
	int MONSTER_ID = 0;
	string ORIG_HUNT_AGRO = "ORIG_HUNT_AGRO";
	bool IS_FLEEING = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string NPCATK_TARGET = "NPCATK_TARGET";
	bool NPC_INITIALIZED = false;
	bool IS_HUNTING = false;
	bool NPC_CANSEE_TARGET = false;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	string HUNT_AGRO = "HUNT_AGRO";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	bool NPCATK_FLEE_RESTORETARGET = false;
	bool HEARD_PLAYER = false;
	bool NPC_DELAYING_FLINCH = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_TARGET_INVALID = false;
	string ENTITY_ENEMY = "ENTITY_ENEMY";
	bool HUNTING_PLAYER = false;
	float NPC_TARG_HALFHEIGHT = 0.0f;
	bool OUT_OF_RANGE = false;
	bool CHICKEN_RUN = false;
	bool PURE_FLEE = false;
	int FLEE_DIR = 0;
	float CKN_TIME_END = 0.0f;
	float CKN_STUCK_COUNTER = 0.0f;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	bool SUSPEND_AI = false;
	float FINAL_ATTACK_DAMAGE = 0.0f;
	float FINAL_HITCHANCE_DAMAGE = 0.0f;
	bool CYCLED_UP = false;
	bool NPC_ALERTED_ALL = false;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	string CANT_TRACK = "CANT_TRACK";
	string CAN_HUNT = "CAN_HUNT";
	string CAN_ATTACK = "CAN_ATTACK";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CAN_FLINCH = "CAN_FLINCH";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	string NPC_HEAR_TARGET = "NPC_HEAR_TARGET";
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	string ORIG_NPC_MOVE_TARGET = "ORIG_NPC_MOVE_TARGET";
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	float FLINCH_DMG_REQ = 0.0f;
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	string CHASE_RANGE = "CHASE_RANGE";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	float M_ATTACK_HITRANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;

	// unnamed block (first think)
	void BaseNpcAttack_FirstThink()
	{
		HAS_AI = true;

		CYCLE_TIME_IDLE = 2.8f;

		// dbg constset CYCLE_TIME_IDLE
		CYCLE_TIME_BATTLE = 0.1f;

		// dbg constset CYCLE_TIME_BATTLE
		CYCLE_TIME = Text(CYCLE_TIME_IDLE);

		// dbg varset CYCLE_TIME
		MONSTER_ID = RandomInt(1000, 9999); // for debugging only
	}

	// game_spawn
	void BaseNpcAttack_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		// randoms here to cut down on mass-spawn lag
		CallEventDelayed(Random(0.5f, 1), "npcatk_get_postspawn_properties");
	}

	// npcatk_get_postspawn_properties
	void BaseNpcAttack_OnNpcatkGetPostspawnProperties()
	{
		OnNpcatkCheckSets();

		ORIG_HUNT_AGRO = HUNT_AGRO;
		IS_FLEEING = false;
		HUNT_LASTTARGET = "\xAFNONE\xAF";
		NPCATK_TARGET = "unset";

		// //dbg atkrng ATTACK_RANGE atkhitrange ATTACK_HITRANGE
		// //dbg temp MONSTER_ID post atkrng ATTACK_RANGE atkhit ATTACK_HITRANGE alyresp ALLY_RESPONSE_RANGE
		NPC_INITIALIZED = true;
	}

	// hunting_mode_go
	// ======================================================================= MAIN CYCLE
	void BaseNpcAttack_OnHuntingModeGo()
	{
		bool targDied = false;
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");

		OnNpcatkHunt();

		// //dbg temp seenme NPC_MOVE_TARGET $cansee(NPC_MOVE_TARGET) hnting IS_HUNTING agro HUNT_AGRO chs CHASE_RANGE canhunt CAN_HUNT sup SUSPEND_AI flee IS_FLEEING ded PLAYING_DEAD
		// these all work: //dbg game.monster.onground $get(ent_me,onground)
		// this always returns 1: godtest $get(ent_me,invincible)
		if (!NPC_INITIALIZED)
			return;

		if (!Truthy(CAN_HUNT))
			return;
		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;
		if (Truthy(PLAYING_DEAD))
			return;

		NPCATK_TARGET = HUNT_LASTTARGET;

		if (HUNT_LASTTARGET != "\xAFNONE\xAF")
		{
			// is target out of range
			if (RangeTo(HUNT_LASTTARGET) > Float(CHASE_RANGE))
			{
				// //dbg MONSTER_ID Target $get(HUNT_LASTTARGET,name) out of range
				SetMoveAnim(ANIM_WALK);
				OnNpcatkClearTargets("targ_out_of_range");
			}

			if (!IsAlive(HUNT_LASTTARGET))
				targDied = true;
			if (!Exists(HUNT_LASTTARGET))
				targDied = true;

			if (targDied)
			{
				// Target died or was removed
				OnMyTargetDied(HUNT_LASTTARGET);
				HUNT_LASTTARGET = "\xAFNONE\xAF";
				NPCATK_TARGET = "unset";
				OnGameWander();
			}
		}

		if (HUNT_LASTTARGET == "\xAFNONE\xAF")
			IS_HUNTING = false;

		if (IS_HUNTING)
		{
			float gameTime = GameTime();
			NPC_CANSEE_TARGET = CanSee(HUNT_LASTTARGET);
			if (!Truthy(CANT_TRACK))
			{
				if (NPC_CANSEE_TARGET)
				{
					NPC_LASTSEEN_POS = OriginOf(HUNT_LASTTARGET);
					OnNpcatkSetmovedest(HUNT_LASTTARGET, MOVE_RANGE);
				}
				if (!NPC_CANSEE_TARGET) // otherwise ranged mons wont move towards you
					OnNpcatkSetmovedest(Text(NPC_LASTSEEN_POS), Eval("game.monster.moveprox"));
			}
			if (NPC_CANSEE_TARGET)
			{
				OnNpcTargetsighted(HUNT_LASTTARGET);
				if (Truthy(NPC_MUST_SEE_TARGET) && RangeTo(HUNT_LASTTARGET) < ATTACK_HITRANGE)
					OnCheckAttack();
			}
			if (!Truthy(NPC_MUST_SEE_TARGET) && RangeTo(HUNT_LASTTARGET) < ATTACK_HITRANGE)
				OnCheckAttack();
			if (CanSee("enemy"))
			{
				// favor nearest enemy
				if (ENT_LASTSEEN != HUNT_LASTTARGET && IsPlayer(ENT_LASTSEEN) && RangeTo(ENT_LASTSEEN) < RangeTo(HUNT_LASTTARGET))
					OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSEEN)), "is_closer_enemy");
			}

			OnNpcatkTargetvalidate(HUNT_LASTTARGET);
		}

		// if HUNT_LASTTARGET isnot ¯NONE¯ //wtf is this?
		// look for target
		if (IS_HUNTING)
			return;
		if (!Truthy(HUNT_AGRO))
			return;
		if (CanSee(NPC_MOVE_TARGET))
		{
			// target spotted
			// setvard HUNT_LASTTARGET $get(ent_lastseen,id)
			// //dbg validating_target HUNT_LASTTARGET
			OnNpcatkTargetvalidate(EntityId(EntityOf(ENT_LASTSEEN))); // set HUNT_LASTTARGET to ¯NONE¯ to invalidate

			if (HUNT_LASTTARGET != "\xAFNONE\xAF")
				OnNpcTargetsighted(HUNT_LASTTARGET);
		}
	}

	// game_wander
	void BaseNpcAttack_OnGameWander()
	{
		// setvard IS_HUNTING 0
		// setmoveanim ANIM_WALK
		// if ( IS_FLEEING ) callevent npcatk_stopflee
		if (IS_HUNTING)
			return;
		OnNpcWander();
	}

	// game_reached_dest
	void BaseNpcAttack_OnGameReachedDest()
	{
		if (CHICKEN_RUN)
			OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, 50, 0))), "0");
	}

	// check_attack
	// Attack
	void BaseNpcAttack_OnCheckAttack()
	{
		if (!Truthy(CAN_ATTACK))
			return;
		if (IS_FLEEING)
			return;
		if (SUSPEND_AI)
			return;

		// adjust attack range case cheater standing on me head, or vis'versa
		// this bit with overriding const naybe causing weird stuff, not enough time to test out right now, so remming
		Vector3 targPos = OriginOf(HUNT_LASTTARGET);
		float myZ = MyOrigin().z;
		float targZ = targPos.z;
		float zDiff = targZ;
		myZ += NPC_TARG_HALFHEIGHT;
		zDiff -= myZ;
		if (zDiff < 0.0f)
			zDiff = -zDiff;
		float finalAttackRange = ATTACK_RANGE;
		if (zDiff > NPC_TARG_HALFHEIGHT) // PLAYER_HALFHEIGHT
		{
			// setvard ATTACK_RANGE E_ATTACK_RANGE
			// setvard ATTACK_HITRANGE E_ATTACK_HITRANGE
			finalAttackRange = ATTACK_HITRANGE;
		}

		// //dbg check_attack reaching... Z_DIFF game.monster.origin TARG_POS
		// //dbg zdiff Z_DIFF using atkrng ATTACK_RANGE ( org O_ATTACK_RANGE ext E_ATTACK_RANGE )
		// //dbg zdiff Z_DIFF using FINAL_ATTACK_RANGE ( norm ATTACK_RANGE )
		// //dbg temp check_attack inrng $cansee(HUNT_LASTTARGET,FINAL_ATTACK_RANGE) ( FINAL_ATTACK_RANGE )
		if (!Truthy(LegacyFunction("cansee", HUNT_LASTTARGET, finalAttackRange)))
			return;

		OnNpcatkAttackenemy();
	}

	// npcatk_attackenemy
	void BaseNpcAttack_OnNpcatkAttackenemy()
	{
		if (Truthy(GetVar("NPC_NO_ATTACK")))
			return;

		OnNpcSelectattack(); // Give a chance to select attack anim

		OnNpcatkFaceenemy();
		PlayAnim("once", GetVar("ANIM_ATTACK"));

		OnNpcAttack();
	}

	// npcatk_go_agro
	void BaseNpcAttack_OnNpcatkGoAgro()
	{
		if (Truthy(CANT_TRACK))
			return;
		HUNT_AGRO = "1";
		NPC_MOVE_TARGET = EntityId(EntityOf(ENT_LASTSTRUCK));
		if (!IsAlive(HUNT_LASTTARGET))
			OnNpcatkTarget2(NPC_MOVE_TARGET);
	}

	// game_struck
	// Hit by someone
	void BaseNpcAttack_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!Truthy(HUNT_AGRO))
			OnNpcatkGoAgro();

		if (!IsAlive(HUNT_LASTTARGET))
			OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSTRUCK)), "struck_while_idle");

		if (IsPlayer(ENT_LASTSTRUCK))
		{
			// Thothie JAN2009 - moved ally alert system to targeting via base_monster_shared
			if (!CYCLED_UP)
				OnCycleUp("stuck_by_player");
		}

		if (RelationshipOf(ENT_LASTSTRUCK, ENT_ME) != "ally")
			OnNpcatkRetaliate();
		OnNpcatkCheckflee();
		if (damage > FLINCH_DMG_REQ)
			OnNpcatkCheckflinch();

		// comment out Thothie JAN2009
		// if ( $get(ent_laststruck,isplayer) )
		// {
		// if ( $cansee(ally) )
		// {
		// if !NO_ALERT_ALLIES
		// ////dbg MONSTER_ID see ally, alerting
		// callexternal ent_lastseen npcatk_ally_alert $get(ent_laststruck,id) $get(ent_me,id) "alert_seen"
		// }
		// }
		OnNpcStruck(); // backwards compat
	}

	// npcatk_retaliate
	void BaseNpcAttack_OnNpcatkRetaliate()
	{
		if (!Truthy(CAN_RETALIATE))
			return;

		if (!Exists(HUNT_LASTTARGET)) // Always retaliate when current target is invalid
			OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSTRUCK)), "retaliate");

		// //dbg temp Retaliating against $get(PARAM1,id)
		if (EntityId(EntityOf(ENT_LASTSTRUCK)) == HUNT_LASTTARGET) // don't retarget current target
			return;

		int retaliteChance = Int(RETALIATE_CHANCE);
		if (GetVar("RETALIATE_CHANGETARGET_CHANCE") != "RETALIATE_CHANGETARGET_CHANCE") // backwards compatiblity
			retaliteChance = Int(GetVar("RETALIATE_CHANGETARGET_CHANCE"));

		if (!(RandomInt(1, 100) < retaliteChance))
			return;

		// setvard NPC_MOVE_TARGET $get(ent_laststruck,id)
		OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSTRUCK)), "retaliate");
	}

	// npcatk_faceattacker
	// Face my new enemy and stop moving
	// =================================
	// PARAM1: Entity to face
	void BaseNpcAttack_OnNpcatkFaceattacker(string target = "")
	{
		if (IS_FLEEING)
			return;
		if (SUSPEND_AI)
			return;

		if (target.isEmpty())
			OnNpcatkSetmovedest(HUNT_LASTTARGET, "9999");
		if (!target.isEmpty())
		{
			// //dbg face enemy PARAM1 ( $get(PARAM1,name) )
			OnNpcatkSetmovedest(EntityId(EntityOf(target)), "9999");
		}
	}

	// npcatk_checkflee
	// Chance of fleeing at low health
	// ===============================
	void BaseNpcAttack_OnNpcatkCheckflee()
	{
		if (CAN_FLEE != "1")
			return;
		if (!(MyHealth() <= Float(GetVar("FLEE_HEALTH"))))
			return;
		if (!(RandomInt(0, 100) < Float(GetVar("FLEE_CHANCE"))))
			return;

		OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), FLEE_DISTANCE, "3.0");
	}

	// npcatk_stopflee
	void BaseNpcAttack_OnNpcatkStopflee()
	{
		IS_FLEEING = false;
		// setmoveanim ANIM_WALK
		if (NPCATK_FLEE_RESTORETARGET)
			OnNpcatkTarget2(HUNT_LASTTARGET);
		OnNpcStopflee();
	}

	// npcatk_flee
	// PARAM1: Threatning Entity  2: Dist to flee  3: Time to stop fleeing (optional)
	void BaseNpcAttack_OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "")
	{
		if (EntityOf(threatEntity) is self) // don't flee own danger sounds
			return;

		// dbg MONSTER_ID Fleeing $get(PARAM1,name) dist PARAM2 time PARAM3
		PlayAnim("break");
		SetMoveDest(threatEntity, fleeDistance, "flee");
		SetMoveAnim(ANIM_RUN);

		IS_FLEEING = true;
		NPCATK_FLEE_RESTORETARGET = IS_HUNTING;

		// anti-olympix h4x
		string fleeTimeText = fleeDuration;
		float fleeTime = Float(fleeTimeText);
		if (fleeTimeText.isEmpty())
		{
			// dbg got infinite flee time
			fleeTime = 5.0f;
		}
		if (fleeTime > 10.0f)
		{
			// dbg got flee time over 10.0  ( PARAM3 )
			fleeDuration = "10.0";
		}

		CallEventDelayed(fleeTime, "npcatk_stopflee");
	}

	// game_heardsound
	// Hear enemies
	// ============
	// PARAM1: Sound type   2: Sound Origin   3: Danger radius
	void BaseNpcAttack_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (!Truthy(CAN_HEAR))
			return;
		if (Truthy(GetVar("NPC_HEARDSOUND_OVERRIDE")))
			return;
		// if CAN_HUNT //makes bats not drop down
		if (SUSPEND_AI) // test on keledros
			return;
		if (IS_FLEEING)
			return;

		// if ( $get(ent_lastheard,relationship,ent_me) equals enemy )
		// {
		// //if hear closer enemy, favor him
		// if IS_HUNTING
		// if $get(HUNT_LASTTARGET,range) > ATTACK_RANGE
		// if $get(ent_lastheard,range) < $get(HUNT_LASTTARGET,range)
		// callevent npcatk_target $get(ent_lastheard,id) "heard_closer_enemy"
		// }
		// if ( PARAM1 equals 'combat' )
		// {
		// if !IS_HUNTING
		// if !IS_FLEEING
		// if HUNT_AGRO
		// if $get(ent_lastheard,relationship,ent_me) equals enemy
		// callevent npcatk_target $get(ent_lastheard,id) "heard_enemy"
		// }
		CBaseEntity@ iHeard = EntityOf(ENT_LASTHEARD); // gotta do this to prevent relationship issuses

		// //dbg temp heard $get(I_HEARD,name) PARAM1
		if (soundType != "danger" && !IS_HUNTING && RelationshipOf(iHeard, ENT_ME) == "enemy" && RangeTo(iHeard) < Float(HEAR_RANGE_MAX) && !Truthy(ScriptVarOf(iHeard, PLAYING_DEAD)) && !Truthy(GetVar("NPC_IGNORE_PLAYERS")))
		{
			OnNpcHeardenemy(); // backwards compat
			if (IsPlayer(iHeard) && RangeTo(iHeard) < Float(HEAR_RANGE_PLAYER) && !CYCLED_UP)
			{
				OnCycleUp("heard_player");
				if (!HEARD_PLAYER)
				{
					HEARD_PLAYER = true;
					CallEventDelayed(5.0f, "heard_cycle_down");
				}
			}

			if (Eval("game.monster.race") != "hguard")
			{
				bool seeHeard = CanSee(EntityId(iHeard));
				if (seeHeard)
					OnNpcatkTarget2(EntityId(EntityOf(ENT_LASTSEEN)), "spotted_heard");

				if (!seeHeard)
				{
					// callevent npcatk_faceattacker I_HEARD "heard_enemy"
					if (Eval("game.monster.race") != "hguard")
						OnNpcatkSetmovedest(EntityId(iHeard), Eval("game.monster.moveprox"));
				}
			}
		}
	}

	// npcatk_checkflinch
	// Flinch when hit
	void BaseNpcAttack_OnNpcatkCheckflinch(string incomingDamage = "")
	{
		if (SUSPEND_AI) // no flinchie while AI suspended
			return;

		if (!Truthy(CAN_FLINCH))
			return;
		if (NPC_DELAYING_FLINCH)
			return;
		if (!(RandomInt(0, 99) < Float(GetVar("FLINCH_CHANCE"))))
			return;

		if (GetVar("FLINCH_ANIM") != "FLINCH_ANIM")
			PlayAnim("critical", GetVar("FLINCH_ANIM"));

		NPC_DELAYING_FLINCH = false;
		CallEventOrDelay(FLINCH_DELAY, "npcatk_resetflinch");
		OnNpcFlinch();
	}

	// npcatk_resetflinch
	void BaseNpcAttack_OnNpcatkResetflinch()
	{
		NPC_DELAYING_FLINCH = true;
	}

	// npcatk_vanish
	// param1 = time - if unset monster will not return until npcatk_vanish_return is called
	void BaseNpcAttack_OnNpcatkVanish(string time = "")
	{
		NPC_VANISHED_AT = MyOrigin();
		SetOrigin(ENT_ME, Vector3(20000, 20000, 20000));

		if (NPC_VANISH_RETURN_TIME == "NPC_VANISH_RETURN_TIME")
			NPC_VANISH_RETURN_TIME = time;
		// //dbg MONSTER_ID Winking out from NPC_VANISHED_AT , be back in NPC_VANISH_RETURN_TIME
		CallEventOrDelay(NPC_VANISH_RETURN_TIME, "npcatk_vanish_return");
	}

	// npcatk_vanish_return
	void BaseNpcAttack_OnNpcatkVanishReturn()
	{
		// //dbg MONSTER_ID winking in to NPC_VANISHED_AT
		SetOrigin(ENT_ME, NPC_VANISHED_AT);
		NPC_STUCK_TELEPORT = false;
	}

	// npcatk_targetvalidate
	// PARAM1 = target to validate
	void BaseNpcAttack_OnNpcatkTargetvalidate(string target = "")
	{
		// //dbg temp validating $get(PARAM1,name)
		string oldHuntLasttarget = HUNT_LASTTARGET;

		NPC_TARGET_INVALID = false;

		if (HUNT_LASTTARGET == "\xAFNONE\xAF")
		{
			HUNT_LASTTARGET = target;
			NPCATK_TARGET = HUNT_LASTTARGET;
		}

		if (RelationshipOf(target, ENT_ME) == "ally")
		{
			// dbg MONSTER_ID invalidtarget ally
			OnNpcatkClearTargets("validate:targ_is_ally");
		}

		if (Truthy(ScriptVarOf(HUNT_LASTTARGET, PLAYING_DEAD)))
		{
			// dbg MONSTER_ID invalidtarget playing_dead
			NPC_TARGET_INVALID = true;
		}

		// callevent npcatk_clear_targets "validate:targ_playing_dead"
		if (!CYCLED_UP && IsPlayer(HUNT_LASTTARGET)) // for some reason CYCLED_TIME == CYCLE_TIME_BATTLE no workie
			OnCycleUp("spotted_player");

		if (RelationshipOf(NPCATK_TARGET, ENT_ME) == "ally")
		{
			// dbg npcatk_targetvalidate: Attempted to target ally?
			HUNT_LASTTARGET = "\xAFNONE\xAF";
			NPCATK_TARGET = "unset";
			NPC_TARGET_INVALID = true;
		}

		if (IsPlayer(target) && Truthy(GetVar("NPC_IGNORE_PLAYERS")))
			NPC_TARGET_INVALID = true;

		OnNpcTargetvalidate(EntityOf(target));

		if (NPC_TARGET_INVALID)
		{
			if (target != oldHuntLasttarget)
			{
				// in case current target became invalid
				HUNT_LASTTARGET = oldHuntLasttarget;
				NPCATK_TARGET = HUNT_LASTTARGET;
			}
			if (HUNT_LASTTARGET == target)
			{
				OnNpcatkClearTargets();
				HUNT_LASTTARGET = "\xAFNONE\xAF";
				NPCATK_TARGET = "unset";
			}
		}
		if (NPC_TARGET_INVALID)
			return;

		if (HUNT_LASTTARGET == "\xAFNONE\xAF")
			return;

		NPC_LASTSEEN_POS = OriginOf(HUNT_LASTTARGET);

		OnNpcTargetsighted(HUNT_LASTTARGET); // bakcwards compat, only activates for valid target so useful

		if (IS_HUNTING)
			return;

		ENTITY_ENEMY = HUNT_LASTTARGET;
		NPCATK_TARGET = HUNT_LASTTARGET; // forward compat

		// new valid target
		if (IsPlayer(target))
		{
			HUNTING_PLAYER = true;
			OnCheckAttack();
			// Thothie JAN2009 - moved to base_monster_shared (targeting)
			// if ( !NO_ALERT_ALLIES )
			// {
			// ////dbg MONSTER_ID Alerting allies to $get(PARAM1,name)
			// callexternal all npcatk_ally_alert $get(PARAM1,id) $get(ent_me,id) "alert_all"
			// }
			if (!CYCLED_UP)
				OnCycleUp("spotted_player_redund");
		}

		// human guards use full cycle vs. npcs, as they often defend against them
		if (Eval("game.monster.race") == "hguard")
			CYCLE_TIME = Text(CYCLE_TIME_BATTLE);

		SetMoveAnim(ANIM_RUN);
		IS_HUNTING = true;
		NPC_TARG_HALFHEIGHT = Clamp(Divide(HeightOf(HUNT_LASTTARGET), 2.0f), 37.0f, 2000.0f);
	}

	// my_target_died
	void BaseNpcAttack_OnMyTargetDied(string offender = "")
	{
		// //dbg my_target_died $get(PARAM1,name) $get(PARAM1,isalive) $get(PARAM1,exists) ( PARAM1 )
		OUT_OF_RANGE = false;
		OnNpcatkClearTargets("target_dead");
		SetMoveAnim(ANIM_WALK);
		// if !$cansee(enemy)
		CallEventDelayed(2.0f, "game_wander");
	}

	// npcatk_clear_targets
	// PARAM1 = reason
	void BaseNpcAttack_OnNpcatkClearTargets(string reason = "")
	{
		// //dbg npcatk_clear_targets PARAM1
		NPC_MOVE_TARGET = ORIG_NPC_MOVE_TARGET;
		HUNT_AGRO = ORIG_HUNT_AGRO;
		HUNTING_PLAYER = false;
		IS_HUNTING = false;
		HUNT_LASTTARGET = "\xAFNONE\xAF";
		NPCATK_TARGET = "unset";
		OnCycleDown();
	}

	// super_lure
	// called externally by super lure, PARAM1=target PARAM2=race to lure (ommit for all)
	void BaseNpcAttack_OnSuperLure(CBaseEntity@ target = null, string lureRace = "")
	{
		// //dbg MONSTER_ID temp superlure from $get(PARAM1,name) PARAM2 but game.monster.race $get(NPCATK_TARGET,name)
		string targRace = Eval("game.monster.race");
		if (!lureRace.isEmpty())
			targRace = lureRace;

		if (Eval("game.monster.race") != targRace)
			return;
		if (HUNT_LASTTARGET != "\xAFNONE\xAF")
			return;
		if (IS_HUNTING)
			return;
		// //dbg MONSTER_ID temp Superlure called from $get(PARAM1,name)
		OnNpcatkTarget2(EntityId(target), "super_lure");
	}

	// npcatk_target
	// PARAM1 == entity to target PARAM2 = debug
	void BaseNpcAttack_OnNpcatkTarget2(string target = "", string debug = "")
	{
		// sets NPC attack target
		// this shoulda been in here a long time ago
		string oldTarget = HUNT_LASTTARGET;
		HUNT_LASTTARGET = EntityId(EntityOf(target)); // make sure HUNT_LASTTARGET is ALWAYS ID and NEVER a string (ie. ent_lastseen)
		NPCATK_TARGET = HUNT_LASTTARGET;
		OnNpcatkTargetvalidate(HUNT_LASTTARGET);
		if (!IsAlive(HUNT_LASTTARGET))
		{
			// target was invalidated, restore old, if allive
			if (EntityId(EntityOf(target)) != oldTarget && IsAlive(oldTarget))
			{
				HUNT_LASTTARGET = oldTarget;
				NPCATK_TARGET = HUNT_LASTTARGET;
			}
		}

		if (!IsAlive(HUNT_LASTTARGET))
			return;
		if (!Truthy(HUNT_AGRO))
			OnNpcatkGoAgro();
	}

	// chicken_run
	// param =1 duration
	void BaseNpcAttack_OnChickenRun(float duration = 0.0f)
	{
		// random movement
		// //dbg MONSTER_ID Chicken run for PARAM1 cuz PARAM2
		if (Truthy(PLAYING_DEAD))
			return;
		if (Truthy(GetVar("CANT_FLEE")))
			return;
		if (IS_FLEEING)
			return;
		IS_FLEEING = true;
		CHICKEN_RUN = true;
		PURE_FLEE = true;
		NPCATK_FLEE_RESTORETARGET = IS_HUNTING;

		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_RUN);

		FLEE_DIR = RandomInt(1, 359);

		CKN_TIME_END = duration;

		CKN_STUCK_COUNTER = 0.0f;

		OnNpcatkClearmovedest();
		CallEventDelayed(0.1f, "init_chicken_run");
	}

	// npcatk_chicken_run
	// convention
	void BaseNpcAttack_OnNpcatkChickenRun(float value = 0.0f, string value2 = "")
	{
		OnChickenRun(value);
	}

	// npcatk_chickenrun
	// convention alias
	void BaseNpcAttack_OnNpcatkChickenrun(float value = 0.0f, string value2 = "")
	{
		OnChickenRun(value);
	}

	// init_chicken_run
	void BaseNpcAttack_OnInitChickenRun()
	{
		// setangle view.yaw FLEE_DIR
		OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, FLEE_DIR, 0), Vector3(0, 500, 0))), "0");

		CKN_MY_OLD_POS = Text(OriginOf(ENT_ME));

		CallEventDelayed(0.5f, "chicken_run_stuckcheck");

		// //dbg MONSTER_ID ChickenInit run ends in CKN_TIME_END
		CallEventDelayed(CKN_TIME_END, "chicken_run_end");
	}

	// chicken_run_stuckcheck
	void BaseNpcAttack_OnChickenRunStuckcheck()
	{
		if (!CHICKEN_RUN)
			return;

		Vector3 cknMyPos = OriginOf(ENT_ME);
		float cknMoveDist = Distance(cknMyPos, Vec(CKN_MY_OLD_POS));

		// //dbg MONSTER_ID dist CKN_MOVE_DIST Cmp CKN_MY_POS vs CKN_MY_OLD_POS
		if (cknMoveDist == 0.0f)
		{
			SetMoveAnim(ANIM_RUN);
			// //dbg MONSTER_ID Chicken - stuck, picking new dir CKN_MOVE_DIST oldpos CKN_MY_OLD_POS vs CKN_MY_POS
			FLEE_DIR = RandomInt(1, 359);
			OnNpcatkClearmovedest();
			// setangle view.yaw FLEE_DIR
			Vector3 runDir = RelativePosition(Vector3(0, FLEE_DIR, 0), Vector3(0, 500, 0));
			OnNpcatkSetmovedest(Text(runDir), "0");
			// //dbg MONSTER_ID temp chicken run stuck
			PlayAnim("once", ANIM_RUN);
			CKN_STUCK_COUNTER += 1.0f;
		}
		CKN_MY_OLD_POS = Text(cknMyPos);

		if (cknMoveDist > 0.0f)
			CKN_STUCK_COUNTER = 0.0f;
		if (CKN_STUCK_COUNTER > 4.0f)
			OnChickenRunEnd();

		CallEventDelayed(0.25f, "chicken_run_stuckcheck");
	}

	// chicken_run_end
	void BaseNpcAttack_OnChickenRunEnd()
	{
		if (!CHICKEN_RUN)
			return;

		// //dbg MONSTER_ID CHICKEN RUN ENDED PARAM1
		SetMoveAnim(ANIM_RUN);
		CHICKEN_RUN = false;
		IS_FLEEING = false;
		PURE_FLEE = false;
		// setmoveanim ANIM_WALK
		if (NPCATK_FLEE_RESTORETARGET)
			OnNpcatkFaceattacker(HUNT_LASTTARGET);
	}

	// npcatk_suspend_ai
	void BaseNpcAttack_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		SUSPEND_AI = true;
		CallEventOrDelay(seconds, "npcatk_resume_ai");
	}

	// npcatk_resume_ai
	void BaseNpcAttack_OnNpcatkResumeAi(string target = "")
	{
		SUSPEND_AI = false;
	}

	// npcatk_adj_attack
	void BaseNpcAttack_OnNpcatkAdjAttack()
	{
		// TS basenpc_adj_attack and rename
		// Thothie - for future use
		// concept being: being spells, items, or npc scripts may adjust any monsters's hit damage and hit chance up or down
		// (eg. spell 'curse' or ms_npcscript make_strong)
		// to apply (example):
		// setvard FINAL_HITCHANCE ATTACK_HITRANGE
		// setvard FINAL_DAMAGE ATTACK_DAMAGE
		// callevent basenpc_get_final_damage
		// dodamage ent_lastseen ATTACK_HITRANGE FINAL_DAMAGE FINAL_HITCHANCE
		// set in npcatk_postspawn and remove these ifs
		// handled internally in npcatk_new
		if (EXT_DAMAGE_ADJUSTMENT != "EXT_DAMAGE_ADJUSTMENT")
			FINAL_ATTACK_DAMAGE += Float(EXT_DAMAGE_ADJUSTMENT);
		if (EXT_HITCHANCE_ADJUSTMENT != "EXT_HITCHANCE_ADJUSTMENT")
			FINAL_HITCHANCE_DAMAGE += Float(EXT_HITCHANCE_ADJUSTMENT);
	}

	// npcatk_settarget
	// forward compatibility ^_^
	void BaseNpcAttack_OnNpcatkSettarget(string target = "", string debug = "")
	{
		// Thothie JAN2009 - oops (param pass fix)
		OnNpcatkTarget2(target, "compatibility");
	}

	// cycle_up
	// PARAM1=debug reason
	void BaseNpcAttack_OnCycleUp(string reason = "")
	{
		CYCLED_UP = true;
		if (!IS_HUNTING)
		{
			// //dbg cycle_up PARAM1
			// step adjustements to help monsters get around
			if (!NO_STEP_ADJ)
				OnAdjStepSize();
		}

		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
	}

	// cycle_down
	// PARAM1=debug reason
	void BaseNpcAttack_OnCycleDown()
	{
		// dbg cycle_down PARAM1
		NPC_ALERTED_ALL = false; // Thothie JAN2009
		CYCLED_UP = false;
		CYCLE_TIME = Text(CYCLE_TIME_IDLE);
	}

	// heard_cycle_down
	void BaseNpcAttack_OnHeardCycleDown()
	{
		if (CanSee("enemy"))
			return;
		if (HUNTING_PLAYER)
			return;
		// //dbg Calming down, heard player but never found
		HEARD_PLAYER = false;
		OnCycleDown();
	}

	// npcatk_clearmovedest
	// { [client]
	// if game.debug > 4
	// //dbg //dbg_level game.debug
	// if !STARTED_DEBUG_LOOP
	// setvard STARTED_DEBUG_LOOP 1
	// callevent still_here_loop
	// }
	// { [client] still_here_loop
	// //dbg base_npc_attack script lingering on client
	// callevent 2.0 still_here_loop
	// }
	void BaseNpcAttack_OnNpcatkClearmovedest()
	{
		// //dbg temp npcatk_clearmovedest PARAM1
		SetMoveDest("none");
	}

	// npcatk_setmovedest
	void BaseNpcAttack_OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		// //dbg temp npcatk_setmovedest PARAM3 ( PARAM1 PARAM2 )
		SetMoveDest(destination, range);
	}

	// npcatk_check_sets
	void BaseNpcAttack_OnNpcatkCheckSets()
	{
		// set anything that wasn't
		// olympix prevention
		// init defaults
		if (NPC_MUST_SEE_TARGET == "NPC_MUST_SEE_TARGET")
			NPC_MUST_SEE_TARGET = "1";

		if (HUNT_AGRO == "HUNT_AGRO")
			HUNT_AGRO = "1";
		ORIG_HUNT_AGRO = HUNT_AGRO;

		// dbg hunt_agro HUNT_AGRO ORIG_HUNT_AGRO
		if (CANT_TRACK == "CANT_TRACK")
			CANT_TRACK = "0";

		if (CAN_HUNT == "CAN_HUNT")
			CAN_HUNT = "1";

		if (CAN_ATTACK == "CAN_ATTACK")
			CAN_ATTACK = "1";

		if (CAN_HEAR == "CAN_HEAR")
			CAN_HEAR = "1";

		if (CAN_FLEE == "CAN_FLEE")
			CAN_FLEE = "1";

		if (CAN_RETALIATE == "CAN_RETALIATE")
			CAN_RETALIATE = "1";

		if (CAN_FLINCH == "CAN_FLINCH")
			CAN_FLINCH = "0";

		if (RETALIATE_CHANCE == "RETALIATE_CHANCE")
			RETALIATE_CHANCE = "75";

		if (NPC_HEAR_TARGET == "NPC_HEAR_TARGET")
			NPC_HEAR_TARGET = "enemy";

		if (FLEE_DISTANCE == "FLEE_DISTANCE")
			FLEE_DISTANCE = "1024";

		if (GetVar("RETALIATE_CHANGETARGET_CHANCE") != "RETALIATE_CHANGETARGET_CHANCE")
			RETALIATE_CHANCE = GetVar("RETALIATE_CHANGETARGET_CHANCE");

		if (GetVar("MY_ENEMY") != "MY_ENEMY")
		{
			// Backwards compatibility
			NPC_MOVE_TARGET = GetVar("MY_ENEMY");
		}

		if (NPC_MOVE_TARGET == "NPC_MOVE_TARGET" && Truthy(HUNT_AGRO))
			NPC_MOVE_TARGET = "enemy";
		ORIG_NPC_MOVE_TARGET = NPC_MOVE_TARGET;

		if (!Truthy(HUNT_AGRO) && NPC_MOVE_TARGET == "NPC_MOVE_TARGET")
			NPC_MOVE_TARGET = "none";

		if (Text(NPC_ALLY_RESPONSE_RANGE) == "NPC_ALLY_RESPONSE_RANGE")
			NPC_ALLY_RESPONSE_RANGE = Clamp(MyMaxHealth() * 10.0f, 96.0f, 1024.0f);

		// APR2010_01 - thothie - wrong comparison was here
		if (Text(FLINCH_DMG_REQ) == "FLINCH_DMG_REQ")
			FLINCH_DMG_REQ = MyMaxHealth() * 0.1f;

		if (HEAR_RANGE_MAX == "HEAR_RANGE_MAX")
			HEAR_RANGE_MAX = "1024";

		if (HEAR_RANGE_PLAYER == "HEAR_RANGE_PLAYER")
			HEAR_RANGE_PLAYER = "800";
		if (CHASE_RANGE == "CHASE_RANGE")
			CHASE_RANGE = "4000";

		if (FLINCH_DELAY == "FLINCH_DELAY")
			FLINCH_DELAY = "5.0";

		// ====== These are critical, and its going to eat CPU to fix em, edit the monster asap
		// ====== Not having these set will cause problems with include scripts
		if (MOVE_RANGE == "MOVE_RANGE")
		{
			// dbg move_range NOT SET!!!
			MOVE_RANGE = Eval("game.monster.moveprox");
		}

		if (Text(ATTACK_RANGE) == "ATTACK_RANGE")
		{
			// dbg attack_range NOT SET!!!
			ATTACK_RANGE = Float(Eval("game.monster.moveprox"));
			ATTACK_RANGE *= 2.5f;
		}

		// attack range should always be monster height + player height/2
		// case player is on monster head (remember, monsters measure from feet, instead of center)
		M_ATTACK_HITRANGE = Float(Eval("game.monster.height"));
		M_ATTACK_HITRANGE += 10.0f;
		M_ATTACK_HITRANGE += 38.0f;

		if (Text(ATTACK_HITRANGE) == "ATTACK_HITRANGE")
		{
			// dbg ATTACK_HITRANGE NOT SET!!!
			ATTACK_HITRANGE = M_ATTACK_HITRANGE;
		}

		if (ATTACK_HITRANGE < M_ATTACK_HITRANGE)
		{
			// dbg attack_hitrange set too low! ATTACK_HITRANGE < M_ATTACK_HITRANGE
			ATTACK_HITRANGE = M_ATTACK_HITRANGE;
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseNpcAttack_OnGameSpawn(playerRace, playerGender);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttack_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_get_postspawn_properties
	void OnNpcatkGetPostspawnProperties()
	{
		BaseNpc_OnNpcatkGetPostspawnProperties(); // monsters/base_npc
		BaseNpcAttack_OnNpcatkGetPostspawnProperties();
	}

	void OnHuntingModeGo() { BaseNpcAttack_OnHuntingModeGo(); } // hunting_mode_go
	void OnGameWander() { BaseNpcAttack_OnGameWander(); } // game_wander
	void OnGameReachedDest() { BaseNpcAttack_OnGameReachedDest(); } // game_reached_dest
	void OnCheckAttack() { BaseNpcAttack_OnCheckAttack(); } // check_attack
	void OnNpcatkAttackenemy() { BaseNpcAttack_OnNpcatkAttackenemy(); } // npcatk_attackenemy
	void OnNpcatkGoAgro() { BaseNpcAttack_OnNpcatkGoAgro(); } // npcatk_go_agro
	void OnNpcatkRetaliate() { BaseNpcAttack_OnNpcatkRetaliate(); } // npcatk_retaliate
	void OnNpcatkFaceattacker(string target = "") { BaseNpcAttack_OnNpcatkFaceattacker(target); } // npcatk_faceattacker
	void OnNpcatkCheckflee() { BaseNpcAttack_OnNpcatkCheckflee(); } // npcatk_checkflee
	void OnNpcatkStopflee() { BaseNpcAttack_OnNpcatkStopflee(); } // npcatk_stopflee
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { BaseNpcAttack_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { BaseNpcAttack_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnNpcatkCheckflinch(string incomingDamage = "") { BaseNpcAttack_OnNpcatkCheckflinch(incomingDamage); } // npcatk_checkflinch
	void OnNpcatkResetflinch() { BaseNpcAttack_OnNpcatkResetflinch(); } // npcatk_resetflinch
	void OnNpcatkVanish(string time = "") { BaseNpcAttack_OnNpcatkVanish(time); } // npcatk_vanish
	void OnNpcatkVanishReturn() { BaseNpcAttack_OnNpcatkVanishReturn(); } // npcatk_vanish_return
	void OnNpcatkTargetvalidate(string target = "") { BaseNpcAttack_OnNpcatkTargetvalidate(target); } // npcatk_targetvalidate
	void OnMyTargetDied(string offender = "") { BaseNpcAttack_OnMyTargetDied(offender); } // my_target_died
	void OnNpcatkClearTargets(string reason = "") { BaseNpcAttack_OnNpcatkClearTargets(reason); } // npcatk_clear_targets
	void OnSuperLure(CBaseEntity@ target = null, string lureRace = "") { BaseNpcAttack_OnSuperLure(target, lureRace); } // super_lure
	void OnNpcatkTarget2(string target = "", string debug = "") { BaseNpcAttack_OnNpcatkTarget2(target, debug); } // npcatk_target
	void OnChickenRun(float duration = 0.0f) { BaseNpcAttack_OnChickenRun(duration); } // chicken_run
	void OnNpcatkChickenRun(float value = 0.0f, string value2 = "") { BaseNpcAttack_OnNpcatkChickenRun(value, value2); } // npcatk_chicken_run
	void OnNpcatkChickenrun(float value = 0.0f, string value2 = "") { BaseNpcAttack_OnNpcatkChickenrun(value, value2); } // npcatk_chickenrun
	void OnInitChickenRun() { BaseNpcAttack_OnInitChickenRun(); } // init_chicken_run
	void OnChickenRunStuckcheck() { BaseNpcAttack_OnChickenRunStuckcheck(); } // chicken_run_stuckcheck
	void OnChickenRunEnd() { BaseNpcAttack_OnChickenRunEnd(); } // chicken_run_end
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") { BaseNpcAttack_OnNpcatkSuspendAi(seconds, debugTag); } // npcatk_suspend_ai
	void OnNpcatkResumeAi(string target = "") { BaseNpcAttack_OnNpcatkResumeAi(target); } // npcatk_resume_ai
	void OnNpcatkAdjAttack() { BaseNpcAttack_OnNpcatkAdjAttack(); } // npcatk_adj_attack
	void OnNpcatkSettarget(string target = "", string debug = "") { BaseNpcAttack_OnNpcatkSettarget(target, debug); } // npcatk_settarget
	void OnCycleUp(string reason = "") { BaseNpcAttack_OnCycleUp(reason); } // cycle_up
	void OnCycleDown() { BaseNpcAttack_OnCycleDown(); } // cycle_down
	void OnHeardCycleDown() { BaseNpcAttack_OnHeardCycleDown(); } // heard_cycle_down
	void OnNpcatkClearmovedest() { BaseNpcAttack_OnNpcatkClearmovedest(); } // npcatk_clearmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "") { BaseNpcAttack_OnNpcatkSetmovedest(destination, range); } // npcatk_setmovedest
	void OnNpcatkCheckSets() { BaseNpcAttack_OnNpcatkCheckSets(); } // npcatk_check_sets
	void OnCknTimeEnd() {} // CKN_TIME_END
	void OnFleeTime() {} // FLEE_TIME
	void OnFlinchDelay() {} // FLINCH_DELAY
	void OnNpcVanishReturnTime() {} // NPC_VANISH_RETURN_TIME
	void OnAdjStepSize() {} // adj_step_size
	void OnNpcAttack() {} // npc_attack
	void OnNpcFlinch(float damage = 0.0f) {} // npc_flinch
	void OnNpcHeardenemy() {} // npc_heardenemy
	void OnNpcSelectattack() {} // npc_selectattack
	void OnNpcStopflee() {} // npc_stopflee
	void OnNpcStruck(float damage = 0.0f) {} // npc_struck
	void OnNpcTargetsighted(string target = "") {} // npc_targetsighted
	void OnNpcTargetvalidate(CBaseEntity@ target = null) {} // npc_targetvalidate
	void OnNpcWander() {} // npc_wander
	void OnNpcatkFaceenemy() {} // npcatk_faceenemy
	void OnNpcatkHunt() {} // npcatk_hunt

	// This file's events and timers by their .script names
	bool BaseNpcAttack_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "chicken_run_end") { OnChickenRunEnd(); return true; }
		if (name == "chicken_run_stuckcheck") { OnChickenRunStuckcheck(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_wander") { OnGameWander(); return true; }
		if (name == "heard_cycle_down") { OnHeardCycleDown(); return true; }
		if (name == "hunting_mode_go") { OnHuntingModeGo(); return true; }
		if (name == "init_chicken_run") { OnInitChickenRun(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npcatk_adj_attack") { OnNpcatkAdjAttack(); return true; }
		if (name == "npcatk_attackenemy") { OnNpcatkAttackenemy(); return true; }
		if (name == "npcatk_check_sets") { OnNpcatkCheckSets(); return true; }
		if (name == "npcatk_checkflee") { OnNpcatkCheckflee(); return true; }
		if (name == "npcatk_checkflinch") { OnNpcatkCheckflinch(Param(params, 0)); return true; }
		if (name == "npcatk_chicken_run") { OnNpcatkChickenRun(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "npcatk_chickenrun") { OnNpcatkChickenrun(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_clearmovedest") { OnNpcatkClearmovedest(); return true; }
		if (name == "npcatk_faceattacker") { OnNpcatkFaceattacker(Param(params, 0)); return true; }
		if (name == "npcatk_flee") { OnNpcatkFlee(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_go_agro") { OnNpcatkGoAgro(); return true; }
		if (name == "npcatk_resetflinch") { OnNpcatkResetflinch(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_retaliate") { OnNpcatkRetaliate(); return true; }
		if (name == "npcatk_setmovedest") { OnNpcatkSetmovedest(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_stopflee") { OnNpcatkStopflee(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_target") { OnNpcatkTarget2(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "npcatk_vanish") { OnNpcatkVanish(Param(params, 0)); return true; }
		if (name == "npcatk_vanish_return") { OnNpcatkVanishReturn(); return true; }
		if (name == "super_lure") { OnSuperLure(EntityParam(params, 0), Param(params, 1)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_npc_attack"]
shared class BaseNpcAttackScript : BaseNpcScript, BaseNpcAttack
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseNpcAttack_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
