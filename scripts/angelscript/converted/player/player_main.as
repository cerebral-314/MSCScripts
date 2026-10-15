#pragma context server

// Converted from player/player_main.script by msc_transpiler.
// Player
// 1:55 PM 3/1/2005
// Thothie - quests
// m = destmap of last transition touched
// d = destination spawn of last transition touched
// mv = last gauntlet map I validly spawned in
// dl = darkness contamination level
// h = show_health toggle
// p = health_bars toggle
// r = ring quest stage (integer)
// l = lighthouse keeper (spider,grave,crystal,food)
// n = how many times name has been changed
// s = pet pokeball state, 1=egged, 2=summoned [defunct]
// f = Felwyn Symbol/Shard quest
// b1-b9 = galat chest bank
// a = achievments (token #0=sorc_villa)
// rep = Got reporter reward
// dhal = halo toggled off if set to 1 because default value for unset quests is 0
// pnw = pet wolf name [defunt, pets see below]
// sy = sylphiel's soup available
// BODY = last submodel body layout (for char select screen)
// pets = list of pet types (by script name)
// <pet_script> = pet XP
// <pet_script>_hp = Current Pet HP
// <pet_script>_name = Current Name
// Player Initialization

#include "runtime/ScriptEntity.as"
#include "converted/player/valid_spawn_new.as"
#include "converted/player/server/dmgpoints.as"
#include "converted/player/server/element_resist.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PlayerMain
{
	// Constants
	int LEAP_SIDE_DRAIN = 30;
	int LEAP_BACK_DRAIN = 60;
	int HBAR_FRAMES = 12;
	string SOUND_LEVELUP1 = "magic/converted_EnchP01.wav";
	string LEVELUP_SCRIPT = "player/player_cl_effects_levelup";
	int PLR_DARK_LEVEL_LOSS_RATE = 50;
	int PLR_MAX_DARK_LEVEL = 50000;
	string SOUND_BEAR_STRUCK1 = "monsters/bear/c_bear_hit1.wav";
	string SOUND_BEAR_STRUCK2 = "monsters/bear/c_bear_hit2.wav";
	string SOUND_BEAR_STRUCK3 = "monsters/bear/c_bear_no.wav";

	// Variables (an unset .script variable reads as its own name)
	float FREQ_AFK_CHECK = 60.0f;
	float PLR_2H_REDUCT = 0.0f;
	bool DISPLAY_TARG_HP = false;
	string DISPLAY_PLAYER_HP = "DISPLAY_PLAYER_HP";
	bool PLR_STARTED_AFK_CHECKS = false;
	int PLR_SPEED = 0;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float PLR_DMG = 0.0f;
	bool HAD_FIRST_SPAWN = false;
	bool IS_AFK = false;
	float AFK_TIME = 0.0f;
	float MY_SPAWN_TIME = 0.0f;
	float FIRST_PARTY_MSG = 0.0f;
	string CVAR_HP_LIMIT = "CVAR_HP_LIMIT";
	bool PLR_LIGHTS_SYNCED = false;
	string OWNER_POS = "OWNER_POS";
	float BEAM_ROT = 0.0f;
	string PLR_CORRODE_DURATION = "PLR_CORRODE_DURATION";
	int PLR_SWIFT_BLADE = 0;
	float MSC_PUSH_RESIST = 0.0f;
	bool PLR_LESSER_LEADFOOT = false;
	bool PLR_BRAVERY = false;
	string PLR_DMG_ADJUST_FIRE = "PLR_DMG_ADJUST_FIRE";
	string PLR_ADD_FIRE_DOT = "PLR_ADD_FIRE_DOT";
	float DEMON_BLOOD_END_TIME = 0.0f;
	bool PLR_MANA_FONT = false;
	string IR_GLOWING = "IR_GLOWING";
	bool PL_BEEN_ATTACKED = false;
	float LAST_STRUCK_FOR = 0.0f;
	float BUILD_BAR_COUNT = 0.0f;
	string BAR_STRING = "BAR_STRING";
	string SHOW_HEALTH = "SHOW_HEALTH";
	string LEVEL_UP_SCRIPT = "LEVEL_UP_SCRIPT";
	bool SEND_DMG_DELAY = false;
	float PLR_DARK_LEVEL = 0.0f;
	float PLR_LAST_ATK_TIME = 0.0f;
	CBaseEntity@ HBAR_TARGET = null;
	bool DISPLAY_HBAR_DELAY = false;
	float PLR_LAST_HBAR_SHOW = 0.0f;
	bool DISPLAY_PBAR_DELAY = false;
	float PL_TIME = 0.0f;
	Vector3 AFK_OLD_POS = Vector3();
	bool AFK_DID_FIRST_PULSE = false;
	bool PLR_IN_WORLD = false;
	string PLR_GENDER = "PLR_GENDER";
	bool GAVE_MAP_INTRO = false;
	bool SCARABS_ATTACHED = false;
	string MOTD_TXT1 = "MOTD_TXT1";
	string MOTD_TXT2 = "MOTD_TXT2";
	string MOTD_TXT3 = "MOTD_TXT3";
	string MOTD_TXT4 = "MOTD_TXT4";
	string MOTD_TXT5 = "MOTD_TXT5";
	string MOTD_TXT6 = "MOTD_TXT6";
	string MOTD_TXT7 = "MOTD_TXT7";
	float SIZE_IDX = 0.0f;
	bool PLR_DID_MOTD = false;
	bool ELM_REGISTER_SILENT = false;
	float PLR_ARROW_MENU = 0.0f;
	string PLR_ARROW_ID = "PLR_ARROW_ID";
	float NEXT_DODGE = 0.0f;
	float NEXT_LEAPBACK = 0.0f;
	float NEXT_LEAPLEFT = 0.0f;
	float NEXT_LEAPRIGHT = 0.0f;

	// unnamed block (first think)
	void PlayerMain_FirstThink()
	{
		FREQ_AFK_CHECK = 60.0f;

		PLR_2H_REDUCT = 1.0f;
		// set these to 0 before public releases in MAY2007 (hbar client script will crash old clients)
		DISPLAY_TARG_HP = true; // Used to be for bloodstone ring, now enabled by default.
		DISPLAY_PLAYER_HP = "1"; // default
		SetGlobal("PLR_DARK_UNHOLY_LEVEL", 20000); // this is a varg so it can be picked up by other scripts and the code
	}

	// game_spawn
	// Spawn
	// this runs twice, once during character selection (before clicking), and again when character spawns into world
	void PlayerMain_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		DebugPrint("game_spawn " + Text(HealthOf(ENT_ME)));

		if (!PLR_STARTED_AFK_CHECKS)
			PLR_STARTED_AFK_CHECKS = true;

		// callevent 60.0 afk_check
		LegacyCommand("hud.killicons", ENT_ME);

		PLR_SPEED = 100;

		PLAYING_DEAD = "0"; // in case died while invalidated

		// if ( !$get(GAME_MASTER,exists) ) createnpc game_master $vec(20000,-10000,-20000)
		if (Float(GetQuestData(ENT_ME, "h")) == 1.0f)
			OnConsoleHealthToggle("1");

		SetRace("human");

		if (!HAD_FIRST_SPAWN)
		{
			SetGlobal("global.mstime.updateall", 0); // update time to stop strobe effect?
			PLR_DMG = 0.0f;
			if (Truthy(Eval("game.cvar.ms_chatlog")))
				ChatLog(LegacyFunction("timestamp", ">") + " PLAYER_JOIN: " + NameOf(ENT_ME) + " [ " + SteamIdOf(ENT_ME) + " ] ip: " + GetProp(ENT_ME, "ip"));
			HAD_FIRST_SPAWN = true;
			IS_AFK = false;
			AFK_TIME = 0.0f;
			MY_SPAWN_TIME = GameTime();
			FIRST_PARTY_MSG = GameTime();
			CVAR_HP_LIMIT = Eval("game.cvar.ms_hp_limit");
			FIRST_PARTY_MSG += 60.0f;
		}

		// dbg Spawned from LAST_SPAWN ( legit: $get_map_legit(ent_me) validated: G_VALID_SPAWN type: $get_jointype(ent_me) )
		SetVolume(10);
	}

	// random_spawn
	void PlayerMain_OnRandomSpawn()
	{
		CallExternal(GetVar("GAME_MASTER"), "find_spawn_point", self);
	}

	// activate_stuff
	// { reset_trans_checks
	// setvard NO_TRANS_CHECKS 0
	// }
	void PlayerMain_OnActivateStuff()
	{
		if (!PLR_LIGHTS_SYNCED)
		{
			// send player lights to my client, if any
			// callexternal GAME_MASTER gm_lights_sync $get(ent_me,index)
			CallExternal("all", "player_joined", self);
			UseTrigger("player_joined");
			PLR_LIGHTS_SYNCED = true;
		}

		// Removed client side dll check. -greatguys1@NOV2021
		if (Float(GetProp(ENT_ME, "companions")) > 0.0f) {}

		LegacyCommand("drainstamina", ENT_ME, -1000); // restore stamina on spawn
		ClientCommand(ENT_ME, "room_type 0;wait;switchhand 1;wait;switchhand 1"); // reset EAX and fix hand display

		// infomsg all "DEBUG" "activate_stuff"
		DebugPrint("activate_stuff");

		if (Float(CVAR_HP_LIMIT) > 0.0f && MaxHealthOf(ENT_ME) >= Float(CVAR_HP_LIMIT))
			CallEventDelayed(1.0f, "hp_max_warn");

		// setvard PLR_PRECHEAT_POS $get(ent_me,origin)
		CallExternal("all", "ext_activate_items", self);
	}

	// tele_spawn
	// { send_recon_line3
	// clientcmd ent_me CLIENT_RECON_LINE3
	// }
	void PlayerMain_OnTeleSpawn()
	{
		// dbg temp moving to ( NEW_SPAWN_POS )
		PlaySound(0, 10, "magic/spawn.wav");
		SetOrigin(ENT_ME, Vec(NEW_SPAWN_POS));
		OWNER_POS = NEW_SPAWN_POS;
		for (int i = 0; i < 18; i++)
		{
			loopIteration = i;
			OnBeamFx();
		}
	}

	// beam_fx
	void PlayerMain_OnBeamFx()
	{
		Vector3 beamStart = Vec(OWNER_POS);
		Vector3 beamEnd = Vec(OWNER_POS);

		beamStart += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, -32));
		beamEnd += RelativePosition(Vector3(0, BEAM_ROT, 0), Vector3(0, 32, 128));
		Effect("beam", "point", "lgtning.spr", 100, beamStart, beamEnd, Vector3(255, 0, 255), 200, 16, 3);

		BEAM_ROT += 20.0f;
	}

	// game_think
	// Main think... called every frame
	void PlayerMain_OnGameThink()
	{
	}

	// game_jump
	// Player jump
	void PlayerMain_OnGameJump()
	{
		// dbg temp Jimmune IMMUNE_LIGHTNING
		PlayAnim("once", ANIM_JUMP);
	}

	// game_jump_land
	void PlayerMain_OnGameJumpLand()
	{
		PlayAnim("break");
	}

	// game_death
	// Player death
	void PlayerMain_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClearEffects(); // may not work on players yet

		PLR_CORRODE_DURATION = "0";

		PLR_SWIFT_BLADE = 0;
		MSC_PUSH_RESIST = 0.0f;
		PLR_LESSER_LEADFOOT = false;

		LegacyCommand("hud.killicons", ENT_ME);

		// if ( $get_quest_data(ent_me,s) equals out )
		// {
		// if $get(ent_me,companions) > 0
		// callevent player_unsummon_pets
		// }
		PLR_BRAVERY = false; // reset bravery pot status
		PLR_DMG_ADJUST_FIRE = "0"; // reset damage adjust
		PLR_ADD_FIRE_DOT = "0"; // reset additional DOT

		OnExtSetbodytype("normal"); // JAN2010 - for new ref model

		if (PLR_FAURA) // reset aura
			CallExternal(ENT_ME, "ext_fire_aura_remove");
		if (PLR_PAURA) // reset aura
			CallExternal(ENT_ME, "ext_poison_aura_remove");

		PLR_MANA_FONT = false; // disable mana font

		CallExternal("all", "bs_global_command", self, "vanish", "death"); // remove my summons and report my death

		IR_GLOWING = "0"; // toggle internal glow off
		// remove external potion effects
		if (REGEN_ON)
			CallExternal(ENT_ME, "regen_end");
		if (VAMPIRE_ON)
			CallExternal(ENT_ME, "vampire_off");
		if (PLR_FAURA)
			CallExternal(ENT_ME, "ext_fire_aura_remove");

		// setvard VAMPIRE_ON 0 //vampire blood go bye bye
		// setvard DEMON_BLOOD 0 //" "
		if (Truthy(ScriptVarOf(ENT_ME, "PLR_SHIELD_UP")))
			CallExternal(ENT_ME, "ext_shield_up", 0);

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_SFAURA_ACTIVE")))
			CallExternal(ENT_ME, "ext_sfaura_end");

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_HAURA_ACTIVE")))
			CallExternal(ENT_ME, "ext_end_holy_aura");

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_REPEL_SHIELD_ACTIVE")))
			CallExternal(ENT_ME, "ext_end_repel_shield");

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_PLSHIELD_ACTIVE")))
			CallExternal(ENT_ME, "ext_pole_lshield_end");

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_BEAR_MODE")))
		{
			// callevent ext_bear_mode_end
			DebugPrint("player died in bear mode " + EntityId(PLR_BEAR_IMAGE_ID));
			// playsound 0 10 monsters/bear/c_bear_dead.wav
			CallExternal(PLR_BEAR_IMAGE_ID, "ext_bear_die", "from_player_main");
			CallExternal(ENT_ME, "ext_bear_mode_end");
		}
		else
		{
			// setvard PLR_BEAR_MODE 0
			// setprop ent_me rendermode 0
			// setprop ent_me renderamt 255
			// nopush OLD_NOPUSH
			// callexternal PLR_BEAR_CLAWS_ID bear_transformation_end
			PlaySound(0, 10, SOUND_DEATH);
		}

		// redundant bear removal
		if (Exists(PLR_BEAR_IMAGE_ID))
			DeleteEntity(PLR_BEAR_IMAGE_ID, "fade");

		ScriptFlags(ENT_ME, "cleartype", "nopush");
		ScriptFlags(ENT_ME, "cleartype", "mana_regen");
		ScriptFlags(ENT_ME, "cleartype", "combat");
		ScriptFlags(ENT_ME, "cleartype", "speed");
		ScriptFlags(ENT_ME, "cleartype", "atkspeed");
		ScriptFlags(ENT_ME, "cleartype", "spider_resist");

		OnSpiderProtectEnd();
		CallExternal(ENT_ME, "plr_change_speed", "normal"); // Set normal speed - player/emote_sitstand

		OnAnimateDeath();
		UseTrigger("player_died"); // tell map a player died
		CallEventDelayed(0.1f, "warp_out"); // anti-looter measure
	}

	// warp_out
	void PlayerMain_OnWarpOut()
	{
		SetOrigin(ENT_ME, Vector3(20000, 20000, -20000)); // send real body to oblivion so cant be looted
	}

	// game_parry
	// PARAM1=attacker PARAM2=Damage PARAM3=Type PARAM4=Parry_Roll PARAM5=Atk_Roll PARAM6=ParrySkill
	void PlayerMain_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		// dbg temp PLAYER PARRY! Atker $get(PARAM1,name) dmg PARAM2 dmgtype PARAM3 roll PARAM4 pry PARAM5 p6 PARAM6
		int parryRollValue = int(parryRoll);
		int accuRoll = int(accuracyRoll);
		DebugPrint("game_parry " + Text(parryValue));
		PlayerMessage(ENT_ME, "You parry the attack! ( " + parryRollValue + " vs. " + accuRoll + " )");
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=Type
	string PlayerMain_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		PL_BEEN_ATTACKED = true;

		LAST_STRUCK_FOR = damage; // for bone blade

		// this doesn't wanna work here :\
		// if ( $get(ent_me,scriptvar,'PLR_SPIDER_PROT') )
		// {
		// if $get(PARAM1,race) equals spider
		// local DMG_RED_AMT $get(ent_me,scriptvar,'PLR_SPIDER_AMT')
		// local OUT_DMG PARAM2
		// multiply OUT_DMG DMG_RED_AMT
		// setdmg hit 1
		// setdmg dmg OUT_DMG
		// return DMG_RED_AMT
		// dbg adjusted_damage PARAM2 to OUT_DMG via DMG_RED_AMT
		// }
		if (PLR_BEAR_MODE && RandomInt(1, 3) == 1)
			PlayRandomSound(0, 10, SOUND_BEAR_STRUCK1, SOUND_BEAR_STRUCK2, SOUND_BEAR_STRUCK3);

		// dbg PlayerTakedmg P1 $get(PARAM1,name) p2 PARAM2 p3 PARAM3 p4 PARAM4
		if (!(damage > 0.0f))
			return result;

		OnDisplayHealth();
		return result;
	}

	// display_health
	void PlayerMain_OnDisplayHealth()
	{
		CallExternal("players", "show_hbar_player", self);

		if (!Truthy(SHOW_HEALTH))
			return;
		float myHp = HealthOf(ENT_ME);
		float myMaxhp = MaxHealthOf(ENT_ME);
		myHp = int(myHp);
		myMaxhp = int(myMaxhp);

		float percent = Divide(myHp, myMaxhp) * 100.0f;
		percent = int(percent);
		string percentText = Text(percent);

		float fillPos = Divide(percent, 10.0f);
		fillPos = int(fillPos);
		string fillPosText = Text(fillPos);

		BUILD_BAR_COUNT = 0.0f;
		BAR_STRING = "{";
		for (int i = 0; i < 10; i++)
		{
			loopIteration = i;
			OnBuildBar(fillPosText);
		}
		BAR_STRING += "}";

		percentText += "%";

		PlayerMessageGreen(ENT_ME, "HP: " + BAR_STRING + " " + percentText + " ( " + Text(myHp) + " / " + Text(myMaxhp) + " )");
	}

	// console_health_toggle
	// PARAM1 = 0/1/toggle //called externally from sv_world_commands
	void PlayerMain_OnConsoleHealthToggle(string showHealth = "")
	{
		if (showHealth == "toggle")
		{
			if (Truthy(SHOW_HEALTH))
				SHOW_HEALTH = "0";
			else
				SHOW_HEALTH = "1";
		}

		if (showHealth != "toggle")
			SHOW_HEALTH = showHealth;

		if (Truthy(SHOW_HEALTH))
		{
			Quest("set", ENT_ME, "h", 1);
			PlayerMessage(ENT_ME, "Your health will now be displayed in the combat hud when you are struck");
			ConsoleMessage(ENT_ME, "Your health will now be displayed in the combat hud when you are struck");
		}
		if (!Truthy(SHOW_HEALTH))
		{
			Quest("set", ENT_ME, "h", 0);
			PlayerMessage(ENT_ME, "Your health will no longer be displayed in the combat hud");
			ConsoleMessage(ENT_ME, "Your health will no longer be displayed in the combat hud");
		}
	}

	// healthbar_toggle
	// PARAM1 = 0/1/toggle //called externally from sv_world_commands
	void PlayerMain_OnHealthbarToggle(string displayMode = "")
	{
		if (displayMode == "toggle")
		{
			if (Truthy(DISPLAY_PLAYER_HP))
				DISPLAY_PLAYER_HP = "0";
			else
				DISPLAY_PLAYER_HP = "1";
		}

		if (displayMode != "toggle")
			DISPLAY_PLAYER_HP = displayMode;

		if (Truthy(DISPLAY_PLAYER_HP))
		{
			Quest("set", ENT_ME, "p", 1);
			PlayerMessage(ENT_ME, "Player health bars are enabled.");
			ConsoleMessage(ENT_ME, "Player health bars are enabled.");
		}
		if (!Truthy(DISPLAY_PLAYER_HP))
		{
			Quest("set", ENT_ME, "p", 0);
			PlayerMessage(ENT_ME, "Player health bars are disabled.");
			ConsoleMessage(ENT_ME, "Player health bars are disabled.");
		}
	}

	// mana_drain
	// called externally from magic_hand_base
	void PlayerMain_OnManaDrain()
	{
		if (!Truthy(SHOW_HEALTH))
			return;
		float myMp = ManaOf(ENT_ME);
		float myMaxmp = MaxManaOf(ENT_ME);
		myMp = int(myMp);
		myMaxmp = int(myMaxmp);

		float percent = Divide(myMp, myMaxmp) * 100.0f;
		percent = int(percent);
		string percentText = Text(percent);

		float fillPos = Divide(percent, 10.0f);
		fillPos = int(fillPos);
		string fillPosText = Text(fillPos);

		BUILD_BAR_COUNT = 0.0f;
		BAR_STRING = "{";
		for (int i = 0; i < 10; i++)
		{
			loopIteration = i;
			OnBuildBar(fillPosText);
		}
		BAR_STRING += "}";

		percentText += "%";

		PlayerMessageBlue(ENT_ME, "MANA: " + BAR_STRING + " " + percentText + " ( " + Text(myMp) + " / " + Text(myMaxmp) + " )");
	}

	// build_bar
	void PlayerMain_OnBuildBar(string barLength = "")
	{
		BUILD_BAR_COUNT += 1.0f;
		if (BUILD_BAR_COUNT <= Float(barLength))
			BAR_STRING += "|";
		if (BUILD_BAR_COUNT > Float(barLength))
			BAR_STRING += " ";
	}

	// game_learnskill
	// failed armor body hack
	// { [shared] monitor_loop
	// callevent 5.0 monitor_loop
	// if ( $get(ent_me,isalive) )
	// {
	// if $get(ent_me,exists)
	// if !$item_exists(ent_me,armor_body)
	// //dbg temp player has no body, giving body
	// giveitem armor_body
	// }
	// }
	// 1: Skill name (buggy-keeps spaces)  2: Subskill name 3: Skill value (buggy-oft returns 0)
	void PlayerMain_OnGameLearnskill(string skill = "", string subSkill = "", float value = 0.0f)
	{
		PlayerMessageGreen(ENT_ME, "Level awarded to " + skill + " " + subSkill);

		if (Truthy(GetProp(ENT_ME, "isbot")))
			return;

		string titleString = NameOf(ENT_ME) + " has gained a level!";
		string messageString = "has gained experience in " + skill;
		if (StartsWith(skill, "Spell"))
			messageString += " " + subSkill;

		InfoMessage("all", titleString, messageString);

		PlaySound(0, 10, SOUND_LEVELUP1); // SOUND_LEVELUP2

		ClientEvent("new", "all", "player/player_conartist", "levelup", IndexOf(ENT_ME));
		LEVEL_UP_SCRIPT = LastClientScriptId();
	}

	// reset_send_dmg_delay
	void PlayerMain_OnResetSendDmgDelay()
	{
		SEND_DMG_DELAY = false;
	}

	// game_transition_entered
	void PlayerMain_OnGameTransitionEntered(string transDesc = "", string destMap = "", string localSpawn = "", string destSpawn = "")
	{
	}

	// game_xpgain
	// PARAM1=XP amt
	void PlayerMain_OnGameXpgain(float xp = 0.0f, CBaseEntity@ monster = null)
	{
		int xpGain = int(xp);
		PlayerMessageGreen(ENT_ME, "* " + xpGain + " XP Awarded");
	}

	// give_map_intro
	void PlayerMain_OnGiveMapIntro()
	{
		InfoMessage(ENT_ME, GetVar("G_MAP_NAME"), GetVar("G_MAP_DESC"));
		string petList = GetQuestData(ENT_ME, "pets");
		if (petList != "0")
			CallEventDelayed(0.1f, "pet_notice");
		CallEventDelayed(3.0f, "give_map_diff");
	}

	// pet_notice
	void PlayerMain_OnPetNotice()
	{
		string petList = GetQuestData(ENT_ME, "pets");
		if (petList != "0")
		{
			if (GetTokenCount(petList) > 1)
				HelpTip(ENT_ME, "generic", "You have Pets!", "You can summon your pets via the Player Menu (defaultkey: F)");
			else
				HelpTip(ENT_ME, "generic", "You have a Pet!", "You can summon your pet via the Player Menu (defaultkey: F)");
		}
	}

	// give_map_diff
	void PlayerMain_OnGiveMapDiff()
	{
		// callevent 1.0 give_server_settings
		if (GetVar("G_MAP_DIFF") != "G_MAP_DIFF")
			InfoMessage(ENT_ME, "Intended Difficulty", GetVar("G_MAP_DIFF"));
		if (!(MyMaxHealth() >= 5.0f))
			return;
		if (MyMaxHealth() < Float(GetVar("G_WARN_HP")))
			InfoMessage(ENT_ME, "WARNING", "This area maybe too difficult at your level!");
	}

	// help_toggle
	void PlayerMain_OnHelpToggle()
	{
		bool exitSub = false;
		if (!Truthy(GetVar("G_HELP_ON")))
		{
			SetGlobal("G_HELP_ON", 1);
			ConsoleMessage(ENT_ME, "Be sure to get more info at: www.msremake.com/forums");
			UseTrigger("help_spr");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(GetVar("G_HELP_ON")))
		{
			SetGlobal("G_HELP_ON", 0);
			ConsoleMessage(ENT_ME, "Be sure to get more info at: www.msremake.com/forums");
			PlayerMessageGreen(ENT_ME, "You can type help again to restore the help panels");
			UseTrigger("help_spr");
			exitSub = true;
		}
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	string PlayerMain_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// dbg Player_Attacked with PARAM5 for PARAM6
		if (damageType == "dark")
		{
			// Thothie AUG2010_23 Dark Energy Corruption
			OnPlrAddDark(int(Float(damageText)));
		}
		return result;
	}

	// plr_add_dark
	// <amt>
	void PlayerMain_OnPlrAddDark(float amount = 0.0f)
	{
		float oldPlrDarkLevel = PLR_DARK_LEVEL;
		PLR_DARK_LEVEL += amount;
		if (PLR_DARK_LEVEL > PLR_MAX_DARK_LEVEL)
			PLR_DARK_LEVEL = PLR_MAX_DARK_LEVEL;
		if (oldPlrDarkLevel < Float(GetVar("PLR_DARK_UNHOLY_LEVEL")) && PLR_DARK_LEVEL > Float(GetVar("PLR_DARK_UNHOLY_LEVEL")))
			OnPlayerCalcHolyResistance();
	}

	// game_helptip
	void PlayerMain_OnGameHelptip(string title = "", string tip = "")
	{
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=type
	string PlayerMain_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool exitSub = false;
		float inDmg = 0.0f;
		string result = "";

		IS_AFK = false;
		PLR_LAST_ATK_TIME = GameTime();

		if (PLR_2H_REDUCT < 1.0f)
		{
			if (Contains(damageType, "effect"))
				exitSub = true;
			if (!exitSub)
			{
				inDmg = damage * PLR_2H_REDUCT;
				DebugPrint("2hreduct " + Text(damage) + " to " + Text(inDmg));
				result = AppendResult(result, Text(PLR_2H_REDUCT));
			}
		}

		if (Float(ScriptVarOf(ENT_ME, "PLR_DMG_ADJUST_FIRE")) > 0.0f && Contains(damageType, "fire"))
		{
			string adjRatioText = ScriptVarOf(ENT_ME, "PLR_DMG_ADJUST_FIRE");
			int adjRatio = Int(adjRatioText);
			result = AppendResult(result, adjRatioText);
			inDmg = damage * adjRatio;
			DebugPrint("Adjusted fire dmg " + Text(damage) + " to " + Text(inDmg));
		}

		if (Float(ScriptVarOf(ENT_ME, "PLR_ADD_FIRE_DOT")) > 0.0f)
		{
			int dotRatio = Int(ScriptVarOf(ENT_ME, "PLR_ADD_FIRE_DOT"));
			float ownerSkill = SkillOf(ENT_ME, "spellcasting.fire") * dotRatio;

			// Do a check to see if this player already has a fire dot applied to the enemy
			string dotFlagName = "fire_effect;" + IndexOf(ENT_ME); // example: fire_effect;1
			string value = ScriptFlag(target, dotFlagName, "name_value");
			if (value == "none") // Not applied, so apply one
				ApplyEffect(target, "effects/dot_fire", 5.0f, self, ownerSkill, "spellcasting.fire");
		}

		if (!DISPLAY_TARG_HP)
			return result;
		@HBAR_TARGET = target;
		CallEventDelayed(0.1f, "ext_show_hbar_monster"); // give time for health to propigate
		return result;
	}

	// ext_show_hbar_monster
	// <target_to_show> <even_if_no_bloodstone>
	void PlayerMain_OnExtShowHbarMonster(CBaseEntity@ targetToShow = null, int forceShow = 0)
	{
		bool exitSub = false;
		if (forceShow == 0 && !DISPLAY_TARG_HP)
			exitSub = true;
		if (exitSub)
			return;
		if (targetToShow !is null)
			@HBAR_TARGET = targetToShow;

		if (!(GameTime() > PLR_LAST_HBAR_SHOW))
			return;
		DISPLAY_HBAR_DELAY = true;
		PLR_LAST_HBAR_SHOW = GameTime() + 0.5f;

		// callevent 0.5 reset_hbar_delay
		CBaseEntity@ targHit = HBAR_TARGET;

		float targHp = HealthOf(targHit);
		float targMaxhp = MaxHealthOf(targHit);
		float percHp = Divide(targHp, targMaxhp);
		float hbarFrame = HBAR_FRAMES * percHp;
		hbarFrame = int(hbarFrame);
		float hbarHeight = Clamp(HeightOf(targHit), 32.0f, 512.0f);
		// add HBAR_HEIGHT 32
		Vector3 hbarPos = OriginOf(targHit);
		hbarPos.z += hbarHeight;
		// dbg making health_bar HBAR_FRAME
		float hbarScale = Clamp(Divide(targMaxhp, 4000.0f), 0.05f, 0.75f);
		string hbarScaleText = Text(hbarScale);

		if (!IsAlive(targHit))
			hbarFrame = 0.0f;

		string hbarAdjPos = ScriptVarOf(targHit, "NPC_HBAR_ADJ");
		// dbg show_hbar_monster HBAR_ADJ_POS
		if (hbarAdjPos != "NPC_HBAR_ADJ")
		{
			float targYaw = AnglesOf(targHit).y;
			hbarPos += RelativePosition(Vector3(0, targYaw, 0), Vec(hbarAdjPos));
		}

		// new HBAR_POS attempt
		// trying to make it look like its on hud
		// fail - rather this just kinda makes it always appear in front of you
		// has its advantages but still no good
		// most likely will have to make new script function to draw on hud
		// based on stamina or weight bar
		// local MY_VIEW $get(ent_me,viewangles)
		// local MY_VIEW_YAW $vec.yaw(MY_VIEW)
		// local MY_VIEW_PITCH $vec.pitch(MY_VIEW)
		// local MY_VIEW_ROLL $vec.roll(MY_VIEW)
		// local HBAR_POS $get(ent_me,origin)
		// vectoradd HBAR_POS $relpos($vec(MY_VIEW_PITCH,MY_VIEW_YAW,MY_VIEW_ROLL),$vec(0,30,32))
		// local HBAR_SCALE 0.1
		float wagaroWtf = hbarFrame;
		string wagaroWtfText = Text(wagaroWtf);
		DebugPrint("ext_show_hbar_monster " + Text(hbarFrame) + " " + wagaroWtfText);
		wagaroWtf += 22.0f; // i've no fucking idea why, but the client does not like frame=5, so crazy fix
		wagaroWtfText = Text(wagaroWtf);

		ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "show_hbar", hbarPos, wagaroWtfText, hbarScaleText, IndexOf(targHit));
	}

	// show_hbar_player
	void PlayerMain_OnShowHbarPlayer(CBaseEntity@ player = null)
	{
		if (!Truthy(DISPLAY_PLAYER_HP))
			return;

		if (DISPLAY_PBAR_DELAY)
			return;
		DISPLAY_PBAR_DELAY = true;
		CallEventDelayed(0.5f, "reset_display_pbar_delay");
		CBaseEntity@ targHit = self;

		float targHp = HealthOf(targHit);
		float targMaxhp = MaxHealthOf(targHit);
		float percHp = Divide(targHp, targMaxhp);
		float hbarFrame = HBAR_FRAMES * percHp;
		hbarFrame = int(hbarFrame);
		float hbarHeight = HeightOf(targHit) - 20.0f; // player origin is center, compensate
		Vector3 hbarPos = OriginOf(targHit);
		hbarPos.z += hbarHeight;
		// dbg making health_bar HBAR_FRAME
		string hbarScale = Text(targMaxhp);

		if (!IsAlive(targHit))
			hbarFrame = 0.0f;

		float wagaroWtf = hbarFrame;
		// dbg ext_show_hbar_monster HBAR_FRAME WAGARO_WTF
		wagaroWtf += 22.0f; // i've no fucking idea why, but the client does not like frame=5, so crazy fix
		string wagaroWtfText = Text(wagaroWtf);

		// if ( PARAM1 equals $get(ent_me,id) ) clientevent new all player/health_bar HBAR_POS HBAR_FRAME 0.125 $get(ent_me,index)
		// if ( PARAM1 isnot ent_me ) clientevent new PARAM1 player/health_bar HBAR_POS HBAR_FRAME 0.125 $get(ent_me,index)
		if (player is self)
			ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "show_hbar", hbarPos, wagaroWtfText, 0.125f, IndexOf(ENT_ME));
		if (player !is self)
			ClientEvent("update", player, Eval("const.localplayer.scriptID"), "show_hbar", hbarPos, wagaroWtfText, 0.125f, IndexOf(ENT_ME));
	}

	// reset_display_pbar_delay
	void PlayerMain_OnResetDisplayPbarDelay()
	{
		DISPLAY_PBAR_DELAY = false;
	}

	// game_targeted_by_player
	void PlayerMain_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		OnShowHbarPlayer(player);
	}

	// reset_hbar_delay
	void PlayerMain_OnResetHbarDelay()
	{
		DISPLAY_HBAR_DELAY = false;
	}

	// unnamed block (timer)
	void PlayerMain_Timer()
	{
		CallEventDelayed(FREQ_AFK_CHECK, "PlayerMain_Timer");
		if (!PLR_STARTED_AFK_CHECKS)
			return;

		Vector3 curPos = OriginOf(ENT_ME);
		if (Distance(AFK_OLD_POS, curPos) <= 128.0f)
		{
			if (AFK_DID_FIRST_PULSE)
			{
				float lastAtkTime = PLR_LAST_ATK_TIME + 60.0f;
				if (GameTime() > lastAtkTime) // not AFK if hit something <60 seconds ago
				{
					if (Truthy(GetVar("G_DEVELOPER_MODE")) && !IS_AFK)
						PlayerMessageBlue(ENT_ME, "====== FLAGGED AFK!");
					IS_AFK = true;
					FREQ_AFK_CHECK = 5.0f;
				}
			}
		}
		else
		{
			if (Truthy(GetVar("G_DEVELOPER_MODE")) && IS_AFK)
				PlayerMessageBlue(ENT_ME, "====== No longer afk");
			FREQ_AFK_CHECK = 60.0f;
			IS_AFK = false;
		}

		if (IS_AFK)
			AFK_TIME += 1.0f;

		if (PLR_IN_WORLD)
		{
			PL_TIME += 1.0f;
			if (PLR_DARK_LEVEL > 0.0f)
			{
				// Thothie AUG2010_23 Dark Energy Corruption
				if (!IS_AFK)
				{
					PLR_DARK_LEVEL -= PLR_DARK_LEVEL_LOSS_RATE;
					if (PLR_DARK_LEVEL < 0.0f)
						PLR_DARK_LEVEL = 0.0f;
					Quest("set", ENT_ME, "dl", PLR_DARK_LEVEL);

					// figure new holy damage ratio
					OnPlayerCalcHolyResistance();
				}
			}
		}
		// Thothie AUG2010_23 - wtf is this about? (removing - thinking pre game_player_putinworld convention)
		// if ( $get(ent_me,onground) )
		// {
		// setvard IN_WORLD 1
		// setvard PL_TIME 0
		// }
		AFK_OLD_POS = MyOrigin();
		AFK_DID_FIRST_PULSE = true;
	}

	// game_party_join
	// test these:
	// does not work, at least not here
	// { game_seen
	// dbg game_seen $get(PARAM1,name)
	// }
	// These work
	// { game_jump
	// dbg game_jump
	// }
	// { game_jump_land
	// dbg game_jump_land
	// }
	void PlayerMain_OnGamePartyJoin(string partyName = "")
	{
		// dbg game_party_join PARAM1
		if (!(FIRST_PARTY_MSG > 0.0f))
			return;
		if (!(GameTime() > FIRST_PARTY_MSG))
			return;

		// local PARTY_REPORT_TYPE game.cvar.ms_party_report
		// if PARTY_REPORT_TYPE > 0
		string titleStr = NameOf(ENT_ME) + " has joined " + partyName;
		string outStr = NameOf(ENT_ME) + " has joined the party of " + partyName;
		// if ( PARTY_REPORT_TYPE == 2 ) infomsg all TITLE_STR OUT_STR
		MessageAll("green", outStr);
	}

	// game_party_leave
	void PlayerMain_OnGamePartyLeave()
	{
	}

	// christmas_mode
	// Maybe useful later
	// { [server] game_death
	// callexternal all player_died $get(ent_me,id)
	// }
	// debuggary - remove
	// {
	// repeatdelay 1.0
	// dbg can_attack $get(ent_me,canattack)
	// }
	void PlayerMain_OnChristmasMode()
	{
		CallExternal(ENT_ME, "ext_weather_manual_change", "snow");
		PlayMusic("all", "system", "xmass.mp3");
		SetGlobal("global.map.weather", "snow;snow;snow");
	}

	// game_player_got_from_store
	// <item_id> <vendor_id>
	void PlayerMain_OnGamePlayerGotFromStore(CBaseEntity@ item = null, CBaseEntity@ vendor = null)
	{
		bool exitSub = false;
		bool reportItem = false;

		DebugPrint("game_player_got_from_store " + EntityId(item) + " " + EntityId(vendor));

		if (StartsWith(ItemNameOf(item), "gold_pouch_"))
		{
			CallExternal(ENT_ME, "ext_addgold", ScriptVarOf(item, "GOLD_VALUE"));
			LegacyCommand("removeitem", @item);
			DeleteEntity(item);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(ScriptVarOf(vendor, "NPC_ECHO_ITEMS")))
			CallExternal(vendor, "ext_player_got_item", @item, self);

		if (Float(GetProp(item, "value")) > 500.0f && !Truthy(ScriptVarOf(vendor, "NPC_NO_TRADE_REPORT")))
		{
			// report to other players when grabbing items over 500gp in value
			// - anti-ninja
			string vendorName = NameOf(vendor);
			if (Contains(ToLowerCase(vendorName), "chest"))
				reportItem = true;
			if (Truthy(ScriptVarOf(vendor, "NPC_REPORT_ITEMS")))
				reportItem = true;
			if (Truthy(ScriptVarOf(vendor, "NPC_NO_REPORT_ITEMS")))
				reportItem = false;
			if (Truthy(GetVar("G_DEVELOPER_MODE")))
				PlayerMessageGreen(ENT_OWNER, "report_item: " + Text(reportItem) + " [ " + ToLowerCase(vendorName) + " ] " + ScriptVarOf(vendor, "NPC_REPORT_ITEMS"));
			if (reportItem)
			{
				string outMsg = "";
				outMsg = outMsg + NameOf(ENT_ME) + " recieved " + NameOf(item) + " from " + vendorName;
				InfoMessage("all", outMsg, " ");
			}
		}

		if (!Truthy(GetVar("G_DEVELOPER_MODE")))
			return;
		MessageAll("green", "fromstore: " + NameOf(item) + " " + GetProp(item, "value"));
	}

	// hp_max_warn
	void PlayerMain_OnHpMaxWarn()
	{
		string msgTitle = "HP LIMIT is ";
		msgTitle = msgTitle + Text(int(Float(CVAR_HP_LIMIT))) + " hp";
		InfoMessage(ENT_ME, msgTitle, "Your current character is too powerful for this server.");
		CallEventDelayed(2.0f, "hp_max_warn2");
	}

	// hp_max_warn2
	void PlayerMain_OnHpMaxWarn2()
	{
		string msgTitle = "HP LIMIT is ";
		msgTitle = msgTitle + Text(int(Float(CVAR_HP_LIMIT))) + " hp";
		InfoMessage(ENT_ME, msgTitle, "You will be disconnected in 10 seconds.");
		CallEventDelayed(5.0f, "hp_max_warn3");
	}

	// hp_max_warn3
	void PlayerMain_OnHpMaxWarn3()
	{
		string msgTitle = "HP LIMIT is ";
		msgTitle = msgTitle + Text(int(Float(CVAR_HP_LIMIT))) + " hp";
		InfoMessage(ENT_ME, msgTitle, "Your current character is too powerful for this server.");
		CallEventDelayed(1.0f, "hp_max_warn4");
	}

	// hp_max_warn4
	void PlayerMain_OnHpMaxWarn4()
	{
		string msgTitle = "HP LIMIT is ";
		msgTitle = msgTitle + Text(int(Float(CVAR_HP_LIMIT))) + " hp";
		InfoMessage(ENT_ME, msgTitle, "You will be disconnected in 5 seconds.");
		CallEventDelayed(4.0f, "hp_max_warn5");
	}

	// hp_max_warn5
	void PlayerMain_OnHpMaxWarn5()
	{
		string clCmd = "toggleconsole;clear;echo This server does not allow characters with more than ";
		clCmd = clCmd + Text(int(Float(CVAR_HP_LIMIT))) + " hp;echo ===;disconnect";
		ClientCommand(ENT_ME, clCmd);
	}

	// game_respawn
	// goes off if player spawns after death
	void PlayerMain_OnGameRespawn()
	{
		DebugPrint("game_respawn");
	}

	// game_player_putinworld
	// goes off when player spawns, rather than during character selection (as with game_spawn)
	void PlayerMain_OnGamePlayerPutinworld()
	{
		if (Truthy(GetVar("G_CHRISTMAS_MODE")))
		{
			string mapName = ToLowerCase(MapName());
			if (mapName == "edana")
				CallEventDelayed(1.0f, "christmas_mode");
			if (mapName == "deralia")
				CallEventDelayed(1.0f, "christmas_mode");
			if (mapName == "helena")
				CallEventDelayed(1.0f, "christmas_mode");
		}
		// (always true here) if game.serverside

		if (!PLR_IN_WORLD)
		{
			CallExternal("players", "ext_reset_model"); // reinitialize models for all players so new player sees them proper
			PLR_IN_WORLD = true;
		}

		if (!HasEffect(ENT_ME, "player_sitstand"))
			ApplyEffect(ENT_ME, "player/emote_sit&stand");

		OnValidateSpawn();

		PLR_DARK_LEVEL = Float(GetQuestData(ENT_ME, "dl"));

		PLR_GENDER = GenderOf(ENT_ME);

		CallExternal(ENT_ME, "ext_set_gender");

		string maxViewDistText = Eval("game.map.maxviewdistance");
		int maxViewDist = Int(maxViewDistText);
		DebugPrint("map_maxviewdistance " + maxViewDistText);
		if (maxViewDist > 512)
			ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "set_view_dist", maxViewDistText);
		else
			ClientEvent("update", ENT_ME, Eval("const.localplayer.scriptID"), "set_view_dist", 16384);

		// if ( $filesize(motd.txt) > 0 )
		// {
		// callevent do_motd
		// }
		if (!GAVE_MAP_INTRO && GetVar("G_MAP_NAME") != "G_MAP_NAME")
		{
			GAVE_MAP_INTRO = true;
			CallEventDelayed(10.0f, "give_map_intro");
		}

		if (GetVar("G_FORCE_SPAWN_WEATHER") != "G_FORCE_SPAWN_WEATHER")
			CallExternal(ENT_ME, "ext_weather_change", GetVar("G_FORCE_SPAWN_WEATHER"));

		// Thothie AUG2010_23 Dark Energy Corruption
		OnPlayerCalcHolyResistance();

		// JAN2011_28 remove negative attachments
		SCARABS_ATTACHED = false;

		CallEventDelayed(1.0f, "activate_stuff");

		if (MyMaxHealth() < 100.0f && MyHealth() > 0.0f && !Truthy(GetVar("G_HELP_ON")))
			OnHelpToggle();

		if (Truthy(GetVar("G_RANDOM_SPAWN")))
			CallEventDelayed(0.1f, "random_spawn");

		// summonpets ent_me
		if (NEW_SPAWN_POS != "NEW_SPAWN_POS")
			CallEventDelayed(0.1f, "tele_spawn");
	}

	// setup_weather
	void PlayerMain_OnSetupWeather()
	{
		if (GetVar("G_CURRENT_WEATHER") == "0")
			return;
		if (ScriptVarOf(ENT_ME, "PLR_WEATHER") == GetVar("G_CURRENT_WEATHER"))
			return;
		CallExternal(ENT_ME, "ext_weather_change", GetVar("G_CURRENT_WEATHER"));
	}

	// do_motd
	void PlayerMain_OnDoMotd()
	{
		MOTD_TXT1 = "";
		MOTD_TXT2 = "";
		MOTD_TXT3 = "";
		MOTD_TXT4 = "";
		MOTD_TXT5 = "";
		MOTD_TXT6 = "";
		MOTD_TXT7 = "";
		SIZE_IDX = 0.0f;
		ConsoleMessage(ENT_ME, Eval("game.cvar.hostname") + " MESSAGE OF THE DAY ===========");
		OnDoMotdLoop();
	}

	// force_motd
	void PlayerMain_OnForceMotd()
	{
		PLR_DID_MOTD = false;
		OnDoMotd();
	}

	// do_motd_loop
	void PlayerMain_OnDoMotdLoop()
	{
		if (PLR_DID_MOTD)
			return;
		string motdLine = LegacyFunction("get_fileline", "motd.txt");
		if (motdLine == "[EOF]")
		{
			PLR_DID_MOTD = true;
			HelpTip(ENT_ME, "generic", "MESSAGE OF THE DAY", MOTD_TXT1, MOTD_TXT2, MOTD_TXT3); // - overflows: MOTD_TXT4 MOTD_TXT5 MOTD_TXT6 MOTD_TXT7
		}
		if (motdLine == "[EOF]")
			return;
		ConsoleMessage(ENT_ME, Text(SIZE_IDX) + " - " + motdLine);
		float newLen = int(motdLine.length());
		if (SIZE_IDX == 0.0f)
			newLen += int(MOTD_TXT1.length());
		if (SIZE_IDX == 1.0f)
			newLen += int(MOTD_TXT2.length());
		if (SIZE_IDX == 2.0f)
			newLen += int(MOTD_TXT3.length());
		if (SIZE_IDX == 3.0f)
			newLen += int(MOTD_TXT4.length());
		if (SIZE_IDX == 4.0f)
			newLen += int(MOTD_TXT5.length());
		if (SIZE_IDX == 5.0f)
			newLen += int(MOTD_TXT6.length());
		if (SIZE_IDX == 6.0f)
			newLen += int(MOTD_TXT7.length());
		if (newLen > 180.0f)
			SIZE_IDX += 1.0f;
		if (SIZE_IDX == 0.0f)
			MOTD_TXT1 = MOTD_TXT1 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 1.0f)
			MOTD_TXT2 = MOTD_TXT2 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 2.0f)
			MOTD_TXT3 = MOTD_TXT3 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 3.0f)
			MOTD_TXT4 = MOTD_TXT4 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 4.0f)
			MOTD_TXT5 = MOTD_TXT5 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 5.0f)
			MOTD_TXT6 = MOTD_TXT6 + Left(motdLine, 180) + " |";
		if (SIZE_IDX == 6.0f)
			MOTD_TXT7 = MOTD_TXT7 + Left(motdLine, 180) + " |";
		CallEventDelayed(0.01f, "do_motd_loop");
	}

	// game_damaged_other
	// test -works - return untested on monsters
	// PARAM1=target_hit PARAM2=dmg //players only?
	string PlayerMain_OnGameDamagedOther_2(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (!PLR_SPECIAL_WEAPON)
			return result;

		if (ScriptVarOf(PLR_ACTIVE_WEAPON, "SPECIAL_WEAPON_TYPE") == "wolf")
		{
			string targName = NameOf(target);
			targName = ToLowerCase(targName);
			if (Contains(targName, "wolf"))
			{
				result = AppendResult(result, "2.0");
				DebugPrint("multi x2");
			}
		}
		return result;
	}

	// delay_to_ms_player_spawn
	void PlayerMain_OnDelayToMsPlayerSpawn()
	{
		LegacyCommand("torandomspawn", ENT_ME);
	}

	// find_ms_player_spawn
	void PlayerMain_OnFindMsPlayerSpawn()
	{
		LegacyCommand("torandomspawn", ENT_ME);
	}

	// player_calc_holy_resistance
	void PlayerMain_OnPlayerCalcHolyResistance()
	{
		// Thothie AUG2010_23 Dark Energy Corruption
		// - players who use dark energy too often are vulnerable to holy magic
		// - past a certain threshold, other side effects ensue
		// dbg player_calc_holy_resistance entered
		float normLevel = 100.0f;
		float darkRatio = Divide(PLR_DARK_LEVEL, Float(GetVar("PLR_DARK_UNHOLY_LEVEL")));
		normLevel *= Ratio(darkRatio, 1, 0);
		if (PLR_DARK_LEVEL > Float(GetVar("PLR_DARK_UNHOLY_LEVEL")))
		{
			normLevel = 0.0f;
			// dbg player_calc_holy_resistance ye_are_evil
			SetProp(ENT_ME, "skin", 2);
		}
		else
		{
			SetProp(ENT_ME, "skin", 1);
		}
		// dbg determine_holyvuln NORM_LEVEL
		ELM_REGISTER_SILENT = true;
		CallExternal(ENT_ME, "ext_register_element", "playr", "holy", normLevel, "player_main");
	}

	// game_arrowmenu
	// optimal debuggary
	// {
	// dbg OPT_DEBUG: player:init game.time
	// }
	// { game_spawn
	// dbg OPT_DEBUG: player:game_spawn game.time
	// }
	// { game_postspawn
	// dbg OPT_DEBUG: player:game_postspawn game.time
	// }
	// { game_player_putinworld
	// dbg OPT_DEBUG: player:game_player_putinworld game.time
	// }
	// <time_last_opened|0=selected> [selected_arrow_id] - activates when player opens arrow menu
	void PlayerMain_OnGameArrowmenu(float timeLastOpened = 0.0f, string selectedArrow = "")
	{
		DebugPrint("game_arrowmenu " + Text(timeLastOpened) + " " + selectedArrow);
		PLR_ARROW_MENU = timeLastOpened;
		if (timeLastOpened == 0.0f)
		{
			PLR_ARROW_ID = selectedArrow;
			// remembers the bolt type so the steam crossbow keeps it after a map change - Dravus
			string ammoName = ItemNameOf(selectedArrow);
			if (StartsWith(ammoName, "proj_bolt"))
				Quest("set", ENT_ME, "sxbow_bolt", ammoName);
		}
		else if (Truthy(GetVar("G_DEVELOPER_MODE")))
			PlayerMessage(ENT_ME, "Selecting ammo...");
	}

	// game_leapback
	// <stamina>
	void PlayerMain_OnGameLeapback(string stamina = "")
	{
		bool exitSub = false;
		bool notNow = false;

		if (!(GameTime() > NEXT_DODGE))
			return;
		if (IsKeyDown(ENT_ME, "forward"))
			return;
		if (!(GameTime() > NEXT_LEAPBACK))
			return;

		if (Truthy(ScriptVarOf(ENT_ME, "PLR_BEAR_MODE")))
			return;

		if (!(SkillOf(ENT_ME, "martialarts") > 15.0f))
			return;
		if (Float(stamina) <= LEAP_BACK_DRAIN)
			PlayerMessageDark(ENT_ME, "Not enough stamina remaing to dodge.");
		if (!(Float(stamina) > LEAP_BACK_DRAIN))
			return;

		if (!IsOnGround(ENT_ME))
		{
			PlayerMessageDark(ENT_ME, "Can't dodge in mid-air...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!Truthy(GetProp(ENT_ME, "canrun")))
			notNow = true;
		if (!CanAttack(ENT_ME))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canjump")))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canmove")))
			notNow = true;
		if (notNow)
		{
			PlayerMessageDark(ENT_ME, "Can't dodge now...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(GetProp(ENT_ME, "ducking")))
			return;

		// //pending new status flag check
		// if ( !$get(ent_me,canmove) )
		// {
		// dplayermessage ent_me Can't dodge now...
		// local EXIT_SUB 1
		// }
		// if !EXIT_SUB
		HelpTip(ENT_ME, "firstleapback", "Congratulations! You can dodge!", "From Martialarts 15+, you can make short backwards dodges by holding shift and the back key.");

		NEXT_DODGE = 0.25f + GameTime();

		NEXT_LEAPBACK = GameTime() + 3.0f;

		LegacyCommand("drainstamina", ENT_ME, LEAP_BACK_DRAIN);
		string viewYawText = Text(ViewAnglesOf(ENT_ME));
		float viewYaw = Vec(viewYawText).y;
		AddVelocity(ENT_ME, RelativePosition(Vector3(0, viewYaw, 0), Vector3(0, -600, 150)), "override");
		ServerPlaySound(4, 10, PLR_SOUND_JAB1);
	}

	// game_leapleft
	// <stamina>
	void PlayerMain_OnGameLeapleft(string stamina = "")
	{
		bool exitSub = false;
		bool notNow = false;

		if (!(GameTime() > NEXT_DODGE))
			return;
		if (IsKeyDown(ENT_ME, "forward"))
			return;
		if (!(GameTime() > NEXT_LEAPLEFT))
			return;
		if (Truthy(ScriptVarOf(ENT_ME, "PLR_BEAR_MODE")))
			return;

		if (!(SkillOf(ENT_ME, "martialarts") > 10.0f))
			return;
		if (Float(stamina) <= LEAP_SIDE_DRAIN)
			PlayerMessageDark(ENT_ME, "Not enough stamina remaing to dodge.");
		if (!(Float(stamina) > LEAP_SIDE_DRAIN))
			return;

		if (!IsOnGround(ENT_ME))
		{
			PlayerMessageDark(ENT_ME, "Can't dodge in mid-air...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!Truthy(GetProp(ENT_ME, "canrun")))
			notNow = true;
		if (!CanAttack(ENT_ME))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canjump")))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canmove")))
			notNow = true;
		if (notNow)
		{
			PlayerMessageDark("ent_me Can't dodge now...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(GetProp(ENT_ME, "ducking")))
			return;

		HelpTip(ENT_ME, "firstleap", "Congratulations! You can dodge!", "From Martialarts 10+, you can make short dodges to the left or right by holding shift with a strafe key.|At 15, you'll be able to leap backwards.");

		NEXT_DODGE = 0.25f + GameTime();

		NEXT_LEAPLEFT = GameTime() + 3.0f;

		LegacyCommand("drainstamina", ENT_ME, LEAP_SIDE_DRAIN);
		string viewYawText = Text(ViewAnglesOf(ENT_ME));
		float viewYaw = Vec(viewYawText).y;
		AddVelocity(ENT_ME, RelativePosition(Vector3(0, viewYaw, 0), Vector3(-600, 0, 180)), "override");
		ServerPlaySound(4, 10, "player/hitground1.wav");
	}

	// game_leapright
	// <stamina>
	void PlayerMain_OnGameLeapright(string stamina = "")
	{
		bool exitSub = false;
		bool notNow = false;

		if (!(GameTime() > NEXT_DODGE))
			return;
		if (IsKeyDown(ENT_ME, "forward"))
			return;
		if (!(GameTime() > NEXT_LEAPRIGHT))
			return;
		if (Truthy(ScriptVarOf(ENT_ME, "PLR_BEAR_MODE")))
			return;

		if (!(SkillOf(ENT_ME, "martialarts") > 10.0f))
			return;
		if (Float(stamina) <= LEAP_SIDE_DRAIN)
			PlayerMessageDark(ENT_ME, "Not enough stamina remaing to dodge.");
		if (!(Float(stamina) > LEAP_SIDE_DRAIN))
			return;

		if (!IsOnGround(ENT_ME))
		{
			PlayerMessageDark(ENT_ME, "Can't dodge in mid-air...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!Truthy(GetProp(ENT_ME, "canrun")))
			notNow = true;
		if (!CanAttack(ENT_ME))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canjump")))
			notNow = true;
		if (!Truthy(GetProp(ENT_ME, "canmove")))
			notNow = true;
		if (notNow)
		{
			PlayerMessageDark(ENT_ME, "Can't dodge now...");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (Truthy(GetProp(ENT_ME, "ducking")))
			return;

		HelpTip(ENT_ME, "firstleap", "Congratulations! You can dodge!", "From Martialarts 10+, you can make short dodges to the left or right by holding shift with a strafe key.|At 15, you'll be able to leap backwards.");

		NEXT_DODGE = 0.25f + GameTime();

		NEXT_LEAPRIGHT = GameTime() + 3.0f;

		LegacyCommand("drainstamina", ENT_ME, LEAP_SIDE_DRAIN);
		string viewYawText = Text(ViewAnglesOf(ENT_ME));
		float viewYaw = Vec(viewYawText).y;
		AddVelocity(ENT_ME, RelativePosition(Vector3(0, viewYaw, 0), Vector3(600, 0, 180)), "override");
		ServerPlaySound(4, 10, "player/hitground1.wav");
	}

	// game_applyeffect
	// <applyeffect|applyeffect> <target> <effectscript> [params...]
	string PlayerMain_OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "")
	{
		bool abort = false;
		string result = "";
		if (Truthy(ScriptFlag(ENT_ME, "spider_resist", "type_exists")))
		{
			if (Contains(ItemNameOf(attacker), "spid"))
				abort = true;
			if (Contains(ItemNameOf(caller), "spid"))
				abort = true;
			if (abort)
			{
				// dbg game_applyeffect abort spider applyeffect [ p2 $get(PARAM2,name) p5 $get(PARAM5,itemname) ]
				result = AppendResult(result, "abort");
				bool didAbort = true;
			}
		}
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// activate_stuff
	void OnActivateStuff()
	{
		PlayerServerDmgpoints_OnActivateStuff(); // player/server/dmgpoints
		PlayerMain_OnActivateStuff();
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayerServerDmgpoints_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // player/server/dmgpoints
		ElementResist_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // player/server/element_resist
		PlayerMain_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, PlayerServerDmgpoints_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PlayerMain_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, PlayerMain_OnGameDamagedOther_2(target, damage, damageType, damageEvent));
		return result;
	}

	void OnGameSpawn(string playerRace = "", string playerGender = "") { PlayerMain_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnRandomSpawn() { PlayerMain_OnRandomSpawn(); } // random_spawn
	void OnTeleSpawn() { PlayerMain_OnTeleSpawn(); } // tele_spawn
	void OnBeamFx() { PlayerMain_OnBeamFx(); } // beam_fx
	void OnGameThink() { PlayerMain_OnGameThink(); } // game_think
	void OnGameJump() { PlayerMain_OnGameJump(); } // game_jump
	void OnGameJumpLand() { PlayerMain_OnGameJumpLand(); } // game_jump_land
	void OnWarpOut() { PlayerMain_OnWarpOut(); } // warp_out
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f) { PlayerMain_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); } // game_parry
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return PlayerMain_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnDisplayHealth() { PlayerMain_OnDisplayHealth(); } // display_health
	void OnConsoleHealthToggle(string showHealth = "") { PlayerMain_OnConsoleHealthToggle(showHealth); } // console_health_toggle
	void OnHealthbarToggle(string displayMode = "") { PlayerMain_OnHealthbarToggle(displayMode); } // healthbar_toggle
	void OnManaDrain() { PlayerMain_OnManaDrain(); } // mana_drain
	void OnBuildBar(string barLength = "") { PlayerMain_OnBuildBar(barLength); } // build_bar
	void OnGameLearnskill(string skill = "", string subSkill = "", float value = 0.0f) { PlayerMain_OnGameLearnskill(skill, subSkill, value); } // game_learnskill
	void OnResetSendDmgDelay() { PlayerMain_OnResetSendDmgDelay(); } // reset_send_dmg_delay
	void OnGameTransitionEntered(string transDesc = "", string destMap = "", string localSpawn = "", string destSpawn = "") { PlayerMain_OnGameTransitionEntered(transDesc, destMap, localSpawn, destSpawn); } // game_transition_entered
	void OnGameXpgain(float xp = 0.0f, CBaseEntity@ monster = null) { PlayerMain_OnGameXpgain(xp, monster); } // game_xpgain
	void OnGiveMapIntro() { PlayerMain_OnGiveMapIntro(); } // give_map_intro
	void OnPetNotice() { PlayerMain_OnPetNotice(); } // pet_notice
	void OnGiveMapDiff() { PlayerMain_OnGiveMapDiff(); } // give_map_diff
	void OnHelpToggle() { PlayerMain_OnHelpToggle(); } // help_toggle
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return PlayerMain_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage
	void OnPlrAddDark(float amount = 0.0f) { PlayerMain_OnPlrAddDark(amount); } // plr_add_dark
	void OnGameHelptip(string title = "", string tip = "") { PlayerMain_OnGameHelptip(title, tip); } // game_helptip
	void OnExtShowHbarMonster(CBaseEntity@ targetToShow = null, int forceShow = 0) { PlayerMain_OnExtShowHbarMonster(targetToShow, forceShow); } // ext_show_hbar_monster
	void OnShowHbarPlayer(CBaseEntity@ player = null) { PlayerMain_OnShowHbarPlayer(player); } // show_hbar_player
	void OnResetDisplayPbarDelay() { PlayerMain_OnResetDisplayPbarDelay(); } // reset_display_pbar_delay
	void OnGameTargetedByPlayer(CBasePlayer@ player = null) { PlayerMain_OnGameTargetedByPlayer(player); } // game_targeted_by_player
	void OnResetHbarDelay() { PlayerMain_OnResetHbarDelay(); } // reset_hbar_delay
	void OnGamePartyJoin(string partyName = "") { PlayerMain_OnGamePartyJoin(partyName); } // game_party_join
	void OnGamePartyLeave() { PlayerMain_OnGamePartyLeave(); } // game_party_leave
	void OnChristmasMode() { PlayerMain_OnChristmasMode(); } // christmas_mode
	void OnGamePlayerGotFromStore(CBaseEntity@ item = null, CBaseEntity@ vendor = null) { PlayerMain_OnGamePlayerGotFromStore(item, vendor); } // game_player_got_from_store
	void OnHpMaxWarn() { PlayerMain_OnHpMaxWarn(); } // hp_max_warn
	void OnHpMaxWarn2() { PlayerMain_OnHpMaxWarn2(); } // hp_max_warn2
	void OnHpMaxWarn3() { PlayerMain_OnHpMaxWarn3(); } // hp_max_warn3
	void OnHpMaxWarn4() { PlayerMain_OnHpMaxWarn4(); } // hp_max_warn4
	void OnHpMaxWarn5() { PlayerMain_OnHpMaxWarn5(); } // hp_max_warn5
	void OnGameRespawn() { PlayerMain_OnGameRespawn(); } // game_respawn
	void OnGamePlayerPutinworld() { PlayerMain_OnGamePlayerPutinworld(); } // game_player_putinworld
	void OnSetupWeather() { PlayerMain_OnSetupWeather(); } // setup_weather
	void OnDoMotd() { PlayerMain_OnDoMotd(); } // do_motd
	void OnForceMotd() { PlayerMain_OnForceMotd(); } // force_motd
	void OnDoMotdLoop() { PlayerMain_OnDoMotdLoop(); } // do_motd_loop
	void OnDelayToMsPlayerSpawn() { PlayerMain_OnDelayToMsPlayerSpawn(); } // delay_to_ms_player_spawn
	void OnFindMsPlayerSpawn() { PlayerMain_OnFindMsPlayerSpawn(); } // find_ms_player_spawn
	void OnPlayerCalcHolyResistance() { PlayerMain_OnPlayerCalcHolyResistance(); } // player_calc_holy_resistance
	void OnGameArrowmenu(float timeLastOpened = 0.0f, string selectedArrow = "") { PlayerMain_OnGameArrowmenu(timeLastOpened, selectedArrow); } // game_arrowmenu
	void OnGameLeapback(string stamina = "") { PlayerMain_OnGameLeapback(stamina); } // game_leapback
	void OnGameLeapleft(string stamina = "") { PlayerMain_OnGameLeapleft(stamina); } // game_leapleft
	void OnGameLeapright(string stamina = "") { PlayerMain_OnGameLeapright(stamina); } // game_leapright
	string OnGameApplyeffect(string command = "", CBaseEntity@ caller = null, string effect = "", string value = "", string attacker = "", string value2 = "", string value3 = "", string value4 = "", string value5 = "") { return PlayerMain_OnGameApplyeffect(command, caller, effect, value, attacker, value2, value3, value4, value5); } // game_applyeffect
	void OnAnimateDeath() {} // animate_death
	void OnEndDemonBlood() {} // end_demon_blood
	void OnExtSetbodytype(string bodyType = "", string armorId = "") {} // ext_setbodytype
	void OnSpiderProtectEnd() {} // spider_protect_end

	// This file's events and timers by their .script names
	bool PlayerMain_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "activate_stuff") { OnActivateStuff(); return true; }
		if (name == "beam_fx") { OnBeamFx(); return true; }
		if (name == "build_bar") { OnBuildBar(Param(params, 0)); return true; }
		if (name == "christmas_mode") { OnChristmasMode(); return true; }
		if (name == "console_health_toggle") { OnConsoleHealthToggle(Param(params, 0)); return true; }
		if (name == "delay_to_ms_player_spawn") { OnDelayToMsPlayerSpawn(); return true; }
		if (name == "display_health") { OnDisplayHealth(); return true; }
		if (name == "do_motd") { OnDoMotd(); return true; }
		if (name == "do_motd_loop") { OnDoMotdLoop(); return true; }
		if (name == "ext_show_hbar_monster") { OnExtShowHbarMonster(EntityParam(params, 0), Int(Param(params, 1))); return true; }
		if (name == "find_ms_player_spawn") { OnFindMsPlayerSpawn(); return true; }
		if (name == "force_motd") { OnForceMotd(); return true; }
		if (name == "game_applyeffect") { Return(OnGameApplyeffect(Param(params, 0), EntityParam(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6), Param(params, 7), Param(params, 8))); return true; }
		if (name == "game_arrowmenu") { OnGameArrowmenu(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_helptip") { OnGameHelptip(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_jump") { OnGameJump(); return true; }
		if (name == "game_jump_land") { OnGameJumpLand(); return true; }
		if (name == "game_leapback") { OnGameLeapback(Param(params, 0)); return true; }
		if (name == "game_leapleft") { OnGameLeapleft(Param(params, 0)); return true; }
		if (name == "game_leapright") { OnGameLeapright(Param(params, 0)); return true; }
		if (name == "game_learnskill") { OnGameLearnskill(Param(params, 0), Param(params, 1), Float(Param(params, 2))); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_party_join") { OnGamePartyJoin(Param(params, 0)); return true; }
		if (name == "game_party_leave") { OnGamePartyLeave(); return true; }
		if (name == "game_player_got_from_store") { OnGamePlayerGotFromStore(EntityParam(params, 0), EntityParam(params, 1)); return true; }
		if (name == "game_player_putinworld") { OnGamePlayerPutinworld(); return true; }
		if (name == "game_respawn") { OnGameRespawn(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "game_think") { OnGameThink(); return true; }
		if (name == "game_transition_entered") { OnGameTransitionEntered(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_xpgain") { OnGameXpgain(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		if (name == "give_map_diff") { OnGiveMapDiff(); return true; }
		if (name == "give_map_intro") { OnGiveMapIntro(); return true; }
		if (name == "healthbar_toggle") { OnHealthbarToggle(Param(params, 0)); return true; }
		if (name == "help_toggle") { OnHelpToggle(); return true; }
		if (name == "hp_max_warn") { OnHpMaxWarn(); return true; }
		if (name == "hp_max_warn2") { OnHpMaxWarn2(); return true; }
		if (name == "hp_max_warn3") { OnHpMaxWarn3(); return true; }
		if (name == "hp_max_warn4") { OnHpMaxWarn4(); return true; }
		if (name == "hp_max_warn5") { OnHpMaxWarn5(); return true; }
		if (name == "mana_drain") { OnManaDrain(); return true; }
		if (name == "pet_notice") { OnPetNotice(); return true; }
		if (name == "player_calc_holy_resistance") { OnPlayerCalcHolyResistance(); return true; }
		if (name == "plr_add_dark") { OnPlrAddDark(Float(Param(params, 0))); return true; }
		if (name == "random_spawn") { OnRandomSpawn(); return true; }
		if (name == "reset_display_pbar_delay") { OnResetDisplayPbarDelay(); return true; }
		if (name == "reset_hbar_delay") { OnResetHbarDelay(); return true; }
		if (name == "reset_send_dmg_delay") { OnResetSendDmgDelay(); return true; }
		if (name == "setup_weather") { OnSetupWeather(); return true; }
		if (name == "show_hbar_player") { OnShowHbarPlayer(EntityParam(params, 0)); return true; }
		if (name == "tele_spawn") { OnTeleSpawn(); return true; }
		if (name == "warp_out") { OnWarpOut(); return true; }
		if (name == "PlayerMain_Timer") { PlayerMain_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "player/player_main"]
shared class PlayerMainScript : ValidSpawnNewScript, PlayerMain, PlayerServerDmgpoints, ElementResist
{
	// Variables declared by included files, with the value they start with in this script
	PlayerMainScript()
	{
		FREQ_AFK_CHECK = 60.0f;
		LEAP_SIDE_DRAIN = 30;
		LEAP_BACK_DRAIN = 60;
		HBAR_FRAMES = 12;
		SOUND_LEVELUP1 = "magic/converted_EnchP01.wav";
		LEVELUP_SCRIPT = "player/player_cl_effects_levelup";
		PLR_DARK_LEVEL_LOSS_RATE = 50;
		PLR_MAX_DARK_LEVEL = 50000;
		SOUND_BEAR_STRUCK1 = "monsters/bear/c_bear_hit1.wav";
		SOUND_BEAR_STRUCK2 = "monsters/bear/c_bear_hit2.wav";
		SOUND_BEAR_STRUCK3 = "monsters/bear/c_bear_no.wav";
		PLR_RESIST_RESET = "1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0;1.0"; // from player/server/element_resist
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("health_bar.spr");
		Precache("human/reference.mdl");
		Precache("dwarf/reference.mdl");
		Precache("player/hitground1.wav");
		CallEventDelayed(FREQ_AFK_CHECK, "PlayerMain_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PlayerMain_FirstThink();
		PlayerServerDmgpoints_FirstThink();
		ElementResist_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return PlayerMain_DispatchEvent(name, params)
			|| PlayerServerDmgpoints_DispatchEvent(name, params)
			|| ElementResist_DispatchEvent(name, params)
			|| ValidSpawnNewScript::DispatchEvent(name, params);
	}
}
