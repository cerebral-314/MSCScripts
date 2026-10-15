#pragma context server

// Converted from nashalrath/dragon_green_mini.script by msc_transpiler.
// closerange: <128
// farrange: 128-256
// move towards @ >256

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "nashalrath/dragon_green_mini"]
class DragonGreenMini : BaseMonsterNewScript
{
	// Constants
	string ANIMSET_ATK_CLOSE = "anim_atk_close1;anim_atk_close2;anim_atk_close2;anim_atk_close1;anim_atk_close2;anim_atk_close3;anim_atk_close1;anim_atk_close2;anim_atk_close4";
	string ANIMSET_ATK_FAR = "anim_atk_far1";
	string ANIM_BREATH_CLOSE = "anim_breath_close";
	string ANIM_BREATH_FAR = "anim_breath_far";
	string ANIM_SPIT = "anim_atk_fireball";
	int MAX_BREATH_RANGE = 384;
	int BONE_RIGHT_CLAW = 35;
	int BONE_LEFT_CLAW = 30;
	int BONE_LEFT_FOOT = 72;
	float DMG_CLAW = 400.0f;
	int AOE_CLAW = 128;
	float FALLOFF_CLAW = 0.01f;
	float DMG_BITE = 600.0f;
	int AOE_BITE = 96;
	float FALLOFF_BITE = 0.01f;
	int DMG_STOMP = 800;
	int AOE_STOMP = 256;
	bool FALLOFF_STOMP = false;
	string SOUND_INTRO = "monsters/dragons/c_dragnold_bat2.wav";
	string SOUND_ALERT1 = "monsters/dragons/c_dragnold_bat1.wav";
	string SOUND_ALERT2 = "monsters/dragons/c_dragnold_bat2.wav";
	string SOUND_ATTACK1 = "monsters/dragons/c_dragnold_atk1.wav";
	string SOUND_ATTACK2 = "monsters/dragons/c_dragnold_atk2.wav";
	string SOUND_ATTACK3 = "monsters/dragons/c_dragnold_atk3.wav";
	string SOUND_PAIN1 = "monsters/dragons/c_dragnold_hit1.wav";
	string SOUND_PAIN2 = "monsters/dragons/c_dragnold_hit2.wav";
	string SOUND_PAIN3 = "monsters/dragons/c_dragonold_hit2.wav";
	string SOUND_IDLE = "monsters/dragons/c_dragnold_slct.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_SWING = "weapons/swinghuge.wav";
	string SOUND_STEP1 = "monsters/dragons/fs_x0snw_drg1.wav";
	string SOUND_STEP2 = "monsters/dragons/fs_x0snw_drg2.wav";
	string SOUND_STEP3 = "monsters/dragons/fs_x0snw_drg3.wav";
	string SOUND_BREATH = "magic/spookie1.wav";
	string SOUND_BREATH_START = "magic/flame_loop_start.wav";
	string SOUND_BREATH_LOOP = "magic/flame_loop.wav";
	string SOUND_FLAP = "monsters/bat/flap_big.wav";
	float FREQ_BREATH = 0.0f;
	float HOVER_DURATION = 15.0f;
	int DMG_BREATH = 75;
	int DOT_BREATH = 100;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ATTACK_MODE = "ATTACK_MODE";
	float BREATH_IDX = 0.0f;
	float ATK_SOUND_IDX = 0.0f;
	float ATTACK_ANIM_IDX = 0.0f;
	float HALF_HEALTH = 0.0f;
	CBaseEntity@ MASTER_ID = null;
	int DID_INTRO = 0;
	float NEXT_BREATH = 0.0f;
	float NEXT_STANCE_SHIFT = 0.0f;
	string SLAM_ORG = "SLAM_ORG";
	string DEBUG_BEAM_START = "DEBUG_BEAM_START";
	Vector3 DEBUG_BEAM_END = Vector3();
	int DEBUG_BEAM_RADIUS = 0;
	float DEBUG_BEAM_ROT = 0.0f;
	float NEXT_GLOAT = 0.0f;
	string BREATH_TARGET = "BREATH_TARGET";
	int BREATH_FWD_OFS = 0;
	int BREATH_FORWARD = 0;
	string CL_WIND_IDX = "CL_WIND_IDX";
	string FORCE_BREATH = "FORCE_BREATH";
	string CL_BREATH_IDX = "CL_BREATH_IDX";
	float BREATH_CURRENT_YAW = 0.0f;
	string BREATH_ON = "BREATH_ON";
	bool BREATH_HOVER = false;
	bool BREATH_LOOP_SOUND = false;
	float NEXT_BREATH_ANG_ADJ = 0.0f;
	string BREATH_DEST_YAW = "BREATH_DEST_YAW";
	int BREATH_ROT_DIR = 0;
	float NEXT_FLAP_SOUND = 0.0f;
	float NEXT_BREATH_DMG = 0.0f;
	float NEXT_BREATH_DEBUG_CIRC = 0.0f;
	Vector3 PROJ_LAND_ORG = Vector3();
	string PROJ_NME_TARGS = "PROJ_NME_TARGS";
	float CUR_SPIT_TARG_IDX = 0.0f;
	string GLOB_TARG = "GLOB_TARG";
	string BLOB_ORG = "BLOB_ORG";
	float DMG_GLOB = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DragonGreenMini()
	{
		ANIM_WALK = "anim_lx_leap";
		ANIM_IDLE = "anim_idle_deep";
		NO_SPAWN_STUCK_CHECK = true;
		NO_STEP_ADJ = true;
		NPC_MUST_SEE_TARGET = "0";
		NPC_BOSS_REGEN_FREQ = 120.0f;
		SOUND_DEATH = "monsters/dragons/c_dragnold_dead.wav";
	}

	// unnamed block (first think)
	void DragonGreenMini_FirstThink()
	{
		ANIM_ATTACK = "anim_atk_far1";
		ANIM_RUN = "anim_lx_leap";
		ANIM_WALK = "anim_lx_leap"; // frame_leap_start frame_leap_land
		ANIM_IDLE = "anim_idle_deep"; // anim_idle_close anim_idle_far
	}

	// unnamed block (first think)
	void DragonGreenMini_FirstThink2()
	{
		NO_SPAWN_STUCK_CHECK = true;
		NO_STEP_ADJ = true;
		NPC_MUST_SEE_TARGET = "0";
		ATTACK_MOVERANGE = 256.0f;
		MOVE_RANGE = "256";
		ATTACK_RANGE = 265.0f;
		ATTACK_HITRANGE = 265.0f;

		NPC_IS_BOSS = true;
		NPC_GIVE_EXP = 20000.0f;

		ATTACK_MODE = "close";
		BREATH_IDX = 0.0f;
		ATK_SOUND_IDX = 0.0f;
	}

	// frame_slct_next_attack
	void DragonGreenMini_OnFrameSlctNextAttack()
	{
		OnDistSelectAttack();
	}

	// game_death
	void DragonGreenMini_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(MASTER_ID, "ext_image_died");
	}

	// frame_slct_next_attack
	void DragonGreenMini_OnFrameSlctNextAttack_2()
	{
		PlaySound(0, 10, SOUND_SWING, 0.8f, RandomInt(80, 125));
	}

	// game_death
	void DragonGreenMini_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ANIM_DEATH = "anim_die_far";
		if (ATTACK_MODE == "close")
			ANIM_DEATH = "anim_die_close";
		if (ATTACK_MODE == "far")
			ANIM_DEATH = "anim_die_far";
		if (RangeTo(ENT_LASTSTRUCK) > 384.0f)
			ANIM_DEATH = "anim_die_vfar";

		if (Truthy(BREATH_ON))
		{
			ClientEvent("update", "all", CL_BREATH_IDX, "end_fx");
			if (BREATH_HOVER)
				ClientEvent("update", "all", CL_WIND_IDX, "end_fx");
			if (BREATH_LOOP_SOUND)
				PlaySound(4, 0, SOUND_BREATH_LOOP);
		}
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("nashalrath/dragon_green_mini_cl");
		PrecacheFile("nashalrath/wind_cl");
	}

	// fake_precache
	void OnFakePrecache()
	{
		ServerPlaySound(0, 0, "monsters/bat/flap_big.wav");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DragonGreenMini_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		DragonGreenMini_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (HealthOf(ENT_ME) > 0.0f)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
		else
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2, SOUND_PAIN3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Aspect of Jaminporlants");
		SetUniqueName("gdragon_aspect");
		SetModel("monsters/dragon_green_mini.mdl");
		SetRace("demon");
		SetWidth(256);
		SetHeight(256);
		SetHealth(40000);
		SetNoPush(true);
		SetDamageTaken("all", 0.25f);
		SetDamageTaken("cold", 0.75f);
		// takedmg fire 0.75
		// takedmg poison 0.75
		// takedmg acid 0.75
		// takedmg lightning 0.75
		SetDamageTaken("holy", 0);
		SetDamageTaken("stun", 0);

		SetHearingSensitivity(11); // (change)
		SetIdleAnim("anim_intro");
		SetMoveAnim("anim_intro");
		ATTACK_ANIM_IDX = 0.0f;

		LegacyCommand("setturnrate", 0.1f); // prob wont do anything, but we'll see (nope, does nodda)
		SetStepSize(0);

		CallEventDelayed(2.0f, "get_final_props");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		if (!(GameTime() > NEXT_BREATH))
			return;
		NEXT_BREATH = GameTime() + FREQ_BREATH;
		if (NPCATK_TARGET == "unset")
			return;
		AS_ATTACKING = GameTime() + 15.0f;
		OnDoBreath();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_GLOAT))
			return;
		NEXT_GLOAT = GameTime() + Random(20, 60);
		CallExternal(MASTER_ID, "ext_gloat");
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		if (GameTime() > NEXT_STANCE_SHIFT)
		{
			NEXT_STANCE_SHIFT = GameTime() + Random(4, 6);
			if (RangeTo(NPCATK_TARGET) < 128.0f)
			{
				if (ATTACK_MODE != "close")
					ANIM_ATTACK = "anim_far2close";
			}
			else if (ATTACK_MODE != "far")
				ANIM_ATTACK = "anim_close2far";
		}
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		AS_ATTACKING = GameTime() + 5.0f;
		PlayAnim("critical", "anim_intro");
		PlaySound(0, 10, SOUND_INTRO);
		CallExternal("players", "ext_play_music_me", "tikal.mp3");

		NEXT_BREATH = GameTime() + FREQ_BREATH; // breath maybe hover or spit ball
	}

	// get_final_props
	void OnGetFinalProps()
	{
		HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;
		@MASTER_ID = FindByName("gdragon_img");
		string masterTarg = ScriptVarOf(MASTER_ID, "CHAT_CURRENT_SPEAKER");
		OnNpcatkSettarget(masterTarg);
	}

	// frame_far2close_done
	void OnFrameFar2closeDone()
	{
		ATTACK_MODE = "close";
		ANIM_IDLE = "anim_idle_close";
		SetIdleAnim(ANIM_IDLE);
		OnDistSelectAttack();
	}

	// frame_close2far_done
	void OnFrameClose2farDone()
	{
		ATTACK_MODE = "far";
		ANIM_IDLE = "anim_idle_far";
		SetIdleAnim(ANIM_IDLE);
		OnDistSelectAttack();
	}

	// frame_slct_next_attack
	void OnFrameSlctNextAttack()
	{
		DragonGreenMini_OnFrameSlctNextAttack();
		DragonGreenMini_OnFrameSlctNextAttack_2();
	}

	// dist_select_attack
	void OnDistSelectAttack()
	{
		if (ATTACK_MODE == "close")
		{
			if (ATTACK_ANIM_IDX >= GetTokenCount(ANIMSET_ATK_CLOSE))
				ATTACK_ANIM_IDX = 0.0f;
			ANIM_ATTACK = GetToken(ANIMSET_ATK_CLOSE, int(ATTACK_ANIM_IDX));
			ATTACK_ANIM_IDX += 1.0f;
		}

		if (ATTACK_MODE == "far")
		{
			if (ATTACK_ANIM_IDX >= GetTokenCount(ANIMSET_ATK_FAR))
				ATTACK_ANIM_IDX = 0.0f;
			ANIM_ATTACK = GetToken(ANIMSET_ATK_FAR, int(ATTACK_ANIM_IDX));
			ATTACK_ANIM_IDX += 1.0f;
		}
	}

	// frame_claw_right
	void OnFrameClawRight()
	{
		OnAttackSound();
		Vector3 pos = BonePositionOf(ENT_ME, BONE_RIGHT_CLAW);
		// local MY_YAW $get(ent_me,angles.yaw)
		// vectoradd L_POS $relpos($vec(0,MY_YAW,0),$vec(0,32,0)) //forward a bit
		pos.z = OriginOf(ENT_ME).z; // and at my ground height
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugCircle(Text(pos), AOE_CLAW);
		DoDamageEx(pos, AOE_CLAW, DMG_CLAW, FALLOFF_CLAW, ENT_ME, ENT_ME, "none", "slash");
	}

	// frame_claw_left
	void OnFrameClawLeft()
	{
		OnAttackSound();
		Vector3 pos = BonePositionOf(ENT_ME, BONE_LEFT_CLAW);
		// local MY_YAW $get(ent_me,angles.yaw)
		// vectoradd L_POS $relpos($vec(0,MY_YAW,0),$vec(0,32,0)) //forward a bit
		pos.z = OriginOf(ENT_ME).z; // and at my ground height
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugCircle(Text(pos), AOE_CLAW);
		DoDamageEx(pos, AOE_CLAW, DMG_CLAW, FALLOFF_CLAW, ENT_ME, ENT_ME, "none", "slash");
	}

	// frame_bite
	void OnFrameBite()
	{
		OnAttackSound();
		Vector3 pos = AttachmentPositionOf(ENT_ME, 0);
		// local MY_YAW $get(ent_me,angles.yaw)
		// vectoradd L_POS $relpos($vec(0,MY_YAW,0),$vec(0,64,0)) //forward a bit
		pos.z = OriginOf(ENT_ME).z; // and at my ground height
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugCircle(Text(pos), AOE_BITE);
		DoDamageEx(pos, AOE_BITE, DMG_BITE, FALLOFF_BITE, ENT_ME, ENT_ME, "none", "pierce");
	}

	// frame_knock_left
	void OnFrameKnockLeft()
	{
		OnAttackSound();
		Vector3 pos = BonePositionOf(ENT_ME, BONE_RIGHT_CLAW);
		// local MY_YAW $get(ent_me,angles.yaw)
		// vectoradd L_POS $relpos($vec(0,MY_YAW,0),$vec(0,64,0)) //forward a bit
		pos.z = OriginOf(ENT_ME).z; // and at my ground height
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugCircle(Text(pos), AOE_CLAW);
		float dmg = DMG_CLAW * 1.5f;
		DoDamageEx(pos, AOE_CLAW, dmg, FALLOFF_CLAW, ENT_ME, ENT_ME, "none", "slash_effect", "dmgevent:knockleft");
	}

	// knockleft_dodamage
	void OnKnockleftDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		AddVelocity(target, RelativeVelocity(Vector3(-800, 100, 120)));
	}

	// frame_stomp
	void OnFrameStomp()
	{
		Vector3 pos = BonePositionOf(ENT_ME, BONE_LEFT_FOOT);
		// local MY_YAW $get(ent_me,angles.yaw)
		// vectoradd L_POS $relpos($vec(0,MY_YAW,0),$vec(0,64,0)) //forward a bit
		pos.z = OriginOf(ENT_ME).z; // and at my ground height
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugCircle(Text(pos), AOE_STOMP);
		ClientEvent("new", "all", "effects/sfx_stun_burst", pos, 256, 1, Vector3(0, 0, 255));
		SLAM_ORG = Text(pos);
		DoDamageEx(pos, AOE_STOMP, DMG_STOMP, FALLOFF_STOMP, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:stomp");
	}

	// stomp_dodamage
	void OnStompDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (!IsOnGround(target))
			return;
		ApplyEffect(target, "effects/debuff_stun", 5.0f, self);
		Vector3 targOrg = OriginOf(target);
		string myOrg = SLAM_ORG;
		float targAng = AnglesTo(Vec(myOrg), targOrg);
		int newYaw = int(targAng);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 500, 110)));
	}

	// debug_circle
	void OnDebugCircle(string center = "", int radius = 0)
	{
		// visual representation of AOE attacks
		DEBUG_BEAM_START = center;
		DEBUG_BEAM_END = Vec(DEBUG_BEAM_START);
		DEBUG_BEAM_END.z += 64.0f;
		DEBUG_BEAM_RADIUS = radius;
		Effect("beam", "point", "lgtning.spr", 20, DEBUG_BEAM_START, DEBUG_BEAM_END, Vector3(255, 0, 255), 200, 0, 1.0f);

		DEBUG_BEAM_ROT = 0.0f;
		for (int i = 0; i < 16; i++)
		{
			loopIteration = i;
			OnDebugCircleLoop();
		}
	}

	// debug_circle_loop
	void OnDebugCircleLoop()
	{
		Vector3 beamStart = Vec(DEBUG_BEAM_START);
		Vector3 beamEnd = Vec(DEBUG_BEAM_START);

		beamStart += RelativePosition(Vector3(0, DEBUG_BEAM_ROT, 0), Vector3(0, DEBUG_BEAM_RADIUS, 32));
		DEBUG_BEAM_ROT += 22.5f;

		beamEnd += RelativePosition(Vector3(0, DEBUG_BEAM_ROT, 0), Vector3(0, DEBUG_BEAM_RADIUS, 32));

		Effect("beam", "point", "lgtning.spr", 20, beamStart, beamEnd, Vector3(255, 0, 255), 200, 0, 1.0f);
	}

	// attack_sound
	void OnAttackSound(float pitch = 0.0f)
	{
		ATK_SOUND_IDX += 1.0f;
		if (ATK_SOUND_IDX == 2.0f)
			PlaySound(0, 10, SOUND_ATTACK1, 0.8f, RandomInt(80, 110));
		if (ATK_SOUND_IDX == 4.0f)
			PlaySound(0, 10, SOUND_ATTACK2, 0.8f, RandomInt(80, 110));
		if (ATK_SOUND_IDX == 6.0f)
		{
			PlaySound(0, 10, SOUND_ATTACK3, 0.8f, RandomInt(80, 110));
			ATK_SOUND_IDX = 0.0f;
		}
	}

	// do_breath
	void OnDoBreath()
	{
		bool exitSub = false;
		DebugPrint("do_breath " + Text(BREATH_IDX) + " " + FORCE_BREATH);

		bool vfarBreath = false;
		if (RangeTo(NPCATK_TARGET) > MAX_BREATH_RANGE)
			vfarBreath = true;
		if (FORCE_BREATH == "vfar")
			vfarBreath = true;

		if (vfarBreath)
		{
			// out of range of our standard breath weapons, use the projectile
			BREATH_TARGET = NPCATK_TARGET;
			OnNpcatkSuspendMovement(ANIM_SPIT);
			OnNpcatkSuspendAi("5.0");
			PlayAnim("critical", ANIM_SPIT);
			exitSub = true;
		}
		if (exitSub)
			return;

		BREATH_IDX += 1.0f;

		if (FORCE_BREATH == "hover")
			BREATH_IDX = 6.0f;

		if (BREATH_IDX < 5.0f)
		{
			// breath weapona anim based on distance
			BREATH_FWD_OFS = 64;

			string attackMode = ATTACK_MODE;
			if (FORCE_BREATH == "close")
				attackMode = FORCE_BREATH;
			if (FORCE_BREATH == "far")
				attackMode = FORCE_BREATH;

			if (attackMode == "close")
			{
				PlayAnim("critical", ANIM_BREATH_CLOSE);
				BREATH_TARGET = NPCATK_TARGET;
				BREATH_FORWARD = 100;
				OnNpcatkSuspendAi("5.0");
				OnNpcatkSuspendMovement(ANIM_BREATH_CLOSE);
			}
			else
			{
				PlayAnim("critical", ANIM_BREATH_FAR);
				BREATH_TARGET = NPCATK_TARGET;
				BREATH_FORWARD = 200;
				OnNpcatkSuspendAi("5.0");
				OnNpcatkSuspendMovement(ANIM_BREATH_FAR);
			}
		}

		if (BREATH_IDX == 6.0f)
		{
			// hover breath
			BREATH_IDX = 0.0f;
			OnNpcatkSuspendAi("25.0");

			BREATH_FWD_OFS = 128;

			if (ATTACK_MODE == "close")
				PlayAnim("critical", "anim_close2hover");
			if (ATTACK_MODE == "far")
				PlayAnim("critical", "anim_far2hover");
			Vector3 windOrg = OriginOf(ENT_ME);
			// vectoradd WIND_ORG z 32
			float hoverDuration = HOVER_DURATION + 1.0f;
			ClientEvent("new", "all", "nashalrath/wind_cl", windOrg, 1.0f, hoverDuration);
			CL_WIND_IDX = LastClientScriptId();
		}

		FORCE_BREATH = "0";
	}

	// frame_launch
	void OnFrameLaunch()
	{
		PlaySound(0, 10, SOUND_FLAP);
	}

	// frame_launch_done
	void OnFrameLaunchDone()
	{
		OnNpcatkSuspendMovement("anim_hover_breath");
		PlayAnim("critical", "anim_hover_breath");
		PlaySound(0, 10, SOUND_BREATH_START);
		ClientEvent("new", "all", "nashalrath/dragon_green_mini_cl", IndexOf(ENT_ME), "breath");
		CL_BREATH_IDX = LastClientScriptId();
		BREATH_CURRENT_YAW = AnglesOf(ENT_ME).y;
		BREATH_ON = "1";
		BREATH_HOVER = true;
		OnBreathLoop();
		CallEventDelayed(HOVER_DURATION, "breath_end");
	}

	// frame_breath_prep
	void OnFrameBreathPrep()
	{
		PlaySound(0, 10, SOUND_BREATH, 0.8f, 150);
		SetMoveDest(BREATH_TARGET, 9999);
	}

	// frame_breath_far_start
	void OnFrameBreathFarStart()
	{
		OnBreathStart();
	}

	// frame_breath_close_start
	void OnFrameBreathCloseStart()
	{
		OnBreathStart();
	}

	// frame_breath_close_end
	void OnFrameBreathCloseEnd()
	{
		OnBreathEnd();
	}

	// frame_breath_far_end
	void OnFrameBreathFarEnd()
	{
		OnBreathEnd();
	}

	// breath_start
	void OnBreathStart()
	{
		PlaySound(1, 10, SOUND_BREATH_START);
		CallEventDelayed(1.5f, "breath_loop_sound");
		ClientEvent("new", "all", "nashalrath/dragon_green_mini_cl", IndexOf(ENT_ME), "breath");
		CL_BREATH_IDX = LastClientScriptId();
		BREATH_CURRENT_YAW = AnglesOf(ENT_ME).y;
		BREATH_ON = "1";
		OnBreathLoop();
	}

	// breath_loop_sound
	void OnBreathLoopSound()
	{
		// some quick breaths may end before the initials ound ends
		if (!Truthy(BREATH_ON))
			return;
		BREATH_LOOP_SOUND = true;
		PlaySound(4, 10, SOUND_BREATH_LOOP);
	}

	// breath_loop
	void OnBreathLoop()
	{
		Vector3 breathFaceOrg = Vec("L_BREATH_FACE_ORG");
		if (!Truthy(BREATH_ON))
			return;
		CallEventDelayed(0.1f, "breath_loop");
		if (!BREATH_HOVER)
		{
			// track target slowly
			if (GameTime() > NEXT_BREATH_ANG_ADJ)
			{
				NEXT_BREATH_ANG_ADJ = GameTime() + 1.0f;
				if (IsAlive(BREATH_TARGET))
				{
					Vector3 myOrg = OriginOf(ENT_ME);
					Vector3 targOrg = OriginOf(BREATH_TARGET);
					float angToTarg = AnglesTo(myOrg, targOrg);
					// local ANG_TO_TARG $neg(ANG_TO_TARG)
					BREATH_DEST_YAW = Text(angToTarg);
				}
			}

			float myYaw = AnglesOf(ENT_ME).y;

			if (BREATH_CURRENT_YAW != Float(BREATH_DEST_YAW))
			{
				if (Float(BREATH_DEST_YAW) < myYaw)
					BREATH_ROT_DIR = -1;
				else
					BREATH_ROT_DIR = 1;
				BREATH_CURRENT_YAW += BREATH_ROT_DIR;
				if (AngleDifference(Float(BREATH_DEST_YAW), BREATH_CURRENT_YAW) < 10.0f)
					BREATH_CURRENT_YAW = Float(BREATH_DEST_YAW);
				breathFaceOrg = OriginOf(ENT_ME);
				breathFaceOrg += RelativePosition(Vector3(0, BREATH_CURRENT_YAW, 0), Vector3(0, 500, 0));
				SetMoveDest(breathFaceOrg, 9999);
			}
		}
		else
		{
			// just circle
			BREATH_CURRENT_YAW += 2.0f;
			if (BREATH_CURRENT_YAW > 359.99f)
				BREATH_CURRENT_YAW = 0.0f;
			breathFaceOrg = OriginOf(ENT_ME);
			breathFaceOrg += RelativePosition(Vector3(0, BREATH_CURRENT_YAW, 0), Vector3(0, 500, 0));
			SetMoveDest(breathFaceOrg, 9999);

			// plus flap sounds
			if (GameTime() > NEXT_FLAP_SOUND)
			{
				NEXT_FLAP_SOUND = GameTime() + 1.0f;
				LegacyCommand("svsound.play3d", SOUND_FLAP, 10, AttachmentPositionOf(ENT_ME, 0));
			}
		}

		if (!(GameTime() > NEXT_BREATH_DMG))
			return;
		NEXT_BREATH_DMG = GameTime() + Random(0.2f, 0.5f);
		Vector3 breathPos = AttachmentPositionOf(ENT_ME, 0);
		breathPos.z = GroundHeight(breathPos);
		breathPos += RelativePosition(Vector3(0, BREATH_CURRENT_YAW, 0), Vector3(0, BREATH_FWD_OFS, 0));
		// breath is a combination of earth and poison
		DoDamageEx(breathPos, 128, DMG_BREATH, 0.1f, ENT_ME, ENT_ME, "none", "blunt", "dmgevent:breath");

		if (Truthy(GetVar("G_DEVELOPER_MODE")) && GameTime() > NEXT_BREATH_DEBUG_CIRC)
		{
			NEXT_BREATH_DEBUG_CIRC = GameTime() + 1.0f;
			OnDebugCircle(Text(breathPos), 128);
		}
	}

	// breath_dodamage
	void OnBreathDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		// this is lagging like fuck, seeing if new haseffect func helps
		// dbg breath_dodamage $get(PARAM2,haseffect,DOT_acid)
		if (!HasEffect(target, "DOT_gpoison"))
			ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_BREATH);
		ApplyEffect(target, "effects/dot_acid", 5.0f, self, DOT_BREATH, "none");
	}

	// breath_end
	void OnBreathEnd()
	{
		BREATH_ON = "0";
		ClientEvent("update", "all", CL_BREATH_IDX, "end_fx");

		PlaySound(4, 0, SOUND_BREATH_LOOP);
		BREATH_LOOP_SOUND = false;

		if (BREATH_HOVER)
		{
			if (ATTACK_MODE == "close")
				PlayAnim("critical", "anim_hover2close");
			else
				PlayAnim("critical", "anim_hover2far");
			PlaySound(0, 10, SOUND_FLAP);
		}

		if (BREATH_HOVER)
			return;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
	}

	// frame_land
	void OnFrameLand()
	{
		BREATH_HOVER = false;
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		ClientEvent("update", "all", CL_WIND_IDX, "end_fx");
	}

	// frame_vfar_breath_start
	void OnFrameVfarBreathStart()
	{
		PlaySound(0, 10, SOUND_BREATH, 0.8f, 150);
		SetMoveDest(BREATH_TARGET, 9999);
	}

	// frame_vfar_breath_fire
	void OnFrameVfarBreathFire()
	{
		PlaySound(0, 10, "SOUND_SPIT", 0.8f, 50);
		Vector3 spitDest = AttachmentPositionOf(ENT_ME, 0);
		float spitYaw = AnglesOf(ENT_ME).y;
		spitDest += RelativePosition(Vector3(0, spitYaw, 0), Vector3(0, 512, 0));
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_gdragon_spit", AttachmentPositionOf(ENT_ME, 0), spitDest, 400, 0, 0, "none"); // special dragon spit, ignores target collides, but blinds as touch and splits into multi guided balls when hit wall
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
	}

	// ext_proj_touch
	void OnExtProjTouch(CBaseEntity@ target = null)
	{
		float dotBreath = DOT_BREATH * 0.5f;
		ApplyEffect(target, "effects/dot_poison_blind", 5.0f, self, dotBreath);
	}

	// ext_proj_landed
	void OnExtProjLanded(Vector3 origin = Vector3())
	{
		PROJ_LAND_ORG = origin;
		PROJ_NME_TARGS = FindInSphere("enemy", 1024);
		if (PROJ_NME_TARGS != "none")
		{
			CUR_SPIT_TARG_IDX = 0.0f;
			OnGuidedSlimeBall();
			CallEventDelayed(0.4f, "guided_slime_ball");
			if (GetTokenCount(PROJ_NME_TARGS) > 1)
				CallEventDelayed(0.6f, "guided_slime_ball");
			if (GetTokenCount(PROJ_NME_TARGS) > 2)
				CallEventDelayed(0.8f, "guided_slime_ball");
		}
	}

	// guided_slime_ball
	void OnGuidedSlimeBall()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(PROJ_NME_TARGS, int(CUR_SPIT_TARG_IDX)));
		CUR_SPIT_TARG_IDX += 1.0f;
		if (CUR_SPIT_TARG_IDX > GetTokenCount(PROJ_NME_TARGS))
			CUR_SPIT_TARG_IDX = 0.0f;
		GLOB_TARG = EntityId(curTarg);
		TossProjectile("proj_glob_guided", PROJ_LAND_ORG, @curTarg, 200, 0, 0, "none");
	}

	// ext_glob_landed
	void OnExtGlobLanded(string origin = "")
	{
		BLOB_ORG = origin;
		DMG_GLOB = DOT_BREATH * 0.5f;
		DoDamageEx(origin, 96, DMG_GLOB, 0.2f, ENT_ME, ENT_ME, "none", "acid_effect", "dmgevent:glob");
	}

	// glob_dodamage
	void OnGlobDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		Vector3 targOrg = OriginOf(target);
		float blobDist = Divide(Distance(Vec(BLOB_ORG), targOrg), 64.0f);
		float blobDistRatio = 1.0f - blobDist;
		float blindDuration = Ratio(blobDistRatio, 2, 6); // blind 2-6 seconds based on how direct the hit was
		// dbg glob_dodamage BLIND_DURATION
		ApplyEffect(target, "effects/dot_poison_blind", blindDuration, self, DMG_GLOB);
	}

	// ext_abreath_now
	// <type> debuggary
	void OnExtAbreathNow(string breathType = "")
	{
		DebugPrint("ext_abreath_now " + breathType);
		NEXT_BREATH = 0.0f;
		if (breathType.isEmpty())
		{
			bool doNadda = true; // really need a !startswith
		}
		else
		{
			FORCE_BREATH = breathType;
		}
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnHoverDuration() {} // HOVER_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/monster_extras.mdl");
		Precache("monsters/bat/flap_big.wav");
		Precache("monsters/dragon_green_mini.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DragonGreenMini_FirstThink();
		DragonGreenMini_FirstThink2();
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
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "breath_dodamage") { OnBreathDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "breath_end") { OnBreathEnd(); return true; }
		if (name == "breath_loop") { OnBreathLoop(); return true; }
		if (name == "breath_loop_sound") { OnBreathLoopSound(); return true; }
		if (name == "breath_start") { OnBreathStart(); return true; }
		if (name == "debug_circle") { OnDebugCircle(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "debug_circle_loop") { OnDebugCircleLoop(); return true; }
		if (name == "dist_select_attack") { OnDistSelectAttack(); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "ext_abreath_now") { OnExtAbreathNow(Param(params, 0)); return true; }
		if (name == "ext_glob_landed") { OnExtGlobLanded(Param(params, 0)); return true; }
		if (name == "ext_proj_landed") { OnExtProjLanded(Vec(Param(params, 0))); return true; }
		if (name == "ext_proj_touch") { OnExtProjTouch(EntityParam(params, 0)); return true; }
		if (name == "fake_precache") { OnFakePrecache(); return true; }
		if (name == "frame_bite") { OnFrameBite(); return true; }
		if (name == "frame_breath_close_end") { OnFrameBreathCloseEnd(); return true; }
		if (name == "frame_breath_close_start") { OnFrameBreathCloseStart(); return true; }
		if (name == "frame_breath_far_end") { OnFrameBreathFarEnd(); return true; }
		if (name == "frame_breath_far_start") { OnFrameBreathFarStart(); return true; }
		if (name == "frame_breath_prep") { OnFrameBreathPrep(); return true; }
		if (name == "frame_claw_left") { OnFrameClawLeft(); return true; }
		if (name == "frame_claw_right") { OnFrameClawRight(); return true; }
		if (name == "frame_close2far_done") { OnFrameClose2farDone(); return true; }
		if (name == "frame_far2close_done") { OnFrameFar2closeDone(); return true; }
		if (name == "frame_knock_left") { OnFrameKnockLeft(); return true; }
		if (name == "frame_land") { OnFrameLand(); return true; }
		if (name == "frame_launch") { OnFrameLaunch(); return true; }
		if (name == "frame_launch_done") { OnFrameLaunchDone(); return true; }
		if (name == "frame_slct_next_attack") { OnFrameSlctNextAttack(); return true; }
		if (name == "frame_stomp") { OnFrameStomp(); return true; }
		if (name == "frame_vfar_breath_fire") { OnFrameVfarBreathFire(); return true; }
		if (name == "frame_vfar_breath_start") { OnFrameVfarBreathStart(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "get_final_props") { OnGetFinalProps(); return true; }
		if (name == "glob_dodamage") { OnGlobDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "guided_slime_ball") { OnGuidedSlimeBall(); return true; }
		if (name == "knockleft_dodamage") { OnKnockleftDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "stomp_dodamage") { OnStompDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
