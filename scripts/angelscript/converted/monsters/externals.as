#pragma context server

// Converted from monsters/externals.script by msc_transpiler.
// Called against montsters exernally or via ms_npcscript

#include "runtime/ScriptEntity.as"
// #include test_scripts/npc_externals - not found (optional)
// #include $currentmap_npc_externals - not found (optional)
#include "converted/dq/externals/dq_monster_externals.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class MonstersExternals
{
	// Constants
	float NPC_FADE_IN_SPEED = 0.1f;

	// Variables (an unset .script variable reads as its own name)
	float EXT_DEMON_BLOOD_RATIO = 0.0f;
	string MY_OLD_NAME = "MY_OLD_NAME";
	string NPC_GLOW = "NPC_GLOW";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_OVERRIDE_DEATH = false;
	bool NPC_QUED_FOR_DEATH = false;
	bool NPC_SILENT_DEATH = false;
	float SKEL_RESPAWN_TIMES = 0.0f;
	string BASE_FRAMERATE = "BASE_FRAMERATE";
	string NPCATK_TARGET = "NPCATK_TARGET";
	string ICE_CAGE_OLD_CANT_TURN = "ICE_CAGE_OLD_CANT_TURN";
	string ICE_CAGE_OLD_STUCK_CHECK = "ICE_CAGE_OLD_STUCK_CHECK";
	string ICE_CAGE_OLD_ROAM = "ICE_CAGE_OLD_ROAM";
	bool FREEZE_WAS_SUSPEND = false;
	bool I_R_FROZEN = false;
	bool IN_ICECAGE = false;
	string CANT_TURN = "CANT_TURN";
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float G_ORC_TALLY = 0.0f;
	float G_ROGUE_TALLY = 0.0f;
	float G_DEMON_TALLY = 0.0f;
	float G_UNDEAD_TALLY = 0.0f;
	float G_SPIDER_TALLY = 0.0f;
	float G_HUMAN_TALLY = 0.0f;
	float G_HGUARD_TALLY = 0.0f;
	float G_ENEMY_TALLY = 0.0f;
	float MAKE_NOISE = 0.0f;
	bool DEMON_BLOOD = false;
	string NPC_ADJ_FLAGS = "NPC_ADJ_FLAGS";
	bool HIT_BY_MANABALL = false;
	string EXTPLAY_SOUND = "EXTPLAY_SOUND";
	float STRUCK_BY_HOLY = 0.0f;
	bool SKELE_TURNED = false;
	bool STRUCK_HOLY = false;
	bool EXT_FADE_ON_DEATH = false;
	string FLEE_DISTANCE = "FLEE_DISTANCE";
	string CAN_FLEE = "CAN_FLEE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	string EFFECT_FREEZE_AMT = "EFFECT_FREEZE_AMT";
	float BASE_MOVESPEED = 0.0f;
	bool NPC_CRITICAL = false;
	bool NPC_GHOST = false;
	Vector3 NPC_WINK_IN_POINT = Vector3();
	bool NPC_WINKED_OUT = false;
	bool NPC_IS_BOSS = false;
	string NPC_BOSS_KNOWS = "NPC_BOSS_KNOWS";
	string NPC_BOSS_KNOWS_AMTS = "NPC_BOSS_KNOWS_AMTS";
	bool NPC_NO_SIEGE_HUNT = false;
	string PLR_SCAN_TOKEN = "PLR_SCAN_TOKEN";
	float NPC_EXP_REDUCT = 0.0f;
	bool NPC_NO_DROPS = false;
	int DROP_GOLD = 0;
	string DROP_ITEM1_CHANCE = "DROP_ITEM1_CHANCE";
	string DROP_ITEM2_CHANCE = "DROP_ITEM2_CHANCE";
	string DROP_ITEM3_CHANCE = "DROP_ITEM3_CHANCE";
	string DROP_ITEM4_CHANCE = "DROP_ITEM4_CHANCE";
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string PLR_SCAN_TOKEN_SORTED = "PLR_SCAN_TOKEN_SORTED";
	bool NPC_NO_PLAYER_DMG = false;
	string NPC_ORG_WIDTH = "NPC_ORG_WIDTH";
	string NPC_ORG_HEIGHT = "NPC_ORG_HEIGHT";
	int MONSTER_WIDTH = 0;
	float NPC_MODEL_SCALED = 0.0f;
	bool NPC_USES_HANDLE_EVENTS = false;
	string NPC_ORG_BASE_MOVESPEED = "NPC_ORG_BASE_MOVESPEED";
	string NPC_ORG_RANGE = "NPC_ORG_RANGE";
	string NPC_ORG_HITRANGE = "NPC_ORG_HITRANGE";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string NPC_SET_RANGE = "NPC_SET_RANGE";
	float NPC_SET_RANGE_RATIO = 0.0f;
	bool NPC_ATTACK_UNTIL_SPOTTED = false;
	float AS_ATTACKING = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	bool NPC_FADEIN_SET = false;
	float NPC_RENDER_AMT = 0.0f;
	int NPC_RENDER_MODE = 0;
	int NPC_FADEIN_RATE = 0;
	bool NO_STEP_ADJ = false;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	bool NPC_IS_TURRET = false;
	string EXT_DEBUG_PARAM = "EXT_DEBUG_PARAM";
	bool EXT_DBG_LOOP_ON = false;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	bool NPC_DO_SPAWN_SOUND = false;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	bool NPC_NO_ROAM = false;
	bool NPC_FORCE_ROAM = false;
	bool NPC_SELF_ADJUST = false;
	string NPC_ADJ_DOWN = "NPC_ADJ_DOWN";
	bool NPC_SELF_ADJUST_NOAVG = false;
	bool NPC_DOT_POISON = false;
	float NPC_DOT_POISON_RATIO = 0.0f;
	bool NPC_DOT_COLD = false;
	float NPC_DOT_COLD_RATIO = 0.0f;
	bool NPC_DOT_FIRE = false;
	float NPC_DOT_FIRE_RATIO = 0.0f;
	bool NPC_DOT_LIGHTNING = false;
	float NPC_DOT_LIGHTNING_RATIO = 0.0f;
	bool NPC_NO_AUTO_ACTIVATE = false;
	int NPC_NO_AGRO = 0;
	int NPC_SPRITE_IN = 0;
	bool NPC_SUMMON = false;
	bool NPC_DID_DEATH = false;
	bool NPC_XPTR = false;
	float NPC_XPTR_TIME = 0.0f;
	float NPC_XPTR_MAXXP = 0.0f;
	bool NPC_CUSTOM_COMBAT_MUSIC = false;
	string NPC_CMUSIC_FILE = "NPC_CMUSIC_FILE";
	float NPC_DMG_MULTI = 0.0f;
	float NPC_HP_MULTI = 0.0f;
	bool NPC_DIE_NT_FIRST_RUN = false;
	float NPC_DIE_NT_NEXT_CHECK = 0.0f;
	float NPC_DIE_NT_BASE = 0.0f;
	float NPC_LAST_SUICDE_ABORT = 0.0f;
	bool NPC_SILENT_SUICIDE = false;
	bool NPC_INVISIBLE_SUICIDE = false;
	bool NPC_NO_COUNT = false;
	float NPC_MOVE_SPEED_ADJ = 0.0f;
	bool NPC_TELEHUNT = false;
	int NPC_TELEHUNTER_FX = 0;
	float NPC_TELEHUNT_FREQ = 0.0f;
	bool NPC_TELEHUNT_RANDOM = false;
	string NPC_CUSTOM_SKIN = "NPC_CUSTOM_SKIN";
	float NPC_DO_ON_SPOT = 0.0f;
	string NPC_SAY_ON_SPOT = "NPC_SAY_ON_SPOT";
	float NPC_DO_ON_DIE = 0.0f;
	string NPC_SAY_ON_DIE = "NPC_SAY_ON_DIE";
	bool NPC_DUMP_XP = false;
	string NEXT_CIRCLE_HEAL = "NEXT_CIRCLE_HEAL";
	string NPC_DELAY_TARGET = "NPC_DELAY_TARGET";
	bool IS_BLOODLESS = false;

	// unnamed block (first think)
	void MonstersExternals_FirstThink()
	{
		EXT_DEMON_BLOOD_RATIO = 5.0f;
	}

	// orc_race
	// Race changes, to be called from ms_npcscript
	void MonstersExternals_OnOrcRace()
	{
		SetRace("orc");
	}

	// demon_race
	void MonstersExternals_OnDemonRace()
	{
		SetRace("demon");
	}

	// undead_race
	void MonstersExternals_OnUndeadRace()
	{
		SetRace("undead");
	}

	// human_race
	void MonstersExternals_OnHumanRace()
	{
		SetRace("human");
	}

	// spider_race
	void MonstersExternals_OnSpiderRace()
	{
		SetRace("spider");
	}

	// wildanimal_race
	void MonstersExternals_OnWildanimalRace()
	{
		SetRace("wildanimal");
	}

	// hated_race
	void MonstersExternals_OnHatedRace()
	{
		SetRace("hated");
	}

	// beloved_race
	void MonstersExternals_OnBelovedRace()
	{
		SetRace("beloved");
	}

	// evil_race
	void MonstersExternals_OnEvilRace()
	{
		SetRace("evil");
	}

	// good_race
	void MonstersExternals_OnGoodRace()
	{
		SetRace("good");
	}

	// vermin_race
	void MonstersExternals_OnVerminRace()
	{
		SetRace("vermin");
	}

	// rogue_race
	void MonstersExternals_OnRogueRace()
	{
		SetRace("rogue");
	}

	// hguard_race
	void MonstersExternals_OnHguardRace()
	{
		SetRace("hguard");
	}

	// neutral_race
	void MonstersExternals_OnNeutralRace()
	{
		SetRace("neutral");
	}

	// lightning_immune
	// Immune changes, to be used from ms_npcscript, item, or spell
	void MonstersExternals_OnLightningImmune()
	{
		SetDamageTaken("lightning", 0);
	}

	// fire_immune
	void MonstersExternals_OnFireImmune()
	{
		SetDamageTaken("fire", 0);
	}

	// poison_immune
	void MonstersExternals_OnPoisonImmune()
	{
		SetDamageTaken("poison", 0);
	}

	// cold_immune
	void MonstersExternals_OnColdImmune()
	{
		SetDamageTaken("cold", 0);
	}

	// normal_immune
	void MonstersExternals_OnNormalImmune()
	{
		SetDamageTaken("cold", 1);
		SetDamageTaken("fire", 1);
		SetDamageTaken("lightning", 1);
		SetDamageTaken("poison", 1);
	}

	// fifty_armor
	// Armor Changes (to be used by ms_npcscript)
	void MonstersExternals_OnFiftyArmor()
	{
		SetDamageTaken("all", 0.5f);
	}

	// eighty_armor
	void MonstersExternals_OnEightyArmor()
	{
		SetDamageTaken("all", 0.2f);
	}

	// no_armor
	void MonstersExternals_OnNoArmor()
	{
		SetDamageTaken("all", 1);
	}

	// weakened_armor
	void MonstersExternals_OnWeakenedArmor()
	{
		SetDamageTaken("all", 2);
	}

	// make_invulnerable
	// Invincible Toggle (to be used by ms_npcscript)
	void MonstersExternals_OnMakeInvulnerable()
	{
		MY_OLD_NAME = NameOf(ENT_ME);
		string myNewName = "Invincible " + MY_OLD_NAME;
		SetName(myNewName);
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 64, -1, 0);
		NPC_GLOW = Text(Vector3(255, 255, 255));
		SetInvincible(true);
	}

	// make_vulnerable
	void MonstersExternals_OnMakeVulnerable()
	{
		if (MY_OLD_NAME != "MY_OLD_NAME")
			SetName(MY_OLD_NAME);
		SetInvincible(false);
		Effect("glow", ENT_ME, Vector3(255, 255, 255), 128, 1, 1);
		NPC_GLOW = "NPC_GLOW";
	}

	// add_10_health
	// Add HP (to be used by ms_npcscript)
	void MonstersExternals_OnAdd10Health()
	{
		float currentHp = HealthOf(ENT_ME) + 10.0f;
		SetHealth(currentHp);
	}

	// add_100_health
	void MonstersExternals_OnAdd100Health()
	{
		float currentHp = HealthOf(ENT_ME) + 100.0f;
		SetHealth(currentHp);
	}

	// add_500_health
	void MonstersExternals_OnAdd500Health()
	{
		float currentHp = HealthOf(ENT_ME) + 500.0f;
		SetHealth(currentHp);
	}

	// add_1000_health
	void MonstersExternals_OnAdd1000Health()
	{
		float currentHp = HealthOf(ENT_ME) + 1000.0f;
		SetHealth(currentHp);
	}

	// double_health
	void MonstersExternals_OnDoubleHealth()
	{
		string myOldhpName = NameOf(ENT_ME);
		string myNewhpName = "Strong " + myOldhpName;
		SetName(myNewhpName);

		float currentHp = HealthOf(ENT_ME) * 2.0f;
		SetHealth(currentHp);
	}

	// quad_health
	void MonstersExternals_OnQuadHealth()
	{
		string myOldhpName = NameOf(ENT_ME);
		string myNewhpName = "Very Strong " + myOldhpName;
		SetName(myNewhpName);

		float currentHp = HealthOf(ENT_ME) * 4.0f;
		SetHealth(currentHp);
	}

	// half_health
	void MonstersExternals_OnHalfHealth()
	{
		string myOldhpName = NameOf(ENT_ME);
		string myNewhpName = "Weakened " + myOldhpName;
		SetName(myNewhpName);

		NPC_GIVE_EXP = Divide(NPC_GIVE_EXP, 2.0f); // Thothie FEB2009 - reduce XP value for nerfed monster
		SetSkillLevel(NPC_GIVE_EXP);

		float currentHp = HealthOf(ENT_ME) * 0.5f;
		SetHealth(currentHp);
	}

	// npc_fade_away
	void MonstersExternals_OnNpcFadeAway()
	{
		// not always monster spawn friendly
		SetAlive(false);
		DeleteEntity(ENT_ME, "fade");
	}

	// go_roam
	void MonstersExternals_OnGoRoam()
	{
		SetRoam(true);
	}

	// no_roam
	void MonstersExternals_OnNoRoam()
	{
		SetRoam(false);
	}

	// set_stun_prot
	void MonstersExternals_OnSetStunProt(float stunProtection = 0.0f)
	{
		SetDamageTaken("stun", stunProtection);
	}

	// npc_suicide
	void MonstersExternals_OnNpcSuicide(string suicideMode = "")
	{
		bool exitSub = false;

		if (!IsAlive(ENT_ME))
			return;

		if (Truthy(GetVar("I_R_COMPANION"))) // never, ever, slay companions (if you need to, make new external)
			return;

		float sinceSpawn = GameTime() - Float(GetVar("NPC_SPAWN_TIME"));

		// if ( NPC_QUED_FOR_DEATH ) local PARAM1 dienow
		if (sinceSpawn < 2.0f)
		{
			if (suicideMode == "dienow")
			{
				SetAnimFrameRate(0);
				SetAnimMoveSpeed(0);
				NPC_OVERRIDE_DEATH = true;
				DeleteEntity(ENT_ME, "fade");
				exitSub = true;
			}
			else
			{
				NPC_QUED_FOR_DEATH = true;
				CallEventDelayed(2.1f, "npc_suicide");
				DebugPrint("npc_suicide - not_ready_to_die - qued for death");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (suicideMode == "no_pets" && Truthy(GetVar("I_R_PET")))
			exitSub = true;

		if (suicideMode == "only_bad")
		{
			if (RaceOf(ENT_ME) == "human")
				exitSub = true;
			if (RaceOf(ENT_ME) == "hguard")
				exitSub = true;
			if (RaceOf(ENT_ME) == "beloved")
				exitSub = true;
		}
		if (exitSub)
			return;

		if (NPC_SILENT_SUICIDE)
			NPC_SILENT_DEATH = true;
		if (NPC_INVISIBLE_SUICIDE)
			SetOrigin(ENT_ME, Vector3(20000, -20000, -20000));

		SetInvincible(false);
		SetRace("hated");
		SKEL_RESPAWN_TIMES = 99.0f;
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
	}

	// freeze_solid_start
	// newer
	// PARAM1 = duration to freeze PARAM2 = attacker
	void MonstersExternals_OnFreezeSolidStart(string freezeDuration = "", string attacker = "")
	{
		// this is to tell monsters that change their move/anim speeds not to do so while frozen
		if (BASE_FRAMERATE == "BASE_FRAMERATE")
			BASE_FRAMERATE = "1.0";

		if (NPCATK_TARGET == "unset")
			NPCATK_TARGET = attacker;

		ICE_CAGE_OLD_CANT_TURN = CANT_TURN;
		ICE_CAGE_OLD_STUCK_CHECK = NO_STUCK_CHECKS;
		ICE_CAGE_OLD_ROAM = GetProp(ENT_ME, "roam");
		DebugPrint("freeze_solid_start roamstate " + ICE_CAGE_OLD_ROAM);

		FREEZE_WAS_SUSPEND = Truthy(GetVar("SUSPEND_AI"));
		if (!Truthy(GetVar("SUSPEND_AI")))
			OnNpcatkSuspendAi(freezeDuration);

		I_R_FROZEN = true;
		IN_ICECAGE = true;
		CANT_TURN = "1";
		NO_STUCK_CHECKS = "1";
		SetRoam(false);

		SetAnimFrameRate(0.0001f);

		// setanim.movespeed 0
		CallEventOrDelay(freezeDuration, "freeze_solid_end");
	}

	// freeze_solid_end
	// <unfroze_early:0|1>
	void MonstersExternals_OnFreezeSolidEnd(int unfrozeEarly = 0)
	{
		DebugPrint("thaw");
		if (!I_R_FROZEN)
			return;

		if (unfrozeEarly == 1 && !FREEZE_WAS_SUSPEND)
			OnNpcatkResumeAi();

		I_R_FROZEN = false;
		IN_ICECAGE = false;
		CANT_TURN = ICE_CAGE_OLD_CANT_TURN;
		NO_STUCK_CHECKS = ICE_CAGE_OLD_STUCK_CHECK;
		SetRoam(Truthy(ICE_CAGE_OLD_ROAM));
		SetAnimFrameRate(Float(BASE_FRAMERATE));
		// setanim.movespeed BASE_MOVESPEED
		PlayAnim("break");
		if (Truthy(GetVar("NEW_AI")))
		{
			if (NPCATK_TARGET != "unset")
				SetMoveDest(NPCATK_TARGET, GetVar("ATTACK_MOVERANGE"));
		}
		else if (IsAlive(GetVar("HUNT_LASTTARGET")))
			SetMoveDest(GetVar("HUNT_LASTTARGET"), GetVar("MOVE_RANGE"));
	}

	// double_unfreeze
	void MonstersExternals_OnDoubleUnfreeze()
	{
		DebugPrint("double_unfreeze");
		PlayAnim("critical", GetVar("ANIM_ATTACK")); // cant seem to get them moving again ><
	}

	// tally_race
	// PARAM1 = race to check (set all these G_'s 0 before calling)
	void MonstersExternals_OnTallyRace()
	{
		if (Eval("game.monster.race") == "orc")
			G_ORC_TALLY += 1.0f;
		if (Eval("game.monster.race") == "rogue")
			G_ROGUE_TALLY += 1.0f;
		if (Eval("game.monster.race") == "demon")
			G_DEMON_TALLY += 1.0f;
		if (Eval("game.monster.race") == "undead")
			G_UNDEAD_TALLY += 1.0f;
		if (Eval("game.monster.race") == "spider")
			G_SPIDER_TALLY += 1.0f;
		if (Eval("game.monster.race") == "human")
			G_HUMAN_TALLY += 1.0f;
		if (Eval("game.monster.race") == "hguard")
			G_HGUARD_TALLY += 1.0f;
	}

	// tally_enemy
	// PARAM1 = npc to check (setvarg G_ENEMY_TALLY 0 before calling)
	void MonstersExternals_OnTallyEnemy(string npc = "")
	{
		if (RelationshipOf(ENT_ME, npc) != "enemy")
			return;
		G_ENEMY_TALLY += 1.0f;
	}

	// send_damage
	// same params as do damage
	void MonstersExternals_OnSendDamage(string target = "", string mode = "", string damage = "", string percent = "", string attacker = "", string effect = "", string flags = "")
	{
		// temporary debug
		// if ( !$get(PARAM1,isalive) )
		// {
		// local OUT_PAR1 PARAM1
		// callevent debug_beam OUT_PAR1 PARAM2 (255,0,0)
		// }
		// if !SEND_DMG_DELAY
		// setvard SEND_DMG_DELAY 1
		// callevent 0.2 reset_send_dmg_delay
		// //dbg send_damage PARAM1 PARAM2 PARAM3 PARAM4 PARAM5 PARAM6 PARAM7
		DoDamage(target, mode, damage, percent, attacker, effect, flags);
	}

	// demon_blood
	// PARAM1 = ratio to increase dmg (def 5.0)
	void MonstersExternals_OnDemonBlood(string damageRatio = "")
	{
		if (!damageRatio.isEmpty() && Float(damageRatio) > 1.0f)
			EXT_DEMON_BLOOD_RATIO = Float(damageRatio);

		PlaySound(0, 10, "monsters/troll/trollidle2.wav"); // precache?

		MAKE_NOISE = 2.0f;
		DEMON_BLOOD = true;

		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "demon_blood");

		CallEventDelayed(1.0f, "demon_blood_loop");
	}

	// demon_blood_loop
	void MonstersExternals_OnDemonBloodLoop()
	{
		if (!DEMON_BLOOD)
			return;

		Effect("glow", ENT_ME, Vector3(255, 0, 0), 256, 1.9f, 1.9f);

		if (!(MyHealth() > 11.0f))
			return;

		CallEventDelayed(2.0f, "demon_blood_loop");

		MAKE_NOISE += 1.0f;
		if (MAKE_NOISE > 5.0f)
		{
			PlayRandomSound(0, 10, "monsters/troll/trollidle2.wav", "monsters/troll/trollidle.wav");
			MAKE_NOISE = 0.0f;
		}

		if (!Truthy(GetVar("DEMON_NOHP_LOSS")))
			GiveHealth("DEMON_BLOOD_LOSS");
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 32, 10, 1, 32);
		if (MAKE_NOISE > 0.0f)
			PlaySound(0, 10, "player/heartbeat_noloop.wav");
		DEMON_BLOOD = true;
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg
	string MonstersExternals_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!DEMON_BLOOD)
			return result;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return result;

		result = AppendResult(result, Text(EXT_DEMON_BLOOD_RATIO));

		// applyeffect ent_laststruck effects/generic_damage DEMON_LEVEL $get(ent_me,id) 1 magic
		// setdmg does not work here
		// local IN_DMG PARAM2
		// add IN_DMG DEMON_LEVEL
		// setdmg dmg IN_DMG
		// dbg game_damaged_other DEMON_LEVEL
		PlayRandomSound(0, 10, "monsters/troll/trollpain.wav", "monsters/troll/trollattack.wav");
		return result;
	}

	// ext_hit_manaball
	void MonstersExternals_OnExtHitManaball()
	{
		// stop rapid damage stack from player manaballs
		if (HIT_BY_MANABALL)
			return;
		HIT_BY_MANABALL = true;
		CallEventDelayed(1.0f, "reset_hit_by_manaball");
	}

	// reset_hit_by_manaball
	void MonstersExternals_OnResetHitByManaball()
	{
		HIT_BY_MANABALL = false;
	}

	// ext_playsound_kiss
	void MonstersExternals_OnExtPlaysoundKiss(int channel = 0, int volume = 0, string soundFile = "")
	{
		PlaySound(channel, volume, soundFile);
	}

	// ext_svplaysound_kiss
	void MonstersExternals_OnExtSvplaysoundKiss(int channel = 0, int volume = 0, string sound = "", float attenuation = 0.0f, int pitch = 0)
	{
		DebugPrint("ext_svplaysound_kiss " + channel + " " + volume + " " + sound + " " + Text(attenuation) + " " + pitch);
		ServerPlaySound(channel, volume, sound, attenuation, pitch);
	}

	// ext_mon_playsound
	// <WAV> <(source)> [MaxRange] //sound must be precached
	void MonstersExternals_OnExtMonPlaysound(int soundFile = 0, int soundSource = 0, string maxRange = "")
	{
		bool exitSub = false;

		if (!maxRange.isEmpty())
		{
			int sourceOrg = soundSource;
			// dbg temp $dist(game.monster.origin,SOURCE_ORG)
			if (Distance(MyOrigin(), Vec(Text(sourceOrg))) > Float(maxRange))
				exitSub = true;
		}
		if (exitSub)
			return;

		EXTPLAY_SOUND = soundFile;
		CallEventDelayed(0.1f, "ext_playsound2"); // delay 0.1 seconds to stop flood
	}

	// turn_undead
	// PARAM1=Dmg PARAM2=Exorcist
	void MonstersExternals_OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		int turnStrength = 0;

		// if !AM_SKELETON //base_skeleton users handle this different, should migrate
		if (!Truthy(Eval("game.monster.isalive")))
			return;

		if (Truthy(GetVar("CUSTOM_TURN_UNDEAD")))
			return;

		// dbg temp got rebuke PARAM1 PARAM2
		if (DamageTakenOf(ENT_ME, "holy") == 0.0f)
			return;

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 512, 1, 1);

		STRUCK_BY_HOLY = 1.0f;
		SKELE_TURNED = true;
		STRUCK_HOLY = true;

		// callexternal EXT_THE_EXCORCIST send_damage $get(ent_me,id) direct EXT_INC_HOLY_DMG 100 EXT_THE_EXCORCIST holy
		DoDamageEx(self, "direct", holyDamage, 100, @exorcist, @exorcist, "spellcasting.divination", "holy_effect");

		// something about the external damage on this fubars things sometimes (causes death anim to lock)
		// fade monsters killed by this as work around:
		if (holyDamage > MyHealth())
			EXT_FADE_ON_DEATH = true;

		if (!Truthy(GetVar("I_AM_TURNABLE")))
			return;

		// determined turned
		turnStrength *= 7;

		if (turnStrength > 1000) // cap at 1000 (no turning bosses)
			turnStrength = 1000;

		if (Truthy(GetVar("IS_FLEEING"))) // can't turn already turned
			return;

		if (!(turnStrength > 0.0f))
			return;

		float turnResistance = Float(GetVar("MY_MAX_HP"));
		turnResistance = Divide(turnResistance, 25.0f);
		turnResistance = int(turnResistance);

		if (turnResistance < 2.0f)
			turnResistance = 2.0f;

		int turnchance = RandomInt(1, int(turnResistance));

		// dbg MyTurnResistance TURN_RESISTANCE mymaxhp MY_MAX_HP Rolled TURNCHANCE
		if (turnchance != 1)
			return;

		// Minimum Turn Duration 5 seconds, max 20
		float turnDuration = SkillOf("THE_EXCORCIST", "spellcasting.divination");
		if (turnDuration < 5.0f)
			turnDuration = 5.0f;
		if (turnDuration > 15.0f)
			turnDuration = 15.0f;

		// Thothie - RUN AWAY!
		FLEE_DISTANCE = "2048";

		SetVolume(10);
		PlayRandomSound(2, 10, GetVar("SOUND_TURNED1"), GetVar("SOUND_TURNED2"), GetVar("SOUND_TURNED3"), GetVar("SOUND_TURNED4"));

		CAN_FLEE = "1";
		OnNpcatkFlee("THE_EXCORCIST", FLEE_DISTANCE, Text(turnDuration));
	}

	// ext_speak
	// <"text">
	void MonstersExternals_OnExtSpeak(string text = "")
	{
		SetSayTextRange(2048);
		SayText(text);
	}

	// give_hp
	// PARAM1 = amont to give, can be negative
	void MonstersExternals_OnGiveHp(string amount = "")
	{
		GiveHealth(amount);
	}

	// ext_invalidate
	// { [server] ext_return_relpos //used to return position relative to others
	// local MY_ORG game.monster.origin
	// vectoradd MY_ORG $relpos(PARAM1,PARAM2)
	// setvarg G_RELPOS MY_ORG
	// }
	// <PARAM1> 1|0 - marks target as invalid
	void MonstersExternals_OnExtInvalidate(string invalidFlag = "")
	{
		PLAYING_DEAD = invalidFlag;
	}

	// ext_dodamage
	// same params as do damage
	void MonstersExternals_OnExtDodamage(CBaseEntity@ target = null, string hitMode = "", float damage = 0.0f, string hitChance = "", string attacker = "", string damageSkill = "", string value = "")
	{
		DoDamage(target, hitMode, damage, hitChance, attacker, damageSkill, value);
	}

	// ext_set_freeze_amt
	void MonstersExternals_OnExtSetFreezeAmt(string freezeAmount = "")
	{
		// this is used to determine the current amount of freeze magic on the target
		EFFECT_FREEZE_AMT = freezeAmount;
	}

	// ext_flash_bang
	// PARAM1 = origin PARAM2 = radius PARAM3 = source_owner
	void MonstersExternals_OnExtFlashBang(Vector3 origin = Vector3(), int radius = 0, CBaseEntity@ sourceOwner = null)
	{
		if (!(Distance(MyOrigin(), origin) < radius))
			return;
		OnNpcatkFlee(EntityId(sourceOwner), "1024", "5.0");
	}

	// speed_x2
	void MonstersExternals_OnSpeedX2()
	{
		// increase move and atk speeds
		SetMoveSpeed(1.5f);
		SetAnimMoveSpeed(1.5f);
		SetAnimFrameRate(1.5f);
		BASE_MOVESPEED = 1.5f;
		BASE_FRAMERATE = "1.5";
		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "speed_x2");
	}

	// speed_x2_5
	void MonstersExternals_OnSpeedX25()
	{
		// increase move and atk speeds
		SetMoveSpeed(1.75f);
		SetAnimMoveSpeed(1.75f);
		SetAnimFrameRate(1.75f);
		BASE_MOVESPEED = 1.75f;
		BASE_FRAMERATE = "1.75";
		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "speed_x2");
	}

	// speed_x3
	void MonstersExternals_OnSpeedX3()
	{
		// increase move and atk speeds
		SetMoveSpeed(2);
		SetAnimMoveSpeed(2);
		SetAnimFrameRate(2);
		BASE_MOVESPEED = 2.0f;
		BASE_FRAMERATE = "2.0";
		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "speed_x3");
	}

	// speed_x4
	void MonstersExternals_OnSpeedX4()
	{
		// increase move and atk speeds
		SetMoveSpeed(3);
		SetAnimMoveSpeed(3);
		SetAnimFrameRate(3);
		BASE_MOVESPEED = 3.0f;
		BASE_FRAMERATE = "3.0";

		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "speed_x4");
	}

	// critical_npc
	void MonstersExternals_OnCriticalNpc()
	{
		// for siege mode maps
		SetInvincible(false);
		NPC_CRITICAL = true;
		LegacyCommand("token.add", "G_CRITICAL_NPCS", self);
		SetGlobal("G_SIEGE_MAP", 1);
		CBaseEntity@ firstToken = FindEntity(GetToken(GetVar("G_CRITICAL_NPCS"), 0));
		if (!IsAlive(firstToken)) // fix buggy token creation
			LegacyCommand("token.del", "G_CRITICAL_NPCS", 0);
	}

	// ext_monsterspawn_removed
	// No longer required, but still called, in case you want script to do something about it
	void MonstersExternals_OnExtMonsterspawnRemoved(CBaseEntity@ spawnId = null)
	{
		if (GetProp(ENT_ME, "spawner") != EntityId(spawnId))
			return;
		string mapName = ToLowerCase(MapName());
		if (Contains(mapName, "helena"))
			OnNpcSuicide("dienow");
		// if ( L_MAP_NAME equals walltest ) callevent npc_suicide dienow
		if (mapName == "aleyesu")
			OnNpcSuicide("dienow");
		if (mapName == "b_castle")
			OnNpcSuicide("dienow");
		if (mapName == "bloodrose")
			OnNpcSuicide("dienow");
		if (mapName == "calruin2")
			OnNpcSuicide("dienow");
		if (mapName == "cleicert")
			OnNpcSuicide("dienow");
		if (mapName == "demontemple")
			OnNpcSuicide("dienow");
		if (mapName == "foutpost")
			OnNpcSuicide("dienow");
		if (mapName == "gatecity")
			OnNpcSuicide("dienow");
		if (Contains(mapName, "gertenheld"))
			OnNpcSuicide("dienow");
		if (mapName == "keledrosruins")
			OnNpcSuicide("dienow");
		if (mapName == "kfortress")
			OnNpcSuicide("dienow");
		if (Contains(mapName, "lodagond"))
			OnNpcSuicide("dienow");
		if (mapName == "ms_wicardoven")
			OnNpcSuicide("dienow");
		if (mapName == "mscave")
			OnNpcSuicide("dienow");
		if (mapName == "shad_palace")
			OnNpcSuicide("dienow");
		if (mapName == "sorc_villa")
			OnNpcSuicide("dienow");
		if (mapName == "the_keep")
			OnNpcSuicide("dienow");
		if (Contains(mapName, "islesofdread"))
			OnNpcSuicide("dienow");
		if (mapName == "the_wall")
			OnNpcSuicide("dienow");
		if (mapName == "umulak")
			OnNpcSuicide("dienow");
		if (mapName == "ww1")
			OnNpcSuicide("dienow");
		if (mapName == "ww2b")
			OnNpcSuicide("dienow");
		if (mapName == "ww3d")
			OnNpcSuicide("dienow");

		if (NPC_DIE_ON_SPAWN_REMOVAL)
			OnNpcSuicide("dienow");
	}

	// glow_red
	void MonstersExternals_OnGlowRed()
	{
		NPC_GLOW = Text(Vector3(255, 0, 0));
	}

	// glow_green
	void MonstersExternals_OnGlowGreen()
	{
		NPC_GLOW = Text(Vector3(0, 255, 0));
	}

	// glow_blue
	void MonstersExternals_OnGlowBlue()
	{
		NPC_GLOW = Text(Vector3(0, 0, 255));
	}

	// glow_yellow
	void MonstersExternals_OnGlowYellow()
	{
		NPC_GLOW = Text(Vector3(255, 255, 0));
	}

	// glow_purple
	void MonstersExternals_OnGlowPurple()
	{
		NPC_GLOW = Text(Vector3(255, 0, 255));
	}

	// glow_custom
	void MonstersExternals_OnGlowCustom(string glow = "")
	{
		NPC_GLOW = glow;
	}

	// glow_remove
	void MonstersExternals_OnGlowRemove()
	{
		NPC_GLOW = "NPC_GLOW";
	}

	// remove_ghost
	void MonstersExternals_OnRemoveGhost()
	{
		NPC_GHOST = false;
	}

	// make_ghost
	void MonstersExternals_OnMakeGhost()
	{
		NPC_GHOST = true;
	}

	// npc_post_spawn
	void MonstersExternals_OnNpcPostSpawn()
	{
		if (NPC_GHOST)
		{
			SetProp(ENT_ME, "rendermode", 5);
			SetProp(ENT_ME, "renderamt", 255);
			CallEventDelayed(10.1f, "npcatk_reset_ghost");
		}

		if (NPC_GLOW != "NPC_GLOW")
		{
			DebugPrint("npc_post_spawn [externals] initiated glow " + NPC_GLOW);
			Effect("glow", ENT_ME, NPC_GLOW, 64, 20, 0);
			CallEventDelayed(10.1f, "npcatk_reset_glow");
		}
	}

	// npcatk_reset_glow
	// These render effects are reset priodically as some effects can remove or conflict with them
	void MonstersExternals_OnNpcatkResetGlow()
	{
		if (NPC_GLOW == "NPC_GLOW")
			return;
		Effect("glow", ENT_ME, NPC_GLOW, 64, 20, 0);
		CallEventDelayed(10.1f, "npcatk_reset_glow");
	}

	// npcatk_reset_ghost
	void MonstersExternals_OnNpcatkResetGhost()
	{
		if (!NPC_GHOST)
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		CallEventDelayed(10.1f, "npcatk_reset_ghost");
	}

	// set_race
	void MonstersExternals_OnSetRace(string raceName = "")
	{
		SetRace(raceName);
	}

	// set_model
	void MonstersExternals_OnSetModel(string model = "")
	{
		SetModel(model);
		SetSolid("box");
		SetBoundingBox("npcsize");
	}

	// ext_report_armor
	void MonstersExternals_OnExtReportArmor(string armorType = "", string player = "")
	{
		ConsoleMessage(player, NameOf(ENT_ME) + " Armor: MSC_ARMOR_ALL " + armorType + " : " + Text(DamageTakenOf(ENT_ME, armorType)));
	}

	// ext_set_parry
	// add param SEP2009_17 - set a monster's parry skill
	void MonstersExternals_OnExtSetParry(string parrySkill = "")
	{
		SetStat("parry", parrySkill);
	}

	// ext_blind
	void MonstersExternals_OnExtBlind()
	{
		LegacyCommand("blind", 1);
	}

	// ext_unblind
	void MonstersExternals_OnExtUnblind()
	{
		LegacyCommand("blind", 0);
	}

	// game_drain_death
	// PARAM1 = drainer
	void MonstersExternals_OnGameDrainDeath(CBaseEntity@ attacker = null)
	{
		// dbg DRAIN DEATH
		DoDamage(ENT_ME, "direct", @attacker, 100, "100%", @attacker, "target");
	}

	// ext_wink_out
	// { ext_nopush
	// scriptflags ent_me add ext_nopush nopush PARAM1
	// //dbg nopush set to PARAM1
	// }
	// { ext_nopush_on
	// scriptflags ent_me add ext_nopush nopush 1 PARAM2 none
	// //if ( PARAM2 > 0 ) callevent PARAM2 ext_nopush_off //seems this should be PARAM1 though
	// }
	// { ext_nopush_off
	// nopush 0
	// }
	void MonstersExternals_OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f)
	{
		// teleport off map, return to point PARAM1 in PARAM2 seconds
		SetOrigin(ENT_ME, Vector3(20000, 10000, -20000));
		NPC_WINK_IN_POINT = spawnPosition;
		NPC_WINKED_OUT = true;
		CallEventDelayed(delay, "ext_wink_in");
	}

	// ext_wink_in
	void MonstersExternals_OnExtWinkIn()
	{
		// return from ext_wink_out
		SetOrigin(ENT_ME, NPC_WINK_IN_POINT);
		NPC_WINKED_OUT = false;
	}

	// make_boss
	void MonstersExternals_OnMakeBoss()
	{
		DebugPrint("make_boss");
		NPC_IS_BOSS = true;
		NPC_BOSS_KNOWS = "";
		NPC_BOSS_KNOWS_AMTS = "";
	}

	// ext_makepet
	void MonstersExternals_OnExtMakepet(CBaseEntity@ owner = null)
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		NPC_SILENT_DEATH = true;
		CallEventDelayed(0.01f, "npc_suicide");
		CreateNpc(GetVar("NPC_PET_SCRIPT"), RelativePosition(Vector3(0, 0, 0)), @owner, 1);
	}

	// ext_set_health
	void MonstersExternals_OnExtSetHealth(float health = 0.0f, float maxHealth = 0.0f)
	{
		SetHealth(health, maxHealth);
	}

	// ignore_critical_npc
	// { ext_return_relpos_vec //return an adjusted self-relative position SEP2009_17 - fixed, was useless old way as was using coord type $relpos()
	// setvard EXT_RELPOS $relpos(PARAM1,PARAM2,PARAM3)
	// }
	// Thothie FEB2009 - external addparam to flag monster not to hunt for critical NPCs
	void MonstersExternals_OnIgnoreCriticalNpc()
	{
		NPC_NO_SIEGE_HUNT = true;
	}

	// ext_hit_chance
	// Thothie FEB2009_18 - external for setting hit chance penalties
	void MonstersExternals_OnExtHitChance(float hitMultiplier = 0.0f)
	{
		SetHitMultiplier(ENT_ME, hitMultiplier);
	}

	// ext_set_frozen
	// Thothie FEB2009_19 - allow frozen status from things other than freeze_solid
	void MonstersExternals_OnExtSetFrozen(string duration = "")
	{
		I_R_FROZEN = true;
		// setvard ORIG_NOPUSH $get(ent_me,nopush)
		// nopush 1
		ScriptFlags(ENT_ME, "add", "ext_set_frozen", "nopush", 1, duration, "none");
		CallEventOrDelay(duration, "ext_set_unfrozen");
	}

	// ext_set_unfrozen
	void MonstersExternals_OnExtSetUnfrozen()
	{
		I_R_FROZEN = false;
	}

	// ext_unsummon
	// Thothie APR2009 - allow unsommoning of all NPC's summons, globally
	void MonstersExternals_OnExtUnsummon()
	{
		if (!Truthy(GetVar("AM_SUMMONED")))
			return;
		SetAlive(false);
		DeleteEntity(ENT_ME, "fade");
	}

	// ext_sphere_token_x
	// TYPE_SCAN SCAN_RANGE
	void MonstersExternals_OnExtSphereTokenX(string scanType = "", float scanRange = 0.0f)
	{
		PLR_SCAN_TOKEN = FindInSphere(scanType, scanRange);
	}

	// ext_sphere_token
	// TYPE_SCAN SCAN_RANGE SCAN_ORIGIN
	void MonstersExternals_OnExtSphereToken(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3())
	{
		PLR_SCAN_TOKEN = LegacyFunction("get_tsphere", scanType, scanRange, scanOrigin);
	}

	// ext_box_token
	// TYPE_SCAN SCAN_RANGE SCAN_ORIGIN
	void MonstersExternals_OnExtBoxToken(string scanType = "", int scanRange = 0, string scanOrigin = "")
	{
		PLR_SCAN_TOKEN = LegacyFunction("get_tbox", scanType, scanRange, scanOrigin);
	}

	// ext_reduct_xp
	// add param for monster placements that are exploitable, etc
	void MonstersExternals_OnExtReductXp(float xpReduction = 0.0f)
	{
		if (!(xpReduction < 1.0f))
			return;
		if (Text(NPC_EXP_REDUCT) == "NPC_EXP_REDUCT")
		{
			NPC_EXP_REDUCT = xpReduction;
		}
		else
		{
			NPC_EXP_REDUCT -= xpReduction; // in case XP reduced for more than one reason
		}
	}

	// ext_no_drops
	// { ext_reduct_xp2
	// if NPC_EXP_REDUCT < 1.0
	// multiply NPC_GIVE_EXP NPC_EXP_REDUCT
	// if ( DROP_GOLD ) multiply DROP_GOLD_AMT NPC_EXP_REDUCT
	// skilllevel NPC_GIVE_EXP
	// dbg ext_reduct_xp NPC_EXP_REDUCT NPC_GIVE_EXP
	// }
	// add param to remove drops for exploitable monsters
	void MonstersExternals_OnExtNoDrops()
	{
		NPC_NO_DROPS = true;
		CallEventDelayed(1.5f, "ext_no_drops2"); // delay to give chance for monsters to set treasure
	}

	// ext_no_drops2
	void MonstersExternals_OnExtNoDrops2()
	{
		SetGold(0);
		DROP_GOLD = 0;
		DROP_ITEM1_CHANCE = "0%";
		DROP_ITEM2_CHANCE = "0%";
		DROP_ITEM3_CHANCE = "0%";
		DROP_ITEM4_CHANCE = "0%";
		CONTAINER_DROP_CHANCE = "0%";
	}

	// ext_ent_list_sort
	// Jelly's external scan+sort
	// SCAN_TYPE SCAN_RANGE SCAN_ORIGIN SORT_TYPE:range|hp|maxhp|mp|maxmp
	void MonstersExternals_OnExtEntListSort(string scanFilter = "", string searchRange = "", string searchOrigin = "", string sortBy = "")
	{
		OnExtSphereToken(scanFilter, Int(searchRange), Vec(searchOrigin));
		PLR_SCAN_TOKEN_SORTED = SortEntities(PLR_SCAN_TOKEN, sortBy);
	}

	// ext_no_player_damage
	// DEC2009 - Option to make monster invulnerable to player damage (good for guards / crit NPCs)
	void MonstersExternals_OnExtNoPlayerDamage()
	{
		NPC_NO_PLAYER_DMG = true;
	}

	// ext_setrender
	// Failed JAN2010 spariment
	void MonstersExternals_OnExtSetrender(string renderMode = "")
	{
		DebugPrint("got ext_setrender " + renderMode);
	}

	// set_scale_nr
	// <ratio> - scale with no reach change
	void MonstersExternals_OnSetScaleNr(string ratio = "")
	{
		OnExtScale(Float(ratio), 0, 1);
	}

	// set_scale_nb
	// <ratio> - scale with no bbox change
	void MonstersExternals_OnSetScaleNb(string ratio = "")
	{
		OnExtScale(Float(ratio), 1, 0);
	}

	// set_scale_nbr
	// <ratio> - scale with no bbox or reach change
	void MonstersExternals_OnSetScaleNbr(string ratio = "")
	{
		OnExtScale(Float(ratio), 1, 1);
	}

	// ext_scale
	// <ratio> [no_bounding_fix:0|1] [no_range_fix:0|1]
	void MonstersExternals_OnExtScale(float ratio = 0.0f, int noBoundingFix = 0, int noRangeFix = 0)
	{
		// scales model, bounding box, and attack ranges
		DebugPrint("ext_scale " + Text(ratio) + " " + noBoundingFix + " " + noRangeFix);

		if (!(ratio > 0.0f))
			return;

		float myWidth = WidthOf(ENT_ME);
		float myHeight = HeightOf(ENT_ME);

		if (NPC_ORG_WIDTH == "NPC_ORG_WIDTH")
		{
			NPC_ORG_WIDTH = Text(myWidth);
			NPC_ORG_HEIGHT = Text(myHeight);
		}
		else
		{
			myWidth = Float(NPC_ORG_WIDTH);
			myHeight = Float(NPC_ORG_HEIGHT);
		}

		SetProp(ENT_ME, "scale", ratio);
		myWidth *= ratio;
		myHeight *= ratio;

		// most msc mobs can't really deal with being smaller than this
		if (myWidth < 16.0f)
			myWidth = 16.0f;
		if (myHeight < 16.0f)
			myHeight = 16.0f;

		SetWidth(myWidth);
		SetHeight(myWidth);
		MONSTER_WIDTH = int(myWidth);

		NPC_MODEL_SCALED = ratio;
		NPC_USES_HANDLE_EVENTS = true;

		float halfW = myWidth * 0.5f;

		// thus func tends to fubar things
		if (noBoundingFix != 1)
			SetBoundingBox(Vector3(-halfW, -halfW, 0), Vector3(halfW, halfW, myHeight));

		if (ratio > 1.0f)
		{
			// bigger = longer strides (otherwise run anims look weird)
			if (Text(BASE_MOVESPEED) == "BASE_MOVESPEED")
			{
				BASE_MOVESPEED = ratio;
				NPC_ORG_BASE_MOVESPEED = Text(BASE_MOVESPEED);
			}
			else
			{
				if (NPC_ORG_BASE_MOVESPEED == "NPC_ORG_BASE_MOVESPEED")
					BASE_MOVESPEED = Float(NPC_ORG_BASE_MOVESPEED);
				else
					NPC_ORG_BASE_MOVESPEED = Text(BASE_MOVESPEED);
				BASE_MOVESPEED += ratio;
			}
			SetAnimMoveSpeed(BASE_MOVESPEED);
			SetMoveSpeed(BASE_MOVESPEED);
		}

		NPC_MODEL_SCALED = ratio;

		if (noRangeFix == 1)
			return;
		if (!Truthy(GetVar("NPC_RANGED")))
		{
			DebugPrint("ext_scale adjusting ranges");
			CallEventDelayed(1.9f, "ext_adjust_scale_range");
		}
		else
		{
			DebugPrint("ext_scale not changing reach, mob is ranged");
		}
	}

	// set_scale
	void MonstersExternals_OnSetScale(float scale = 0.0f)
	{
		OnExtScale(scale);
	}

	// ext_adjust_scale_range
	void MonstersExternals_OnExtAdjustScaleRange()
	{
		// local RANGE_ADJ_RATIO NPC_SCALED
		// if PARAM1 > 0
		// multiply ATTACK_RANGE RANGE_ADJ_RATIO
		// multiply ATTACK_HITRANGE RANGE_ADJ_RATIO
		// multiply MOVE_RANGE RANGE_ADJ_RATIO
		// multiply ATTACK_MOVERANGE RANGE_ADJ_RATIO
		DebugPrint("ext_adjust_scale_range entered");

		float curWidth = WidthOf(ENT_ME);
		float curHeight = HeightOf(ENT_ME);

		if (NPC_ORG_RANGE == "NPC_ORG_RANGE")
			NPC_ORG_RANGE = Text(ATTACK_RANGE);
		if (NPC_ORG_HITRANGE == "NPC_ORG_HITRANGE")
			NPC_ORG_HITRANGE = Text(ATTACK_HITRANGE);

		ATTACK_RANGE = Float(NPC_ORG_RANGE);
		ATTACK_HITRANGE = Float(NPC_ORG_HITRANGE);

		if (ATTACK_RANGE >= 512.0f)
			DebugPrint("ext_adjust_scale_range base range > 512 - npc ranged without flag?");

		if (!(ATTACK_RANGE < 512.0f)) // else probably a ranged NPC, without NPC_RANGED flag
			return;

		float minRange = curWidth;
		if (curWidth < curHeight)
			minRange = curHeight;
		if (NPC_MODEL_SCALED > 1.0f) // scaling up seems to be giving slightly insane reach
			minRange *= 0.85f;
		if (minRange < 38.0f) // min half player height
			minRange = 38.0f;
		ATTACK_RANGE = minRange;
		ATTACK_RANGE *= 1.5f;
		ATTACK_HITRANGE = minRange;
		ATTACK_HITRANGE *= 2.0f;

		NPC_SET_RANGE = Text(ATTACK_RANGE); // future use, to detect range changes
		NPC_SET_RANGE_RATIO = Divide(ATTACK_RANGE, 0.0f); // future use, so we can adjust dynamic ranges

		DebugPrint("ext_adjust_scale_range " + Text(ATTACK_RANGE) + " " + Text(ATTACK_HITRANGE));
	}

	// set_attack_until_spotted
	void MonstersExternals_OnSetAttackUntilSpotted()
	{
		// simulates hacking on an object until spots or spotted by player
		NPC_ATTACK_UNTIL_SPOTTED = true;
	}

	// npc_post_spawn
	void MonstersExternals_OnNpcPostSpawn_2()
	{
		if (!NPC_ATTACK_UNTIL_SPOTTED)
			return;
		OnNpcatkAttackTillSpotted();
	}

	// npcatk_attack_till_spotted
	void MonstersExternals_OnNpcatkAttackTillSpotted()
	{
		if (NPCATK_TARGET != "unset")
			return;
		CallEventDelayed(0.25f, "npcatk_attack_till_spotted");
		PlayAnim("once", GetVar("ANIM_ATTACK"));
		AS_ATTACKING = GameTime() + 5.0f;
		Vector3 faceSpot = Vec(GetVar("NPC_HOME_LOC"));
		float faceDir = Vec(GetVar("NPC_HOME_ANG")).y;
		faceSpot += RelativePosition(Vector3(0, faceDir, 0), Vector3(0, 256, 0));
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(faceSpot, 9999);
	}

	// set_fade_in
	// thought I had this, guess not
	void MonstersExternals_OnSetFadeIn(float fadeRate = 0.0f)
	{
		if (NPC_FADEIN_SET)
			return;
		NPC_FADEIN_SET = true;
		NPC_RENDER_AMT = 0.0f;
		NPC_RENDER_MODE = 2;
		SetProp(ENT_ME, "renderamt", NPC_RENDER_AMT);
		SetProp(ENT_ME, "rendermode", NPC_RENDER_MODE);

		float fadeDelay = fadeRate;
		if (fadeDelay == 0.0f)
			fadeDelay = 0.1f;

		NPC_FADEIN_RATE = int(fadeRate);
		if (NPC_FADEIN_RATE < 10)
			NPC_FADEIN_RATE = 10;
		CallEventDelayed(fadeDelay, "set_fade_in_loop");
	}

	// set_fade_in_loop
	void MonstersExternals_OnSetFadeInLoop()
	{
		NPC_RENDER_AMT += 10.0f;

		if (NPC_RENDER_AMT < 255.0f)
		{
			SetProp(ENT_ME, "renderamt", NPC_RENDER_AMT);
			CallEventDelayed(NPC_FADE_IN_SPEED, "set_fade_in_loop");
		}
		else
		{
			SetProp(ENT_ME, "renderamt", 255);
			SetProp(ENT_ME, "rendermode", 0);
			NPC_RENDER_AMT = 255.0f;
			NPC_RENDER_MODE = 0;
			OnNpcFadeinDone();
		}
	}

	// set_no_step_adj
	// FEB2010_06 toggle step adj on individual monsters
	void MonstersExternals_OnSetNoStepAdj()
	{
		NO_STEP_ADJ = true;
	}

	// set_npc_turret
	// FEB2010_06 global set turret function
	void MonstersExternals_OnSetNpcTurret()
	{
		SetMoveSpeed(0);
		BASE_MOVESPEED = 0.0f;
		SetMoveAnim(GetVar("ANIM_IDLE"));
		SetRoam(false);
		NO_STUCK_CHECKS = "1";
		ANIM_RUN = GetVar("ANIM_IDLE");
		ANIM_WALK = GetVar("ANIM_IDLE");
		NPC_IS_TURRET = true;
		CallEventDelayed(0.1f, "set_npc_turret2");
	}

	// set_npc_turret2
	void MonstersExternals_OnSetNpcTurret2()
	{
		// enforcer - case we got set_npc_turret during load time
		ANIM_RUN = GetVar("ANIM_IDLE");
		ANIM_WALK = GetVar("ANIM_IDLE");
		SetMoveAnim(GetVar("ANIM_IDLE"));
	}

	// set_summon_circle
	void MonstersExternals_OnSetSummonCircle()
	{
		OnSetFadeIn(1.0f);
		if (!Truthy(GetVar("NPC_HANDLES_SUMMON_CIRCLES")))
			SetAnimFrameRate(0);
		CallEventDelayed(0.1f, "set_summon_circle2");
	}

	// set_summon_circle2
	void MonstersExternals_OnSetSummonCircle2()
	{
		if (!Truthy(GetVar("NPC_HANDLES_SUMMON_CIRCLES")))
		{
			OnNpcatkSuspendAi();
			SetAnimFrameRate(0); // case variant in npc_spawn
		}
		Vector3 circleOrg = OriginOf(ENT_ME);
		circleOrg.z = GroundHeight(circleOrg);
		if (HeightOf(ENT_ME) < 90.0f)
			ClientEvent("new", "all", "effects/sfx_summon_circle", circleOrg, 3);
		else
			ClientEvent("new", "all", "effects/sfx_summon_circle", circleOrg, 5);
		CallEventDelayed(1.0f, "set_summon_circle3");
	}

	// set_summon_circle3
	void MonstersExternals_OnSetSummonCircle3()
	{
		AS_ATTACKING = GameTime() + 5.0f;
		if (Truthy(GetVar("NPC_HANDLES_SUMMON_CIRCLES")))
			return;
		OnNpcatkResumeAi();
		if (BASE_FRAMERATE == "BASE_FRAMERATE")
			SetAnimFrameRate(1);
		else
			SetAnimFrameRate(Float(BASE_FRAMERATE));
	}

	// set_takedmg_holy
	// add param
	void MonstersExternals_OnSetTakedmgHoly(float holyRatio = 0.0f)
	{
		SetDamageTaken("holy", holyRatio);
	}

	// set_stepsize
	void MonstersExternals_OnSetStepsize(float stepSize = 0.0f)
	{
		SetStepSize(stepSize);
	}

	// ext_playanim
	void MonstersExternals_OnExtPlayanim(string animation = "")
	{
		DebugPrint("ext_playanim " + animation);
		PlayAnim("critical", animation);
	}

	// bs_global_command
	// { ext_sethp
	// hp PARAM1
	// }
	// <param1> - called globally when player dies
	void MonstersExternals_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (reason != "death")
			return;
		if (!IsAlive(ENT_ME))
			return;
		// clear XP from player who died
		DebugPrint("bs_global_command clearplayerhits " + NameOf(deadPlayer));
		if (NPC_IS_BOSS)
			return;
		LegacyCommand("clearplayerhits", ENT_ME, @deadPlayer);
	}

	// ext_dbg
	void MonstersExternals_OnExtDbg(string debugValue = "")
	{
		if (debugValue != "off")
		{
			EXT_DEBUG_PARAM = debugValue;
			EXT_DBG_LOOP_ON = true;
			OnExtDbgLoop();
		}
		else
		{
			EXT_DBG_LOOP_ON = false;
		}
	}

	// ext_dbg_loop
	void MonstersExternals_OnExtDbgLoop()
	{
		if (!EXT_DBG_LOOP_ON)
			return;
		CallEventDelayed(0.1f, "ext_dbg_loop");
		DebugPrint(GetProp(ENT_ME, EXT_DEBUG_PARAM));
	}

	// set_blind_attack
	void MonstersExternals_OnSetBlindAttack()
	{
		NPC_MUST_SEE_TARGET = "0";
	}

	// ext_spawn_sound
	void MonstersExternals_OnExtSpawnSound()
	{
		NPC_USES_HANDLE_EVENTS = true;
		NPC_DO_SPAWN_SOUND = true;
	}

	// setfx_spawn_sound
	void MonstersExternals_OnSetfxSpawnSound()
	{
		// convention alias
		OnExtSpawnSound();
	}

	// setfx_summon_circle
	void MonstersExternals_OnSetfxSummonCircle()
	{
		// convention alias
		OnSetSummonCircle();
	}

	// setfx_fade_in
	void MonstersExternals_OnSetfxFadeIn()
	{
		// convention alias
		OnSetFadeIn();
	}

	// setfx_tele_in
	void MonstersExternals_OnSetfxTeleIn()
	{
		OnSetFadeIn(20.0f);
		CallEventDelayed(0.01f, "setfx_tele_in2");
	}

	// setfx_tele_in2
	void MonstersExternals_OnSetfxTeleIn2()
	{
		Vector3 myPosGround = OriginOf(ENT_ME);
		myPosGround.z = GroundHeight(myPosGround);
		ClientEvent("new", "all", "effects/sfx_repulse_burst", myPosGround, 128, 1.0f);
	}

	// set_no_player_damage
	void MonstersExternals_OnSetNoPlayerDamage()
	{
		// /alias for ext_no_player_damage
		NPC_NO_PLAYER_DMG = true;
	}

	// ext_setmodelbody
	void MonstersExternals_OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0)
	{
		SetModelBody(bodyGroup, submodel);
	}

	// set_die_on_spawn_removed
	// { ext_anim_exists
	// dbg ext_animexists $anim_exists(PARAM1)
	// }
	void MonstersExternals_OnSetDieOnSpawnRemoved()
	{
		NPC_DIE_ON_SPAWN_REMOVAL = true;
	}

	// set_dosr
	void MonstersExternals_OnSetDosr()
	{
		NPC_DIE_ON_SPAWN_REMOVAL = true;
	}

	// set_no_roam
	void MonstersExternals_OnSetNoRoam()
	{
		NPC_NO_ROAM = true;
		SetRoam(false);
	}

	// set_roam
	void MonstersExternals_OnSetRoam(string enabled = "")
	{
		if (enabled.isEmpty())
		{
			NPC_FORCE_ROAM = true;
			SetRoam(true);
		}
		else
		{
			// using equals here, as addparams get streamed
			if (enabled == "1")
			{
				NPC_FORCE_ROAM = true;
				SetRoam(true);
			}
			else if (enabled == "0")
			{
				NPC_NO_ROAM = true;
				SetRoam(false);
			}
		}
	}

	// trig_damage
	// <name>;<dmg>;<dmg_type> - called by a map brush with scriptevent
	void MonstersExternals_OnTrigDamage(string triggerName = "", string damage = "", string damageType = "")
	{
		// local TRIG_NAME PARAM1
		string trigDmgType = damageType + "_effect";
		DoDamageEx(ENT_ME, "direct", damage, "100%", GetVar("GAME_MASTER"), GetVar("GAME_MASTER"), "none", trigDmgType);
	}

	// set_self_adj
	// [adj_down]
	void MonstersExternals_OnSetSelfAdj(string adjDown = "")
	{
		bool noAdj = false;
		DebugPrint("set_self_adj " + adjDown);
		if (NPC_SELF_ADJUST)
			return;
		NPC_SELF_ADJUST = true;
		if (adjDown.isEmpty())
			noAdj = true;
		if (noAdj)
			return;
		if (!(Float(adjDown) > 0.0f))
			return;
		// used to cap out adjustment on higher level beasties
		NPC_ADJ_DOWN = adjDown;
	}

	// set_no_avg
	void MonstersExternals_OnSetNoAvg()
	{
		// don't add this monster to the level averages (good for monsters encountered early in map, where not everyone may have joined yet)
		NPC_SELF_ADJUST_NOAVG = true;
	}

	// set_poisonous
	void MonstersExternals_OnSetPoisonous(string value = "")
	{
		// setvard NPC_POISONOUS 1
		// setvard NPC_GLOW (0,255,0)
		OnAddDotPoison(Float(value));
	}

	// add_dot_poison
	// [ratio]
	void MonstersExternals_OnAddDotPoison(float ratio = 0.0f)
	{
		NPC_DOT_POISON = true;
		NPC_DOT_POISON_RATIO = 1.0f;
		if (ratio > 0.0f)
			NPC_DOT_POISON_RATIO = ratio;
		NPC_GLOW = Text(Vector3(0, 255, 0));
	}

	// add_dot_cold
	// [ratio]
	void MonstersExternals_OnAddDotCold(float ratio = 0.0f)
	{
		NPC_DOT_COLD = true;
		NPC_DOT_COLD_RATIO = 1.0f;
		if (ratio > 0.0f)
			NPC_DOT_COLD_RATIO = ratio;
		NPC_GLOW = Text(Vector3(0, 128, 255));
	}

	// add_dot_fire
	// [ratio]
	void MonstersExternals_OnAddDotFire(float ratio = 0.0f)
	{
		NPC_DOT_FIRE = true;
		NPC_DOT_FIRE_RATIO = 1.0f;
		if (ratio > 0.0f)
			NPC_DOT_FIRE_RATIO = ratio;
		NPC_GLOW = Text(Vector3(255, 64, 0));
	}

	// add_dot_lightning
	// [ratio]
	void MonstersExternals_OnAddDotLightning(float ratio = 0.0f)
	{
		NPC_DOT_LIGHTNING = true;
		NPC_DOT_LIGHTNING_RATIO = 1.0f;
		if (ratio > 0.0f)
			NPC_DOT_LIGHTNING_RATIO = ratio;
		NPC_GLOW = Text(Vector3(255, 255, 0));
	}

	// set_no_auto_activate
	// don't cycle up instantly based on player prox on spawn
	void MonstersExternals_OnSetNoAutoActivate()
	{
		NPC_NO_AUTO_ACTIVATE = true;
	}

	// set_non_agro
	void MonstersExternals_OnSetNonAgro()
	{
		NPC_NO_AGRO = 1;
		OnNpcatkSuspendAi();
	}

	// setfx_sprite_in
	void MonstersExternals_OnSetfxSpriteIn()
	{
		// make sure c-tele1.spr is precached somewhere on the map or scripts - it isn't precached by default
		NPC_USES_HANDLE_EVENTS = true;
		NPC_SPRITE_IN = 1;
		OnSetFadeIn();
	}

	// setfx_sprite_inx
	void MonstersExternals_OnSetfxSpriteInx()
	{
		// uses xflare1.spr as it's already cached
		NPC_USES_HANDLE_EVENTS = true;
		NPC_SPRITE_IN = 2;
		OnSetFadeIn();
	}

	// set_summon
	void MonstersExternals_OnSetSummon()
	{
		// for global npc summon counting
		NPC_SUMMON = true;
		LegacyCommand("add", "G_NPC_SUMMON_COUNT", 1);
		DebugPrint("set_summon " + GetVar("G_NPC_SUMMON_COUNT"));
	}

	// ext_summon_fade
	void MonstersExternals_OnExtSummonFade()
	{
		if (!NPC_SUMMON)
			return;
		LegacyCommand("subtract", "G_NPC_SUMMON_COUNT", 1);
		DebugPrint("ext_summon_fade " + GetVar("G_NPC_SUMMON_COUNT"));
		SetAnimFrameRate(0);
		SetAnimMoveSpeed(0);
		SetGravity(0);
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
		NPC_DID_DEATH = true;
		NPC_OVERRIDE_DEATH = true;
		SKEL_RESPAWN_TIMES = 99.0f;
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
		DeleteEntity(ENT_ME, "fade");
	}

	// set_fadein_delayed
	void MonstersExternals_OnSetFadeinDelayed()
	{
		OnSetFadeIn(1.0f);
	}

	// setfx_beam_in
	void MonstersExternals_OnSetfxBeamIn()
	{
		OnSetFadeIn();
		Vector3 beamStart = OriginOf(ENT_ME);
		beamStart.z = GroundHeight(beamStart);
		string beamEnd = Text(beamStart);
		beamEnd = Text(Vec(beamEnd) + Vector3(0.0f, 0.0f, 512.0f));
		Effect("beam", "point", "lgtning.spr", 90, beamStart, beamEnd, Vector3(64, 128, 255), 200, 20, 2.0f);
		PlaySound(0, 10, "weather/Storm_exclamation.wav");
	}

	// set_xp_tr
	// nerf powers monster's XP to reach max over time (case big xp mob close to start) [cals from map start]
	// ie. if you attack this mob 10 minutes in, and <minstomax> is set to 20, you'll get 50% xp
	// <minutes to max XP>
	void MonstersExternals_OnSetXpTr(float minutes = 0.0f)
	{
		NPC_XPTR = true;
		NPC_XPTR_TIME = minutes * 60.0f;
		if (NPC_XPTR_TIME > GameTime())
		{
			DebugPrint("set_xp_tr " + Text(NPC_XPTR_TIME));
			CallEventDelayed(2.0f, "set_xp_timeramp_start");
		}
		else
		{
			DebugPrint("set_xp_tr [time elapsed]");
		}
	}

	// set_xp_timeramp_start
	void MonstersExternals_OnSetXpTimerampStart()
	{
		NPC_XPTR_MAXXP = NPC_GIVE_EXP; // all XP mods should be done by now
		OnSetXpTimerampLoop();
		DebugPrint("set_xp_timeramp_start " + GetVar("TIME_RATIO") + " [ " + Text(NPC_XPTR_TIME) + " ]");
	}

	// set_xp_timeramp_loop
	void MonstersExternals_OnSetXpTimerampLoop()
	{
		bool exitSub = false;
		if (!NPC_XPTR)
			return;
		CallEventDelayed(60.0f, "set_xp_timeramp_loop");
		float timeRatio = Divide(GameTime(), NPC_XPTR_TIME);
		if (timeRatio > 1.0f)
		{
			NPC_XPTR = false;
			exitSub = true;
		}
		if (exitSub)
			return;
		float newXp = Ratio(timeRatio, 0, NPC_XPTR_MAXXP);
		SetSkillLevel(newXp);
		DebugPrint("set_xp_timeramp_loop " + Text(timeRatio) + " = " + Text(newXp) + " / " + Text(NPC_XPTR_MAXXP) + " [ " + Text(NPC_XPTR_TIME) + " ]");
	}

	// game_scriptflag_update
	// <action> <name> [type] [value] [base_expire_time]
	void MonstersExternals_OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f)
	{
		bool checkExpire = false;

		// handle flags
		if (Truthy(ScriptFlag(ENT_ME, "nopush", "type_exists")))
			SetNoPush(true);
		else
			SetNoPush(false);

		// handle check for expire
		if (action == "add")
			checkExpire = true;
		if (action == "edit") // expire time may have changed
			checkExpire = true;

		if (!checkExpire)
			return;

		float checkExptime = baseExpireTime;

		if (checkExptime > -1.0f)
		{
			checkExptime += 0.1f;
			CallEventDelayed(checkExptime, "check_flags_expired");
		}
	}

	// check_flags_expired
	void MonstersExternals_OnCheckFlagsExpired()
	{
		ScriptFlags(ENT_ME, "remove_expired");
		CallExternal(ENT_ME, "ext_scriptflag_expired");
	}

	// npc_post_spawn
	// in case nopush was set at spawn
	void MonstersExternals_OnNpcPostSpawn_3()
	{
		if (!IsNoPush(ENT_ME))
			return;
		ScriptFlags(ENT_ME, "add", "npspawn", "nopush");
	}

	// set_cbm_file
	// map side npc addparams can only get one param at a time, so we have to break this in two
	void MonstersExternals_OnSetCbmFile(string musicFile = "")
	{
		if (NPC_CUSTOM_COMBAT_MUSIC) // this is running twice, and we REALLY need to find out why
			return;
		NPC_CUSTOM_COMBAT_MUSIC = true;
		NPC_CMUSIC_FILE = musicFile;
	}

	// set_cbm
	// alias for set_cbm_file
	void MonstersExternals_OnSetCbm(string musicFile = "")
	{
		OnSetCbmFile(musicFile);
	}

	// ext_conflict
	void MonstersExternals_OnExtConflict()
	{
		LegacyCommand("conflictcheck");
	}

	// ext_showflags
	void MonstersExternals_OnExtShowflags()
	{
		string test = LegacyFunction("get_scriptflag", ENT_ME, "listall");
	}

	// set_mclip
	void MonstersExternals_OnSetMclip(int clip = 0)
	{
		SetMonsterClip(clip != 0);
	}

	// ext_teleportfx1
	void MonstersExternals_OnExtTeleportfx1()
	{
		CallEventDelayed(0.1f, "ext_teleportfx1_delay");
	}

	// ext_teleportfx2
	void MonstersExternals_OnExtTeleportfx2()
	{
		PlaySound(0, 10, "debris/beamstart8.wav");
	}

	// ext_teleportfx1_delay
	void MonstersExternals_OnExtTeleportfx1Delay()
	{
		Vector3 myFeet = OriginOf(ENT_ME);
		myFeet.z = GroundHeight(myFeet);
		ClientEvent("update", "all", Eval("const.localplayer.scriptID"), "cl_tele1_fx", myFeet);
	}

	// ext_beam_follow_test
	void MonstersExternals_OnExtBeamFollowTest()
	{
		DebugPrint("beam_follow_test");
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 0, 5, 30.0f, 255, Vector3(255, 0, 0));
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 1, 5, 30.0f, 255, Vector3(255, 0, 255));
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 2, 5, 30.0f, 255, Vector3(255, 255, 0));
		Effect("beam", "follow", "lgtning.spr", ENT_ME, 3, 5, 30.0f, 255, Vector3(255, 255, 255));
	}

	// set_cadj
	// <ratio> - reduces monsters strength and xp, but sadly, does not affect drops, so use with care
	void MonstersExternals_OnSetCadj(float ratio = 0.0f)
	{
		if (!(ratio > 0.0f))
			return;
		DebugPrint("set_cadj " + Text(ratio));
		float adjRatio = ratio;
		if (!(adjRatio < 1.0f)) // abuse prvention
			return;
		NPC_DMG_MULTI = adjRatio;
		NPC_HP_MULTI = adjRatio;
		SetDamageMultiplier(NPC_DMG_MULTI);
		adjRatio *= 0.5f;
		NPC_EXP_REDUCT = adjRatio;
	}

	// ext_dmgmulti
	void MonstersExternals_OnExtDmgmulti(float multiplier = 0.0f)
	{
		// dbg ext_dmgmulti PARAM1
		SetDamageMultiplier(multiplier); // this is for effects, not addparams
	}

	// set_die_nt
	// <delay>
	void MonstersExternals_OnSetDieNt(float delay = 0.0f)
	{
		bool noSuicide = false;
		// remove mob in <delay> seconds, if no target nearby
		DebugPrint("set_die_nt " + Text(delay));

		if (!NPC_DIE_NT_FIRST_RUN)
		{
			if (delay <= 0.0f)
				return;
			NPC_DIE_NT_FIRST_RUN = true;
			NPC_DIE_NT_NEXT_CHECK = delay;
			NPC_DIE_NT_BASE = delay;
			NPC_LAST_SUICDE_ABORT = GameTime();
			CallEventDelayed(NPC_DIE_NT_NEXT_CHECK, "set_die_nt");
			return;
		}

		if (IsAlive(NPCATK_TARGET) && RangeTo(NPCATK_TARGET) < 256.0f)
			noSuicide = true;

		float gameTime = GameTime();

		// last saw enemy < die delay, abort
		float last = Float(GetVar("NPC_LASTSEEN_ENEMY_TIME")) + NPC_DIE_NT_BASE;
		// add L_LAST NPC_LAST_SUICDE_ABORT
		if (gameTime < last)
			noSuicide = true;

		// last attacked < die delay, abort
		last = Float(GetVar("NPC_LAST_DAMAGED_TIME")) + NPC_DIE_NT_BASE;
		// add L_LAST NPC_LAST_SUICDE_ABORT
		if (gameTime < last)
			noSuicide = true;

		// last damaged enemy < die delay, abort
		last = Float(GetVar("NPC_LAST_DAMAGED_OTHER_TIME")) + NPC_DIE_NT_BASE;
		// add L_LAST NPC_LAST_SUICDE_ABORT
		if (gameTime < last)
			noSuicide = true;

		if (noSuicide)
		{
			NPC_LAST_SUICDE_ABORT = gameTime;
			CallEventDelayed(NPC_DIE_NT_NEXT_CHECK, "set_die_nt"); // try again in a bit
		}
		else
		{
			NPC_SILENT_SUICIDE = true;
			NPC_INVISIBLE_SUICIDE = true;
			NPC_NO_COUNT = true;
			OnNpcSuicide();
		}
	}

	// ext_rmines_clear
	void MonstersExternals_OnExtRminesClear()
	{
		// allows boss mob to tell minions to self-remove faster on the mess that is rmines
		OnNpcatkClearTargets();
		NPC_DIE_NT_NEXT_CHECK = 10.0f;
	}

	// set_mspeed
	// <ratio> - changes the move speed without messing with the attack speed
	void MonstersExternals_OnSetMspeed(float ratio = 0.0f)
	{
		// adjusts xp slightly - see base_self_adjust
		DebugPrint("set_mspeed " + Text(ratio));
		if (!(ratio > 0.0f))
			return;
		if (Text(BASE_MOVESPEED) == "BASE_MOVESPEED")
			BASE_MOVESPEED = 1.0f;
		BASE_MOVESPEED *= ratio;
		NPC_MOVE_SPEED_ADJ = BASE_MOVESPEED;
		SetMoveSpeed(BASE_MOVESPEED);
		SetAnimMoveSpeed(BASE_MOVESPEED);
		DebugPrint("set_mspeed newspeed " + Text(BASE_MOVESPEED));
		PlayAnim("break"); // case we hit a trigger with this, and are moving, otherwise we'll run in place until we attack
		NPC_USES_HANDLE_EVENTS = true;
		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "mspeed");
	}

	// set_mspeedt
	void MonstersExternals_OnSetMspeedt(float moveSpeed = 0.0f)
	{
		DebugPrint("setanim.movespeed " + Text(moveSpeed));
		SetAnimMoveSpeed(moveSpeed);
	}

	// set_mspeed2
	void MonstersExternals_OnSetMspeed2(float moveSpeed = 0.0f)
	{
		DebugPrint("movespeed " + Text(moveSpeed));
		SetMoveSpeed(moveSpeed);
	}

	// set_bbox
	void MonstersExternals_OnSetBbox(string bboxMins = "", string bboxMaxs = "")
	{
		if (bboxMins.isEmpty())
			return;
		DebugPrint("ext_setbbox " + bboxMins);
		if (bboxMaxs.isEmpty())
		{
			SetBoundingBox(bboxMins); // npcsize|animsize - animsize sometimes crashes
		}
		else
		{
			SetBoundingBox(bboxMins, bboxMaxs); // <vec_mins> <vec_maxs>
		}
	}

	// set_range
	// <units> - changes attack range, setting this lower than orig NPC will result in XP nerf
	void MonstersExternals_OnSetRange(float units = 0.0f)
	{
		if (!(units > 0.0f))
			return;
		// some NPC's change their range dynamically, in which case, this may not work
		if (NPC_ORG_RANGE == "NPC_ORG_RANGE") // case we do this more than once, for some reason
			NPC_ORG_RANGE = Text(ATTACK_RANGE);
		NPC_SET_RANGE = Text(units);
		NPC_SET_RANGE_RATIO = Float(NPC_ORG_RANGE); // future use, so we can adjust dynamic ranges
		NPC_SET_RANGE_RATIO = Divide(NPC_SET_RANGE_RATIO, Float(NPC_ORG_RANGE));
		CallEventDelayed(2.0f, "set_range2"); // give mob chance to set his ranges
	}

	// set_range2
	void MonstersExternals_OnSetRange2()
	{
		ATTACK_RANGE = Float(NPC_SET_RANGE);
		ATTACK_HITRANGE = Float(NPC_SET_RANGE);
		ATTACK_HITRANGE *= 2.0f;
	}

	// set_tele_hunter
	// [frequency]
	void MonstersExternals_OnSetTeleHunter(string frequency = "")
	{
		if (NPC_TELEHUNT)
			return;
		DebugPrint("set_tele_hunter " + frequency);
		// periodically teleport to target
		NPC_TELEHUNT = true;
		NPC_TELEHUNTER_FX = 1;
		NPC_TELEHUNT_FREQ = Float(frequency);
		if (frequency.isEmpty())
			NPC_TELEHUNT_FREQ = 20.0f;
		NPC_DO_SPAWN_SOUND = true;
		CallEventDelayed(NPC_TELEHUNT_FREQ, "npcatk_tele_hunter_loop");
		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "telehunt");
	}

	// set_tele_hunter_random
	// [frequency]
	void MonstersExternals_OnSetTeleHunterRandom(string frequency = "")
	{
		if (NPC_TELEHUNT)
			return;
		DebugPrint("set_tele_hunter_random " + frequency);
		// periodically teleport to random players
		PlayAnim("break");
		NPC_TELEHUNT = true;
		NPC_TELEHUNTER_FX = 1;
		NPC_TELEHUNT_FREQ = Float(frequency);
		NPC_TELEHUNT_RANDOM = true;
		if (frequency.isEmpty())
			NPC_TELEHUNT_FREQ = 20.0f;
		NPC_DO_SPAWN_SOUND = true;
		CallEventDelayed(NPC_TELEHUNT_FREQ, "npcatk_tele_hunter_loop");

		if (NPC_ADJ_FLAGS == "NPC_ADJ_FLAGS")
			NPC_ADJ_FLAGS = "";
		NPC_ADJ_FLAGS = TokenAdd(NPC_ADJ_FLAGS, "telehunt");
	}

	// set_skin
	// <index>
	void MonstersExternals_OnSetSkin(string skinIndex = "")
	{
		if (skinIndex.isEmpty())
			return;
		NPC_CUSTOM_SKIN = skinIndex;
		SetProp(ENT_ME, "skin", skinIndex);
	}

	// set_say_spawn
	void MonstersExternals_OnSetSaySpawn(string spawnText = "")
	{
		if (spawnText.isEmpty())
			return;
		SetSayTextRange(2048);
		SayText(spawnText);
	}

	// set_say_spot
	void MonstersExternals_OnSetSaySpot(string spotText = "")
	{
		if (spotText.isEmpty())
			return;
		SetSayTextRange(2048);
		NPC_DO_ON_SPOT += 1.0f;
		NPC_SAY_ON_SPOT = spotText;
	}

	// set_say_die
	void MonstersExternals_OnSetSayDie(string deathText = "")
	{
		if (deathText.isEmpty())
			return;
		SetSayTextRange(2048);
		NPC_DO_ON_DIE += 1.0f;
		NPC_SAY_ON_DIE = deathText;
	}

	// set_dump_xp
	// todos: set_tele_hunter_in_and_out (teleports off map) set_tele_hunter_ranged (larger radious from player)
	// [begin] Script Side XP: future use experiment
	void MonstersExternals_OnSetDumpXp()
	{
		DebugPrint("set_dump_xp set");
		NPC_DUMP_XP = true; // causes mob to dump hitdata to array on death code side (CMSMonster::Killed)
	}

	// game_death
	void MonstersExternals_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!NPC_DUMP_XP)
			return;
		DebugPrint("dumping xp... [ " + GetArrayCount("ARRAY_XP_PLAYERS") + " ]");
		int count = GetArrayCount("ARRAY_XP_PLAYERS");
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDbgDumpXp();
		}
	}

	// dbg_dump_xp
	void MonstersExternals_OnDbgDumpXp()
	{
		int curHit = loopIteration;
		string curPlr = GetArray("ARRAY_XP_PLAYERS", Text(curHit));
		curPlr = NameOf(curPlr);
		string curSkl = GetArray("ARRAY_XP_SKILLS", Text(curHit));
		string curExp = GetArray("ARRAY_XP_AMTS", Text(curHit));
		DebugPrint("dbg_dump_xp " + curPlr + " " + curSkl + " " + curExp);
	}

	// set_solid
	void MonstersExternals_OnSetSolid(string solidType = "")
	{
		DebugPrint("set_solid " + solidType);
		// this seems silly, but still have mysterious bug where this gets called twice and mystery param sometimes gets passed.
		if (solidType == "none")
			SetSolid(solidType);
		if (solidType == "box")
			SetSolid(solidType);
		if (solidType == "slidebox")
			SetSolid(solidType);
		if (solidType == "trigger")
			SetSolid(solidType);
	}

	// ext_clearfx
	// [end] Script Side XP: future use experiment
	void MonstersExternals_OnExtClearfx()
	{
		DebugPrint("ext_clearfx");
		ClearEffects();
	}

	// ext_remove_effect
	void MonstersExternals_OnExtRemoveEffect(string effectName = "")
	{
		// . eventall ext_remove_effect freeze_solid
		// . eventall ext_remove_effect iceshield
		DebugPrint("ext_remove_effect " + effectName);
		LegacyCommand("removeeffect", ENT_ME, effectName);
	}

	// ext_break
	void MonstersExternals_OnExtBreak()
	{
		DebugPrint("ext_break");
		PlayAnim("break");
	}

	// ext_bleed
	void MonstersExternals_OnExtBleed(string color = "", string amount = "")
	{
		DebugPrint("ext_bleed col " + color + " amt " + amount);
		LegacyCommand("bleed", ENT_ME, color, amount);
	}

	// set_takedmg
	// <type:ratio>
	void MonstersExternals_OnSetTakedmg(string typeRatio = "")
	{
		string dmgType = LegacyFunction("string_upto", typeRatio, ":");
		int dmgRatio = Int(LegacyFunction("string_from", typeRatio, ":"));
		SetDamageTaken(dmgType, dmgRatio);
	}

	// set_notarget
	// <0|1>
	void MonstersExternals_OnSetNotarget(string playingDead = "")
	{
		if (playingDead.isEmpty())
			return;
		PLAYING_DEAD = playingDead;
	}

	// ext_set_next_circle_heal
	void MonstersExternals_OnExtSetNextCircleHeal(string healAmount = "")
	{
		NEXT_CIRCLE_HEAL = healAmount;
	}

	// ext_delay_target
	// <delay> <target|"enemy"> selects a target (after delay for init), useful for summons
	void MonstersExternals_OnExtDelayTarget(float delay = 0.0f, string target = "")
	{
		NPC_DELAY_TARGET = target;
		if (NPC_DELAY_TARGET.isEmpty())
			return;
		CallEventDelayed(delay, "ext_delay_target2");
	}

	// ext_delay_target2
	void MonstersExternals_OnExtDelayTarget2()
	{
		bool doScan = false;
		if (NPC_DELAY_TARGET == "enemy")
			doScan = true;
		if (!IsAlive(NPC_DELAY_TARGET))
			doScan = true;

		if (doScan)
		{
			string targs = FindInSphere("enemy", 2048);
			targs = SortEntities(targs, "range");
			OnNpcatkSettarget(GetToken(targs, 0));
		}
		else
		{
			OnNpcatkSettarget(NPC_DELAY_TARGET);
		}
	}

	// set_world_spawn
	void MonstersExternals_OnSetWorldSpawn()
	{
		ApplyEffect(self, "effects/add_dynamic_spawn", "world");
	}

	// set_dyn_spawn
	void MonstersExternals_OnSetDynSpawn()
	{
		ApplyEffect(self, "effects/add_dynamic_spawn");
	}

	// toggle_invincible
	// makes the monster invincible if they are not, or turns it off if they are.
	void MonstersExternals_OnToggleInvincible()
	{
		if (Truthy(GetProp(ENT_ME, "invincible")))
			SetInvincible(false);
		else
			SetInvincible(true);
	}

	// make_phys_immune
	void MonstersExternals_OnMakePhysImmune()
	{
		OnImmuneGhost();
	}

	// immune_ghost
	void MonstersExternals_OnImmuneGhost()
	{
		SetDamageTaken("slash", 0);
		SetDamageTaken("blunt", 0);
		SetDamageTaken("pierce", 0);
		OnExtEresistAdj();
		OnExtEresistAdj();
		IS_BLOODLESS = true;
	}

	// ext_hearingsensitivity
	void MonstersExternals_OnExtHearingsensitivity(float sensitivity = 0.0f)
	{
		SetHearingSensitivity(sensitivity);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnOrcRace() { MonstersExternals_OnOrcRace(); } // orc_race
	void OnDemonRace() { MonstersExternals_OnDemonRace(); } // demon_race
	void OnUndeadRace() { MonstersExternals_OnUndeadRace(); } // undead_race
	void OnHumanRace() { MonstersExternals_OnHumanRace(); } // human_race
	void OnSpiderRace() { MonstersExternals_OnSpiderRace(); } // spider_race
	void OnWildanimalRace() { MonstersExternals_OnWildanimalRace(); } // wildanimal_race
	void OnHatedRace() { MonstersExternals_OnHatedRace(); } // hated_race
	void OnBelovedRace() { MonstersExternals_OnBelovedRace(); } // beloved_race
	void OnEvilRace() { MonstersExternals_OnEvilRace(); } // evil_race
	void OnGoodRace() { MonstersExternals_OnGoodRace(); } // good_race
	void OnVerminRace() { MonstersExternals_OnVerminRace(); } // vermin_race
	void OnRogueRace() { MonstersExternals_OnRogueRace(); } // rogue_race
	void OnHguardRace() { MonstersExternals_OnHguardRace(); } // hguard_race
	void OnNeutralRace() { MonstersExternals_OnNeutralRace(); } // neutral_race
	void OnLightningImmune() { MonstersExternals_OnLightningImmune(); } // lightning_immune
	void OnFireImmune() { MonstersExternals_OnFireImmune(); } // fire_immune
	void OnPoisonImmune() { MonstersExternals_OnPoisonImmune(); } // poison_immune
	void OnColdImmune() { MonstersExternals_OnColdImmune(); } // cold_immune
	void OnNormalImmune() { MonstersExternals_OnNormalImmune(); } // normal_immune
	void OnFiftyArmor() { MonstersExternals_OnFiftyArmor(); } // fifty_armor
	void OnEightyArmor() { MonstersExternals_OnEightyArmor(); } // eighty_armor
	void OnNoArmor() { MonstersExternals_OnNoArmor(); } // no_armor
	void OnWeakenedArmor() { MonstersExternals_OnWeakenedArmor(); } // weakened_armor
	void OnMakeInvulnerable() { MonstersExternals_OnMakeInvulnerable(); } // make_invulnerable
	void OnMakeVulnerable() { MonstersExternals_OnMakeVulnerable(); } // make_vulnerable
	void OnAdd10Health() { MonstersExternals_OnAdd10Health(); } // add_10_health
	void OnAdd100Health() { MonstersExternals_OnAdd100Health(); } // add_100_health
	void OnAdd500Health() { MonstersExternals_OnAdd500Health(); } // add_500_health
	void OnAdd1000Health() { MonstersExternals_OnAdd1000Health(); } // add_1000_health
	void OnDoubleHealth() { MonstersExternals_OnDoubleHealth(); } // double_health
	void OnQuadHealth() { MonstersExternals_OnQuadHealth(); } // quad_health
	void OnHalfHealth() { MonstersExternals_OnHalfHealth(); } // half_health
	void OnNpcFadeAway() { MonstersExternals_OnNpcFadeAway(); } // npc_fade_away
	void OnGoRoam() { MonstersExternals_OnGoRoam(); } // go_roam
	void OnNoRoam() { MonstersExternals_OnNoRoam(); } // no_roam
	void OnSetStunProt(float stunProtection = 0.0f) { MonstersExternals_OnSetStunProt(stunProtection); } // set_stun_prot
	void OnNpcSuicide(string suicideMode = "") { MonstersExternals_OnNpcSuicide(suicideMode); } // npc_suicide
	void OnFreezeSolidStart(string freezeDuration = "", string attacker = "") { MonstersExternals_OnFreezeSolidStart(freezeDuration, attacker); } // freeze_solid_start
	void OnFreezeSolidEnd(int unfrozeEarly = 0) { MonstersExternals_OnFreezeSolidEnd(unfrozeEarly); } // freeze_solid_end
	void OnDoubleUnfreeze() { MonstersExternals_OnDoubleUnfreeze(); } // double_unfreeze
	void OnTallyRace() { MonstersExternals_OnTallyRace(); } // tally_race
	void OnTallyEnemy(string npc = "") { MonstersExternals_OnTallyEnemy(npc); } // tally_enemy
	void OnSendDamage(string target = "", string mode = "", string damage = "", string percent = "", string attacker = "", string effect = "", string flags = "") { MonstersExternals_OnSendDamage(target, mode, damage, percent, attacker, effect, flags); } // send_damage
	void OnDemonBlood(string damageRatio = "") { MonstersExternals_OnDemonBlood(damageRatio); } // demon_blood
	void OnDemonBloodLoop() { MonstersExternals_OnDemonBloodLoop(); } // demon_blood_loop
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { return MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent); } // game_damaged_other
	void OnExtHitManaball() { MonstersExternals_OnExtHitManaball(); } // ext_hit_manaball
	void OnResetHitByManaball() { MonstersExternals_OnResetHitByManaball(); } // reset_hit_by_manaball
	void OnExtPlaysoundKiss(int channel = 0, int volume = 0, string soundFile = "") { MonstersExternals_OnExtPlaysoundKiss(channel, volume, soundFile); } // ext_playsound_kiss
	void OnExtSvplaysoundKiss(int channel = 0, int volume = 0, string sound = "", float attenuation = 0.0f, int pitch = 0) { MonstersExternals_OnExtSvplaysoundKiss(channel, volume, sound, attenuation, pitch); } // ext_svplaysound_kiss
	void OnExtMonPlaysound(int soundFile = 0, int soundSource = 0, string maxRange = "") { MonstersExternals_OnExtMonPlaysound(soundFile, soundSource, maxRange); } // ext_mon_playsound
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null) { MonstersExternals_OnTurnUndead(holyDamage, exorcist); } // turn_undead
	void OnExtSpeak(string text = "") { MonstersExternals_OnExtSpeak(text); } // ext_speak
	void OnGiveHp(string amount = "") { MonstersExternals_OnGiveHp(amount); } // give_hp
	void OnExtInvalidate(string invalidFlag = "") { MonstersExternals_OnExtInvalidate(invalidFlag); } // ext_invalidate
	void OnExtDodamage(CBaseEntity@ target = null, string hitMode = "", float damage = 0.0f, string hitChance = "", string attacker = "", string damageSkill = "", string value = "") { MonstersExternals_OnExtDodamage(target, hitMode, damage, hitChance, attacker, damageSkill, value); } // ext_dodamage
	void OnExtSetFreezeAmt(string freezeAmount = "") { MonstersExternals_OnExtSetFreezeAmt(freezeAmount); } // ext_set_freeze_amt
	void OnExtFlashBang(Vector3 origin = Vector3(), int radius = 0, CBaseEntity@ sourceOwner = null) { MonstersExternals_OnExtFlashBang(origin, radius, sourceOwner); } // ext_flash_bang
	void OnSpeedX2() { MonstersExternals_OnSpeedX2(); } // speed_x2
	void OnSpeedX25() { MonstersExternals_OnSpeedX25(); } // speed_x2_5
	void OnSpeedX3() { MonstersExternals_OnSpeedX3(); } // speed_x3
	void OnSpeedX4() { MonstersExternals_OnSpeedX4(); } // speed_x4
	void OnCriticalNpc() { MonstersExternals_OnCriticalNpc(); } // critical_npc
	void OnExtMonsterspawnRemoved(CBaseEntity@ spawnId = null) { MonstersExternals_OnExtMonsterspawnRemoved(spawnId); } // ext_monsterspawn_removed
	void OnGlowRed() { MonstersExternals_OnGlowRed(); } // glow_red
	void OnGlowGreen() { MonstersExternals_OnGlowGreen(); } // glow_green
	void OnGlowBlue() { MonstersExternals_OnGlowBlue(); } // glow_blue
	void OnGlowYellow() { MonstersExternals_OnGlowYellow(); } // glow_yellow
	void OnGlowPurple() { MonstersExternals_OnGlowPurple(); } // glow_purple
	void OnGlowCustom(string glow = "") { MonstersExternals_OnGlowCustom(glow); } // glow_custom
	void OnGlowRemove() { MonstersExternals_OnGlowRemove(); } // glow_remove
	void OnRemoveGhost() { MonstersExternals_OnRemoveGhost(); } // remove_ghost
	void OnMakeGhost() { MonstersExternals_OnMakeGhost(); } // make_ghost

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn();
		MonstersExternals_OnNpcPostSpawn_2();
		MonstersExternals_OnNpcPostSpawn_3();
	}

	void OnNpcatkResetGlow() { MonstersExternals_OnNpcatkResetGlow(); } // npcatk_reset_glow
	void OnNpcatkResetGhost() { MonstersExternals_OnNpcatkResetGhost(); } // npcatk_reset_ghost
	void OnSetRace(string raceName = "") { MonstersExternals_OnSetRace(raceName); } // set_race
	void OnSetModel(string model = "") { MonstersExternals_OnSetModel(model); } // set_model
	void OnExtReportArmor(string armorType = "", string player = "") { MonstersExternals_OnExtReportArmor(armorType, player); } // ext_report_armor
	void OnExtSetParry(string parrySkill = "") { MonstersExternals_OnExtSetParry(parrySkill); } // ext_set_parry
	void OnExtBlind() { MonstersExternals_OnExtBlind(); } // ext_blind
	void OnExtUnblind() { MonstersExternals_OnExtUnblind(); } // ext_unblind
	void OnGameDrainDeath(CBaseEntity@ attacker = null) { MonstersExternals_OnGameDrainDeath(attacker); } // game_drain_death
	void OnExtWinkOut(Vector3 spawnPosition = Vector3(), float delay = 0.0f) { MonstersExternals_OnExtWinkOut(spawnPosition, delay); } // ext_wink_out
	void OnExtWinkIn() { MonstersExternals_OnExtWinkIn(); } // ext_wink_in
	void OnMakeBoss() { MonstersExternals_OnMakeBoss(); } // make_boss
	void OnExtMakepet(CBaseEntity@ owner = null) { MonstersExternals_OnExtMakepet(owner); } // ext_makepet
	void OnExtSetHealth(float health = 0.0f, float maxHealth = 0.0f) { MonstersExternals_OnExtSetHealth(health, maxHealth); } // ext_set_health
	void OnIgnoreCriticalNpc() { MonstersExternals_OnIgnoreCriticalNpc(); } // ignore_critical_npc
	void OnExtHitChance(float hitMultiplier = 0.0f) { MonstersExternals_OnExtHitChance(hitMultiplier); } // ext_hit_chance
	void OnExtSetFrozen(string duration = "") { MonstersExternals_OnExtSetFrozen(duration); } // ext_set_frozen
	void OnExtSetUnfrozen() { MonstersExternals_OnExtSetUnfrozen(); } // ext_set_unfrozen
	void OnExtUnsummon() { MonstersExternals_OnExtUnsummon(); } // ext_unsummon
	void OnExtSphereTokenX(string scanType = "", float scanRange = 0.0f) { MonstersExternals_OnExtSphereTokenX(scanType, scanRange); } // ext_sphere_token_x
	void OnExtSphereToken(string scanType = "", int scanRange = 0, Vector3 scanOrigin = Vector3()) { MonstersExternals_OnExtSphereToken(scanType, scanRange, scanOrigin); } // ext_sphere_token
	void OnExtBoxToken(string scanType = "", int scanRange = 0, string scanOrigin = "") { MonstersExternals_OnExtBoxToken(scanType, scanRange, scanOrigin); } // ext_box_token
	void OnExtReductXp(float xpReduction = 0.0f) { MonstersExternals_OnExtReductXp(xpReduction); } // ext_reduct_xp
	void OnExtNoDrops() { MonstersExternals_OnExtNoDrops(); } // ext_no_drops
	void OnExtNoDrops2() { MonstersExternals_OnExtNoDrops2(); } // ext_no_drops2
	void OnExtEntListSort(string scanFilter = "", string searchRange = "", string searchOrigin = "", string sortBy = "") { MonstersExternals_OnExtEntListSort(scanFilter, searchRange, searchOrigin, sortBy); } // ext_ent_list_sort
	void OnExtNoPlayerDamage() { MonstersExternals_OnExtNoPlayerDamage(); } // ext_no_player_damage
	void OnExtSetrender(string renderMode = "") { MonstersExternals_OnExtSetrender(renderMode); } // ext_setrender
	void OnSetScaleNr(string ratio = "") { MonstersExternals_OnSetScaleNr(ratio); } // set_scale_nr
	void OnSetScaleNb(string ratio = "") { MonstersExternals_OnSetScaleNb(ratio); } // set_scale_nb
	void OnSetScaleNbr(string ratio = "") { MonstersExternals_OnSetScaleNbr(ratio); } // set_scale_nbr
	void OnExtScale(float ratio = 0.0f, int noBoundingFix = 0, int noRangeFix = 0) { MonstersExternals_OnExtScale(ratio, noBoundingFix, noRangeFix); } // ext_scale
	void OnSetScale(float scale = 0.0f) { MonstersExternals_OnSetScale(scale); } // set_scale
	void OnExtAdjustScaleRange() { MonstersExternals_OnExtAdjustScaleRange(); } // ext_adjust_scale_range
	void OnSetAttackUntilSpotted() { MonstersExternals_OnSetAttackUntilSpotted(); } // set_attack_until_spotted
	void OnNpcatkAttackTillSpotted() { MonstersExternals_OnNpcatkAttackTillSpotted(); } // npcatk_attack_till_spotted
	void OnSetFadeIn(float fadeRate = 0.0f) { MonstersExternals_OnSetFadeIn(fadeRate); } // set_fade_in
	void OnSetFadeInLoop() { MonstersExternals_OnSetFadeInLoop(); } // set_fade_in_loop
	void OnSetNoStepAdj() { MonstersExternals_OnSetNoStepAdj(); } // set_no_step_adj
	void OnSetNpcTurret() { MonstersExternals_OnSetNpcTurret(); } // set_npc_turret
	void OnSetNpcTurret2() { MonstersExternals_OnSetNpcTurret2(); } // set_npc_turret2
	void OnSetSummonCircle() { MonstersExternals_OnSetSummonCircle(); } // set_summon_circle
	void OnSetSummonCircle2() { MonstersExternals_OnSetSummonCircle2(); } // set_summon_circle2
	void OnSetSummonCircle3() { MonstersExternals_OnSetSummonCircle3(); } // set_summon_circle3
	void OnSetTakedmgHoly(float holyRatio = 0.0f) { MonstersExternals_OnSetTakedmgHoly(holyRatio); } // set_takedmg_holy
	void OnSetStepsize(float stepSize = 0.0f) { MonstersExternals_OnSetStepsize(stepSize); } // set_stepsize
	void OnExtPlayanim(string animation = "") { MonstersExternals_OnExtPlayanim(animation); } // ext_playanim
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "") { MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); } // bs_global_command
	void OnExtDbg(string debugValue = "") { MonstersExternals_OnExtDbg(debugValue); } // ext_dbg
	void OnExtDbgLoop() { MonstersExternals_OnExtDbgLoop(); } // ext_dbg_loop
	void OnSetBlindAttack() { MonstersExternals_OnSetBlindAttack(); } // set_blind_attack
	void OnExtSpawnSound() { MonstersExternals_OnExtSpawnSound(); } // ext_spawn_sound
	void OnSetfxSpawnSound() { MonstersExternals_OnSetfxSpawnSound(); } // setfx_spawn_sound
	void OnSetfxSummonCircle() { MonstersExternals_OnSetfxSummonCircle(); } // setfx_summon_circle
	void OnSetfxFadeIn() { MonstersExternals_OnSetfxFadeIn(); } // setfx_fade_in
	void OnSetfxTeleIn() { MonstersExternals_OnSetfxTeleIn(); } // setfx_tele_in
	void OnSetfxTeleIn2() { MonstersExternals_OnSetfxTeleIn2(); } // setfx_tele_in2
	void OnSetNoPlayerDamage() { MonstersExternals_OnSetNoPlayerDamage(); } // set_no_player_damage
	void OnExtSetmodelbody(int bodyGroup = 0, int submodel = 0) { MonstersExternals_OnExtSetmodelbody(bodyGroup, submodel); } // ext_setmodelbody
	void OnSetDieOnSpawnRemoved() { MonstersExternals_OnSetDieOnSpawnRemoved(); } // set_die_on_spawn_removed
	void OnSetDosr() { MonstersExternals_OnSetDosr(); } // set_dosr
	void OnSetNoRoam() { MonstersExternals_OnSetNoRoam(); } // set_no_roam
	void OnSetRoam(string enabled = "") { MonstersExternals_OnSetRoam(enabled); } // set_roam
	void OnTrigDamage(string triggerName = "", string damage = "", string damageType = "") { MonstersExternals_OnTrigDamage(triggerName, damage, damageType); } // trig_damage
	void OnSetSelfAdj(string adjDown = "") { MonstersExternals_OnSetSelfAdj(adjDown); } // set_self_adj
	void OnSetNoAvg() { MonstersExternals_OnSetNoAvg(); } // set_no_avg
	void OnSetPoisonous(string value = "") { MonstersExternals_OnSetPoisonous(value); } // set_poisonous
	void OnAddDotPoison(float ratio = 0.0f) { MonstersExternals_OnAddDotPoison(ratio); } // add_dot_poison
	void OnAddDotCold(float ratio = 0.0f) { MonstersExternals_OnAddDotCold(ratio); } // add_dot_cold
	void OnAddDotFire(float ratio = 0.0f) { MonstersExternals_OnAddDotFire(ratio); } // add_dot_fire
	void OnAddDotLightning(float ratio = 0.0f) { MonstersExternals_OnAddDotLightning(ratio); } // add_dot_lightning
	void OnSetNoAutoActivate() { MonstersExternals_OnSetNoAutoActivate(); } // set_no_auto_activate
	void OnSetNonAgro() { MonstersExternals_OnSetNonAgro(); } // set_non_agro
	void OnSetfxSpriteIn() { MonstersExternals_OnSetfxSpriteIn(); } // setfx_sprite_in
	void OnSetfxSpriteInx() { MonstersExternals_OnSetfxSpriteInx(); } // setfx_sprite_inx
	void OnSetSummon() { MonstersExternals_OnSetSummon(); } // set_summon
	void OnExtSummonFade() { MonstersExternals_OnExtSummonFade(); } // ext_summon_fade
	void OnSetFadeinDelayed() { MonstersExternals_OnSetFadeinDelayed(); } // set_fadein_delayed
	void OnSetfxBeamIn() { MonstersExternals_OnSetfxBeamIn(); } // setfx_beam_in
	void OnSetXpTr(float minutes = 0.0f) { MonstersExternals_OnSetXpTr(minutes); } // set_xp_tr
	void OnSetXpTimerampStart() { MonstersExternals_OnSetXpTimerampStart(); } // set_xp_timeramp_start
	void OnSetXpTimerampLoop() { MonstersExternals_OnSetXpTimerampLoop(); } // set_xp_timeramp_loop
	void OnGameScriptflagUpdate(string action = "", string flagName = "", string flagType = "", float value = 0.0f, float baseExpireTime = 0.0f) { MonstersExternals_OnGameScriptflagUpdate(action, flagName, flagType, value, baseExpireTime); } // game_scriptflag_update
	void OnCheckFlagsExpired() { MonstersExternals_OnCheckFlagsExpired(); } // check_flags_expired
	void OnSetCbmFile(string musicFile = "") { MonstersExternals_OnSetCbmFile(musicFile); } // set_cbm_file
	void OnSetCbm(string musicFile = "") { MonstersExternals_OnSetCbm(musicFile); } // set_cbm
	void OnExtConflict() { MonstersExternals_OnExtConflict(); } // ext_conflict
	void OnExtShowflags() { MonstersExternals_OnExtShowflags(); } // ext_showflags
	void OnSetMclip(int clip = 0) { MonstersExternals_OnSetMclip(clip); } // set_mclip
	void OnExtTeleportfx1() { MonstersExternals_OnExtTeleportfx1(); } // ext_teleportfx1
	void OnExtTeleportfx2() { MonstersExternals_OnExtTeleportfx2(); } // ext_teleportfx2
	void OnExtTeleportfx1Delay() { MonstersExternals_OnExtTeleportfx1Delay(); } // ext_teleportfx1_delay
	void OnExtBeamFollowTest() { MonstersExternals_OnExtBeamFollowTest(); } // ext_beam_follow_test
	void OnSetCadj(float ratio = 0.0f) { MonstersExternals_OnSetCadj(ratio); } // set_cadj
	void OnExtDmgmulti(float multiplier = 0.0f) { MonstersExternals_OnExtDmgmulti(multiplier); } // ext_dmgmulti
	void OnSetDieNt(float delay = 0.0f) { MonstersExternals_OnSetDieNt(delay); } // set_die_nt
	void OnExtRminesClear() { MonstersExternals_OnExtRminesClear(); } // ext_rmines_clear
	void OnSetMspeed(float ratio = 0.0f) { MonstersExternals_OnSetMspeed(ratio); } // set_mspeed
	void OnSetMspeedt(float moveSpeed = 0.0f) { MonstersExternals_OnSetMspeedt(moveSpeed); } // set_mspeedt
	void OnSetMspeed2(float moveSpeed = 0.0f) { MonstersExternals_OnSetMspeed2(moveSpeed); } // set_mspeed2
	void OnSetBbox(string bboxMins = "", string bboxMaxs = "") { MonstersExternals_OnSetBbox(bboxMins, bboxMaxs); } // set_bbox
	void OnSetRange(float units = 0.0f) { MonstersExternals_OnSetRange(units); } // set_range
	void OnSetRange2() { MonstersExternals_OnSetRange2(); } // set_range2
	void OnSetTeleHunter(string frequency = "") { MonstersExternals_OnSetTeleHunter(frequency); } // set_tele_hunter
	void OnSetTeleHunterRandom(string frequency = "") { MonstersExternals_OnSetTeleHunterRandom(frequency); } // set_tele_hunter_random
	void OnSetSkin(string skinIndex = "") { MonstersExternals_OnSetSkin(skinIndex); } // set_skin
	void OnSetSaySpawn(string spawnText = "") { MonstersExternals_OnSetSaySpawn(spawnText); } // set_say_spawn
	void OnSetSaySpot(string spotText = "") { MonstersExternals_OnSetSaySpot(spotText); } // set_say_spot
	void OnSetSayDie(string deathText = "") { MonstersExternals_OnSetSayDie(deathText); } // set_say_die
	void OnSetDumpXp() { MonstersExternals_OnSetDumpXp(); } // set_dump_xp
	void OnDbgDumpXp() { MonstersExternals_OnDbgDumpXp(); } // dbg_dump_xp
	void OnSetSolid(string solidType = "") { MonstersExternals_OnSetSolid(solidType); } // set_solid
	void OnExtClearfx() { MonstersExternals_OnExtClearfx(); } // ext_clearfx
	void OnExtRemoveEffect(string effectName = "") { MonstersExternals_OnExtRemoveEffect(effectName); } // ext_remove_effect
	void OnExtBreak() { MonstersExternals_OnExtBreak(); } // ext_break
	void OnExtBleed(string color = "", string amount = "") { MonstersExternals_OnExtBleed(color, amount); } // ext_bleed
	void OnSetTakedmg(string typeRatio = "") { MonstersExternals_OnSetTakedmg(typeRatio); } // set_takedmg
	void OnSetNotarget(string playingDead = "") { MonstersExternals_OnSetNotarget(playingDead); } // set_notarget
	void OnExtSetNextCircleHeal(string healAmount = "") { MonstersExternals_OnExtSetNextCircleHeal(healAmount); } // ext_set_next_circle_heal
	void OnExtDelayTarget(float delay = 0.0f, string target = "") { MonstersExternals_OnExtDelayTarget(delay, target); } // ext_delay_target
	void OnExtDelayTarget2() { MonstersExternals_OnExtDelayTarget2(); } // ext_delay_target2
	void OnSetWorldSpawn() { MonstersExternals_OnSetWorldSpawn(); } // set_world_spawn
	void OnSetDynSpawn() { MonstersExternals_OnSetDynSpawn(); } // set_dyn_spawn
	void OnToggleInvincible() { MonstersExternals_OnToggleInvincible(); } // toggle_invincible
	void OnMakePhysImmune() { MonstersExternals_OnMakePhysImmune(); } // make_phys_immune
	void OnImmuneGhost() { MonstersExternals_OnImmuneGhost(); } // immune_ghost
	void OnExtHearingsensitivity(float sensitivity = 0.0f) { MonstersExternals_OnExtHearingsensitivity(sensitivity); } // ext_hearingsensitivity
	void OnIceCageDuration() {} // ICE_CAGE_DURATION
	void OnLCheckExptime() {} // L_CHECK_EXPTIME
	void OnLFadeDelay() {} // L_FADE_DELAY
	void OnNpcDieNtNextCheck() {} // NPC_DIE_NT_NEXT_CHECK
	void OnNpcFadeInSpeed() {} // NPC_FADE_IN_SPEED
	void OnNpcTelehuntFreq() {} // NPC_TELEHUNT_FREQ
	void OnExtEresistAdj() {} // ext_eresist_adj
	void OnNpcFadeinDone() {} // npc_fadein_done
	void OnNpcatkClearTargets(string reason = "") {} // npcatk_clear_targets
	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") {} // npcatk_flee
	void OnNpcatkResumeAi(string target = "") {} // npcatk_resume_ai
	void OnNpcatkSettarget(string target = "", string debug = "") {} // npcatk_settarget
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool MonstersExternals_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "add_1000_health") { OnAdd1000Health(); return true; }
		if (name == "add_100_health") { OnAdd100Health(); return true; }
		if (name == "add_10_health") { OnAdd10Health(); return true; }
		if (name == "add_500_health") { OnAdd500Health(); return true; }
		if (name == "add_dot_cold") { OnAddDotCold(Float(Param(params, 0))); return true; }
		if (name == "add_dot_fire") { OnAddDotFire(Float(Param(params, 0))); return true; }
		if (name == "add_dot_lightning") { OnAddDotLightning(Float(Param(params, 0))); return true; }
		if (name == "add_dot_poison") { OnAddDotPoison(Float(Param(params, 0))); return true; }
		if (name == "beloved_race") { OnBelovedRace(); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "check_flags_expired") { OnCheckFlagsExpired(); return true; }
		if (name == "cold_immune") { OnColdImmune(); return true; }
		if (name == "critical_npc") { OnCriticalNpc(); return true; }
		if (name == "dbg_dump_xp") { OnDbgDumpXp(); return true; }
		if (name == "demon_blood") { OnDemonBlood(Param(params, 0)); return true; }
		if (name == "demon_blood_loop") { OnDemonBloodLoop(); return true; }
		if (name == "demon_race") { OnDemonRace(); return true; }
		if (name == "double_health") { OnDoubleHealth(); return true; }
		if (name == "double_unfreeze") { OnDoubleUnfreeze(); return true; }
		if (name == "eighty_armor") { OnEightyArmor(); return true; }
		if (name == "evil_race") { OnEvilRace(); return true; }
		if (name == "ext_adjust_scale_range") { OnExtAdjustScaleRange(); return true; }
		if (name == "ext_beam_follow_test") { OnExtBeamFollowTest(); return true; }
		if (name == "ext_bleed") { OnExtBleed(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_blind") { OnExtBlind(); return true; }
		if (name == "ext_box_token") { OnExtBoxToken(Param(params, 0), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_break") { OnExtBreak(); return true; }
		if (name == "ext_clearfx") { OnExtClearfx(); return true; }
		if (name == "ext_conflict") { OnExtConflict(); return true; }
		if (name == "ext_dbg") { OnExtDbg(Param(params, 0)); return true; }
		if (name == "ext_dbg_loop") { OnExtDbgLoop(); return true; }
		if (name == "ext_delay_target") { OnExtDelayTarget(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "ext_delay_target2") { OnExtDelayTarget2(); return true; }
		if (name == "ext_dmgmulti") { OnExtDmgmulti(Float(Param(params, 0))); return true; }
		if (name == "ext_dodamage") { OnExtDodamage(EntityParam(params, 0), Param(params, 1), Float(Param(params, 2)), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "ext_ent_list_sort") { OnExtEntListSort(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "ext_flash_bang") { OnExtFlashBang(Vec(Param(params, 0)), Int(Param(params, 1)), EntityParam(params, 2)); return true; }
		if (name == "ext_hearingsensitivity") { OnExtHearingsensitivity(Float(Param(params, 0))); return true; }
		if (name == "ext_hit_chance") { OnExtHitChance(Float(Param(params, 0))); return true; }
		if (name == "ext_hit_manaball") { OnExtHitManaball(); return true; }
		if (name == "ext_invalidate") { OnExtInvalidate(Param(params, 0)); return true; }
		if (name == "ext_makepet") { OnExtMakepet(EntityParam(params, 0)); return true; }
		if (name == "ext_mon_playsound") { OnExtMonPlaysound(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_monsterspawn_removed") { OnExtMonsterspawnRemoved(EntityParam(params, 0)); return true; }
		if (name == "ext_no_drops") { OnExtNoDrops(); return true; }
		if (name == "ext_no_drops2") { OnExtNoDrops2(); return true; }
		if (name == "ext_no_player_damage") { OnExtNoPlayerDamage(); return true; }
		if (name == "ext_playanim") { OnExtPlayanim(Param(params, 0)); return true; }
		if (name == "ext_playsound_kiss") { OnExtPlaysoundKiss(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2)); return true; }
		if (name == "ext_reduct_xp") { OnExtReductXp(Float(Param(params, 0))); return true; }
		if (name == "ext_remove_effect") { OnExtRemoveEffect(Param(params, 0)); return true; }
		if (name == "ext_report_armor") { OnExtReportArmor(Param(params, 0), Param(params, 1)); return true; }
		if (name == "ext_rmines_clear") { OnExtRminesClear(); return true; }
		if (name == "ext_scale") { OnExtScale(Float(Param(params, 0)), Int(Param(params, 1)), Int(Param(params, 2))); return true; }
		if (name == "ext_set_freeze_amt") { OnExtSetFreezeAmt(Param(params, 0)); return true; }
		if (name == "ext_set_frozen") { OnExtSetFrozen(Param(params, 0)); return true; }
		if (name == "ext_set_health") { OnExtSetHealth(Float(Param(params, 0)), Float(Param(params, 1))); return true; }
		if (name == "ext_set_next_circle_heal") { OnExtSetNextCircleHeal(Param(params, 0)); return true; }
		if (name == "ext_set_parry") { OnExtSetParry(Param(params, 0)); return true; }
		if (name == "ext_set_unfrozen") { OnExtSetUnfrozen(); return true; }
		if (name == "ext_setmodelbody") { OnExtSetmodelbody(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "ext_setrender") { OnExtSetrender(Param(params, 0)); return true; }
		if (name == "ext_showflags") { OnExtShowflags(); return true; }
		if (name == "ext_spawn_sound") { OnExtSpawnSound(); return true; }
		if (name == "ext_speak") { OnExtSpeak(Param(params, 0)); return true; }
		if (name == "ext_sphere_token") { OnExtSphereToken(Param(params, 0), Int(Param(params, 1)), Vec(Param(params, 2))); return true; }
		if (name == "ext_sphere_token_x") { OnExtSphereTokenX(Param(params, 0), Float(Param(params, 1))); return true; }
		if (name == "ext_summon_fade") { OnExtSummonFade(); return true; }
		if (name == "ext_svplaysound_kiss") { OnExtSvplaysoundKiss(Int(Param(params, 0)), Int(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Int(Param(params, 4))); return true; }
		if (name == "ext_teleportfx1") { OnExtTeleportfx1(); return true; }
		if (name == "ext_teleportfx1_delay") { OnExtTeleportfx1Delay(); return true; }
		if (name == "ext_teleportfx2") { OnExtTeleportfx2(); return true; }
		if (name == "ext_unblind") { OnExtUnblind(); return true; }
		if (name == "ext_unsummon") { OnExtUnsummon(); return true; }
		if (name == "ext_wink_in") { OnExtWinkIn(); return true; }
		if (name == "ext_wink_out") { OnExtWinkOut(Vec(Param(params, 0)), Float(Param(params, 1))); return true; }
		if (name == "fifty_armor") { OnFiftyArmor(); return true; }
		if (name == "fire_immune") { OnFireImmune(); return true; }
		if (name == "freeze_solid_end") { OnFreezeSolidEnd(Int(Param(params, 0))); return true; }
		if (name == "freeze_solid_start") { OnFreezeSolidStart(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_drain_death") { OnGameDrainDeath(EntityParam(params, 0)); return true; }
		if (name == "game_scriptflag_update") { OnGameScriptflagUpdate(Param(params, 0), Param(params, 1), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4))); return true; }
		if (name == "give_hp") { OnGiveHp(Param(params, 0)); return true; }
		if (name == "glow_blue") { OnGlowBlue(); return true; }
		if (name == "glow_custom") { OnGlowCustom(Param(params, 0)); return true; }
		if (name == "glow_green") { OnGlowGreen(); return true; }
		if (name == "glow_purple") { OnGlowPurple(); return true; }
		if (name == "glow_red") { OnGlowRed(); return true; }
		if (name == "glow_remove") { OnGlowRemove(); return true; }
		if (name == "glow_yellow") { OnGlowYellow(); return true; }
		if (name == "go_roam") { OnGoRoam(); return true; }
		if (name == "good_race") { OnGoodRace(); return true; }
		if (name == "half_health") { OnHalfHealth(); return true; }
		if (name == "hated_race") { OnHatedRace(); return true; }
		if (name == "hguard_race") { OnHguardRace(); return true; }
		if (name == "human_race") { OnHumanRace(); return true; }
		if (name == "ignore_critical_npc") { OnIgnoreCriticalNpc(); return true; }
		if (name == "immune_ghost") { OnImmuneGhost(); return true; }
		if (name == "lightning_immune") { OnLightningImmune(); return true; }
		if (name == "make_boss") { OnMakeBoss(); return true; }
		if (name == "make_ghost") { OnMakeGhost(); return true; }
		if (name == "make_invulnerable") { OnMakeInvulnerable(); return true; }
		if (name == "make_phys_immune") { OnMakePhysImmune(); return true; }
		if (name == "make_vulnerable") { OnMakeVulnerable(); return true; }
		if (name == "neutral_race") { OnNeutralRace(); return true; }
		if (name == "no_armor") { OnNoArmor(); return true; }
		if (name == "no_roam") { OnNoRoam(); return true; }
		if (name == "normal_immune") { OnNormalImmune(); return true; }
		if (name == "npc_fade_away") { OnNpcFadeAway(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "npcatk_attack_till_spotted") { OnNpcatkAttackTillSpotted(); return true; }
		if (name == "npcatk_reset_ghost") { OnNpcatkResetGhost(); return true; }
		if (name == "npcatk_reset_glow") { OnNpcatkResetGlow(); return true; }
		if (name == "orc_race") { OnOrcRace(); return true; }
		if (name == "poison_immune") { OnPoisonImmune(); return true; }
		if (name == "quad_health") { OnQuadHealth(); return true; }
		if (name == "remove_ghost") { OnRemoveGhost(); return true; }
		if (name == "reset_hit_by_manaball") { OnResetHitByManaball(); return true; }
		if (name == "rogue_race") { OnRogueRace(); return true; }
		if (name == "send_damage") { OnSendDamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Param(params, 6)); return true; }
		if (name == "set_attack_until_spotted") { OnSetAttackUntilSpotted(); return true; }
		if (name == "set_bbox") { OnSetBbox(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_blind_attack") { OnSetBlindAttack(); return true; }
		if (name == "set_cadj") { OnSetCadj(Float(Param(params, 0))); return true; }
		if (name == "set_cbm") { OnSetCbm(Param(params, 0)); return true; }
		if (name == "set_cbm_file") { OnSetCbmFile(Param(params, 0)); return true; }
		if (name == "set_die_nt") { OnSetDieNt(Float(Param(params, 0))); return true; }
		if (name == "set_die_on_spawn_removed") { OnSetDieOnSpawnRemoved(); return true; }
		if (name == "set_dosr") { OnSetDosr(); return true; }
		if (name == "set_dump_xp") { OnSetDumpXp(); return true; }
		if (name == "set_dyn_spawn") { OnSetDynSpawn(); return true; }
		if (name == "set_fade_in") { OnSetFadeIn(Float(Param(params, 0))); return true; }
		if (name == "set_fade_in_loop") { OnSetFadeInLoop(); return true; }
		if (name == "set_fadein_delayed") { OnSetFadeinDelayed(); return true; }
		if (name == "set_mclip") { OnSetMclip(Int(Param(params, 0))); return true; }
		if (name == "set_model") { OnSetModel(Param(params, 0)); return true; }
		if (name == "set_mspeed") { OnSetMspeed(Float(Param(params, 0))); return true; }
		if (name == "set_mspeed2") { OnSetMspeed2(Float(Param(params, 0))); return true; }
		if (name == "set_mspeedt") { OnSetMspeedt(Float(Param(params, 0))); return true; }
		if (name == "set_no_auto_activate") { OnSetNoAutoActivate(); return true; }
		if (name == "set_no_avg") { OnSetNoAvg(); return true; }
		if (name == "set_no_player_damage") { OnSetNoPlayerDamage(); return true; }
		if (name == "set_no_roam") { OnSetNoRoam(); return true; }
		if (name == "set_no_step_adj") { OnSetNoStepAdj(); return true; }
		if (name == "set_non_agro") { OnSetNonAgro(); return true; }
		if (name == "set_notarget") { OnSetNotarget(Param(params, 0)); return true; }
		if (name == "set_npc_turret") { OnSetNpcTurret(); return true; }
		if (name == "set_npc_turret2") { OnSetNpcTurret2(); return true; }
		if (name == "set_poisonous") { OnSetPoisonous(Param(params, 0)); return true; }
		if (name == "set_race") { OnSetRace(Param(params, 0)); return true; }
		if (name == "set_range") { OnSetRange(Float(Param(params, 0))); return true; }
		if (name == "set_range2") { OnSetRange2(); return true; }
		if (name == "set_roam") { OnSetRoam(Param(params, 0)); return true; }
		if (name == "set_say_die") { OnSetSayDie(Param(params, 0)); return true; }
		if (name == "set_say_spawn") { OnSetSaySpawn(Param(params, 0)); return true; }
		if (name == "set_say_spot") { OnSetSaySpot(Param(params, 0)); return true; }
		if (name == "set_scale") { OnSetScale(Float(Param(params, 0))); return true; }
		if (name == "set_scale_nb") { OnSetScaleNb(Param(params, 0)); return true; }
		if (name == "set_scale_nbr") { OnSetScaleNbr(Param(params, 0)); return true; }
		if (name == "set_scale_nr") { OnSetScaleNr(Param(params, 0)); return true; }
		if (name == "set_self_adj") { OnSetSelfAdj(Param(params, 0)); return true; }
		if (name == "set_skin") { OnSetSkin(Param(params, 0)); return true; }
		if (name == "set_solid") { OnSetSolid(Param(params, 0)); return true; }
		if (name == "set_stepsize") { OnSetStepsize(Float(Param(params, 0))); return true; }
		if (name == "set_stun_prot") { OnSetStunProt(Float(Param(params, 0))); return true; }
		if (name == "set_summon") { OnSetSummon(); return true; }
		if (name == "set_summon_circle") { OnSetSummonCircle(); return true; }
		if (name == "set_summon_circle2") { OnSetSummonCircle2(); return true; }
		if (name == "set_summon_circle3") { OnSetSummonCircle3(); return true; }
		if (name == "set_takedmg") { OnSetTakedmg(Param(params, 0)); return true; }
		if (name == "set_takedmg_holy") { OnSetTakedmgHoly(Float(Param(params, 0))); return true; }
		if (name == "set_tele_hunter") { OnSetTeleHunter(Param(params, 0)); return true; }
		if (name == "set_tele_hunter_random") { OnSetTeleHunterRandom(Param(params, 0)); return true; }
		if (name == "set_world_spawn") { OnSetWorldSpawn(); return true; }
		if (name == "set_xp_timeramp_loop") { OnSetXpTimerampLoop(); return true; }
		if (name == "set_xp_timeramp_start") { OnSetXpTimerampStart(); return true; }
		if (name == "set_xp_tr") { OnSetXpTr(Float(Param(params, 0))); return true; }
		if (name == "setfx_beam_in") { OnSetfxBeamIn(); return true; }
		if (name == "setfx_fade_in") { OnSetfxFadeIn(); return true; }
		if (name == "setfx_spawn_sound") { OnSetfxSpawnSound(); return true; }
		if (name == "setfx_sprite_in") { OnSetfxSpriteIn(); return true; }
		if (name == "setfx_sprite_inx") { OnSetfxSpriteInx(); return true; }
		if (name == "setfx_summon_circle") { OnSetfxSummonCircle(); return true; }
		if (name == "setfx_tele_in") { OnSetfxTeleIn(); return true; }
		if (name == "setfx_tele_in2") { OnSetfxTeleIn2(); return true; }
		if (name == "speed_x2") { OnSpeedX2(); return true; }
		if (name == "speed_x2_5") { OnSpeedX25(); return true; }
		if (name == "speed_x3") { OnSpeedX3(); return true; }
		if (name == "speed_x4") { OnSpeedX4(); return true; }
		if (name == "spider_race") { OnSpiderRace(); return true; }
		if (name == "tally_enemy") { OnTallyEnemy(Param(params, 0)); return true; }
		if (name == "tally_race") { OnTallyRace(); return true; }
		if (name == "toggle_invincible") { OnToggleInvincible(); return true; }
		if (name == "trig_damage") { OnTrigDamage(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		if (name == "undead_race") { OnUndeadRace(); return true; }
		if (name == "vermin_race") { OnVerminRace(); return true; }
		if (name == "weakened_armor") { OnWeakenedArmor(); return true; }
		if (name == "wildanimal_race") { OnWildanimalRace(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/externals"]
shared class MonstersExternalsScript : DebugScript, MonstersExternals, DqMonsterExternals
{
	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return MonstersExternals_DispatchEvent(name, params)
			|| DqMonsterExternals_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
