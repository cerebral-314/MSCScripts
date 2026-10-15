#pragma context server

// Converted from player/player_animation.script by msc_transpiler.
// Player animations

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerAnimation
{
	// Constants
	string ANIM_STAND = "stand";
	string ANIM_STAND_IDLE = "idle";
	string ANIM_CROUCH = "crouch_idle";
	string ANIM_CROUCHMOVE = "crawl";
	string ANIM_WALK = "walk_slow";
	string ANIM_RUN = "run";
	string ANIM_JUMP = "jump";
	string ANIM_TREAD = "treadwater";
	string ANIM_SWIM = "swim";
	string ANIM_DEATH = "die_simple";
	string ANIM_DEATH2 = "die_forwards";
	bool ANIM_TYPE_WALK = false;
	bool ANIM_TYPE_ONCE = true;
	int ANIM_TYPE_HOLD = 2;

	// Variables (an unset .script variable reads as its own name)
	string TORSO_ANIM = "TORSO_ANIM";
	string LEGS_ANIM = "LEGS_ANIM";
	string CURRENT_DEATH_ANIM = "CURRENT_DEATH_ANIM";

	// unnamed block (first think)
	void PlayerAnimation_FirstThink()
	{
		SetVar("anim.underwater", 0);
	}

	// game_animate
	// Called every frame
	void PlayerAnimation_OnGameAnimate()
	{
		// Normal animation
		LegacyCommand("setstatus", "remove", "swimming");
		int waterlevel = Int(Eval("game.monster.waterlevel"));

		if (waterlevel == 0)
		{
			SetVar("anim.underwater", 0);
		}
		else if (waterlevel < 2)
		{
			if (Truthy(Eval("game.monster.onground")))
				SetVar("anim.underwater", 0);
			else
				SetVar("anim.underwater", 1);
		}
		else if (waterlevel >= 2)
			SetVar("anim.underwater", 1);

		LegacyCommand("gaitframerate", 0); // Reset gait framerate

		if (Float(Eval("game.monster.anim.type")) == (ANIM_TYPE_WALK ? 1.0f : 0.0f))
			OnWalkAnimate();
		else if (Float(Eval("game.monster.anim.type")) == (ANIM_TYPE_ONCE ? 1.0f : 0.0f))
			OnOnceAnimate();
		else if (Float(Eval("game.monster.anim.type")) == ANIM_TYPE_HOLD)
			OnHoldAnimate();
	}

	// walk_animate
	void PlayerAnimation_OnWalkAnimate()
	{
		// Normal player walking around or standing idle, not doing anything special
		if (!Truthy(Eval("game.monster.in_attack_stance")))
		{
			// Set the Torso Animation
			// crouch, walk, run
			TORSO_ANIM = "0"; // JUN2013_09 - conflict - also, we really need to get rid of this whole script
			float legsFramerate = 1.0f;
			int currentSpeed = Int(Eval("game.monster.speed2D"));
			float speedShowRunAnim = Float(Eval("game.monster.walkspeed"));
			speedShowRunAnim += 60.0f;

			// local SPEED_SHOW_RUN_ANIM game.monster.walkspeed  //Threshold Lowered.  Now runs when just pressing 'W'
			// Dry land
			bool onground = true;

			// if( !game.monster.onground ) if( $vec.z(game.monster.velocity) <= -300 ) local l.onground 0
			if (onground)
			{
				// On ground
				if (Truthy(Eval("game.monster.ducking")))
				{
					if (currentSpeed == 0)
						TORSO_ANIM = ANIM_CROUCH;
					else
						TORSO_ANIM = ANIM_CROUCHMOVE;
					// setvard LEGS_FRAMERATE 2.0
					LEGS_ANIM = TORSO_ANIM;
				}
				else if (currentSpeed == 0)
				{
					if (Truthy(Eval("game.monster.currentitem")))
						TORSO_ANIM = ANIM_STAND;
					else
						TORSO_ANIM = ANIM_STAND_IDLE;

					LEGS_ANIM = TORSO_ANIM;
				}
				else if (currentSpeed <= speedShowRunAnim)
				{
					TORSO_ANIM = ANIM_WALK;
					LEGS_ANIM = TORSO_ANIM;
					LegacyCommand("setgaitspeed", Eval("game.monster.walkspeed"));
				}
				else
				{
					// setvard LEGS_FRAMERATE 1.0
					// if( L_CURRENT_SPEED  > SPEED_SHOW_RUN_ANIM )
					TORSO_ANIM = ANIM_RUN;
					LEGS_ANIM = "0";
					LegacyCommand("setgaitspeed", speedShowRunAnim);
				}
			}
			else
			{
				// In air
				TORSO_ANIM = ANIM_JUMP;
				LEGS_ANIM = "0";
			}
		}
		else
		{
			// Set the Legs Animation... same as torso
			// gaitframerate LEGS_FRAMERATE
			// In attack stance (holding an animation after an attack)
			TORSO_ANIM = "aim_" + Eval("game.monster.currentitem.anim_torso");
			bool uselegs = false;
			if (Truthy(Eval("game.monster.ducking"))) // ducking - always use legs
				uselegs = true;
			if (Truthy(Eval("game.monster.speed2D"))) // standing - only use legs when moving
				uselegs = true;

			if (uselegs)
				OnLegsAnimate();
			else
				LEGS_ANIM = "0";
		}

		// if ( LEGS_ANIM equals 0 )
		// {
		// //legs anim fuxed for some reason
		// setvard LEGS_ANIM idle
		// if ( game.monster.ducking )
		// {
		// setvard LEGS_ANIM crouch_idle
		// if game.monster.speed > 0
		// setvard LEGS_ANIM crawl
		// }
		// else
		// {
		// setvard LEGS_ANIM idle
		// if game.monster.speed > 0
		// setvard LEGS_ANIM walk
		// if game.monster.jumping
		// setvard LEGS_ANIM jump
		// }
		// dbg player_animation - no_leg_anim ( set LEGS_ANIM )
		// }
		// Set the final animation to use in-game
		LegacyCommand("setanimtorso", TORSO_ANIM);
		LegacyCommand("setanimlegs", LEGS_ANIM);
	}

	// once_animate
	void PlayerAnimation_OnOnceAnimate()
	{
		// This is an animation played once to completion, then let go for the walk handler to take over
		// Attack, jump, some emotes, etc. use this.
		// Keep the default Torso anim, but make sure we pick the right Legs anim based on
		// what the player is currently doing
		if (Truthy(Eval("game.monster.anim.uselegs")))
		{
			OnLegsAnimate();

			// Set the final Legs anim
			LegacyCommand("setanimlegs", LEGS_ANIM);
		}

		// Let go of this animation when we've played all the frames
		if (Float(Eval("game.monster.anim.current_frame")) >= Float(Eval("game.monster.anim.max_frames")))
		{
			PlayAnim("break");
			OnWalkAnimate(); // Make sure that "setanimtorso" is set right, in case we're going to hold the ready anim for 3 secs
		}
	}

	// hold_animate
	void PlayerAnimation_OnHoldAnimate()
	{
	}

	// legs_animate
	void PlayerAnimation_OnLegsAnimate()
	{
		// Uses the anim ext set by an item to determine the current leg anim
		// This event sets LEGS_ANIM as the final legs to be used
		string customLegsAnim = "0";
		bool customExt = false;
		float legsFramerate = 2.3f;

		LEGS_ANIM = Eval("game.player.currentitem.anim_legs");
		if (Truthy(Eval("game.monster.ducking")))
		{
			if (!Truthy(Eval("game.monster.speed2D")))
			{
				// setvard LEGS_ANIM	ANIM_CROUCH		//this doesn't work for some reason -- just use crawl for now
				LEGS_ANIM = ANIM_CROUCHMOVE;
				customExt = false;
			}
			else
			{
				LEGS_ANIM = ANIM_CROUCHMOVE;
				customExt = false;
			}
		}
		else
		{
			float speedShowRunAnim = Float(Eval("game.monster.walkspeed"));
			speedShowRunAnim += 60.0f;

			if (!Truthy(Eval("game.monster.speed2D")))
			{
				LEGS_ANIM = ANIM_STAND;
				customExt = false;
			}
			else if (Float(Eval("game.monster.speed2D")) <= speedShowRunAnim)
			{
				LEGS_ANIM = ANIM_WALK;
				customExt = false;
			}
			else if (Float(Eval("game.monster.speed2D")) > speedShowRunAnim)
			{
				LEGS_ANIM = ANIM_RUN;
				customExt = false;
			}
		}

		// Try to use [stand/walk/crouchidle/crouchwalk]_<legext>, if it exists
		customLegsAnim = Text(customExt) + Eval("game.player.currentitem.anim_legs");
		if (AnimIndex(customLegsAnim) > -1)
			LEGS_ANIM = customLegsAnim;
	}

	// animate_death
	// Custom
	// ------
	void PlayerAnimation_OnAnimateDeath()
	{
		if (RandomInt(0, 1) == 0)
			CURRENT_DEATH_ANIM = ANIM_DEATH;
		else
			CURRENT_DEATH_ANIM = ANIM_DEATH2;

		PlayAnim("critical", CURRENT_DEATH_ANIM);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameAnimate() { PlayerAnimation_OnGameAnimate(); } // game_animate
	void OnWalkAnimate() { PlayerAnimation_OnWalkAnimate(); } // walk_animate
	void OnOnceAnimate() { PlayerAnimation_OnOnceAnimate(); } // once_animate
	void OnHoldAnimate() { PlayerAnimation_OnHoldAnimate(); } // hold_animate
	void OnLegsAnimate() { PlayerAnimation_OnLegsAnimate(); } // legs_animate
	void OnAnimateDeath() { PlayerAnimation_OnAnimateDeath(); } // animate_death

	// This file's events and timers by their .script names
	bool PlayerAnimation_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "animate_death") { OnAnimateDeath(); return true; }
		if (name == "game_animate") { OnGameAnimate(); return true; }
		if (name == "hold_animate") { OnHoldAnimate(); return true; }
		if (name == "legs_animate") { OnLegsAnimate(); return true; }
		if (name == "once_animate") { OnOnceAnimate(); return true; }
		if (name == "walk_animate") { OnWalkAnimate(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_animation"]
shared class PlayerAnimationScript : ScriptEntity, PlayerAnimation
{
	// Variables every script that includes this file declares
	bool AFK_DID_FIRST_PULSE = false;
	Vector3 AFK_OLD_POS = Vector3();
	float AFK_TIME = 0.0f;
	float AFL_BURST_DOT = 0.0f;
	CBaseEntity@ ALCO_SPAWN_ITEM = null;
	string ALCO_TYPE = "ALCO_TYPE";
	int ARMOR_EQUIPED = 0;
	string ARMOR_OFS = "ARMOR_OFS";
	string ARMOR_TYPE = "ARMOR_TYPE";
	string BAR_STRING = "BAR_STRING";
	bool BASE_REGEN_HP = false;
	bool BASE_REGEN_MP = false;
	float BASE_REGEN_RATE = 0.0f;
	float BEAM_ROT = 0.0f;
	float BLOODSTONE_BONUS_RATE = 0.0f;
	string BLOODSTONE_EQUIPPED = "BLOODSTONE_EQUIPPED";
	float BUILD_BAR_COUNT = 0.0f;
	bool CAN_VAMPIRE_TARGET = false;
	string CVAR_HP_LIMIT = "CVAR_HP_LIMIT";
	float DEMON_BLOOD_END_TIME = 0.0f;
	bool DISPLAY_HBAR_DELAY = false;
	bool DISPLAY_PBAR_DELAY = false;
	string DISPLAY_PLAYER_HP = "DISPLAY_PLAYER_HP";
	bool DISPLAY_TARG_HP = false;
	bool ELM_REGISTER_SILENT = false;
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	float EXT_DMGPOINTS = 0.0f;
	bool EXT_EFFECT_LIST = false;
	string EXT_REMOVE_EFFECT = "EXT_REMOVE_EFFECT";
	float FINAL_REGEN_HP = 0.0f;
	float FINAL_REGEN_MP = 0.0f;
	float FINAL_REGEN_RATE_HP = 0.0f;
	float FINAL_REGEN_RATE_MP = 0.0f;
	float FIRST_PARTY_MSG = 0.0f;
	bool FISSURE_ACTIVE = false;
	float FISSURE_COUNT = 0.0f;
	Vector3 FISSURE_DIR = Vector3();
	float FISSURE_DMG = 0.0f;
	Vector3 FISSURE_END = Vector3();
	float FISSURE_LENGTH = 0.0f;
	float FISSURE_MAX_COUNT = 0.0f;
	Vector3 FISSURE_ORG = Vector3();
	Vector3 FISSURE_START = Vector3();
	string FISSURE_YAW = "FISSURE_YAW";
	float FREQ_AFK_CHECK = 0.0f;
	int GAME_PVP = 0;
	bool GAUNTLET_MAP = false;
	bool GAVE_MAP_INTRO = false;
	bool HAD_FIRST_SPAWN = false;
	int HBAR_FRAMES = 0;
	CBaseEntity@ HBAR_TARGET = null;
	bool HIDE_ARMS = false;
	bool HIDE_CHEST = false;
	bool HIDE_HEAD = false;
	bool HIDE_LEGS = false;
	bool IAM_PLAYER = false;
	bool IMMUNE_VAMPIRE = false;
	bool INIT_DMGPOINTS = false;
	string IR_GLOWING = "IR_GLOWING";
	bool IS_AFK = false;
	bool I_R_FROZEN = false;
	float LAST_STRUCK_FOR = 0.0f;
	int LEAP_BACK_DRAIN = 0;
	int LEAP_SIDE_DRAIN = 0;
	string LEVELUP_SCRIPT = "LEVELUP_SCRIPT";
	string LEVEL_UP_SCRIPT = "LEVEL_UP_SCRIPT";
	string L_VOTE_TRIG = "L_VOTE_TRIG";
	float MANARING_BONUS_RATE = 0.0f;
	string MANARING_EQUIPPED = "MANARING_EQUIPPED";
	string MOTD_TXT1 = "MOTD_TXT1";
	string MOTD_TXT2 = "MOTD_TXT2";
	string MOTD_TXT3 = "MOTD_TXT3";
	string MOTD_TXT4 = "MOTD_TXT4";
	string MOTD_TXT5 = "MOTD_TXT5";
	string MOTD_TXT6 = "MOTD_TXT6";
	string MOTD_TXT7 = "MOTD_TXT7";
	float MSC_PUSH_RESIST = 0.0f;
	float MSG_COUNTER = 0.0f;
	string MSG_TEXT = "MSG_TEXT";
	string MSG_TITLE = "MSG_TITLE";
	string MY_BODY = "MY_BODY";
	string MY_CL_BODY = "MY_CL_BODY";
	string MY_GLOW_ID = "MY_GLOW_ID";
	float MY_SPAWN_TIME = 0.0f;
	string NEW_SPAWN_POS = "NEW_SPAWN_POS";
	float NEXT_DODGE = 0.0f;
	float NEXT_HAURA_SOUND = 0.0f;
	float NEXT_LEAPBACK = 0.0f;
	float NEXT_LEAPLEFT = 0.0f;
	float NEXT_LEAPRIGHT = 0.0f;
	float NEXT_PLSHIELD_SOUND = 0.0f;
	float NEXT_REPEL_SHIELD_SOUND = 0.0f;
	float NEXT_TRANS_MESSAGE = 0.0f;
	float N_RMAP_VALIDS = 0.0f;
	string OLD_RESISTANCES = "OLD_RESISTANCES";
	string OWNER_POS = "OWNER_POS";
	string OWNER_YAW = "OWNER_YAW";
	string PLAYING_DEAD = "PLAYING_DEAD";
	float PLR_2HPEN_HEAVY = 0.0f;
	string PLR_2HPEN_HEAVY_REPORT = "PLR_2HPEN_HEAVY_REPORT";
	float PLR_2HPEN_LIGHT = 0.0f;
	string PLR_2HPEN_LIGHT_REPORT = "PLR_2HPEN_LIGHT_REPORT";
	float PLR_2H_REDUCT = 0.0f;
	string PLR_ACTIVE_PETS = "PLR_ACTIVE_PETS";
	string PLR_ACTIVE_PET_TYPES = "PLR_ACTIVE_PET_TYPES";
	string PLR_ACTIVE_VIEWMODEL = "PLR_ACTIVE_VIEWMODEL";
	CBaseEntity@ PLR_ACTIVE_WEAPON = null;
	string PLR_ADD_FIRE_DOT = "PLR_ADD_FIRE_DOT";
	string PLR_ARMOR_ID = "PLR_ARMOR_ID";
	string PLR_ARROW_ID = "PLR_ARROW_ID";
	float PLR_ARROW_MENU = 0.0f;
	CBaseEntity@ PLR_BEAR_IMAGE_ID = null;
	bool PLR_BEAR_MODE = false;
	string PLR_BODY_TYPE = "PLR_BODY_TYPE";
	bool PLR_BRAVERY = false;
	bool PLR_CHECK_SUMMON_ACTIVE = false;
	string PLR_CHECK_SUMMON_ACTIVE_TYPE = "PLR_CHECK_SUMMON_ACTIVE_TYPE";
	bool PLR_CHECK_WEAPON_RESIST = false;
	string PLR_COMBAT_ICON = "PLR_COMBAT_ICON";
	string PLR_CORRODE_DURATION = "PLR_CORRODE_DURATION";
	float PLR_CRE_HAND = 0.0f;
	string PLR_CRE_TYPE = "PLR_CRE_TYPE";
	string PLR_CUR_TRANS = "PLR_CUR_TRANS";
	float PLR_DARK_LEVEL = 0.0f;
	int PLR_DARK_LEVEL_LOSS_RATE = 0;
	string PLR_DAURA_CL_IDX = "PLR_DAURA_CL_IDX";
	int PLR_DBURST_AOE = 0;
	float PLR_DBURST_DMG = 0.0f;
	float PLR_DBURST_DOT = 0.0f;
	float PLR_DBURST_MAXPUSH = 0.0f;
	string PLR_DBURST_ORG = "PLR_DBURST_ORG";
	bool PLR_DBURST_PUSH = false;
	float PLR_DBURST_SKILL = 0.0f;
	bool PLR_DEBUG_ARRAY_ACTIVE = false;
	int PLR_DEL_PLAYSOUND_CHAN = 0;
	int PLR_DEL_PLAYSOUND_VOL = 0;
	string PLR_DEL_PLAYSOUND_WAV = "PLR_DEL_PLAYSOUND_WAV";
	float PLR_DEVELOPER = 0.0f;
	bool PLR_DID_MOTD = false;
	bool PLR_DID_SHENDER_EVENT = false;
	float PLR_DMG = 0.0f;
	string PLR_DMG_ADJUST_FIRE = "PLR_DMG_ADJUST_FIRE";
	float PLR_DONATOR = 0.0f;
	bool PLR_EPILEPSY_ACTIVE = false;
	float PLR_EPILEPSY_COUNT = 0.0f;
	float PLR_EPILEPSY_DELAY = 0.0f;
	bool PLR_FAURA = false;
	int PLR_FAURA_AOE = 0;
	string PLR_FAURA_CLIDX = "PLR_FAURA_CLIDX";
	float PLR_FAURA_CL_RATE = 0.0f;
	string PLR_FAURA_DOT = "PLR_FAURA_DOT";
	float PLR_FAURA_NEXT_CL = 0.0f;
	string PLR_FAURA_SCAN = "PLR_FAURA_SCAN";
	bool PLR_FEAURA = false;
	int PLR_FEAURA_AOE = 0;
	string PLR_FEAURA_CLIDX = "PLR_FEAURA_CLIDX";
	string PLR_FEAURA_DOT = "PLR_FEAURA_DOT";
	float PLR_FEAURA_NEXT_CL = 0.0f;
	string PLR_FEAURA_SCAN = "PLR_FEAURA_SCAN";
	CBaseEntity@ PLR_FISTS_ID = null;
	CBaseEntity@ PLR_FOUND_PET = null;
	bool PLR_GCOD_ACTIVE = false;
	int PLR_GCOD_AOE = 0;
	string PLR_GCOD_DMG = "PLR_GCOD_DMG";
	float PLR_GCOD_DUR = 0.0f;
	Vector3 PLR_GCOD_POS = Vector3();
	string PLR_GENDER = "PLR_GENDER";
	bool PLR_GLOW_BLOCK = false;
	bool PLR_GOT_REWARD = false;
	bool PLR_HAD_MATCHED_SET = false;
	bool PLR_HAND_SET = false;
	string PLR_HAS_GLOW = "PLR_HAS_GLOW";
	bool PLR_HAS_MATCHED_SET = false;
	float PLR_HAS_TROLLCANO = 0.0f;
	bool PLR_HAURA_ACTIVE = false;
	string PLR_HAURA_CL_ID = "PLR_HAURA_CL_ID";
	string PLR_HAURA_POWER = "PLR_HAURA_POWER";
	int PLR_HAURA_RADIUS = 0;
	string PLR_HAURA_TARGETS = "PLR_HAURA_TARGETS";
	string PLR_HELM_ID = "PLR_HELM_ID";
	bool PLR_IN_COMBAT = false;
	bool PLR_IN_WORLD = false;
	float PLR_LAST_ATK_TIME = 0.0f;
	float PLR_LAST_HBAR_SHOW = 0.0f;
	CBaseEntity@ PLR_LAST_PROJECTILE = null;
	string PLR_LAST_WORN_ARMOR = "PLR_LAST_WORN_ARMOR";
	bool PLR_LCOD_ACTIVE = false;
	int PLR_LCOD_AOE = 0;
	string PLR_LCOD_DMG = "PLR_LCOD_DMG";
	float PLR_LCOD_DUR = 0.0f;
	Vector3 PLR_LCOD_POS = Vector3();
	CBaseEntity@ PLR_LEFT_HAND = null;
	bool PLR_LESSER_LEADFOOT = false;
	float PLR_LESSER_LEADFOOT_STUN = 0.0f;
	bool PLR_LIGHTS_SYNCED = false;
	string PLR_LOCAL_TRANS = "PLR_LOCAL_TRANS";
	bool PLR_LOCK_CLEAR = false;
	string PLR_LTRAN_MAXS = "PLR_LTRAN_MAXS";
	string PLR_LTRAN_MINS = "PLR_LTRAN_MINS";
	Vector3 PLR_LTRAN_ORG = Vector3();
	bool PLR_MANA_FONT = false;
	int PLR_MAX_DARK_LEVEL = 0;
	float PLR_NEXT_FSAURA_SOUND = 0.0f;
	float PLR_NEXT_GCOD_SOUND = 0.0f;
	float PLR_NEXT_HASTE = 0.0f;
	float PLR_NEXT_LCOD_SOUND = 0.0f;
	float PLR_NEXT_SCROLL = 0.0f;
	float PLR_NEXT_STUCK_ADJ = 0.0f;
	string PLR_NEXT_TRANS = "PLR_NEXT_TRANS";
	float PLR_N_ACTIVE_PETS = 0.0f;
	string PLR_OLOF_STATUS = "PLR_OLOF_STATUS";
	int PLR_ORCFOR_MUSIC = 0;
	bool PLR_PAURA = false;
	int PLR_PAURA_AOE = 0;
	string PLR_PAURA_CLIDX = "PLR_PAURA_CLIDX";
	float PLR_PAURA_CL_RATE = 0.0f;
	string PLR_PAURA_DOT = "PLR_PAURA_DOT";
	float PLR_PAURA_NEXT_CL = 0.0f;
	string PLR_PAURA_SCAN = "PLR_PAURA_SCAN";
	bool PLR_PBOLT_ACTIVE = false;
	int PLR_PBOLT_AOE = 0;
	string PLR_PBOLT_ARRAY = "PLR_PBOLT_ARRAY";
	float PLR_PBOLT_COUNTER = 0.0f;
	float PLR_PBOLT_DOT = 0.0f;
	string PLR_PBOLT_ORG = "PLR_PBOLT_ORG";
	string PLR_PBOLT_TARGS = "PLR_PBOLT_TARGS";
	string PLR_PET_IDS = "PLR_PET_IDS";
	string PLR_PET_LIST = "PLR_PET_LIST";
	string PLR_PET_TYPES = "PLR_PET_TYPES";
	bool PLR_PLSHIELD_ACTIVE = false;
	string PLR_PLSHIELD_CL_IDX = "PLR_PLSHIELD_CL_IDX";
	float PLR_PLSHIELD_DOT = 0.0f;
	int PLR_PLSHIELD_PUSH = 0;
	string PLR_PLSHIELD_TARGETS = "PLR_PLSHIELD_TARGETS";
	Vector3 PLR_PRECHEAT_POS = Vector3();
	string PLR_PREV_BODY_TYPE = "PLR_PREV_BODY_TYPE";
	float PLR_REPEL_MAX_HP = 0.0f;
	Vector3 PLR_REPEL_ORG = Vector3();
	int PLR_REPEL_PUSH_STR = 0;
	bool PLR_REPEL_SHIELD_ACTIVE = false;
	int PLR_REPEL_SHIELD_RADIUS = 0;
	string PLR_REPEL_SHIELD_SPECIAL = "PLR_REPEL_SHIELD_SPECIAL";
	string PLR_REPEL_SHIELD_TARGETS = "PLR_REPEL_SHIELD_TARGETS";
	float PLR_RESET_BANK = 0.0f;
	string PLR_RESIST_ELEMENTS = "PLR_RESIST_ELEMENTS";
	string PLR_RESIST_RESET = "PLR_RESIST_RESET";
	bool PLR_RESIST_UPDATE_FLAG = false;
	string PLR_RESIST_VALUES = "PLR_RESIST_VALUES";
	CBaseEntity@ PLR_RIGHT_HAND = null;
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool PLR_SFAURA_ACTIVE = false;
	string PLR_SFAURA_CL_IDX = "PLR_SFAURA_CL_IDX";
	float PLR_SFAURA_DOT = 0.0f;
	int PLR_SFAURA_GROWTH_RATE = 0;
	CBaseEntity@ PLR_SFAURA_ITEM = null;
	float PLR_SFAURA_MAXPUSH = 0.0f;
	int PLR_SFAURA_MAXSIZE = 0;
	int PLR_SFAURA_MP_COST = 0;
	float PLR_SFAURA_SIZE = 0.0f;
	string PLR_SFAURA_TARGS = "PLR_SFAURA_TARGS";
	bool PLR_SHIELD_UP = false;
	string PLR_SOCCER_TEAMSPR = "PLR_SOCCER_TEAMSPR";
	string PLR_SOUND_ARMHIT1 = "PLR_SOUND_ARMHIT1";
	string PLR_SOUND_BREATHFAST1 = "PLR_SOUND_BREATHFAST1";
	string PLR_SOUND_BREATHFAST2 = "PLR_SOUND_BREATHFAST2";
	string PLR_SOUND_BREATHFAST3 = "PLR_SOUND_BREATHFAST3";
	string PLR_SOUND_CHESTHIT1 = "PLR_SOUND_CHESTHIT1";
	string PLR_SOUND_DEATH = "PLR_SOUND_DEATH";
	string PLR_SOUND_FALLPAIN1 = "PLR_SOUND_FALLPAIN1";
	string PLR_SOUND_FALLPAIN2 = "PLR_SOUND_FALLPAIN2";
	string PLR_SOUND_FALLPAIN3 = "PLR_SOUND_FALLPAIN3";
	string PLR_SOUND_FALLPAIN4 = "PLR_SOUND_FALLPAIN4";
	string PLR_SOUND_JAB1 = "PLR_SOUND_JAB1";
	string PLR_SOUND_JAB2 = "PLR_SOUND_JAB2";
	string PLR_SOUND_LEGHIT1 = "PLR_SOUND_LEGHIT1";
	string PLR_SOUND_SHOUT1 = "PLR_SOUND_SHOUT1";
	string PLR_SOUND_STOMACHHIT1 = "PLR_SOUND_STOMACHHIT1";
	string PLR_SOUND_SWORDREADY = "PLR_SOUND_SWORDREADY";
	string PLR_SPEAR_CHARGE_LEVEL = "PLR_SPEAR_CHARGE_LEVEL";
	bool PLR_SPECIAL_WEAPON = false;
	int PLR_SPEED = 0;
	string PLR_SPIDER_AMT = "PLR_SPIDER_AMT";
	bool PLR_SPIDER_PROT = false;
	bool PLR_STARTED_AFK_CHECKS = false;
	float PLR_SUMMON_MENU_DISABLE = 0.0f;
	int PLR_SWIFT_BLADE = 0;
	string PLR_TOD_LOCK = "PLR_TOD_LOCK";
	float PLR_TOTAL_DMG = 0.0f;
	string PLR_UNIQUE_SUMMONS = "PLR_UNIQUE_SUMMONS";
	string PLR_URDUAL_RELEASE_TIME = "PLR_URDUAL_RELEASE_TIME";
	string PLR_WEATHER = "PLR_WEATHER";
	string PLR_WEATHER_BLOCK = "PLR_WEATHER_BLOCK";
	bool PLR_WRAITH_ACTIVE = false;
	bool PL_BEEN_ATTACKED = false;
	bool PL_I_R_FROZEN = false;
	string PL_PARRY = "PL_PARRY";
	float PL_TIME = 0.0f;
	bool REGEN_ON = false;
	float REGEN_RATE = 0.0f;
	string RMAP_SERIES_START = "RMAP_SERIES_START";
	string RMAP_SERIES_TITLE = "RMAP_SERIES_TITLE";
	string RMAP_TYPE = "RMAP_TYPE";
	bool RMAP_VALIDATED_GAUNTLET = false;
	string RMAP_VALID_FROM = "RMAP_VALID_FROM";
	bool SCARABS_ATTACHED = false;
	bool SCROLL_WARNING_LEVEL = false;
	bool SEND_DMG_DELAY = false;
	string SHOW_HEALTH = "SHOW_HEALTH";
	float SIZE_IDX = 0.0f;
	string SOUNDSET_HF_ARMHIT1 = "SOUNDSET_HF_ARMHIT1";
	string SOUNDSET_HF_BREATHFAST1 = "SOUNDSET_HF_BREATHFAST1";
	string SOUNDSET_HF_BREATHFAST2 = "SOUNDSET_HF_BREATHFAST2";
	string SOUNDSET_HF_BREATHFAST3 = "SOUNDSET_HF_BREATHFAST3";
	string SOUNDSET_HF_CHESTHIT1 = "SOUNDSET_HF_CHESTHIT1";
	string SOUNDSET_HF_DEATH = "SOUNDSET_HF_DEATH";
	string SOUNDSET_HF_FALLPAIN1 = "SOUNDSET_HF_FALLPAIN1";
	string SOUNDSET_HF_FALLPAIN2 = "SOUNDSET_HF_FALLPAIN2";
	string SOUNDSET_HF_FALLPAIN3 = "SOUNDSET_HF_FALLPAIN3";
	string SOUNDSET_HF_FALLPAIN4 = "SOUNDSET_HF_FALLPAIN4";
	string SOUNDSET_HF_JAB1 = "SOUNDSET_HF_JAB1";
	string SOUNDSET_HF_JAB2 = "SOUNDSET_HF_JAB2";
	string SOUNDSET_HF_LEGHIT1 = "SOUNDSET_HF_LEGHIT1";
	string SOUNDSET_HF_SHOUT1 = "SOUNDSET_HF_SHOUT1";
	string SOUNDSET_HF_STOMACHHIT1 = "SOUNDSET_HF_STOMACHHIT1";
	string SOUNDSET_HF_SWORDREADY = "SOUNDSET_HF_SWORDREADY";
	string SOUNDSET_HM_ARMHIT1 = "SOUNDSET_HM_ARMHIT1";
	string SOUNDSET_HM_BREATHFAST1 = "SOUNDSET_HM_BREATHFAST1";
	string SOUNDSET_HM_BREATHFAST2 = "SOUNDSET_HM_BREATHFAST2";
	string SOUNDSET_HM_BREATHFAST3 = "SOUNDSET_HM_BREATHFAST3";
	string SOUNDSET_HM_CHESTHIT1 = "SOUNDSET_HM_CHESTHIT1";
	string SOUNDSET_HM_DEATH = "SOUNDSET_HM_DEATH";
	string SOUNDSET_HM_FALLPAIN1 = "SOUNDSET_HM_FALLPAIN1";
	string SOUNDSET_HM_FALLPAIN2 = "SOUNDSET_HM_FALLPAIN2";
	string SOUNDSET_HM_FALLPAIN3 = "SOUNDSET_HM_FALLPAIN3";
	string SOUNDSET_HM_FALLPAIN4 = "SOUNDSET_HM_FALLPAIN4";
	string SOUNDSET_HM_JAB1 = "SOUNDSET_HM_JAB1";
	string SOUNDSET_HM_JAB2 = "SOUNDSET_HM_JAB2";
	string SOUNDSET_HM_LEGHIT1 = "SOUNDSET_HM_LEGHIT1";
	string SOUNDSET_HM_SHOUT1 = "SOUNDSET_HM_SHOUT1";
	string SOUNDSET_HM_STOMACHHIT1 = "SOUNDSET_HM_STOMACHHIT1";
	string SOUNDSET_HM_SWORDREADY = "SOUNDSET_HM_SWORDREADY";
	string SOUND_BEAR_STRUCK1 = "SOUND_BEAR_STRUCK1";
	string SOUND_BEAR_STRUCK2 = "SOUND_BEAR_STRUCK2";
	string SOUND_BEAR_STRUCK3 = "SOUND_BEAR_STRUCK3";
	string SOUND_DEATH = "SOUND_DEATH";
	string SOUND_LEVELUP1 = "SOUND_LEVELUP1";
	string SPIRAL_DMG = "SPIRAL_DMG";
	string SPIRAL_DMG_TYPE = "SPIRAL_DMG_TYPE";
	Vector3 SPIRAL_GLOW_COLOR = Vector3();
	string SPIRAL_SKILL = "SPIRAL_SKILL";
	string SPIRAL_SPIRTE_FILE = "SPIRAL_SPIRTE_FILE";
	Vector3 SPIRAL_SPRITE_COLOR = Vector3();
	int SPIRAL_SPRITE_FRAMES = 0;
	float SPIRAL_SPRITE_SCALE = 0.0f;
	bool STARTED_VOTE = false;
	string S_DESTNAME = "S_DESTNAME";
	string S_TRANNAME = "S_TRANNAME";
	string TARGET_PET_TYPE = "TARGET_PET_TYPE";
	string THIS_MAP = "THIS_MAP";
	string T_SPHERE = "T_SPHERE";
	string VALID_MAP_LIST_ENGLISH = "VALID_MAP_LIST_ENGLISH";
	string VALID_START_MAP = "VALID_START_MAP";
	float VAMPIRE_MULTI = 0.0f;
	bool VAMPIRE_ON = false;
	bool VOTE_DISABLED = false;

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerAnimation_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerAnimation_DispatchEvent(name, params);
	}
}
