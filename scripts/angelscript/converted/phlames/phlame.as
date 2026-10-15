#pragma context server

// Converted from phlames/phlame.script by msc_transpiler.
// = FIX ROCK STORM CONNECTION (impact with clients ommits splodie FX)
// - Summons monsters via map triggers (counts via external calls) [lava scrops, lava boars, demon birds]
// * Transforms into Flame Wing (actually teleports out, and spawns flame wing via trigger) [pauses regen NPC_BOSS_PAUSE_REGEN {or not, seems his regen isn't as fast as expected}]
// * Repulse flame burst /20sec (three in quick sucsession)
// * Spawn fire variant of rock storm
// * Blunt + Fire DOT mele
// * Eye Beam single target
// * Flame staff (fire breath'ish)
// - [axed: made him giant] Flaming Shadow dodge (like Hollow One, but torrent of flames) [might skip, since we made him large]
// - [axed: enough NPC's running around] Spawn multiple flaming boulders (bounce in arc)
// - [axed: bird does enough of this] Trigger meteor shower (via map trigger)
// - [axed: scratch this, would lag] Guided Burst (fire ball shoots out, explodes into multiple shots [1 for each valid target in radius])

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "phlames/phlame"]
class PhlamesPhlame : BaseMonsterNewScript
{
	// Constants
	string ANIM_RUN_DEF = "run2";
	string ANIM_WALK_DEF = "walk2handed";
	string ANIM_IDLE_DEF = "idle";
	string ANIM_TRANSFORM = "crouch_aim_dualmagicmissile";
	string ANIM_SEARCH = "look_idle";
	string ANIM_LOOK = "look_idle";
	string ANIM_SUMMON = "summon";
	string ANIM_METEOR = "cieling_strike";
	string ANIM_BOULDERS = "cieling_strike";
	string ANIM_REPULSE = "fdeploy_strike";
	string ANIM_DODGE = "staff_aim";
	string ANIM_BEAM = "staff_aim";
	string ANIM_FIRE_BREATH = "aim_1";
	string ANIM_GUIDED_BURST = "shoot_1";
	string ANIM_LEAP = "long_jump";
	float FREQ_LOOK = 15.0f;
	float FREQ_GLOAT = 0.0f;
	float FREQ_PAIN = 0.0f;
	float FREQ_SPECIAL = 15.0f;
	float FREQ_CL_REFRESH = 30.0f;
	float FREQ_REPELL = 20.0f;
	int DMG_STAFF = 100;
	float DOT_FIRE = 100.0f;
	int DMG_ROCKS = 400;
	int DMG_EYE_BEAM = 200;
	int DMG_REPULSE = 100;
	string ATTACH_HAND = "1";
	string ATTACH_STAFF = "2";
	string ATTACH_EYE = "3";
	string BIRD_SCRIPT = "phlames/phlame_bird";
	string SOUND_GLOAT1 = "voices/phlame/vs_nx0headm_haha.wav";
	string SOUND_GLOAT2 = "voices/phlame/vs_nx0headm_attk.wav";
	string SOUND_GLOAT3 = "voices/phlame/vs_nx0headm_bat1.wav";
	string SOUND_GLOAT4 = "voices/phlame/vs_nx0headm_bat3.wav";
	string SOUND_SUMMON = "voices/phlame/vs_nx0headm_bat2.wav";
	string SOUND_PAIN1 = "voices/phlame/vs_nx0headm_atk1.wav";
	string SOUND_PAIN_HEALTHY = "voices/phlame/vs_nx0headm_yes.wav";
	string SOUND_PAIN_WEAK = "voices/phlame/vs_nx0headm_no.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_SWING1 = "zombie/claw_miss1.wav";
	string SOUND_SWING2 = "zombie/claw_miss2.wav";
	string SOUND_STRONG_SWING1 = "zombie/claw_strike1.wav";
	string SOUND_STRONG_SWING2 = "zombie/claw_strike2.wav";
	string SOUND_EYE_BEAM_PREP = "weapons/egon_windup2.wav";
	string SOUND_EYE_BEAM_LOOP = "weapons/egon_run3.wav";
	string SOUND_EYE_BEAM_FIRE = "debris/beamstart1.wav";
	string SOUND_EYE_BEAM_OFF = "debris/beamstart1.wav";
	string SOUND_BREATH_START = "monsters/goblin/sps_fogfire.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_UNHOLY = false;
	float SPECIAL_ATTACK = 0.0f;
	float TRANSFORM_COUNT = 0.0f;
	float SUMMON_CYCLE = 0.0f;
	bool ANIM_MODE = false;
	bool CL_FX_ON = false;
	float HEALTH_75 = 0.0f;
	float HEALTH_50 = 0.0f;
	float HEALTH_25 = 0.0f;
	bool IT_HATH_BEGUN = false;
	bool IS_ACTIVE = false;
	float NEXT_GLOAT = 0.0f;
	float NEXT_SPECIAL = 0.0f;
	float FIRST_SUMMON = 0.0f;
	float NEXT_GLOBAL_GLOAT = 0.0f;
	bool IS_WEAK = false;
	float NEXT_PAIN = 0.0f;
	float NEXT_LEAP_AWAY = 0.0f;
	bool STAFF_STRIKE = false;
	bool REPULSE_ATTACK = false;
	float REPULSE_ATTACK_MODE = 0.0f;
	float NEXT_FX_REFRESH = 0.0f;
	bool DID_SUMMON = false;
	float NEXT_REPELL = 0.0f;
	float NEXT_LOOK = 0.0f;
	string CL_EFFECT_ID = "CL_EFFECT_ID";
	string EYE_BEAM_TARGET = "EYE_BEAM_TARGET";
	bool EYE_BEAM_ON = false;
	string EYE_BEAM_ID = "EYE_BEAM_ID";
	float NEXT_EYE_TRACE = 0.0f;
	float BREATH_YAW = 0.0f;
	bool FIRE_BREATH_ON = false;
	float NEXT_SCAN = 0.0f;
	string BREATH_TARGS = "BREATH_TARGS";
	Vector3 MY_ORG = Vector3();
	string MY_ANGLES = "MY_ANGLES";
	bool TRANSFORM_VALID = false;
	bool AM_TRANSFORMED = false;
	float RENDER_AMT = 0.0f;
	Vector3 CREATE_POINT = Vector3();
	bool SUSPEND_CL_FX = false;

	// Variables declared by included files, with the value they start with in this script
	PhlamesPhlame()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		NPC_IS_BOSS = true;
		NPC_BOSS_REGEN_FREQ = 40.0f;
		SOUND_DEATH = "voices/phlame/vs_nx0headm_hit1.wav";
		CAN_HEAR = "0";
	}

	// unnamed block (first think)
	void PhlamesPhlame_FirstThink()
	{
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk2handed";
		ANIM_RUN = "run2";
		ANIM_ATTACK = "staff_strike"; // frame_staff_strike
	}

	// unnamed block (first think)
	void PhlamesPhlame_FirstThink2()
	{
		NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 15000.0f;

		MOVE_RANGE = "512";
		ATTACK_MOVERANGE = 512.0f;
		ATTACK_RANGE = 200.0f;
		ATTACK_HITRANGE = 250.0f;
	}

	// game_dodamage
	string PhlamesPhlame_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (STAFF_STRIKE && hit && !REPULSE_ATTACK)
		{
			// if $get(PARAM2,relationship,ent_me) equals enemy
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		}
		if (REPULSE_ATTACK && hit)
		{
			// if $get(PARAM2,relationship,ent_me) equals enemy
			CBaseEntity@ curTarg = target;
			Vector3 targOrg = OriginOf(curTarg);
			Vector3 myOrg = OriginOf(ENT_ME);
			float newYaw = AnglesTo(myOrg, targOrg);
			ApplyEffect(target, "effects/dot_fire", 5.0f, self, DOT_FIRE);
			AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 3000, 600)));
		}
		STAFF_STRIKE = false;
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/rock_storm");
		PrecacheFile("phlames/phlame_cl");
		PrecacheFile(BIRD_SCRIPT);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ClientEvent("update", "all", CL_EFFECT_ID, "end_fx");
		if (EYE_BEAM_ON)
		{
			Effect("beam", "update", EYE_BEAM_ID, "brightness", 0);
			ServerPlaySound(1, 0, SOUND_EYE_BEAM_LOOP);
		}

		UseTrigger("snd_fboss_death");
		CallExternal("all", "ext_summon_fade");
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
		CL_FX_ON = true;
		PlayAnim("once", ANIM_LOOK);
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		if (reason != "death")
			return;
		if (!IsAlive(ENT_ME))
			return;

		if (!(GameTime() > NEXT_GLOBAL_GLOAT))
			return;
		NEXT_GLOBAL_GLOAT = GameTime() + 15.0f;

		// random global gloat whenever a player dies (anywhere) - maps side
		int rndGloat = RandomInt(1, 4);
		if (rndGloat == 1)
			UseTrigger("snd_gloat1");
		if (rndGloat == 2)
			UseTrigger("snd_gloat2");
		if (rndGloat == 3)
			UseTrigger("snd_gloat3");
		if (rndGloat == 4)
			UseTrigger("snd_gloat4");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		if (EYE_BEAM_ON && RangeTo(ENT_LASTSTRUCK) < RangeTo(EYE_BEAM_TARGET))
			OnEyeBeamSwitchtargets(EntityOf(ENT_LASTSTRUCK));

		if (HealthOf(ENT_ME) < HEALTH_50)
			IS_WEAK = true;
		else
			IS_WEAK = false;

		if (GameTime() > NEXT_PAIN)
		{
			NEXT_PAIN = GameTime() + FREQ_PAIN;
			if (!IS_WEAK)
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN_HEALTHY);
			else
				PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN_WEAK);
		}
		else
		{
			PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2);
		}

		if (IS_WEAK)
		{
			ANIM_RUN = ANIM_RUN_DEF;
			SetMoveAnim(ANIM_RUN);
		}
		else
		{
			ANIM_RUN = ANIM_WALK_DEF;
			SetMoveAnim(ANIM_RUN);
		}

		if (!IS_WEAK)
			return;

		if (RangeTo(ENT_LASTSTRUCK) < 200.0f && GameTime() > NEXT_LEAP_AWAY)
		{
			NEXT_LEAP_AWAY = GameTime() + 0.0f;
			OnDoLeapAway();
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Phlame the Ever Burning");
		SetRace("demon");
		SetHealth(17500);
		SetModel("monsters/phlame.mdl");
		SetWidth(32);
		SetHeight(90);
		SetRace("demon");

		SetHearingSensitivity(5);

		SetUniqueName("phlame_wiz");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.25f);
		SetDamageTaken("lightning", 0.5f);
		SetDamageTaken("poison", 0.25f);
		SetDamageTaken("acid", 0.5f);
		SetDamageTaken("holy", 1.25f);

		IMMUNE_VAMPIRE = true;

		IS_UNHOLY = true;
		SetMoveAnim(ANIM_LOOK);
		SetIdleAnim(ANIM_LOOK);
		PlayAnim("once", ANIM_LOOK);
		SetMoveSpeed(0);

		SetInvincible(true);
		SetRoam(false);

		CatchSpeech("do_anime", "hentai", "anime");

		SetSayTextRange(1024);

		Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 20, 25);

		CallEventDelayed(35.0f, "start_vines");

		OnNpcatkSuspendAi();
		CAN_HEAR = "0";
		NO_SPAWN_STUCK_CHECK = true;
		NPC_NO_AUTO_ACTIVATE = true;
		NO_STUCK_CHECKS = "1";
		SPECIAL_ATTACK = 0.0f;
		TRANSFORM_COUNT = 0.0f;
		SUMMON_CYCLE = 0.0f;

		CallEventDelayed(3.0f, "speak_begin");
		CallEventDelayed(20.0f, "let_us_begin"); // just in case trigger fails
		CallEventDelayed(2.0f, "final_props");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;

		float gameTime = GameTime();

		if (CL_FX_ON && !SUSPEND_CL_FX && gameTime > NEXT_FX_REFRESH)
		{
			NEXT_FX_REFRESH = gameTime + FREQ_CL_REFRESH;
			OnRefreshClientFx();
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (SUSPEND_AI)
			return;

		if (REPULSE_ATTACK_MODE > 0.0f)
			PlayAnim("once", ANIM_ATTACK);

		if (!IS_ACTIVE)
			return;

		if (gameTime > NEXT_GLOAT)
		{
			NEXT_GLOAT = gameTime + FREQ_GLOAT;
			OnDoGloat();
		}

		if (gameTime > NEXT_SPECIAL)
		{
			NEXT_SPECIAL = gameTime + FREQ_SPECIAL;

			SPECIAL_ATTACK += 1.0f;
			if (SPECIAL_ATTACK > 4.0f) // just in case
				SPECIAL_ATTACK = 0.0f;

			// Final order should be: 1-Rocks, 2-Eye, 3-Breath, 4-Repulse (favors summons / transform, if available)
			// transform once at 75% and 25% health
			if (TRANSFORM_COUNT == 0.0f && HealthOf(ENT_ME) < HEALTH_75)
			{
				OnDoTransform();
				exitSub = true;
			}
			if (!exitSub)
			{
				if (TRANSFORM_COUNT == 1.0f && HealthOf(ENT_ME) < HEALTH_25)
				{
					OnDoTransform();
					exitSub = true;
				}
				if (!exitSub)
				{
					if (gameTime > FIRST_SUMMON)
					{
						OnDoSummon();
						if (DID_SUMMON)
						{
							DID_SUMMON = false;
							exitSub = true;
						}
					}
					if (!exitSub)
					{
						if (SPECIAL_ATTACK == 1.0f)
						{
							PlayAnim("critical", ANIM_REPULSE);
							CreateNpc("monsters/summon/rock_storm", RelativePosition(Vector3(0, 0, 32)), self, 4, DMG_ROCKS, 64, 120, 1);
						}

						if (SPECIAL_ATTACK == 2.0f)
							OnDoEyeBeam();

						if (SPECIAL_ATTACK == 3.0f)
						{
							if (RangeTo(NPCATK_TARGET) < 512.0f)
								OnDoFireBreath();
							else
								SPECIAL_ATTACK += 1.0f;
						}

						if (SPECIAL_ATTACK == 4.0f)
						{
							if (RangeTo(NPCATK_TARGET) < 128.0f)
								OnDoRepulse();
							else
								NEXT_SPECIAL = GameTime();
							SPECIAL_ATTACK = 0.0f;
						}
					}
				}
			}
		}

		if (gameTime > NEXT_REPELL && REPULSE_ATTACK_MODE <= 0.0f && !SUSPEND_AI)
		{
			NEXT_REPELL = gameTime + FREQ_REPELL;
			string nearbyNmes = FindInSphere("enemy", 256);
			if (nearbyNmes != "none")
			{
				int nNearbyNmes = GetTokenCount(nearbyNmes);
				int doRepulseChance = RandomInt(1, 3);
				DebugPrint("repulse_check nmes " + nNearbyNmes + " vs " + doRepulseChance);
				if (doRepulseChance < nNearbyNmes)
				{
					REPULSE_ATTACK_MODE += 1.0f;
					PlayAnim("once", ANIM_ATTACK);
				}
			}
		}
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_LOOK))
			return;
		NEXT_LOOK = GameTime() + FREQ_LOOK;
		PlayAnim("once", ANIM_SEARCH);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, PhlamesPhlame_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// do_anime
	void OnDoAnime()
	{
		ANIM_MODE = true;
		SetModelBody(0, 1);
	}

	// final_props
	void OnFinalProps()
	{
		// determines tranform times
		HEALTH_75 = MaxHealthOf(ENT_ME);
		HEALTH_50 = MaxHealthOf(ENT_ME);
		HEALTH_25 = MaxHealthOf(ENT_ME);
		HEALTH_75 *= 0.75f;
		HEALTH_50 *= 0.5f;
		HEALTH_25 *= 0.25f;
	}

	// speak_begin
	void OnSpeakBegin()
	{
		SayText("Then... Let us... Begin...");
	}

	// let_us_begin
	void OnLetUsBegin()
	{
		if (IT_HATH_BEGUN)
			return;
		IT_HATH_BEGUN = true;

		SetInvincible(false);

		ANIM_RUN = ANIM_WALK_DEF;
		ANIM_IDLE = ANIM_IDLE_DEF;

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		OnNpcatkResumeAi();
		NO_STUCK_CHECKS = "0";
		IS_ACTIVE = true;
		NEXT_GLOAT = GameTime() + FREQ_GLOAT;

		NEXT_SPECIAL = GameTime() + 5.0f;

		FIRST_SUMMON = NEXT_SPECIAL + 10.0f;

		SetMoveSpeed(1);
		CAN_HEAR = "1";
	}

	// do_gloat
	void OnDoGloat()
	{
		PlayRandomSound(0, 10, SOUND_GLOAT1, SOUND_GLOAT2, SOUND_GLOAT3, SOUND_GLOAT4);
	}

	// frame_staff_strike
	// ============================================================ Animation Events
	void OnFrameStaffStrike()
	{
		int rndStrength = RandomInt(1, 2);
		if (rndStrength == 1)
			PlayRandomSound(0, 10, SOUND_SWING1, SOUND_SWING2);
		else
			PlayRandomSound(0, 10, SOUND_STRONG_SWING1, SOUND_STRONG_SWING2);

		float dmg = DMG_STAFF;
		if (rndStrength == 2)
			dmg *= 4.0f;

		STAFF_STRIKE = true;

		if (REPULSE_ATTACK_MODE > 0.0f)
		{
			ClientEvent("update", "all", CL_EFFECT_ID, "repulse_attack");
			REPULSE_ATTACK = true;
			DoDamage(Text(RelativePosition(Vector3(0, 0, 32))), 512, DMG_REPULSE, "100%", 0, "reflective", "fire");
			REPULSE_ATTACK_MODE -= 1.0f;
			CallEventDelayed(0.1f, "repulse_reset");
		}
		else
		{
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, dmg, "90%", "blunt");
		}
	}

	// repulse_reset
	void OnRepulseReset()
	{
		REPULSE_ATTACK = false;
	}

	// refresh_client_fx
	void OnRefreshClientFx()
	{
		ClientEvent("new", "all", "phlames/phlame_cl", IndexOf(ENT_ME), EYE_BEAM_ON, FIRE_BREATH_ON);
		CL_EFFECT_ID = LastClientScriptId();
	}

	// do_eye_beam
	void OnDoEyeBeam()
	{
		EYE_BEAM_TARGET = NPCATK_TARGET;
		PlayAnim("break");
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_BEAM);

		PlaySound(0, 10, SOUND_EYE_BEAM_PREP);

		EYE_BEAM_ON = true;
		ClientEvent("update", "all", CL_EFFECT_ID, "eye_beam_on");
		CallEventDelayed(1.0f, "do_eye_beam2");
	}

	// do_eye_beam2
	void OnDoEyeBeam2()
	{
		Effect("beam", "ents", "laserbeam.spr", 30, ENT_ME, ATTACH_EYE, EYE_BEAM_TARGET, 1, Vector3(255, 0, 255), 255, 10, "EYE_BEAM_DURATION");
		EYE_BEAM_ID = ENT_LASTCREATED;
		PlaySound(0, 10, SOUND_EYE_BEAM_FIRE);
		ServerPlaySound(1, 10, SOUND_EYE_BEAM_LOOP);
		OnEyeBeamLoop();
		CallEventDelayed(10.0f, "end_eye_beam");
		OnEyeBeamDuration();
	}

	// eye_beam_loop
	void OnEyeBeamLoop()
	{
		bool getNewTarget = false;
		Vector3 traceEnd = Vec("TRACE_END");
		string traceLine = "TRACE_LINE";
		bool exitSub = false;
		bool gotNewTarget = false;

		if (!EYE_BEAM_ON)
			return;
		CallEventDelayed(0.1f, "eye_beam_loop");

		SetMoveDest(EYE_BEAM_TARGET, 9999);

		if (!(GameTime() > NEXT_EYE_TRACE))
			return;
		NEXT_EYE_TRACE = GameTime() + 0.5f;

		if (!IsAlive(EYE_BEAM_TARGET))
		{
			getNewTarget = true;
		}
		else
		{
			Vector3 traceStart = AttachmentPositionOf(ENT_ME, ATTACH_EYE);
			traceEnd = OriginOf(EYE_BEAM_TARGET);
			traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		}

		// dbg eye_beam_loop TRACE_END vs TRACE_LINE
		if (traceLine != Text(traceEnd))
		{
			getNewTarget = true;
		}
		else
		{
			// dbg eye_beam_loop dodamage $get(EYE_BEAM_TARGET,name) [ GET_NEW_TARGET ]
			if (!getNewTarget)
			{
				DoDamage(EYE_BEAM_TARGET, "direct", DMG_EYE_BEAM, "100%", ENT_ME, "dark");
				AddVelocity(EYE_BEAM_TARGET, RelativeVelocity(Vector3(0, 250, 110)));
				ClientEvent("update", "all", CL_EFFECT_ID, "eye_beam_contact", OriginOf(EYE_BEAM_TARGET));
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		// switch target if someone closer, or target dead/cant see him
		bool canSeeNme = CanSee("enemy");
		if (gotNewTarget)
			return;

		OnEndEyeBeam();
	}

	// eye_beam_switchtargets
	void OnEyeBeamSwitchtargets(CBaseEntity@ target = null)
	{
		EYE_BEAM_TARGET = EntityId(target);
		Effect("beam", "update", EYE_BEAM_ID, "end_target", EYE_BEAM_TARGET);
	}

	// end_eye_beam
	void OnEndEyeBeam()
	{
		if (!EYE_BEAM_ON)
			return;
		EYE_BEAM_ON = false;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
		Effect("beam", "update", EYE_BEAM_ID, "brightness", 0);
		ClientEvent("update", "all", CL_EFFECT_ID, "eye_beam_off");
		ServerPlaySound(1, 0, SOUND_EYE_BEAM_LOOP);
		PlaySound(0, 10, SOUND_EYE_BEAM_OFF);
		CallEventDelayed(0.1f, "end_eye_beam2");
	}

	// end_eye_beam2
	void OnEndEyeBeam2()
	{
		// this second removal is here, as it looks as though the beam update and client update are conflicting sometimes
		ClientEvent("update", "all", CL_EFFECT_ID, "eye_beam_off");
	}

	// do_summon
	void OnDoSummon()
	{
		int maxSummonCount = 0;
		bool clearedForSummon = false;
		DebugPrint("do_summon " + GetVar("G_NPC_SUMMON_COUNT") + " " + maxSummonCount);

		// skip this until we test his basic abilities
		// ideas here: cieling summons (birds) use different anim than floor summons (boars/scorp/vines)
		// - do not summon if G_NPC_SUMMON_COUNT > 2 (4 if players >= 6)
		// face center marker script before summoning birds or scorpion
		// make sure distance from center marker is at least 200 units when summoning giant scorp (dont want it to land on head)
		// - if no room to summon scorp, choose amongst the other summons
		// vines fade/retract in time, so do not add set_summon to them (dont count against the summon limit)
		// use NPC_HOME_LOC for centerpoint
		maxSummonCount = 2;
		if (PlayerCount() > 5)
			maxSummonCount = 4;

		if (Float(GetVar("G_NPC_SUMMON_COUNT")) <= maxSummonCount)
			clearedForSummon = true;

		if (!clearedForSummon)
			return;
		DID_SUMMON = true;

		SUMMON_CYCLE += 1.0f;

		if (SUMMON_CYCLE == 3.0f)
		{
			// scorp (out of order here as we want to do it last, but may not be able to do it without room)
			Vector3 scorpPos = Vec(NPC_HOME_LOC);
			scorpPos.z = GroundHeight(Vec(NPC_HOME_LOC));
			Vector3 myPos = OriginOf(ENT_ME);
			if (Distance(myPos, scorpPos) > 128.0f)
			{
				PlayAnim("critical", ANIM_SUMMON);
				PlaySound(0, 10, SOUND_SUMMON);
				UseTrigger("spawn_fboss_scorps");
			}
			else
			{
				// too close to scorp's spawn point, pick random of the other two
				// (scorp actually spawns well off the ground, but it is not aesthetically pleasing to have the huge thing land on its master's head)
				SUMMON_CYCLE = RandomInt(1, 2);
			}
		}

		if (SUMMON_CYCLE == 1.0f)
		{
			// birds
			SetMoveDest(NPC_HOME_LOC, 9999);
			OnNpcatkSuspendAi();
			OnNpcatkSuspendMovement(ANIM_METEOR, "1.0");
			PlayAnim("hold", ANIM_METEOR);
			CallEventDelayed(1.5f, "break_summon_anim");
			PlaySound(0, 10, SOUND_SUMMON);
			UseTrigger("spawn_fboss_birds");
		}

		if (SUMMON_CYCLE == 2.0f)
		{
			// boars
			PlayAnim("critical", ANIM_SUMMON);
			PlaySound(0, 10, SOUND_SUMMON);
			UseTrigger("spawn_fboss_boars");
		}

		if (!(SUMMON_CYCLE > 3.0f))
			return;
		SUMMON_CYCLE = 0.0f;
	}

	// break_summon_anim
	void OnBreakSummonAnim()
	{
		OnNpcatkResumeAi();
		PlayAnim("break");
	}

	// do_fire_breath
	void OnDoFireBreath()
	{
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_FIRE_BREATH);
		ClientEvent("update", "all", CL_EFFECT_ID, "fire_breath_on");
		PlaySound(1, 10, SOUND_BREATH_START);
		PlayAnim("break");
		PlayAnim("hold", ANIM_FIRE_BREATH);
		SetMoveDest(NPCATK_TARGET, 9999);
		BREATH_YAW = AnglesOf(ENT_ME).y;
		FIRE_BREATH_ON = true;
		CallEventDelayed(10.0f, "end_fire_breath");
		OnFireBreathLoop();
	}

	// fire_breath_loop
	void OnFireBreathLoop()
	{
		if (!FIRE_BREATH_ON)
			return;
		CallEventDelayed(0.1f, "fire_breath_loop");
		BREATH_YAW += 1.0f;
		if (BREATH_YAW > 359.99f)
			BREATH_YAW -= 359.99f;
		Vector3 facePos = OriginOf(ENT_ME);
		facePos += RelativePosition(Vector3(0, BREATH_YAW, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 1.0f;

		BREATH_TARGS = FindInSphere("enemy", 256);
		if (BREATH_TARGS == "none")
			return;
		MY_ORG = OriginOf(ENT_ME);
		MY_ANGLES = Text(AnglesOf(ENT_ME));
		int count = GetTokenCount(BREATH_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBreathAffectTargets();
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(BREATH_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarg);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 10))
			return;
		ApplyEffect(curTarg, "effects/dot_fire", 5.0f, self, DOT_FIRE);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, 2000, 110)));
	}

	// end_fire_breath
	void OnEndFireBreath()
	{
		FIRE_BREATH_ON = false;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
		ClientEvent("update", "all", CL_EFFECT_ID, "fire_breath_off");
		PlayAnim("critical", ANIM_ATTACK);
	}

	// do_repulse
	void OnDoRepulse()
	{
		// callevent npcatk_suspend_movement ANIM_ATTACK 3.0
		PlayAnim("critical", ANIM_ATTACK);
		REPULSE_ATTACK_MODE = 3.0f;
	}

	// transform_check
	void OnTransformCheck()
	{
		// local TRACE_START $get(ent_me,origin)
		// local TRACE_END TRACE_START
		// vectoradd TRACE_END z 248
		// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
		// if ( G_DEVELOPER_MODE ) effect beam point lgtning.spr 20 TRACE_START TRACE_END (255,0,255) 200 0 1
		// eff that, just try to get to center of room
		Vector3 centerPoint = Vec(NPC_HOME_LOC);
		centerPoint.z = GroundHeight(Vec(NPC_HOME_LOC));
		Vector3 myPos = OriginOf(ENT_ME);

		if (Distance(myPos, centerPoint) <= 200.0f)
		{
			TRANSFORM_VALID = true;
		}
		else
		{
			// don't have room to transform, run to center, and pray I can do it in 2 secs
			// (rinse and repeat if I can't)
			DebugPrint("transform_check no_room");
			OnNpcatkSuspendAi("2.0");
			SetMoveAnim(ANIM_RUN_DEF);
			Vector3 moveDest = Vec(NPC_HOME_LOC);
			moveDest.z = GroundHeight(Vec(NPC_HOME_LOC));
			SetMoveDest(NPC_HOME_LOC, 10);
			PlayAnim("critical", ANIM_LEAP);
			CallEventDelayed(0.1f, "leap_forward_boost");
			NEXT_SPECIAL = GameTime() + 2.0f;
		}
	}

	// leap_forward_boost
	void OnLeapForwardBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 300, 110)));
	}

	// do_transform
	void OnDoTransform(string center = "")
	{
		TRANSFORM_VALID = false;
		OnTransformCheck();
		if (!TRANSFORM_VALID)
			return;
		TRANSFORM_COUNT += 1.0f;

		AM_TRANSFORMED = true;

		OnNpcatkSuspendAi();
		SetInvincible(true);
		OnNpcatkSuspendMovement(ANIM_TRANSFORM);
		ClientEvent("update", "all", CL_EFFECT_ID, "do_transform", OriginOf(ENT_ME));

		SetProp(ENT_ME, "rendermode", 2);
		RENDER_AMT = 255.0f;
		OnDoFadeOut();

		ServerPlaySound(1, 10, "ambience/alienfazzle1.wav");
		PlaySound(2, 10, "ambience/blackhole.wav");

		CREATE_POINT = OriginOf(ENT_ME);
		CREATE_POINT.z += 200.0f;
		SetGravity(0);
		ClearEffects();
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 100)));
		SetNoPush(true);
		CallEventDelayed(2.0f, "transform_finalize");

		CallExternal("all", "ext_summon_fade"); // suicide/fade my summons here, so I don't get stuck in my own birds
	}

	// do_fade_out
	void OnDoFadeOut()
	{
		RENDER_AMT -= 5.0f;
		if (!(RENDER_AMT > 0.0f))
			return;
		CallEventDelayed(0.1f, "do_fade_out");
		SetProp(ENT_ME, "renderamt", RENDER_AMT);
	}

	// transform_finalize
	void OnTransformFinalize(string birdPosition = "")
	{
		UseTrigger("snd_phlame_bird_spawn");
		ServerPlaySound(1, 0, "ambience/alienfazzle1.wav");
		ClientEvent("update", "all", CL_EFFECT_ID, "transform_finalize", CREATE_POINT);
		CallEventDelayed(0.5f, "remove_cl_fx");
		SUSPEND_CL_FX = true;
		SetOrigin(ENT_ME, Vector3(20000, -20000, -20000));
		CreateNpc(BIRD_SCRIPT, CREATE_POINT, self, "phlame");
	}

	// remove_cl_fx
	void OnRemoveClFx()
	{
		ClientEvent("update", "all", CL_EFFECT_ID, "end_fx");
	}

	// transform_return
	// <death_origin>
	void OnTransformReturn(Vector3 deathOrigin = Vector3(), string secondPoint = "")
	{
		AM_TRANSFORMED = false;
		SetNoPush(false);
		SetInvincible(false);
		SetGravity(1);
		Vector3 returnPoint = Vec(NPC_HOME_LOC);
		returnPoint.z = GroundHeight(returnPoint);
		returnPoint.z += 200.0f;

		// *sigh* none of this works because traclines can go from off the map to the inside just fine
		// vectorset RETURN_POINT z $get_ground_height(RETURN_POINT)
		// vectoradd RETURN_POINT 200
		// //make sure I actually have room to return here, if not, return to home loc
		// local TRACE_START RETURN_POINT
		// local TRACE_END RETURN_POINT
		// vectoradd TRACE_END z 30
		// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
		// if ( TRACE_LINE isnot TRACE_END ) local RETURN_POINT NPC_HOME_LOC
		// local TRACE_START RETURN_POINT
		// subtract TRACE_END x 180
		// local TRACE_END RETURN_POINT
		// vectoradd TRACE_END x 180
		// local TRACE_LINE $get_traceline(TRACE_START,TRACE_END,worldonly)
		// if ( TRACE_LINE isnot TRACE_END ) local RETURN_POINT NPC_HOME_LOC
		SetOrigin(ENT_ME, returnPoint);

		SUSPEND_CL_FX = false;
		NEXT_FX_REFRESH = 0.0f;
		NEXT_FX_REFRESH += FREQ_CL_REFRESH;
		OnRefreshClientFx();

		ClientEvent("update", "all", CL_EFFECT_ID, "transform_return", deathOrigin, returnPoint);

		OnSetFadeIn();
		CallEventDelayed(1.0f, "npcatk_resume_ai"); // stunned for a bit
		OnNpcatkResumeMovement();
		// resume movement failing here for some reason
		ANIM_WALK = ANIM_WALK_DEF;
		ANIM_IDLE = ANIM_IDLE_DEF;
		ANIM_RUN = ANIM_WALK_DEF;
		SetMoveAnim(ANIM_WALK_DEF);
		SetIdleAnim(ANIM_IDLE_DEF);
		PlayAnim("critical", ANIM_TRANSFORM);
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 1, 1);
		NEXT_SPECIAL = GameTime() + 3.0f; // delay next special a bit
		FIRST_SUMMON = NEXT_SPECIAL + 10.0f; // make sure next special isn't summon
	}

	// start_vines
	void OnStartVines()
	{
		// no anim or anything for this, just happens
		UseTrigger("spawn_fboss_vines");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnEyeBeamDuration() {} // EYE_BEAM_DURATION
	void OnDoLeapAway() {} // do_leap_away

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("c-tele1.spr");
		Precache("firemagic_8bit.spr");
		Precache("laserbeam.spr");
		Precache("red_aura_8bit.spr");
		Precache("3dmflaora.spr");
		Precache("calflame.spr");
		Precache("monsters/phlame.mdl");
		Precache("weapons/egon_run3.wav");
		Precache("ambience/alienfazzle1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PhlamesPhlame_FirstThink();
		PhlamesPhlame_FirstThink2();
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
		if (name == "break_summon_anim") { OnBreakSummonAnim(); return true; }
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "do_anime") { OnDoAnime(); return true; }
		if (name == "do_eye_beam") { OnDoEyeBeam(); return true; }
		if (name == "do_eye_beam2") { OnDoEyeBeam2(); return true; }
		if (name == "do_fade_out") { OnDoFadeOut(); return true; }
		if (name == "do_fire_breath") { OnDoFireBreath(); return true; }
		if (name == "do_gloat") { OnDoGloat(); return true; }
		if (name == "do_repulse") { OnDoRepulse(); return true; }
		if (name == "do_summon") { OnDoSummon(); return true; }
		if (name == "do_transform") { OnDoTransform(Param(params, 0)); return true; }
		if (name == "end_eye_beam") { OnEndEyeBeam(); return true; }
		if (name == "end_eye_beam2") { OnEndEyeBeam2(); return true; }
		if (name == "end_fire_breath") { OnEndFireBreath(); return true; }
		if (name == "eye_beam_loop") { OnEyeBeamLoop(); return true; }
		if (name == "eye_beam_switchtargets") { OnEyeBeamSwitchtargets(EntityParam(params, 0)); return true; }
		if (name == "final_props") { OnFinalProps(); return true; }
		if (name == "fire_breath_loop") { OnFireBreathLoop(); return true; }
		if (name == "frame_staff_strike") { OnFrameStaffStrike(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "leap_forward_boost") { OnLeapForwardBoost(); return true; }
		if (name == "let_us_begin") { OnLetUsBegin(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "refresh_client_fx") { OnRefreshClientFx(); return true; }
		if (name == "remove_cl_fx") { OnRemoveClFx(); return true; }
		if (name == "repulse_reset") { OnRepulseReset(); return true; }
		if (name == "speak_begin") { OnSpeakBegin(); return true; }
		if (name == "start_vines") { OnStartVines(); return true; }
		if (name == "transform_check") { OnTransformCheck(); return true; }
		if (name == "transform_finalize") { OnTransformFinalize(Param(params, 0)); return true; }
		if (name == "transform_return") { OnTransformReturn(Vec(Param(params, 0)), Param(params, 1)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
