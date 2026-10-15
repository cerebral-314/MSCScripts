#pragma context server

// Converted from monsters/djinn_lightning_lesser_alt.script by msc_transpiler.
// Lesser Lightning Djinn rebuild by Thothie
// - CMD's isn't working too well in its native environment

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_lightning_shield.as"

[script "monsters/djinn_lightning_lesser_alt"]
class DjinnLightningLesserAlt : BaseMonsterNewScript, BaseLightningShield
{
	// Constants
	string ANIM_SWIPE = "attack1";
	string ANIM_HEADBUTT = "attack2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "jump";
	string ANIM_SEARCH = "idle_look";
	string ANIM_WALK_DEFAULT = "walk";
	string ANIM_RUN_DEFAULT = "run1";
	string ANIM_IDLE_DEFAULT = "idle1";
	string ANIM_WARCRY = "warcry";
	string ANIM_JUMPING_JACKS = "idle2";
	string ANIM_BEAM = "beam";
	int RANGE_SWIPE = 140;
	int RANGE_HEADBUTT = 100;
	float FREQ_JUMP = 5.0f;
	int MAX_JUMP_RANGE = 600;
	float FREQ_RNDJUMP = 0.0f;
	float FREQ_HEADBUTT = 7.0f;
	string CHANCE_SHOCK = "30";
	float DOT_SHOCK = 40.0f;
	string DMG_SWIPE = "100";
	int DMG_HEADBUTT = 50;
	string ATTACK_HITCHANCE = "95%";
	string CL_SCRIPT = "monsters/djinn_lightning_lesser_cl";
	float FREQ_FX_REFRESH = 15.0f;
	float FREQ_SHIELD = 45.0f;
	float FREQ_BLAST = 0.0f;
	float DMG_BEAM = 100.0f;
	int DMG_BEAM_SECONDARY = 100;
	string SOUND_BCHARGE = "magic/bolt_start.wav";
	string SOUND_LOOP = "magic/bolt_loop.wav";
	string SOUND_BFIRE = "magic/bolt_end.wav";
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle2.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE5 = "bullchicken/bc_idle5.wav";
	string SOUND_HEADBUTT = "bullchicken/bc_spithit1.wav";
	string SOUND_SWIPEHIT1 = "zombie/claw_strike1.wav";
	string SOUND_SWIPEHIT2 = "zombie/claw_strike2.wav";
	string SOUND_SWIPEMISS1 = "zombie/claw_miss1.wav";
	string SOUND_SWIPEMISS2 = "zombie/claw_miss2.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_STEP1 = "player/pl_dirt1.wav";
	string SOUND_STEP2 = "player/pl_dirt2.wav";
	string SOUND_PAIN_WEAK = "bullchicken/bc_pain2.wav";
	string SOUND_PAIN_STRONG = "bullchicken/bc_pain1.wav";
	string SOUND_WARCRY = "bullchicken/bc_attackgrowl3.wav";
	string SOUND_LEAP = "bullchicken/bc_attackgrowl2.wav";
	string SOUND_LEAP_LAND = "weapons/g_bounce2.wav";
	string SOUND_FLINCH = "bullchicken/bc_pain3.wav";
	bool LSHIELD_PASSIVE = false;
	int LSHIELD_RADIUS = 256;
	int LSHIELD_REPELL_STRENGTH = 500;
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_UNHOLY = true;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float ATTACK_HIDX = 0.0f;
	float WEAK_THRESHOLD = 0.0f;
	string CL_SCRIPT_IDX = "CL_SCRIPT_IDX";
	CBaseEntity@ BEAM1_ID = null;
	CBaseEntity@ BEAM2_ID = null;
	float NEXT_JUMP = 0.0f;
	float NEXT_BLAST = 0.0f;
	float NEXT_SHIELD = 0.0f;
	bool DID_WARCRY = false;
	float UP_JUMP_STR = 0.0f;
	float FWD_JUMP_STR = 0.0f;
	float NEXT_RNDJUMP = 0.0f;
	bool SWIPE_ATTACK = false;
	bool HEADBUTT_ATTACK = false;
	float NEXT_HEADBUTT = 0.0f;
	bool DMG_FROM_BEAM = false;
	string BEAM_TARGET = "BEAM_TARGET";
	string BEAM_TYPE = "BEAM_TYPE";
	bool BEAM_ACTIVE = false;
	bool NPC_DIRECT_ATTACK = false;
	float MAX_SUSPEND_AI = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	DjinnLightningLesserAlt()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
	}

	// unnamed block (first think)
	void DjinnLightningLesserAlt_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";
		ANIM_ATTACK = "attack1";
	}

	// unnamed block (first think)
	void DjinnLightningLesserAlt_FirstThink2()
	{
		NPC_GIVE_EXP = 2000.0f;

		IS_UNHOLY = true;

		DROP_GOLD = 1;
		DROP_GOLD_AMT = 500.0f;

		ATTACK_MOVERANGE = 88.0f;
		MOVE_RANGE = "88";
		ATTACK_RANGE = 140.0f;
		ATTACK_HITRANGE = 160.0f;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10%";
		FLINCH_DELAY = "10.0";
		FLINCH_HEALTH = 2000.0f;
	}

	// unnamed block (timer)
	// =================== Idle Sounds
	void DjinnLightningLesserAlt_Timer()
	{
		CallEventDelayed(Random(3, 10), "DjinnLightningLesserAlt_Timer");

		if (!IsAlive(ENT_ME))
			return;
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// unnamed block (timer)
	// =================== CL FX Refresh
	void DjinnLightningLesserAlt_Timer2()
	{
		CallEventDelayed(FREQ_FX_REFRESH, "DjinnLightningLesserAlt_Timer2");

		if (!IsAlive(ENT_ME))
			return;

		if (CL_SCRIPT_IDX != "CL_SCRIPT_IDX")
			ClientEvent("update", "all", CL_SCRIPT_IDX, "remove_fx");

		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_FX_REFRESH);
		CL_SCRIPT_IDX = LastClientScriptId();
	}

	// game_dodamage
	// =================== Handle Outgoing Damage Effects
	string DjinnLightningLesserAlt_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (DMG_FROM_BEAM)
		{
			if (BEAM_TYPE == "push")
				SetVelocity(BEAM_TARGET, RelativeVelocity(Vec("MON_ANGLES"), Vector3(0, 1000, 110)));
			else
				SetVelocity(BEAM_TARGET, RelativeVelocity(Vec("MON_ANGLES"), Vector3(0, -1000, 110)));
		}
		DMG_FROM_BEAM = false;

		if (SWIPE_ATTACK)
		{
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			if (hit)
			{
				PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
				if (RandomInt(1, 100) < Float(CHANCE_SHOCK))
				{
					PlaySound(2, 10, SOUND_BFIRE);
					Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, 1, 1);
					if (RangeTo(target) < ATTACK_HITRANGE)
						ApplyEffect(target, "effects/dot_lightning", RandomInt(2, 5), self, DOT_SHOCK);
				}
			}
		}
		SWIPE_ATTACK = false;

		if (HEADBUTT_ATTACK)
		{
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			if (hit)
			{
				PlaySound(0, 10, SOUND_HEADBUTT);
				if (RangeTo(target) < RANGE_HEADBUTT)
					ApplyEffect(target, "effects/debuff_stun", 5, self);
			}
		}
		HEADBUTT_ATTACK = false;
		return result;
	}

	// unnamed block (timer)
	void DjinnLightningLesserAlt_Timer3()
	{
		CallEventDelayed(10.0f, "DjinnLightningLesserAlt_Timer3");
		if (!IsAlive(ENT_ME))
			return;
		if (!SUSPEND_AI)
			return;
		if (!(GameTime() > MAX_SUSPEND_AI))
			return;
		OnNpcatkResumeAi();
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(CL_SCRIPT);
	}

	// game_death
	// =================== Death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
		OnBeamsRemove();
	}

	// game_struck
	// PARAM1 = damage
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		bool exitSub = false;
		if (HealthOf(ENT_ME) > WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_STRONG);
		if (HealthOf(ENT_ME) <= WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_WEAK);

		if (I_R_FROZEN)
			return;

		if (damage > 200.0f)
		{
			// dbg leaping away due to damage
			if (RandomInt(1, 2) == 1)
			{
				OnLeapAway();
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (RangeTo(ENT_LASTSTRUCK) < ATTACK_RANGE && RandomInt(1, 10) == 1)
			OnLeapAway();
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lesser Lightning Djinn");
		SetHealth(5000);
		SetRace("demon");
		SetRoam(true);
		SetGold(0);
		SetModel("monsters/swamp_ogre.mdl");
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(8);
		SetBlood("green"); // check in code

		SetProp(ENT_ME, "skin", 4);

		// debuggary
		float defAttackRange = Float(Eval("game.monster.moveprox"));
		defAttackRange *= 1.5f;
		DebugPrint("npc_spawn " + Text(defAttackRange));

		SetDamageTaken("all", 0.7f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 0.5f);
		SetDamageTaken("acid", 2);
		SetDamageTaken("poison", 1.25f);

		ATTACK_HIDX = 0.0f;

		WEAK_THRESHOLD = MaxHealthOf(ENT_ME) * 0.3f;

		CallEventDelayed(0.1f, "setup_client");
		CallEventDelayed(0.2f, "init_beam1");
		CallEventDelayed(0.3f, "init_beam2");
	}

	// npcatk_hunt
	// =================== Main Cycle
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield
		float gameTimePlus = 0.0f;
		bool exitSub = false;

		if (NPCATK_TARGET == "unset")
			return;

		if (SUSPEND_AI)
			return;
		if (I_R_FROZEN)
			return;

		float gameTime = GameTime();

		if (gameTime > NEXT_BLAST && CanSee(NPCATK_TARGET))
		{
			OnDoBlast();
			NEXT_BLAST = gameTime + FREQ_BLAST;

			// try not to shield right after blast, or visa versa
			gameTimePlus = gameTime + 5.0f;
			if (gameTimePlus > NEXT_SHIELD)
			{
				NEXT_SHIELD += 10.0f;
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_SHIELD && RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
		{
			OnDoShield();
			NEXT_SHIELD = gameTime + FREQ_SHIELD;

			// try not to shield right after blast, or visa versa
			gameTimePlus = gameTime + 10.0f;
			if (gameTimePlus > NEXT_BLAST)
			{
				NEXT_BLAST += 15.0f;
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_JUMP && RangeTo(NPCATK_TARGET) < MAX_JUMP_RANGE)
		{
			float myZ = OriginOf(ENT_ME).z;
			float targZ = OriginOf(NPCATK_TARGET).z;
			if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
				targZ -= 38.0f;

			float zDiff = targZ;
			string zDiffText;
			zDiff -= myZ;

			if (zDiff > ATTACK_RANGE)
			{
				OnDoHop(zDiff);
				exitSub = true;
				NEXT_JUMP = gameTime + FREQ_JUMP;

				// don't do a positional jump and random jump one after the other
				NEXT_RNDJUMP = gameTime + FREQ_RNDJUMP;
			}
		}
		if (exitSub)
			return;

		if (gameTime > NEXT_RNDJUMP)
		{
			// random jump (hopefully land behind player)
			if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
			{
				NEXT_RNDJUMP = gameTime + FREQ_RNDJUMP;
				OnDoHop(RandomInt(80, 200));
			}
		}
	}

	// npcatk_suspend_ai
	// hacky brain death prevention
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		MAX_SUSPEND_AI = GameTime() + 20.0f;
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnLightningLesserAlt_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_WARCRY = false;
	}

	// npc_targetsighted
	// =================== Warcry
	// first spot
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;

		float gameTime = GameTime();

		NEXT_JUMP = gameTime + FREQ_JUMP;

		NEXT_BLAST = gameTime + FREQ_BLAST;

		NEXT_SHIELD = gameTime + FREQ_SHIELD;

		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
	}

	// setup_client
	// =================== Init Client
	void OnSetupClient()
	{
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME), FREQ_FX_REFRESH);
		CL_SCRIPT_IDX = LastClientScriptId();
	}

	// init_beam1
	// =================== Setup Beams
	void OnInitBeam1()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		@BEAM1_ID = EntityOf(ENT_LASTCREATED);
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		@BEAM2_ID = EntityOf(ENT_LASTCREATED);
	}

	// beams_remove
	void OnBeamsRemove()
	{
		Effect("beam", "update", @BEAM1_ID, "brightness", 0);
		Effect("beam", "update", @BEAM2_ID, "brightness", 0);
		Effect("beam", "update", @BEAM1_ID, "remove", 0.1f);
		Effect("beam", "update", @BEAM2_ID, "remove", 0.1f);
	}

	// do_hop
	// =================== Hop up at targets out of reach (from elf_base)
	// <vertical_difference> - determines jump strength
	void OnDoHop(float verticalDifference = 0.0f)
	{
		PlayAnim("critical", ANIM_LEAP);
		PlaySound(0, 10, SOUND_LEAP);
		UP_JUMP_STR = verticalDifference * 5.0f;
		OnNpcatkSuspendAi("1.0");
		FWD_JUMP_STR = RangeTo(NPCATK_TARGET);
		DebugPrint("do_hop " + Text(UP_JUMP_STR) + " " + Text(FWD_JUMP_STR));
		CallEventDelayed(0.1f, "do_jump_boost");
	}

	// do_jump_boost
	void OnDoJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, FWD_JUMP_STR, UP_JUMP_STR)));
	}

	// run_step1
	// =================== Anim Events
	// called from model during ANIM_RUN
	void OnRunStep1()
	{
		PlaySound(0, 5, SOUND_STEP1);
	}

	// run_step2
	// called from model during ANIM_RUN
	void OnRunStep2()
	{
		PlaySound(0, 5, SOUND_STEP2);
	}

	// attack1
	void OnAttack1()
	{
		SWIPE_ATTACK = true;
		if (!NPC_DIRECT_ATTACK)
			DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SWIPE, ATTACK_HITCHANCE);
		else
			DoDamage(NPCATK_TARGET, "direct", DMG_SWIPE, ATTACK_HITCHANCE, ENT_ME);

		Vector3 attackStart = AttachmentPositionOf(ENT_ME, ATTACK_HIDX);
		Vector3 targOrg = OriginOf(NPCATK_TARGET);
		Vector3 angToTarg = Angles3DTo(attackStart, targOrg);
		angToTarg.x = -angToTarg.x;

		ClientEvent("update", "all", CL_SCRIPT_IDX, "hand_sprite", angToTarg, ATTACK_HIDX);

		ATTACK_HIDX += 1.0f;
		if (ATTACK_HIDX > 1.0f)
			ATTACK_HIDX = 0.0f;

		if (!(GameTime() > NEXT_HEADBUTT))
			return;
		ANIM_ATTACK = ANIM_HEADBUTT;
		ATTACK_RANGE = RANGE_HEADBUTT;
	}

	// attack2
	// headbut on frame 6 of attack2
	void OnAttack2()
	{
		HEADBUTT_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_HEADBUTT, ATTACK_HITCHANCE);

		ANIM_ATTACK = ANIM_SWIPE;
		ATTACK_RANGE = RANGE_SWIPE;
		NEXT_HEADBUTT = GameTime() + FREQ_HEADBUTT;
	}

	// leap_done
	void OnLeapDone()
	{
		PlaySound(0, 10, SOUND_LEAP_LAND);
		SetMoveAnim(ANIM_RUN);
	}

	// npc_flinch
	// =================== Struck and Flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// leap_away
	void OnLeapAway(string target = "")
	{
		PlayAnim("critical", ANIM_LEAP);
		SetMoveDest(NPCATK_TARGET, 99999, "flee");
		CallEventDelayed(0.1f, "leap_boost");
		OnNpcatkSuspendAi("2.0");
	}

	// leap_boost
	void OnLeapBoost()
	{
		if (I_R_FROZEN)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 100)));
	}

	// do_shield
	// =================== Shield
	void OnDoShield()
	{
		DebugPrint("do_shield");

		OnNpcatkSuspendAi();
		OnSuspendMovement(ANIM_JUMPING_JACKS);
		OnLshieldActivate(10.0f);
		CallEventDelayed(10.0f, "end_shield");
	}

	// end_shield
	void OnEndShield()
	{
		OnNpcatkResumeAi();
		OnResumeMovement();
	}

	// suspend_movement
	// =================== Suspend/Resume Movement
	// <hold anim>
	void OnSuspendMovement(string holdAnimation = "")
	{
		CAN_FLINCH = "0";
		SetRoam(false);
		ANIM_RUN = holdAnimation;
		ANIM_IDLE = holdAnimation;
		SetMoveAnim(holdAnimation);
		SetIdleAnim(holdAnimation);
		PlayAnim("critical", holdAnimation);
	}

	// resume_movement
	void OnResumeMovement()
	{
		CAN_FLINCH = "1";
		SetRoam(true);
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_IDLE = ANIM_IDLE_DEFAULT;

		SetMoveAnim(ANIM_RUN_DEFAULT);
		SetIdleAnim(ANIM_IDLE_DEFAULT);
	}

	// do_blast
	// =================== Blast
	void OnDoBlast()
	{
		DebugPrint("do_blast entered");

		BEAM_TARGET = NPCATK_TARGET;
		OnNpcatkSuspendAi();
		OnSuspendMovement(ANIM_BEAM);

		DebugPrint("do_blast setup_beams");

		Effect("beam", "update", @BEAM1_ID, "end_target", BEAM_TARGET, 1);
		Effect("beam", "update", @BEAM1_ID, "brightness", 200);
		Effect("beam", "update", @BEAM2_ID, "end_target", BEAM_TARGET, 2);
		Effect("beam", "update", @BEAM2_ID, "brightness", 200);

		DebugPrint("do_blast setup_sounds");

		PlaySound(0, 10, SOUND_ZAP_START);
		ServerPlaySound(1, 10, SOUND_ZAP_LOOP);

		if (RangeTo(BEAM_TARGET) > 300.0f)
			BEAM_TYPE = "pull";
		else
			BEAM_TYPE = "push";

		DoDamage(BEAM_TARGET, 2048, DMG_BEAM, "100%", "lightning");
		ApplyEffect(BEAM_TARGET, "effects/dot_lightning", 5.0f, self, DOT_SHOCK);

		BEAM_ACTIVE = true;
		OnBeamLoop();
		CallEventDelayed(2.0f, "end_beam");
	}

	// end_beam
	void OnEndBeam()
	{
		BEAM_ACTIVE = false;
		OnNpcatkResumeAi();
		OnResumeMovement();
		ServerPlaySound(1, 0, SOUND_ZAP_LOOP);
		Effect("beam", "update", @BEAM1_ID, "end_target", ENT_ME, 0);
		Effect("beam", "update", @BEAM1_ID, "brightness", 0);
		Effect("beam", "update", @BEAM2_ID, "end_target", ENT_ME, 1);
		Effect("beam", "update", @BEAM2_ID, "brightness", 0);
	}

	// beam_loop
	void OnBeamLoop()
	{
		if (!BEAM_ACTIVE)
			return;
		CallEventDelayed(0.1f, "beam_loop");
		SetMoveDest(BEAM_TARGET, 9999);
		DMG_FROM_BEAM = true;
		DoDamage(BEAM_TARGET, 2048, DMG_BEAM_SECONDARY, "100%", "lightning");
		DMG_FROM_BEAM = false;

		Vector3 monAngles = AnglesOf(ENT_ME);
		monAngles.x = -monAngles.x;
	}

	// set_direct_attack
	void OnSetDirectAttack()
	{
		NPC_DIRECT_ATTACK = true;
		NPC_MUST_SEE_TARGET = "0";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/swamp_ogre.mdl");
		Precache("magic/bolt_loop.wav");
		CallEventDelayed(Float(Eval("$randf(3.0,10.0)")), "DjinnLightningLesserAlt_Timer");
		CallEventDelayed(FREQ_FX_REFRESH, "DjinnLightningLesserAlt_Timer2");
		CallEventDelayed(10.0f, "DjinnLightningLesserAlt_Timer3");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnLightningLesserAlt_FirstThink();
		DjinnLightningLesserAlt_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseLightningShield_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "attack2") { OnAttack2(); return true; }
		if (name == "beam_loop") { OnBeamLoop(); return true; }
		if (name == "beams_remove") { OnBeamsRemove(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "do_blast") { OnDoBlast(); return true; }
		if (name == "do_hop") { OnDoHop(Float(Param(params, 0))); return true; }
		if (name == "do_jump_boost") { OnDoJumpBoost(); return true; }
		if (name == "do_shield") { OnDoShield(); return true; }
		if (name == "end_beam") { OnEndBeam(); return true; }
		if (name == "end_shield") { OnEndShield(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_done") { OnLeapDone(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "resume_movement") { OnResumeMovement(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "set_direct_attack") { OnSetDirectAttack(); return true; }
		if (name == "setup_client") { OnSetupClient(); return true; }
		if (name == "suspend_movement") { OnSuspendMovement(Param(params, 0)); return true; }
		if (name == "DjinnLightningLesserAlt_Timer") { DjinnLightningLesserAlt_Timer(); return true; }
		if (name == "DjinnLightningLesserAlt_Timer2") { DjinnLightningLesserAlt_Timer2(); return true; }
		if (name == "DjinnLightningLesserAlt_Timer3") { DjinnLightningLesserAlt_Timer3(); return true; }
		return BaseLightningShield_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
