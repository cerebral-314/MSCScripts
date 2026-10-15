#pragma context server

// Converted from helena/helena_npc.script by msc_transpiler.
// This script eventually to be applied to all helena NPC's as an include
// - idea being to strip them of vunlerability and move them into a position where the orcs can reach them

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HelenaNpc
{
	// Variables (an unset .script variable reads as its own name)
	CBaseEntity@ SCAREY_GUY = null;
	bool RAID_ON = false;
	bool HELENA_RETURNED_HOME = false;
	bool HELENA_SAVED = false;
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	Vector3 NPC_HOME_ANG = Vector3();
	int STORE_CLOSED = 0;
	float HELENA_TELE_HOME_TIME = 0.0f;
	string OVERCHARGE = "OVERCHARGE";
	float SELL_RATIO = 0.0f;

	// game_struck
	// ================= NEW SYSTEM
	void HelenaNpc_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnHelenaFlee(EntityOf(ENT_LASTSTRUCK));
	}

	// game_heardsound
	void HelenaNpc_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
		if (!(RangeTo(lastHeard) < 128.0f))
			return;
		if (IsPlayer(lastHeard)) // hguards will face some players if this condition isnt here
			return;
		if (RaceOf(lastHeard) == "orc")
			OnHelenaFlee(lastHeard);
		if (RaceOf(lastHeard) == "rogue")
			OnHelenaFlee(lastHeard);
	}

	// helena_flee
	void HelenaNpc_OnHelenaFlee(CBaseEntity@ attacker = null)
	{
		// dbg fleeing $get(PARAM1,name)
		SetRoam(true);

		@SCAREY_GUY = attacker;

		SetMoveAnim("run1");
		SetMoveDest(@SCAREY_GUY, 1024, "flee");
		CallEventDelayed(10.0f, "helena_stopflee");
	}

	// helena_stopflee
	void HelenaNpc_OnHelenaStopflee()
	{
		SetMoveAnim("walk_scared");
	}

	// helena_raid_go
	// called by helena/helena when bad guys come to down
	void HelenaNpc_OnHelenaRaidGo()
	{
		// dbg helena_raid_go
		SetHearingSensitivity(4);

		RAID_ON = true;
		HELENA_RETURNED_HOME = false;

		HELENA_SAVED = false;
		if (NPC_HOME_LOC == "NPC_HOME_LOC")
		{
			// only set once
			NPC_HOME_LOC = Text(MyOrigin());
			NPC_HOME_ANG = MyAngles();
		}
		SetInvincible(false);
		SetMoveAnim("walk_scared");
		SetIdleAnim("crouch_idle");

		// close shop
		SetMenuAutoOpen(false);
		STORE_CLOSED = 1;
	}

	// helena_raid_end
	// called by helena/helena when all bad guys are dead
	void HelenaNpc_OnHelenaRaidEnd()
	{
		// go home, if can't get home in 60 seconds, teleport
		HELENA_TELE_HOME_TIME = GameTime() + 60.0f;
		if (GetVar("STORE_NAME") != "STORE_NAME")
			OnHelenaReturnHome();
		if (GetVar("STORE_NAME") == "STORE_NAME")
			OnHelenaMadeItHome();
	}

	// helena_return_home
	void HelenaNpc_OnHelenaReturnHome()
	{
		bool exitSub = false;

		SetMoveDest(NPC_HOME_LOC, 10);
		if (Distance(MyOrigin(), Vec(NPC_HOME_LOC)) < 10.0f)
		{
			OnHelenaMadeItHome();
			exitSub = true;
		}
		if (GameTime() >= HELENA_TELE_HOME_TIME)
		{
			OnHelenaMadeItHome();
			exitSub = true;
		}
		if (exitSub)
			return;
		if (!(GameTime() < HELENA_TELE_HOME_TIME))
			return;
		if (HELENA_RETURNED_HOME)
			return;
		float rndDelay = Random(4, 9);
		CallEventDelayed(rndDelay, "helena_return_home");
	}

	// helena_made_it_home
	void HelenaNpc_OnHelenaMadeItHome()
	{
		// vendors snap to
		// re-open store at reduced prices
		OVERCHARGE = "50";
		SELL_RATIO = 1.0f;
		STORE_CLOSED = 0;
		HELENA_SAVED = true;

		if (GetVar("STORE_NAME") != "STORE_NAME")
		{
			SetOrigin(ENT_ME, Vec(NPC_HOME_LOC));
			float oldYaw = NPC_HOME_ANG.y;
			SetAngle("face", Vector3(0, oldYaw, 0));
			SetIdleAnim("idle1");
			SetMoveAnim("idle1");
			SetRoam(false);
			SetMoveDest("none");
			LegacyCommand("npcstore.remove", GetVar("STORE_NAME"), "allitems");
			OnVendorAddstoreitems();

			SetMenuAutoOpen(true);
		}
		else
		{
			SetIdleAnim("idle1");
			SetMoveAnim("walk");
		}

		HELENA_RETURNED_HOME = true;

		RAID_ON = false;
	}

	// basevendor_offerstore
	void HelenaNpc_OnBasevendorOfferstore(string target = "")
	{
		if (!HELENA_SAVED)
			return;
		int rndSay = RandomInt(1, 3);

		if (rndSay == 1)
			SayText("Thank you for saving our little town. For you, I'll offer a discount rate.");
		if (rndSay == 2)
			SayText("For the saviors of Helena, we offer discount rates.");
		if (rndSay == 3)
			SayText("Thank you again, please, consider everything on discount.");
		Say("[.56]", "[.4]", "[.58]", "[.66]");
	}

	// game_struck
	void HelenaNpc_OnGameStruck_2(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Truthy(GetVar("DEFAULT_HUMAN"))) // duplications in helenea/default_human
			return;
		OnCallForHelp(EntityOf(ENT_LASTSTRUCK));
	}

	// call_for_help
	// PARAM1 = threatening entity
	void HelenaNpc_OnCallForHelp(CBaseEntity@ attacker = null)
	{
		SetSayTextRange(1024);
		int randScream = RandomInt(1, 4);
		if (randScream == 1)
			SayText("Help! Help!");
		if (randScream == 2)
			SayText("Guards! Call the guards!");
		if (randScream == 3)
			SayText("Save me!");
		if (randScream == 4)
			SayText("Help! Help! I'm being repressed!");
		CallExternal("all", "civilian_attacked", @attacker, IsPlayer(attacker));
	}

	// game_death
	void HelenaNpc_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (Truthy(GetVar("DEFAULT_HUMAN")))
			return;
		CallExternal("all", "civilian_attacked", @EntityOf(ENT_LASTSTRUCK), IsPlayer(ENT_LASTSTRUCK));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		HelenaNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
		HelenaNpc_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4);
	}

	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { HelenaNpc_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnHelenaFlee(CBaseEntity@ attacker = null) { HelenaNpc_OnHelenaFlee(attacker); } // helena_flee
	void OnHelenaStopflee() { HelenaNpc_OnHelenaStopflee(); } // helena_stopflee
	void OnHelenaRaidGo() { HelenaNpc_OnHelenaRaidGo(); } // helena_raid_go
	void OnHelenaRaidEnd() { HelenaNpc_OnHelenaRaidEnd(); } // helena_raid_end
	void OnHelenaReturnHome() { HelenaNpc_OnHelenaReturnHome(); } // helena_return_home
	void OnHelenaMadeItHome() { HelenaNpc_OnHelenaMadeItHome(); } // helena_made_it_home
	void OnBasevendorOfferstore(string target = "") { HelenaNpc_OnBasevendorOfferstore(target); } // basevendor_offerstore
	void OnCallForHelp(CBaseEntity@ attacker = null) { HelenaNpc_OnCallForHelp(attacker); } // call_for_help
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { HelenaNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnRndDelay() {} // RND_DELAY
	void OnVendorAddstoreitems() {} // vendor_addstoreitems

	// This file's events and timers by their .script names
	bool HelenaNpc_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "basevendor_offerstore") { OnBasevendorOfferstore(Param(params, 0)); return true; }
		if (name == "call_for_help") { OnCallForHelp(EntityParam(params, 0)); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "helena_flee") { OnHelenaFlee(EntityParam(params, 0)); return true; }
		if (name == "helena_made_it_home") { OnHelenaMadeItHome(); return true; }
		if (name == "helena_raid_end") { OnHelenaRaidEnd(); return true; }
		if (name == "helena_raid_go") { OnHelenaRaidGo(); return true; }
		if (name == "helena_return_home") { OnHelenaReturnHome(); return true; }
		if (name == "helena_stopflee") { OnHelenaStopflee(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "helena/helena_npc"]
shared class HelenaNpcScript : DebugScript, HelenaNpc
{
	// Variables every script that includes this file declares
	float ADJ_RATIO = 0.0f;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	float AS_ATTACKING = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_RANGE = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	float BASE_MOVESPEED = 0.0f;
	string CANT_TURN = "CANT_TURN";
	string CAN_FLEE = "CAN_FLEE";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	bool DEMON_BLOOD = false;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	bool EFFECT_DAMAGE_DELAY = false;
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	string EXT_DAMAGE_ADJUSTMENT = "EXT_DAMAGE_ADJUSTMENT";
	bool EXT_DBG_LOOP_ON = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	bool EXT_FADE_ON_DEATH = false;
	string EXT_HITCHANCE_ADJUSTMENT = "EXT_HITCHANCE_ADJUSTMENT";
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
	float MAKE_NOISE = 0.0f;
	int MONSTER_WIDTH = 0;
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
	float NPC_ALL_XP_ADJ = 0.0f;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	bool NPC_AUTO_DEATH = false;
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
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
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FORCE_ROAM = false;
	float NPC_FREQ_WARN = 0.0f;
	bool NPC_FRIENDLY = false;
	bool NPC_GAVE_XP_MSG = false;
	bool NPC_GHOST = false;
	float NPC_GIVE_EXP = 0.0f;
	string NPC_GLOW = "NPC_GLOW";
	float NPC_HP_MULTI = 0.0f;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_IS_BOSS = false;
	bool NPC_IS_TURRET = false;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	float NPC_MAXHP = 0.0f;
	float NPC_MODEL_SCALED = 0.0f;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	int NPC_NO_AGRO = 0;
	bool NPC_NO_AUTO_ACTIVATE = false;
	bool NPC_NO_COUNT = false;
	bool NPC_NO_DROPS = false;
	bool NPC_NO_PLAYER_DMG = false;
	bool NPC_NO_ROAM = false;
	bool NPC_NO_SIEGE_HUNT = false;
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	bool NPC_OVERRIDE_DEATH = false;
	bool NPC_QUED_FOR_DEATH = false;
	bool NPC_REACT_CANSEETARGET = false;
	CBaseEntity@ NPC_REACT_LAST_TARGET = null;
	float NPC_REACT_RESET_TARGET_TIME = 0.0f;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	bool NPC_SELF_ADJUST = false;
	bool NPC_SELF_ADJUST_NOAVG = false;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_SILENT_DEATH = false;
	bool NPC_SILENT_SUICIDE = false;
	int NPC_SPRITE_IN = 0;
	bool NPC_SUMMON = false;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	bool NPC_USES_HANDLE_EVENTS = false;
	bool NPC_WINKED_OUT = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_XPTR = false;
	float NPC_XPTR_MAXXP = 0.0f;
	float NPC_XPTR_TIME = 0.0f;
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
		return HelenaNpc_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
