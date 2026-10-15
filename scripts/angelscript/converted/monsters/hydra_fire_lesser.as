#pragma context server

// Converted from monsters/hydra_fire_lesser.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"
#include "converted/monsters/base_struck.as"

[script "monsters/hydra_fire_lesser"]
class HydraFireLesser : BaseMonsterNewScript, BasePropelled, BaseStruck
{
	// Constants
	string ANIM_ALERT = "anim_alert";
	string ANIM_BITE1 = "anim_bite1";
	string ANIM_BITE2 = "anim_bite2";
	string ANIM_BITE3 = "anim_bite3";
	string ANIM_BREATH_RAPID = "anim_breath1";
	string ANIM_BREATH_CONE = "anim_breath2";
	string ANIM_BREATH_GUIDED = "anim_breath3";
	string ANIM_HEADWHIP = "anim_whip_head";
	string ANIM_TAILWHIP = "anim_whip_tail";
	string ANIM_FLINCH1 = "anim_flinch1";
	string ANIM_FLINCH2 = "anim_flinch2";
	bool ATTACH_HEAD_LEFT = false;
	bool ATTACH_HEAD_MID = true;
	int ATTACH_HEAD_RIGHT = 2;
	int ATTACH_TAIL = 3;
	bool ATTACH_HEAD_LEFT1 = true;
	int ATTACH_HEAD_MID1 = 2;
	int ATTACH_HEAD_RIGHT1 = 3;
	int ATTACH_TAIL1 = 4;
	int HYDRA_ATTACK_RANGE = 246;
	int HYDRA_ATTACK_HITRANGE = 280;
	bool NPC_USE_PAIN = true;
	bool NPC_USE_FLINCH = true;
	float NPC_FLINCH_THRESH = 0.01f;
	bool NPC_USE_IDLE = true;
	string SOUND_IDLE1 = "monsters/hydra/c_bulette_slct.wav";
	string SOUND_IDLE2 = "monsters/hydra/c_bulette_dead1.wav";
	string SOUND_IDLE3 = "monsters/hydra/c_bulette_dead2.wav";
	string SOUND_PAIN1 = "monsters/hydra/c_bulette_hit1.wav";
	string SOUND_PAIN2 = "monsters/hydra/c_bulette_hit2.wav";
	string SOUND_PAIN3 = "monsters/hydra/c_bulette_hit3.wav";
	string HYDRA_TYPE = "fire";
	int HYDRA_SIZE = 1;
	int HYDRA_RUN_SPEED = 150;
	int HYDRA_WALK_SPEED = 50;
	string AURA_CL_SCRIPT = "monsters/hydra_fire_lesser_cl";
	string AURA_ELEMENT = "fire_effect";
	float FREQ_CL_REFRESH = 30.0f;
	Vector3 COL_BEAM1 = Vector3();
	Vector3 COL_BEAM2 = Vector3();
	float DOT_DMG = 50.0f;
	float DOT_DUR = 5.0f;
	string DOT_SCRIPT = "effects/dot_fire";
	string DOT_EFFECTNAME = "DOT_fire";
	int DOTALT_DMG = 100;
	float DOTALT_DUR = 5.0f;
	string DOTALT_SCRIPT = "effects/dot_fire";
	string DOTALT_EFFECTNAME = "DOT_fire";
	int DMG_BITE1 = 150;
	int DMG_BITE2 = 175;
	int DMG_BITE3 = 200;
	int DMG_TAIL = 600;
	int AOE_TAIL = 164;
	float FREQ_BREATH = 20.0f;
	float FREQ_TAIL_CHECK = 10.0f;
	int DMG_PROJ_RAPID = 200;
	string PROJ_RAPID_SCRIPT = "proj_fire_bomb";
	int DMG_BREATH_CONE = 100;
	int BREATH_CONE_RANGE = 256;
	int BREATH_CONE_AOE = 256;
	int DMG_PROJ_GUIDED = 1000;
	string PROJ_GUIDED_SCRIPT = "proj_elemental_guided";
	string PROJ_GUIDED_ELEMENT = "fire";
	string SOUND_COMBAT1 = "monsters/hydra/c_bulette_bat1.wav";
	string SOUND_COMBAT2 = "monsters/hydra/c_bulette_bat2.wav";
	string SOUND_COMBAT3 = "monsters/hydra/c_bulette_dead3.wav";
	string SOUND_ATTACK_HEAD1 = "monsters/hydra/c_bulette_atk1.wav";
	string SOUND_ATTACK_HEAD2 = "monsters/hydra/c_bulette_atk2.wav";
	string SOUND_ATTACK_HEAD3 = "monsters/hydra/c_bulette_atk3.wav";
	string SOUND_TAIL = "weapons/swing_huge.wav";
	string SOUND_ALERT = "monsters/hydra/rawr.wav";
	string SOUND_BREATH1_START = "monsters/hydra/c_bulette_bat1.wav";
	string SOUND_BREATH1_STRIKE = "magic/fireball_large.wav";
	string SOUND_BREATH2_START = "monsters/hydra/c_bulette_bat2.wav";
	string SOUND_BREATH2_STRIKE = "magic/flame_loop_start.wav";
	string SOUND_BREATH2_LOOP = "magic/flame_loop.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "anim_flinch1";
	string ANIM_ATTACK = "anim_bite1";
	float GAME_PUSH_RATIO = 0.0f;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	int PROJ_FIRE_BOMB_AOE = 0;
	float PROJ_FIRE_BOMB_SCALE = 0.0f;
	string PROJ_ELEMENT_TYPE = "PROJ_ELEMENT_TYPE";
	int PROJ_ELEMENT_SPEED = 0;
	float PROJ_ELEMENT_MAX_DURATION = 0.0f;
	string BREATH_TYPE = "BREATH_TYPE";
	int DID_INTRO = 0;
	float MOVE_SUSPEND_UNTIL = 0.0f;
	bool HYDRA_DID_INIT = false;
	int AURA_SIZE = 0;
	float NEXT_TAIL_CHECK = 0.0f;
	float NEXT_BREATH = 0.0f;
	float NEXT_CL_REFRESH = 0.0f;
	string MY_CL_IDX = "MY_CL_IDX";
	float RESET_CYCLES = 0.0f;
	bool HAD_TARGET = false;
	float NEXT_AURA_SCAN = 0.0f;
	bool DID_TAIL = false;
	string BREATH_TARGS = "BREATH_TARGS";
	bool AM_BREATHING = false;
	bool NPC_FLINCH_DISABLE = false;
	bool SHOT_GUIDED = false;
	string CUR_BREATH_ANIM = "CUR_BREATH_ANIM";
	CBaseEntity@ CUR_BREATH_TARG = null;
	Vector3 CUR_BREATH_ORG = Vector3();
	string PROJ_ELEMENT_TARGET = "PROJ_ELEMENT_TARGET";
	float RAPID_BREATH_COUNT = 0.0f;
	Vector3 FIRE_BOMB_POS = Vector3();
	float BREATH_CONE_YAW = 0.0f;
	bool BREATH_CONE_ACTIVE = false;
	bool BREATH_CONE_ON = false;
	float NEXT_CONE_SCAN = 0.0f;
	string CONE_TARGS = "CONE_TARGS";
	string TAIL_TARGS = "TAIL_TARGS";

	// Variables declared by included files, with the value they start with in this script
	HydraFireLesser()
	{
		ANIM_IDLE = "anim_idle";
		ANIM_WALK = "anim_walk";
		ANIM_RUN = "anim_walk";
		ANIM_DEATH = "anim_death";
		SOUND_DEATH = "monsters/hydra/death_final.wav";
	}

	// unnamed block (first think)
	void HydraFireLesser_FirstThink()
	{
		ANIM_IDLE = "anim_idle";
		ANIM_WALK = "anim_walk";
		ANIM_RUN = "anim_walk";
		ANIM_FLINCH = "anim_flinch1";
		ANIM_DEATH = "anim_death";
		ANIM_ATTACK = "anim_bite1";

		// base code
		GAME_PUSH_RATIO = 0.1f;
		ATTACK_RANGE = HYDRA_ATTACK_RANGE;
		ATTACK_HITRANGE = HYDRA_ATTACK_HITRANGE;
		NPC_GIVE_EXP = 750.0f; // ovrd with const NPC_BASE_EXP

		// base propelled
		NPC_HACKED_MOVE_SPEED = 50.0f;

		// for projectiles
		PROJ_FIRE_BOMB_AOE = 128;
		PROJ_FIRE_BOMB_SCALE = 0.25f;
		PROJ_ELEMENT_TYPE = PROJ_GUIDED_ELEMENT;
		PROJ_ELEMENT_SPEED = 50;
		PROJ_ELEMENT_MAX_DURATION = 30.0f;
	}

	// game_damaged_other
	// PARAM1=target_hit PARAM2=dmg PARAM3=dmg_type
	string HydraFireLesser_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		bool incDmg = false;
		string result = "";

		// this is cheap, but he needs help; if enemy is immune to fire and hydra does a non-fire attack, increase dmg
		if (HYDRA_TYPE == "fire")
		{
			if (!Contains(damageType, "fire") && DamageTakenOf(target, "fire") == 0.0f)
				incDmg = true;
			if (IsNoPush(target))
				incDmg = true;

			if (incDmg)
			{
				float finDmg = damage * 3.0f;
			}
		}
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		ServerPlaySound(0, 0, "magic/sps_fogfire.wav");
		ServerPlaySound(0, 0, "magic/cold_breath.wav");
		ServerPlaySound(0, 0, "magic/bolt_loop.wav");
		ServerPlaySound(0, 0, "magic/flame_loop.wav");
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ClientEvent("update", "all", MY_CL_IDX, "end_fx");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, HydraFireLesser_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		OnHydraSpawn();
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		float gameTime = GameTime();

		if (NPCATK_TARGET != "unset")
		{
			RESET_CYCLES = gameTime + 20.0f;
			HAD_TARGET = true;
			NPC_HACKED_MOVE_SPEED = HYDRA_RUN_SPEED;
		}
		else
		{
			NPC_HACKED_MOVE_SPEED = HYDRA_WALK_SPEED;
			if (HYDRA_DID_INIT && HAD_TARGET && gameTime > RESET_CYCLES)
			{
				// not had a target for awhile, reset cycles
				OnHydraInitCombat();
				DID_INTRO = 0;
				HAD_TARGET = false;
			}
		}

		if (gameTime < MOVE_SUSPEND_UNTIL)
			NPC_HACKED_MOVE_SPEED = 0.0f;

		if (gameTime > NEXT_CL_REFRESH && HYDRA_DID_INIT)
			OnRefreshClEffects();

		if (gameTime > NEXT_AURA_SCAN)
		{
			NEXT_AURA_SCAN = gameTime + 1.0f;
			OnAuraChecktargets();
		}

		if (AM_BREATHING)
		{
			PlayAnim("once", CUR_BREATH_ANIM); // case something interrupts my critical breath anim
		}

		if (NPCATK_TARGET == "unset")
			return;
		if (SUSPEND_AI)
			return;
		if (AM_BREATHING)
			return;

		if (gameTime > NEXT_TAIL_CHECK)
		{
			NEXT_TAIL_CHECK = gameTime + FREQ_TAIL_CHECK; // reset again when tail whip done
			OnDoTailCheck();
			if (DID_TAIL)
			{
				DID_TAIL = false;
				return;
			}
		}

		if (gameTime > NEXT_BREATH)
		{
			NEXT_BREATH = gameTime + FREQ_BREATH; // reset again when breath done
			OnDoBreath();
		}
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO == 0)
		{
			DID_INTRO = 1;
			PlayAnim("critical", ANIM_ALERT);
			PlaySound(0, 10, SOUND_ALERT);
			OnHydraInitCombat();
			MOVE_SUSPEND_UNTIL = GameTime() + 3.0f;
			AS_ATTACKING = GameTime() + 5.0f;
		}
	}

	// hydra_spawn
	void OnHydraSpawn()
	{
		SetName("Lesser Fire Hydra");
		SetModel("monsters/hydra_small.mdl");
		SetHealth(5000);
		SetWidth(96);
		SetHeight(96);
		SetRace("demon");

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetRoam(true);
		SetHearingSensitivity(4);

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("stun", 0);

		BREATH_TYPE = "0";

		CallEventDelayed(2.0f, "hydra_finalize");
	}

	// hydra_finalize
	void OnHydraFinalize()
	{
		float gold = MaxHealthOf(ENT_ME);
		float goldMulti = 0.5f;
		if (Truthy(Eval("game.central")))
		{
			float players = ActivePlayerCount();
			if (players > 1.0f)
			{
				players *= 0.5f;
				goldMulti += players;
			}
		}
		gold *= goldMulti;
		SetGold(int(gold));
	}

	// hydra_init_combat
	void OnHydraInitCombat()
	{
		HYDRA_DID_INIT = true;
		if (HYDRA_SIZE == 1)
			AURA_SIZE = 128;

		OnRefreshClEffects();
		NEXT_TAIL_CHECK = GameTime() + FREQ_TAIL_CHECK;
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// refresh_cl_effects
	void OnRefreshClEffects()
	{
		bool refresh = false;
		if (MY_CL_IDX == "MY_CL_IDX")
			refresh = true;
		if (GameTime() > NEXT_CL_REFRESH)
			refresh = true;

		if (!refresh)
			return;
		NEXT_CL_REFRESH = GameTime() + FREQ_CL_REFRESH;
		DebugPrint("refresh_cl_effects");
		ClientEvent("new", "all", AURA_CL_SCRIPT, IndexOf(ENT_ME), 30.0f, AURA_SIZE, "fire", BREATH_CONE_ON, BREATH_CONE_RANGE, BREATH_CONE_AOE);
		MY_CL_IDX = LastClientScriptId();
	}

	// do_breath
	void OnDoBreath()
	{
		BREATH_TYPE = Text(Float(BREATH_TYPE) + 1.0f);

		Vector3 scanPoint = RelativePosition(Vector3(0, 512, 32));
		BREATH_TARGS = LegacyFunction("get_tsphere", "enemy", 512, scanPoint);
		if (BREATH_TARGS == "none")
		{
			// no valid targets in front, try again in a bit
			BREATH_TYPE = Text(Float(BREATH_TYPE) - 1.0f);
			NEXT_BREATH = GameTime() + 3.0f;
		}

		if (Float(BREATH_TYPE) == 1.0f)
			OnBreathRapidStart();

		if (Float(BREATH_TYPE) == 2.0f)
			OnBreathConeStart();

		if (Float(BREATH_TYPE) == 3.0f)
		{
			OnBreathGuidedStart();
			BREATH_TYPE = "0";
		}
	}

	// breath_end
	void OnBreathEnd()
	{
		AM_BREATHING = false;
		OnNpcatkResumeMovement();
		OnNpcatkResumeAi();
		NPC_FLINCH_DISABLE = false;
		MOVE_SUSPEND_UNTIL = 0.0f;
		NEXT_BREATH = GameTime() + FREQ_BREATH;
	}

	// breath_guided_start
	// =================== BREATH GUIDED [3]
	void OnBreathGuidedStart()
	{
		AM_BREATHING = true;
		SHOT_GUIDED = false;
		CUR_BREATH_ANIM = ANIM_BREATH_GUIDED;
		OnNpcatkSuspendMovement(ANIM_BREATH_GUIDED);
		OnNpcatkSuspendAi();
		NPC_FLINCH_DISABLE = true;
		MOVE_SUSPEND_UNTIL = GameTime() + 30.0f;
	}

	// frame_breath3_begin
	void OnFrameBreath3Begin()
	{
		PlaySound(0, 10, "SOUND_BREATH3_START");
		BREATH_TARGS = TokenShuffle(BREATH_TARGS);
		@CUR_BREATH_TARG = FindEntity(GetToken(BREATH_TARGS, 0));
		CUR_BREATH_ORG = OriginOf(CUR_BREATH_TARG);
		SetMoveDest(@CUR_BREATH_TARG, 9999);
	}

	// frame_breath3_strike
	void OnFrameBreath3Strike()
	{
		SHOT_GUIDED = true;
		PlaySound(0, 10, SOUND_BREATH1_STRIKE);
		PROJ_ELEMENT_TARGET = EntityId(CUR_BREATH_TARG);
		TossProjectile(EntityId(CUR_BREATH_TARG), PROJ_ELEMENT_SPEED, DMG_PROJ_GUIDED, 1, PROJ_GUIDED_SCRIPT, AttachmentPositionOf(ENT_ME, ATTACH_HEAD_RIGHT), "notoffset");

		if (HYDRA_TYPE == "fire")
			CallExternal(ENT_LASTPROJECTILE, "ext_set_target", @CUR_BREATH_TARG);
	}

	// frame_breath3_done
	void OnFrameBreath3Done()
	{
		if (!SHOT_GUIDED)
		{
			PlayAnim("once", ANIM_BREATH_GUIDED); // something went wrong, try again
		}
		else
		{
			SHOT_GUIDED = false;
			OnBreathEnd();
			PlayAnim("critical", ANIM_IDLE);
		}
	}

	// breath_rapid_start
	// =================== BREATH RAPID [1]
	void OnBreathRapidStart()
	{
		AM_BREATHING = true;
		RAPID_BREATH_COUNT = 0.0f;
		CUR_BREATH_ANIM = ANIM_BREATH_RAPID;
		OnNpcatkSuspendMovement(ANIM_BREATH_RAPID);
		OnNpcatkSuspendAi();
		NPC_FLINCH_DISABLE = true;
		MOVE_SUSPEND_UNTIL = GameTime() + 30.0f;
	}

	// frame_breath1_begin
	void OnFrameBreath1Begin()
	{
		PlaySound(0, 10, SOUND_BREATH1_START);
		BREATH_TARGS = TokenShuffle(BREATH_TARGS);
		@CUR_BREATH_TARG = FindEntity(GetToken(BREATH_TARGS, 0));
		CUR_BREATH_ORG = OriginOf(CUR_BREATH_TARG);
		SetMoveDest(@CUR_BREATH_TARG, 9999);
	}

	// frame_breath1_strike
	void OnFrameBreath1Strike()
	{
		PlaySound(0, 10, SOUND_BREATH1_STRIKE);
		TossProjectile(Text(CUR_BREATH_ORG), 200, DMG_PROJ_RAPID, 1, PROJ_RAPID_SCRIPT, AttachmentPositionOf(ENT_ME, ATTACH_HEAD_LEFT), "notoffset");
		if (HYDRA_TYPE == "fire")
		{
			CallExternal(ENT_LASTPROJECTILE, "ext_lighten", 0);
			CallExternal(ENT_LASTPROJECTILE, "ext_scale", 0.5f);
		}
	}

	// frame_breath1_done
	void OnFrameBreath1Done()
	{
		RAPID_BREATH_COUNT += 1.0f;
		if (RAPID_BREATH_COUNT > 3.0f)
			OnBreathRapidEnd();
		else
			PlayAnim("once", ANIM_BREATH_RAPID);
	}

	// breath_rapid_end
	void OnBreathRapidEnd()
	{
		OnBreathEnd();
	}

	// ext_fire_bomb
	// <land point> - called by proj_fire_bomb
	void OnExtFireBomb(Vector3 landPosition = Vector3())
	{
		FIRE_BOMB_POS = landPosition;
		DoDamageEx(FIRE_BOMB_POS, 128, DMG_PROJ_RAPID, 0.1f, ENT_ME, ENT_ME, "none", "blunt_effect", "dmgevent:rapid");
	}

	// rapid_dodamage
	void OnRapidDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		OnApplyDot(target);

		Vector3 targOrg = OriginOf(target);
		Vector3 myOrg = FIRE_BOMB_POS;
		float newYaw = AnglesTo(myOrg, targOrg);
		AddVelocity(target, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 1000, 200)));
	}

	// frame_breath2_begin
	// =================== BREATH CONE [2]
	void OnFrameBreath2Begin()
	{
		PlaySound(0, 10, SOUND_BREATH2_START);
	}

	// breath_cone_start
	void OnBreathConeStart()
	{
		AM_BREATHING = true;
		CUR_BREATH_ANIM = ANIM_BREATH_CONE;
		OnNpcatkSuspendMovement(ANIM_BREATH_CONE);
		OnNpcatkSuspendAi();
		NPC_FLINCH_DISABLE = true;
		MOVE_SUSPEND_UNTIL = GameTime() + 30.0f;

		BREATH_CONE_YAW = AnglesOf(ENT_ME).y;
		// subtract BREATH_CONE_YAW 45
		// if ( BREATH_CONE_YAW < 0 ) add BREATH_CONE_YAW 359.99
		Vector3 breathPos = OriginOf(ENT_ME);
		breathPos += RelativePosition(Vector3(0, BREATH_CONE_YAW, 0), Vector3(0, BREATH_CONE_RANGE, 0));
		SetMoveDest(breathPos, 9999);
		BREATH_CONE_ACTIVE = true;
		BREATH_CONE_ON = false;
		OnBreathConeLoop();
	}

	// breath_cone_loop
	void OnBreathConeLoop()
	{
		int count;
		if (!BREATH_CONE_ACTIVE)
			return;
		CallEventDelayed(0.1f, "breath_cone_loop");

		Vector3 breathPos = OriginOf(ENT_ME);
		breathPos += RelativePosition(Vector3(0, BREATH_CONE_YAW, 0), Vector3(0, BREATH_CONE_RANGE, 0));
		SetMoveDest(breathPos, 9999);

		if (!BREATH_CONE_ON)
		{
			BREATH_CONE_YAW -= 0.5f;
			if (BREATH_CONE_YAW < 0.0f)
				BREATH_CONE_YAW += 359.99f;
		}
		else
		{
			BREATH_CONE_YAW += 1.0f;
			if (BREATH_CONE_YAW > 359.99f)
				BREATH_CONE_YAW -= 359.99f;
			if (GameTime() > NEXT_CONE_SCAN)
			{
				NEXT_CONE_SCAN = GameTime() + 0.5f;
				breathPos.z += 32.0f;
				CONE_TARGS = LegacyFunction("get_tsphere", "enemy", BREATH_CONE_AOE, breathPos);
				if (CONE_TARGS != "none")
				{
					count = GetTokenCount(CONE_TARGS);
					for (int i = 0; i < count; i++)
					{
						loopIteration = i;
						OnBreathConeAffectTargets();
					}
				}
			}
		}
	}

	// breath_cone_affect_targets
	void OnBreathConeAffectTargets()
	{
		int curIdx = loopIteration;
		CBaseEntity@ curTarg = FindEntity(GetToken(CONE_TARGS, curIdx));
		DoDamageEx(@curTarg, "direct", DMG_BREATH_CONE, "100%", ENT_ME, ENT_ME, "none", AURA_ELEMENT, "dmgevent:cone");
	}

	// cone_dodamage
	void OnConeDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		OnApplyDot2(target);
	}

	// frame_breath2_start
	void OnFrameBreath2Start()
	{
		BREATH_CONE_ON = true;
		PlaySound(1, 10, SOUND_BREATH2_STRIKE);
		PlaySound(4, 10, SOUND_BREATH2_LOOP);
		ClientEvent("update", "all", MY_CL_IDX, "cone_breath_on", BREATH_CONE_RANGE, BREATH_CONE_AOE);
	}

	// frame_breath2_end
	void OnFrameBreath2End()
	{
		BREATH_CONE_ON = false;
		PlaySound(4, 0, SOUND_BREATH2_LOOP);
		ClientEvent("update", "all", MY_CL_IDX, "cone_breath_off");
	}

	// frame_breath2_done
	void OnFrameBreath2Done()
	{
		OnBreathConeEnd();
	}

	// breath_cone_end
	void OnBreathConeEnd()
	{
		BREATH_CONE_ACTIVE = false;
		OnBreathEnd();
		PlayAnim("critical", ANIM_IDLE);
	}

	// frame_bite1_start
	// other frame events
	void OnFrameBite1Start()
	{
		PlaySound(0, 10, SOUND_ATTACK_HEAD1);
	}

	// frame_bite2_start
	void OnFrameBite2Start()
	{
		PlaySound(0, 10, SOUND_ATTACK_HEAD2);
	}

	// frame_bite3_start
	void OnFrameBite3Start()
	{
		PlaySound(0, 10, SOUND_ATTACK_HEAD3);
	}

	// frame_attack_bite1
	void OnFrameAttackBite1()
	{
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE1, "85%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:bite1");
		ANIM_ATTACK = ANIM_BITE2;
	}

	// frame_attack_bite2
	void OnFrameAttackBite2()
	{
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE2, "95%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:bite2");
		ANIM_ATTACK = ANIM_BITE3;
	}

	// frame_attack_bite3
	void OnFrameAttackBite3()
	{
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE3, "85%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:bite3");
		ANIM_ATTACK = ANIM_BITE1;
	}

	// bite1_dodamage
	void OnBite1Dodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(-200, 400, 110)));
		if (!hit)
			return;
		OnApplyDot1(target);
	}

	// bite2_dodamage
	void OnBite2Dodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(0, 800, 110)));
		if (!hit)
			return;
		OnApplyDot1(target);
	}

	// bite3_dodamage
	void OnBite3Dodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(200, 300, 110)));
		if (!hit)
			return;
		OnApplyDot1(target);
	}

	// aura_checktargets
	void OnAuraChecktargets()
	{
		DoDamageEx(RelativePosition(Vector3(0, 0, 0)), AURA_SIZE, "DMG_AURA", 0, ENT_ME, ENT_ME, "none", AURA_ELEMENT, "dmgevent:aura");
	}

	// aura_dodamage
	void OnAuraDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		OnApplyDot2(target);
	}

	// apply_dot1
	void OnApplyDot1(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOT_EFFECTNAME))
			return;
		ApplyEffect(target, DOT_SCRIPT, DOT_DUR, self, DOT_DMG);
	}

	// apply_dot2
	void OnApplyDot2(CBaseEntity@ target = null)
	{
		if (HasEffect(target, DOTALT_EFFECTNAME))
			return;
		ApplyEffect(target, DOTALT_SCRIPT, DOTALT_DUR, self, DOTALT_DMG);
	}

	// do_tail_check
	void OnDoTailCheck()
	{
		float back = AOE_TAIL;
		back = -back;
		Vector3 scanPoint = RelativePosition(Vector3(0, back, 32));
		TAIL_TARGS = LegacyFunction("get_tsphere", "enemy", AOE_TAIL, scanPoint);
		if (TAIL_TARGS == "none")
			return;
		DID_TAIL = true;
		PlayAnim("critical", ANIM_TAILWHIP);
	}

	// frame_tailwhip_start
	void OnFrameTailwhipStart()
	{
		PlaySound(0, 10, SOUND_TAIL);
		// <model> <target> <attach> <width> <life> <brightness> <color>
		ClientEvent("update", "all", MY_CL_IDX, "add_beam", 2.0f, ATTACH_TAIL, COL_BEAM1, COL_BEAM2);
	}

	// frame_attack_tailwhip
	void OnFrameAttackTailwhip()
	{
		float back = AOE_TAIL;
		back = -back;
		Vector3 scanPoint = RelativePosition(Vector3(0, back, 32));
		DoDamageEx(scanPoint, AOE_TAIL, DMG_TAIL, "100%", ENT_ME, ENT_ME, "none", "slash", "dmgevent:tail");
	}

	// tail_dodamage
	void OnTailDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		AddVelocity(target, RelativeVelocity(Vector3(300, -600, 220)));
		if (!hit)
			return;
		OnApplyDot2(target);
	}

	// ext_beam_test
	void OnExtBeamTest()
	{
		ClientEvent("update", "all", MY_CL_IDX, "add_beam", 30.0f, ATTACH_HEAD_MID, LegacyFunction("clcol", COL_BEAM1), LegacyFunction("clcol", COL_BEAM2));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	void OnApplyDot(CBaseEntity@ target = null) {} // apply_dot

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("explode1.spr");
		Precache("3dmflagry.spr");
		Precache("xfireball3.spr");
		Precache("magic/sps_fogfire.wav");
		Precache("magic/cold_breath.wav");
		Precache("magic/bolt_loop.wav");
		Precache("magic/flame_loop.wav");
		Precache("monsters/hydra_small.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HydraFireLesser_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseStruck_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_dot1") { OnApplyDot1(EntityParam(params, 0)); return true; }
		if (name == "apply_dot2") { OnApplyDot2(EntityParam(params, 0)); return true; }
		if (name == "aura_checktargets") { OnAuraChecktargets(); return true; }
		if (name == "aura_dodamage") { OnAuraDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bite1_dodamage") { OnBite1Dodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bite2_dodamage") { OnBite2Dodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "bite3_dodamage") { OnBite3Dodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "breath_cone_affect_targets") { OnBreathConeAffectTargets(); return true; }
		if (name == "breath_cone_end") { OnBreathConeEnd(); return true; }
		if (name == "breath_cone_loop") { OnBreathConeLoop(); return true; }
		if (name == "breath_cone_start") { OnBreathConeStart(); return true; }
		if (name == "breath_end") { OnBreathEnd(); return true; }
		if (name == "breath_guided_start") { OnBreathGuidedStart(); return true; }
		if (name == "breath_rapid_end") { OnBreathRapidEnd(); return true; }
		if (name == "breath_rapid_start") { OnBreathRapidStart(); return true; }
		if (name == "cone_dodamage") { OnConeDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "do_breath") { OnDoBreath(); return true; }
		if (name == "do_tail_check") { OnDoTailCheck(); return true; }
		if (name == "ext_beam_test") { OnExtBeamTest(); return true; }
		if (name == "ext_fire_bomb") { OnExtFireBomb(Vec(Param(params, 0))); return true; }
		if (name == "frame_attack_bite1") { OnFrameAttackBite1(); return true; }
		if (name == "frame_attack_bite2") { OnFrameAttackBite2(); return true; }
		if (name == "frame_attack_bite3") { OnFrameAttackBite3(); return true; }
		if (name == "frame_attack_tailwhip") { OnFrameAttackTailwhip(); return true; }
		if (name == "frame_bite1_start") { OnFrameBite1Start(); return true; }
		if (name == "frame_bite2_start") { OnFrameBite2Start(); return true; }
		if (name == "frame_bite3_start") { OnFrameBite3Start(); return true; }
		if (name == "frame_breath1_begin") { OnFrameBreath1Begin(); return true; }
		if (name == "frame_breath1_done") { OnFrameBreath1Done(); return true; }
		if (name == "frame_breath1_strike") { OnFrameBreath1Strike(); return true; }
		if (name == "frame_breath2_begin") { OnFrameBreath2Begin(); return true; }
		if (name == "frame_breath2_done") { OnFrameBreath2Done(); return true; }
		if (name == "frame_breath2_end") { OnFrameBreath2End(); return true; }
		if (name == "frame_breath2_start") { OnFrameBreath2Start(); return true; }
		if (name == "frame_breath3_begin") { OnFrameBreath3Begin(); return true; }
		if (name == "frame_breath3_done") { OnFrameBreath3Done(); return true; }
		if (name == "frame_breath3_strike") { OnFrameBreath3Strike(); return true; }
		if (name == "frame_tailwhip_start") { OnFrameTailwhipStart(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "hydra_finalize") { OnHydraFinalize(); return true; }
		if (name == "hydra_init_combat") { OnHydraInitCombat(); return true; }
		if (name == "hydra_spawn") { OnHydraSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "rapid_dodamage") { OnRapidDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "refresh_cl_effects") { OnRefreshClEffects(); return true; }
		if (name == "tail_dodamage") { OnTailDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
