#pragma context server

// Converted from game_master.script by msc_transpiler.
// Thothie - this script does what sv_world is supposed to do

#include "runtime/ScriptEntity.as"
// #include test_scripts/game_master - not found (optional)
#include "converted/developer/game_master.as"
// #include $currentmap_game_master - not found (optional)
#include "converted/game_master/dmgpoints.as"
#include "converted/game_master/map_transitions.as"
#include "converted/game_master/vote_generic.as"
#include "converted/dq/externals/dq_game_master.as"

[script "game_master"]
class GameMaster : VoteGenericScript, DeveloperGameMaster, HelenaGameMaster, OldHelenaGameMaster, GameMasterDmgpoints, MapTransitions, DqGameMaster
{
	// Variables declared by included files, with the value they start with in this script
	GameMaster()
	{
		MAGIC_HAND_NAMES1 = "Acidic Bolt;Blizzard;Glow;Rejuvenate;Fire Ball;Fire Dart;Fire Wall;Frost Bolt;Healing Circle;Ice Blast;Ice Shield;";
		MAGIC_HAND_NAMES2 = "Lesser Ice Shield;Ice Wall;Chain Lighting;Lightning Storm;Erratic Lightning;Poison Dart;Poison Cloud;Summon Fangtooth;Summon Guardian;Summon Rat;";
		MAGIC_HAND_NAMES3 = "Summon Undead;Rebuke Undead;Volcano;Healing Wave;Summon Bear;";
		CONST_SPAWNS_PER_SET = 8;
		LIGHTSYS_N_LIGHTS = 16;
	}

	// unnamed block (first think)
	void GameMaster_FirstThink()
	{
		MAGIC_HAND_SCRIPTS1 = "magic_hand_acid_bolt;magic_hand_blizzard;magic_hand_div_glow;magic_hand_div_rejuvenate;magic_hand_fire_ball;magic_hand_fire_dart;magic_hand_fire_wall;magic_hand_frost_bolt;magic_hand_healing_circle;magic_hand_ice_blast;magic_hand_ice_shield;";
		MAGIC_HAND_SCRIPTS2 = "magic_hand_ice_shield_lesser;magic_hand_ice_wall;magic_hand_lightning_chain;magic_hand_lightning_storm;magic_hand_lightning_weak;magic_hand_poison;magic_hand_poison_cloud;magic_hand_summon_fangtooth;magic_hand_summon_guard;magic_hand_summon_rat;";
		MAGIC_HAND_SCRIPTS3 = "magic_hand_summon_undead;magic_hand_turn_undead;magic_hand_volcano;magic_hand_healing_wave;magic_hand_summon_bear1;";

		// const SND_COUNT_DOWN "vox/ten.wav;vox/nine.wav;vox/eight.wav;vox/seven.wav;vox/six.wav;vox/five.wav;vox/four.wav;vox/three.wav;vox/two.wav;vox/one.wav;vox/zero.wav;"
		N_MALDORAS = 0.0f;
		MALDORA_LIST = "";
		DEMON_RAGE_USERS = "";
		DEMON_RAGE_USES = "";
		ArrayCreate("ARRAY_LIGHT_OWNERLIST");
		ArrayCreate("ARRAY_LIGHT_COLOR");
		ArrayCreate("ARRAY_LIGHT_RAD");
		int count = LIGHTSYS_N_LIGHTS;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnInitLights();
		}
	}

	// init_lights
	void OnInitLights()
	{
		ArrayAdd("ARRAY_LIGHT_OWNERLIST", loopIteration);
		ArrayAdd("ARRAY_LIGHT_COLOR", -1);
		ArrayAdd("ARRAY_LIGHT_RAD", -1);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		HelenaGameMaster_OnGameSpawn(playerRace, playerGender); // helena/game_master
		GameMasterDmgpoints_OnGameSpawn(playerRace, playerGender); // game_master/dmgpoints
		SetName("The Game Master");
		SetHealth(1);
		LegacyCommand("invisible", 1);
		SetInvincible(true);
		LegacyCommand("blind", 1);
		SetRace("hated");
		SetWidth(32);
		SetHeight(32);
		SetGravity(0); // JUN2010_15

		SetSayTextRange(64000); // we're at @-20000 so...

		DebugPrint("***************** Game_Master - Spawned");

		// old damage point system, no longer in use
		// array.create ARRAY_PLAYER_IDS
		// array.create ARRAY_PLAYER_SCORES
		// array.create ARRAY_PLAYER_ENTS
		ServerCommand("echo Game Master Spawned");

		PLAYING_DEAD = "1";
		SetGlobal("GAME_MASTER", self);

		G_NGAME_MASTERS += 1.0f;

		if (G_NGAME_MASTERS > 1.0f)
			LegacyCommand("errormessage", "Multiple", "Game", "Masters!", NameOf(ENT_CREATIONOWNER));

		SetUniqueName("game_master");

		// dbg Game Master Spawned id GAME_MASTER
		// setup spawn time by system clock
		TRIGGER_COUNT = 0.0f;

		SPAWN_TIME = Eval("game.time.since.minutes");

		if (Truthy(Eval("game.cvar.ms_chatlog")))
		{
			ChatLog(" ");
			ChatLog("================================================================");
			ChatLog("Server Init at: [ " + Timestamp() + " ] on " + ToLowerCase(MapName()));
			ChatLog("================================================================");
		}

		DEV_PLAYER = "";

		if (Truthy(Eval("game.central")) && Truthy(Eval("game.cvar.ms_dev_mode")))
			LegacyCommand("errormessage", "ms_dev_mode not allowed on [FN].");

		OnSetTime(12.0f, 1.0f); // ded servers have picked up a bug where time does not syc, causing "strobe" effect - hoping having the GM set it on spawn will fix

		// callevent set_chatlog_file
		CallEventDelayed(0.1f, "setup_gm");
		CallEventDelayed(1.0f, "gm_setup_weather");
		CallEventDelayed(60.0f, "time_sync_check");
	}

	// game_menu_getoptions
	void OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		VoteGeneric_OnGameMenuGetoptions(player); // game_master/vote_generic
		int count;

		if (SPELL_ERASE)
		{
			@SPELL_CASTER = player;
			count = Int(GetProp(SPELL_CASTER, "spellslearned"));
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddSpellCallbacks();
			}
			SPELL_ERASE = false;
			bool exitSub = true;
		}
	}

	// game_menu_cancel
	void OnGameMenuCancel(CBasePlayer@ player = null)
	{
		VoteGeneric_OnGameMenuCancel(player); // game_master/vote_generic
		if (!FORGET_SPELL)
			return;
		SPELL_ERASE_CONFIRM = false;
		SPELL_ERASE = false;
		FORGET_SPELL = false;
	}

	// player_left
	void OnPlayerLeft(CBaseEntity@ player = null)
	{
		VoteGeneric_OnPlayerLeft(player); // game_master/vote_generic
		if (Truthy(Eval("game.cvar.ms_chatlog")))
			ChatLog(LegacyFunction("timestamp", ">") + " PLAYER_LEFT: " + NameOf(player) + " [ " + SteamIdOf(player) + " ] [ PlayerCountNow: " + PlayerCount() + " [ " + ActivePlayerCount() + " active ] ]");
	}

	// time_sync_check
	void OnTimeSyncCheck()
	{
		// scramble the global treasure lists ever few minutes to make them more "random"
		GM_SCRAMBLE_COUNT += 1.0f;
		if (GM_SCRAMBLE_COUNT > RandomInt(2, 5))
		{
			GM_SCRAMBLE_COUNT = 0.0f;
			OnGmScrambleTreasure();
		}

		CallEventDelayed(60.0f, "time_sync_check");
		G_MAP_UPTIME += 1.0f; // game master minute ticks (global initiated at map start)

		float curTicTime = G_MAP_UPTIME + Float(SPAWN_TIME);

		// local PRE_SUB CUR_TIC_TIME //debug
		curTicTime -= Float(Eval("game.time.since.minutes"));
	}

	// send_damage
	// same params as do damage
	void OnSendDamage(string target = "", string mode = "", string damage = "", string percent = "", string attacker = "", string effect = "", string flags = "")
	{
		DoDamage(target, mode, damage, percent, attacker, effect, flags);
	}

	// gold_spew
	// Spawn gold bag post-mortem -
	// PARAM1=gold_per_bag PARAM2=bags_player PARAM3=dist_from_mon PARAM4=min#bags PARAM5 max#bags
	void OnGoldSpew(string goldPerBag = "", string bagsPerPlayer = "", string distance = "", string minimumBags = "", string maximumBags = "", Vector3 position = Vector3())
	{
		GOLD_AMT = goldPerBag;
		BAGS_PER_PLAYER = Int(bagsPerPlayer);
		F_DIST = distance;
		string minBagsText = minimumBags;
		int minBags = Int(minBagsText);
		string maxBagsText = maximumBags;
		int maxBags = Int(maxBagsText);

		GOLD_POS = Text(position);

		if (minBagsText.isEmpty())
		{
			minBags = 1;
			minBagsText = Text(minBags);
		}
		if (maxBagsText.isEmpty())
		{
			maxBags = 99;
			maxBagsText = Text(maxBags);
		}
		if (F_DIST.isEmpty())
			F_DIST = "100";

		// incvar [ loc (878.41,3579.85,-395.97) ] Gld 50 BgsPP 2 dst 100 minbags 1 mxbags 30
		NUM_BAGS = ActivePlayerCount() * BAGS_PER_PLAYER;

		if (NUM_BAGS < minBags)
			NUM_BAGS = minBags;
		if (NUM_BAGS > maxBags)
			NUM_BAGS = maxBags;

		ROT_STEP_SIZE = Divide(359.0f, NUM_BAGS);

		ROT_STEP = 0.0f;

		BAG_COUNT = 0.0f;

		DebugPrint("gm_gold_spew ( " + goldPerBag + " " + bagsPerPlayer + " " + distance + " " + minimumBags + " " + maximumBags + " ) Gld " + GOLD_AMT + " BgsPP " + BAGS_PER_PLAYER + " dst " + F_DIST + " minbags " + minBagsText + " mxbags " + maxBagsText);

		CallEventDelayed(1.25f, "gold_spew_loop");
	}

	// gold_spew_loop
	void OnGoldSpewLoop()
	{
		BAG_COUNT += 1.0f;

		Vector3 tSpawn = Vec(GOLD_POS);
		tSpawn += RelativePosition(Vector3(0, ROT_STEP, 0), Vector3(0, Float(F_DIST), 40));
		OnMakeBag(Text(tSpawn), GOLD_AMT);

		DebugPrint("bag # " + Text(BAG_COUNT) + " of " + Text(NUM_BAGS) + " @ " + Text(tSpawn) + " amt " + GOLD_AMT);

		ROT_STEP += ROT_STEP_SIZE;

		if (BAG_COUNT < NUM_BAGS)
			CallEventDelayed(0.5f, "gold_spew_loop");
	}

	// make_bag
	void OnMakeBag(string spawnPosition = "", string goldAmount = "")
	{
		CreateNpc("chests/bag_o_gold_base", Vec(spawnPosition), goldAmount);
	}

	// gm_createnpc
	// ================ Post Mortem NPC Creation Management - Generic - BEGIN
	// - Spawning multiple monsters after death causes lag (such as the "splitting" the black slimes do)
	// - This cuts down on this
	// - These also allow creation of delayed effects post-mortem
	// - For instance, thunder-shock event timed delay with large monster falling over
	// - This handles up to 4 createnpc commands
	// - Format is same as createnpc, prefixed with desired delay
	// - eg: callexternal GAME_MASTER gm_createnpc 0.1 CHILD_SCRIPT $relpos(0,-20,0) CHILD_MOVE_DEST MY_KILLER
	void OnGmCreatenpc(float delay = 0.0f, string npcScript = "", Vector3 position = Vector3(), string ownerId = "", float value = 0.0f, float damageMulti = 0.0f, float healthMulti = 0.0f, string value2 = "", string value3 = "")
	{
		CNPCA_PAR1 = npcScript;
		CNPCA_PAR2 = position;
		CNPCA_PAR3 = ownerId;
		CNPCA_PAR4 = value;
		CNPCA_PAR5 = damageMulti;
		CNPCA_PAR6 = healthMulti;
		CNPCA_PAR7 = value2;
		CNPCA_PAR8 = value3;

		CallEventDelayed(delay, "gm_createnpc_delayed");
	}

	// gm_createnpc_delayed
	void OnGmCreatenpcDelayed()
	{
		// dbg createnpc1 CNPCA_PAR1 CNPCA_PAR2 CNPCA_PAR3 CNPCA_PAR4 CNPCA_PAR5 CNPCA_PAR6 CNPCA_PAR7 CNPCA_PAR8
		CreateNpc(CNPCA_PAR1, CNPCA_PAR2, CNPCA_PAR3, CNPCA_PAR4, CNPCA_PAR5, CNPCA_PAR6, CNPCA_PAR7, CNPCA_PAR8);
	}

	// gm_createnpc2
	void OnGmCreatenpc2(float delay = 0.0f, string childScript = "", string spawnOffset = "", string moveDest = "", CBaseEntity@ killerId = null, float damageMulti = 0.0f, float healthMulti = 0.0f, string value2 = "", string value3 = "")
	{
		CNPCB_PAR1 = childScript;
		CNPCB_PAR2 = spawnOffset;
		CNPCB_PAR3 = moveDest;
		@CNPCB_PAR4 = killerId;
		CNPCB_PAR5 = damageMulti;
		CNPCB_PAR6 = healthMulti;
		CNPCB_PAR7 = value2;
		CNPCB_PAR8 = value3;

		CallEventDelayed(delay, "gm_createnpc_delayed2");
	}

	// gm_createnpc_delayed2
	void OnGmCreatenpcDelayed2()
	{
		// dbg createnpc2 CNPCB_PAR1 CNPCB_PAR2 CNPCB_PAR3 CNPCB_PAR4 CNPCB_PAR5 CNPCB_PAR6 CNPCB_PAR7 CNPCB_PAR8
		CreateNpc(CNPCB_PAR1, Vec(CNPCB_PAR2), CNPCB_PAR3, @CNPCB_PAR4, CNPCB_PAR5, CNPCB_PAR6, CNPCB_PAR7, CNPCB_PAR8);
	}

	// gm_createnpc3
	void OnGmCreatenpc3(float delay = 0.0f, string childScript = "", string spawnOffset = "", string moveDest = "", CBaseEntity@ killerId = null, float damageMulti = 0.0f, float healthMulti = 0.0f, string value2 = "", string value3 = "")
	{
		CNPCC_PAR1 = childScript;
		CNPCC_PAR2 = spawnOffset;
		CNPCC_PAR3 = moveDest;
		@CNPCC_PAR4 = killerId;
		CNPCC_PAR5 = damageMulti;
		CNPCC_PAR6 = healthMulti;
		CNPCC_PAR7 = value2;
		CNPCC_PAR8 = value3;

		CallEventDelayed(delay, "gm_createnpc_delayed3");
	}

	// gm_createnpc_delayed3
	void OnGmCreatenpcDelayed3()
	{
		// dbg createnpc3 CNPCC_PAR1 CNPCC_PAR2 CNPCC_PAR3 CNPCC_PAR4 CNPCC_PAR5 CNPCC_PAR6 CNPCC_PAR7 CNPCC_PAR8
		CreateNpc(CNPCC_PAR1, Vec(CNPCC_PAR2), CNPCC_PAR3, @CNPCC_PAR4, CNPCC_PAR5, CNPCC_PAR6, CNPCC_PAR7, CNPCC_PAR8);
	}

	// gm_createnpc4
	void OnGmCreatenpc4(float delay = 0.0f, string childScript = "", Vector3 spawnOffset = Vector3(), string moveDest = "", CBaseEntity@ killerId = null, float damageMulti = 0.0f, float healthMulti = 0.0f, string value2 = "", string value3 = "")
	{
		CNPCD_PAR1 = childScript;
		CNPCD_PAR2 = spawnOffset;
		CNPCD_PAR3 = moveDest;
		@CNPCD_PAR4 = killerId;
		CNPCD_PAR5 = damageMulti;
		CNPCD_PAR6 = healthMulti;
		CNPCD_PAR7 = value2;
		CNPCD_PAR8 = value3;

		CallEventDelayed(delay, "gm_createnpc_delayed4");
	}

	// gm_createnpc_delayed4
	void OnGmCreatenpcDelayed4()
	{
		// dbg createnpc4 CNPCD_PAR1 CNPCD_PAR2 CNPCD_PAR3 CNPCD_PAR4 CNPCD_PAR5 CNPCD_PAR6 CNPCD_PAR7 CNPCD_PAR8
		CreateNpc(CNPCD_PAR1, CNPCD_PAR2, CNPCD_PAR3, @CNPCD_PAR4, CNPCD_PAR5, CNPCD_PAR6, CNPCD_PAR7, CNPCD_PAR8);
	}

	// gm_fade
	// ================ Post Mortem NPC Creation Management - Generic - END
	// <target> [rendermode]
	void OnGmFade(CBaseEntity@ target = null, string renderMode = "", string fadeAmount = "")
	{
		string rendMode;

		DebugPrint("gm_fade " + EntityId(target) + " " + renderMode + " " + fadeAmount);

		if (renderMode.isEmpty())
			rendMode = "5";
		else
			rendMode = renderMode;

		// make a target fade away - good for fading dead bodies, since they can't fade themselves
		if (Exists(FD_LOOP_TARG)) // in case already fading something, set the current target render to ziltch
			SetProp(FD_LOOP_TARG, "renderamt", 0);

		// SEP2009_9 - allow setting of fade start, to fade faster
		if (fadeAmount.isEmpty())
			FD_LOOP_AMT = 255.0f;
		else
			FD_LOOP_AMT = Float(fadeAmount);

		@FD_LOOP_TARG = target;
		SetProp(FD_LOOP_TARG, "rendermode", rendMode);

		OnGmFadeLoop();
	}

	// gm_fade_loop
	void OnGmFadeLoop()
	{
		FD_LOOP_AMT -= 5.0f;
		if (FD_LOOP_AMT >= 0.0f)
			SetProp(FD_LOOP_TARG, "renderamt", FD_LOOP_AMT);
		if (!(FD_LOOP_AMT > 0.0f))
			return;
		CallEventDelayed(0.1f, "gm_fade_loop");
	}

	// gm_say
	void OnGmSay(string message = "")
	{
		InfoMessage("all", "The Game Master Says...", message);
	}

	// gm_fade_in
	// <target> <rendermode>
	void OnGmFadeIn(CBaseEntity@ target = null, int renderMode = 0)
	{
		if (Exists(FD_LOOP_TARG)) // in case already fading something, finish manifesting him
			SetProp(FD_LOOP_TARG, "renderamt", 255);

		FD_LOOP_AMT = 0.0f;
		@FD_LOOP_TARG = target;
		SetProp(FD_LOOP_TARG, "rendermode", renderMode);
		OnGmFadeInLoop();
	}

	// gm_fade_in_loop
	void OnGmFadeInLoop()
	{
		FD_LOOP_AMT += 5.0f;
		if (FD_LOOP_AMT <= 255.0f)
		{
			SetProp(FD_LOOP_TARG, "renderamt", FD_LOOP_AMT);
			CallEventDelayed(0.1f, "gm_fade_in_loop");
		}
		if (FD_LOOP_AMT >= 255.0f)
			CallExternal(FD_LOOP_TARG, "fade_in_done");
	}

	// gm_worm_gold
	void OnGmWormGold(CBaseEntity@ worm = null, string itemName = "")
	{
		@WORM_ID = worm;
		WORM_GOLD = ActivePlayerCount() * 2.0f;
		WORM_COUNT = 0.0f;
		WORM_ITEM = itemName;
		CallEventDelayed(1.0f, "gm_worm_gold_loop");
	}

	// gm_worm_gold_loop
	void OnGmWormGoldLoop()
	{
		if (!(WORM_COUNT < WORM_GOLD))
			return;
		WORM_COUNT += 1.0f;
		CreateNpc(WORM_ITEM, OriginOf(WORM_ID));
		CallEventDelayed(0.5f, "gm_worm_gold_loop");
	}

	// worldevent_time
	void OnWorldeventTime(float hour = 0.0f, float minute = 0.0f, int timeRatio = 0)
	{
		string timeString = "mstime_" + Text(hour);
		UseTrigger(timeString, "hour_counter");

		OnGmSetupWeather();
	}

	// gm_set_weather
	// <weather_type> <lock:0|1> - from mstrig_weather
	void OnGmSetWeather(string weatherType = "", int lock = 0)
	{
		OnGameSetWeather(weatherType, lock);
	}

	// game_set_weather
	// <weather_type> <lock:0|1> - from mstrig_weather
	void OnGameSetWeather(string weatherType = "", float lock = 0.0f)
	{
		if (lock == 1.0f)
			SetGlobal("G_WEATHER_LOCK", weatherType);
		else
			SetGlobal("G_WEATHER_LOCK", 0);
		OnGmStartWeather(weatherType);
	}

	// gm_setup_weather
	void OnGmSetupWeather()
	{
		bool xmassWeather = false;
		if (GetVar("G_WEATHER_LOCK") == "G_WEATHER_LOCK")
			SetGlobal("G_WEATHER_LOCK", 0);

		if (GetVar("G_WEATHER_LOCK") != "0")
		{
			SetGlobal("G_CURRENT_WEATHER", GetVar("G_WEATHER_LOCK"));
			DebugPrint("gm_setup_weather sending lock " + GetVar("G_WEATHER_LOCK"));
			CallExternal("players", "ext_weather_change", GetVar("G_WEATHER_LOCK"));
		}

		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
		{
			string mapName = ToLowerCase(MapName());
			if (mapName == "edana")
				xmassWeather = true;
			if (mapName == "deralia")
				xmassWeather = true;
			if (mapName == "helena")
				xmassWeather = true;
			if (xmassWeather)
				SetGlobal("global.map.weather", "snow;snow;snow");
		}

		if (GetVar("G_WEATHER_LOCK") != "0")
			return;
		// (always true here) if TIME_HOUR isnot 6

		float nWeatherTypes = GetTokenCount(GetVar("global.map.weather")) - 1.0f;
		int rndWeather = RandomInt(0, int(nWeatherTypes));
		SetGlobal("G_CURRENT_WEATHER", GetToken(GetVar("global.map.weather"), rndWeather));
		DebugPrint("worldevent_time " + GetVar("G_CURRENT_WEATHER") + " ( " + rndWeather + " of " + GetVar("global.map.weather") + " [ " + GetToken(GetVar("global.map.weather"), rndWeather) + " ] )");
		OnGmStartWeather(GetVar("G_CURRENT_WEATHER"));
	}

	// gm_crit_npc_died
	// <NPC> <killedby>
	void OnGmCritNpcDied(CBaseEntity@ npc = null, CBaseEntity@ killerId = null)
	{
		// Critical NPC died, remove it from the global string
		// - cant be done from NPC, as is death event (script can't loop while dead)
		@NPC_DIED = npc;
		@BY_ID = killerId;
		int nNpcs = GetTokenCount(GetVar("G_CRITICAL_NPCS"));
		for (int i = 0; i < nNpcs; i++)
		{
			loopIteration = i;
			OnRemoveCritNpc();
		}
		CallEventDelayed(0.1f, "crit_count_remaining");
	}

	// remove_crit_npc
	void OnRemoveCritNpc()
	{
		CBaseEntity@ curNpc = FindEntity(GetToken(GetVar("G_CRITICAL_NPCS"), loopIteration));
		if (curNpc is NPC_DIED)
			LegacyCommand("token.del", "G_CRITICAL_NPCS", loopIteration);
	}

	// crit_count_remaining
	void OnCritCountRemaining()
	{
		int nNpcs = GetTokenCount(GetVar("G_CRITICAL_NPCS"));
		string nNpcsText = Text(nNpcs);
		if (nNpcs >= 0)
		{
			if (nNpcs > 1)
				nNpcsText += " Critical NPC's Remain!";
			if (nNpcs == 1)
			{
				nNpcsText = "Only One Critical NPC Remains!";
				nNpcs = 0;
			}
			if (nNpcs == 0)
				nNpcsText = "All Critical NPC's slain!";
			string msgReason = " ";
			if (IsPlayer(BY_ID))
				msgReason = NameOf(NPC_DIED) + " WAS SLAIN BY FRIELDY FIRE! ( " + NameOf(BY_ID) + " )!";
			InfoMessage("all", nNpcsText, msgReason);
		}
	}

	// gm_find_highest
	void OnGmFindHighest()
	{
		int curVoteIdx = loopIteration;
		string curVoteCountText = GetToken(VOTE_TALLY, curVoteIdx);
		int curVoteCount = Int(curVoteCountText);
		if (Float(VOTE_WINNAR_COUNT) < curVoteCount)
		{
			VOTE_WINNAR_IDX = curVoteIdx;
			VOTE_WINNAR_COUNT = curVoteCountText;
		}
	}

	// gm_dodamage
	void OnGmDodamage(string target = "", string damageMode = "", string damage = "", string damageType = "", string attacker = "", string damageKind = "", string flag = "", string reflector = "")
	{
		float timeDiff = GameTime() - 0.0f;
		if (timeDiff > 0.1f)
		{
			if (damageMode == "direct")
				DoDamage(target, damageMode, damage, damageType, attacker, damageKind, flag);
			if (damageKind == "reflective")
				DoDamage(target, damageMode, damage, damageType, attacker, damageKind, flag, reflector);
		}
	}

	// game_monsterspawn_removed
	void OnGameMonsterspawnRemoved(CBaseEntity@ spawner = null)
	{
		DebugPrint("game_monsterspawn_removed " + EntityId(spawner));
		CallExternal("all", "ext_monsterspawn_removed", @spawner);
	}

	// game_playerspeak
	// <player> <type> <text>
	void OnGamePlayerspeak(CBasePlayer@ player = null, int sayType = 0, string text = "")
	{
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			ConsoleMessage(player, "You said [ " + sayType + " ] " + text);

		if (!Truthy(Eval("game.cvar.ms_chatlog")))
			return;
		string writeLog = LegacyFunction("timestamp", ">") + " [" + SteamIdOf(player) + "] ";
		writeLog += NameOf(player) + "(" + sayType + "): " + text;
		ChatLog(writeLog);
	}

	// delay_changelevel
	// Uses var DEST_MAP to change level. Intended for delays
	void OnDelayChangelevel()
	{
		LegacyCommand("changelevel", DEST_MAP);
	}

	// gm_setname
	void OnGmSetname(string newName = "")
	{
		SetName(newName);
	}

	// forget_spell
	// ==================================== POTION OF FORGETFUNLESS - BEGIN
	// PARAM1=owner PARAM2=potion_ID
	void OnForgetSpell(CBaseEntity@ owner = null, CBaseEntity@ potionId = null)
	{
		FORGET_SPELL = true;
		PlayerMessageGreen(owner, "Please select a spell you would like to erase from memory.");
		InfoMessage(owner, "Potion of Forgetfulness", "Please select a spell you would like to erase from memory.");
		SPELL_ERASE = true;
		MENU_TARGET = EntityId(owner);
		@POTION_ID = potionId;

		SetName("Potion of Forgetfulness");
		CallEventDelayed(0.1f, "send_menu");
	}

	// add_spell_callbacks
	void OnAddSpellCallbacks()
	{
		string spellName = "L_SPELL_NAME";
		MenuItem menuItem;

		int curIdx = loopIteration;

		string spellScript = GetProp(SPELL_CASTER, "spellname", curIdx);

		// if ( G_DEVELOPER_MODE ) gplayermessage SPELL_CASTER Slot CUR_IDX is SPELL_SCRIPT
		int spellIdx = 0;
		int checkSet1 = -1;
		int checkSet2 = -1;
		int checkSet3 = -1;

		checkSet1 = FindToken(MAGIC_HAND_SCRIPTS1, spellScript);
		if (checkSet1 > -1)
		{
			spellName = GetToken(MAGIC_HAND_NAMES1, checkSet1);
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				spellIdx = 1;
		}

		checkSet2 = FindToken(MAGIC_HAND_SCRIPTS2, spellScript);
		if (checkSet2 > -1 && checkSet1 == -1)
		{
			spellName = GetToken(MAGIC_HAND_NAMES2, checkSet2);
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				spellIdx = 2;
		}

		checkSet3 = FindToken(MAGIC_HAND_SCRIPTS3, spellScript);
		if (checkSet3 > -1 && checkSet1 == -1 && checkSet2 == -1)
		{
			spellName = GetToken(MAGIC_HAND_NAMES3, checkSet3);
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				spellIdx = 3;
		}

		if (spellName == "L_SPELL_NAME")
		{
			spellName = spellScript;
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				ConsoleMessage(SPELL_CASTER, "was not found, using " + spellName);
		}

		// local reg.mitem.title $item_exists(SPELL_CASTER,SPELL_SCRIPT,name) //phayle, hence screwy crap above
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			ConsoleMessage(SPELL_CASTER, spellScript + " is " + spellName + " ( " + checkSet1 + " " + checkSet2 + " " + checkSet3 + " )");

		menuItem.title = spellName;
		menuItem.type = "callback";
		menuItem.callback = "confirm_forget_spell";
		menuItem.data = curIdx;
		RegisterMenuItem(menuItem);
	}

	// confirm_forget_spell
	void OnConfirmForgetSpell(CBasePlayer@ player = null, int spellIndex = 0)
	{
		string spellName = "L_SPELL_NAME";

		string spellScript = GetProp(player, "spellname", spellIndex);

		int checkSet1 = -1;
		int checkSet2 = -1;
		int checkSet3 = -1;

		// setvard SPELL_NAME $item_exists(PARAM1,SPELL_SCRIPT,name) //phayle, h4x follow:
		checkSet1 = FindToken(MAGIC_HAND_SCRIPTS1, spellScript);
		if (checkSet1 > -1)
			spellName = GetToken(MAGIC_HAND_NAMES1, checkSet1);

		checkSet2 = FindToken(MAGIC_HAND_SCRIPTS2, spellScript);
		if (checkSet2 > -1 && checkSet1 == -1)
			spellName = GetToken(MAGIC_HAND_NAMES2, checkSet2);

		checkSet3 = FindToken(MAGIC_HAND_SCRIPTS3, spellScript);
		if (checkSet3 > -1 && checkSet2 == -1)
			spellName = GetToken(MAGIC_HAND_NAMES3, checkSet3);

		if (spellName == "L_SPELL_NAME")
			spellName = spellScript;

		SPELL_NAME = spellName;

		// infomsg MENU_TARGET "Potion of Forgetfulness" "Are you sure you want to forget L_SPELL_NAME ?"
		SPELL_TO_FORGET_IDX = spellIndex;
		SPELL_ERASE_CONFIRM = true;
		SPELL_ERASE = false;
		MENU_TARGET = EntityId(player);
		OnEraseSpell(MENU_TARGET);
	}

	// send_menu
	void OnSendMenu()
	{
		OpenMenu(MENU_TARGET);
	}

	// erase_spell
	void OnEraseSpell(string target = "")
	{
		LegacyCommand("wipespell", target, SPELL_TO_FORGET_IDX);
		string outMsg = "You ";
		outMsg = outMsg + "have forgotten the spell " + SPELL_NAME;
		PlayerMessageGreen(MENU_TARGET, outMsg);
		InfoMessage(MENU_TARGET, "Potion of Forgetfulness", outMsg);
		SPELL_ERASE_CONFIRM = false;
		SPELL_ERASE = false;
		FORGET_SPELL = false;
		Effect("screenfade", MENU_TARGET, 0.1f, 3, Vector3(10, 10, 10), 255, "fadeout");
	}

	// gm_count_down
	// ==================================== POTION OF FORGETFUNLESS - END
	void OnGmCountDown()
	{
		if (!(GM_COUNT_DOWN_TO >= 0.0f))
			return;
		if (GM_COUNT_DOWN_TO <= 10.0f)
		{
			// precache these waves
			float waveStep = 10.0f - GM_COUNT_DOWN_TO;
			// callexternal players ext_playsound $get_token(SND_COUNT_DOWN,WAVE_STEP)
			MessageAll("green", Text(int(GM_COUNT_DOWN_TO)) + " " + GM_COUNT_MESSAGE);
		}
		if (GM_COUNT_DOWN_TO > 10.0f)
		{
			float divTen = 0.0f;
			divTen = Divide(divTen, 10.0f);
			if (divTen == int(0))
				MessageAll("green", Text(int(GM_COUNT_DOWN_TO)) + " " + GM_COUNT_MESSAGE);
		}
		if (GM_COUNT_DOWN_TO == 0.0f)
			CallEventOrDelay(GM_COUNT_DOWN_EVENT);
		if (!(GM_COUNT_DOWN_TO > 0.0f))
			return;
		GM_COUNT_DOWN_TO -= 1.0f;
		CallEventDelayed(1.0f, "gm_count_down");
	}

	// set_spawn_point
	void OnSetSpawnPoint(string spawnPosition = "")
	{
		float spawnsPerSet = CONST_SPAWNS_PER_SET;
		float nextSpawnSet = CONST_SPAWNS_PER_SET;

		if (N_SPAWN_POINTS == 0.0f)
		{
			SPAWN_POINTS1 = "";
			SPAWN_POINTS2 = "";
			SPAWN_POINTS3 = "";
			SPAWN_POINTS4 = "";
			SPAWN_POINTS5 = "";
			SPAWN_POINTS6 = "";
			SPAWN_POINTS7 = "";
			SPAWN_POINTS8 = "";
			SPAWN_POINTS9 = "";
		}

		ChatLog("DEV: Adding spawn point # " + Text(N_SPAWN_POINTS) + " @ " + spawnPosition);

		// SPAWNS_PER_SET 8
		// NEXT_SPAWN_SET 8
		if (N_SPAWN_POINTS <= spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS1 = TokenAdd(SPAWN_POINTS1, spawnPosition);

		nextSpawnSet += CONST_SPAWNS_PER_SET;
		// SPAWNS_PER_SET 8
		// NEXT_SPAWN_SET 16
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS2 = TokenAdd(SPAWN_POINTS2, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS3 = TokenAdd(SPAWN_POINTS3, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS4 = TokenAdd(SPAWN_POINTS4, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS5 = TokenAdd(SPAWN_POINTS5, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS6 = TokenAdd(SPAWN_POINTS6, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS7 = TokenAdd(SPAWN_POINTS7, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS8 = TokenAdd(SPAWN_POINTS8, spawnPosition);

		spawnsPerSet += CONST_SPAWNS_PER_SET;
		nextSpawnSet += CONST_SPAWNS_PER_SET;
		if (N_SPAWN_POINTS > spawnsPerSet && N_SPAWN_POINTS <= nextSpawnSet)
			SPAWN_POINTS9 = TokenAdd(SPAWN_POINTS9, spawnPosition);

		N_SPAWN_POINTS += 1.0f;
	}

	// find_spawn_point
	// PARAM1 = target
	void OnFindSpawnPoint(CBaseEntity@ target = null)
	{
		if (!(N_SPAWN_POINTS > 0.0f))
			return;

		float minusOne = N_SPAWN_POINTS - 1.0f;
		float rndPoint = RandomInt(0, int(minusOne));
		string oSpawnPoint = Text(rndPoint);
		float rndPointSetIdx = rndPoint;
		string rndPointSetIdxText;
		if (rndPoint > CONST_SPAWNS_PER_SET)
		{
			// RND_POINT 10 RND_POINT_SET_IDX 10
			rndPointSetIdx = Divide(rndPointSetIdx, CONST_SPAWNS_PER_SET); // RND_POINT 10 RND_POINT_SET_IDX 1.xx
			rndPointSetIdx = int(rndPointSetIdx); // RND_POINT 10 RND_POINT_SET_IDX 1
			rndPointSetIdxText = Text(rndPointSetIdx);
			float multiIdx = rndPointSetIdx; // MULTI 1
			multiIdx *= CONST_SPAWNS_PER_SET; // MULTI 8
			rndPoint -= multiIdx; // RND_POINT 2
			rndPoint -= 1.0f; // RND_POINT 1
		}
		else
		{
			rndPointSetIdx = 0.0f;
			rndPointSetIdxText = Text(rndPointSetIdx);
		}

		int spawnsPerSet = CONST_SPAWNS_PER_SET;
		if (rndPointSetIdx == 0.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS1, int(rndPoint));
		if (rndPointSetIdx == 1.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS2, int(rndPoint));
		if (rndPointSetIdx == 2.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS3, int(rndPoint));
		if (rndPointSetIdx == 3.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS4, int(rndPoint));
		if (rndPointSetIdx == 4.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS5, int(rndPoint));
		if (rndPointSetIdx == 5.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS6, int(rndPoint));
		if (rndPointSetIdx == 6.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS7, int(rndPoint));
		if (rndPointSetIdx == 7.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS8, int(rndPoint));
		if (rndPointSetIdx == 8.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS9, int(rndPoint));

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "find_spawn_point: " + GM_SPAWN_POINT + " ( pt# " + oSpawnPoint + " - idx# " + Text(rndPoint) + " of " + Text(N_SPAWN_POINTS) + " set " + rndPointSetIdxText + " )");

		CallExternal(target, "ext_send_tele_point", GM_SPAWN_POINT);
	}

	// dev_cat_points
	void OnDevCatPoints(string devId = "")
	{
		ChatLog("SPAWN_POINTS: " + Text(N_SPAWN_POINTS));
		ChatLog(SPAWN_POINTS1);
		ChatLog(SPAWN_POINTS2);
		ChatLog(SPAWN_POINTS3);
		ChatLog(SPAWN_POINTS4);

		DEV_ID = devId;
		MessageAll("green", "dev_cat_points to " + NameOf(DEV_ID));
		int count = int(N_SPAWN_POINTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDevCatPointLoop();
		}
	}

	// dev_cat_point_loop
	void OnDevCatPointLoop()
	{
		float rndPoint = loopIteration;
		string oSpawnPoint = Text(rndPoint);
		float rndPointSetIdx = rndPoint;
		string rndPointSetIdxText;
		if (rndPoint > CONST_SPAWNS_PER_SET)
		{
			// RND_POINT 8 RND_POINT_SET_IDX
			rndPointSetIdx = Divide(rndPointSetIdx, CONST_SPAWNS_PER_SET); // RND_POINT 10 RND_POINT_SET_IDX 1.xx
			rndPointSetIdx = int(rndPointSetIdx); // RND_POINT 10 RND_POINT_SET_IDX 1
			rndPointSetIdxText = Text(rndPointSetIdx);
			float multiIdx = rndPointSetIdx; // MULTI 1
			multiIdx *= CONST_SPAWNS_PER_SET; // MULTI 8
			rndPoint -= multiIdx; // RND_POINT 2
			rndPoint -= 1.0f; // RND_POINT 1
		}
		else
		{
			rndPointSetIdx = 0.0f;
			rndPointSetIdxText = Text(rndPointSetIdx);
		}

		if (rndPointSetIdx == 0.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS1, int(rndPoint));
		if (rndPointSetIdx == 1.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS2, int(rndPoint));
		if (rndPointSetIdx == 2.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS3, int(rndPoint));
		if (rndPointSetIdx == 3.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS4, int(rndPoint));
		if (rndPointSetIdx == 4.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS5, int(rndPoint));
		if (rndPointSetIdx == 5.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS6, int(rndPoint));
		if (rndPointSetIdx == 6.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS7, int(rndPoint));
		if (rndPointSetIdx == 7.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS8, int(rndPoint));
		if (rndPointSetIdx == 8.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS9, int(rndPoint));

		ConsoleMessage(DEV_ID, "pt# " + oSpawnPoint + " is idx# " + Text(rndPoint) + " of " + Text(N_SPAWN_POINTS) + " set " + rndPointSetIdxText + " = " + GM_SPAWN_POINT);
		MessageAll("green", "pt# " + oSpawnPoint + " is idx# " + Text(rndPoint) + " of " + Text(N_SPAWN_POINTS) + " set " + rndPointSetIdxText + " = " + GM_SPAWN_POINT);
	}

	// dev_test_spawn
	// { dev_cat_points_set //PARAM1=dev PARAM2=set
	// }
	// PARAM1 = target PARAM2=point#
	void OnDevTestSpawn(string target = "", float pointNumber = 0.0f)
	{
		if (!(N_SPAWN_POINTS > 0.0f))
			return;

		float rndPoint = pointNumber;
		string oSpawnPoint = Text(rndPoint);
		float rndPointSetIdx = rndPoint;
		string rndPointSetIdxText;
		if (rndPoint > CONST_SPAWNS_PER_SET)
		{
			// RND_POINT 10 RND_POINT_SET_IDX 10
			rndPointSetIdx = Divide(rndPointSetIdx, CONST_SPAWNS_PER_SET); // RND_POINT 10 RND_POINT_SET_IDX 1.xx
			rndPointSetIdx = int(rndPointSetIdx); // RND_POINT 10 RND_POINT_SET_IDX 1
			rndPointSetIdxText = Text(rndPointSetIdx);
			float multiIdx = rndPointSetIdx; // MULTI 1
			multiIdx *= CONST_SPAWNS_PER_SET; // MULTI 8
			rndPoint -= multiIdx; // RND_POINT 2
			rndPoint -= 1.0f; // RND_POINT 1
		}
		else
		{
			rndPointSetIdx = 0.0f;
			rndPointSetIdxText = Text(rndPointSetIdx);
		}

		int spawnsPerSet = CONST_SPAWNS_PER_SET;
		if (rndPointSetIdx == 0.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS1, int(rndPoint));
		if (rndPointSetIdx == 1.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS2, int(rndPoint));
		if (rndPointSetIdx == 2.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS3, int(rndPoint));
		if (rndPointSetIdx == 3.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS4, int(rndPoint));
		if (rndPointSetIdx == 4.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS5, int(rndPoint));
		if (rndPointSetIdx == 5.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS6, int(rndPoint));
		if (rndPointSetIdx == 6.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS7, int(rndPoint));
		if (rndPointSetIdx == 7.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS8, int(rndPoint));
		if (rndPointSetIdx == 8.0f)
			GM_SPAWN_POINT = GetToken(SPAWN_POINTS9, int(rndPoint));

		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			MessageAll("green", "find_spawn_point: " + GM_SPAWN_POINT + " ( pt# " + oSpawnPoint + " - idx# " + Text(rndPoint) + " of " + Text(N_SPAWN_POINTS) + " set " + rndPointSetIdxText + " )");

		CallExternal(target, "ext_send_tele_point", GM_SPAWN_POINT);
	}

	// gm_add_maldora_fragment
	void OnGmAddMaldoraFragment(CBaseEntity@ playerId = null)
	{
		N_MALDORAS += 1.0f;
		if (GM_MALDORA_LIST == "GM_MALDORA_LIST")
			GM_MALDORA_LIST = "";
		GM_MALDORA_LIST = TokenAdd(GM_MALDORA_LIST, EntityId(playerId));
	}

	// item_demon_rage
	// <item_id> <user_id> <max_uses>
	void OnItemDemonRage(CBaseEntity@ item = null, CBaseEntity@ player = null, int maximumUses = 0)
	{
		float curUses;
		string userId = SteamIdOf(player);

		int findUser = FindToken(DEMON_RAGE_USERS, userId);
		if (findUser > -1)
		{
			curUses = Float(GetToken(DEMON_RAGE_USES, findUser));
			curUses += 1.0f;
			DEMON_RAGE_USES = TokenSet(DEMON_RAGE_USES, findUser, Text(curUses));
		}
		else
		{
			DEMON_RAGE_USERS = TokenAdd(DEMON_RAGE_USERS, userId);
			DEMON_RAGE_USES = TokenAdd(DEMON_RAGE_USES, "1");
			curUses = 1.0f;
		}

		float remUses = maximumUses - curUses;
		string remUsesText = Text(remUses);

		DebugPrint("item_demon_rage " + EntityId(item) + " " + EntityId(player) + " " + maximumUses + " ( charges " + remUsesText + " / " + maximumUses + " )");

		if (curUses > maximumUses)
			CallExternal(item, "demon_rage_maxed");
		if (curUses <= maximumUses)
			CallExternal(item, "demon_rage", remUsesText);
	}

	// gm_boost
	// same params as addvelocity
	void OnGmBoost(string target = "", Vector3 velocity = Vector3(), string flag = "")
	{
		AddVelocity(target, velocity, flag);
	}

	// setup_gm
	void OnSetupGm()
	{
		SetGlobal("G_MAP_ADDPARAMS", 0);

		if (int(Eval("game.map.addparams").length()) > 1)
		{
			SetGlobal("G_MAP_ADDPARAMS", Eval("game.map.addparams"));
			if (Right(GetVar("G_MAP_ADDPARAMS"), 1) != ";")
				LegacyCommand("stradd", "G_MAP_ADDPARAMS", ";");
		}

		DebugPrint("setup_gm gotaddparams " + GetVar("G_MAP_ADDPARAMS"));

		// get spawn points
		// local SPAWN_POINTS
		// getspawnpoints SPAWN_POINTS
		// setvarg G_SPAWN_POINTS SPAWN_POINTS
		// map handlers
		if (StartsWith(ToLowerCase(MapName()), "m2_quest"))
			GM_HANDLE_ACTIVATES = true;

		// get admins
		SetGlobal("G_ADMIN_LIST", "");
		SetGlobal("G_ADMIN_AUTH", "");
		NO_ADMINS_FOUND = true;
		OnAdminLoadList();

		if (Float(Eval("game.time.month")) != 4.0f)
			return;
		if (Float(Eval("game.time.day")) != 1.0f)
			return;
		DebugPrint("Setup April Fools Mode (Delay)");
		CallEventDelayed(Random(10, 600), "gm_april_fools_mode");
	}

	// admin_load_list
	void OnAdminLoadList()
	{
		string inLine = LegacyFunction("get_fileline", "admins.txt");
		if (inLine == "[FILE_NOT_FOUND]")
			return;
		if (inLine == "[EOF]")
			return;
		string adminAuth = "standard_";
		bool skipLine = false;
		DebugPrint("reading,admins: " + inLine);
		if (Left(inLine, 5) != "STEAM")
			skipLine = true;
		if (!skipLine)
		{
			if (Contains(inLine, "rcon"))
				adminAuth += "cvar_rcon_";
			if (Contains(inLine, "cvar"))
				adminAuth += "cvar_";
			if (Contains(inLine, "all"))
				adminAuth = "standard_rcon_cvar_";
			bool adminIdStart = false;
			string parser = " ";
			int adminIdEnd = inLine.findFirst(parser);
			if (adminIdEnd == -1)
				adminIdEnd = int(inLine.length());
			string adminId = Left(inLine, adminIdEnd);
			// SEP2009 - This thing was writing to chatlog, regardless of ms_chatlog setting - fixed
			if (Truthy(Eval("game.cvar.ms_chatlog"))) {}

			LegacyCommand("token.add", "G_ADMIN_LIST", adminId);
			LegacyCommand("token.add", "G_ADMIN_AUTH", adminAuth);
			NO_ADMINS_FOUND = false;
		}
		CallEventDelayed(0.1f, "admin_load_list");
	}

	// set_wizard_center
	void OnSetWizardCenter(string center = "")
	{
		WIZARD_CENTER = center;
	}

	// set_shad_tele_point
	// <origin> <index> <trigger> (see mscave/shad_tele_base)
	void OnSetShadTelePoint(string origin = "", string index = "", string trigger = "")
	{
		if (SHAD_TELEPOINTS == "SHAD_TELEPOINTS")
			SHAD_TELEPOINTS = "1;2;3;4;5;6;7";
		if (SHAD_TRIGGERS == "SHAD_TRIGGERS")
			SHAD_TRIGGERS = "1;2;3;4;5;6;7";
		float pointIndex = Float(index);
		pointIndex -= 1.0f;
		DebugPrint("set_shad_tele_point " + Text(pointIndex) + " " + origin + " " + trigger);
		SHAD_TELEPOINTS = TokenSet(SHAD_TELEPOINTS, int(pointIndex), origin);
		SHAD_TRIGGERS = TokenSet(SHAD_TRIGGERS, int(pointIndex), trigger);
	}

	// give_item_idx
	// <targetidx> <item_string> [params]
	void OnGiveItemIdx(string targetIndex = "", string itemString = "", string offerParams = "")
	{
		OnGiveItem(ToPlayer(EntityOf(targetIndex)), itemString, offerParams);
	}

	// give_item
	// <target> <item_string> [params...]
	void OnGiveItem(CBasePlayer@ giver = null, string itemString = "", string offerParams = "")
	{
		// . eventgm give_item ME proj_arrow_jagged 15
		if (offerParams.isEmpty())
			Offer(giver, itemString);
		else
			Offer(giver, itemString, offerParams);
	}

	// gm_createitem
	// <delay> <item> <position> [reserve]
	void OnGmCreateitem(float delay = 0.0f, string item = "", Vector3 position = Vector3(), int reserve = 0)
	{
		if (MAKING_ITEM)
			InfoMessage("all", "ERROR", "Game failed to create an item due to script error.");
		if (MAKING_ITEM)
			return;
		ITEM_NAME = item;
		ITEM_POS = position;
		GM_ITEM_RESERVE = reserve != 0;
		MAKING_ITEM = true;
		CallEventDelayed(delay, "gm_createitem2");
	}

	// gm_createitem2
	void OnGmCreateitem2()
	{
		MAKING_ITEM = false;
		CreateItem(ITEM_NAME, ITEM_POS);
		if (GM_ITEM_RESERVE)
			CallExternal(ENT_LASTCREATED, "bitem_reserve_for_strongest");
	}

	// gm_hollow_one_died
	// FEB2009_19
	void OnGmHollowOneDied(Vector3 position = Vector3())
	{
		// slight delay to make sure all death events have time to process
		// and not unduely stress the server
		HOLLOW_ONE_POS = position;
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "kh_dragon_death", HOLLOW_ONE_POS);
		CallEventDelayed(1.0f, "gm_hollow_one_died2");
	}

	// gm_hollow_one_died2
	void OnGmHollowOneDied2()
	{
		OnGoldSpew("500", "2", "72", "4", "8", HOLLOW_ONE_POS);
	}

	// gm_set_sorc_point
	// <origin> - external from other/sorc_telepoint
	void OnGmSetSorcPoint(Vector3 origin = Vector3())
	{
		if (GetVar("G_SORC_TELE_POINTS") == "G_SORC_TELE_POINTS")
			SetGlobal("G_SORC_TELE_POINTS", 0);

		LegacyCommand("add", "G_SORC_TELE_POINTS", 1);

		if (SORC_TELE_SETS < 1)
		{
			SORC_TELE_SETS = 1;
			SORC_CUR_TELE_SET = 1;
			SORC_TELE_SET1 = "";
		}

		if (Float(GetVar("G_SORC_TELE_POINTS")) > 9.0f && SORC_TELE_SETS < 2)
		{
			SORC_TELE_SETS = 2;
			SORC_CUR_TELE_SET = 2;
			SORC_TELE_SET2 = "";
		}

		if (Float(GetVar("G_SORC_TELE_POINTS")) > 18.0f && SORC_TELE_SETS < 3)
		{
			SORC_TELE_SETS = 3;
			SORC_CUR_TELE_SET = 3;
			SORC_TELE_SET3 = "";
		}

		if (SORC_CUR_TELE_SET == 1)
			SORC_TELE_SET1 = TokenAdd(SORC_TELE_SET1, Text(origin));
		if (SORC_CUR_TELE_SET == 2)
			SORC_TELE_SET2 = TokenAdd(SORC_TELE_SET2, Text(origin));
		if (SORC_CUR_TELE_SET == 3)
			SORC_TELE_SET3 = TokenAdd(SORC_TELE_SET3, Text(origin));
	}

	// game_get_spawns
	void OnGameGetSpawns(string spawnPoints = "")
	{
		SetGlobal("G_SPAWN_POINTS", spawnPoints);
	}

	// give_item_delayed
	// JUN2010_13 - delayed item give (to give potion time to delete before granting new ability item)
	// <target> <item_name> <delay>
	void OnGiveItemDelayed(CBaseEntity@ target = null, string itemName = "", float delay = 0.0f)
	{
		@GM_ITEM_TARGET = target;
		GM_ITEM_NAME = itemName;
		CallEventDelayed(delay, "give_item_delayed2");
	}

	// give_item_delayed2
	void OnGiveItemDelayed2()
	{
		Offer(GM_ITEM_TARGET, GM_ITEM_NAME);
	}

	// gm_add_del_que
	// <id_to_add> [min_delay]
	void OnGmAddDelQue(string targetId = "", string delayBeforeFade = "")
	{
		// items/monsters added to this que will be deleted (via fade out) within 15 secs
		// useful for monsters with non-conventional deaths (such as those using base_flyer_grav)
		if (Contains(LegacyFunction("get_array", "ARRAY_GM_DEL_QUE"), "[ERROR_NO_ARRAY]"))
			ArrayCreate("ARRAY_GM_DEL_QUE");
		ArrayAdd("ARRAY_GM_DEL_QUE", targetId);

		if (GM_DEL_QUE_ACTIVE)
			return;
		GM_DEL_QUE_ACTIVE = true;

		string fadeDelay = delayBeforeFade;
		if (delayBeforeFade.isEmpty())
			fadeDelay = "15.0";

		CallEventOrDelay(fadeDelay, "gm_del_que_loop");
	}

	// gm_del_que_loop
	void OnGmDelQueLoop()
	{
		DebugPrint("gm_del_que_loop " + GetArrayCount("ARRAY_GM_DEL_QUE"));

		if (GetArrayCount("ARRAY_GM_DEL_QUE") > 0)
		{
			DeleteEntity(GetArray("ARRAY_GM_DEL_QUE", "0"), "fade");
			ArrayRemoveAt("ARRAY_GM_DEL_QUE", 0);
			CallEventDelayed(2.0f, "gm_del_que_loop");
		}
		else
		{
			GM_DEL_QUE_ACTIVE = false;
		}
	}

	// gm_vanish_que
	// <ent> <delay_till_vanish>
	void OnGmVanishQue(CBaseEntity@ targetId = null, float vanishDelay = 0.0f)
	{
		// items/monsters added to this que will be deleted (via fade out) within 15 secs
		// useful for monsters with non-conventional deaths (such as those using base_flyer_grav)
		if (Contains(LegacyFunction("get_array", "ARRAY_GM_VANISH_QUE"), "[ERROR_NO_ARRAY]"))
			ArrayCreate("ARRAY_GM_VANISH_QUE");
		ArrayAdd("ARRAY_GM_VANISH_QUE", @targetId);

		if (GM_VANISH_QUE_ACTIVE)
			return;
		GM_VANISH_QUE_ACTIVE = true;

		CallEventDelayed(vanishDelay, "gm_vanish_que_loop");
	}

	// gm_vanish_que_loop
	void OnGmVanishQueLoop()
	{
		DebugPrint("gm_vanish_que_loop " + GetArrayCount("ARRAY_GM_VANISH_QUE"));

		if (GetArrayCount("ARRAY_GM_VANISH_QUE") > 0)
		{
			SetProp(GetArray("ARRAY_GM_VANISH_QUE", "0"), "rendermode", 5);
			SetProp(GetArray("ARRAY_GM_VANISH_QUE", "0"), "renderamt", 0);
			ArrayRemoveAt("ARRAY_GM_VANISH_QUE", 0);
			CallEventDelayed(0.1f, "gm_vanish_que_loop");
		}
		else
		{
			GM_VANISH_QUE_ACTIVE = false;
		}
	}

	// gm_drop_item
	// <delay> <item_scriptname> <origin> [reserve_for_strongest:0|1]
	void OnGmDropItem(float delay = 0.0f, string itemScriptName = "", Vector3 origin = Vector3(), int reserveForStrongest = 0)
	{
		GM_ITEM_TO_GIVE = itemScriptName;
		GM_ITEM_ORIGIN = origin;
		GM_ITEM_RESERVE = reserveForStrongest != 0;
		CallEventDelayed(delay, "gm_drop_item2");
	}

	// gm_drop_item2
	void OnGmDropItem2()
	{
		CreateItem(GM_ITEM_TO_GIVE, GM_ITEM_ORIGIN);
		if (GM_ITEM_RESERVE)
			CallExternal(ENT_LASTCREATED, "bitem_reserve_for_strongest");
	}

	// gm_start_weather
	// <type>
	void OnGmStartWeather(string weatherType = "")
	{
		if (weatherType == "snow")
			SetGlobal("IS_SNOWING", 1);
		else
			SetGlobal("IS_SNOWING", 0);

		if (Contains(weatherType, "rain"))
			SetGlobal("IS_RAINING", 1);
		else
			SetGlobal("IS_RAINING", 0);

		string outTrig = "weatherchange_" + GetVar("G_CURRENT_WEATHER");
		UseTrigger(outTrig); // allow mappers to capture weather changes

		CallExternal("players", "ext_weather_change", GetVar("G_CURRENT_WEATHER"));
	}

	// gm_test_trig
	void OnGmTestTrig(string entity = "", string text = "", string text2 = "", string text3 = "", string text4 = "")
	{
		string outMsg = LegacyFunction("stradd", text, "|", text2, "|", text3, "|", text4);
		InfoMessage("all", NameOf(entity), outMsg);
	}

	// gm_trig_filter
	// <trigger_name> <tripper> <tokens>
	void OnGmTrigFilter(string triggerName = "", string tripper = "", string tokens = "")
	{
		// totalhp>
		// totalhp<
		// avghp>
		// avghp<
		// race=
		// isally
		// isenemy
		// nplayers=*
		// nplayers>*
		// nplayers<*
		GM_TRIG_TARGET = tripper;
		GM_TRIG_TOKENS = tokens;

		int nTokens = GetTokenCount(GM_TRIG_TOKENS);
		GM_TRIG_ACTIVATE = false;
		GM_RACE_ACTIVATE = false;
		GM_TRIG_HP_REQ = false;
		GM_TRIG_RACE_REQ = false;
		int count = Int(LegacyFunction("get_token", GM_TRIG_TOKENS));
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmTrigFilterCheck();
		}

		bool doTrigger = false;
		if (GM_RACE_ACTIVATE) // passed race test
			doTrigger = true;
		if (GM_TRIG_HP_REQ) // but also has hpreq
			doTrigger = false;
		if (GM_TRIG_ACTIVATE)
		{
			if (GM_TRIG_RACE_REQ)
			{
				if (GM_RACE_ACTIVATE) // passed both hpreq and race test
					doTrigger = true;
			}
			else
			{
				doTrigger = true; // passed hpreq, had no race test
			}
		}

		if (!doTrigger)
			return;
		UseTrigger(triggerName);
	}

	// gm_trig_filter_check
	void OnGmTrigFilterCheck()
	{
		float propLen = 0.0f;
		int propStr;
		string propStrText;
		string curToken = GetToken(GM_TRIG_TOKENS, loopIteration);
		int lenToken = int(curToken.length());
		if (StartsWith(curToken, "race="))
		{
			GM_TRIG_RACE_REQ = true;
			propLen = lenToken - 5.0f;
			propStrText = Right(curToken, int(propLen));
			if (RaceOf("GM_RACE_TARGET") == propStrText)
				GM_RACE_ACTIVATE = true;
			else
				GM_RACE_ACTIVATE = false;
		}
		if (StartsWith(curToken, "isally"))
		{
			GM_TRIG_RACE_REQ = true;
			if (RaceOf("GM_RACE_TARGET") == "human")
				GM_RACE_ACTIVATE = true;
			if (RaceOf("GM_RACE_TARGET") == "elf")
				GM_RACE_ACTIVATE = true;
			if (RaceOf("GM_RACE_TARGET") == "dwarf")
				GM_RACE_ACTIVATE = true;
			if (RaceOf("GM_RACE_TARGET") == "hguard")
				GM_RACE_ACTIVATE = true;
			if (IsPlayer("GM_RACE_TARGET"))
				GM_RACE_ACTIVATE = true;
		}
		if (StartsWith(curToken, "isenemy"))
		{
			GM_TRIG_RACE_REQ = true;
			GM_RACE_ACTIVATE = true;
			if (RaceOf("GM_RACE_TARGET") == "human")
				GM_RACE_ACTIVATE = false;
			if (RaceOf("GM_RACE_TARGET") == "elf")
				GM_RACE_ACTIVATE = false;
			if (RaceOf("GM_RACE_TARGET") == "dwarf")
				GM_RACE_ACTIVATE = false;
			if (RaceOf("GM_RACE_TARGET") == "hguard")
				GM_RACE_ACTIVATE = false;
			if (IsPlayer("GM_RACE_TARGET"))
				GM_RACE_ACTIVATE = false;
		}

		if (StartsWith(curToken, "totalhp>"))
		{
			GM_TRIG_HP_REQ = true;
			propLen = lenToken - 8.0f;
			propStrText = Right(curToken, int(propLen));
			propStr = Int(propStrText);
			if (Float(Eval("game.players.totalhp")) >= propStr)
				GM_TRIG_ACTIVATE = true;
			else
				GM_TRIG_ACTIVATE = false;
		}
		if (StartsWith(curToken, "totalhp<"))
		{
			GM_TRIG_HP_REQ = true;
			propLen = lenToken - 8.0f;
			propStrText = Right(curToken, int(propLen));
			propStr = Int(propStrText);
			if (Float(Eval("game.players.totalhp")) < propStr)
				GM_TRIG_ACTIVATE = true;
			else
				GM_TRIG_ACTIVATE = false;
		}
		if (StartsWith(curToken, "avghp<"))
		{
			GM_TRIG_HP_REQ = true;
			propLen = lenToken - 6.0f;
			propStrText = Right(curToken, int(propLen));
			propStr = Int(propStrText);
			if (Float(Eval("game.players.avghp")) >= propStr)
				GM_TRIG_ACTIVATE = true;
			else
				GM_TRIG_ACTIVATE = false;
		}
		if (StartsWith(curToken, "avghp>"))
		{
			GM_TRIG_HP_REQ = true;
			propLen = lenToken - 6.0f;
			propStrText = Right(curToken, int(propLen));
			propStr = Int(propStrText);
			if (Float(Eval("game.players.avghp")) < propStr)
				GM_TRIG_ACTIVATE = true;
			else
				GM_TRIG_ACTIVATE = false;
		}
	}

	// gm_april_fools_mode
	void OnGmAprilFoolsMode()
	{
		bool goodToGo = false;
		if (!Truthy(GetVar("G_DEVELOPER_MODE")) && Contains(Eval("game.cvar.hostname"), "RKS"))
			goodToGo = true;
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			goodToGo = true;
		if (!goodToGo)
			return;
		SetGlobal("G_APRIL_FOOLS_MODE", 1);
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			InfoMessage("all", "APRIL FOOLS MODE GO", "Checking april fool spawns");
	}

	// gm_april_fools_spawn_add
	// <location>
	void OnGmAprilFoolsSpawnAdd(Vector3 location = Vector3())
	{
		if (GM_APRIL_CHECKING)
			return;
		DebugPrint("gm_april_fools_spawn_add " + Text(location));
		GM_APRIL_SPAWN_POINT = location;
		GM_APRIL_CHECKING = true;
		CallEventDelayed(10.0f, "gm_april_fools_check_point");
	}

	// gm_april_fools_check_point
	void OnGmAprilFoolsCheckPoint()
	{
		bool exitSub = false;
		if (!GM_APRIL_CHECKING)
			return;
		GM_APRIL_CHECKING = false;
		if (PlayerCount() == 0)
			exitSub = true;
		if (exitSub)
			return;
		SetVar("APRIL_PLAYERS", GetActivePlayers());
		GM_APRIL_INVALIDATED = false;
		// make sure no players too close to desired spawn point
		// and last target is no longer on server
		int count = GetTokenCount("APRIL_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmAprilFoolsFilter();
		}
		if (GM_APRIL_INVALIDATED)
			return;
		SetGlobal("G_APRIL_FOOLS_MODE", 0);
		OnGmSpawnNewell();
	}

	// gm_spawn_newell
	void OnGmSpawnNewell()
	{
		DebugPrint("gm_spawn_newell");
		CreateNpc("monsters/gabe_newell", GM_APRIL_SPAWN_POINT);
	}

	// gm_april_fools_filter
	void OnGmAprilFoolsFilter()
	{
		CBasePlayer@ curPlayer = FindPlayer(GetToken("APRIL_PLAYERS", loopIteration));
		if (EntityId(curPlayer) == GetVar("G_LAST_GABE_TARGET"))
		{
			DebugPrint("gm_april_fools_filter - invalidated - last target still on server");
			SetGlobal("G_APRIL_FOOLS_MODE", 0);
			GM_APRIL_INVALIDATED = true;
		}

		Vector3 curOrg = OriginOf(curPlayer);
		if (Distance(curOrg, GM_APRIL_SPAWN_POINT) < 256.0f)
		{
			DebugPrint("gm_april_fools_filter - invalidated - too close, will check again");
			GM_APRIL_INVALIDATED = true;
		}
	}

	// gm_recieve_client_info
	void OnGmRecieveClientInfo(string clientInfo = "")
	{
		InfoMessage("all", "Returned", clientInfo);
		ConsoleMessage("GM_PLAYER_REQ", "CLIENT_INFO_RETURNED: " + clientInfo);
	}

	// gm_newweather_string
	void OnGmNewweatherString(string value = "", string weatherType = "", string value2 = "", string value3 = "", string value4 = "")
	{
		DebugPrint("got " + NameOf(value) + " " + weatherType + " " + value2 + " " + value3);

		GM_NEW_WEATHER = weatherType;
		SetGlobal("G_CURRENT_WEATHER", weatherType);

		string newWeatherStr = value + ";";

		bool addParam = true;
		if (weatherType.isEmpty())
			addParam = false;
		if (addParam)
			newWeatherStr = weatherType + ";";

		addParam = true;
		if (value2.isEmpty())
			addParam = false;
		if (addParam)
			newWeatherStr = value2 + ";";

		addParam = true;
		if (value3.isEmpty())
			addParam = false;
		if (addParam)
			newWeatherStr = value3 + ";";

		addParam = true;
		if (value4.isEmpty())
			addParam = false;
		if (addParam)
			newWeatherStr = value4 + ";";

		if (GetVar("G_CURRENT_WEATHER") != weatherType)
			OnGmStartWeather(GetVar("G_CURRENT_WEATHER"));

		SetGlobal("global.map.weather", newWeatherStr);
	}

	// reserve_test
	// <targ_player>
	void OnReserveTest(string targetPlayer = "")
	{
		// precachefile PARAM2
		Vector3 spawnPoint = OriginOf(targetPlayer);
		Vector3 myAngles = AnglesOf(targetPlayer);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 64, 0));
		CreateItem("smallarms_nh", spawnPoint);
		DebugPrint("reserve_test " + NameOf(ENT_LASTCREATED));
		CallExternal(ENT_LASTCREATED, "item_banked");
	}

	// gm_keldorn_troll
	void OnGmKeldornTroll(CBaseEntity@ player = null)
	{
		ClientEvent("update", player, Eval("const.localplayer.scriptID"), "cl_playsound", "voices/deralia/slinker2.wav");
		Offer(player, "scroll2_trollcano");
	}

	// gm_sxbow_swap
	void OnGmSxbowSwap(string receiver = "")
	{
		GM_SXBOW_RECIEVE = receiver;
		CallEventDelayed(1.0f, "gm_sxbow_swap2");
	}

	// gm_sxbow_swap2
	void OnGmSxbowSwap2()
	{
		Offer(GM_SXBOW_RECIEVE, "bows_sxbow");
	}

	// gm_epilepsy_begin
	void OnGmEpilepsyBegin()
	{
		CallExternal("players", "ext_epilepsy_time_begin");
	}

	// gm_epilepsy_end
	void OnGmEpilepsyEnd()
	{
		CallExternal("players", "ext_epilepsy_time_end");
	}

	// player_joined
	// <id> - called from player_main->activate_stuff
	void OnPlayerJoined(CBaseEntity@ player = null)
	{
		GM_HAD_PLAYER = true;
		OnGmLightsSync(Text(IndexOf(player)));
	}

	// gm_lights_sync
	// <owner_id>
	void OnGmLightsSync(string ownerId = "")
	{
		// new player joined, send him all current player lights
		DebugPrint("gm_lights_sync");
		int nLights = GetArrayCount("ARRAY_LIGHT_OWNERLIST");
		GM_LIGHT_PLAYER = Int(ownerId);
		if (!(nLights > 0))
			return;
		for (int i = 0; i < nLights; i++)
		{
			loopIteration = i;
			OnGmLightsSyncLoop();
		}
	}

	// gm_lights_sync_loop
	void OnGmLightsSyncLoop()
	{
		string curOwner = GetArray("ARRAY_LIGHT_OWNERLIST", Text(loopIteration));
		string curColor = GetArray("ARRAY_LIGHT_COLOR", Text(loopIteration));
		string curRad = GetArray("ARRAY_LIGHT_RAD", Text(loopIteration));
		DebugPrint("gm_lights_sync_loop sending " + curOwner + " " + curColor + " " + curRad);
		ClientEvent("update", Text(GM_LIGHT_PLAYER), Eval("const.localplayer.scriptID"), "cl_light_update", "new", curOwner, curColor, curRad);
	}

	// gm_dumplights
	void OnGmDumplights()
	{
		int count = LIGHTSYS_N_LIGHTS;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmDumplightsLoop();
		}
	}

	// gm_dumplights_loop
	void OnGmDumplightsLoop()
	{
		int curIdx = loopIteration;
		DebugPrint(Text(curIdx) + " " + GetArray("ARRAY_LIGHT_OWNERLIST", Text(curIdx)) + " " + GetArray("ARRAY_LIGHT_COLOR", Text(curIdx)) + " " + GetArray("ARRAY_LIGHT_RAD", Text(curIdx)));
	}

	// gm_light_update
	// <new|remove|update|clear> <owner_index> <color> <rad> [debug]
	void OnGmLightUpdate(string lightAction = "", int ownerIndex = 0, Vector3 lightColor = Vector3(), string radius = "")
	{
		DebugPrint("gm_light_update " + lightAction + " " + ownerIndex + " " + Text(lightColor) + " " + radius);

		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "cl_light_update", lightAction, ownerIndex, lightColor, radius);

		if (lightAction == "new")
		{
			// update and new are really the same now, due to AUG2013 changes, so far as the gm tracker is concerned
			ArraySet("ARRAY_LIGHT_COLOR", ownerIndex, lightColor);
			ArraySet("ARRAY_LIGHT_RAD", ownerIndex, radius);
		}

		// check if light owner already exists, if so, update instead
		// local L_FIND_IDX $get_arrayfind(ARRAY_LIGHT_OWNERLIST,L_OWNER)
		// if ( L_FIND_IDX > -1 )
		// {
		// local L_ACTION update
		// }
		// else
		// {
		// array.set ARRAY_LIGHT_COLOR L_OWNER L_COLOR
		// array.set ARRAY_LIGHT_RAD L_OWNER L_RAD
		// }
		if (lightAction == "update")
		{
			// local L_LIGHT_IDX $get_arrayfind(ARRAY_LIGHT_OWNERLIST,L_OWNER)
			ArraySet("ARRAY_LIGHT_COLOR", ownerIndex, lightColor);
			ArraySet("ARRAY_LIGHT_RAD", ownerIndex, radius);
		}

		if (lightAction == "remove")
		{
			// local L_LIGHT_IDX $get_arrayfind(ARRAY_LIGHT_OWNERLIST,L_OWNER)
			ArraySet("ARRAY_LIGHT_COLOR", ownerIndex, -1);
			ArraySet("ARRAY_LIGHT_RAD", ownerIndex, -1);
		}
	}

	// ext_activate_items
	// This is an m2_quest only function...
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		if (!GM_HANDLE_ACTIVATES)
			return;
		if (StartsWith(ToLowerCase(MapName()), "m2_quest"))
		{
			UseTrigger("global");
			GM_HANDLE_ACTIVATES = false;
		}
	}

	// gm_scramble_treasure
	void OnGmScrambleTreasure()
	{
		int count;
		LegacyCommand("token.scramble", "G_NOOB_ITEMS1");
		LegacyCommand("token.scramble", "G_NOOB_ITEMS2");
		LegacyCommand("token.scramble", "G_NOOB_ITEMS3");
		LegacyCommand("token.scramble", "G_NOOB_ITEMS4");
		LegacyCommand("token.scramble", "G_NOOB_ITEMS5");
		LegacyCommand("token.scramble", "G_NOOB_ITEMS6");
		LegacyCommand("token.scramble", "G_GOOD_ITEMS1");
		LegacyCommand("token.scramble", "G_GOOD_ITEMS2");
		LegacyCommand("token.scramble", "G_GOOD_ITEMS3");
		LegacyCommand("token.scramble", "G_GREAT_ITEMS1");
		LegacyCommand("token.scramble", "G_GREAT_ITEMS2");
		LegacyCommand("token.scramble", "G_GREAT_ITEMS3");
		LegacyCommand("token.scramble", "G_NOOB_ARROWS");
		LegacyCommand("token.scramble", "G_GOOD_ARROWS");
		LegacyCommand("token.scramble", "G_GREAT_ARROWS");
		LegacyCommand("token.scramble", "G_EPIC_ARROWS");

		GM_N_EPICS = GetGlobalArrayCount("G_ARRAY_EPIC");

		// initiate temp array to dump global treasure list into
		if (GetArrayCount("ARRAY_TEMP") == -1)
		{
			ArrayCreate("ARRAY_TEMP");
			count = GM_N_EPICS;
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnGmInitArrayTemp();
			}
		}

		// set random point to where to begin dump
		float nEpics = GM_N_EPICS - 1.0f;
		GM_TEMP_COUNT = RandomInt(0, int(nEpics));

		// dump global epic array into temp
		count = GM_N_EPICS;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmEpicToTempLoop();
		}

		// and back again
		count = GM_N_EPICS;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmTempToEpicLoop();
		}
	}

	// gm_init_array_temp
	void OnGmInitArrayTemp()
	{
		ArrayAdd("ARRAY_TEMP", 0);
	}

	// gm_epic_to_temp_loop
	void OnGmEpicToTempLoop()
	{
		int curEpic = loopIteration;
		ArraySet("ARRAY_TEMP", GM_TEMP_COUNT, GetGlobalArray("G_ARRAY_EPIC", Text(curEpic)));
		GM_TEMP_COUNT += 1.0f;
		if (GM_TEMP_COUNT >= GM_N_EPICS) // wrap around
			GM_TEMP_COUNT = 0.0f;
	}

	// gm_temp_to_epic_loop
	void OnGmTempToEpicLoop()
	{
		int curEpic = loopIteration;
		GlobalArraySet("G_ARRAY_EPIC", curEpic, GetArray("ARRAY_TEMP", Text(curEpic)));
	}

	// gm_dump_epics
	// debugary
	void OnGmDumpEpics()
	{
		int count = GetGlobalArrayCount("G_ARRAY_EPIC");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmDumpEpicsLoop();
		}
	}

	// gm_dump_epics_loop
	void OnGmDumpEpicsLoop()
	{
		int curEpic = loopIteration;
		DebugPrint("# " + curEpic + " " + GetGlobalArray("G_ARRAY_EPIC", Text(curEpic)));
	}

	// gm_ms_text
	// <npc_name> <text> called by ms_text ent - but should work fine from anywhere
	void OnGmMsText(string npcName = "", string message = "")
	{
		DebugPrint("gm_ms_text " + npcName + " " + message);
		SetName(npcName);
		SayText(message);
	}

	// gm_suspend_mob_spawns
	// 0|1
	void OnGmSuspendMobSpawns(int disableSpawns = 0)
	{
		// for temporarily suspending monster spawning (deletes on spawn via base_monster_shared)
		GM_DISABLE_SPAWNS = disableSpawns != 0;
	}

	// gm_trigger_hpseq_count
	// <(ignored)> <trigger> activated by trigger relay rly_door_count on orc_for
	void OnGmTriggerHpseqCount(string ignored = "", string triggerName = "")
	{
		if (Text(GM_BTROLLS_DEAD) == "GM_BTROLLS_DEAD")
			GM_BTROLLS_DEAD = 1.0f;
		else
			GM_BTROLLS_DEAD += 1.0f;

		if (!(GM_BTROLLS_DEAD >= GM_TOTAL_TRIGGERED))
			return;
		UseTrigger(triggerName);
	}

	// gm_trigger_hpseq
	// <caller(ignored)> <trigger_prefix> <hpreqs...>
	void OnGmTriggerHpseq(string caller = "", string triggerPrefix = "", string hpRequirement = "", string hpRequirement2 = "", string hpRequirement3 = "", string hpRequirement4 = "", string hpRequirement5 = "", string hpRequirement6 = "", string hpRequirement7 = "")
	{
		// spawn_btrolls_;0;500;1000;1500;2000;3000
		GM_TRIGGER_PREFIX = triggerPrefix;
		GM_HP_TOKENS = hpRequirement;
		int nParams = Int(Eval("game.event.params"));
		if (nParams > 3)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement2);
		if (nParams > 4)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement3);
		if (nParams > 5)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement4);
		if (nParams > 6)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement5);
		if (nParams > 7)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement6);
		if (nParams > 8)
			GM_HP_TOKENS = TokenAdd(GM_HP_TOKENS, hpRequirement7);

		GM_TOTAL_HP = Eval("game.playersnb.totalhp");
		GM_TOTAL_TRIGGERED = 0.0f;
		int count = GetTokenCount(GM_HP_TOKENS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnGmTriggerHpseqLoop();
		}
	}

	// gm_trigger_hpseq_loop
	void OnGmTriggerHpseqLoop()
	{
		string curHpreqText = GetToken(GM_HP_TOKENS, loopIteration);
		int curHpreq = Int(curHpreqText);
		if (Float(GM_TOTAL_HP) >= curHpreq)
		{
			string trigger = GM_TRIGGER_PREFIX + curHpreqText;
			UseTrigger(trigger);
			GM_TOTAL_TRIGGERED += 1.0f;
		}
	}

	// ext_got_quest_item
	// { game_triggered //<map trigger fired>
	// }
	// ---Quest Items
	// <item_code> //Qitem found, add it to items found
	void OnExtGotQuestItem(string itemCode = "")
	{
		if (GetArrayCount("ARRAY_QUEST_ITEMS") == -1)
			ArrayCreate("ARRAY_QUEST_ITEMS");

		ArrayAdd("ARRAY_QUEST_ITEMS", itemCode);

		if (StartsWith(ToLowerCase(MapName()), "undermines") && !PLR_FOUND_FIRST_STICK) // lame
		{
			PLR_FOUND_FIRST_STICK = true;
			InfoMessage("all", "Stick of Dynamite", "Hrmmm... the fuse is broken... but maybe we can use this, somewhere...");
		}
	}

	// ext_check_quest_item
	// TODO: Make this event the only one that should need to be called.
	// It should:
	// Take PARAM1 as the QITEM CODE
	// Take PARAM2 as the calling NPC
	// Check if the item exists
	// If it does, count all of them that exist
	// Delete those entries
	// Call back to the npc that number of times
	// <item_code> <caller_id> //Called from npc that needs a particular item. Find and removes qitem if found, then call back to the npc.
	void OnExtCheckQuestItem(string itemCode = "", CBaseEntity@ callerId = null)
	{
		int count;

		QITEM_NAME = itemCode;
		@QITEM_CALLER = callerId;

		int findItem = ArrayFind("ARRAY_QUEST_ITEMS", QITEM_NAME);

		if (Text(findItem) == "[ERROR_NO_ARRAY]")
			return;

		if (findItem > -1) // If item was found
		{
			count = GetArrayCount("ARRAY_QUEST_ITEMS"); // Finds each qitem, deletes the entry, then calls the NPC
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnFindAllQitems();
			}
		}
	}

	// find_all_qitems
	void OnFindAllQitems()
	{
		int idx = loopIteration;

		int findItem = ArrayFind("ARRAY_QUEST_ITEMS", QITEM_NAME);

		if (findItem > -1)
		{
			ArrayRemoveAt("ARRAY_QUEST_ITEMS", findItem);
			CallExternal(QITEM_CALLER, "ext_receive_quest_item", QITEM_NAME);
		}
		else
		{
			return;
		}
	}

	// ext_dump_quest_items
	// Dumps all qitems to the console
	void OnExtDumpQuestItems()
	{
		int count = GetArrayCount("ARRAY_QUEST_ITEMS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnExtDumpQuestItemsLoop();
		}
	}

	// ext_dump_quest_items_loop
	void OnExtDumpQuestItemsLoop()
	{
		DebugPrint(GetArray("ARRAY_QUEST_ITEMS", Text(loopIteration)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFadeDelay() {} // FADE_DELAY
	void OnGmCountDownEvent() {} // GM_COUNT_DOWN_EVENT
	void OnItemDelay() {} // ITEM_DELAY
	void OnItemTime() {} // ITEM_TIME
	void OnSetTime(float hour = 0.0f, float minute = 0.0f) {} // set_time

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GameMaster_FirstThink();
		VoteGeneric_FirstThink();
		DqGameMaster_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_spell_callbacks") { OnAddSpellCallbacks(); return true; }
		if (name == "admin_load_list") { OnAdminLoadList(); return true; }
		if (name == "confirm_forget_spell") { OnConfirmForgetSpell(PlayerParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "crit_count_remaining") { OnCritCountRemaining(); return true; }
		if (name == "delay_changelevel") { OnDelayChangelevel(); return true; }
		if (name == "dev_cat_point_loop") { OnDevCatPointLoop(); return true; }
		if (name == "dev_cat_points") { OnDevCatPoints(Param(params, 0)); return true; }
		if (name == "dev_test_spawn") { OnDevTestSpawn(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "erase_spell") { OnEraseSpell(Param(params, 0)); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "ext_check_quest_item") { OnExtCheckQuestItem(Param(params, 0), EntityParam(params, 1)); return true; }
		if (name == "ext_dump_quest_items") { OnExtDumpQuestItems(); return true; }
		if (name == "ext_dump_quest_items_loop") { OnExtDumpQuestItemsLoop(); return true; }
		if (name == "ext_got_quest_item") { OnExtGotQuestItem(Param(params, 0)); return true; }
		if (name == "find_all_qitems") { OnFindAllQitems(); return true; }
		if (name == "find_spawn_point") { OnFindSpawnPoint(EntityParam(params, 0)); return true; }
		if (name == "forget_spell") { OnForgetSpell(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_get_spawns") { OnGameGetSpawns(Param(params, 0)); return true; }
		if (name == "game_menu_cancel") { OnGameMenuCancel(PlayerParam(params, 0)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_monsterspawn_removed") { OnGameMonsterspawnRemoved(EntityParam(params, 0)); return true; }
		if (name == "game_playerspeak") { OnGamePlayerspeak(PlayerParam(params, 0), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "game_set_weather") { OnGameSetWeather(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "give_item") { OnGiveItem(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "give_item_delayed") { OnGiveItemDelayed(EntityParam(params, 0), Param(params, 1), Float(Param(params, 2))); return true; }
		if (name == "give_item_delayed2") { OnGiveItemDelayed2(); return true; }
		if (name == "give_item_idx") { OnGiveItemIdx(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "gm_add_del_que") { OnGmAddDelQue(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_add_maldora_fragment") { OnGmAddMaldoraFragment(EntityParam(params, 0)); return true; }
		if (name == "gm_april_fools_check_point") { OnGmAprilFoolsCheckPoint(); return true; }
		if (name == "gm_april_fools_filter") { OnGmAprilFoolsFilter(); return true; }
		if (name == "gm_april_fools_mode") { OnGmAprilFoolsMode(); return true; }
		if (name == "gm_april_fools_spawn_add") { OnGmAprilFoolsSpawnAdd(Vec(Param(params, 0))); return true; }
		if (name == "gm_boost") { OnGmBoost(Param(params, 0), Vec(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "gm_count_down") { OnGmCountDown(); return true; }
		if (name == "gm_createitem") { OnGmCreateitem(Float(Param(params, 0)), Param(params, 1), Vec(Param(params, 2)), Int(Param(params, 3))); return true; }
		if (name == "gm_createitem2") { OnGmCreateitem2(); return true; }
		if (name == "gm_createnpc") { OnGmCreatenpc(Float(Param(params, 0)), Param(params, 1), Vec(Param(params, 2)), Param(params, 3), Float(Param(params, 4)), Float(Param(params, 5)), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "gm_createnpc2") { OnGmCreatenpc2(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3), EntityParam(params, 4), Float(Param(params, 5)), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "gm_createnpc3") { OnGmCreatenpc3(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3), EntityParam(params, 4), Float(Param(params, 5)), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "gm_createnpc4") { OnGmCreatenpc4(Float(Param(params, 0)), Param(params, 1), Vec(Param(params, 2)), Param(params, 3), EntityParam(params, 4), Float(Param(params, 5)), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "gm_createnpc_delayed") { OnGmCreatenpcDelayed(); return true; }
		if (name == "gm_createnpc_delayed2") { OnGmCreatenpcDelayed2(); return true; }
		if (name == "gm_createnpc_delayed3") { OnGmCreatenpcDelayed3(); return true; }
		if (name == "gm_createnpc_delayed4") { OnGmCreatenpcDelayed4(); return true; }
		if (name == "gm_crit_npc_died") { OnGmCritNpcDied(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "gm_del_que_loop") { OnGmDelQueLoop(); return true; }
		if (name == "gm_dodamage") { OnGmDodamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7)); return true; }
		if (name == "gm_drop_item") { OnGmDropItem(Float(Param(params, 0)), Param(params, 1), Vec(Param(params, 2)), Int(Param(params, 3))); return true; }
		if (name == "gm_drop_item2") { OnGmDropItem2(); return true; }
		if (name == "gm_dump_epics") { OnGmDumpEpics(); return true; }
		if (name == "gm_dump_epics_loop") { OnGmDumpEpicsLoop(); return true; }
		if (name == "gm_dumplights") { OnGmDumplights(); return true; }
		if (name == "gm_dumplights_loop") { OnGmDumplightsLoop(); return true; }
		if (name == "gm_epic_to_temp_loop") { OnGmEpicToTempLoop(); return true; }
		if (name == "gm_epilepsy_begin") { OnGmEpilepsyBegin(); return true; }
		if (name == "gm_epilepsy_end") { OnGmEpilepsyEnd(); return true; }
		if (name == "gm_fade") { OnGmFade(EntityParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "gm_fade_in") { OnGmFadeIn(EntityParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "gm_fade_in_loop") { OnGmFadeInLoop(); return true; }
		if (name == "gm_fade_loop") { OnGmFadeLoop(); return true; }
		if (name == "gm_find_highest") { OnGmFindHighest(); return true; }
		if (name == "gm_hollow_one_died") { OnGmHollowOneDied(Vec(Param(params, 0))); return true; }
		if (name == "gm_hollow_one_died2") { OnGmHollowOneDied2(); return true; }
		if (name == "gm_init_array_temp") { OnGmInitArrayTemp(); return true; }
		if (name == "gm_keldorn_troll") { OnGmKeldornTroll(EntityParam(params, 0)); return true; }
		if (name == "gm_light_update") { OnGmLightUpdate(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2)), Param(params, 3)); return true; }
		if (name == "gm_lights_sync") { OnGmLightsSync(Param(params, 0)); return true; }
		if (name == "gm_lights_sync_loop") { OnGmLightsSyncLoop(); return true; }
		if (name == "gm_ms_text") { OnGmMsText(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_newweather_string") { OnGmNewweatherString(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "gm_recieve_client_info") { OnGmRecieveClientInfo(Param(params, 0)); return true; }
		if (name == "gm_say") { OnGmSay(Param(params, 0)); return true; }
		if (name == "gm_scramble_treasure") { OnGmScrambleTreasure(); return true; }
		if (name == "gm_set_sorc_point") { OnGmSetSorcPoint(Vec(Param(params, 0))); return true; }
		if (name == "gm_set_weather") { OnGmSetWeather(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "gm_setname") { OnGmSetname(Param(params, 0)); return true; }
		if (name == "gm_setup_weather") { OnGmSetupWeather(); return true; }
		if (name == "gm_spawn_newell") { OnGmSpawnNewell(); return true; }
		if (name == "gm_start_weather") { OnGmStartWeather(Param(params, 0)); return true; }
		if (name == "gm_suspend_mob_spawns") { OnGmSuspendMobSpawns(Int(Param(params, 0))); return true; }
		if (name == "gm_sxbow_swap") { OnGmSxbowSwap(Param(params, 0)); return true; }
		if (name == "gm_sxbow_swap2") { OnGmSxbowSwap2(); return true; }
		if (name == "gm_temp_to_epic_loop") { OnGmTempToEpicLoop(); return true; }
		if (name == "gm_test_trig") { OnGmTestTrig(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4)); return true; }
		if (name == "gm_trig_filter") { OnGmTrigFilter(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "gm_trig_filter_check") { OnGmTrigFilterCheck(); return true; }
		if (name == "gm_trigger_hpseq") { OnGmTriggerHpseq(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8)); return true; }
		if (name == "gm_trigger_hpseq_count") { OnGmTriggerHpseqCount(Param(params, 0), Param(params, 1)); return true; }
		if (name == "gm_trigger_hpseq_loop") { OnGmTriggerHpseqLoop(); return true; }
		if (name == "gm_vanish_que") { OnGmVanishQue(EntityParam(params, 0), Float(Param(params, 1))); return true; }
		if (name == "gm_vanish_que_loop") { OnGmVanishQueLoop(); return true; }
		if (name == "gm_worm_gold") { OnGmWormGold(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "gm_worm_gold_loop") { OnGmWormGoldLoop(); return true; }
		if (name == "gold_spew") { OnGoldSpew(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Vec(Param(params, 5))); return true; }
		if (name == "gold_spew_loop") { OnGoldSpewLoop(); return true; }
		if (name == "init_lights") { OnInitLights(); return true; }
		if (name == "item_demon_rage") { OnItemDemonRage(EntityParam(params, 0), EntityParam(params, 1), Int(Param(params, 2))); return true; }
		if (name == "make_bag") { OnMakeBag(Param(params, 0), Param(params, 1)); return true; }
		if (name == "player_joined") { OnPlayerJoined(EntityParam(params, 0)); return true; }
		if (name == "player_left") { OnPlayerLeft(EntityParam(params, 0)); return true; }
		if (name == "remove_crit_npc") { OnRemoveCritNpc(); return true; }
		if (name == "reserve_test") { OnReserveTest(Param(params, 0)); return true; }
		if (name == "send_damage") { OnSendDamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "send_menu") { OnSendMenu(); return true; }
		if (name == "set_shad_tele_point") { OnSetShadTelePoint(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "set_spawn_point") { OnSetSpawnPoint(Param(params, 0)); return true; }
		if (name == "set_wizard_center") { OnSetWizardCenter(Param(params, 0)); return true; }
		if (name == "setup_gm") { OnSetupGm(); return true; }
		if (name == "time_sync_check") { OnTimeSyncCheck(); return true; }
		if (name == "worldevent_time") { OnWorldeventTime(Float(Param(params, 0)), Float(Param(params, 1)), Int(Param(params, 2))); return true; }
		return HelenaGameMaster_DispatchEvent(name, params)
			|| OldHelenaGameMaster_DispatchEvent(name, params)
			|| GameMasterDmgpoints_DispatchEvent(name, params)
			|| MapTransitions_DispatchEvent(name, params)
			|| DqGameMaster_DispatchEvent(name, params)
			|| VoteGenericScript::DispatchEvent(name, params);
	}
}
