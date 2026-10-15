#pragma context server

// Converted from monsters/summon/base_summon.script by msc_transpiler.
// Thothie - added speech feedback, and summon spam control
// Summoned monster
// Responds to:
// "attack" - summon_attackall
// "kill" - summon_attacktarget
// "come" - summon_come
// "vanish" - unsummons (pets only)
// Define:
// SUMMON_VICINITY - Range monster can stray before he disengages and comes back to owner

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseSummon
{
	// Constants
	int SUMMON_CIRCLE_INDEX = 3;
	int SUMMON_RUN_DIST = 256;
	string SUM_SAY_COME = "Coming sir.";
	string SUM_SAY_ATTACK = "Attacking target.";
	string SUM_SAY_HUNT = "Hunting, sir.";
	string SUM_SAY_DEFEND = "Defending you.";
	string SUM_SAY_DEATH = "Arrrrrrrrgghh!";
	string SUM_SAY_GUARD = "I shall guard this position with my life.";
	string SUM_REPORT_SUFFIX = ", sir.";
	string ANIM_WALK_BASE = "walk";
	string ANIM_RUN_BASE = "run";
	int DEFEND_RANGE = 256;
	int HOVER_FAR = 128;
	int HOVER_CLOSE = 64;
	float CYCLE_TIME_BATTLE = 0.1f;
	float CYCLE_TIME_IDLE = 0.1f;
	float CYCLE_TIME_NPC = 0.1f;
	int SUMMON_VICINITY = 400;

	// Variables (an unset .script variable reads as its own name)
	string CAN_RETALIATE = "CAN_RETALIATE";
	int HOVER_DISTANCE = 0;
	string SUMMON_MASTER = "SUMMON_MASTER";
	bool IS_HIRED = false;
	int I_R_PET = 0;
	string ACT_NAME = "ACT_NAME";
	string NAMEPREFIX = "NAMEPREFIX";
	bool STUCK_CHECKING = false;
	Vector3 AS_LAST_ORIGIN = Vector3();
	bool NPC_FORCED_MOVEDEST = false;
	string OWNER_TARGET = "OWNER_TARGET";
	bool KILL_MODE = false;
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	string NPC_ATTACK_TARGET = "NPC_ATTACK_TARGET";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string CYCLE_TIME = "CYCLE_TIME";
	bool CYCLED_UP = false;
	string ME_STREGTH = "ME_STREGTH";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	bool GUARD_MODE = false;
	bool IGNORE_TARGETS = false;
	bool DEFEND_MODE = false;
	bool FOLLOW_MASTER = false;
	Vector3 GUARD_POS = Vector3();
	float SUMMON_LAST_TARG_NOTICE = 0.0f;
	string SUMMON_LAST_TARG = "SUMMON_LAST_TARG";

	// unnamed block (first think)
	void BaseSummon_FirstThink()
	{
		CAN_RETALIATE = "0"; // don't retliate, instead concentrate on your master's target
	}

	// npc_spawn
	void BaseSummon_OnNpcSpawn(string npc = "")
	{
		SetMonsterClip(false);
		if (Contains(ToLowerCase(MapName()), "sfor"))
			SetMonsterClip(true);

		CatchSpeech("basesummon_say_come", "come", "follow", "return", "disengage");
		CatchSpeech("basesummon_say_defend", "defend");
		CatchSpeech("basesummon_say_attacktarget", "kill", "attack him", "attack her", "attack it", "sick", "sic");
		CatchSpeech("basesummon_say_attackall", "attack", "hunt", "fight", "kill them all", "kill everything", "go away", "move");
		CatchSpeech("basesummon_say_report", "status", "report", "health", "hp", "strength", "power");
		CatchSpeech("basesummon_say_dismiss", "dismiss", "unsummon", "vanish");
		CatchSpeech("basesummon_say_guard", "guard", "stay", "stop");

		SetMenuAutoOpen(true);

		OnSummonCycle();

		OnSummonSpawn();
	}

	// npc_post_spawn
	void BaseSummon_OnNpcPostSpawn()
	{
		HOVER_DISTANCE = HOVER_FAR; // how close to stay to master when idle
	}

	// game_dynamically_created
	void BaseSummon_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SUMMON_MASTER = creatorValue1;

		// callevent 0.1 bs_scan
		if (Truthy(GetVar("SUMMON_UNIQUE")))
			CallExternal(SUMMON_MASTER, "ext_summon_unique", GetVar("SUMMON_UNIQUE_TAG"));

		// if ( $get_insphere(SUMMON_MASTER,game.monster.moveprox) ) callevent bs_unsolid
		if (IsPlayer(SUMMON_MASTER))
		{
			IS_HIRED = true;
			I_R_PET = 1;
		}

		CallEventDelayed(1.0f, "bs_set_defend_mode");
		OnPreNameSet();

		if (!Truthy(GetVar("IS_COMPANION")))
		{
			ACT_NAME = NameOf(ENT_ME);
			NAMEPREFIX = NameOf(SUMMON_MASTER) + "'s" + " " + NameOf(ENT_ME);
			SetName(NAMEPREFIX);
		}
		else
		{
			OnExtCompanionUpdateName();
		}

		CallEventDelayed(0.1f, "summon_circle");
		CallEventDelayed(0.5f, "basesummon_delayedspawneffect");

		OnSummonSummoned(creatorValue1, Float(creatorValue2), damage);

		STUCK_CHECKING = true;
		AS_LAST_ORIGIN = MyOrigin();
	}

	// summon_circle
	void BaseSummon_OnSummonCircle()
	{
		Vector3 circlePos = OriginOf(ENT_ME);
		circlePos.z = GroundHeight(circlePos);
		ClientEvent("new", "all", "effects/sfx_summon_circle", circlePos, SUMMON_CIRCLE_INDEX);
	}

	// summon_summoned
	void BaseSummon_OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		if (I_R_PET == 0)
			return;

		DebugPrint("summon_summoned help_summons");

		string text = "You've Summoned your first monster";
		text += "|You can control all your summons globally with the following say commands:|all hunt|all follow|all vanish";
		HelpTip(SUMMON_MASTER, "help_summons", "Monster Summons", text);
	}

	// basesummon_say_come
	void BaseSummon_OnBasesummonSayCome(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		SetSayTextRange(1024);
		if (!Truthy(GetVar("SUM_NO_TALK")))
			SayText(SUM_SAY_COME);

		if (IsAlive(NPCATK_TARGET))
			PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " disengaging battle");
		else
			PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " following and non-agro");
		OnSummonAcknowledge("follow");

		OnNpcatkClearTargets();
		OnNocatkSuspendAi();
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(SUMMON_MASTER, HOVER_CLOSE);
		OnBsSetFollowMode();

		OnSummonCome();
	}

	// basesummon_say_attacktarget
	void BaseSummon_OnBasesummonSayAttacktarget(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		OWNER_TARGET = EntityId(TargetOf(SUMMON_MASTER));
		if (!Exists(OWNER_TARGET))
			return;

		OnBsSetHuntMode();
		KILL_MODE = true;
		OnNpcatkClearTargets();

		if (OWNER_TARGET != ENT_ME && RelationshipOf(ENT_ME, OWNER_TARGET) != "ally")
			OnNpcatkSettarget(OWNER_TARGET);

		SetSayTextRange(1024);
		if (!Truthy(GetVar("SUM_NO_TALK")))
			SayText(SUM_SAY_ATTACK);

		PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " attacking target");

		OnSummonAcknowledge("attack");

		NPC_MOVE_TARGET = OWNER_TARGET;
		NPC_ATTACK_TARGET = OWNER_TARGET;
		SetMoveDest(NPC_MOVE_TARGET, 9999);
	}

	// basesummon_say_attackall
	void BaseSummon_OnBasesummonSayAttackall(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		SetSayTextRange(1024);
		if (!Truthy(GetVar("SUM_NO_TALK")))
			SayText(SUM_SAY_HUNT);
		PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " seeking enemies");

		OnSummonAcknowledge("hunt");

		PlayAnim("once", ANIM_WALK);
		OnBsSetHuntMode();

		if (CanSee("enemy"))
			return;
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(SUMMON_MASTER, 2048, "flee");
	}

	// basesummon_say_defend
	void BaseSummon_OnBasesummonSayDefend(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		SetSayTextRange(1024);
		if (!Truthy(GetVar("SUM_NO_TALK")))
			SayText(SUM_SAY_DEFEND);
		PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " set defensive mode");

		OnSummonAcknowledge("defend");

		OnBsSetDefendMode();
	}

	// basesummon_say_guard
	void BaseSummon_OnBasesummonSayGuard(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		SetSayTextRange(1024);
		if (!Truthy(GetVar("SUM_NO_TALK")))
			SayText(SUM_SAY_GUARD);
		PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + " holding location");

		OnSummonAcknowledge("stay");

		OnBsSetGuardMode();
	}

	// summon_cycle
	// main cycle ================================================================================
	void BaseSummon_OnSummonCycle()
	{
		CallEventDelayed(2.0f, "summon_cycle");

		if (!IS_HIRED)
			return;

		// //dbg temp $get(NPCATK_TARGET,name) grd GUARD_MODE flw FOLLOW_MASTER dfns DEFEND_MODE ignor IGNORE_TARGETS
		// //dbg temp game.monster.anim
		if (!Truthy(NO_STUCK_CHECKS))
		{
			float minRange = Float(Eval("game.monster.moveprox"));
			minRange += 32.0f;
			if (RangeTo(SUMMON_MASTER) > minRange)
				NO_STUCK_CHECKS = "1";
		}

		if (GUARD_MODE && Distance(MyOrigin(), GUARD_POS) > HOVER_CLOSE)
		{
			SetMoveAnim(ANIM_WALK);
			NPC_FORCED_MOVEDEST = true;
			SetMoveDest(GUARD_POS, HOVER_CLOSE);
		}

		if (FOLLOW_MASTER)
		{
			if (RangeTo(SUMMON_MASTER) <= SUMMON_RUN_DIST && NPCATK_TARGET == "unset")
				SetMoveAnim(ANIM_WALK);
			if (RangeTo(SUMMON_MASTER) > SUMMON_RUN_DIST)
				SetMoveAnim(ANIM_RUN);
			NPC_FORCED_MOVEDEST = true;
			if (NPCATK_TARGET == "unset")
				SetMoveDest(SUMMON_MASTER, HOVER_DISTANCE);
		}
	}

	// npcatk_targetvalidate
	void BaseSummon_OnNpcatkTargetvalidate(string target = "")
	{
		// dont attack master
		if (NPCATK_TARGET == SUMMON_MASTER)
			NPCATK_TARGET = "unset";

		if (RaceOf(NPCATK_TARGET) == "hguard" && !KILL_MODE)
			NPCATK_TARGET = "unset";

		// summons always at full cycle, since attack mostly NPCs
		CYCLE_TIME = Text(CYCLE_TIME_BATTLE);
		CYCLED_UP = true;

		// in defense mode, only attack creatures in a certain range
		// this is messy
		if (DEFEND_MODE && RangeTo(target) > DEFEND_RANGE)
			NPCATK_TARGET = "unset";

		// ignore targets in follow mode
		if (IGNORE_TARGETS)
			NPCATK_TARGET = "unset";
	}

	// npc_death
	void BaseSummon_OnNpcDeath()
	{
		if (Truthy(GetVar("SUMMON_UNIQUE")))
			CallExternal(SUMMON_MASTER, "ext_unsummon_unique", GetVar("SUMMON_UNIQUE_TAG"));

		if (I_R_PET == 1)
			LegacyCommand("subtract", "CURRENT_SUMMONS", 1);
		// dbg CurSums CURRENT_SUMMONS max MAX_SUMMONS
		SetSayTextRange(1024);
		if (RandomInt(1, 2) == 1 && !Truthy(GetVar("SUM_NO_TALK")) && SUM_SAY_DEATH != "none")
			SayText(SUM_SAY_DEATH);
		PlayerMessage(SUMMON_MASTER, "Your " + ACT_NAME + " has been slain!");
		OnSummonDeath();
		DeleteEntity(ENT_ME, "fade");
	}

	// basesummon_say_report
	void BaseSummon_OnBasesummonSayReport(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;
		string atkMin = "ATK_MIN";

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		float meHealth = MyHealth();
		float meMaxHealth = MyMaxHealth();
		int healthString = int(meHealth);
		string healthStringText = Text(healthString) + "/" + Text(meMaxHealth);
		healthString = Int(healthStringText);

		if (!Truthy(GetVar("SUM_NO_TALK")))
		{
			if (atkMin == "ATK_MIN")
				atkMin = GetVar("DMG_MAX");

			string meStrength = atkMin;
			ME_STREGTH += "/strike";

			SetSayTextRange(1024);
			SayText("My health is " + healthStringText + " and my attack strength is " + meStrength + " " + SUM_REPORT_SUFFIX);
		}
		OnSummonAcknowledge("report");
		PlayerMessageGreen(SUMMON_MASTER, ACT_NAME + ":" + " Health " + healthString + " Attack " + int(Float(GetVar("SUMMON_DMG_BASE"))));
	}

	// basesummon_say_dismiss
	void BaseSummon_OnBasesummonSayDismiss(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;

		if (Truthy(GetVar("I_R_COMPANION")))
			return;
		if (I_R_PET == 0)
			return;

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		OnKillme();
	}

	// killme
	void BaseSummon_OnKillme()
	{
		if (I_R_PET == 1)
			LegacyCommand("subtract", "CURRENT_SUMMONS", 1);
		// dbg CurSums CURRENT_SUMMONS max MAX_SUMMONS
		// removescript
		OnSummonUnsummon(); // let top script handle particulars
		if (Truthy(GetVar("SUMMON_UNIQUE")))
			CallExternal(SUMMON_MASTER, "ext_unsummon_unique", GetVar("SUMMON_UNIQUE_TAG"));

		SetAlive(false);
		DeleteEntity(ENT_ME, "fade");
		RemoveScript();
		ClientEvent("remove", "all", IndexOf(ENT_ME));
	}

	// bs_set_follow_mode
	void BaseSummon_OnBsSetFollowMode()
	{
		DebugPrint("bs_set_follow_mode");

		// follow master
		if (!Truthy(GetVar("I_R_COMPANION")))
			SetRoam(true);
		KILL_MODE = false;
		NO_STUCK_CHECKS = "0";
		ANIM_WALK = ANIM_WALK_BASE;
		ANIM_RUN = ANIM_RUN_BASE;
		SetMoveAnim(ANIM_RUN);
		GUARD_MODE = false;
		IGNORE_TARGETS = true;
		DEFEND_MODE = false;
		FOLLOW_MASTER = true;
		HOVER_DISTANCE = HOVER_CLOSE;
	}

	// bs_set_hunt_mode
	void BaseSummon_OnBsSetHuntMode()
	{
		DebugPrint("bs_set_hunt_mode");

		// seek prey
		if (!Truthy(GetVar("I_R_COMPANION")))
			SetRoam(true);
		KILL_MODE = false;
		NO_STUCK_CHECKS = "0";
		ANIM_WALK = ANIM_WALK_BASE;
		ANIM_RUN = ANIM_RUN_BASE;
		SetMoveAnim(ANIM_RUN);
		GUARD_MODE = false;
		IGNORE_TARGETS = false;
		DEFEND_MODE = false;
		FOLLOW_MASTER = false;
	}

	// bs_set_defend_mode
	void BaseSummon_OnBsSetDefendMode()
	{
		DebugPrint("bs_set_defend_mode");

		// stay near master
		SetRoam(false);
		NO_STUCK_CHECKS = "0";
		KILL_MODE = false;
		ANIM_WALK = ANIM_WALK_BASE;
		ANIM_RUN = ANIM_RUN_BASE;
		SetMoveAnim(ANIM_RUN);
		GUARD_MODE = false;
		IGNORE_TARGETS = false;
		DEFEND_MODE = true;
		FOLLOW_MASTER = true;
		HOVER_DISTANCE = HOVER_FAR;
	}

	// bs_set_guard_mode
	void BaseSummon_OnBsSetGuardMode()
	{
		DebugPrint("bs_set_guard_mode");

		// stay still
		SetRoam(false);
		KILL_MODE = false;
		NO_STUCK_CHECKS = "1";
		SetMoveAnim(ANIM_IDLE);
		ANIM_WALK = ANIM_IDLE;
		ANIM_RUN = ANIM_IDLE;
		GUARD_POS = MyOrigin();
		GUARD_MODE = true;
		IGNORE_TARGETS = false;
		DEFEND_MODE = false;
		FOLLOW_MASTER = false;
		HOVER_DISTANCE = HOVER_FAR;
	}

	// game_menu_getoptions
	void BaseSummon_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (EntityId(player) != SUMMON_MASTER)
			return;

		if (!IS_HIRED)
			return;

		if (!IsAlive(ENT_ME))
			return;

		if (Truthy(GetVar("COMPANION_CONFIRM_DISMISS")))
		{
			HelpTip(player, "generic", "DISMISS PET", "Are you sure you want to abandon your pet?|Remember, you won't be able to get the pet back again.");
			PlayerMessageGreen(player, "Confirm release of pet...");

			menuItem.title = "Yes";
			menuItem.type = "callback";
			menuItem.data = "from_menu";
			menuItem.callback = "companion_release";
			RegisterMenuItem(menuItem);

			menuItem.title = "No";
			menuItem.type = "callback";
			menuItem.data = "from_menu";
			menuItem.callback = "companion_release_cancel";
			RegisterMenuItem(menuItem);
		}
		if (Truthy(GetVar("COMPANION_CONFIRM_DISMISS")))
			return;

		menuItem.title = "Report Status";
		menuItem.type = "callback";
		menuItem.data = "from_menu";
		menuItem.callback = "basesummon_say_report";
		RegisterMenuItem(menuItem);

		if (NPCATK_TARGET == "unset")
			menuItem.title = "Follow (Do Not Engage)";
		else
			menuItem.title = "Disengage";
		menuItem.type = "callback";
		menuItem.data = "from_menu";
		menuItem.callback = "basesummon_say_come";
		RegisterMenuItem(menuItem);

		menuItem.title = "Defend";
		menuItem.type = "callback";
		menuItem.data = "from_menu";
		menuItem.callback = "basesummon_say_defend";
		RegisterMenuItem(menuItem);

		menuItem.title = "Hunt";
		menuItem.type = "callback";
		menuItem.data = "from_menu";
		menuItem.callback = "basesummon_say_attackall";
		RegisterMenuItem(menuItem);

		menuItem.title = "Stay Here";
		menuItem.type = "callback";
		menuItem.data = "from_menu";
		menuItem.callback = "basesummon_say_guard";
		RegisterMenuItem(menuItem);

		if (I_R_PET == 0)
			return;
		if (!Truthy(GetVar("I_R_COMPANION")))
		{
			menuItem.title = "Unsummon";
			menuItem.type = "callback";
			menuItem.data = "from_menu";
			menuItem.callback = "basesummon_say_dismiss";
			RegisterMenuItem(menuItem);
		}
		else
		{
			menuItem.title = "Unsummon";
			menuItem.type = "callback";
			menuItem.data = "from_menu";
			menuItem.callback = "companion_unsummon";
			RegisterMenuItem(menuItem);

			menuItem.title = "Abandon Pet";
			menuItem.type = "callback";
			menuItem.data = "from_menu";
			menuItem.callback = "companion_abandon";
			RegisterMenuItem(menuItem);
		}
	}

	// bs_unsolid
	void BaseSummon_OnBsUnsolid()
	{
		SetSolid("none");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		SetAnimFrameRate(0);
		SetAnimMoveSpeed(0);
		SetMoveSpeed(0);
	}

	// bs_attempt_solid
	void BaseSummon_OnBsAttemptSolid()
	{
		float minRange = Float(Eval("game.monster.moveprox"));
		minRange += 15.0f;
		if (!(RangeTo(SUMMON_MASTER) > minRange))
			return;
		SetSolid("box");
		SetProp(ENT_ME, "rendermode", 0);
		SetAnimFrameRate(1);
		SetAnimMoveSpeed(1);
		SetMoveSpeed(1);
	}

	// npc_monster_stuck
	void BaseSummon_OnNpcMonsterStuck()
	{
		float minRange = Float(Eval("game.monster.moveprox"));
		minRange += 15.0f;
		if (!(RangeTo(SUMMON_MASTER) < minRange))
			return;
		OnBsUnsolid();
		OnNpcatkSuspendAi("2.0");
		CallEventDelayed(2.0f, "bs_attempt_solid");
	}

	// npc_found_new_target
	void BaseSummon_OnNpcFoundNewTarget(string target = "")
	{
		// dbg temp newtargetrange $get(PARAM1,range)
		string targName = FullNameOf(target);
		float lastnDiff = GameTime() - SUMMON_LAST_TARG_NOTICE;
		if (!(lastnDiff > 5.0f)) // only notify of target changes every 5 seconds
			return;
		SUMMON_LAST_TARG_NOTICE = GameTime();
		if (SUMMON_LAST_TARG == target) // and only if target actually changed
			return;
		if (I_R_PET != 0)
			PlayerMessage(SUMMON_MASTER, "Your " + ACT_NAME + " has targeted " + targName);
		SUMMON_LAST_TARG = target;
	}

	// my_target_died
	void BaseSummon_OnMyTargetDied(string offender = "")
	{
		if (KILL_MODE)
		{
			KILL_MODE = false;
			OnBsSetDefendMode();
		}
	}

	// bs_global_command
	// <caller_id> <command>
	void BaseSummon_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (EntityId(deadPlayer) != SUMMON_MASTER)
			return;

		if (command == "follow")
			OnBasesummonSayCome(deadPlayer, "from_menu");
		if (command == "defend")
			OnBasesummonSayDefend(deadPlayer, "from_menu");
		if (command == "kill")
			OnBasesummonSayAttacktarget(deadPlayer, "from_menu");
		if (command == "hunt")
			OnBasesummonSayAttackall(deadPlayer, "from_menu");
		if (command == "vanish")
			OnBasesummonSayDismiss(deadPlayer, "from_menu");
		if (command == "stay")
			OnBasesummonSayGuard(deadPlayer, "from_menu");
	}

	// npcatk_hunt
	void BaseSummon_OnNpcatkHunt()
	{
		if (Exists(SUMMON_MASTER))
			return;
		if (I_R_PET == 0)
			return;
		OnKillme();
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BaseSummon_OnNpcPostSpawn();
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		BaseSummon_OnBsGlobalCommand(deadPlayer, command, reason);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseSummon_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BaseSummon_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseSummon_OnNpcatkHunt();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		BaseSummon_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		BaseSummon_OnMyTargetDied(offender);
	}

	void OnSummonCircle() { BaseSummon_OnSummonCircle(); } // summon_circle
	void OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "") { BaseSummon_OnSummonSummoned(value, lifetime, minAttack); } // summon_summoned
	void OnBasesummonSayCome(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayCome(value, source); } // basesummon_say_come
	void OnBasesummonSayAttacktarget(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayAttacktarget(value, source); } // basesummon_say_attacktarget
	void OnBasesummonSayAttackall(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayAttackall(value, source); } // basesummon_say_attackall
	void OnBasesummonSayDefend(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayDefend(value, source); } // basesummon_say_defend
	void OnBasesummonSayGuard(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayGuard(value, source); } // basesummon_say_guard
	void OnSummonCycle() { BaseSummon_OnSummonCycle(); } // summon_cycle
	void OnNpcDeath() { BaseSummon_OnNpcDeath(); } // npc_death
	void OnBasesummonSayReport(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayReport(value, source); } // basesummon_say_report
	void OnBasesummonSayDismiss(CBasePlayer@ value = null, string source = "") { BaseSummon_OnBasesummonSayDismiss(value, source); } // basesummon_say_dismiss
	void OnKillme() { BaseSummon_OnKillme(); } // killme
	void OnBsSetFollowMode() { BaseSummon_OnBsSetFollowMode(); } // bs_set_follow_mode
	void OnBsSetHuntMode() { BaseSummon_OnBsSetHuntMode(); } // bs_set_hunt_mode
	void OnBsSetDefendMode() { BaseSummon_OnBsSetDefendMode(); } // bs_set_defend_mode
	void OnBsSetGuardMode() { BaseSummon_OnBsSetGuardMode(); } // bs_set_guard_mode
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { BaseSummon_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnBsUnsolid() { BaseSummon_OnBsUnsolid(); } // bs_unsolid
	void OnBsAttemptSolid() { BaseSummon_OnBsAttemptSolid(); } // bs_attempt_solid
	void OnNpcMonsterStuck() { BaseSummon_OnNpcMonsterStuck(); } // npc_monster_stuck
	void OnNpcFoundNewTarget(string target = "") { BaseSummon_OnNpcFoundNewTarget(target); } // npc_found_new_target
	void OnExtCompanionUpdateName() {} // ext_companion_update_name
	void OnNocatkSuspendAi() {} // nocatk_suspend_ai
	void OnPreNameSet() {} // pre_name_set
	void OnSummonAcknowledge(string command = "") {} // summon_acknowledge
	void OnSummonCome() {} // summon_come
	void OnSummonDeath() {} // summon_death
	void OnSummonSpawn() {} // summon_spawn
	void OnSummonUnsummon() {} // summon_unsummon

	// This file's events and timers by their .script names
	bool BaseSummon_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basesummon_say_attackall") { OnBasesummonSayAttackall(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_attacktarget") { OnBasesummonSayAttacktarget(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_come") { OnBasesummonSayCome(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_defend") { OnBasesummonSayDefend(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_dismiss") { OnBasesummonSayDismiss(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_guard") { OnBasesummonSayGuard(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "basesummon_say_report") { OnBasesummonSayReport(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "bs_attempt_solid") { OnBsAttemptSolid(); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "bs_set_defend_mode") { OnBsSetDefendMode(); return true; }
		if (name == "bs_set_follow_mode") { OnBsSetFollowMode(); return true; }
		if (name == "bs_set_guard_mode") { OnBsSetGuardMode(); return true; }
		if (name == "bs_set_hunt_mode") { OnBsSetHuntMode(); return true; }
		if (name == "bs_unsolid") { OnBsUnsolid(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "killme") { OnKillme(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_found_new_target") { OnNpcFoundNewTarget(Param(params, 0)); return true; }
		if (name == "npc_monster_stuck") { OnNpcMonsterStuck(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "summon_circle") { OnSummonCircle(); return true; }
		if (name == "summon_cycle") { OnSummonCycle(); return true; }
		if (name == "summon_summoned") { OnSummonSummoned(Param(params, 0), Float(Param(params, 1)), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/base_summon"]
shared class BaseSummonScript : BaseMonsterNewScript, BaseSummon
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";

	// Variables declared by included files, with the value they start with in this script
	BaseSummonScript()
	{
		CYCLE_TIME_IDLE = 0.1f;
		CYCLE_TIME_NPC = 0.1f;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseSummon_FirstThink();
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
		return BaseSummon_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
