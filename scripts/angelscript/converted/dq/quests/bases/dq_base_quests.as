#pragma context server

// Converted from dq/quests/bases/dq_base_quests.script by msc_transpiler.
// By greatguys1
// Best viewed in EditPlus with the ms.stx applied
// This keeps track of quest progress through QUEST_MODE, and notifies quest participants of quest completion.
// Functions:
// init_basic_npc_vars		Vars that only need to be activated once.
// init_post_spawn_vars		Vars that may need to be reapplied after the quest finishes.
// activate_vars			Vars that are only activated once the quest starts.
// disable_vars			Vars that must be disabled after the quest is finished.
// quest_taker_updated		is an event called when the quest_taker is moved to someone else. This can happen from the quest taker leaving the server and someone else talking to the npc.
// quest_taker_maxhp_updated	Called when the maxhp of the quest taker is updated. It's called directly from quest_taker_updated.
// Dynamic Quest Vars:
// QUEST_REWARD_TYPE	<"map">|<"script">|<"gm"> Map event, script event, or game master event. If it's a game master event, make it to the map it's on only via the casual include on game_master if you've got a custom reward
// QUEST_REWARD_EVENT	The function used to dish out the reward. If the quest giver is dynamically created, it will assume the reward is script based.
// QUEST_REWARD_ALL	Do we reward all of the people that were present at the start of the quest?
// QUEST_TAKER		The id of who got the quest. If he leaves the game after taking it, it'll be assigned to whoever else talks to the guy first.
// QUEST_TAKER_MAXHP	The maxhp of the quest_taker
// SET_SIEGE_MODE 0|1 (dwarf will become a CRITICAL_NPC target for all mobs on map when quest activated - default for defend_me.)
// QUEST_FADE_ON_COMPLETE <0>|<fade>|<walk_fade> //on quest complete, fade away in spot, or attempt to walk away, and fade as I do?
// Vars that affect the npc directly:
// const QUEST_GIVER_NAME <string> - change name from default "Dwarven Miner"
// const NEW_RACE <race> - set beloved if you don't want attacked, defaults to human
// const AM_INVINCIBLE <0|1> - invulerable (might not be targeted as a result)
// const NEW_WIDTH <change width>
// const NEW_HEIGHT <change height>
// const MONSTER_MODEL <new model> (must be precached - must have matching animations or the anims must be redefined in top script)	Pending removal
// const SUBMODEL_GROUPS "<group>;<subgroup>" (can define multiple pairs by repeating)
// const USE_SKIN <#> (New skin to use on the model)
// Vars for monsters/base_monster_new:
// const QUEST_COMBATANT 0|1	//do I engage in combat, cower/flee?
// const QUEST_ACTIVE_COMBATANT 0|1 //if combatant, fight before quest activation (may die before players meet him)
// const COMBAT_STRIKE_EVENT <eventname> (for use with new model with different anims - this is the eventname tied to the attack frame)
// Vars for monsters/base_battle_ally:
// const QUEST_FOLLOWER 1|0	//do I follow my activator or stay here? (required for escort)
// const IS_LEADER 0|1 - instead of following player, will try to roam ahead to where he is facing (requires QUEST_FOLLOW 1)
// Vars for the quest_dwarf script only:
// const USE_LANTERN <0|1> - has lantern
// const LANTERN_COLOR <(R,G,B)> defaults to: (128,64,0)
// setvard INIT_IDLE_MODE <sitting|wounded|standing> - defaults to <wounded> for non-combatants, and <sitting> for combatants based on QUEST_COMBATANT setting
// const QUEST_EXPERT_COMBATANT 0|1 //if combatant, unlocks special stun attack

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DqBaseQuests
{
	// Constants
	string QUEST_WAITING = "waiting";
	string QUEST_ASKING = "asking";
	string QUEST_ACTIVE = "active";
	string QUEST_COMPLETE = "complete";
	string QUEST_FAILED = "failed";

	// Variables (an unset .script variable reads as its own name)
	bool USING_BASE_QUEST = false;
	string QUEST_MODE = "QUEST_MODE";
	bool ALLY_FOLLOW_ON = false;
	int QUEST_CURRENTLY_COMBATING = 0;
	CBasePlayer@ OFFER_MENU_ID = null;
	CBasePlayer@ QUEST_TAKER = null;
	float QUEST_TAKER_MAXHP = 0.0f;
	string ALLY_FOLLOW_PLR_ID = "ALLY_FOLLOW_PLR_ID";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string PLAYING_DEAD = "PLAYING_DEAD";

	// unnamed block (first think)
	void DqBaseQuests_FirstThink()
	{
		USING_BASE_QUEST = true;

		QUEST_MODE = QUEST_WAITING;

		ALLY_FOLLOW_ON = false;
		QUEST_CURRENTLY_COMBATING = 0;
	}

	// game_spawn
	void DqBaseQuests_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		CallEventDelayed(1.1f, "init_basic_npc_vars");
	}

	// quest_intro_check
	// PARAM1 = PlayerID //To prevent exploits by another player keeping a menu open.
	void DqBaseQuests_OnQuestIntroCheck(CBasePlayer@ playerId = null)
	{
		if (QUEST_MODE == QUEST_WAITING)
		{
			OnQuestIntro();
			@OFFER_MENU_ID = playerId;
			CallEventDelayed(0.1f, "offer_menu");
		}
	}

	// quest_intro
	void DqBaseQuests_OnQuestIntro()
	{
		QUEST_MODE = QUEST_ASKING;
	}

	// quest_activate_check
	// PARAM1 = PlayerID
	void DqBaseQuests_OnQuestActivateCheck(CBasePlayer@ playerId = null)
	{
		if (QUEST_MODE == QUEST_ASKING)
			OnQuestActivate(playerId);
	}

	// quest_activate
	void DqBaseQuests_OnQuestActivate(CBasePlayer@ menuOwner = null)
	{
		@QUEST_TAKER = menuOwner;
		OnQuestTakerUpdated();

		OnActivateVars();

		QUEST_MODE = QUEST_ACTIVE;
	}

	// quest_finished_check
	void DqBaseQuests_OnQuestFinishedCheck()
	{
		if (QUEST_MODE == QUEST_ACTIVE)
			OnQuestFinished();
	}

	// quest_finished
	void DqBaseQuests_OnQuestFinished()
	{
		OnInitPostSpawnVars();
		OnDisableVars();

		QUEST_MODE = QUEST_COMPLETE;
		OnInformQuestFinished();
	}

	// inform_quest_finished
	void DqBaseQuests_OnInformQuestFinished()
	{
		string string_ = "Please return to " + FullNameOf(ENT_ME);
		InfoMessage("all", "Quest Complete", string_);
	}

	// game_death
	void DqBaseQuests_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		QUEST_MODE = QUEST_FAILED;
	}

	// game_menu_getoptions
	// PARAM1 = PlayerID of who opened the menu
	void DqBaseQuests_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		if (QUEST_MODE != QUEST_WAITING && QUEST_MODE != QUEST_ASKING && !Exists(QUEST_TAKER))
		{
			@QUEST_TAKER = player;
			OnQuestTakerUpdated();
		}
	}

	// quest_taker_updated
	// Is called when the quest_taker var is changed
	void DqBaseQuests_OnQuestTakerUpdated()
	{
		QUEST_TAKER_MAXHP = MaxHealthOf(QUEST_TAKER);
		OnQuestTakerMaxhpUpdated();

		if (QUEST_MODE != QUEST_COMPLETE && QUEST_FOLLOWER != 0)
			ALLY_FOLLOW_PLR_ID = EntityId(QUEST_TAKER);
	}

	// init_basic_npc_vars
	// { quest_taker_maxhp_updated	//Right now just a placeholder.
	// }
	void DqBaseQuests_OnInitBasicNpcVars()
	{
		// Stuffs done after initializing the npc so these can be applied properly. Also things that never need to be applied more than once. I don't like this 'cuz its on a timer. :(
		// Also everything needs to be filled out. All templates need to have something for all the vars!
		// QUEST_GIVER_NAME
		SetName(QUEST_GIVER_NAME);

		// NEW_WIDTH
		SetWidth(NEW_WIDTH);

		// NEW_HEIGHT
		SetHeight(NEW_HEIGHT);

		SetSolid("box");
		SetBoundingBox("npcsize");

		// MONSTER_MODEL
		if (MONSTER_MODEL != "0")
			SetModel(MONSTER_MODEL);

		// SUBMODEL_GROUPS
		// Thothie edit: making this so you can switch up more submodel groups
		// - very few, if any, mobs use more than 4
		SetModelBody(0, Int(GetToken(SUBMODEL_GROUPS, 0)));
		if (GetTokenCount(SUBMODEL_GROUPS) >= 2)
			SetModelBody(1, Int(GetToken(SUBMODEL_GROUPS, 1)));
		if (GetTokenCount(SUBMODEL_GROUPS) >= 3)
			SetModelBody(2, Int(GetToken(SUBMODEL_GROUPS, 2)));
		if (GetTokenCount(SUBMODEL_GROUPS) >= 4)
			SetModelBody(3, Int(GetToken(SUBMODEL_GROUPS, 3)));

		// USE_SKIN
		SetProp(ENT_ME, "skin", USE_SKIN);

		OnInitPostSpawnVars();
	}

	// init_post_spawn_vars
	// Mostly things that need to be reapplied after the quest is finished
	void DqBaseQuests_OnInitPostSpawnVars()
	{
		// NEW_RACE
		SetRace(NEW_RACE);

		// AM_INVINCIBLE
		SetInvincible(AM_INVINCIBLE);
		if (AM_INVINCIBLE)
			OnDoTargetMe(0);

		// QUEST_ACTIVE_COMBATANT
		QUEST_CURRENTLY_COMBATING = QUEST_ACTIVE_COMBATANT;
		if (QUEST_CURRENTLY_COMBATING != 0)
			OnDoRoam(1);
		else
			OnDoRoam(0);
	}

	// activate_vars
	// Called when quest_activate is called
	void DqBaseQuests_OnActivateVars()
	{
		if (SET_SIEGE_MODE == 1)
		{
			OnCriticalNpc(); // Event already sets invincibility 0
			OnDoTargetMe(1);
		}

		if (QUEST_COMBATANT == 1)
		{
			QUEST_CURRENTLY_COMBATING = 1;
			OnDoRoam(1);
			OnDoTargetMe(1);
		}

		if (QUEST_FOLLOWER == 1)
		{
			OnSetFollower();
			OnDoRoam(1);
		}

		if (IS_LEADER == 1)
		{
			OnSetLeader(1);
			OnDoRoam(1);
		}
	}

	// disable_vars
	// Called when quest_finished is called
	void DqBaseQuests_OnDisableVars()
	{
		bool stopRoam = false;

		if (IS_LEADER == 1)
		{
			OnSetLeader(0); // Became a problem when it activated the follow just for a second
			stopRoam = true;
		}

		if (QUEST_FOLLOWER == 1)
		{
			ALLY_FOLLOW_ON = false; // From monsters/base_battle_ally
			stopRoam = true;
		}

		if (QUEST_COMBATANT == 1 && QUEST_ACTIVE_COMBATANT == 0)
		{
			QUEST_CURRENTLY_COMBATING = 0;
			stopRoam = true;
		}

		if ((stopRoam ? 1 : 0) == 1)
		{
			OnNpcatkClearTargets();
			OnDoRoam(0);
			PlayAnim("critical", ANIM_IDLE);
		}
	}

	// npc_targetvalidate
	void DqBaseQuests_OnNpcTargetvalidate(CBaseEntity@ target = null)
	{
		if (QUEST_CURRENTLY_COMBATING == 0)
		{
			NPCATK_TARGET = "unset"; // Only works with monsters/base_monster_new
		}
	}

	// delete_fade_me
	void DqBaseQuests_OnDeleteFadeMe()
	{
		if (QUEST_FADE_ON_COMPLETE == "fade")
		{
			OnDoDeleteFadeBit();
		}
		else if (QUEST_FADE_ON_COMPLETE == "walk_fade")
		{
			SetMoveDest(ENT_ME, 9999, "flee"); // Thanks Thothie!
			OnDoRoam(1);
			CallEventDelayed(5.0f, "do_delete_fade_bit");
		}
	}

	// do_delete_fade_bit
	// Thanks Thothie!
	void DqBaseQuests_OnDoDeleteFadeBit()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// do_roam
	// PARAM1 = <0|1>
	void DqBaseQuests_OnDoRoam(int flag = 0)
	{
		if (flag == 1)
		{
			SetRoam(true);
			NO_STUCK_CHECKS = "0";
		}
		else
		{
			SetRoam(false);
			NO_STUCK_CHECKS = "1";
		}
	}

	// do_target_me
	// PARAM1 = <0|1>
	void DqBaseQuests_OnDoTargetMe(int flag = 0)
	{
		if (flag == 0)
		{
			SetRace("beloved");
			PLAYING_DEAD = "1";
		}
		else
		{
			SetRace(NEW_RACE);
			PLAYING_DEAD = "0";
		}
	}

	// game_dynamically_created
	// PARAM1 = facing angle of info_target //Thanks Thothie!
	void DqBaseQuests_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SetAngle("face", Vector3(0, Vec(creatorValue1).y, 0));
	}

	// offer_menu
	// This is so I can put it on a timer.
	void DqBaseQuests_OnOfferMenu()
	{
		OpenMenu(OFFER_MENU_ID);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { DqBaseQuests_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnQuestIntroCheck(CBasePlayer@ playerId = null) { DqBaseQuests_OnQuestIntroCheck(playerId); } // quest_intro_check
	void OnQuestIntro() { DqBaseQuests_OnQuestIntro(); } // quest_intro
	void OnQuestActivateCheck(CBasePlayer@ playerId = null) { DqBaseQuests_OnQuestActivateCheck(playerId); } // quest_activate_check
	void OnQuestActivate(CBasePlayer@ menuOwner = null) { DqBaseQuests_OnQuestActivate(menuOwner); } // quest_activate
	void OnQuestFinishedCheck() { DqBaseQuests_OnQuestFinishedCheck(); } // quest_finished_check
	void OnQuestFinished() { DqBaseQuests_OnQuestFinished(); } // quest_finished
	void OnInformQuestFinished() { DqBaseQuests_OnInformQuestFinished(); } // inform_quest_finished
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { DqBaseQuests_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { DqBaseQuests_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnQuestTakerUpdated() { DqBaseQuests_OnQuestTakerUpdated(); } // quest_taker_updated
	void OnInitBasicNpcVars() { DqBaseQuests_OnInitBasicNpcVars(); } // init_basic_npc_vars
	void OnInitPostSpawnVars() { DqBaseQuests_OnInitPostSpawnVars(); } // init_post_spawn_vars
	void OnActivateVars() { DqBaseQuests_OnActivateVars(); } // activate_vars
	void OnDisableVars() { DqBaseQuests_OnDisableVars(); } // disable_vars
	void OnNpcTargetvalidate(CBaseEntity@ target = null) { DqBaseQuests_OnNpcTargetvalidate(target); } // npc_targetvalidate
	void OnDeleteFadeMe() { DqBaseQuests_OnDeleteFadeMe(); } // delete_fade_me
	void OnDoDeleteFadeBit() { DqBaseQuests_OnDoDeleteFadeBit(); } // do_delete_fade_bit
	void OnDoRoam(int flag = 0) { DqBaseQuests_OnDoRoam(flag); } // do_roam
	void OnDoTargetMe(int flag = 0) { DqBaseQuests_OnDoTargetMe(flag); } // do_target_me
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { DqBaseQuests_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnOfferMenu() { DqBaseQuests_OnOfferMenu(); } // offer_menu
	void OnCriticalNpc() {} // critical_npc
	void OnNpcatkClearTargets(string reason = "") {} // npcatk_clear_targets
	void OnQuestTakerMaxhpUpdated() {} // quest_taker_maxhp_updated
	void OnSetFollower() {} // set_follower
	void OnSetLeader(int isLeader = 0) {} // set_leader

	// This file's events and timers by their .script names
	bool DqBaseQuests_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_vars") { OnActivateVars(); return true; }
		if (name == "delete_fade_me") { OnDeleteFadeMe(); return true; }
		if (name == "disable_vars") { OnDisableVars(); return true; }
		if (name == "do_delete_fade_bit") { OnDoDeleteFadeBit(); return true; }
		if (name == "do_roam") { OnDoRoam(Int(Param(params, 0))); return true; }
		if (name == "do_target_me") { OnDoTargetMe(Int(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "inform_quest_finished") { OnInformQuestFinished(); return true; }
		if (name == "init_basic_npc_vars") { OnInitBasicNpcVars(); return true; }
		if (name == "init_post_spawn_vars") { OnInitPostSpawnVars(); return true; }
		if (name == "npc_targetvalidate") { OnNpcTargetvalidate(EntityParam(params, 0)); return true; }
		if (name == "offer_menu") { OnOfferMenu(); return true; }
		if (name == "quest_activate") { OnQuestActivate(PlayerParam(params, 0)); return true; }
		if (name == "quest_activate_check") { OnQuestActivateCheck(PlayerParam(params, 0)); return true; }
		if (name == "quest_finished") { OnQuestFinished(); return true; }
		if (name == "quest_finished_check") { OnQuestFinishedCheck(); return true; }
		if (name == "quest_intro") { OnQuestIntro(); return true; }
		if (name == "quest_intro_check") { OnQuestIntroCheck(PlayerParam(params, 0)); return true; }
		if (name == "quest_taker_updated") { OnQuestTakerUpdated(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "dq/quests/bases/dq_base_quests"]
shared class DqBaseQuestsScript : ScriptEntity, DqBaseQuests
{
	// Variables every script that includes this file declares
	float ADJ_RANGE = 0.0f;
	float ADJ_RATIO = 0.0f;
	string AI_NO_TARGET_STRING = "AI_NO_TARGET_STRING";
	float ALLY_AS_UNSTUCK_ANG = 0.0f;
	int ALLY_FOLLOW_CLOSE_DIST = 0;
	int ALLY_FOLLOW_NORM_DIST = 0;
	int ALLY_FOLLOW_PLR_DIST = 0;
	string ALLY_FPLAYER_LIST = "ALLY_FPLAYER_LIST";
	float ALLY_FWD_JUMP_STR = 0.0f;
	bool ALLY_IS_LEADER = false;
	float ALLY_JUMP_STR = 0.0f;
	int ALLY_JUMP_THRESHOLD = 0;
	string ALLY_LEADER_DEST = "ALLY_LEADER_DEST";
	int ALLY_MAX_JUMP_RANGE = 0;
	int ALLY_MIN_DISTANCE = 0;
	int ALLY_MOVE_AWAY_DIST = 0;
	float ALLY_NEXT_FAS_CHECK = 0.0f;
	float ALLY_NEXT_FOLLOW_CHECK = 0.0f;
	float ALLY_NEXT_LEADER_UPDATE = 0.0f;
	float ALLY_NEXT_REGEN = 0.0f;
	int ALLY_OLD_DIST = 0;
	float ALLY_REGEN_RATIO = 0.0f;
	bool ALLY_RESPONSE_DELAY = false;
	float ALLY_STUCK_COUNT = 0.0f;
	bool AM_FLANKING = false;
	bool AM_INVINCIBLE = false;
	bool AM_SITTING = false;
	string ANIM_ALLY_JUMP = "ANIM_ALLY_JUMP";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_IDLE = "ANIM_IDLE";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_SIT_IDLE = "ANIM_SIT_IDLE";
	string ANIM_SIT_IDLE_CONVO1 = "ANIM_SIT_IDLE_CONVO1";
	string ANIM_SIT_IDLE_CONVO2 = "ANIM_SIT_IDLE_CONVO2";
	string ANIM_SIT_IDLE_NOLANTERN = "ANIM_SIT_IDLE_NOLANTERN";
	string ANIM_SIT_IDLE_WOUNDED = "ANIM_SIT_IDLE_WOUNDED";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
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
	string ATTACK2_ACCURACY = "ATTACK2_ACCURACY";
	int ATTACK2_CHANCE = 0;
	string ATTACK2_DAMAGE = "ATTACK2_DAMAGE";
	float ATTACK2_DAMAGE_MULT = 0.0f;
	string ATTACK_ACCURACY = "ATTACK_ACCURACY";
	int ATTACK_ANIMINDEX = 0;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	float ATTACK_DAMAGE_MULT = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
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
	string BS_SOUND_STRUCK1 = "BS_SOUND_STRUCK1";
	string BS_SOUND_STRUCK2 = "BS_SOUND_STRUCK2";
	string BS_SOUND_STRUCK3 = "BS_SOUND_STRUCK3";
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_RETALIATE = "CAN_RETALIATE";
	string CHASE_RANGE = "CHASE_RANGE";
	bool CHAT_ABORT = false;
	string CHAT_ANIMS_ANAME = "CHAT_ANIMS_ANAME";
	bool CHAT_AUTO_FACE = false;
	bool CHAT_AUTO_HAIL = false;
	bool CHAT_AUTO_JOB = false;
	bool CHAT_AUTO_RUMOR = false;
	bool CHAT_BUSY = false;
	string CHAT_CONV_ANIMS = "CHAT_CONV_ANIMS";
	string CHAT_CURRENT_SPEAKER = "CHAT_CURRENT_SPEAKER";
	float CHAT_DELAY = 0.0f;
	string CHAT_DELAYS_ANAME = "CHAT_DELAYS_ANAME";
	float CHAT_END_MOVE_MOUTH = 0.0f;
	float CHAT_END_TIME = 0.0f;
	string CHAT_EVENTS_ANAME = "CHAT_EVENTS_ANAME";
	bool CHAT_FACE_ON_USE = false;
	bool CHAT_IGNORE_WHILE_BUSY = false;
	CBasePlayer@ CHAT_LAST_USED_MENU = null;
	string CHAT_LINES_ANAME = "CHAT_LINES_ANAME";
	int CHAT_MAX_LINE_LEN = 0;
	bool CHAT_MENU_ENABLE = false;
	bool CHAT_MENU_ON = false;
	bool CHAT_MOVE_MOUTH = false;
	bool CHAT_NEVER_INTERRUPT = false;
	bool CHAT_NO_CLOSE_MOUTH = false;
	string CHAT_PLAYANIM_STYLE = "CHAT_PLAYANIM_STYLE";
	bool CHAT_QUE_ACTIVE = false;
	bool CHAT_RESET_ON_NEW = false;
	string CHAT_SEQUENCE = "CHAT_SEQUENCE";
	string CHAT_SOUNDS_ANAME = "CHAT_SOUNDS_ANAME";
	float CHAT_SPOOL_OUT_ALL_COUNT = 0.0f;
	float CHAT_SPOOL_OUT_COUNT = 0.0f;
	bool CHAT_USE_BUSY_MESSAGE = false;
	bool CHAT_USE_CONV_ANIMS = false;
	bool CHICKEN_RUN = false;
	string CKN_MY_OLD_POS = "CKN_MY_OLD_POS";
	float CKN_STUCK_COUNTER = 0.0f;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CUSTOM_LANTERN_COLOR = "CUSTOM_LANTERN_COLOR";
	bool CYCLED_UP = false;
	string CYCLE_TIME = "CYCLE_TIME";
	float CYCLE_TIME_BATTLE = 0.0f;
	float CYCLE_TIME_IDLE = 0.0f;
	float CYCLE_TIME_NPC = 0.0f;
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
	string DUMP_CONVO = "DUMP_CONVO";
	string DWARF_COMVO_ANIMS = "DWARF_COMVO_ANIMS";
	string DWARF_CONVO_ANIMS = "DWARF_CONVO_ANIMS";
	bool EFFECT_DAMAGE_DELAY = false;
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string ENTITY_ENEMY = "ENTITY_ENEMY";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
	float FD_LOOP_COUNT = 0.0f;
	string FD_MAX_RANGE = "FD_MAX_RANGE";
	Vector3 FLEESTUCK_OLDPOS = Vector3();
	int FLEE_DIR = 0;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	float FLEE_STUCKCHECK_FREQ = 0.0f;
	int FLEE_STUCK_COUNT = 0;
	string FLEE_TARGET = "FLEE_TARGET";
	float FLEE_TIME = 0.0f;
	bool FLINCHED_RECENTLY = false;
	string FLINCH_ANIM = "FLINCH_ANIM";
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	float FLINCH_DMG_REQ = 0.0f;
	float FLINCH_HEALTH = 0.0f;
	bool FREEZE_WAS_SUSPEND = false;
	float FREQ_ALLYJUMP = 0.0f;
	float FREQ_LANTERNCL_REFRESH = 0.0f;
	float G_DEMON_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	float HACK_ATTACK_DELAY = 0.0f;
	float HACK_DAMAGE_DELAY = 0.0f;
	bool HACK_DELAYING_ATTACK = false;
	bool HAS_AI = false;
	bool HAS_BASE_CHAT_ARRAY_INCLUDE = false;
	bool HAS_INCLUDE_NPC = false;
	bool HAVE_TARGET = false;
	int HEALTH_MULT = 0;
	bool HEARD_PLAYER = false;
	bool HEARD_VERIFY = false;
	string HEAR_RANGE_MAX = "HEAR_RANGE_MAX";
	string HEAR_RANGE_PLAYER = "HEAR_RANGE_PLAYER";
	bool HIT_BY_MANABALL = false;
	bool HUNTING_PLAYER = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	bool IMMUNE_VAMPIRE = false;
	string INIT_IDLE_MODE = "INIT_IDLE_MODE";
	bool IN_ICECAGE = false;
	bool IS_BLOODLESS = false;
	bool IS_FLEEING = false;
	bool IS_HUNTING = false;
	int IS_LEADER = 0;
	CBaseEntity@ I_HEARD = null;
	bool I_R_FROZEN = false;
	bool LANTERN_ACTIVE = false;
	string LANTERN_CL_IDX = "LANTERN_CL_IDX";
	string LANTERN_COLOR = "LANTERN_COLOR";
	bool LANTERN_HAND_INDEX = false;
	int LANTERN_HAND_SUBMODEL = 0;
	bool LANTERN_ON = false;
	bool LANTERN_SET = false;
	float LAST_STRUCK_FOR = 0.0f;
	Vector3 L_TEST_POS_ADJ = Vector3();
	float MAKE_NOISE = 0.0f;
	float MAX_ADV_SEARCHTIME = 0.0f;
	float MIN_ATTACK_RANGE = 0.0f;
	int MONSTER_ID = 0;
	string MONSTER_MODEL = "MONSTER_MODEL";
	int MONSTER_WIDTH = 0;
	string MOVE_RANGE = "MOVE_RANGE";
	bool MOVE_TARGET_IS_NPC = false;
	float MUMMY_LIVES = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	bool NEW_AI = false;
	int NEW_HEIGHT = 0;
	string NEW_NAME = "NEW_NAME";
	string NEW_RACE = "NEW_RACE";
	int NEW_WIDTH = 0;
	float NEXT_ALLYJUMP = 0.0f;
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	float NEXT_DZOMB_FLEE = 0.0f;
	float NEXT_HITFRUST_RECORD = 0.0f;
	float NEXT_LANTERNCL_REFRESH = 0.0f;
	bool NO_SPAWN_STUCK_CHECK = false;
	bool NO_STEP_ADJ = false;
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
	float NPC_ATN_FLINCH = 0.0f;
	float NPC_ATN_IDLE = 0.0f;
	float NPC_ATN_PAIN = 0.0f;
	float NPC_ATN_STRUCK = 0.0f;
	bool NPC_ATTACK_MISS = false;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	bool NPC_BATTLE_ALLY = false;
	string NPC_BOSS_KILLS = "NPC_BOSS_KILLS";
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	float NPC_BOSS_REGEN_FREQ = 0.0f;
	float NPC_BOSS_REGEN_RATE = 0.0f;
	float NPC_BOSS_RESTORATION = 0.0f;
	float NPC_BS_HALF_HEALTH = 0.0f;
	bool NPC_CANSEE_TARGET = false;
	string NPC_CANT_PARRY_TYPES = "NPC_CANT_PARRY_TYPES";
	int NPC_CHASE_RANGE = 0;
	float NPC_CLOSEIN_RANGE = 0.0f;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	bool NPC_COULD_SEE_TARGET = false;
	bool NPC_CRITICAL = false;
	bool NPC_CRIT_WARN_DELAY = false;
	string NPC_CUR_MATERIAL_TYPE = "NPC_CUR_MATERIAL_TYPE";
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	bool NPC_CUSTOM_NAME = false;
	string NPC_CUSTOM_NAME_STRING = "NPC_CUSTOM_NAME_STRING";
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	float NPC_DBL_MOVEPROX = 0.0f;
	string NPC_DEATH_MSG = "NPC_DEATH_MSG";
	float NPC_DELAY_RETALITATE = 0.0f;
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool NPC_DID_DEATH = false;
	bool NPC_DID_STEP_ADJ = false;
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
	bool NPC_FLINCH_ALLOW_SUSPEND_AI = false;
	bool NPC_FLINCH_ALLOW_SUSPEND_MOVEMENT = false;
	bool NPC_FLINCH_DISABLE_ONCE = false;
	float NPC_FLINCH_THRESH = 0.0f;
	float NPC_FLINCH_TIME = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_FLINCH = 0.0f;
	float NPC_FREQ_IDLE = 0.0f;
	float NPC_FREQ_PAIN = 0.0f;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	int NPC_FRUST_THRESHOLD = 0;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	bool NPC_GOING_HOME = false;
	float NPC_HALF_HEIGHT = 0.0f;
	float NPC_HALF_WIDTH = 0.0f;
	bool NPC_HAS_TARGET = false;
	float NPC_HEIGHT = 0.0f;
	bool NPC_HOMER_FIRST_CALL = false;
	Vector3 NPC_HOME_ANG = Vector3();
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_HUNTING_BLIND = false;
	bool NPC_IGNORE_PLAYERS = false;
	bool NPC_INALLY = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LASTSEEN_ENEMY_TIME = 0.0f;
	Vector3 NPC_LASTSEEN_POS = Vector3();
	float NPC_LAST_DAMAGED_OTHER_TIME = 0.0f;
	float NPC_LAST_DAMAGED_TIME = 0.0f;
	Vector3 NPC_LAST_ORIGIN = Vector3();
	float NPC_LAST_STRUCK_TIME = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_LAST_SUSPEND_AI = 0.0f;
	string NPC_LOST_TARGET = "NPC_LOST_TARGET";
	bool NPC_MADE_IT_HOME = false;
	string NPC_MATERIAL_TYPE = "NPC_MATERIAL_TYPE";
	float NPC_MAXHP = 0.0f;
	float NPC_MAX_RANGE = 0.0f;
	float NPC_MAX_UNSEEN_TIME = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	string NPC_MOST_DISTANT = "NPC_MOST_DISTANT";
	string NPC_MOVEDEST_TARGET = "NPC_MOVEDEST_TARGET";
	bool NPC_MOVEMENT_SUSPENDED = false;
	string NPC_MOVEPROX = "NPC_MOVEPROX";
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_NEVER_RESUME = false;
	bool NPC_NEVER_RESUME_AI = false;
	float NPC_NEXT_FLINCH = 0.0f;
	float NPC_NEXT_IDLE = 0.0f;
	float NPC_NEXT_PAIN = 0.0f;
	float NPC_NEXT_RETALITATE = 0.0f;
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
	string NPC_PAIN_LEVEL = "NPC_PAIN_LEVEL";
	int NPC_PITCH_FLINCH = 0;
	int NPC_PITCH_IDLE = 0;
	int NPC_PITCH_PAIN = 0;
	int NPC_PITCH_STRUCK = 0;
	string NPC_PREV_TARGET = "NPC_PREV_TARGET";
	bool NPC_PROXACT_INRANGE = false;
	CBaseEntity@ NPC_PROXACT_PLAYERID = null;
	CBasePlayer@ NPC_PROXACT_SCANID = null;
	bool NPC_PROXACT_TRIPPED = false;
	bool NPC_PROX_LOOP = false;
	bool NPC_QUED_FOR_DEATH = false;
	string NPC_RANGED = "NPC_RANGED";
	string NPC_RANGE_TYPE = "NPC_RANGE_TYPE";
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	float NPC_RESUME_AI_TIME = 0.0f;
	bool NPC_RETALIATING = false;
	bool NPC_RETURNING_HOME = false;
	bool NPC_ROAMING_HOME = false;
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
	float NPC_SPAWN_PRED1 = 0.0f;
	float NPC_SPAWN_PRED2 = 0.0f;
	float NPC_SPAWN_TIME = 0.0f;
	int NPC_SPRITE_IN = 0;
	string NPC_STOREHUNTSTATE_ADVANCED = "NPC_STOREHUNTSTATE_ADVANCED";
	string NPC_STOREHUNTSTATE_MLK = "NPC_STOREHUNTSTATE_MLK";
	float NPC_STORE_HP = 0.0f;
	string NPC_STORE_LOST_TARGET = "NPC_STORE_LOST_TARGET";
	string NPC_STORE_TARGET = "NPC_STORE_TARGET";
	int NPC_STRUCK_CHANNEL = 0;
	string NPC_STRUCK_SOUND_EVENT = "NPC_STRUCK_SOUND_EVENT";
	int NPC_STRUCK_VOL = 0;
	bool NPC_STUCK_TELEPORT = false;
	bool NPC_SUMMON = false;
	bool NPC_TARGET_INVALID = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_USE_FLINCH = false;
	bool NPC_USE_IDLE = false;
	bool NPC_USE_PAIN = false;
	bool NPC_VADJSTING = false;
	Vector3 NPC_VANISHED_AT = Vector3();
	string NPC_VANISH_RETURN_TIME = "NPC_VANISH_RETURN_TIME";
	int NPC_WANDER_RANGE = 0;
	bool NPC_WAS_IN_BATTLE = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
	int OLD_NO_STUCK_CHECKS = 0;
	float ORIG_MOVERANGE = 0.0f;
	string PARRY_TYPE = "PARRY_TYPE";
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	int QUEST_ACTIVE_COMBATANT = 0;
	string QUEST_ACTIVE_TEXT = "QUEST_ACTIVE_TEXT";
	string QUEST_ASKING_TEXT = "QUEST_ASKING_TEXT";
	int QUEST_COMBATANT = 0;
	string QUEST_COMPLETE_TEXT = "QUEST_COMPLETE_TEXT";
	string QUEST_DATA1 = "QUEST_DATA1";
	bool QUEST_EXPERT_COMBATANT = false;
	string QUEST_FADE_ON_COMPLETE = "QUEST_FADE_ON_COMPLETE";
	int QUEST_FOLLOWER = 0;
	string QUEST_GIVER_NAME = "QUEST_GIVER_NAME";
	bool QUEST_REWARD_ALL = false;
	string QUEST_REWARD_EVENT = "QUEST_REWARD_EVENT";
	string QUEST_REWARD_TYPE = "QUEST_REWARD_TYPE";
	string QUEST_TYPE = "QUEST_TYPE";
	string QUEST_WAITING_TEXT = "QUEST_WAITING_TEXT";
	string RETALIATE_CHANCE = "RETALIATE_CHANCE";
	bool RE_FLEE_DELAY = false;
	bool SEARCH_ROTATION = false;
	int SET_SIEGE_MODE = 0;
	bool SKELE_TURNED = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string SOUND_ALERT1 = "SOUND_ALERT1";
	string SOUND_ALERT2 = "SOUND_ALERT2";
	string SOUND_ALERT3 = "SOUND_ALERT3";
	string SOUND_ALLY_JUMP = "SOUND_ALLY_JUMP";
	string SOUND_ATTACK1 = "SOUND_ATTACK1";
	string SOUND_ATTACK2 = "SOUND_ATTACK2";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_FLINCH1 = "SOUND_FLINCH1";
	string SOUND_FLINCH2 = "SOUND_FLINCH2";
	string SOUND_FLINCH3 = "SOUND_FLINCH3";
	string SOUND_PAIN = "SOUND_PAIN";
	string SOUND_PAIN1 = "SOUND_PAIN1";
	string SOUND_PAIN2 = "SOUND_PAIN2";
	string SOUND_PAIN3 = "SOUND_PAIN3";
	string SOUND_STRUCK = "SOUND_STRUCK";
	float STRUCK_BY_HOLY = 0.0f;
	bool STRUCK_HOLY = false;
	float STUCK_COUNT = 0.0f;
	string SUBMODEL_GROUPS = "SUBMODEL_GROUPS";
	bool SUSPEND_AI = false;
	string TOFLEE_DISTANCE = "TOFLEE_DISTANCE";
	bool USE_LANTERN = false;
	string USE_SKIN = "USE_SKIN";

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DqBaseQuests_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return DqBaseQuests_DispatchEvent(name, params);
	}
}
