#pragma context server

// Converted from monsters/abomination_venom.script by msc_transpiler.
// acid breath
// fire breath
// poison burst
// charge (turn off roam, set no turn, stop if angle changes?)
// acid bomb (periodic range atk? splash anim via mummy cyl?)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/abomination_venom"]
class AbominationVenom : BaseMonsterNewScript
{
	// Constants
	string ANIM_ATTACK_SHORT = "attack1";
	string ANIM_ATTACK_LONG = "attack2";
	string ANIM_CRAWL = "crawl";
	string ANIM_WALK_ACTIVE = "walk";
	string ANIM_LIGHTNING = "breath_fast";
	string ANIM_FLING = "grab_fling";
	string ANIM_JUMP = "jump";
	string ANIM_BREATH_ATTACK = "breath";
	string ANIM_RAWR = "rawr";
	string ANIM_CHARGE = "run";
	float MONSTER_HP = 20000.0f;
	int ATTACK_RANGE_SHORT = 100;
	int ATTACK_RANGE_LONG = 150;
	int ATTACK_HITRANGE_SHORT = 150;
	int ATTACK_HITRANGE_LONG = 200;
	string ATTACK_HITCHANCE = "80%";
	int DOT_BREATH = 200;
	int DMG_BITE_SHORT = 300;
	int DMG_BITE_LONG = 600;
	int DMG_CHARGE = 50;
	int DOT_POISON_BURST = 100;
	float FREQ_SPECIAL = 0.0f;
	float FREQ_IDLE = 0.0f;
	string SOUND_RAWR = "monsters/abombination/rawr.wav";
	string SOUND_ATTACK1 = "monsters/abombination/attack1.wav";
	string SOUND_ATTACK2 = "monsters/abombination/attack2.wav";
	string SOUND_IDLE1 = "monsters/abombination/growl1.wav";
	string SOUND_IDLE2 = "monsters/abombination/growl2.wav";
	string SOUND_PAIN1 = "monsters/abombination/pain1.wav";
	string SOUND_PAIN2 = "monsters/abombination/pain2.wav";
	string SOUND_STEP1 = "monsters/abombination/step1.wav";
	string SOUND_STEP2 = "monsters/abombination/step2.wav";
	string SOUND_STRUCK1 = "weapons/bullet_hit1.wav";
	string SOUND_STRUCK2 = "weapons/bullet_hit2.wav";
	string SOUND_ATTACK_LONG = "zombie/claw_miss1.wav";
	string SOUND_ATTACK_SHORT = "zombie/claw_miss2.wav";
	string SOUND_BREATH_START = "ambience/steamburst1.wav";
	string SOUND_BREATH_LOOP = "ambience/steamjet1.wav";
	string SOUND_CHARGE_START = "monsters/abombination/rawr.wav";
	string SOUND_FBREATH = "monsters/goblin/sps_fogfire.wav";
	bool LSHIELD_PASSIVE = false;
	int LSHIELD_REPELL_STRENGTH = 300;
	float LSHIELD_FREQ_UPDATE = 0.25f;
	int DMG_LSHIELD = 300;
	int LSHIELD_RADIUS = 128;
	string SOUND_ZAP_LOOP = "magic/bolt_loop.wav";
	string SOUND_ZAP_START = "magic/bolt_end.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_UNHOLY = true;
	float CUR_SPECIAL = 0.0f;
	float NEXT_IDLE = 0.0f;
	float NPC_HALF_HEALTH = 0.0f;
	float NEXT_SPECIAL = 0.0f;
	float ATTACK_COUNTER = 0.0f;
	bool DID_WARCRY = false;
	string BREATH_TYPE = "BREATH_TYPE";
	float BREATH_IDX = 0.0f;
	float BREATH_ANG = 0.0f;
	float BREATH_COUNT = 0.0f;
	bool BREATH_ATTACK_ON = false;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";
	bool MELEE_ATTACK_SHORT = false;
	bool MELEE_ATTACK_LONG = false;
	string STUN_TARGS = "STUN_TARGS";
	bool IN_CHARGE = false;
	float CHARGE_YAW = 0.0f;
	string CHARGE_CL_FX = "CHARGE_CL_FX";
	float NEXT_TOUCH_CHECK = 0.0f;
	string BURST_TARGS = "BURST_TARGS";
	bool DROP_HUNDERSWAMP_CHEST = false;

	// Variables declared by included files, with the value they start with in this script
	AbominationVenom()
	{
		ANIM_WALK = "crawl";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		IMMUNE_VAMPIRE = true;
		SOUND_DEATH = "monsters/abombination/die.wav";
	}

	// unnamed block (first think)
	void AbominationVenom_FirstThink()
	{
		// base anims
		ANIM_WALK = "crawl";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ANIM_DEATH = "death1_die";
	}

	// unnamed block (first think)
	void AbominationVenom_FirstThink2()
	{
		// base stats
		NPC_GIVE_EXP = 8000.0f;
		ATTACK_RANGE = 150.0f;
		ATTACK_HITRANGE = 200.0f;
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
	}

	// game_dodamage
	string AbominationVenom_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (hit)
		{
			if (MELEE_ATTACK_LONG)
				AddVelocity(target, RelativeVelocity(Vector3(0, 400, 110)));
			if (MELEE_ATTACK_SHORT)
				AddVelocity(target, RelativeVelocity(Vector3(-150, 200, 110)));
		}
		MELEE_ATTACK_LONG = false;
		MELEE_ATTACK_SHORT = false;
		return result;
	}

	// game_touch
	string AbominationVenom_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		DebugPrint("game_touch " + NameOf(other));

		if (!(GameTime() > NEXT_TOUCH_CHECK))
			return result;
		NEXT_TOUCH_CHECK = GameTime() + 0.1f;

		Vector3 targOrg = OriginOf(other);
		Vector3 myOrg = OriginOf(ENT_ME);
		float newYaw = AnglesTo(myOrg, targOrg);

		AddVelocity(other, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 2000, 400)));
		DoDamage(other, 110, DMG_CHARGE, "100%", "blunt");
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (DROP_HUNDERSWAMP_CHEST)
		{
			if (Float(Eval("game.players.totalhp")) < 3000.0f)
			{
				UseTrigger("mm_abom_seal");
				UseTrigger("brk_weed");
			}
			CreateNpc("chests/hunderswamp1_extra", RelativePosition(Vector3(0, 0, 0)));
		}

		if (!BREATH_ATTACK_ON)
			return;
		ClientEvent("update", "all", BREATH_IDX, "end_fx");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (MaxHealthOf(ENT_ME) > NPC_HALF_HEALTH)
			PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2);
		else
			PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN1, SOUND_PAIN2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Venomous Bone Abomination");

		SetModel("monsters/abomination.mdl");
		SetProp(ENT_ME, "skin", 1);

		SetHeight(72);
		SetWidth(96);

		SetRace("demon");

		SetBlood("green");

		SetRoam(true);
		SetHearingSensitivity(4);

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		SetHealth(MONSTER_HP);

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("holy", 1.5f);
		SetDamageTaken("fire", 0.5f);
		SetDamageTaken("cold", 1);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 2);

		SetDamageTaken("slash", 1);
		SetDamageTaken("blunt", 1.25f);
		SetDamageTaken("pierce", 0.75f);
		SetDamageTaken("stun", 0.5f);

		CUR_SPECIAL = 0.0f;
		NEXT_IDLE = GameTime() + FREQ_IDLE;

		CallEventDelayed(2.0f, "final_adj");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool exitSub = false;

		if (IN_CHARGE)
			return;
		if (I_R_FROZEN)
			return;

		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE)
		{
			NEXT_IDLE = GameTime() + FREQ_IDLE;
			PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2);
			PlayAnim("once", "breath_slow");
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE_LONG)
		{
			ANIM_ATTACK = ANIM_ATTACK_LONG;
			ATTACK_RANGE = ATTACK_RANGE_LONG;
			ATTACK_HITRANGE = ATTACK_HITRANGE_LONG;
		}
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE_SHORT)
		{
			ANIM_ATTACK = ANIM_ATTACK_SHORT;
			ATTACK_RANGE = ATTACK_RANGE_SHORT;
			ATTACK_HITRANGE = ATTACK_HITRANGE_SHORT;
		}

		if (!(GameTime() > NEXT_SPECIAL))
			return;
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		if (CUR_SPECIAL > 4.0f)
			CUR_SPECIAL = 0.0f;
		CUR_SPECIAL += 1.0f;
		if (CUR_SPECIAL == 1.0f)
		{
			OnDoCharge();
			exitSub = true;
		}
		if (exitSub)
			return;

		// reset of these require target in range
		if (RangeTo(NPCATK_TARGET) > 400.0f)
		{
			CUR_SPECIAL = 0.0f;
			NEXT_SPECIAL = GameTime();
			float special = FREQ_SPECIAL * 0.5f;
			NEXT_SPECIAL += special;
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CUR_SPECIAL == 2.0f)
		{
			AS_ATTACKING = GameTime() + 3.0f;
			PlayAnim("critical", ANIM_JUMP);
			CallEventDelayed(0.01f, "jump_boost");
		}
		if (CUR_SPECIAL == 3.0f)
		{
			int rndBreath = RandomInt(1, 2);
			if (rndBreath == 1)
			{
				BREATH_TYPE = "1"; // fire
			}
			else
			{
				BREATH_TYPE = "0"; // blinding gas (default)
			}
			OnDoBreathAttack();
		}
		if (CUR_SPECIAL == 4.0f)
		{
			OnPoisonBurst();
			CUR_SPECIAL = 0.0f;
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, AbominationVenom_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		ATTACK_COUNTER = 0.0f;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_RAWR);
		PlaySound(0, 10, SOUND_RAWR);
		DID_WARCRY = true;
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_WARCRY = false;
	}

	// final_adj
	void OnFinalAdj()
	{
		NPC_HALF_HEALTH = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// jump_boost
	void OnJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, 200)));
	}

	// do_breath_attack
	void OnDoBreathAttack()
	{
		ClientEvent("new", "all", "monsters/abomination_cl", IndexOf(ENT_ME), BREATH_TYPE);
		BREATH_IDX = Float(LastClientScriptId());
		OnNpcatkSuspendAi();
		OnNpcatkSuspendMovement(ANIM_BREATH_ATTACK);
		if (Float(BREATH_TYPE) == 0.0f)
		{
			PlaySound(1, 10, SOUND_BREATH_START);
			PlaySound(2, 10, SOUND_BREATH_LOOP);
		}
		else
		{
			PlaySound(1, 10, SOUND_FBREATH);
		}
		PlayAnim("break");
		PlayAnim("hold", ANIM_BREATH_ATTACK);
		SetMoveDest(NPCATK_TARGET, 9999);
		BREATH_ANG = AnglesOf(ENT_ME).y - 45.0f;
		if (BREATH_ANG < 0.0f)
			BREATH_ANG += 359.0f;
		BREATH_COUNT = 0.0f;
		BREATH_ATTACK_ON = true;
		CallEventDelayed(0.01f, "breath_attack_loop");
	}

	// breath_attack_loop
	void OnBreathAttackLoop()
	{
		int count;
		if (!BREATH_ATTACK_ON)
			return;

		BREATH_COUNT += 1.0f;
		if (BREATH_COUNT == 45.0f)
			OnEndBreathAttack();

		if (!(BREATH_COUNT < 45.0f))
			return;
		CallEventDelayed(0.05f, "breath_attack_loop");

		BREATH_ANG += 1.0f;
		if (BREATH_ANG > 359.0f)
			BREATH_ANG -= 359.0f;

		Vector3 facePos = OriginOf(ENT_ME) + RelativePosition(Vector3(0, BREATH_ANG, 0), Vector3(0, 500, 0));
		SetMoveDest(facePos, 9999);

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 0.25f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 128, 0));
		CLOUD_TARGS = LegacyFunction("get_tsphere", "enemy", 256, scanPoint);
		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBreathAffectTargets();
			}
		}
	}

	// breath_affect_targets
	void OnBreathAffectTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(CLOUD_TARGS, loopIteration));
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 384.0f))
			return;
		if (Float(BREATH_TYPE) == 0.0f)
			ApplyEffect(curTarget, "effects/dot_poison_blind", 5.0f, self, DOT_BREATH, 0, 0, "none");
		else
			ApplyEffect(curTarget, "effects/dot_fire", 5.0f, self, DOT_BREATH);
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 800, 120)));
	}

	// end_breath_attack
	void OnEndBreathAttack()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;

		ClientEvent("update", "all", BREATH_IDX, "end_fx");
		OnNpcatkResumeAi();
		OnNpcatkResumeMovement();
		PlayAnim("critical", ANIM_ATTACK);
		ServerPlaySound(2, 0, SOUND_BREATH_LOOP);
		BREATH_ATTACK_ON = false;
	}

	// frame_attack_short
	void OnFrameAttackShort()
	{
		PlaySound(1, 10, SOUND_ATTACK_SHORT);
		ATTACK_COUNTER += 1.0f;
		if (ATTACK_COUNTER > 4.0f)
		{
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			ATTACK_COUNTER = Random(-2, 1);
		}
		MELEE_ATTACK_SHORT = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE_SHORT, ATTACK_HITCHANCE, "slash");
	}

	// frame_attack_long
	void OnFrameAttackLong()
	{
		PlaySound(1, 10, SOUND_ATTACK_LONG);
		ATTACK_COUNTER += 1.0f;
		if (ATTACK_COUNTER > 3.0f)
		{
			PlayRandomSound(2, 10, SOUND_ATTACK1, SOUND_ATTACK2);
			ATTACK_COUNTER = Random(-2, 1);
		}
		MELEE_ATTACK_LONG = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE_LONG, ATTACK_HITCHANCE, "slash");
	}

	// frame_run
	void OnFrameRun()
	{
		PlayRandomSound(0, 10, SOUND_STEP1, SOUND_STEP2);
	}

	// frame_jump_land
	void OnFrameJumpLand()
	{
		NEXT_SPECIAL = GameTime() + FREQ_SPECIAL;
		Vector3 myGround = OriginOf(ENT_ME);
		myGround.z = GroundHeight(myGround);
		ClientEvent("new", "all", "effects/sfx_stun_burst", myGround, 256, 1, Vector3(64, 64, 255));
		STUN_TARGS = FindInSphere("enemy", 256);
		if (STUN_TARGS == "none")
			return;
		int count = GetTokenCount(STUN_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnStunTargets();
		}
	}

	// stun_targets
	void OnStunTargets()
	{
		bool exitSub = false;
		CBaseEntity@ curTarg = FindEntity(GetToken(STUN_TARGS, loopIteration));
		if (IsPlayer(curTarg) && !IsOnGround(curTarg))
			exitSub = true;
		if (exitSub)
			return;
		ApplyEffect(curTarg, "effects/debuff_stun", 5.0f, self);
		Vector3 targOrg = OriginOf(curTarg);
		float targAng = AnglesTo(MyOrigin(), targOrg);
		int newYaw = int(targAng);
		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 800, 110)));
	}

	// do_charge
	void OnDoCharge()
	{
		PlaySound(0, 10, SOUND_CHARGE_START);
		IN_CHARGE = true;
		CHARGE_YAW = AnglesOf(ENT_ME).y;
		ClientEvent("new", "all", "effects/sfx_motionblur_perm", IndexOf(ENT_ME), 0);
		CHARGE_CL_FX = LastClientScriptId();
		OnNpcatkSuspendAi("5.0");
		SetCallback("touch", "enable");
		SetRoam(false);
		SetAnimFrameRate(3);
		SetMoveSpeed(3);
		PlayAnim("critical", ANIM_RUN);
		Vector3 chargeDest = OriginOf(ENT_ME);
		chargeDest += RelativePosition(Vector3(0, CHARGE_YAW, 0), Vector3(0, 4000, 0));
		SetMoveDest(chargeDest, 1);
		OnChargeScanLoop();
		CallEventDelayed(5.0f, "end_charge");
	}

	// end_charge
	void OnEndCharge()
	{
		if (!IN_CHARGE)
			return;
		ClientEvent("update", "all", CHARGE_CL_FX, "effect_die");
		IN_CHARGE = false;
		SetCallback("touch", "disable");
		SetRoam(true);
		SetAnimFrameRate(1);
		SetMoveSpeed(1);
		AS_ATTACKING = GameTime() + 5.0f;
		OnNpcatkResumeAi();
		PlayAnim("critical", ANIM_ATTACK_SHORT); // wish we had a stunned anim
	}

	// charge_scan_loop
	void OnChargeScanLoop()
	{
		if (!IN_CHARGE)
			return;
		CallEventDelayed(0.1f, "charge_scan_loop");

		// keep charge dest
		Vector3 chargeDest = OriginOf(ENT_ME);
		chargeDest += RelativePosition(Vector3(0, CHARGE_YAW, 0), Vector3(0, 256, 0));
		SetMoveDest(chargeDest, 1);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 300, 0)));
		PlayAnim("once", ANIM_RUN);

		Vector3 traceStart = OriginOf(ENT_ME);
		traceStart.z += 64.0f;
		string traceEnd = Text(traceStart);
		float myYaw = AnglesOf(ENT_ME).y;
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 100, 0)));
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine == traceEnd)
			return;
		// hit a wall
		// cl hitwall fx here (include sound)
		OnEndCharge();
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return AbominationVenom_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// poison_burst
	void OnPoisonBurst()
	{
		PlayAnim("critical", "grab_fling");
		AS_ATTACKING = GameTime() + 5.0f;
		Vector3 burstOrg = OriginOf(ENT_ME);
		burstOrg.z += 32.0f;
		ClientEvent("new", "all", "effects/sfx_poison_burst", burstOrg, 196, 0);
		BURST_TARGS = FindInSphere("enemy", 196);
		if (BURST_TARGS == "none")
			return;
		int count = GetTokenCount(BURST_TARGS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPoisonBurstAffectTargets();
		}
	}

	// poison_burst_affect_targets
	void OnPoisonBurstAffectTargets()
	{
		string curTarg = GetToken(BURST_TARGS, loopIteration);
		Vector3 targOrg = OriginOf(curTarg);
		Vector3 myOrg = OriginOf(ENT_ME);
		float newYaw = AnglesTo(myOrg, targOrg);

		AddVelocity(curTarg, RelativeVelocity(Vector3(0, newYaw, 0), Vector3(0, 2000, 400)));
		ApplyEffect(curTarg, "effects/poison_spore", 5.0f, self, DOT_POISON_BURST);
	}

	// set_hunderswamp_north_spec
	void OnSetHunderswampNorthSpec()
	{
		DebugPrint("set_hunderswamp_north_spec");
		DROP_HUNDERSWAMP_CHEST = true;
		SetRace("wildanimal");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/abomination.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AbominationVenom_FirstThink();
		AbominationVenom_FirstThink2();
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
		if (name == "breath_affect_targets") { OnBreathAffectTargets(); return true; }
		if (name == "breath_attack_loop") { OnBreathAttackLoop(); return true; }
		if (name == "charge_scan_loop") { OnChargeScanLoop(); return true; }
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_breath_attack") { OnDoBreathAttack(); return true; }
		if (name == "do_charge") { OnDoCharge(); return true; }
		if (name == "end_breath_attack") { OnEndBreathAttack(); return true; }
		if (name == "end_charge") { OnEndCharge(); return true; }
		if (name == "final_adj") { OnFinalAdj(); return true; }
		if (name == "frame_attack_long") { OnFrameAttackLong(); return true; }
		if (name == "frame_attack_short") { OnFrameAttackShort(); return true; }
		if (name == "frame_jump_land") { OnFrameJumpLand(); return true; }
		if (name == "frame_run") { OnFrameRun(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "jump_boost") { OnJumpBoost(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "poison_burst") { OnPoisonBurst(); return true; }
		if (name == "poison_burst_affect_targets") { OnPoisonBurstAffectTargets(); return true; }
		if (name == "set_hunderswamp_north_spec") { OnSetHunderswampNorthSpec(); return true; }
		if (name == "stun_targets") { OnStunTargets(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
