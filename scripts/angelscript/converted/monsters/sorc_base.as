#pragma context server

// Converted from monsters/sorc_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SorcBase
{
	// Constants
	string ANIM_SORCJUMP = "battleaxe_swing1_L";
	float FREQ_SORCJUMP = 5.0f;
	int SORC_MAX_JUMP_RANGE = 600;
	int ORC_JUMP_RANGE = 512;
	int ORC_JUMP_CUTOFF = 400;
	int ORC_JUMP_POWER = 0;
	float FREQ_TELE = 0.0f;
	bool SORC_TELEPORTS = true;
	float SORC_LRESIST = 0.75f;
	float SORC_PRESIST = 1.10f;
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_HIT = "voices/orc/hit.wav";
	string SOUND_HIT2 = "voices/orc/hit2.wav";
	string SOUND_HIT3 = "voices/orc/hit3.wav";
	string SOUND_PAIN = "monsters/orc/pain.wav";
	string SOUND_WARCRY1 = "monsters/orc/battlecry.wav";
	string SOUND_ATTACK1 = "voices/orc/attack.wav";
	string SOUND_ATTACK2 = "voices/orc/attack2.wav";
	string SOUND_ATTACK3 = "voices/orc/attack3.wav";
	string SOUND_HELP = "voices/orc/help.wav";
	string SOUND_ZOMB_STRUCK1 = "debris/flesh2.wav";
	string SOUND_ZOMB_STRUCK2 = "agrunt/ag_pain3.wav";
	string SOUND_ZOMB_STRUCK3 = "agrunt/ag_pain5.wav";
	string SOUND_ZOMB_ATK1 = "zombie/claw_miss1.wav";
	string SOUND_ZOMB_ATK2 = "zombie/claw_miss2.wav";
	string SOUND_ZOMB_ATK3 = "zombie/claw_strike1.wav";
	string SOUND_ZOMB_ALERT1 = "monsters/zombie1/orc_zo_alert10.wav";
	string SOUND_ZOMB_ALERT2 = "monsters/zombie1/orc_zo_alert20.wav";
	string SOUND_ZOMB_ALERT3 = "monsters/zombie1/orc_zo_alert30.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NO_CLOSE_MOUTH = false;
	bool ORC_JUMPER = false;
	bool SORC_SUPERJUMP = false;
	string ANIM_KNEEL = "ANIM_KNEEL";
	bool SORC_TELE_CYCLE_ON = false;
	int SORC_TELE_SETS = 0;
	string SORC_TELE_SET1 = "SORC_TELE_SET1";
	string SORC_TELE_SET2 = "SORC_TELE_SET2";
	string SORC_TELE_SET3 = "SORC_TELE_SET3";
	bool SORC_NO_TELE = false;
	string PLAYER_LIST = "PLAYER_LIST";
	string SORC_SCAN_BEST_SET = "SORC_SCAN_BEST_SET";
	int SORC_SCAN_IDX = 0;
	string SORC_SCAN_SET = "SORC_SCAN_SET";
	string SORC_FINAL_TELEDEST = "SORC_FINAL_TELEDEST";
	string SORC_REPULSE_TARGETS = "SORC_REPULSE_TARGETS";
	int SORC_CUR_TELE_IDX = 0;
	string SORC_TELE_ORG = "SORC_TELE_ORG";
	int SORC_SCAN_BEST_IDX = 0;
	string SORC_SCAN_BEST_DIST = "SORC_SCAN_BEST_DIST";
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	bool NPC_SILENT_DEATH = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string HUNT_AGRO = "HUNT_AGRO";
	string CAN_HEAR = "CAN_HEAR";
	string CAN_FLEE = "CAN_FLEE";
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string FLINCH_DELAY = "FLINCH_DELAY";
	string LAST_ENEMY = "LAST_ENEMY";
	bool CALLED_HELP = false;
	float NEXT_SORCJUMP = 0.0f;
	float UP_SORCJUMP_STR = 0.0f;
	float FWD_JUMP_STR = 0.0f;
	bool DID_SPOT_SPEECH = false;
	string SPAWN_SPEECH = "SPAWN_SPEECH";
	float SPAWN_SPEECH_DELAY = 0.0f;
	string SPOT_SPEECH = "SPOT_SPEECH";
	bool AM_ESCORT = false;
	CBaseEntity@ CHIEF_ID = null;
	bool KNEEL_MODE = false;

	// unnamed block (first think)
	void SorcBase_FirstThink()
	{
		// sorcs jump a wee higher (save the big ones)
		// - Move this to elf style system
		NO_CLOSE_MOUTH = true;

		ORC_JUMPER = true;
		if (Contains(ToLowerCase(MapName()), "sorc_palace"))
			SORC_SUPERJUMP = true;
		if (SORC_SUPERJUMP)
		{
			ORC_JUMPER = false; // uses local system instead
		}

		ANIM_KNEEL = "kneel"; // vard to let the higher scripts use it
	}

	// game_spawn
	void SorcBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetDamageTaken("lightning", SORC_LRESIST);
		SetDamageTaken("poison", SORC_PRESIST);
		SetDamageTaken("acid", SORC_PRESIST);
	}

	// cycle_up
	void SorcBase_OnCycleUp(string reason = "")
	{
		if (!(Float(GetVar("G_SORC_TELE_POINTS")) > 0.0f))
			return;
		if (!SORC_TELEPORTS)
			return;
		if (SORC_NO_TELE)
			return;
		if (SORC_TELE_CYCLE_ON)
			return;
		SORC_TELE_CYCLE_ON = true;

		// load telepoints from GM
		SORC_TELE_SETS = Int(ScriptVarOf(GetVar("GAME_MASTER"), "SORC_TELE_SETS"));
		SORC_TELE_SET1 = ScriptVarOf(GetVar("GAME_MASTER"), "SORC_TELE_SET1");
		if (SORC_TELE_SETS > 1)
			SORC_TELE_SET2 = ScriptVarOf(GetVar("GAME_MASTER"), "SORC_TELE_SET2");
		if (SORC_TELE_SETS > 2)
			SORC_TELE_SET3 = ScriptVarOf(GetVar("GAME_MASTER"), "SORC_TELE_SET3");

		CallEventDelayed(FREQ_TELE, "sorc_check_tele_points");
	}

	// ext_list_telepoints
	// debug
	void SorcBase_OnExtListTelepoints()
	{
		int count = GetTokenCount(SORC_TELE_SET1);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnListTelePoints1();
		}
		if (SORC_TELE_SETS > 1)
		{
			count = GetTokenCount(SORC_TELE_SET2);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnListTelePoints2();
			}
		}
		if (SORC_TELE_SETS > 2)
		{
			count = GetTokenCount(SORC_TELE_SET3);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnListTelePoints3();
			}
		}
	}

	// list_tele_points1
	void SorcBase_OnListTelePoints1()
	{
		DebugPrint("set1: " + loopIteration + " " + GetToken(SORC_TELE_SET1, loopIteration));
	}

	// list_tele_points2
	void SorcBase_OnListTelePoints2()
	{
		DebugPrint("set2: " + loopIteration + " " + GetToken(SORC_TELE_SET2, loopIteration));
	}

	// list_tele_points3
	void SorcBase_OnListTelePoints3()
	{
		DebugPrint("set3: " + loopIteration + " " + GetToken(SORC_TELE_SET3, loopIteration));
	}

	// no_teleport
	// external addparam
	void SorcBase_OnNoTeleport()
	{
		SORC_NO_TELE = true;
	}

	// sorc_check_tele_points
	void SorcBase_OnSorcCheckTelePoints()
	{
		bool exitSub = false;

		CallEventDelayed(FREQ_TELE, "sorc_check_tele_points");

		// don't teleport if AI suspended
		if (SUSPEND_AI)
			return;

		// don't teleport if you were in swing range within last few seconds, or have otherwise been marked as mid-attack
		float lastAtk = AS_ATTACKING + 10.0f;
		DebugPrint("Last Attack " + Text(GameTime()) + " vs " + Text(lastAtk));
		if (!(GameTime() > lastAtk))
			return;

		// don't teleport if someone teleported recently
		if (!(GameTime() > Float(GetVar("G_SORC_NEXT_TELE"))))
			return;

		// dont teleport if I'm already near striking range of my target
		if (NPCATK_TARGET != "unset" && RangeTo(NPCATK_TARGET) <= ATTACK_HITRANGE)
			exitSub = true;
		if (exitSub)
			return;

		// find teleport point with player closet to it
		PLAYER_LIST = "";
		PLAYER_LIST = GetActivePlayers();

		PLAYER_LIST = TokenShuffle(PLAYER_LIST);

		SORC_SCAN_BEST_SET = "0";

		SORC_SCAN_IDX = 1;
		SORC_SCAN_SET = SORC_TELE_SET1;
		int count = GetTokenCount(SORC_SCAN_SET);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSorcScanTelePoints();
		}
		if (SORC_TELE_SETS > 1)
		{
			SORC_SCAN_IDX = 2;
			SORC_SCAN_SET = SORC_TELE_SET2;
			count = GetTokenCount(SORC_SCAN_SET);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnSorcScanTelePoints();
			}
		}
		if (SORC_TELE_SETS > 2)
		{
			SORC_SCAN_IDX = 3;
			SORC_SCAN_SET = SORC_TELE_SET3;
			count = GetTokenCount(SORC_SCAN_SET);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnSorcScanTelePoints();
			}
		}

		// store destination
		if (Float(SORC_SCAN_BEST_SET) == 1.0f)
			SORC_SCAN_BEST_SET = SORC_TELE_SET1;
		if (Float(SORC_SCAN_BEST_SET) == 2.0f)
			SORC_SCAN_BEST_SET = SORC_TELE_SET2;
		if (Float(SORC_SCAN_BEST_SET) == 3.0f)
			SORC_SCAN_BEST_SET = SORC_TELE_SET3;
		SORC_FINAL_TELEDEST = GetToken(SORC_SCAN_BEST_SET, SORC_SCAN_BEST_IDX);

		// reserver teleporter
		SetGlobal("G_SORC_NEXT_TELE", GameTime());
		LegacyCommand("add", "G_SORC_NEXT_TELE", 5.0f);

		// hold up
		OnNpcatkSuspendAi();

		// fade out (fast)
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		// get off map
		CallEventDelayed(0.20f, "sorc_tele_out");

		// repulse targets near destination
		CallEventDelayed(0.25f, "sorc_repulse");

		// teleport
		CallEventDelayed(0.5f, "sorc_finalize_teleport");
	}

	// sorc_tele_out
	void SorcBase_OnSorcTeleOut()
	{
		SetOrigin(ENT_ME, Vector3(20000, -20000, -20000));
	}

	// sorc_finalize_teleport
	void SorcBase_OnSorcFinalizeTeleport()
	{
		SetOrigin(ENT_ME, Vec(SORC_FINAL_TELEDEST));
		OnNpcatkResumeAi();
		CallEventDelayed(0.25f, "sorc_reset_renderprops");
	}

	// sorc_reset_renderprops
	void SorcBase_OnSorcResetRenderprops()
	{
		SetProp(ENT_ME, "rendermode", 0);
	}

	// sorc_repulse
	void SorcBase_OnSorcRepulse()
	{
		float repulseAoe = Float(Eval("game.monster.moveprox"));
		repulseAoe *= 1.5f;
		ClientEvent("new", "all", "effects/sfx_repulse_burst", SORC_FINAL_TELEDEST, repulseAoe, 1.0f);
		SORC_REPULSE_TARGETS = LegacyFunction("get_tsphere", "any", ATTACK_RANGE, SORC_FINAL_TELEDEST);
		if (SORC_REPULSE_TARGETS == "none")
			return;
		int count = GetTokenCount(SORC_REPULSE_TARGETS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSorcRepulseTargets();
		}
	}

	// sorc_repulse_targets
	void SorcBase_OnSorcRepulseTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SORC_REPULSE_TARGETS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(Vec(SORC_FINAL_TELEDEST), targOrg);
		SetVelocity(curTarg, RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 800, 0)), "override");
	}

	// sorc_scan_tele_points
	void SorcBase_OnSorcScanTelePoints()
	{
		DebugPrint("Checking: " + SORC_CUR_TELE_IDX + " of " + GetTokenCount(SORC_SCAN_SET) + " in set " + SORC_SCAN_IDX + " cur_best_dist " + SORC_SCAN_BEST_DIST);
		SORC_CUR_TELE_IDX = loopIteration;
		SORC_TELE_ORG = GetToken(SORC_SCAN_SET, SORC_CUR_TELE_IDX);
		int count = GetTokenCount(PLAYER_LIST);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSorcScanTeleFindNearestPlayer();
		}
		loopIteration = outerIteration;
	}

	// sorc_scan_tele_find_nearest_player
	void SorcBase_OnSorcScanTeleFindNearestPlayer()
	{
		string curPlayer = GetToken(PLAYER_LIST, loopIteration);

		if (!IsAlive(curPlayer))
			return;

		Vector3 curPlayerOrg = OriginOf(curPlayer);
		float distFromPoint = Distance(Vec(SORC_TELE_ORG), curPlayerOrg);

		if (Float(SORC_SCAN_BEST_SET) == 0.0f)
		{
			// first canidate
			DebugPrint("First: " + SORC_SCAN_BEST_IDX);
			SORC_SCAN_BEST_SET = SORC_SCAN_IDX;
			SORC_SCAN_BEST_IDX = SORC_CUR_TELE_IDX;
			SORC_SCAN_BEST_DIST = Text(distFromPoint);
		}
		else
		{
			// test canidate vs. previous
			DebugPrint("Better: " + SORC_SCAN_BEST_IDX + " ( " + SORC_SCAN_BEST_DIST + " ) vs. " + SORC_CUR_TELE_IDX + " ( " + Text(distFromPoint) + " )");

			if (distFromPoint < Float(SORC_SCAN_BEST_DIST))
			{
				SORC_SCAN_BEST_SET = SORC_SCAN_IDX;
				SORC_SCAN_BEST_IDX = SORC_CUR_TELE_IDX;
				SORC_SCAN_BEST_DIST = Text(distFromPoint);
			}
		}
	}

	// sorc_tele_fx
	// <origin>
	void SorcBase_OnSorcTeleFx(Vector3 origin = Vector3())
	{
		float repulseAoe = Float(Eval("game.monster.moveprox"));
		repulseAoe *= 1.5f;
		Vector3 org = origin;
		org.z = GroundHeight(org);
		ClientEvent("new", "all", "effects/sfx_repulse_burst", org, repulseAoe, 1.0f);
	}

	// set_tele_in
	void SorcBase_OnSetTeleIn()
	{
		OnSetFadeIn(1.0f);
		CallEventDelayed(0.1f, "set_tele_in2");
	}

	// set_tele_in2
	void SorcBase_OnSetTeleIn2()
	{
		OnSorcTeleFx(OriginOf(ENT_ME));
	}

	// unnamed block (first think)
	// ================================================================ Orc base
	// ================================================================
	// ================================================================
	void SorcBase_FirstThink2()
	{
		NPC_SILENT_DEATH = true;
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fallback";
		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_HEAR = "1"; // Turn to face enemies I hear
		CAN_FLEE = "0"; // Don't flee
		CAN_FLINCH = "1"; // Flinch when hit
		FLINCH_CHANCE = "30%"; // Chance of flinch
		ANIM_FLINCH = "flinch";
		FLINCH_DELAY = "4"; // base_npc_attack - Time until next allowed flinch
		LAST_ENEMY = "`NONE`";
	}

	// npc_spawn
	void SorcBase_OnNpcSpawn(string npc = "")
	{
		SetRoam(true);
		SetRace("orc");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		OnOrcSpawn();
	}

	// npc_death
	// On death, don't display weapon
	void SorcBase_OnNpcDeath()
	{
		SetModelBody(2, 0); // Hide weapon
		SetModelBody(4, 0); // Hide Shield
		OnOrcDeath();
	}

	// npcatk_targetvalidate
	// Warcry
	void SorcBase_OnNpcatkTargetvalidate(string target = "")
	{
		string lastseenEnemy = NPCATK_TARGET;
		if (lastseenEnemy == LAST_ENEMY)
			return;

		LAST_ENEMY = lastseenEnemy;
	}

	// npc_struck
	// Hit by someone
	void SorcBase_OnNpcStruck(float damage = 0.0f)
	{
		OnSoundStruck();
		OnOrcStruck();
	}

	// sound_struck
	void SorcBase_OnSoundStruck()
	{
		PlayRandomSound(1, 10, SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");
	}

	// baseorc_yell
	void SorcBase_OnBaseorcYell()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// game_damaged_other
	string SorcBase_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		if (GetVar("ATTACK_PUSH") == "ATTACK_PUSH")
			return result;
		if (GetVar("ATTACK_PUSH") == "none")
			return result;
		AddVelocity(ENT_LASTSTRUCKBYME, Vec(GetVar("ATTACK_PUSH"))); // Push the player a bit
		return result;
	}

	// game_parry
	void SorcBase_OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_aiding_ally
	void SorcBase_OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "")
	{
		if (CALLED_HELP)
			return;
		CALLED_HELP = true;
		CallExternal(EntityOf(caller), "ext_mon_playsound", 0, 10, "voices/orc/help.wav");
	}

	// game_death
	void SorcBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlaySound(0, 5, "voices/orc/die.wav");
	}

	// npcatk_hunt
	// ============================= End Orc_Base
	// =============================
	// ============================= Sorc Superjump (elf style)
	void SorcBase_OnNpcatkHunt()
	{
		if (NPCATK_TARGET == "unset")
			return;

		float gameTime = GameTime();

		if (!(gameTime > NEXT_SORCJUMP))
			return;

		if (!(RangeTo(NPCATK_TARGET) < SORC_MAX_JUMP_RANGE))
			return;

		float myZ = OriginOf(ENT_ME).z;
		float targZ = OriginOf(NPCATK_TARGET).z;
		if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
			targZ -= 38.0f;

		float zDiff = targZ - myZ;

		if (zDiff > ATTACK_RANGE)
		{
			OnSorcHop(zDiff);
			bool exitSub = true;
			NEXT_SORCJUMP = gameTime + FREQ_SORCJUMP;
		}
	}

	// sorc_hop
	// <vertical_difference> - determines jump strength
	void SorcBase_OnSorcHop(float verticalDifference = 0.0f)
	{
		PlaySound(0, 10, "monsters/orc/attack1.wav");
		UP_SORCJUMP_STR = verticalDifference * 5.0f;
		OnNpcatkSuspendAi("1.0");
		FWD_JUMP_STR = RangeTo(NPCATK_TARGET);
		PlayAnim("critical", ANIM_SORCJUMP);
		CallEventDelayed(0.1f, "sorc_jump_boost");
	}

	// sorc_jump_boost
	void SorcBase_OnSorcJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, FWD_JUMP_STR, UP_SORCJUMP_STR)));
	}

	// npc_targetsighted
	// =============== Sorc Palace Chatter
	void SorcBase_OnNpcTargetsighted(string target = "")
	{
		if (DID_SPOT_SPEECH)
			return;
		DID_SPOT_SPEECH = true;
		if (SPOT_SPEECH == "SPOT_SPEECH")
			return;
		SayText(SPOT_SPEECH);
	}

	// npc_post_spawn
	void SorcBase_OnNpcPostSpawn()
	{
		if (SPAWN_SPEECH == "SPAWN_SPEECH")
			return;
		CallEventDelayed(SPAWN_SPEECH_DELAY, "say_spawn_speech");
	}

	// say_spawn_speech
	void SorcBase_OnSaySpawnSpeech()
	{
		SayText(SPAWN_SPEECH);
	}

	// set_sorcpal_jailer1
	void SorcBase_OnSetSorcpalJailer1()
	{
		SetSayTextRange(2048);
		SPAWN_SPEECH = "What's all that racket down there?";
		SPAWN_SPEECH_DELAY = 1.0f;
		SPOT_SPEECH = "Sound the alarm! Introduers!";
	}

	// set_sorcpal_jailer2
	void SorcBase_OnSetSorcpalJailer2()
	{
		SetSayTextRange(2048);
		SPAWN_SPEECH = "I don't know...";
		SPAWN_SPEECH_DELAY = 2.0f;
		SPOT_SPEECH = "Intruders! ...and they let the beef escape!!!";

		if (Float(GetVar("G_ONE_SHOT")) >= 1.0f)
		{
			SPAWN_SPEECH = "SPAWN_SPEECH";
			SPOT_SPEECH = "SPOT_SPEECH";
		}

		SetGlobal("G_ONE_SHOT", 1); // didn't realize this guy had two lives, so we don't want him repeating
	}

	// set_sorcpal_kennel1
	void SorcBase_OnSetSorcpalKennel1()
	{
		SetSayTextRange(2048);
		SPOT_SPEECH = "Go get em Fido!";
	}

	// set_sorcpal_wrecked1
	void SorcBase_OnSetSorcpalWrecked1()
	{
		SetSayTextRange(2048);
		SPAWN_SPEECH = "We really gotta fix this place someday.";
		SPAWN_SPEECH_DELAY = 0.1f;
		SPOT_SPEECH = "Intruders!! Armed humans within the palace walls!";
	}

	// set_sorcpal_wrecked2
	void SorcBase_OnSetSorcpalWrecked2()
	{
		SetSayTextRange(2048);
		SPAWN_SPEECH = "Just shut up and do your patrol.";
		SPAWN_SPEECH_DELAY = 2.0f;
	}

	// set_sorcpal_reward1
	void SorcBase_OnSetSorcpalReward1()
	{
		SetSayTextRange(2048);
		SPOT_SPEECH = "Runegahr will promote us good if we smash these guys!";
	}

	// set_sorcpal_reached1
	void SorcBase_OnSetSorcpalReached1()
	{
		SetSayTextRange(2048);
		SPOT_SPEECH = "The intruders have reached the north east hall!";
	}

	// set_sorcpal_reached2
	void SorcBase_OnSetSorcpalReached2()
	{
		SetSayTextRange(2048);
		if (PlayerCount() > 1)
			SPOT_SPEECH = "How did a couple of humans get this far into the palace!?";
		else
			SPOT_SPEECH = "How did one armed human get THIS far into the palace!?";
	}

	// set_sorcpal_reached3
	void SorcBase_OnSetSorcpalReached3()
	{
		SetSayTextRange(2048);
		if (PlayerCount() > 1)
			SPOT_SPEECH = "They've reached the east tower!";
		else
			SPOT_SPEECH = "He's reached the east tower!";
	}

	// set_sorcpal_killthem1
	void SorcBase_OnSetSorcpalKillthem1()
	{
		SetSayTextRange(2048);
		if (PlayerCount() > 1)
			SPOT_SPEECH = "Kill them! Kill them NOW!";
		else
			SPOT_SPEECH = "Kill him! Kill him NOW!";
	}

	// set_sorc_villa_first_guard
	void SorcBase_OnSetSorcVillaFirstGuard()
	{
		SPOT_SPEECH = "Humans! Humans have entered the town from the palace! SOUND THE ALARM!";
	}

	// set_sorcpal_throne
	// ================================================================ Throne guards
	void SorcBase_OnSetSorcpalThrone()
	{
		// throne room escort
		SetSayTextRange(2048);

		SORC_NO_TELE = true;
		AM_ESCORT = true;

		if (Truthy(GetVar("G_SORC_CHIEF_PRESENT")))
		{
			@CHIEF_ID = FindByName("the_warchief");
			if (!Truthy(ScriptVarOf(CHIEF_ID, "ESCORT_ACTIVE")))
			{
				SetInvincible(true);
				KNEEL_MODE = true;
				SetIdleAnim(ANIM_KNEEL);
				SetMoveAnim(ANIM_KNEEL);
				OnNpcatkSuspendAi();
				SetRoam(false);
			}
		}
	}

	// npc_post_spawn
	void SorcBase_OnNpcPostSpawn_2()
	{
		if (!KNEEL_MODE)
			return;
		SetIdleAnim(ANIM_KNEEL);
		SetMoveAnim(ANIM_KNEEL);
		SetRoam(false);
	}

	// sorcs_confirm_order
	void SorcBase_OnSorcsConfirmOrder()
	{
		SayText("Yes, warchief.");
		Say("[.16]", "[.32]", "[.32]", "[.16]");
	}

	// ext_chief_orders_attack
	void SorcBase_OnExtChiefOrdersAttack()
	{
		if (!KNEEL_MODE)
			return;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkResumeAi();
		SetInvincible(false);
		KNEEL_MODE = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SorcBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SorcBase_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
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
		SorcBase_OnNpcPostSpawn();
		SorcBase_OnNpcPostSpawn_2();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		SorcBase_OnGameSpawn(playerRace, playerGender);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SorcBase_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		SorcBase_OnNpcatkHunt();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SorcBase_OnNpcatkTargetvalidate(target);
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		SorcBase_OnCycleUp(reason);
	}

	// game_parry
	void OnGameParry(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float parryRoll = 0.0f, float accuracyRoll = 0.0f, float parryValue = 0.0f)
	{
		BaseMonsterShared_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue); // monsters/base_monster_shared
		SorcBase_OnGameParry(attacker, damage, damageType, parryRoll, accuracyRoll, parryValue);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SorcBase_OnNpcTargetsighted(target);
	}

	void OnExtListTelepoints() { SorcBase_OnExtListTelepoints(); } // ext_list_telepoints
	void OnListTelePoints1() { SorcBase_OnListTelePoints1(); } // list_tele_points1
	void OnListTelePoints2() { SorcBase_OnListTelePoints2(); } // list_tele_points2
	void OnListTelePoints3() { SorcBase_OnListTelePoints3(); } // list_tele_points3
	void OnNoTeleport() { SorcBase_OnNoTeleport(); } // no_teleport
	void OnSorcCheckTelePoints() { SorcBase_OnSorcCheckTelePoints(); } // sorc_check_tele_points
	void OnSorcTeleOut() { SorcBase_OnSorcTeleOut(); } // sorc_tele_out
	void OnSorcFinalizeTeleport() { SorcBase_OnSorcFinalizeTeleport(); } // sorc_finalize_teleport
	void OnSorcResetRenderprops() { SorcBase_OnSorcResetRenderprops(); } // sorc_reset_renderprops
	void OnSorcRepulse() { SorcBase_OnSorcRepulse(); } // sorc_repulse
	void OnSorcRepulseTargets() { SorcBase_OnSorcRepulseTargets(); } // sorc_repulse_targets
	void OnSorcScanTelePoints() { SorcBase_OnSorcScanTelePoints(); } // sorc_scan_tele_points
	void OnSorcScanTeleFindNearestPlayer() { SorcBase_OnSorcScanTeleFindNearestPlayer(); } // sorc_scan_tele_find_nearest_player
	void OnSorcTeleFx(Vector3 origin = Vector3()) { SorcBase_OnSorcTeleFx(origin); } // sorc_tele_fx
	void OnSetTeleIn() { SorcBase_OnSetTeleIn(); } // set_tele_in
	void OnSetTeleIn2() { SorcBase_OnSetTeleIn2(); } // set_tele_in2
	void OnNpcDeath() { SorcBase_OnNpcDeath(); } // npc_death
	void OnNpcStruck(float damage = 0.0f) { SorcBase_OnNpcStruck(damage); } // npc_struck
	void OnSoundStruck() { SorcBase_OnSoundStruck(); } // sound_struck
	void OnBaseorcYell() { SorcBase_OnBaseorcYell(); } // baseorc_yell
	void OnNpcAidingAlly(CBaseEntity@ allyToAid = null, string caller = "") { SorcBase_OnNpcAidingAlly(allyToAid, caller); } // npc_aiding_ally
	void OnSorcHop(float verticalDifference = 0.0f) { SorcBase_OnSorcHop(verticalDifference); } // sorc_hop
	void OnSorcJumpBoost() { SorcBase_OnSorcJumpBoost(); } // sorc_jump_boost
	void OnSaySpawnSpeech() { SorcBase_OnSaySpawnSpeech(); } // say_spawn_speech
	void OnSetSorcpalJailer1() { SorcBase_OnSetSorcpalJailer1(); } // set_sorcpal_jailer1
	void OnSetSorcpalJailer2() { SorcBase_OnSetSorcpalJailer2(); } // set_sorcpal_jailer2
	void OnSetSorcpalKennel1() { SorcBase_OnSetSorcpalKennel1(); } // set_sorcpal_kennel1
	void OnSetSorcpalWrecked1() { SorcBase_OnSetSorcpalWrecked1(); } // set_sorcpal_wrecked1
	void OnSetSorcpalWrecked2() { SorcBase_OnSetSorcpalWrecked2(); } // set_sorcpal_wrecked2
	void OnSetSorcpalReward1() { SorcBase_OnSetSorcpalReward1(); } // set_sorcpal_reward1
	void OnSetSorcpalReached1() { SorcBase_OnSetSorcpalReached1(); } // set_sorcpal_reached1
	void OnSetSorcpalReached2() { SorcBase_OnSetSorcpalReached2(); } // set_sorcpal_reached2
	void OnSetSorcpalReached3() { SorcBase_OnSetSorcpalReached3(); } // set_sorcpal_reached3
	void OnSetSorcpalKillthem1() { SorcBase_OnSetSorcpalKillthem1(); } // set_sorcpal_killthem1
	void OnSetSorcVillaFirstGuard() { SorcBase_OnSetSorcVillaFirstGuard(); } // set_sorc_villa_first_guard
	void OnSetSorcpalThrone() { SorcBase_OnSetSorcpalThrone(); } // set_sorcpal_throne
	void OnSorcsConfirmOrder() { SorcBase_OnSorcsConfirmOrder(); } // sorcs_confirm_order
	void OnExtChiefOrdersAttack() { SorcBase_OnExtChiefOrdersAttack(); } // ext_chief_orders_attack
	void OnFreqTele() {} // FREQ_TELE
	void OnSpawnSpeechDelay() {} // SPAWN_SPEECH_DELAY
	void OnOrcDeath() {} // orc_death
	void OnOrcSpawn() {} // orc_spawn
	void OnOrcStruck() {} // orc_struck
	void OnSwingAxe() {} // swing_axe

	// This file's events and timers by their .script names
	bool SorcBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "baseorc_yell") { OnBaseorcYell(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "ext_chief_orders_attack") { OnExtChiefOrdersAttack(); return true; }
		if (name == "ext_list_telepoints") { OnExtListTelepoints(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_parry") { OnGameParry(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), Float(Param(params, 4)), Float(Param(params, 5))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "list_tele_points1") { OnListTelePoints1(); return true; }
		if (name == "list_tele_points2") { OnListTelePoints2(); return true; }
		if (name == "list_tele_points3") { OnListTelePoints3(); return true; }
		if (name == "no_teleport") { OnNoTeleport(); return true; }
		if (name == "npc_aiding_ally") { OnNpcAidingAlly(EntityParam(params, 0), Param(params, 1)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "say_spawn_speech") { OnSaySpawnSpeech(); return true; }
		if (name == "set_sorc_villa_first_guard") { OnSetSorcVillaFirstGuard(); return true; }
		if (name == "set_sorcpal_jailer1") { OnSetSorcpalJailer1(); return true; }
		if (name == "set_sorcpal_jailer2") { OnSetSorcpalJailer2(); return true; }
		if (name == "set_sorcpal_kennel1") { OnSetSorcpalKennel1(); return true; }
		if (name == "set_sorcpal_killthem1") { OnSetSorcpalKillthem1(); return true; }
		if (name == "set_sorcpal_reached1") { OnSetSorcpalReached1(); return true; }
		if (name == "set_sorcpal_reached2") { OnSetSorcpalReached2(); return true; }
		if (name == "set_sorcpal_reached3") { OnSetSorcpalReached3(); return true; }
		if (name == "set_sorcpal_reward1") { OnSetSorcpalReward1(); return true; }
		if (name == "set_sorcpal_throne") { OnSetSorcpalThrone(); return true; }
		if (name == "set_sorcpal_wrecked1") { OnSetSorcpalWrecked1(); return true; }
		if (name == "set_sorcpal_wrecked2") { OnSetSorcpalWrecked2(); return true; }
		if (name == "set_tele_in") { OnSetTeleIn(); return true; }
		if (name == "set_tele_in2") { OnSetTeleIn2(); return true; }
		if (name == "sorc_check_tele_points") { OnSorcCheckTelePoints(); return true; }
		if (name == "sorc_finalize_teleport") { OnSorcFinalizeTeleport(); return true; }
		if (name == "sorc_hop") { OnSorcHop(Float(Param(params, 0))); return true; }
		if (name == "sorc_jump_boost") { OnSorcJumpBoost(); return true; }
		if (name == "sorc_repulse") { OnSorcRepulse(); return true; }
		if (name == "sorc_repulse_targets") { OnSorcRepulseTargets(); return true; }
		if (name == "sorc_reset_renderprops") { OnSorcResetRenderprops(); return true; }
		if (name == "sorc_scan_tele_find_nearest_player") { OnSorcScanTeleFindNearestPlayer(); return true; }
		if (name == "sorc_scan_tele_points") { OnSorcScanTelePoints(); return true; }
		if (name == "sorc_tele_fx") { OnSorcTeleFx(Vec(Param(params, 0))); return true; }
		if (name == "sorc_tele_out") { OnSorcTeleOut(); return true; }
		if (name == "sorcs_confirm_order") { OnSorcsConfirmOrder(); return true; }
		if (name == "sound_struck") { OnSoundStruck(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/sorc_base"]
shared class SorcBaseScript : BaseMonsterNewScript, SorcBase
{
	// Variables every script that includes this file declares
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	SorcBaseScript()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SorcBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		SorcBase_FirstThink2();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SorcBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
