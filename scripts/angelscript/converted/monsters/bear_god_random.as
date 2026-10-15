#pragma context server

// Converted from monsters/bear_god_random.script by msc_transpiler.
// Bear Gods by Thothie for Skycastle remake

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bear_base_giant.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BearGodRandom
{
	// Constants
	float NPC_BOSS_REGEN_RATE = 0.05f;
	float NPC_BOSS_RESTORATION = 0.25f;
	string NPC_BASE_EXP = "4000";
	int ATTACK_STOMPRANGE = 512;
	float FREQ_STOMP = 20.0f;
	string FREQ_STAND = "$randf(15,25)";
	string FREQ_BOLT = "$randf(10,20)";
	string FREQ_TREE = "$randf(20,30)";
	float DMG_STORM = 20.0f;
	float STORM_DUR = 60.0f;
	int STORM_RAD = 1024;
	string SMASH_DAMAGE = "$rand(50,150)";
	string ATTACK_NORMAL_DAMAGE = "$rand(40,80)";
	string ATTACK_STANDING_DAMAGE = "$rand(40,58)";
	int ATTACK_STOMPDMG = 50;
	string ATTACK_HITCHANCE = "70%";
	bool GOLD_BAGS = true;
	int GOLD_BAGS_PPLAYER = 4;
	int GOLD_PER_BAG = 50;
	int GOLD_RADIUS = 200;
	int GOLD_MAX_BAGS = 32;
	string SOUND_ATTACK1 = "monsters/bear/giantbearattack.wav";
	string SOUND_STRUCK4 = "monsters/bear/giantbearpain.wav";
	string SOUND_STRUCK5 = "none";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	bool NPC_OVERSIZED = false;
	bool NPC_IS_BOSS = false;
	string ANIM_ATTACK = "ANIM_ATTACK";
	float NPC_GIVE_EXP = 0.0f;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool IN_INTRO = false;
	string ANIM_INTRO = "ANIM_INTRO";
	float INTRO_YAW = 0.0f;
	int BEAR_TYPE = 0;
	float AS_ATTACKING = 0.0f;
	bool SUSPEND_AI = false;
	Vector3 FIRST_TEST = Vector3();
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	bool STOMP_DELAY = false;
	bool BEAR_ISSTOMPATK = false;
	bool BG_STAND_DELAY = false;
	bool BG_PUSH_ATK = false;
	bool FOUND_TARGET = false;
	float BG_LOOP_COUNT = 0.0f;
	int BG_RANGE = 0;
	string BG_LPLAYERS_INRANGE = "BG_LPLAYERS_INRANGE";
	CBasePlayer@ P_TARGET = null;
	float N_TREES = 0.0f;

	// unnamed block (first think)
	void BearGodRandom_FirstThink()
	{
		NPC_OVERSIZED = true;
		NPC_IS_BOSS = true;

		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "attack";
		NPC_GIVE_EXP = 2000.0f;

		NPC_MUST_SEE_TARGET = "0";
	}

	// game_precache
	void BearGodRandom_OnGamePrecache()
	{
		// prob don't need this, but paranoia
		PrecacheFile("weather/sfx_weather_snow");
		PrecacheFile("weather/sfx_weather_fog_black");
		PrecacheFile("weather/sfx_weather_rain_storm");

		// more likely to be a problem
		PrecacheFile("monsters/summon/uber_blizzard");
		PrecacheFile("monsters/summon/stun_burst");
		PrecacheFile("monsters/summon/shock_beam");
		PrecacheFile("monsters/summon/doom_plant");
	}

	// npc_spawn
	void BearGodRandom_OnNpcSpawn(string npc = "")
	{
		SetHealth(6000);
		// ov 165
		SetModel("monsters/bear_huge.mdl");
		SetWidth(200);
		SetHeight(96);

		SetDamageTaken("stun", 0.3f);

		SetInvincible(true);

		SetIdleAnim("upattack");
		SetMoveAnim("upattack");

		CallEventDelayed(0.1f, "select_bear_type");
		IN_INTRO = true;
		ANIM_INTRO = "upattack";
		CallEventDelayed(0.1f, "intro_loop");
		CallEventDelayed(3.0f, "intro_down");
		CallEventDelayed(5.0f, "end_intro");

		OnNpcatkSuspendAi();

		SetNoPush(true);
	}

	// select_bear_type
	void BearGodRandom_OnSelectBearType()
	{
		OnNpcatkSuspendAi(); // redund
		INTRO_YAW = AnglesOf(ENT_ME).y;
		SetAngle("face", Vector3(0, INTRO_YAW, 0));

		SetDamageTaken("dark", 0.5f);

		if (!OVERRIDE_BEAR)
			BEAR_TYPE = RandomInt(1, 3);

		if (BEAR_TYPE == 1)
		{
			SetName("Bear God of the Frozen Tundra");
			SetDamageTaken("cold", 0);
			SetDamageTaken("fire", 1.25f);
			SetModelBody(0, 0);
			CallExternal("players", "ext_weather_change", "snow");
			CallEventDelayed(2.0f, "make_uber_blizzard");
			UseTrigger("make_ice");
			InfoMessage("all", "The Bear God of the Frozen Tundra", "Has appeared...");
		}

		if (BEAR_TYPE == 2)
		{
			SetName("Bear God of the Thundering Plains");
			SetDamageTaken("lightning", 0);
			SetDamageTaken("poison", 1.25f);
			SetModelBody(0, 1);
			CallExternal("players", "ext_weather_change", "rain_storm");
			CallEventDelayed(10.0f, "make_storm_bolt");
			UseTrigger("make_plains");
			InfoMessage("all", "The Bear God of the Thundering Plains", "Has appeared...");
		}

		if (BEAR_TYPE == 3)
		{
			SetName("Bear God of the Black Forest");
			SetDamageTaken("poison", 0);
			SetDamageTaken("holy", 1);
			SetModelBody(0, 2);
			SetGlobal("G_WEATHER_LOCK", "fog_black");
			CallExternal("players", "ext_weather_change", GetVar("G_WEATHER_LOCK"));

			CallEventDelayed(10.0f, "make_dewm_tree");
			UseTrigger("make_trees");
			InfoMessage("all", "The Bear God of the Black Forest", "Has appeared...");
		}

		SetInvincible(false);
	}

	// intro_loop
	void BearGodRandom_OnIntroLoop()
	{
		if (!IN_INTRO)
			return;
		AS_ATTACKING = 20.0f;
		SUSPEND_AI = true;
		SetAngle("face", Vector3(0, INTRO_YAW, 0));
		PlayAnim("once", ANIM_INTRO);
		SetIdleAnim(ANIM_INTRO);
		SetMoveAnim(ANIM_INTRO);
		CallEventDelayed(0.1f, "intro_loop");
	}

	// intro_down
	void BearGodRandom_OnIntroDown()
	{
		AS_ATTACKING = 20.0f;
		SetAngle("face", Vector3(0, INTRO_YAW, 0));
		ANIM_INTRO = "attack";
	}

	// end_intro
	void BearGodRandom_OnEndIntro()
	{
		SetAngle("face", Vector3(0, INTRO_YAW, 0));
		IN_INTRO = false;
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		OnNpcatkResumeAi();
		Vector3 firstDest = MyOrigin();
		FIRST_TEST += RelativePosition(Vector3(0, INTRO_YAW, 0), Vector3(0, 1024, 0));
		SetMoveDest(FIRST_TEST, MOVE_RANGE);
	}

	// npc_post_spawn
	void BearGodRandom_OnNpcPostSpawn()
	{
		SetAngle("face", Vector3(0, INTRO_YAW, 0));
		ATTACK_RANGE = 250.0f;
		ATTACK_HITRANGE = 275.0f;
		ATTACK_MOVERANGE = 200.0f;
	}

	// make_uber_blizzard
	void BearGodRandom_OnMakeUberBlizzard()
	{
		if (!Truthy(Eval("game.monster.isalive")))
			return;
		CreateNpc("monsters/summon/uber_blizzard", RelativePosition(Vector3(0, 0, 0)), self, DMG_STORM, STORM_DUR, STORM_RAD, "30%");
		float refreshBliz = STORM_DUR + 5.0f;
		CallEventDelayed(refreshBliz, "make_uber_blizzard");
	}

	// bear_stomp
	void BearGodRandom_OnBearStomp()
	{
		if (STOMP_DELAY)
			return;
		STOMP_DELAY = true;
		CallEventDelayed(FREQ_STOMP, "bg_reset_stomp_delay");
		CallEventDelayed(0.5f, "repulse_stomp");
	}

	// repulse_stomp
	void BearGodRandom_OnRepulseStomp()
	{
		CreateNpc("monsters/summon/stun_burst", RelativePosition(Vector3(0, 0, 0)), self, 512, 0, SMASH_DAMAGE);
	}

	// bg_reset_stomp_delay
	void BearGodRandom_OnBgResetStompDelay()
	{
		STOMP_DELAY = false;
	}

	// bear_shake
	void BearGodRandom_OnBearShake()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 380, 20, 1, 512);
		PlaySound(1, 10, SOUND_GETDOWN);
	}

	// bear_walkeffect
	void BearGodRandom_OnBearWalkeffect()
	{
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 256, 10, 1, 256);
		PlayRandomSound(1, SOUND_UPSTEP1, SOUND_UPSTEP2);
	}

	// frame_attack1
	void BearGodRandom_OnFrameAttack1()
	{
		PlayRandomSound(Int(Eval("game.sound.weapon")), BEAR_VOLUME, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3); // Attack grunts

		BEAR_ISSTOMPATK = false;
		// I r effing huge thus I need to reach over (read: through) allies to hit opponents'
		// so I do direct damage
		if (!(RangeTo(HUNT_LASTTARGET) < ATTACK_HITRANGE))
			return;
		DoDamage(ENT_LASTSEEN, "direct", ATTACK_DAMAGE, ATTACK_HITCHANCE);
	}

	// npc_selectattack
	void BearGodRandom_OnNpcSelectattack()
	{
		if (BG_STAND_DELAY)
			return;
		BG_STAND_DELAY = true;
		CallEventOrDelay(FREQ_STAND, "bg_reset_stand_delay");
		OnBearStandup();
	}

	// bg_reset_stand_delay
	void BearGodRandom_OnBgResetStandDelay()
	{
		BG_STAND_DELAY = false;
	}

	// game_damaged_other
	string BearGodRandom_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		// <insanity>
		bool shouldPushEntity = true;
		if (BEAR_ISSTOMPATK)
		{
			// Let player jump to avoid stomp damage
			if (!IsOnGround(ENT_LASTSTRUCKBYME))
			{
				shouldPushEntity = false;
				SetVar(Eval("game.monster.canceldamage"), 1);
			}
		}

		if (!shouldPushEntity)
			return result;

		int forwardpush = 190;
		float sidepush = Random(-60, 0);
		int uppush = 10;
		if (BEAR_ISDEAD)
		{
			forwardpush = 100;
			sidepush = 0.0f;
			uppush = 200;
		}

		if (!BG_PUSH_ATK)
			return result;
		AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(sidepush, forwardpush, uppush))); // Push the player a bit
		BG_PUSH_ATK = false;
		return result;
	}

	// frame_attack1
	void BearGodRandom_OnFrameAttack1_2()
	{
		BG_PUSH_ATK = true;
	}

	// bear_stomp
	void BearGodRandom_OnBearStomp_2()
	{
		BG_PUSH_ATK = true;
	}

	// npc_death
	void BearGodRandom_OnNpcDeath()
	{
		SetGlobal("G_WEATHER_LOCK", 0);

		if (ToLowerCase(MapName()) == "tundra" && Float(Eval("game.players.totalhp")) < 2000.0f)
			UseTrigger("mm_early_release");

		if (ToLowerCase(MapName()) == "skycastle")
		{
			CallExternal("players", "ext_clear_valid_gauntlets");
			CallExternal("players", "ext_play_music", ENT_ME, "Nashalrath.mp3");
		}

		CallExternal("players", "ext_weather_change", "clear");
		CallExternal(GetVar("GAME_MASTER"), "gm_bear_god_death");
	}

	// make_storm_bolt
	void BearGodRandom_OnMakeStormBolt()
	{
		CallEventOrDelay(FREQ_BOLT, "make_storm_bolt");
		FOUND_TARGET = false;
		OnPickPlayerInrange(2048);
		if (FOUND_TARGET)
			OnMakeStormBolt2();
	}

	// make_storm_bolt2
	void BearGodRandom_OnMakeStormBolt2()
	{
		// dbg selected $get(P_TARGET,name) as target ( RND_TARGET of N_TARGETS [ BG_LPLAYERS ] )
		Vector3 pOrg = OriginOf(P_TARGET);
		pOrg.z = GroundHeight(pOrg);
		CreateNpc("monsters/summon/shock_beam", pOrg, self, 128, 7.0f, 40, Vector3(255, 255, 0), 2.0f);
	}

	// pick_player_inrange
	// PARAM1=range
	void BearGodRandom_OnPickPlayerInrange(int range = 0)
	{
		SetVar("BG_LPLAYERS", GetActivePlayers());
		int nTargets = GetTokenCount("BG_LPLAYERS");
		BG_LOOP_COUNT = 0.0f;
		BG_RANGE = range;
		BG_LPLAYERS_INRANGE = "";
		for (int i = 0; i < nTargets; i++)
		{
			loopIteration = i;
			OnFilterRangeLoop();
		}

		// dbg temp targets in range returned BG_LPLAYERS_INRANGE amongst BG_LPLAYERS
		nTargets = GetTokenCount(BG_LPLAYERS_INRANGE);
		float rndTarget = RandomInt(1, nTargets) - 1.0f; // token strings enumberate from 0
		@P_TARGET = FindPlayer(GetToken("BG_LPLAYERS", int(rndTarget)));
		if (IsAlive(P_TARGET))
			FOUND_TARGET = true;
	}

	// filter_range_loop
	void BearGodRandom_OnFilterRangeLoop()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("BG_LPLAYERS", int(BG_LOOP_COUNT)));
		BG_LOOP_COUNT += 1.0f;
		if (RangeTo(curPlayer) <= BG_RANGE)
			BG_LPLAYERS_INRANGE = TokenAdd(BG_LPLAYERS_INRANGE, EntityId(curPlayer));
	}

	// make_dewm_tree
	void BearGodRandom_OnMakeDewmTree()
	{
		CallEventOrDelay(FREQ_TREE, "make_dewm_tree");

		if (!(N_TREES < 3.0f))
			return;
		FOUND_TARGET = false;
		OnPickPlayerInrange(2048);
		if (!FOUND_TARGET)
			return;
		Vector3 pOrg = OriginOf(P_TARGET);
		CreateNpc("monsters/summon/doom_plant", pOrg, self, 20);
		N_TREES += 1.0f;
	}

	// plant_died
	void BearGodRandom_OnPlantDied()
	{
		N_TREES -= 1.0f;
	}

	// npc_monster_stuck
	void BearGodRandom_OnNpcMonsterStuck()
	{
		// black bear god has a habbit of getting stuck in his shrubbery
		if (!(STUCK_COUNT > 2.0f))
			return;
		CallExternal("all", "master_stuck");
	}

	// worldevent_time
	void BearGodRandom_OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0)
	{
		// reset blackness on hour advance
		if (BEAR_TYPE != 3)
			return;
		CallEventDelayed(0.1f, "re_black");
	}

	// re_black
	void BearGodRandom_OnReBlack()
	{
		CallExternal("all", "game_playercmd_setweather", "fog_black", 1, 1);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { BearGodRandom_OnGamePrecache(); } // game_precache

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BearBaseGiant_OnNpcPostSpawn(); // monsters/bear_base_giant
		BearGodRandom_OnNpcPostSpawn();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		BearBase_OnNpcSpawn(npc); // monsters/bear_base
		BearBaseGiant_OnNpcSpawn(npc); // monsters/bear_base_giant
		BearGodRandom_OnNpcSpawn(npc);
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		BearGodRandom_OnNpcSelectattack();
	}

	// npc_death
	void OnNpcDeath()
	{
		BearBaseGiant_OnNpcDeath(); // monsters/bear_base_giant
		BearGodRandom_OnNpcDeath();
	}

	// bear_stomp
	void OnBearStomp()
	{
		BearBaseGiant_OnBearStomp(); // monsters/bear_base_giant
		BearGodRandom_OnBearStomp();
		BearGodRandom_OnBearStomp_2();
	}

	void OnSelectBearType() { BearGodRandom_OnSelectBearType(); } // select_bear_type
	void OnIntroLoop() { BearGodRandom_OnIntroLoop(); } // intro_loop
	void OnIntroDown() { BearGodRandom_OnIntroDown(); } // intro_down
	void OnEndIntro() { BearGodRandom_OnEndIntro(); } // end_intro
	void OnMakeUberBlizzard() { BearGodRandom_OnMakeUberBlizzard(); } // make_uber_blizzard
	void OnRepulseStomp() { BearGodRandom_OnRepulseStomp(); } // repulse_stomp
	void OnBgResetStompDelay() { BearGodRandom_OnBgResetStompDelay(); } // bg_reset_stomp_delay
	void OnBearShake() { BearGodRandom_OnBearShake(); } // bear_shake
	void OnBearWalkeffect() { BearGodRandom_OnBearWalkeffect(); } // bear_walkeffect

	// frame_attack1
	void OnFrameAttack1()
	{
		BearGodRandom_OnFrameAttack1();
		BearGodRandom_OnFrameAttack1_2();
	}

	void OnBgResetStandDelay() { BearGodRandom_OnBgResetStandDelay(); } // bg_reset_stand_delay
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return BearGodRandom_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	void OnMakeStormBolt() { BearGodRandom_OnMakeStormBolt(); } // make_storm_bolt
	void OnMakeStormBolt2() { BearGodRandom_OnMakeStormBolt2(); } // make_storm_bolt2
	void OnPickPlayerInrange(int range = 0) { BearGodRandom_OnPickPlayerInrange(range); } // pick_player_inrange
	void OnFilterRangeLoop() { BearGodRandom_OnFilterRangeLoop(); } // filter_range_loop
	void OnMakeDewmTree() { BearGodRandom_OnMakeDewmTree(); } // make_dewm_tree
	void OnPlantDied() { BearGodRandom_OnPlantDied(); } // plant_died
	void OnNpcMonsterStuck() { BearGodRandom_OnNpcMonsterStuck(); } // npc_monster_stuck
	void OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0) { BearGodRandom_OnWorldeventTime(hour, minute, timeRatio); } // worldevent_time
	void OnReBlack() { BearGodRandom_OnReBlack(); } // re_black
	void OnFreqBolt() {} // FREQ_BOLT
	void OnFreqStand() {} // FREQ_STAND
	void OnFreqStomp() {} // FREQ_STOMP
	void OnFreqTree() {} // FREQ_TREE
	void OnRefreshBliz() {} // REFRESH_BLIZ

	// This file's events and timers by their .script names
	bool BearGodRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bear_shake") { OnBearShake(); return true; }
		if (name == "bear_stomp") { OnBearStomp(); return true; }
		if (name == "bear_walkeffect") { OnBearWalkeffect(); return true; }
		if (name == "bg_reset_stand_delay") { OnBgResetStandDelay(); return true; }
		if (name == "bg_reset_stomp_delay") { OnBgResetStompDelay(); return true; }
		if (name == "end_intro") { OnEndIntro(); return true; }
		if (name == "filter_range_loop") { OnFilterRangeLoop(); return true; }
		if (name == "frame_attack1") { OnFrameAttack1(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "intro_down") { OnIntroDown(); return true; }
		if (name == "intro_loop") { OnIntroLoop(); return true; }
		if (name == "make_dewm_tree") { OnMakeDewmTree(); return true; }
		if (name == "make_storm_bolt") { OnMakeStormBolt(); return true; }
		if (name == "make_storm_bolt2") { OnMakeStormBolt2(); return true; }
		if (name == "make_uber_blizzard") { OnMakeUberBlizzard(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_monster_stuck") { OnNpcMonsterStuck(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "pick_player_inrange") { OnPickPlayerInrange(Int(Param(params, 0))); return true; }
		if (name == "plant_died") { OnPlantDied(); return true; }
		if (name == "re_black") { OnReBlack(); return true; }
		if (name == "repulse_stomp") { OnRepulseStomp(); return true; }
		if (name == "select_bear_type") { OnSelectBearType(); return true; }
		if (name == "worldevent_time") { OnWorldeventTime(Float(Param(params, 0)), Float(Param(params, 1)), Int(Param(params, 2))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/bear_god_random"]
shared class BearGodRandomScript : BearBaseGiantScript, BearGodRandom
{
	// Variables every script that includes this file declares
	bool OVERRIDE_BEAR = false;

	// Variables declared by included files, with the value they start with in this script
	BearGodRandomScript()
	{
		NPC_BOSS_REGEN_RATE = 0.05f;
		NPC_BOSS_RESTORATION = 0.25f;
		NPC_BASE_EXP = "4000";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ATTACK_STOMPRANGE = 512;
		ATTACK_NORMAL_DAMAGE = "$rand(40,80)";
		ATTACK_STANDING_DAMAGE = "$rand(40,58)";
		ATTACK_STOMPDMG = 50;
		ATTACK_HITCHANCE = "70%";
		SOUND_ATTACK1 = "monsters/bear/giantbearattack.wav";
		SOUND_STRUCK4 = "monsters/bear/giantbearpain.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/dewm_shrub.mdl");
		Precache("monsters/dewm_bush.mdl");
		Precache("monsters/dewm_tree.mdl");
		Precache("cactusgibs.mdl");
		Precache("monsters/giant_bear.mdl");
		Precache("monsters/bear_huge.mdl");
		CallEventDelayed(3.0f, "BearBaseGiant_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGodRandom_FirstThink();
		BearBaseGiant_FirstThink();
		BearBase_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BearGodRandom_DispatchEvent(name, params)
			|| BearBaseGiantScript::DispatchEvent(name, params);
	}
}
