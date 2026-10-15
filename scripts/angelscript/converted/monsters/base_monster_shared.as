#pragma context server

// Converted from monsters/base_monster_shared.script by msc_transpiler.
// Thothie
// Bits shared by both the old and new AI
// (hope maybe to congragate both AI's eventually)
// Currently handled:
// npcatk_get_postspawn_properties
// - step size adjustment
// - NPC_RANGED set to 1 if ATTACK_RANGE > 255
// npcatk_check_if_scared_of
// - checks if monster is scared of danger sound (so fire immune beasts are not scared of volcano, for instance)
// game_parry
// - parry messages
// functions:
// npcatk_go_home - sends monster home so long as he sees no enemy
// npcatk_to_ground - puts monster on ground
// npcatk_suspend_attack <DURATION> - suspend attack ability (similar to npcatk_suspend_ai)
// npcatk_resume_attack - resumes attack ability
// npcatk_flank - flanks random	pos around target (iffy)
// npcatk_find_distant - find most distant player target (stores in: NPC_MOST_DISTANT)
// bm_gold_spew //PARAM1=gold_per_bag PARAM2=bags_per_player PARAM3=dist_from_mon PARAM4=min#bags PARAM5 max#bags
// debug_beam - simplified, point-based beam drawing for debuggary (moved to player/externals->ext_debug_beam)
// npcatk_suspend_movement //<anim> [duration] suspends movement (but not AI) and loops anim until...
// npcatk_resume_movement //...is called - useful for spell casting and the like
// preset external consts
// these apply when NPC_IS_BOSS is set to 1 at npc_post_spawn
// NPC_BOSS_REGEN_RATE			//[0.1] ratio of health boss regains per minute
// NPC_BOSS_REGEN_FREQ			//[60] how often regeneration pulses occur
// NPC_BOSS_RESTORATION			//[0.75] ratio of health to restore when boss slays all players on server
// NPC_RETURN_HOME				//return home on kill, so long as no new targets acquired (uses newer, simplified system)
// unset external vars (optional)
// NPC_IS_BOSS					//flags monster as boss
// NPC_NEVER_UNAGRO				//never calm down from lack of seeing enemy in awhile
// - Proximity activated: (new, cuz we have too many monsters that work this way and fail to respond)
// NPC_PROX_ACTIVATE 1			//suspend AI on spawn, wait for player to come..
// NPC_PROXACT_RANGE 512			//within this range then activate...
// NPC_PROXACT_EVENT event_name	//this event.
// NPC_PROXACT_DELAY 0			//delay before calling NPC_PROXACT_EVENT when activated
// NPC_PROXACT_IFSEEN 1			//activate if a player can see me, or targets me, regardless of range
// NPC_PROXACT_FOV 1				//Require player must be in field of vision to activate
// NPC_PROXACT_CONE 90			//effect field of vision for FOV activation
// >NPC_PROXACT_TRIPPED 0		//this sets to 1 after monster is activated
// >NPC_PROXACT_PLAYERID			//player that activated me will be stored here
// DROP_GOLD 		[1/0] (Whether to drop gold)
// DROP_GOLD_MIN		(Min amount to drop)
// DROP_GOLD_MAX		(Max amount to drop)
// DROP_GOLD_AMT		$rand(10,20) //simpler variant of above
// DROP_ITEM[x] 		(Itemname)
// DROP_ITEM[x]_CHANCE 	(Chance the item will drop)
// DROPS_CONTAINER		[1/0] (creates a special container on death)
// CONTAINER_DROP_CHANCE	% chance to drop
// CONTAINER_SCRIPT		[script name, eg chests/quiver_of_poison]
// CONTAINER_PARAM[1-4]	extra params for container (varies with script)
// GOLD_BAGS 1|0 - used to make circles of gold bags for high end beasties
// GOLD_BAGS_PPLAYER - number of bags to spawn per player on server
// GOLD_PER_BAG - amount of gold in each bag
// GOLD_RADIUS - distance to spawn bags from monster
// GOLD_MAX_BAGS - maximum number of gold bags
// NPC_GIVE_EXP - adjustable XP amount
// NPC_BASE_EXP - only used for monsters that are built using includes of other monsters, prevents them from having the same xp

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_anti_stuck.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseMonsterShared
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.1f;
	float NPC_BOSS_REGEN_FREQ = 60.0f;
	float NPC_BOSS_RESTORATION = 0.5f;
	string NPC_CANT_PARRY_TYPES = "target;magic";
	int DEF_STEP_SIZE = 32;
	string PARRY_TYPE = "parried!";

	// Variables (an unset .script variable reads as its own name)
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	bool NPC_SILENT_SUICIDE = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_NO_COUNT = false;
	float NPC_SPAWN_TIME = 0.0f;
	bool NPC_IGNORE_PLAYERS = false;
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	Vector3 NPC_HOME_ANG = Vector3();
	float NPC_ALLY_RESPONSE_RANGE = 0.0f;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	bool DID_HELP_TIP = false;
	string NPC_RANGED = "NPC_RANGED";
	Vector3 NPC_SPAWN_LOC = Vector3();
	Vector3 NPC_SPAWN_ANGLES = Vector3();
	float NPC_HEIGHT = 0.0f;
	float NPC_HALF_HEIGHT = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	bool NPC_ATTACK_MISS = false;
	bool NPC_NO_ATTACK = false;
	bool MOVE_TARGET_IS_NPC = false;
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool AM_FLANKING = false;
	float ADJ_RANGE = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	float FD_LOOP_COUNT = 0.0f;
	bool NPC_PROX_LOOP = false;
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	bool NPC_PROXACT_TRIPPED = false;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_FORCED_MOVEDEST = false;
	float AS_ATTACKING = 0.0f;
	bool NPC_XPTR = false;
	int NPC_NO_AGRO = 0;
	float LAST_STRUCK_FOR = 0.0f;
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float SKEL_RESPAWN_TIMES = 0.0f;
	float MUMMY_LIVES = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	float BMS_RENDERAMT = 0.0f;
	bool NPC_ALERTED_ALL = false;
	string NPC_ALERT_LIST = "NPC_ALERT_LIST";
	string NPC_ALERT_OF = "NPC_ALERT_OF";
	CBaseEntity@ NPC_ALLY_TO_AID = null;
	bool NPC_HOMER_FIRST_CALL = false;
	bool NPC_MADE_IT_HOME = false;
	bool NPC_GOING_HOME = false;
	string NPC_OLD_ANIM_RUN = "NPC_OLD_ANIM_RUN";
	string NPC_OLD_ANIM_WALK = "NPC_OLD_ANIM_WALK";
	string NPC_OLD_ANIM_IDLE = "NPC_OLD_ANIM_IDLE";
	int OLD_NO_STUCK_CHECKS = 0;
	string NPC_OLD_ROAM = "NPC_OLD_ROAM";
	bool NPC_MOVEMENT_SUSPENDED = false;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_IDLE = "ANIM_IDLE";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool NPC_RETURNING_HOME = false;
	float NPC_NEXT_RHOME_WIGGLE = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_NEVER_RESUME_AI = false;
	bool NPC_NEVER_RESUME = false;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	float NPC_DO_ON_DIE = 0.0f;
	float NPC_DO_ON_SPOT = 0.0f;
	bool NPC_WAS_IN_BATTLE = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	bool NPC_TARGET_INVALID = false;
	bool BAST_TELEPORTING = false;

	// unnamed block (first think)
	void BaseMonsterShared_FirstThink()
	{
		NPC_MAX_UNSEEN_TIME = 120.0f;
	}

	// game_spawn
	void BaseMonsterShared_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		if (Truthy(ScriptVarOf(GetVar("GAME_MASTER"), "GM_DISABLE_SPAWNS")))
		{
			// allow suspension of spawns
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 0);
			SetOrigin(ENT_ME, Vector3(20000, 10000, 0));
			OnNpcatkSuspendAi();
			NPC_SILENT_SUICIDE = true;
			NPC_INVISIBLE_SUICIDE = true;
			NPC_NO_COUNT = true;
			OnNpcSuicide();
		}

		NPC_SPAWN_TIME = GameTime();

		if (Truthy(GetVar("G_SIEGE_MAP")) && GetTokenCount(GetVar("G_CRITICAL_NPCS")) > 0)
			CallEventDelayed(0.1f, "npcatk_setup_siege");
	}

	// npc_spawn
	void BaseMonsterShared_OnNpcSpawn(string npc = "")
	{
		OnNpcInitialdrop();
	}

	// npcatk_setup_siege
	void BaseMonsterShared_OnNpcatkSetupSiege()
	{
		bool exitSub = false;

		// in siege maps, 1 in 3 monsters ignore players until struck, prefering to go for the critical NPCs
		if (NPC_NO_SIEGE_HUNT) // Thothie FEB2009 - give option to flag monsters not to hunt critical NPCs
			return;

		if (RaceOf(ENT_ME) == "hguard")
			return;
		if (RaceOf(ENT_ME) == "human")
			return;
		if (RandomInt(1, 3) != 1)
			return;

		if (Contains(ToLowerCase(MapName()), "gertenheld_forest"))
		{
			// Thothie FEB2009 - goblins on gertenheld_forest shouldn't hunt for Jerdid
			if (RaceOf(ENT_ME) == "goblin")
				exitSub = true;
		}
		if (exitSub)
			return;

		NPC_IGNORE_PLAYERS = true;
		OnNpcatkNpcHunterLoop();

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
		{
			SetProp(ENT_ME, "rendermode", 5); // for visual debug
			SetProp(ENT_ME, "renderamt", 255);
		}
	}

	// npc_initialdrop
	void BaseMonsterShared_OnNpcInitialdrop()
	{
		Vector3 origin = MyOrigin() + Vector3(0, 0, 5);
		LegacyCommand("setorigin", origin);
		NPC_HOME_LOC = Text(OriginOf(ENT_ME));
		NPC_HOME_ANG = AnglesOf(ENT_ME);
	}

	// npc_post_spawn
	// this was setup before I realized there was a game_postspawn function - this happens 1.0 seconds after npc_spawn, so still useful
	void BaseMonsterShared_OnNpcPostSpawn()
	{
		float dropGold = 0.0f;
		bool exitSub = false;

		if (Text(NPC_ALLY_RESPONSE_RANGE) == "NPC_ALLY_RESPONSE_RANGE")
		{
			NPC_ALLY_RESPONSE_RANGE = MyMaxHealth();
			float npcAllyRangeRatio = NPC_ALLY_RESPONSE_RANGE;
			if (npcAllyRangeRatio > 1000.0f)
				npcAllyRangeRatio = 1000.0f;
			npcAllyRangeRatio = Divide(npcAllyRangeRatio, 1000.0f);
			NPC_ALLY_RESPONSE_RANGE = Ratio(npcAllyRangeRatio, 256, 1024);
		}

		if (NPC_NO_AGRO != 0)
			OnNpcatkSuspendAi();

		if (NPC_NO_ROAM)
			SetRoam(false);
		if (NPC_FORCE_ROAM)
			SetRoam(true);

		if (NPC_IS_BOSS)
		{
			NPC_BOSS_KILLS = "";
			NPC_BOSS_KNOWS = "";
			NPC_BOSS_KNOWS_AMTS = "";
			// callexternal GAME_MASTER gm_clear_boss_kills //no longer in use
			CallEventDelayed(0.1f, "npcatk_boss_regen");
		}

		if (DROP_GOLD != 0)
		{
			if (Float(GetVar("DROP_GOLD_MAX")) != 0.0f)
				dropGold = RandomInt(Int(GetVar("DROP_GOLD_MIN")), Int(GetVar("DROP_GOLD_MAX")));
			if (DROP_GOLD_AMT != 0.0f)
			{
				// FEB2010_06 - allow override of gold amount by upper script
				if (GetVar("OVR_DROP_GOLD_AMT") == "OVR_DROP_GOLD_AMT")
					dropGold = DROP_GOLD_AMT;
				else
					dropGold = Float(GetVar("OVR_DROP_GOLD_AMT"));
			}
			// FEB2011_27 - adjust gold drop by XP adj
			SetGold(int(dropGold));
		}

		if (!Truthy(GetVar("OVERRIDE_NODROP")) && Truthy(GetVar("G_NO_DROP")))
			exitSub = true;
		if (exitSub)
			return;

		if (NPC_NO_DROPS)
			return;
		if (RandomInt(1, 100) <= Float(DROP_ITEM1_CHANCE))
		{
			// dbg got DROP_ITEM1
			GiveItem(GetVar("DROP_ITEM1"));
		}
		if (RandomInt(1, 100) <= Float(DROP_ITEM2_CHANCE))
		{
			// dbg got DROP_ITEM2
			GiveItem(GetVar("DROP_ITEM2"));
		}
		if (RandomInt(1, 100) <= Float(DROP_ITEM3_CHANCE))
			GiveItem("DROP_ITEM3");
		if (RandomInt(1, 100) <= Float(DROP_ITEM4_CHANCE))
			GiveItem("DROP_ITEM4");
		if (RandomInt(1, 100) <= 0.0f)
			GiveItem("DROP_ITEM5");
	}

	// game_targeted_by_player
	// Player first sees a monster
	// 1: Player
	void BaseMonsterShared_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		// dbg targeted: rng: $get(PARAM1,range) b_prxact: NPC_PROX_ACTIVATE mrng: NPC_PROXACT_RANGE ifseen: NPC_PROXACT_IFSEEN fov: NPC_PROXACT_CONE trip: NPC_PROXACT_TRIPPED
		if (NPC_CRITICAL)
		{
			// treat critical NPC's as players in terms of viewable health
			CallExternal(player, "ext_show_hbar_monster", self, 1);
		}

		if (Truthy(GetVar("NPC_BATTLE_ALLY")))
		{
			// treat critical NPC's as players in terms of viewable health
			CallExternal(player, "ext_show_hbar_monster", self, 1);
		}

		// FEB2009 - fixing bugs with prox activation
		if (Truthy(GetVar("NPC_PROX_ACTIVATE")) && !NPC_PROXACT_TRIPPED)
		{
			if (RangeTo(player) < Float(GetVar("NPC_PROXACT_RANGE")))
				OnNpcatkProxActivated(player, "spottedme_inrange");
			if (!NPC_PROXACT_TRIPPED && Truthy(GetVar("NPC_PROXACT_IFSEEN")))
				OnNpcatkProxActivated(player, "spottedme");
		}

		// works, but annoying
		// callexternal PARAM1 ext_show_hbar_monster $get(ent_me,id)
		if (DID_HELP_TIP)
			return;
		DID_HELP_TIP = true;

		string text = "You are looking at " + Eval("game.monster.name") + ".|It's hostile! Kill it!";
		text += "|You gain skill this way.  Eventually gaining skill";
		string text2 = "|in a weapon will earn you a title and access to|new abilities.";
		HelpTip(player, "help_monster", "Monster", text, text2);
	}

	// bm_gold_spew
	// PARAM1=gold_per_bag PARAM2=bags_player PARAM3=dist_from_mon PARAM4=min#bags PARAM5 max#bags
	void BaseMonsterShared_OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0)
	{
		// dbg bm_gold_spew ( PARAM1 PARAM2 PARAM3 PARAM4 PARAM5 ) gold_per_bag OUT_PAR1 bags_pplayer OUT_PAR2 dist OUT_PAR3 minbags OUT_PAR4 maxbags OUT_PAR5
		CallExternal(GetVar("GAME_MASTER"), "gold_spew", goldPerBag, bagsPerPlayer, distance, minBags, maxBags, OriginOf(ENT_ME));
	}

	// npcatk_get_postspawn_properties
	// moved from base_npc - called before npc_post_spawn
	void BaseMonsterShared_OnNpcatkGetPostspawnProperties()
	{
		// if ( !$get(GAME_MASTER,exists) ) createnpc game_master $vec(20000,-10000,-20000)
		if (NPC_RANGED == "NPC_RANGED")
		{
			if (ATTACK_RANGE > 255.0f)
				NPC_RANGED = "1";
			if (Float(GetVar("MOVE_RANGE")) > 255.0f)
				NPC_RANGED = "1";
		}

		NPC_SPAWN_LOC = MyOrigin();
		NPC_SPAWN_ANGLES = MyAngles();

		// ==== STEP SIZE CONTROL
		NPC_HEIGHT = Float(Eval("game.monster.height"));
		NPC_HALF_HEIGHT = Divide(NPC_HEIGHT, 2.0f); // SEP2009 - fixed typo here
		MIN_ATTACK_RANGE = NPC_HALF_HEIGHT + 37.0f + 10.0f; // half human player height

		// if ( ATTACK_HITRANGE <= MIN_ATTACK_RANGE ) //dbg Warning: Monster's atkrng is below minimum required! ( is: ATTACK_HITRANGE min: MIN_ATTACK_RANGE )
		if (Truthy(GetVar("NPC_PROX_ACTIVATE")))
		{
			if (!NPC_PROXACT_TRIPPED) // FEB2009 maybe tripped before postspawn props are done
			{
				OnNpcatkSuspendAi("proxact:postspawn_props");
				OnNpcatkProxactScan();
			}
		}
	}

	// adj_step_size
	void BaseMonsterShared_OnAdjStepSize()
	{
		bool exitSub = false;

		if (Truthy(GetVar("G_NO_STEP_ADJ")))
			return;
		if (NO_STEP_ADJ)
			return;
		if (Eval("game.monster.race") == "human" && !Truthy(GetVar("NPC_BATTLE_ALLY")))
			exitSub = true;
		if (exitSub)
			return;

		string mapName = MapName();
		if (mapName == "unrest2_beta1")
			exitSub = true;
		if (mapName == "unrest2")
			exitSub = true;
		if (exitSub)
		{
			// unrest2 has strange stuff
			LegacyCommand("maxslope", 90);
			SetStepSize(1000);
		}
		if (exitSub)
			return;

		int finalStepsize = DEF_STEP_SIZE;
		if (Float(Eval("game.monster.height")) < DEF_STEP_SIZE)
		{
			finalStepsize = Int(Eval("game.monster.height"));
			if (Float(Eval("game.monster.height")) < 18.0f)
				finalStepsize = 18;
		}

		SetStepSize(finalStepsize); // 'sparimental
	}

	// game_damaged_other
	// { [server] npcatk_to_ground
	// local MY_POS game.monster.origin
	// local MY_GROUND $get_ground_height(MY_POS)
	// add MY_GROUND 1
	// local MY_X $vec.x(MY_POS)
	// local MY_Y $vec.y(MY_POS)
	// setorigin ent_me (MY_X,MY_Y,MY_GROUND)
	// }
	string BaseMonsterShared_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		NPC_LAST_DAMAGED_OTHER_TIME = GameTime();
		NPC_ATTACK_MISS = false;
		return result;
	}

	// npcatk_suspend_attack
	// PARAM1 = time to resume
	void BaseMonsterShared_OnNpcatkSuspendAttack(float time = 0.0f)
	{
		if (NPC_NO_ATTACK)
			return;
		NPC_NO_ATTACK = true;
		CallEventDelayed(time, "npcatk_resume_attack");
	}

	// npcatk_resume_attack
	void BaseMonsterShared_OnNpcatkResumeAttack()
	{
		if (!NPC_NO_ATTACK)
			return;
		NPC_NO_ATTACK = false;
	}

	// npcatk_flank
	// <param1> flank target
	void BaseMonsterShared_OnNpcatkFlank(string target = "")
	{
		Vector3 newDest = OriginOf(target);
		int rAng = RandomInt(0, 359);
		newDest += RelativePosition(Vector3(0, rAng, 0), Vector3(0, MONSTER_WIDTH, 0));
		OnNpcatkSuspendAttack(2.0f);
		MOVE_TARGET_IS_NPC = false;
		NPC_MOVEDEST_TARGET = Text(newDest);
		SetMoveDest(NPC_MOVEDEST_TARGET, MONSTER_WIDTH);
	}

	// flank_thrash_move_dest
	void BaseMonsterShared_OnFlankThrashMoveDest()
	{
		if (!AM_FLANKING)
			return;
		SetMoveDest("NPC_FLANK_REPOS", 5);
		CallEventDelayed(0.1f, "flank_thrash_move_dest");
	}

	// npcatk_resume_ai
	void BaseMonsterShared_OnNpcatkResumeAi(string target = "")
	{
		AM_FLANKING = false;
	}

	// game_reached_dest
	void BaseMonsterShared_OnGameReachedDest()
	{
		if (!AM_FLANKING)
			return;
		if (!(Distance(MyOrigin(), Vec("NPC_FLANK_REPOS")) <= 2.0f))
			return;
		// dbg temp reached flank pos
		OnNpcatkResumeAi();
	}

	// npcatk_range_adj
	// { npcatk_attackenemy //old AI
	// callevent npcatk_check_miss
	// }
	// { npcatk_attack //new AI
	// callevent npcatk_check_miss
	// }
	void BaseMonsterShared_OnNpcatkRangeAdj()
	{
		CBaseEntity@ targ = null;

		// doesn't adjust the hitrange directly, but returns adjusted range as ADJ_RANGE
		// best if used just prior to dodamage in model attack event
		if (!Truthy(GetVar("NEW_AI")))
			@targ = EntityOf(GetVar("HUNT_LASTTARGET"));
		if (Truthy(GetVar("NEW_AI")))
			@targ = EntityOf(NPCATK_TARGET);

		float targetHalfheight = Clamp(Divide(HeightOf(targ), 2.0f), 37.0f, 2000.0f);

		ADJ_RANGE = ATTACK_RANGE;
		if (!(ATTACK_RANGE < 256.0f)) // do not adjust ranges for archers
			return;

		Vector3 targPos = OriginOf(targ);
		float myZ = MyOrigin().z;
		float targZ = targPos.z;
		float zDiff = targZ;
		myZ += targetHalfheight;
		zDiff -= myZ;
		if (zDiff < 0.0f)
			zDiff = -zDiff;
		float finalAttackRange = ATTACK_RANGE;
		if (zDiff > targetHalfheight) // PLAYER_HALFHEIGHT
			ADJ_RANGE = ATTACK_HITRANGE;
	}

	// game_parry
	void BaseMonsterShared_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlayerMessage(attacker, "Your attack was " + PARRY_TYPE);
	}

	// npcatk_find_distant
	// <max_range> returns NPC_MOST_DISTANT - most distant player in range of PARAM1
	void BaseMonsterShared_OnNpcatkFindDistant(string maxRange = "")
	{
		NPC_MOST_DISTANT = "unset";
		FD_MAX_RANGE = maxRange;
		if (FD_MAX_RANGE.isEmpty())
			FD_MAX_RANGE = "1024";
		SetVar("FD_PLIST", GetActivePlayers());
		FD_LOOP_COUNT = 0.0f;
		int count = GetTokenCount("FD_PLIST");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkFdLoop();
		}
	}

	// npcatk_fd_loop
	void BaseMonsterShared_OnNpcatkFdLoop()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("FD_PLIST", int(FD_LOOP_COUNT)));
		FD_LOOP_COUNT += 1.0f;

		bool doNotStore = false;
		if (RangeTo(curPlayer) > Float(FD_MAX_RANGE))
			doNotStore = true;
		if (!IsAlive(curPlayer))
			doNotStore = true;
		if (doNotStore)
			return;
		if (!(RangeTo(curPlayer) > RangeTo(NPC_MOST_DISTANT)))
			return;
		// dbg npcatk_fd_loop:STORED: $get(CUR_PLAYER,name)
		NPC_MOST_DISTANT = EntityId(curPlayer);
	}

	// npcatk_proxact_scan
	void BaseMonsterShared_OnNpcatkProxactScan()
	{
		if (NPC_PROXACT_TRIPPED)
			return;
		SetVar("LPLAYERS", GetActivePlayers());
		NPC_PROX_LOOP = false;
		NPC_PROXACT_INRANGE = false;
		int count = GetTokenCount("LPLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkProxactLplayers();
		}
		if (NPC_PROXACT_INRANGE)
			OnNpcatkProxActivated(NPC_PROXACT_SCANID, "player_scan");

		if (NPC_PROXACT_TRIPPED) // might get reset above
			return;
		CallEventDelayed(1.0f, "npcatk_proxact_scan");
	}

	// npcatk_prox_activated
	// FEB2009 - fixed various bugs regarding proximity activation
	// PARAM1 = activating player PARAM2 = reason
	void BaseMonsterShared_OnNpcatkProxActivated(CBaseEntity@ player = null, string reason = "")
	{
		bool exitSub = false;

		DebugPrint("npcatk_prox_activated: " + NameOf(player) + " " + reason);

		if (reason != "struck" && Truthy(GetVar("NPC_PROXACT_FOV")))
		{
			Vector3 testOrig = OriginOf(player);
			if (!WithinCone2D(testOrig, MyOrigin(), MyAngles(), Float(GetVar("NPC_PROXACT_CONE"))))
			{
				if (Truthy(GetVar("G_DEVELOPER_MODE")))
					MessageAll("green", NameOf(ENT_ME) + " npcatk_prox_activated " + NameOf(player) + " " + GetVar("NPC_PROXACT_CONE") + " " + Text(WithinCone2D(testOrig, MyOrigin(), MyAngles(), Float(GetVar("NPC_PROXACT_CONE")))));
				exitSub = true;
				DebugPrint("npcatk_prox_activated: Not in FOV!");
			}
		}
		if (exitSub)
			return;

		@NPC_PROXACT_PLAYERID = player;
		if (NPC_PROXACT_TRIPPED)
			return;
		NPC_PROXACT_TRIPPED = true;
		if (GetVar("NPC_PROXACT_DELAY") == "NPC_PROXACT_DELAY")
			CallEventOrDelay(GetVar("NPC_PROXACT_EVENT"));
		else
			CallEventOrDelay(GetVar("NPC_PROXACT_DELAY"), GetVar("NPC_PROXACT_EVENT"));
	}

	// npcatk_proxact_lplayers
	// get player list, set PLAYER_INRANGE
	void BaseMonsterShared_OnNpcatkProxactLplayers()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("LPLAYERS", loopIteration));
		// if ( G_DEVELOPER_MODE ) messageall green nup: $get(ent_me,name) npcatk_proxact_lplayers $get(CUR_PLAYER,range) vs NPC_PROXACT_RANGE
		if (!(RangeTo(curPlayer) < Float(GetVar("NPC_PROXACT_RANGE"))))
			return;
		NPC_PROXACT_INRANGE = true;
		@NPC_PROXACT_SCANID = curPlayer;
	}

	// game_heardsound
	void BaseMonsterShared_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (Truthy(GetVar("NPC_HEARDSOUND_OVERRIDE")))
			return;

		if (Truthy(GetVar("NPC_PROX_ACTIVATE")) && !NPC_PROXACT_TRIPPED)
		{
			CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
			if (IsPlayer(lastHeard) && RangeTo(lastHeard) < Float(GetVar("NPC_PROXACT_RANGE")))
				OnNpcatkProxActivated(lastHeard, EntityId(lastHeard));
		}
	}

	// ext_super_lure
	// { gen_cmd
	// PARAM1 PARAM2 PARAM3 PARAM4 PARAM5 PARAM6
	// }
	// { npcatk_get_nplayers
	// //determine party strength for monster scaling
	// local TOTAL_HP game.players.totalhp
	// local ONE_PLAYER G_WARN_HP
	// multiply ONE_PLAYER 2.0
	// if ( ONE_PLAYER < 500 ) local ONE_PLAYER 500
	// setvard NPC_PARTY_STRENGTH TOTAL_HP
	// divide NPC_PARTY_STRENGTH ONE_PLAYER
	// setvard NPC_PARTY_STRENGTH $int(NPC_PARTY_STRENGTH)
	// if ( NPC_PARTY_STRENGTH < 1 ) setvard NPC_PARTY_STRENGTH 1
	// }
	// { npcatk_ramp_monster
	// //ramp monters based on party strength
	// //get party strength
	// callevent npcatk_get_nplayers
	// local N_PLAYERS NPC_PARTY_STRENGTH
	// subtract N_PLAYERS 1
	// if N_PLAYERS > 0
	// if ( N_PLAYERS < G_CVAR_DIFF ) local N_PLAYERS G_CVAR_DIFF
	// //Old AI can't adamage adjust so less XP bonus
	// if ( NEW_AI )
	// {
	// local NPC_BOSS_EXP_ADJ NPC_BOSS_EXP_ADJ_NEW
	// local NPC_NORM_EXP_ADJ NPC_NORM_EXP_ADJ_NEW
	// }
	// if ( !NEW_AI )
	// {
	// local NPC_BOSS_EXP_ADJ NPC_BOSS_EXP_ADJ_OLD
	// local NPC_NORM_EXP_ADJ NPC_NORM_EXP_ADJ_OLD
	// }
	// //bosses ( >=1500hp ) ramp differently than minions
	// if ( NPC_MAXHP < 1500 )
	// {
	// //normal monsters tripple at 8 players
	// local EXP_ADJ NPC_NORM_EXP_ADJ //0.1
	// local HP_ADJ NPC_NORM_HP_ADJ //0.25
	// local DMG_ADJ NPC_NORM_DMG_ADJ //0.20
	// local MAX_CAP NPC_NORM_CAP //3.0
	// }
	// if ( NPC_MAXHP >= 1500 )
	// {
	// //boss monsters double at 8 players
	// local EXP_ADJ NPC_BOSS_EXP_ADJ //0.05
	// local HP_ADJ NPC_BOSS_HP_ADJ //0.1
	// local DMG_ADJ NPC_BOSS_DMG_ADJ //0.1
	// local MAX_CAP NPC_BOSS_CAP //2.0
	// }
	// multiply EXP_ADJ N_PLAYERS
	// multiply HP_ADJ N_PLAYERS
	// multiply DMG_ADJ N_PLAYERS
	// //increase XP by 5-10% / player
	// if ( NPC_GIVE_EXP > 0 )
	// {
	// local F_CAP NPC_GIVE_EXP
	// multiply F_CAP MAX_CAP
	// local FINAL_XP NPC_GIVE_EXP
	// multiply FINAL_XP EXP_ADJ
	// add FINAL_XP NPC_GIVE_EXP
	// capvar FINAL_XP NPC_GIVE_EXP F_CAP
	// setvard NPC_GIVE_EXP FINAL_XP
	// skilllevel NPC_GIVE_EXP
	// }
	// //increase HP 10-25% / player
	// if ( NPC_MAXHP > 0 )
	// {
	// local F_CAP NPC_MAXHP
	// multiply F_CAP MAX_CAP
	// //dbg temp basehp NPC_MAXHP x cap MAX_CAP = max F_CAP
	// local FINAL_HP NPC_MAXHP
	// multiply FINAL_HP HP_ADJ
	// add FINAL_HP NPC_MAXHP
	// //dbg temp basehp NPC_MAXHP x adj HP_ADJ = FINAL_HP
	// capvar FINAL_HP NPC_MAXHP F_CAP
	// hp FINAL_HP
	// setvard NPC_MAXHP FINAL_HP
	// }
	// //increase damage 10-20% / player (make this code side as only works on new AI and doesnt affect some types of damage)
	// capvar DMG_ADJ 0 2.0
	// add NPC_DMG_MULTI DMG_ADJ
	// dmgmulti NPC_DMG_MULTI
	// //add NPC_DMG_MULTI 1
	// }
	// PARAM1=id PARAM2=race PARAM3=run/walk
	void BaseMonsterShared_OnExtSuperLure(CBaseEntity@ lureTarget = null, string race = "", string moveMode = "")
	{
		bool exitSub = false;

		// super lures attract monsters that have no valid targets
		// they can be setup to attract only monsters of a paticular race
		// and monsters can either walk or run to the target
		// dbg ext_super_lure PARAM1 PARAM2 PARAM3
		if (!IsAlive(ENT_ME))
			return;
		if (IsAlive(NPCATK_TARGET))
			return;
		if (CanSee("enemy"))
			return;
		if (race != "all" && RaceOf(ENT_ME) != race)
			exitSub = true;
		if (exitSub)
			return;
		if (RaceOf(ENT_ME) == "human")
			return;
		if (RaceOf(ENT_ME) == "hguard")
			return;
		if (moveMode == "run")
			OnNpcatkRun();
		OnNpcatkSetmovedest(EntityId(lureTarget), "32");
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(@lureTarget, 32);
	}

	// npcatk_run
	void BaseMonsterShared_OnNpcatkRun()
	{
		bool exitSub = false;

		// dbg runmode_cuz PARAM1
		SetMoveAnim(ANIM_RUN);
		AS_ATTACKING = GameTime() + 1.0f;
		if (IsAlive(NPCATK_TARGET))
			exitSub = true;
		if (exitSub)
			return;
	}

	// npcatk_walk
	void BaseMonsterShared_OnNpcatkWalk()
	{
		// dbg walkmode_cuz PARAM1
		SetMoveAnim(ANIM_WALK);
		PlayAnim("once", ANIM_WALK);
		AS_ATTACKING = GameTime();
	}

	// game_struck
	void BaseMonsterShared_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_XPTR && IsPlayer(ENT_LASTSTRUCK))
		{
			NPC_XPTR = false; // xp ramp over time ends on first struck
		}

		if (NPC_NO_AGRO == 1 && Truthy(GetVar("SUSPEND_AI")))
		{
			NPC_NO_AGRO = 2;
			OnNpcatkResumeAi();
			OnNpcatkSettarget(EntityId(EntityOf(ENT_LASTSTRUCK)), "go_agro");
		}

		// FEB2009 - prox act should activate if struck, regardless
		if (Truthy(GetVar("NPC_PROX_ACTIVATE")) && !NPC_PROXACT_TRIPPED)
			OnNpcatkProxActivated(EntityOf(ENT_LASTSTRUCK), "struck");

		LAST_STRUCK_FOR = damage;

		if (NPCATK_TARGET == "unset" && RelationshipOf(ENT_LASTSTRUCK, ENT_ME) != "ally" && !CanDamage(ENT_LASTSTRUCK))
		{
			// holy crap I was attacked by something I can't kill, run!
			OnNpcatkFlee(EntityId(EntityOf(ENT_LASTSTRUCK)), "768", "5.0");
		}

		// if ( $get(ent_me,hp) <= 0 )
		// {
		// setalive 0
		// skilllevel 0 //stop sploiting invuln monsters
		// }
		// siege map system
		if (!IsPlayer(ENT_LASTSTRUCK))
			return;
		if (NPC_IGNORE_PLAYERS)
		{
			// siege map system
			NPC_LAST_STRUCK_TIME = GameTime();
			CallEventDelayed(10.0f, "npcatk_resume_civi_hunt"); // if not struck again within 10 seconds, resume hunting NPCs (ie. ignore players)
		}
		NPC_IGNORE_PLAYERS = false;
	}

	// npcatk_resume_civi_hunt
	void BaseMonsterShared_OnNpcatkResumeCiviHunt()
	{
		// siege map system
		if (NPC_IGNORE_PLAYERS)
			return;

		float timeSinceStruck = GameTime() - NPC_LAST_STRUCK_TIME;
		if (!(timeSinceStruck > 8.0f))
			return;
		OnNpcatkClearTargets("not_struck");
		NPC_IGNORE_PLAYERS = true;
		OnNpcatkNpcHunterLoop();
	}

	// npcatk_npc_hunter_loop
	void BaseMonsterShared_OnNpcatkNpcHunterLoop()
	{
		// siege map system: pick a random critical NPC to hunt, if current target invalid/dead
		if (!NPC_IGNORE_PLAYERS)
			return;
		CallEventDelayed(5.0f, "npcatk_npc_hunter_loop");
		int nCrits = GetTokenCount(GetVar("G_CRITICAL_NPCS"));
		int rndCrit = RandomInt(0, nCrits);
		if (IsAlive(NPCATK_TARGET))
			return;
		OnNpcatkSettarget(GetToken(GetVar("G_CRITICAL_NPCS"), rndCrit));
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type Param4=AccuracyRoll
	string BaseMonsterShared_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool blockPrematureDamage = false;
		string result = "";

		// new internalized parry system
		if (Contains(damageType, "holy"))
		{
			// with few exceptions, undeads struck by holy do not rise again
			SKEL_RESPAWN_TIMES = 99.0f;
			MUMMY_LIVES = 0.0f;
		}

		NPC_LAST_DAMAGED_TIME = GameTime();

		float sinceSpawn = GameTime() - NPC_SPAWN_TIME;
		if (sinceSpawn < 2.0f && !NPC_OVERRIDE_DEATH)
		{
			if (RelationshipOf(attacker, ENT_ME) == "enemy")
				blockPrematureDamage = true;
			if (IsPlayer(attacker))
				blockPrematureDamage = true;
			if (blockPrematureDamage)
				result = AppendResult(result, "0");
		}

		if (NPC_NO_PLAYER_DMG)
		{
			// character is immune to player damage
			// function added DEC2008a (took us awhile to figure this out)
			if (IsPlayer(attacker))
				result = AppendResult(result, "0");
		}
		// (never true here, the rest is skipped) if MONSTER_PARRY > 0
		return result;
	}

	// start_running
	// external/params call - start running when spawned
	void BaseMonsterShared_OnStartRunning()
	{
		CallEventDelayed(0.1f, "cycle_up");
		CallEventDelayed(0.2f, "npcatk_run");
	}

	// make_fade_in
	// =============== debuggary entries - comment before distro
	// { ext_touch_on
	// setcallback touch enable
	// setprop ent_me solid 1
	// }
	// This seems to be same as game_damaged - maybe can adjust damage here? (check code)
	// { game_attacked
	// dbg game_attacked PARAM1 PARAM2 PARAM3 PARAM4
	// }
	// This works, but is more or less useless due to all the internal anim setting
	// - This function has been axed, seek "* PLAYANIM *" ms.dll code if you want to restore it
	// { game_anim_new
	// //dbg game_anim_new PARAM1
	// }
	// { game_damaged
	// if G_DEVELOPER_MODE
	// gplayermessage PARAM1 PARAM3 element
	// }
	void BaseMonsterShared_OnMakeFadeIn()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 2);
		BMS_RENDERAMT = 0.0f;
		CallEventDelayed(0.1f, "make_fade_in_loop");
	}

	// make_fade_in_loop
	void BaseMonsterShared_OnMakeFadeInLoop()
	{
		BMS_RENDERAMT += 10.0f;
		if (BMS_RENDERAMT < 255.0f)
		{
			SetProp(ENT_ME, "rendermode", 2);
			SetProp(ENT_ME, "renderamt", BMS_RENDERAMT);
			CallEventDelayed(0.1f, "make_fade_in_loop");
		}
		if (BMS_RENDERAMT >= 255.0f)
		{
			SetProp(ENT_ME, "rendermode", 0);
			SetProp(ENT_ME, "renderamt", 255);
		}
	}

	// game_killed_player
	// PARAM1=player - goes off whenever a monster kills a player
	void BaseMonsterShared_OnGameKilledPlayer(CBasePlayer@ player = null)
	{
		float resistAmt = 0.0f;

		// last theory is that sometimes this is going off for no reason
		// if $get(PARAM1,name) isnot 0
		if (!IsPlayer(player))
			return;

		if (!NPC_IS_BOSS)
			GiveHealth(MaxHealthOf(player));

		if (NPC_IS_BOSS && !Truthy(ScriptVarOf(player, "PLR_BRAVERY")))
		{
			// this is a separate  system
			// if ( NPC_BOSS_RESTORATION > 0 ) callevent npcatk_add_boss_kill $get(PARAM1,id)
			string playerId = SteamIdOf(player);
			playerId = Right(playerId, 6);
			// if $len(PLAYER_ID) == 6
			// dbg adding PLAYER_ID [len $len(PLAYER_ID) ]
			int knowIdx = FindToken(NPC_BOSS_KNOWS, playerId);
			if (knowIdx == -1)
			{
				// player 404'd - add him
				if (int(NPC_BOSS_KNOWS.length()) < 210) // dont add any more ID's, token string get too long
				{
					NPC_BOSS_KNOWS = TokenAdd(NPC_BOSS_KNOWS, playerId);
					NPC_BOSS_KNOWS_AMTS = TokenAdd(NPC_BOSS_KNOWS_AMTS, "0.95");
					resistAmt = 0.95f;
				}
			}
			if (knowIdx > -1)
			{
				// found player, dock him another 10%
				resistAmt = Float(GetToken(NPC_BOSS_KNOWS_AMTS, knowIdx));
				if (resistAmt > 0.0f)
				{
					resistAmt -= 0.05f;
					NPC_BOSS_KNOWS_AMTS = TokenSet(NPC_BOSS_KNOWS_AMTS, knowIdx, Text(resistAmt));
				}
			}

			if (resistAmt > 0.0f)
			{
				// warn him
				string msgTitle = "Defeated by Boss " + NameOf(ENT_ME);
				string msgText = "Your weapons and spells are now only ";
				if (resistAmt == 0.95f) // first warning gets a pop-up
					HelpTip(player, "generic", "Boss Monsters learn your tactics!", "Boss monsters become more effective at defending themselves against you each they defeat you.|Try to avoid being slain by them!");
				resistAmt *= 100.0f;
				msgText += Text(int(resistAmt)) + "% effective against him.";
				InfoMessage(player, msgTitle, msgText);
			}
			if (resistAmt <= 0.0f)
				InfoMessage(player, "Useless...", "You've been defeated so many times by this boss that your attacks are no longer effective.");
		}
	}

	// npcatk_boss_regen
	void BaseMonsterShared_OnNpcatkBossRegen()
	{
		if (!(NPC_BOSS_REGEN_RATE > 0.0f))
			return;
		float diff = GameTime() - NPC_LAST_DAMAGED_TIME;
		if (diff > 240.0f) // 4 minutes (240 seconds)
		{
			// bosses passively regen 10%[def] of their current hp/minute
			CallEventDelayed(NPC_BOSS_REGEN_FREQ, "npcatk_boss_regen");
			if (IsAlive(ENT_ME) && HealthOf(ENT_ME) > 0.0f)
			{
				float hpToGive = HealthOf(ENT_ME) * NPC_BOSS_REGEN_RATE;
				GiveHealth(hpToGive);
			}
		}
		else
		{
			// dbg regen_pulse HP_TO_GIVE
			CallEventDelayed(diff, "npcatk_boss_regen");
		}
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string BaseMonsterShared_OnGameDamaged_2(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";

		if (!NPC_IS_BOSS)
			return result;

		if (!IsPlayer(attacker))
			return result;
		string playerId = SteamIdOf(attacker);
		playerId = Right(playerId, 6);
		int knowIdx = FindToken(NPC_BOSS_KNOWS, playerId);

		if (knowIdx > -1)
		{
			// consistancy check
			int nKnows = GetTokenCount(NPC_BOSS_KNOWS);
			int nKnowsAmts = GetTokenCount(NPC_BOSS_KNOWS_AMTS);
			if (nKnows != nKnowsAmts)
			{
				// the token system is corrupt or invalid
				// reset
				NPC_BOSS_KNOWS = "";
				NPC_BOSS_KNOWS_AMTS = "";
				exitSub = true;
			}
			if (!exitSub)
			{
				// oh yeah, this guy again, resist damage by how well ye know him
				string resistAmtText = GetToken(NPC_BOSS_KNOWS_AMTS, knowIdx);
				int resistAmt = Int(resistAmtText);
				float inDmg = damage * resistAmt;
				result = AppendResult(result, resistAmtText);
				if (resistAmt <= 0)
					InfoMessage(attacker, "Useless...", "Your weapons and spells no longer have any affect.");
			}
		}
		return result;
	}

	// npcatk_settarget
	// Not using this
	// { npcatk_add_boss_kill //PARAM1=playerid PARAM2=bossid PARAM3=restoration_ratio
	// local IN_PLAYER $get(PARAM1,steamid)
	// //dbg gm_add_boss_kill IN_PLAYER vs BOSS_KILLS
	// if ( $get_find_token(NPC_BOSS_KILLS,PARAM1) == -1 )
	// {
	// token.add NPC_BOSS_KILLS $get(PARAM1,steamid)
	// }
	// dbg gm_add_boss_kill $get_token_amt(NPC_BOSS_KILLS) vs game.players
	// if $get_token_amt(NPC_BOSS_KILLS) == game.players
	// setvard NPC_BOSS_KILLS ''
	// //if a boss kills every player on the server once, restore mass hp
	// if $get(ent_me,isalive)
	// if $get(ent_me,hp) > 0
	// local HP_TO_GIVE $get(ent_me,maxhp)
	// multiply HP_TO_GIVE NPC_BOSS_RESTORATION
	// givehp HP_TO_GIVE
	// local MSG_TITLE $get(ent_me,name)
	// strconc MSG_TITLE " has slain all members of the party!"
	// local MSG_TEXT "Boss regenerates "
	// strconc MSG_TEXT $int(HP_TO_GIVE) "hit points"
	// infomsg all MSG_TITLE MSG_TEXT
	// }
	// { game_touch
	// dbg general game_touch
	// }
	// Thothie JAN2009 - centeralizing/optimizing ally alert system for less server crashes and more effectivness
	// <target> <debug> <debug>
	void BaseMonsterShared_OnNpcatkSettarget(string target = "", string debug = "")
	{
		bool exitSub = false;

		if (NPC_ALERTED_ALL)
			return;
		if (!NPC_FIGHTS_NPCS && !IsPlayer(target)) // dont alert allies for mob on mob action, unless killing mobs is your thing
			exitSub = true;
		if (exitSub)
			return;
		OnNpcatkAlertAllAllies(target);
	}

	// npcatk_alert_all_allies
	void BaseMonsterShared_OnNpcatkAlertAllAllies(string attacker = "")
	{
		DebugPrint("npcatk_alert_all_allies of " + NameOf(attacker) + " " + Text(NPC_ALLY_RESPONSE_RANGE) + " NO_ALERT_ALLIES");

		if (attacker == GetVar("GAME_MASTER"))
			return;
		if (RelationshipOf(attacker, ENT_ME) != "enemy")
			return;

		NPC_ALERTED_ALL = true;
		NPC_ALERT_LIST = FindInSphere("ally", NPC_ALLY_RESPONSE_RANGE);
		// dbg npcatk_alert_all_allies Alerting NPC_ALERT_LIST
		if (NPC_ALERT_LIST == "none")
			return;
		NPC_ALERT_OF = attacker;
		int count = GetTokenCount(NPC_ALERT_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkAlertInRange();
		}
	}

	// npcatk_alert_in_range
	void BaseMonsterShared_OnNpcatkAlertInRange()
	{
		CBaseEntity@ curAlly = FindEntity(GetToken(NPC_ALERT_LIST, loopIteration));
		// dbg npcatk_alert_in_range $get(CUR_ALLY,name)
		CallExternal(curAlly, "npcatk_ally_alert", NPC_ALERT_OF, self, "alert_all_in_range");
	}

	// npcatk_ally_alert
	// <target> <alerter> <debug>
	void BaseMonsterShared_OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null)
	{
		string nmeToTarget = "NME_TO_TARGET";

		// dbg npcatk_ally_alert - targ $get(PARAM1,name) alerter $get(PARAM2,name) reason PARAM3
		if (NPC_NO_AGRO != 0 && Truthy(GetVar("SUSPEND_AI")))
		{
			OnNpcatkResumeAi();
			OnNpcatkSettarget(EntityId(allyToAid), "go_agro_ally_alert");
		}

		if (Truthy(GetVar("SUSPEND_AI")))
			return;

		if (Truthy(GetVar("NEW_AI")))
		{
			if (NPCATK_TARGET == "unset") // ignore if I already have target
			{
				// (always true here) if !NPC_MOVING_LAST_KNOWN
				nmeToTarget = attacker;
				@NPC_ALLY_TO_AID = allyToAid;
				OnNpcatkSettarget(nmeToTarget, "ally_alerted");
				OnNpcAidingAlly(NPC_ALLY_TO_AID);
			}
		}
		else if (GetVar("HUNT_LASTTARGET") == "\xAFNONE\xAF" && !Truthy(GetVar("IS_HUNTING")))
		{
			nmeToTarget = attacker;
			@NPC_ALLY_TO_AID = allyToAid;
			OnNpcatkTarget2(nmeToTarget, "ally_alerted");
			OnNpcAidingAlly(NPC_ALLY_TO_AID);
		}
	}

	// cycle_down
	void BaseMonsterShared_OnCycleDown()
	{
		NPC_ALERTED_ALL = false;

		if (NPC_NO_AGRO != 2)
			return;
		NPC_NO_AGRO = 1;
		OnNpcatkSuspendAi();
	}

	// npcatk_dodamage
	// This is for compatability, not really required anymore, as can be handled code-side via dmgmulti
	// be nice to have an acumulti for altering accuracy (debuff)
	// lots of params (see below), prevents crash from damage stacks
	void BaseMonsterShared_OnNpcatkDodamage(string target = "", string hitRange = "", string damage = "", string hitChance = "", string damageSource = "", string reflective = "", string value = "")
	{
		// (always true here) if !CANT_DAMAGE

		float adjDamage = Float(damage); // param3 is always damage
		float adjHitchance = Float(hitChance); // param4 is always hitchance

		adjDamage *= Float(EXT_DAMAGE_ADJUSTMENT); // apply any external debilitaing effects (ie. curse, etc)
		adjHitchance *= Float(EXT_HITCHANCE_ADJUSTMENT); // apply any external debilitaing effects (ie. curse, etc)

		// multiply ADJ_DAMAGE NPC_DMG_MULTI //handle via dmgmulti command
		// target (origin for AOE)
		// range or 'direct'
		// damage source for direct, fall off for ranged, not used on standard
		// reflective flag (AOE only)

		// dbg dodamage NPC_DMG_PARAM1 NPC_DMG_PARAM2 NPC_DMG_PARAM3 NPC_DMG_PARAM4 NPC_DMG_PARAM5 NPC_DMG_PARAM6 NPC_DMG_PARAM7
		DoDamage(target, hitRange, adjDamage, adjHitchance, damageSource, reflective, value);
	}

	// npcatk_go_home
	// Thothie JAN2009 - fixed this broken function -  moved to shared
	// not called here, useful external - sends monster home after all clear
	void BaseMonsterShared_OnNpcatkGoHome()
	{
		if (!NPC_HOMER_FIRST_CALL)
		{
			NPC_HOMER_FIRST_CALL = true;
			NPC_MADE_IT_HOME = false;
			NPC_GOING_HOME = true; // this is just an indicator for external use
		}

		if (NPCATK_TARGET != "unset")
		{
			// interrupted on way home, reset
			NPC_HOMER_FIRST_CALL = false;
			NPC_MADE_IT_HOME = true;
			NPC_GOING_HOME = false;
		}

		if (NPCATK_TARGET != "unset")
			return;
		if (NPC_MADE_IT_HOME)
			return;

		// dbg npcatk_go_home heading home... [ NPC_MADE_IT_HOME ]
		if (Eval("game.monster.movedest.origin") != Text(NPC_SPAWN_LOC))
			OnNpcatkSetmovedest(Text(NPC_SPAWN_LOC), "1");

		if (Distance(MyOrigin(), NPC_SPAWN_LOC) <= MONSTER_WIDTH)
		{
			// //dbg made it home
			SetMoveDest("none");
			SetAngle("face", NPC_SPAWN_ANGLES);
			NPC_GOING_HOME = false;
			NPC_MADE_IT_HOME = true; // Thothie JAN2009 - fubar
			NPC_HOMER_FIRST_CALL = false;
			OnNpcMadeItHome(); // external - can disable movement here
		}
		else
		{
			CallEventDelayed(1.0f, "npcatk_go_home");
		}
	}

	// npcatk_suspend_movement
	// JAN2010_26 - shared suspend movement functions
	// <idle_anim> [duration]
	void BaseMonsterShared_OnNpcatkSuspendMovement(string idleAnim = "", string duration = "")
	{
		bool exitSub = false;

		SetRoam(false);
		SetMoveAnim(idleAnim);
		SetIdleAnim(idleAnim);

		if (!NPC_MOVEMENT_SUSPENDED)
		{
			// case we get two requests
			NPC_OLD_ANIM_RUN = ANIM_RUN;
			NPC_OLD_ANIM_WALK = ANIM_WALK;
			NPC_OLD_ANIM_IDLE = ANIM_IDLE;
			OLD_NO_STUCK_CHECKS = int(Float(NO_STUCK_CHECKS));
			NPC_OLD_ROAM = GetProp(ENT_ME, "roam");
			DebugPrint("npcatk_suspend_movement oldroam " + NPC_OLD_ROAM);
		}

		NPC_MOVEMENT_SUSPENDED = true;

		ANIM_RUN = idleAnim;
		ANIM_WALK = idleAnim;
		ANIM_IDLE = idleAnim;
		NO_STUCK_CHECKS = "1";

		if (duration.isEmpty())
			exitSub = true;
		if (exitSub)
			return;
		CallEventOrDelay(duration, "npcatk_resume_movement");
	}

	// npcatk_resume_movement
	// <idle_anim>
	void BaseMonsterShared_OnNpcatkResumeMovement()
	{
		if (!NPC_MOVEMENT_SUSPENDED)
			return;
		NPC_MOVEMENT_SUSPENDED = false;

		DebugPrint("npcatk_resume_movement");

		SetRoam(Truthy(NPC_OLD_ROAM));
		ANIM_RUN = NPC_OLD_ANIM_RUN;
		ANIM_WALK = NPC_OLD_ANIM_WALK;
		ANIM_IDLE = NPC_OLD_ANIM_IDLE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		NO_STUCK_CHECKS = OLD_NO_STUCK_CHECKS;
		PlayAnim("break");
	}

	// npcatk_clear_targets
	// JAN2010_29 - shared return home functions
	void BaseMonsterShared_OnNpcatkClearTargets(string reason = "")
	{
		if (!Truthy(GetVar("NPC_RETURN_HOME")))
			return;
		if (NPC_RETURNING_HOME)
			return;
		NPC_RETURNING_HOME = true;
		NPC_NEXT_RHOME_WIGGLE = GameTime() + Random(10, 20);
		DebugPrint("npcatk_clear_targets returning home");
		CallEventDelayed(1.0f, "npcatk_go_home_loop");
	}

	// npcatk_go_home_loop
	void BaseMonsterShared_OnNpcatkGoHomeLoop()
	{
		if (NPCATK_TARGET != "unset")
			NPC_RETURNING_HOME = false;
		if (NPCATK_TARGET != "unset")
			return;
		if (NPC_RETURNING_HOME)
		{
			float homeDist = Distance(Vec(NPC_HOME_LOC), MyOrigin());

			DebugPrint("npcatk_go_home_loop dist " + Text(homeDist) + " getdist " + GetProp(ENT_ME, "movedest.prox"));

			if (homeDist > 64.0f)
			{
				// setvard NPC_FORCED_MOVEDEST 1
				if (GameTime() > NPC_NEXT_RHOME_WIGGLE)
				{
					// wiggle a bit if having trouble getting home
					OnNpcatkSetmovedest(Text(RelativePosition(Vector3(0, Random(0, 359), 0), Vector3(0, 500, 0))), "0");
					PlayAnim("once", ANIM_RUN);
					NPC_NEXT_RHOME_WIGGLE = GameTime() + Random(10, 20);
				}
				else
				{
					OnNpcatkSetmovedest(NPC_HOME_LOC, "32");
					// setmovedest NPC_HOME_LOC 32
					SetRoam(true);
				}
				CallEventDelayed(Random(0.5f, 1.5f), "npcatk_go_home_loop");
			}
			else
			{
				NPC_RETURNING_HOME = false;
				float homeYaw = NPC_HOME_ANG.y;
				SetAngle("face", Vector3(0, homeYaw, 0));
				CallEventDelayed(1.0f, "npcatk_return_home_pos_reset"); // redundant, but sometimes fubars
				SetRoam(false);
				DebugPrint("npcatk_clear_targets made it home");
			}
		}
	}

	// npcatk_return_home_pos_reset
	void BaseMonsterShared_OnNpcatkReturnHomePosReset()
	{
		Vector3 faceSpot = Vec(NPC_HOME_LOC);
		float faceDir = NPC_HOME_ANG.y;
		faceSpot += RelativePosition(Vector3(0, faceDir, 0), Vector3(0, 256, 0));
		SetMoveDest(faceSpot, 9999);
	}

	// game_dodamage
	// debuggary
	// { game_damaged
	// if G_DEVELOPER_MODE
	// gplayermessage G_DEV_PLAYER game_damaged PARAM1 PARAM2 PARAM3
	// }
	string BaseMonsterShared_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		float dot = 0.0f;
		string result = "";

		if (!hit)
			return result;
		if (Contains(damageType, "_effect")) // hacky way to prevent infinite dots
			return result;

		if (NPC_DOT_POISON)
		{
			dot = MaxHealthOf(target) * 0.05f * NPC_DOT_POISON_RATIO;

			if (DamageMultiplierOf(ENT_ME) > 1.0f)
				dot = Divide(dot, DamageMultiplierOf(ENT_ME));

			ApplyEffect(target, "effects/dot_poison", 10.0f, self, dot);
		}
		if (NPC_DOT_FIRE)
		{
			dot = MaxHealthOf(target) * 0.15f * NPC_DOT_FIRE_RATIO;

			if (DamageMultiplierOf(ENT_ME) > 1.0f)
				dot = Divide(dot, DamageMultiplierOf(ENT_ME));

			ApplyEffect(target, "effects/dot_fire", 5.0f, self, dot);
		}
		if (NPC_DOT_COLD)
		{
			dot = MaxHealthOf(target) * 0.05f * NPC_DOT_COLD_RATIO;

			if (DamageMultiplierOf(ENT_ME) > 1.0f)
				dot = Divide(dot, DamageMultiplierOf(ENT_ME));

			ApplyEffect(target, "effects/dot_cold", 5.0f, self, dot);
		}
		if (NPC_DOT_LIGHTNING)
		{
			dot = MaxHealthOf(target) * 0.1f * NPC_DOT_LIGHTNING_RATIO;

			if (DamageMultiplierOf(ENT_ME) > 1.0f)
				dot = Divide(dot, DamageMultiplierOf(ENT_ME));

			ApplyEffect(target, "effects/dot_lightning", 5.0f, self, dot);
		}
		return result;
	}

	// npcatk_clear_targets
	void BaseMonsterShared_OnNpcatkClearTargets_2(string reason = "")
	{
		if (NPC_NO_AGRO != 2)
			return;
		NPC_NO_AGRO = 1;
		OnNpcatkSuspendAi();
	}

	// npcatk_suspend_roam
	// <delay> - assumes roam is on by default
	void BaseMonsterShared_OnNpcatkSuspendRoam(float delay = 0.0f)
	{
		SetRoam(false);
		AS_ATTACKING = GameTime() + delay;
		CallEventDelayed(delay, "npcatk_resume_roam");
	}

	// npcatk_resume_roam
	void BaseMonsterShared_OnNpcatkResumeRoam()
	{
		SetRoam(true);
	}

	// npcatk_suspend_ai
	void BaseMonsterShared_OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		if (Truthy(GetVar("SUSPEND_AI")))
			return;
		NPC_LAST_SUSPEND_AI = GameTime();
		NPC_RESUME_AI_TIME = GameTime();
		if (!seconds.isEmpty())
		{
			NPC_RESUME_AI_TIME += Float(seconds);
		}
		else
		{
			NPC_NEVER_RESUME_AI = true;
			NPC_RESUME_AI_TIME = 999.0f;
		}
	}

	// npcatk_resume_ai
	void BaseMonsterShared_OnNpcatkResumeAi_2(string target = "")
	{
		if (!Truthy(GetVar("SUSPEND_AI")))
			return;
		NPC_NEVER_RESUME = false;
	}

	// npcatk_fx_sprite_in1
	// fancier
	void BaseMonsterShared_OnNpcatkFxSpriteIn1()
	{
		float spriteScale = 0.0f;
		if (HeightOf(ENT_ME) <= 64.0f)
			spriteScale = 1.0f;
		if (HeightOf(ENT_ME) > 128.0f)
			spriteScale = 2.0f;
		if (HeightOf(ENT_ME) > 200.0f)
			spriteScale = 4.0f;
		Vector3 origin = OriginOf(ENT_ME);
		if (!Truthy(GetProp(ENT_ME, "fly")))
		{
			float hheight = HeightOf(ENT_ME) * 0.5f;
			origin.z += hheight;
		}
		ClientEvent("new", "all", "effects/sfx_sprite_in", origin, "c-tele1.spr", 25, spriteScale);
		if (NPC_DO_SPAWN_SOUND)
			PlaySound(0, 10, "magic/spawn_loud.wav");
	}

	// npcatk_fx_sprite_in2
	// precache friendly
	void BaseMonsterShared_OnNpcatkFxSpriteIn2()
	{
		float spriteScale = 0.0f;
		if (HeightOf(ENT_ME) <= 64.0f)
			spriteScale = 3.0f;
		if (HeightOf(ENT_ME) > 128.0f)
			spriteScale = 5.0f;
		if (HeightOf(ENT_ME) > 200.0f)
			spriteScale = 7.0f;
		Vector3 origin = OriginOf(ENT_ME);
		if (!Truthy(GetProp(ENT_ME, "fly")))
		{
			float hheight = HeightOf(ENT_ME) * 0.5f;
			origin.z += hheight;
		}
		ClientEvent("new", "all", "effects/sfx_sprite_in", origin, "xflare1.spr", 20, spriteScale);
		if (NPC_DO_SPAWN_SOUND)
			PlaySound(0, 10, "magic/spawn_loud.wav");
	}

	// npcatk_handle_postevents
	void BaseMonsterShared_OnNpcatkHandlePostevents()
	{
		// for param triggered events that happen a split second after spawn
		if (NPC_SPRITE_IN == 1)
			OnNpcatkFxSpriteIn1();
		else if (NPC_SPRITE_IN == 2)
			OnNpcatkFxSpriteIn2();
		else if (NPC_DO_SPAWN_SOUND)
			PlaySound(0, 10, "magic/spawn_loud.wav");
	}

	// cycle_down
	void BaseMonsterShared_OnCycleDown_2()
	{
		OnNpcatkClearMusic();
	}

	// npcatk_clear_music
	void BaseMonsterShared_OnNpcatkClearMusic()
	{
		if (!NPC_CUSTOM_COMBAT_MUSIC)
			return;
		PlayMusic("all", "stop");
	}

	// game_death
	void BaseMonsterShared_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_WAS_IN_BATTLE)
			CallExternal("players", "ext_untargeted_by_mob", self);
		OnCycleDown();

		NPC_PREV_TARGET = "unset"; // in case fake death

		if (NPC_DO_ON_DIE > 0.0f && NPC_SAY_ON_DIE != "NPC_SAY_ON_DIE")
		{
			NPC_DO_ON_DIE -= 1.0f;
			SayText(NPC_SAY_ON_DIE);
		}
	}

	// npc_targetsighted
	// calm down if not seen or been near target for awhile
	void BaseMonsterShared_OnNpcTargetsighted(string target = "")
	{
		if (NPC_DO_ON_SPOT > 0.0f && NPC_SAY_ON_SPOT != "NPC_SAY_ON_SPOT")
		{
			NPC_DO_ON_SPOT -= 1.0f;
			SayText(NPC_SAY_ON_SPOT);
		}

		if (Truthy(GetVar("NEW_AI")))
		{
			if (NPCATK_TARGET != NPC_PREV_TARGET)
			{
				NPC_PREV_TARGET = NPCATK_TARGET;
				if (IsPlayer(NPCATK_TARGET))
				{
					NPC_WAS_IN_BATTLE = true;
					CallExternal(NPCATK_TARGET, "ext_targeted_by_mob", self);
				}
			}
		}
		else if (GetVar("HUNT_LASTTARGET") != NPC_PREV_TARGET)
		{
			NPC_PREV_TARGET = GetVar("HUNT_LASTTARGET");
			if (IsPlayer(GetVar("HUNT_LASTTARGET")))
			{
				NPC_WAS_IN_BATTLE = true;
				CallExternal(GetVar("HUNT_LASTTARGET"), "ext_targeted_by_mob", self);
			}
		}

		if (!NPC_CUSTOM_COMBAT_MUSIC)
			return;
		PlayMusic(NPC_PREV_TARGET, "combat", NPC_CMUSIC_FILE);

		NPC_LASTSEEN_ENEMY_TIME = GameTime();
	}

	// npc_targetvalidate
	void BaseMonsterShared_OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		float targRange = 0.0f;
		bool exitSub = false;

		// NOV2014_11 - cycle down if not seen enemy for awhile
		if (NPC_LASTSEEN_ENEMY_TIME > 0.0f)
		{
			float calmTime = NPC_LASTSEEN_ENEMY_TIME + NPC_MAX_UNSEEN_TIME;
			if (GameTime() > calmTime)
			{
				DebugPrint("npc_targetvalidate (shared) LongTimeNoSee " + Text(calmTime) + " max " + Text(NPC_MAX_UNSEEN_TIME) + " last " + Text(NPC_LASTSEEN_ENEMY_TIME) + " cur " + Text(GameTime()) + " to " + Text(calmTime));

				if (Truthy(GetVar("NEW_AI")))
					targRange = RangeTo(NPCATK_TARGET);
				else
					targRange = RangeTo(GetVar("HUNT_LASTTARGET"));

				if (targRange < ATTACK_HITRANGE && !Truthy(NPC_RANGED))
				{
					DebugPrint("npcatk_targetvalidate (shared) aborting calm down, near target");
					NPC_LASTSEEN_ENEMY_TIME = GameTime();
					exitSub = true;
				}
				if (!exitSub)
				{
					NPC_LASTSEEN_ENEMY_TIME = 0.0f;

					if (Truthy(GetVar("NEW_AI")))
					{
						NPC_PREV_TARGET = "unset";
					}
					else
					{
						NPC_PREV_TARGET = "\xAFNONE\xAF";
						NPC_TARGET_INVALID = true;
					}
					OnNpcatkClearTargets("LongTimeNoSee");
				}
			}
		}
	}

	// npc_selectattack
	void BaseMonsterShared_OnNpcSelectattack()
	{
		NPC_LASTSEEN_ENEMY_TIME = GameTime();
	}

	// npcatk_tele_hunter_loop
	void BaseMonsterShared_OnNpcatkTeleHunterLoop()
	{
		DebugPrint("npcatk_tele_hunter_loop " + Text(BAST_TELEPORTING));
		if (!NPC_TELEHUNT)
			return;
		if (!IsAlive(ENT_ME))
			return;
		CallEventDelayed(NPC_TELEHUNT_FREQ, "npcatk_tele_hunter_loop");

		if (BAST_TELEPORTING)
			return;

		string teleTarg = "none";

		if (NPC_TELEHUNT_RANDOM)
		{
			if (PlayerCount() > 0)
			{
				SetVar("TELEHUNT_PLR_LIST", GetPlayers());
				float nplayers = GetTokenCount("TELEHUNT_PLR_LIST") - 1.0f;
				int rndPlr = RandomInt(0, int(nplayers));
				teleTarg = GetToken("TELEHUNT_PLR_LIST", 0);
				DebugPrint("npcatk_tele_hunter_loop random " + NameOf(teleTarg));
			}
		}
		else
		{
			teleTarg = NPCATK_TARGET;
		}

		if (teleTarg == "none")
			return;

		OnNpcTelehuntAttempt();
		// (always true here) if !NPC_TELEHUNT_ABORT

		BAST_TELEPORTING = true; // flagged off in as_tele_to_player_loop on success/surrender

		DebugPrint("npcatk_tele_hunter_loop as_tele_to_player_loop " + NameOf(teleTarg));
		OnAsTeleToPlayerLoop(teleTarg);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { BaseMonsterShared_OnGameSpawn(playerRace, playerGender); } // game_spawn

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc);
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
	}

	void OnNpcatkSetupSiege() { BaseMonsterShared_OnNpcatkSetupSiege(); } // npcatk_setup_siege
	void OnNpcInitialdrop() { BaseMonsterShared_OnNpcInitialdrop(); } // npc_initialdrop
	void OnNpcPostSpawn() { BaseMonsterShared_OnNpcPostSpawn(); } // npc_post_spawn

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack();
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnGameTargetedByPlayer(CBasePlayer@ player = null) { BaseMonsterShared_OnGameTargetedByPlayer(player); } // game_targeted_by_player
	void OnBmGoldSpew(int goldPerBag = 0, string bagsPerPlayer = "", int distance = 0, int minBags = 0, int maxBags = 0) { BaseMonsterShared_OnBmGoldSpew(goldPerBag, bagsPerPlayer, distance, minBags, maxBags); } // bm_gold_spew
	void OnNpcatkGetPostspawnProperties() { BaseMonsterShared_OnNpcatkGetPostspawnProperties(); } // npcatk_get_postspawn_properties
	void OnAdjStepSize() { BaseMonsterShared_OnAdjStepSize(); } // adj_step_size
	void OnNpcatkSuspendAttack(float time = 0.0f) { BaseMonsterShared_OnNpcatkSuspendAttack(time); } // npcatk_suspend_attack
	void OnNpcatkResumeAttack() { BaseMonsterShared_OnNpcatkResumeAttack(); } // npcatk_resume_attack
	void OnNpcatkFlank(string target = "") { BaseMonsterShared_OnNpcatkFlank(target); } // npcatk_flank
	void OnFlankThrashMoveDest() { BaseMonsterShared_OnFlankThrashMoveDest(); } // flank_thrash_move_dest

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseMonsterShared_OnNpcatkResumeAi(target);
		BaseMonsterShared_OnNpcatkResumeAi_2(target);
	}

	void OnGameReachedDest() { BaseMonsterShared_OnGameReachedDest(); } // game_reached_dest
	void OnNpcatkRangeAdj() { BaseMonsterShared_OnNpcatkRangeAdj(); } // npcatk_range_adj
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f) { BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); } // game_parry
	void OnNpcatkFindDistant(string maxRange = "") { BaseMonsterShared_OnNpcatkFindDistant(maxRange); } // npcatk_find_distant
	void OnNpcatkFdLoop() { BaseMonsterShared_OnNpcatkFdLoop(); } // npcatk_fd_loop
	void OnNpcatkProxactScan() { BaseMonsterShared_OnNpcatkProxactScan(); } // npcatk_proxact_scan
	void OnNpcatkProxActivated(CBaseEntity@ player = null, string reason = "") { BaseMonsterShared_OnNpcatkProxActivated(player, reason); } // npcatk_prox_activated
	void OnNpcatkProxactLplayers() { BaseMonsterShared_OnNpcatkProxactLplayers(); } // npcatk_proxact_lplayers
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnExtSuperLure(CBaseEntity@ lureTarget = null, string race = "", string moveMode = "") { BaseMonsterShared_OnExtSuperLure(lureTarget, race, moveMode); } // ext_super_lure
	void OnNpcatkRun() { BaseMonsterShared_OnNpcatkRun(); } // npcatk_run
	void OnNpcatkWalk() { BaseMonsterShared_OnNpcatkWalk(); } // npcatk_walk
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnNpcatkResumeCiviHunt() { BaseMonsterShared_OnNpcatkResumeCiviHunt(); } // npcatk_resume_civi_hunt
	void OnNpcatkNpcHunterLoop() { BaseMonsterShared_OnNpcatkNpcHunterLoop(); } // npcatk_npc_hunter_loop
	void OnStartRunning() { BaseMonsterShared_OnStartRunning(); } // start_running
	void OnMakeFadeIn() { BaseMonsterShared_OnMakeFadeIn(); } // make_fade_in
	void OnMakeFadeInLoop() { BaseMonsterShared_OnMakeFadeInLoop(); } // make_fade_in_loop
	void OnGameKilledPlayer(CBasePlayer@ player = null) { BaseMonsterShared_OnGameKilledPlayer(player); } // game_killed_player
	void OnNpcatkBossRegen() { BaseMonsterShared_OnNpcatkBossRegen(); } // npcatk_boss_regen
	void OnNpcatkSettarget(string target = "", string debug = "") { BaseMonsterShared_OnNpcatkSettarget(target, debug); } // npcatk_settarget
	void OnNpcatkAlertAllAllies(string attacker = "") { BaseMonsterShared_OnNpcatkAlertAllAllies(attacker); } // npcatk_alert_all_allies
	void OnNpcatkAlertInRange() { BaseMonsterShared_OnNpcatkAlertInRange(); } // npcatk_alert_in_range
	void OnNpcatkAllyAlert(string attacker = "", CBaseEntity@ allyToAid = null) { BaseMonsterShared_OnNpcatkAllyAlert(attacker, allyToAid); } // npcatk_ally_alert

	// cycle_down
	void OnCycleDown()
	{
		BaseMonsterShared_OnCycleDown();
		BaseMonsterShared_OnCycleDown_2();
	}

	void OnNpcatkDodamage(string target = "", string hitRange = "", string damage = "", string hitChance = "", string damageSource = "", string reflective = "", string value = "") { BaseMonsterShared_OnNpcatkDodamage(target, hitRange, damage, hitChance, damageSource, reflective, value); } // npcatk_dodamage
	void OnNpcatkGoHome() { BaseMonsterShared_OnNpcatkGoHome(); } // npcatk_go_home
	void OnNpcatkSuspendMovement(string idleAnim = "", string duration = "") { BaseMonsterShared_OnNpcatkSuspendMovement(idleAnim, duration); } // npcatk_suspend_movement
	void OnNpcatkResumeMovement() { BaseMonsterShared_OnNpcatkResumeMovement(); } // npcatk_resume_movement

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseMonsterShared_OnNpcatkClearTargets(reason);
		BaseMonsterShared_OnNpcatkClearTargets_2(reason);
	}

	void OnNpcatkGoHomeLoop() { BaseMonsterShared_OnNpcatkGoHomeLoop(); } // npcatk_go_home_loop
	void OnNpcatkReturnHomePosReset() { BaseMonsterShared_OnNpcatkReturnHomePosReset(); } // npcatk_return_home_pos_reset
	void OnNpcatkSuspendRoam(float delay = 0.0f) { BaseMonsterShared_OnNpcatkSuspendRoam(delay); } // npcatk_suspend_roam
	void OnNpcatkResumeRoam() { BaseMonsterShared_OnNpcatkResumeRoam(); } // npcatk_resume_roam
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") { BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); } // npcatk_suspend_ai
	void OnNpcatkFxSpriteIn1() { BaseMonsterShared_OnNpcatkFxSpriteIn1(); } // npcatk_fx_sprite_in1
	void OnNpcatkFxSpriteIn2() { BaseMonsterShared_OnNpcatkFxSpriteIn2(); } // npcatk_fx_sprite_in2
	void OnNpcatkHandlePostevents() { BaseMonsterShared_OnNpcatkHandlePostevents(); } // npcatk_handle_postevents
	void OnNpcatkClearMusic() { BaseMonsterShared_OnNpcatkClearMusic(); } // npcatk_clear_music
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnNpcTargetsighted(string target = "") { BaseMonsterShared_OnNpcTargetsighted(target); } // npc_targetsighted
	void OnNpcTargetvalidate(CBaseEntity@ target = null) { BaseMonsterShared_OnNpcTargetvalidate(target); } // npc_targetvalidate
	void OnNpcatkTeleHunterLoop() { BaseMonsterShared_OnNpcatkTeleHunterLoop(); } // npcatk_tele_hunter_loop
	void OnLDiff() {} // L_DIFF
	void OnNpcBossRegenFreq() {} // NPC_BOSS_REGEN_FREQ
	void OnNpcProxactDelay() {} // NPC_PROXACT_DELAY
	void OnNpcProxactEvent() {} // NPC_PROXACT_EVENT
	void OnNpcTelehuntDelay() {} // NPC_TELEHUNT_DELAY
	void OnNpcTelehuntFreq() {} // NPC_TELEHUNT_FREQ
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "") {} // npc_aiding_ally
	void OnNpcMadeItHome() {} // npc_made_it_home
	void OnNpcSuicide(string suicideMode = "") {} // npc_suicide
	void OnNpcTelehuntAttempt() {} // npc_telehunt_attempt
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") {} // npcatk_flee
	void OnNpcatkTarget2(string target = "", string debug = "") {} // npcatk_target

	// This file's events and timers by their .script names
	bool BaseMonsterShared_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "adj_step_size") { OnAdjStepSize(); return true; }
		if (name == "bm_gold_spew") { OnBmGoldSpew(Int(Param(params, 0)), Param(params, 1), Int(Param(params, 2)), Int(Param(params, 3)), Int(Param(params, 4))); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "ext_super_lure") { OnExtSuperLure(EntityParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "flank_thrash_move_dest") { OnFlankThrashMoveDest(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_killed_player") { OnGameKilledPlayer(PlayerParam(params, 0)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "make_fade_in") { OnMakeFadeIn(); return true; }
		if (name == "make_fade_in_loop") { OnMakeFadeInLoop(); return true; }
		if (name == "npc_initialdrop") { OnNpcInitialdrop(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "npcatk_alert_all_allies") { OnNpcatkAlertAllAllies(Param(params, 0)); return true; }
		if (name == "npcatk_alert_in_range") { OnNpcatkAlertInRange(); return true; }
		if (name == "npcatk_ally_alert") { OnNpcatkAllyAlert(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "npcatk_boss_regen") { OnNpcatkBossRegen(); return true; }
		if (name == "npcatk_clear_music") { OnNpcatkClearMusic(); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_dodamage") { OnNpcatkDodamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "npcatk_fd_loop") { OnNpcatkFdLoop(); return true; }
		if (name == "npcatk_find_distant") { OnNpcatkFindDistant(Param(params, 0)); return true; }
		if (name == "npcatk_flank") { OnNpcatkFlank(Param(params, 0)); return true; }
		if (name == "npcatk_fx_sprite_in1") { OnNpcatkFxSpriteIn1(); return true; }
		if (name == "npcatk_fx_sprite_in2") { OnNpcatkFxSpriteIn2(); return true; }
		if (name == "npcatk_get_postspawn_properties") { OnNpcatkGetPostspawnProperties(); return true; }
		if (name == "npcatk_go_home") { OnNpcatkGoHome(); return true; }
		if (name == "npcatk_go_home_loop") { OnNpcatkGoHomeLoop(); return true; }
		if (name == "npcatk_handle_postevents") { OnNpcatkHandlePostevents(); return true; }
		if (name == "npcatk_npc_hunter_loop") { OnNpcatkNpcHunterLoop(); return true; }
		if (name == "npcatk_prox_activated") { OnNpcatkProxActivated(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_proxact_lplayers") { OnNpcatkProxactLplayers(); return true; }
		if (name == "npcatk_proxact_scan") { OnNpcatkProxactScan(); return true; }
		if (name == "npcatk_range_adj") { OnNpcatkRangeAdj(); return true; }
		if (name == "npcatk_resume_ai") { OnNpcatkResumeAi(Param(params, 0)); return true; }
		if (name == "npcatk_resume_attack") { OnNpcatkResumeAttack(); return true; }
		if (name == "npcatk_resume_civi_hunt") { OnNpcatkResumeCiviHunt(); return true; }
		if (name == "npcatk_resume_movement") { OnNpcatkResumeMovement(); return true; }
		if (name == "npcatk_resume_roam") { OnNpcatkResumeRoam(); return true; }
		if (name == "npcatk_return_home_pos_reset") { OnNpcatkReturnHomePosReset(); return true; }
		if (name == "npcatk_run") { OnNpcatkRun(); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_setup_siege") { OnNpcatkSetupSiege(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_suspend_attack") { OnNpcatkSuspendAttack(Float(Param(params, 0))); return true; }
		if (name == "npcatk_suspend_movement") { OnNpcatkSuspendMovement(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npcatk_suspend_roam") { OnNpcatkSuspendRoam(Float(Param(params, 0))); return true; }
		if (name == "npcatk_tele_hunter_loop") { OnNpcatkTeleHunterLoop(); return true; }
		if (name == "npcatk_walk") { OnNpcatkWalk(); return true; }
		if (name == "start_running") { OnStartRunning(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/base_monster_shared"]
shared class BaseMonsterSharedScript : BaseAntiStuckScript, BaseMonsterShared
{
	// Variables declared by included files, with the value they start with in this script
	BaseMonsterSharedScript()
	{
		NPC_BOSS_REGEN_RATE = 0.1f;
		NPC_BOSS_REGEN_FREQ = 60.0f;
		NPC_BOSS_RESTORATION = 0.5f;
		NPC_CANT_PARRY_TYPES = "target;magic";
		DEF_STEP_SIZE = 32;
		PARRY_TYPE = "parried!";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseMonsterShared_DispatchEvent(name, params)
			|| BaseAntiStuckScript::DispatchEvent(name, params);
	}
}
