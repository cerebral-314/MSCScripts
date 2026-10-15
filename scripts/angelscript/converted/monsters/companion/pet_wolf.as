#pragma context server

// Converted from monsters/companion/pet_wolf.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/companion/base_companion.as"
#include "converted/monsters/summon/base_summon.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class PetWolf
{
	// Constants
	int SUMMON_CIRCLE_INDEX = 13;
	int SUMMON_RUN_DIST = 160;
	string ANIM_WALK_BASE = "walk_wolf";
	string ANIM_RUN_BASE = "run_wolf";
	int BASE_HP = 150;
	bool SUM_NO_TALK = true;
	int COMPANION_MAXHP = 3000;
	string MAX_DMG = "50";
	float XPDMG_MULTI = 0.01f;
	int BASE_DMG = 4;
	string SOUND_TELE = "monsters/wolves/wolf_atk2.wav";
	int HOVER_FAR = 256;
	int HOVER_CLOSE = 128;
	string ANIM_LEAP = "attack2";
	string ANIM_CLAW = "attack2";
	string ANIM_HOWL = "howl";
	string ANIM_ALERT = "threat";
	string ANIM_IDLE_SIT = "sit_idle1";
	string ANIM_IDLE_SIT2 = "sit_idle2";
	string ANIM_IDLE_STAND = "standidle1";
	string ANIM_IDLE_STAND2 = "standidle2";
	string ANIM_IDLE_STAND3 = "guard";
	string ANIM_TOSTAND = "standup";
	string ANIM_BITE = "attack1";
	string ANIM_EAT = "eat";
	string ANIM_FLINCH1 = "hopback";
	string ANIM_FLINCH2 = "pain1";
	string ANIM_FLINCH3 = "pain2";
	bool NPC_BATTLE_ALLY = true;
	string ATTACK_HITCHANCE = "70";
	int LEAP_RANGE = 256;
	float DMG_BITE = 0.0f;
	float DMG_CLAW = 0.0f;
	float FREQ_LOOK = 20.0f;
	float FREQ_IDLE = 0.0f;
	float FREQ_HOWL = 0.0f;
	int CHANCE_CLAW = 50;
	string SOUND_HOWL1 = "monsters/wolves/wolf_howl1.wav";
	string SOUND_HOWL2 = "monsters/wolves/wolf_howl2.wav";
	string SOUND_GROWL = "monsters/wolves/wolf_alert.wav";
	string SOUND_ATK1 = "monsters/wolves/wolf_atk1.wav";
	string SOUND_ATK2 = "monsters/wolves/wolf_atk2.wav";
	string SOUND_ATK3 = "monsters/wolves/wolf_atk3.wav";
	string SOUND_PAIN = "monsters/wolves/wolf_yelp1.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_YELP = "monsters/wolves/wolf_yelp2.wav";
	string SOUND_DEATH = "monsters/wolves/wolf_death.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_COMPANION = true;
	string COMPANION_TYPE = "wolf";
	string ANIM_WALK = "walk_wolf";
	string ANIM_RUN = "run_wolf";
	string ANIM_IDLE = "standidle1";
	bool IS_HIRED = false;
	string ACT_NAME = "ACT_NAME";
	string NPC_REVIVAL_SCRIPT = "NPC_REVIVAL_SCRIPT";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_FLINCH = "ANIM_FLINCH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	bool NPC_NO_PLAYER_DMG = false;
	float NEXT_HOWL = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	float AS_ATTACKING = 0.0f;
	bool SIT_MODE = false;
	float PET_LAST_ATTACK = 0.0f;
	string ATTACK_TYPE = "ATTACK_TYPE";
	bool MELEE_ATTACK = false;
	float SEARCH_DELAY = 0.0f;
	string FLINCH_ANIM = "FLINCH_ANIM";
	float NEXT_REFACE = 0.0f;

	// unnamed block (first think)
	void PetWolf_FirstThink()
	{
		// base_summon / Companion
		IS_COMPANION = true;
		IS_HIRED = true;
		COMPANION_TYPE = "wolf";
		ACT_NAME = "pet wolf";
		NPC_REVIVAL_SCRIPT = "monsters/companion/pet_wolf"; // this is for pet ressurection crystals (future item)

		// _base anims
		ANIM_WALK = "walk_wolf"; // model needs a walk anim
		ANIM_RUN = "run_wolf";
		ANIM_IDLE = "standidle1";
		ANIM_DEATH = "die1";
		ANIM_ATTACK = "attack1"; // using event bite1
		// setvard NPC_ALLY_RESPONSE_RANGE 2048
		ANIM_FLINCH = "hopback";

		// _base stats
		ATTACK_RANGE = 92.0f;
		ATTACK_HITRANGE = 128.0f;
		ATTACK_MOVERANGE = 72.0f;
		NPC_NO_PLAYER_DMG = true;
	}

	// pet_spawn
	void PetWolf_OnPetSpawn()
	{
		SetName("pet wolf");
		SetRace("human");
		SetModel("monsters/giant_rat.mdl");
		SetModelBody(0, 1);
		SetHearingSensitivity(8);
		SetWidth(36);
		SetHeight(48);
		SetRoam(false);

		SetHealth(BASE_HP);

		NEXT_HOWL = 0.0f;

		CatchSpeech("say_sit", "sit");
		CatchSpeech("say_speak", "speak");
	}

	// npc_post_spawn
	// { companion_check_spawn
	// //determine if pet deployed or not
	// local SPAWN_IN 0
	// local OWNER_PET_PREF $get_quest_data(ent_owner,s)
	// dbg check_spawn_in quest: OWNER_PET_PREF
	// if ( OWNER_PET_PREF equals out ) local SPAWN_IN 1
	// if ( OWNER_PET_PREF equals 0 ) local SPAWN_IN 1
	// if ( !SPAWN_IN )
	// {
	// invincible 1
	// dbg check_spawn_in out
	// setvard COMPANION_EGGED 1
	// setvard SUSPEND_AI 1
	// setvard CYCLE_TIME 10.0
	// blind 1
	// setorigin ent_me (10000,20000,10000)
	// }
	// if SPAWN_IN
	// invincible 0
	// setvard CYCLE_TIME 0.1
	// setvard SUSPEND_AI 0
	// setvard COMPANION_EGGED 0
	// blind 0
	// setvard PET_LAST_ATTACK 0
	// callevent basecompanion_catchup
	// effect glow ent_me (255,255,255) 128 5.0 5.0
	// playsound 0 10 magic/spawn_loud.wav
	// }
	void PetWolf_OnNpcPostSpawn()
	{
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// unnamed block (timer)
	void PetWolf_Timer()
	{
		bool exitSub = false;
		CallEventDelayed(FREQ_IDLE, "PetWolf_Timer");

		if (SUSPEND_AI)
			return;

		OnNpcatkSetmovedest(GetVar("G_ALPHA"), Text(ATTACK_MOVERANGE));

		if (NPCATK_TARGET != "unset")
			return;

		if (GameTime() > NEXT_HOWL)
		{
			DebugPrint("idle howl");
			NEXT_HOWL = GameTime() + FREQ_HOWL;
			OnDoHowl();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (SIT_MODE)
		{
			NO_STUCK_CHECKS = "1";
			PlayAnim("critical", ANIM_IDLE_SIT2);
		}
		else
		{
			NO_STUCK_CHECKS = "0";
			int rndIdle = RandomInt(1, 2);
			if (rndIdle == 1)
			{
				OnAtkSound();
				PlayAnim("critical", ANIM_IDLE_STAND2);
				AS_ATTACKING = GameTime();
			}
			if (rndIdle == 2)
			{
				PlaySound(0, 10, SOUND_GROWL);
				PlayAnim("critical", ANIM_IDLE_STAND3);
				AS_ATTACKING = GameTime();
			}
		}
		// (never true here, the rest is skipped) if AM_ALPHA
	}

	// sitmode_off
	void PetWolf_OnSitmodeOff()
	{
		if (SIT_MODE)
			PlayAnim("critical", ANIM_TOSTAND);
		SIT_MODE = false;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
	}

	// sitmode_on
	void PetWolf_OnSitmodeOn()
	{
		SIT_MODE = true;
		SetMoveAnim(ANIM_IDLE_SIT);
		SetIdleAnim(ANIM_IDLE_SIT);
	}

	// bite1
	// anim events
	void PetWolf_OnBite1()
	{
		PET_LAST_ATTACK = GameTime();
		ATTACK_TYPE = "bite";
		float dmgFinal = DMG_BITE;
		float addDmg = COMPANION_XP * XPDMG_MULTI;
		dmgFinal += addDmg;
		if (dmgFinal > Float(MAX_DMG))
			dmgFinal = Float(MAX_DMG);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(dmgFinal), ATTACK_HITCHANCE, "slash");
		OnAtkSound();
		if (RandomInt(1, 100) < CHANCE_CLAW)
			ANIM_ATTACK = ANIM_CLAW;
		MELEE_ATTACK = true;
	}

	// claw1
	void PetWolf_OnClaw1()
	{
		ATTACK_TYPE = "claw";
		float dmgFinal = DMG_CLAW;
		float addDmg = COMPANION_XP * XPDMG_MULTI;
		dmgFinal += addDmg;
		if (dmgFinal > Float(MAX_DMG))
			dmgFinal = Float(MAX_DMG);
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(dmgFinal), ATTACK_HITCHANCE, "slash");
		OnAtkSound();
		MELEE_ATTACK = true;
		ANIM_ATTACK = ANIM_BITE;
	}

	// do_howl
	// ==== end anim events
	void PetWolf_OnDoHowl()
	{
		if (IsAlive(ENT_ME))
			PlayAnim("critical", ANIM_HOWL);
		PlayRandomSound(0, 10, SOUND_HOWL1, SOUND_HOWL2);
	}

	// npcatk_lost_sight
	void PetWolf_OnNpcatkLostSight()
	{
		if (CanSee("enemy"))
			return;
		if (int(SEARCH_DELAY) != 0)
			return;
		SEARCH_DELAY = 1.0f;
		PlaySound(0, 10, SOUND_GROWL);
		CallEventDelayed(FREQ_LOOK, "reset_search_delay");
		OnDoHowl();
	}

	// reset_search_delay
	void PetWolf_OnResetSearchDelay()
	{
		SEARCH_DELAY = 0.0f;
	}

	// npc_flinch
	void PetWolf_OnNpcFlinch(float damage = 0.0f)
	{
		// monster favorw backpedal for flinch, but has two other less likely flinches, including a rollover
		int rndFlinch = RandomInt(1, 5);
		if (rndFlinch == 1)
			FLINCH_ANIM = ANIM_FLINCH2;
		if (rndFlinch == 2)
			FLINCH_ANIM = ANIM_FLINCH3;
		if (rndFlinch > 2)
			FLINCH_ANIM = ANIM_FLINCH1;
		PlaySound(0, 10, SOUND_YELP);
	}

	// cycle_up
	void PetWolf_OnCycleUp(string reason = "")
	{
		if (SIT_MODE)
			OnSitmodeOff();
	}

	// atk_sound
	void PetWolf_OnAtkSound()
	{
		PlayRandomSound(0, 10, SOUND_ATK1, SOUND_ATK2, SOUND_ATK3);
	}

	// game_struck
	void PetWolf_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		float halfHealth = MaxHealthOf(ENT_ME) * 0.5f;
		float quartHealth = MaxHealthOf(ENT_ME) * 0.25f;

		if (HealthOf(ENT_ME) > halfHealth)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1);
		else if (HealthOf(ENT_ME) > quartHealth)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN);
		else
			PlayRandomSound(0, 10, SOUND_PAIN);
	}

	// game_dodamage
	string PetWolf_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (!hit)
			return result;
		if (ATTACK_TYPE == "bite")
			AddVelocity(target, RelativeVelocity(Vector3(-50, 110, 105)));
		if (ATTACK_TYPE == "claw")
			AddVelocity(target, RelativeVelocity(Vector3(-100, 130, 120)));
		return result;
	}

	// game_death
	void PetWolf_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		int rndDeath = RandomInt(1, 2);
		if (rndDeath == 1)
			ANIM_DEATH = "die1";
		if (rndDeath == 2)
			ANIM_DEATH = "die2";
	}

	// my_target_died
	void PetWolf_OnMyTargetDied(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		PlayAnim("once", ANIM_EAT);
	}

	// npc_death
	// ======================== BASE_SUMMON CHANGES / MODS
	void PetWolf_OnNpcDeath()
	{
		InfoMessage(SUMMON_MASTER, "YOUR PET HAS BEEN SLAIN!", COMPANION_NAME + " has been slain!");
		OnSummonDeath();
		OnBcompanionUnRegme();
	}

	// bs_set_guard_mode
	void PetWolf_OnBsSetGuardMode()
	{
		PlaySound(0, 10, SOUND_ATK2);
		OnSitmodeOn();
	}

	// bs_set_hunt_mode
	void PetWolf_OnBsSetHuntMode()
	{
		PlaySound(0, 10, SOUND_ATK2);
		OnSitmodeOff();
	}

	// bs_set_follow_mode
	void PetWolf_OnBsSetFollowMode()
	{
		PlaySound(0, 10, SOUND_ATK2);
		OnSitmodeOff();
	}

	// bs_set_defend_mode
	void PetWolf_OnBsSetDefendMode()
	{
		PlaySound(0, 10, SOUND_ATK2);
		OnSitmodeOff();
	}

	// bs_set_hunt_mode
	void PetWolf_OnBsSetHuntMode_2()
	{
		OnBsSetDefendMode();
	}

	// basesummon_say_report
	void PetWolf_OnBasesummonSayReport(CBasePlayer@ value = null, string source = "")
	{
		bool exitSub = false;
		string atkMin = "ATK_MIN";

		if (source != "from_menu" && EntityId(EntityOf(ENT_LASTSPOKE)) != SUMMON_MASTER)
			exitSub = true;
		if (exitSub)
			return;

		if (atkMin == "ATK_MIN")
			atkMin = "DMG_MAX";

		float meHealth = MyHealth();
		float meMaxHealth = MyMaxHealth();
		string healthString = "(" + Text(meHealth) + "/" + Text(meMaxHealth) + ")";

		float dmgFinal = BASE_DMG;
		float addDmg = COMPANION_XP * XPDMG_MULTI;
		dmgFinal += addDmg;
		if (dmgFinal > Float(MAX_DMG))
			dmgFinal = Float(MAX_DMG);

		string meStrength = Text(dmgFinal);

		SetSayTextRange(1024);
		SayText("[status] HP " + healthString + " DMG/ATK: " + meStrength + " XP: " + int(COMPANION_XP));
	}

	// npcatk_hunt
	// ======================= HUNT FACE
	// - face where my master faces, looking for enemies
	void PetWolf_OnNpcatkHunt()
	{
		OnCliffCheck();

		if (SUSPEND_AI)
			return;

		if (NPCATK_TARGET != "unset")
			return;
		if (!IsAlive(SUMMON_MASTER))
			return;
		float escortDist = RangeTo(SUMMON_MASTER);
		if (escortDist > 128.0f)
		{
			if (SIT_MODE) // unique to wolf
				OnSitmodeOff();
			NEXT_REFACE = GameTime() + 2.0f;
			NO_STUCK_CHECKS = "0";
			OnNpcatkSetmovedest(SUMMON_MASTER, "128");
			if (escortDist > SUMMON_RUN_DIST)
				SetMoveAnim(ANIM_RUN);
			else
				SetMoveAnim(ANIM_WALK);
		}
		else
		{
			NO_STUCK_CHECKS = "1";
			if (GameTime() > NEXT_REFACE)
			{
				SetMoveDest("none");
				// dbg facing escort angs
				float escortFace = AnglesOf(SUMMON_MASTER).y;
				SetAngle("face", Vector3(0, escortFace, 0));
			}
		}
	}

	// game_targeted_by_player
	void PetWolf_OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		DebugPrint("game_targeted_by_player " + NameOf(player));
		CallExternal(player, "ext_show_hbar_monster", self, 1);
	}

	// unnamed block (timer)
	// passive regen
	void PetWolf_Timer2()
	{
		CallEventDelayed(15.0f, "PetWolf_Timer2");
		if (!(GameTime() > COMPANION_NEXT_REGEN))
			return;
		if (NPCATK_TARGET != "unset")
			return;
		if (!(HealthOf(ENT_ME) < MaxHealthOf(ENT_ME)))
			return;
		float tenPercent = MaxHealthOf(ENT_ME) * 0.1f;
		GiveHealth(tenPercent);
		OnSitmodeOn();
	}

	// game_damaged
	string PetWolf_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!SIT_MODE)
			return result;
		SetIdleAnim(ANIM_IDLE);
		return result;
	}

	// summon_cycle
	void PetWolf_OnSummonCycle()
	{
	}

	// cliff_check
	void PetWolf_OnCliffCheck()
	{
		if (IsOnGround(ENT_ME))
			return;
		Vector3 traceStart = OriginOf(ENT_ME);
		traceStart.z += 28.0f;
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, -128.0f));
		if (LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly") != traceEnd)
			return;
		DebugPrint("OMG cliff!");
		OnBasecompanionCatchup(1);
	}

	// npcatk_anti_stuck
	void PetWolf_OnNpcatkAntiStuck()
	{
		if (!(STUCK_COUNT > 1.0f))
			return;
		OnBasecompanionCatchup();
	}

	// say_sit
	void PetWolf_OnSaySit()
	{
		PlayAnim("hold", ANIM_IDLE_SIT);
	}

	// say_speak
	void PetWolf_OnSaySpeak()
	{
		PlaySound(0, 10, "monsters/wolves/wolf_alert.wav");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseCompanion_OnGameSpawn(playerRace, playerGender); // monsters/companion/base_companion
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseCompanion_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, PetWolf_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// bs_set_follow_mode
	void OnBsSetFollowMode()
	{
		BaseCompanion_OnBsSetFollowMode(); // monsters/companion/base_companion
		BaseSummon_OnBsSetFollowMode(); // monsters/summon/base_summon
		PetWolf_OnBsSetFollowMode();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseCompanion_OnNpcatkHunt(); // monsters/companion/base_companion
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseSummon_OnNpcatkHunt(); // monsters/summon/base_summon
		PetWolf_OnNpcatkHunt();
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseCompanion_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/companion/base_companion
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseSummon_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/summon/base_summon
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseCompanion_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseCompanion_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, PetWolf_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseCompanion_OnMyTargetDied(offender); // monsters/companion/base_companion
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		BaseSummon_OnMyTargetDied(offender); // monsters/summon/base_summon
		PetWolf_OnMyTargetDied(offender);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PetWolf_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BaseSummon_OnNpcPostSpawn(); // monsters/summon/base_summon
		PetWolf_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PetWolf_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		PetWolf_OnNpcatkLostSight();
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		PetWolf_OnCycleUp(reason);
	}

	// npcatk_anti_stuck
	void OnNpcatkAntiStuck()
	{
		BaseAntiStuck_OnNpcatkAntiStuck(); // monsters/base_anti_stuck
		PetWolf_OnNpcatkAntiStuck();
	}

	// game_targeted_by_player
	void OnGameTargetedByPlayer(CBasePlayer@ player = null)
	{
		BaseMonsterShared_OnGameTargetedByPlayer(player); // monsters/base_monster_shared
		PetWolf_OnGameTargetedByPlayer(player);
	}

	// bs_set_defend_mode
	void OnBsSetDefendMode()
	{
		BaseSummon_OnBsSetDefendMode(); // monsters/summon/base_summon
		PetWolf_OnBsSetDefendMode();
	}

	// bs_set_guard_mode
	void OnBsSetGuardMode()
	{
		BaseSummon_OnBsSetGuardMode(); // monsters/summon/base_summon
		PetWolf_OnBsSetGuardMode();
	}

	void OnPetSpawn() { PetWolf_OnPetSpawn(); } // pet_spawn
	void OnSitmodeOff() { PetWolf_OnSitmodeOff(); } // sitmode_off
	void OnSitmodeOn() { PetWolf_OnSitmodeOn(); } // sitmode_on
	void OnBite1() { PetWolf_OnBite1(); } // bite1
	void OnClaw1() { PetWolf_OnClaw1(); } // claw1
	void OnDoHowl() { PetWolf_OnDoHowl(); } // do_howl
	void OnResetSearchDelay() { PetWolf_OnResetSearchDelay(); } // reset_search_delay
	void OnNpcFlinch(float damage = 0.0f) { PetWolf_OnNpcFlinch(damage); } // npc_flinch
	void OnAtkSound() { PetWolf_OnAtkSound(); } // atk_sound
	void OnNpcDeath() { PetWolf_OnNpcDeath(); } // npc_death
	void OnBsSetHuntMode() { PetWolf_OnBsSetHuntMode_2(); } // bs_set_hunt_mode
	void OnBasesummonSayReport(CBasePlayer@ value = null, string source = "") { PetWolf_OnBasesummonSayReport(value, source); } // basesummon_say_report
	void OnSummonCycle() { PetWolf_OnSummonCycle(); } // summon_cycle
	void OnCliffCheck() { PetWolf_OnCliffCheck(); } // cliff_check
	void OnSaySit() { PetWolf_OnSaySit(); } // say_sit
	void OnSaySpeak() { PetWolf_OnSaySpeak(); } // say_speak
	void OnFreqLook() {} // FREQ_LOOK

	// This file's events and timers by their .script names
	bool PetWolf_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "atk_sound") { OnAtkSound(); return true; }
		if (name == "basesummon_say_report") { OnBasesummonSayReport(PlayerParam(params, 0), Param(params, 1)); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "bs_set_defend_mode") { OnBsSetDefendMode(); return true; }
		if (name == "bs_set_follow_mode") { OnBsSetFollowMode(); return true; }
		if (name == "bs_set_guard_mode") { OnBsSetGuardMode(); return true; }
		if (name == "bs_set_hunt_mode") { OnBsSetHuntMode(); return true; }
		if (name == "claw1") { OnClaw1(); return true; }
		if (name == "cliff_check") { OnCliffCheck(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_howl") { OnDoHowl(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_targeted_by_player") { OnGameTargetedByPlayer(PlayerParam(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_anti_stuck") { OnNpcatkAntiStuck(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "pet_spawn") { OnPetSpawn(); return true; }
		if (name == "reset_search_delay") { OnResetSearchDelay(); return true; }
		if (name == "say_sit") { OnSaySit(); return true; }
		if (name == "say_speak") { OnSaySpeak(); return true; }
		if (name == "sitmode_off") { OnSitmodeOff(); return true; }
		if (name == "sitmode_on") { OnSitmodeOn(); return true; }
		if (name == "summon_cycle") { OnSummonCycle(); return true; }
		if (name == "PetWolf_Timer") { PetWolf_Timer(); return true; }
		if (name == "PetWolf_Timer2") { PetWolf_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/companion/pet_wolf"]
shared class PetWolfScript : BaseSummonScript, PetWolf, BaseCompanion
{
	// Variables every script that includes this file declares
	float DOT_ICE = 0.0f;
	string FREEZE_TARGS = "FREEZE_TARGS";
	float FREQ_COMBAT_HOWL = 0.0f;
	float NEXT_COMBAT_HOWL = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	PetWolfScript()
	{
		SUMMON_CIRCLE_INDEX = 13;
		SUMMON_RUN_DIST = 160;
		ANIM_WALK_BASE = "walk_wolf";
		ANIM_RUN_BASE = "run_wolf";
		HOVER_FAR = 256;
		HOVER_CLOSE = 128;
		ANIM_WALK = "walk_wolf";
		ANIM_RUN = "run_wolf";
		ANIM_IDLE = "standidle1";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
		SOUND_DEATH = "monsters/wolves/wolf_death.wav";
		I_R_PET = 1; // from monsters/companion/base_companion
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/giant_rat.mdl");
		CallEventDelayed(5.0f, "BaseCompanion_Timer");
		CallEventDelayed(FREQ_IDLE, "PetWolf_Timer");
		CallEventDelayed(15.0f, "PetWolf_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PetWolf_FirstThink();
		BaseCompanion_FirstThink();
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
		return PetWolf_DispatchEvent(name, params)
			|| BaseCompanion_DispatchEvent(name, params)
			|| BaseSummonScript::DispatchEvent(name, params);
	}
}
