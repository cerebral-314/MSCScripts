#pragma context server

// Converted from monsters/djinn_lightning_lesser.script by msc_transpiler.
// Lesser Lightning Djinn by The Magical Bong/CrazyMonkeyDude (From Swamp Ogre by Thothie)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_lightning_shield.as"

[script "monsters/djinn_lightning_lesser"]
class DjinnLightningLesser : BaseMonsterNewScript, BaseLightningShield
{
	// Constants
	float ORC_HOP_DELAY = 1.0f;
	int ORC_JUMP_THRESH = 80;
	string ANIM_SEARCH = "idle_look";
	string ANIM_SWIPE = "attack1";
	string ANIM_HEADBUTT = "attack2";
	string ANIM_JUMP = "jump";
	string ANIM_LEAP = "jump";
	string ANIM_WARCRY = "warcry";
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
	float WEAK_THRESHOLD = 1250.0f;
	string SWIPE_DAMAGE = "$rand(75,110)";
	string HEADBUTT_CHANCE = "100%";
	float HEADBUTT_FREQ = 7.0f;
	string HEADBUTT_DAMAGE = "$rand(75,110)";
	string LEAP_DAMAGE = "$rand(20,75)";
	string LEAP_STUNCHANCE = "35%";
	int LEAP_RANGE_TOOFAR = 512;
	int LEAP_RANGE_TOOCLOSE = 128;
	float LEAP_AWAY_INTERVAL = 500.0f;
	float NEXT_LEAP_AWAY = 1800.0f;
	float FREQ_CHAIN = 0.0f;
	string CHANCE_SHOCK = "30";
	float DMG_CHAIN = 0.0f;
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	string ATTACK_HITCHANCE = "95%";
	bool LSHIELD_PASSIVE = false;
	int LSHIELD_RADIUS = 120;
	int DMG_LSHIELD = 60;
	float FREQ_SHIELD = 0.0f;
	string MONSTER_MODEL = "monsters/swamp_ogre.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK_DEFAULT = "walk";
	string ANIM_RUN_DEFAULT = "run1";
	string ANIM_FLINCH = "ANIM_FLINCH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool CAN_LEAP = false;
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float RUN_STEP = 0.0f;
	string CUR_BEAM = "CUR_BEAM";
	string BEAM_LIST = "BEAM_LIST";
	bool DID_WARCRY = false;
	bool LEAP_ENABLED = false;
	float NEXT_SHIELD = 0.0f;
	bool HEADBUTT_DELAY = false;
	bool SWIPE_ATTACK = false;
	bool HEADBUTT_ON = false;
	string NPC_DELAYING_UNSTUCK = "NPC_DELAYING_UNSTUCK";
	bool SEARCH_ANIM_DELAY = false;
	bool ORC_JUMPING = false;
	bool CHAIN_ON = false;
	float CHAIN_COUNT = 0.0f;
	string BEAM_TARGET_LIST = "BEAM_TARGET_LIST";
	string BEAM_ID = "BEAM_ID";

	// Variables declared by included files, with the value they start with in this script
	DjinnLightningLesser()
	{
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "bullchicken/bc_die1.wav";
	}

	// unnamed block (first think)
	void DjinnLightningLesser_FirstThink()
	{
		NPC_GIVE_EXP = 800.0f;
		ANIM_IDLE = "idle1";
		ANIM_WALK_DEFAULT = "walk";
		ANIM_RUN_DEFAULT = "run1";
		ANIM_DEATH = "dieforward";
		ANIM_FLINCH = "bigflinch";

		ANIM_WALK = ANIM_WALK_DEFAULT;
		ANIM_RUN = ANIM_RUN_DEFAULT;
		ANIM_ATTACK = ANIM_SWIPE;
		CAN_LEAP = true; // stop the hip-hopping when needed

		DROP_GOLD = 1;
		DROP_GOLD_MIN = 30;
		DROP_GOLD_MAX = 50;

		CAN_FLINCH = "1";
		FLINCH_CHANCE = "10%";
		FLINCH_DELAY = "10.0";
		FLINCH_HEALTH = 1750.0f;
	}

	// my_target_died
	void DjinnLightningLesser_OnMyTargetDied(string offender = "")
	{
		if (!CanSee("enemy"))
		{
			PlayAnim("critical", ANIM_WARCRY);
			PlaySound(0, 10, SOUND_WARCRY);
			DID_WARCRY = false;
			CallEventDelayed(1.0f, "enable_leap");
		}
	}

	// game_dodamage
	// 1: Attack Hit (1/0)  2: Entity Attack hit  3:  Start Position  4:  End Position
	string DjinnLightningLesser_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (HEADBUTT_ON)
		{
			if (hit)
			{
				PlaySound(0, 10, SOUND_HEADBUTT);
				ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5, self);
			}
			if (!hit)
				PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);
			ANIM_ATTACK = ANIM_SWIPE;
			HEADBUTT_ON = false;
			exitSub = true;
		}
		if (exitSub)
			return result;

		// assumes swipe
		if (SWIPE_ATTACK)
		{
			SWIPE_ATTACK = false;
			if (RandomInt(1, 100) < Float(CHANCE_SHOCK))
			{
				PlaySound(0, 10, "SOUND_BFIRE");
				Effect("glow", ENT_ME, Vector3(255, 255, 0), 64, 1, 1);
				ApplyEffect(target, "effects/dot_lightning", RandomInt(2, 5), self, 10);
			}
		}

		if (hit)
		{
			PlayRandomSound(0, 10, SOUND_SWIPEHIT1, SOUND_SWIPEHIT2);
			AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(-100, 130, 120)));
		}
		if (!hit)
			PlayRandomSound(0, 10, SOUND_SWIPEMISS1, SOUND_SWIPEMISS2);

		if (CHAIN_ON)
		{
			// effect beam point lgtning.spr 30 BEAM_START BEAM_END (255,255,255) 255 10 0.2
			// effect beam end lgtning.spr 30 BEAM_START PARAM2 0 (200,255,50) 200 10 0.2
			// callevent set_beam $get(PARAM2,id)
			AddVelocity(target, Vec(LegacyFunction("vec", 50, 0))); // $vec(0,-110,130)
		}
		return result;
	}

	// my_target_died
	void DjinnLightningLesser_OnMyTargetDied_2(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		// stop jumping (saves CPU when monster idle)
		ORC_JUMPING = false;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseLightningShield_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_lightning_shield
		int count = GetTokenCount(BEAM_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBeamsRemove();
		}
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
		SetDamageTaken("all", 0.8f);
		SetDamageTaken("lightning", 0);
		SetDamageTaken("holy", 0.25f);
		SetDamageTaken("poison", 1.5f);
	}

	// game_struck
	// PARAM1 = damage
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		bool exitSub = false;

		if (MyHealth() > WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_STRONG);
		if (MyHealth() <= WEAK_THRESHOLD)
			PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_PAIN_WEAK);

		if (damage > 200.0f)
		{
			// dbg leaping away due to damage
			OnLeapAway();
			exitSub = true;
		}
		if (exitSub)
			return;

		float hpAfter = MyHealth() - damage;

		if (hpAfter < NEXT_LEAP_AWAY)
		{
			// dbg leaping away due to interval
			NEXT_LEAP_AWAY -= LEAP_AWAY_INTERVAL;
			OnLeapAway();
		}
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Lesser Lightning Djinn");
		SetHealth(2750);
		SetRace("demon");
		SetRoam(true);
		SetModel(MONSTER_MODEL);
		SetMoveAnim(ANIM_WALK);
		SetHeight(64);
		SetWidth(32);
		SetHearingSensitivity(2);
		SetBlood("green"); // check in code
		SetIdleAnim(ANIM_IDLE);

		RUN_STEP = 0.0f;

		CallEventDelayed(1.0f, "idle_sounds");

		CUR_BEAM = "0";
		BEAM_LIST = "";
		CallEventDelayed(0.1f, "init_beam1");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseLightningShield_OnNpcatkHunt(); // monsters/base_lightning_shield

		if (!(GameTime() > NEXT_SHIELD))
			return;
		NEXT_SHIELD = GameTime() + FREQ_SHIELD;
		OnExtLshieldOn();

		// regenerate
		if (MyHealth() < MyMaxHealth())
			GiveHealth(0.1f);

		if (NPCATK_TARGET == "unset")
			return;
		if (!(RangeTo(NPCATK_TARGET) <= LEAP_RANGE_TOOFAR))
			return;
		if (!(RangeTo(NPCATK_TARGET) > LEAP_RANGE_TOOCLOSE))
			return;
		if (!LEAP_ENABLED)
			return;

		LEAP_ENABLED = false;
		CallEventDelayed(5.0f, "enable_leap");
		OnScriptLeap(); // do not confused with model vent leap_attack
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		// if spotted player, start jump checks
		if (ORC_JUMPING)
			return;
		if (!IsPlayer(NPCATK_TARGET))
			return;
		ORC_JUMPING = true;
		CallEventDelayed(1.0f, "orc_jump_check");
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DjinnLightningLesser_OnMyTargetDied(offender);
		DjinnLightningLesser_OnMyTargetDied_2(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DjinnLightningLesser_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// cycle_up
	void OnCycleUp(string reason = "")
	{
		BaseNpcAttackNew_OnCycleUp(reason); // monsters/base_npc_attack_new
		CallEventDelayed(FREQ_CHAIN, "do_lightning");
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared

		if (HEADBUTT_DELAY)
		{
			ANIM_ATTACK = ANIM_SWIPE;
		}
		else if (RandomInt(1, 100) < Float(HEADBUTT_CHANCE))
		{
			ANIM_ATTACK = ANIM_HEADBUTT;
			HEADBUTT_DELAY = true;
			CallEventDelayed(HEADBUTT_FREQ, "headbutt_reset");
		}
	}

	// npcatk_validatetarget
	// first spot
	void OnNpcatkValidatetarget(string target = "")
	{
		if (!IsPlayer(target))
			return;
		if (DID_WARCRY)
			return;
		PlayAnim("critical", ANIM_WARCRY);
		PlaySound(0, 10, SOUND_WARCRY);
		DID_WARCRY = true;
	}

	// enable_leap
	void OnEnableLeap()
	{
		LEAP_ENABLED = true;
	}

	// script_leap
	void OnScriptLeap()
	{
		PlayAnim("critical", ANIM_LEAP);
		CallEventDelayed(0.1f, "leap_boost");
	}

	// leap_boost
	void OnLeapBoost()
	{
		if (I_R_FROZEN)
			return;
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 600, 100)));
	}

	// headbutt_reset
	void OnHeadbuttReset()
	{
		HEADBUTT_DELAY = false;
	}

	// attack1
	void OnAttack1()
	{
		SWIPE_ATTACK = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), SWIPE_DAMAGE, ATTACK_HITCHANCE);
	}

	// attack2
	// headbut on frame 6 of attack2
	void OnAttack2()
	{
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), HEADBUTT_DAMAGE, ATTACK_HITCHANCE);
		HEADBUTT_ON = true;
	}

	// leap_away
	void OnLeapAway(string target = "")
	{
		PlayAnim("critical", ANIM_LEAP);
		SetMoveDest(NPCATK_TARGET, 99999, "flee");
		CallEventDelayed(0.1f, "leap_boost");
		OnNpcatkSuspendAi("3.0");
	}

	// leap_attack
	// called from ANIM_LEAP at frame 28
	void OnLeapAttack()
	{
		PlaySound(0, 10, SOUND_LEAP);

		if (Truthy(LegacyFunction("cansee", "enemy", 128)))
		{
			OnNpcatkDodamage(EntityId(EntityOf(ENT_LASTSEEN)), Text(ATTACK_HITRANGE), LEAP_DAMAGE, ATTACK_HITCHANCE);
			if (RandomInt(1, 100) < Float(LEAP_STUNCHANCE))
				ApplyEffect(EntityOf(ENT_LASTSEEN), "effects/debuff_stun", 5, self);
		}
	}

	// leap_done
	void OnLeapDone()
	{
		PlaySound(0, 10, SOUND_LEAP_LAND);
		SetMoveAnim(ANIM_RUN);
	}

	// npcatk_search_init_advanced
	void OnNpcatkSearchInitAdvanced()
	{
		if (SEARCH_ANIM_DELAY)
			return;
		NPC_DELAYING_UNSTUCK = "10.0";
		PlayAnim("critical", ANIM_SEARCH);
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
		SEARCH_ANIM_DELAY = true;
		CallEventDelayed(5.0f, "reset_search_anim");
	}

	// reset_search_anim
	void OnResetSearchAnim()
	{
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_FLINCH);
	}

	// idle_sounds
	void OnIdleSounds()
	{
		CallEventDelayed(Random(3, 10), "idle_sounds");
		if (NPCATK_TARGET != "unset")
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5);
	}

	// run_step1
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

	// orc_jump_check
	void OnOrcJumpCheck()
	{
		if (!ORC_JUMPING)
			return;
		CallEventDelayed(ORC_HOP_DELAY, "orc_jump_check");
		if (!CAN_LEAP)
			return;
		if (IS_FLEEING)
			return;
		if (NPCATK_TARGET == "unset")
			return;
		if (!CanSee(NPCATK_TARGET))
			return;

		// jump at player if he's higher than I am
		Vector3 mePos = MyOrigin();
		float myZ = mePos.z;
		Vector3 targetPos = OriginOf(NPCATK_TARGET);
		float targetZ = targetPos.z;
		float targetZDifference = targetZ - myZ;

		if (targetZDifference > ORC_JUMP_THRESH)
			OnOrcHop();
	}

	// orc_hop
	void OnOrcHop()
	{
		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(NPCATK_TARGET, 1);
		PlayAnim("critical", ANIM_LEAP);
		PlaySound(0, 10, SOUND_LEAP);
		int jumpHeight = RandomInt(550, 650);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 250, jumpHeight)));
	}

	// bo_zombie_mode
	void OnBoZombieMode()
	{
		OnNpcSuicide();
	}

	// ext_lshield_on
	// [duration]
	void OnExtLshieldOn(float duration = 0.0f)
	{
		CAN_LEAP = false;
		float shieldDuration = duration;
		if (shieldDuration == 0.0f)
			shieldDuration = 3.0f;
		OnNpcatkSuspendAi();
		SetRoam(false);
		OnLshieldActivate(shieldDuration);
		SetIdleAnim("warcry");
		SetMoveAnim("warcry");
		PlaySound(0, 10, SOUND_WARCRY);
		CallEventDelayed(shieldDuration, "ext_end_shield");
	}

	// ext_end_shield
	void OnExtEndShield()
	{
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
		OnNpcatkResumeAi();
		SetRoam(true);
		CAN_LEAP = true;
	}

	// do_lightning
	// ====== DELUXE SHOCKIE (From bigger brother)
	void OnDoLightning(string endOrigin = "")
	{
		CHAIN_ON = true;
		CHAIN_COUNT = 0.0f;
		CAN_LEAP = false;
		OnNpcatkSuspendAi();
		Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 3, 1);
		CUR_BEAM = "0";
		BEAM_TARGET_LIST = LegacyFunction("get_tsphere", "enemy", 1024, MyOrigin());
		DebugPrint(BEAM_TARGET_LIST);
		int count = GetTokenCount(BEAM_TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnSetBeam();
		}
		CallEventDelayed(0.1f, "chain_lightning");
	}

	// chain_lightning
	void OnChainLightning()
	{
		int count;

		CHAIN_COUNT += 1.0f;
		if (CHAIN_COUNT < 10.0f)
		{
			SetIdleAnim("idle2");
			SetMoveAnim("idle2");
			CAN_LEAP = false;
		}
		if (CHAIN_COUNT == 10.0f)
		{
			CHAIN_ON = false;
			count = GetTokenCount(BEAM_LIST);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnBeamsOff();
			}
			CallEventDelayed(1.0f, "resume_attack");
			CallEventDelayed(FREQ_CHAIN, "do_lightning");
		}
		if (!(CHAIN_COUNT < 10.0f))
			return;
		CallEventDelayed(0.1f, "chain_lightning");
		// dodamage $relpos(0,0,0) 1024 DMG_CHAIN 100% 0.0 reflective lightning
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		count = GetTokenCount(BEAM_TARGET_LIST);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnPushTargets();
		}
		CAN_LEAP = true;
	}

	// push_targets
	void OnPushTargets()
	{
		CBaseEntity@ curTarget = FindEntity(GetToken(BEAM_TARGET_LIST, loopIteration));
		Vector3 targOrg = OriginOf(BEAM_TARGET_LIST);
		string traceLine = LegacyFunction("get_traceline", MyOrigin(), targOrg, "worldonly");
		if (traceLine != Text(targOrg))
			return;
		float finDmg = DMG_CHAIN;
		float resistFloat = DamageTakenOf(curTarget, "lightning");
		finDmg *= resistFloat;
		LegacyCommand("drainhp", @curTarget, ENT_ME, finDmg);
		AddVelocity(curTarget, Vector3(130, 0, 0));
	}

	// set_beam
	void OnSetBeam()
	{
		CBaseEntity@ curBeamId = FindEntity(GetToken(BEAM_LIST, Int(CUR_BEAM)));
		CBaseEntity@ curTarget = FindEntity(GetToken(BEAM_TARGET_LIST, loopIteration));

		if (curBeamId is null)
			return;

		DebugPrint("beam " + EntityId(curBeamId) + " to " + NameOf(curTarget));
		Effect("beam", "update", @curBeamId, "brightness", 200);
		Effect("beam", "update", @curBeamId, "end_target", @curTarget, 0);
		CUR_BEAM = Text(Float(CUR_BEAM) + 1.0f);

		// applyeffect CUR_TARGET effects/dot_lightning 3.0 $get(ent_me,id) DMG_SHOCK
		if (!(Float(CUR_BEAM) > GetTokenCount(BEAM_LIST)))
			return;
		CUR_BEAM = "0";
	}

	// beams_off
	void OnBeamsOff()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "brightness", 0);
	}

	// beams_remove
	void OnBeamsRemove()
	{
		Effect("beam", "update", GetToken(BEAM_LIST, loopIteration), "remove", 0);
	}

	// resume_attack
	void OnResumeAttack()
	{
		OnNpcatkResumeAi();
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_RUN);
	}

	// init_beam1
	void OnInitBeam1()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		BEAM_ID = EntityId(EntityOf(ENT_LASTCREATED));
		DebugPrint("init_beam1 " + BEAM_ID);
		CallEventDelayed(0.1f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam2 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 1, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam3 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
		CallEventDelayed(0.1f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "ents", "lgtning.spr", 30, ENT_ME, 2, ENT_ME, 0, Vector3(200, 255, 50), 0, 10, -1);
		BEAM_LIST = TokenAdd(BEAM_LIST, EntityId(EntityOf(ENT_LASTCREATED)));
		DebugPrint("init_beam4 " + BEAM_LIST + " " + EntityId(EntityOf(ENT_LASTCREATED)));
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqChain() {} // FREQ_CHAIN
	void OnHeadbuttFreq() {} // HEADBUTT_FREQ
	void OnOrcHopDelay() {} // ORC_HOP_DELAY
	void OnShieldDuration() {} // SHIELD_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/swamp_ogre.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DjinnLightningLesser_FirstThink();
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
		if (name == "beams_off") { OnBeamsOff(); return true; }
		if (name == "beams_remove") { OnBeamsRemove(); return true; }
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "chain_lightning") { OnChainLightning(); return true; }
		if (name == "cycle_up") { OnCycleUp(Param(params, 0)); return true; }
		if (name == "do_lightning") { OnDoLightning(Param(params, 0)); return true; }
		if (name == "enable_leap") { OnEnableLeap(); return true; }
		if (name == "ext_end_shield") { OnExtEndShield(); return true; }
		if (name == "ext_lshield_on") { OnExtLshieldOn(Float(Param(params, 0))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "headbutt_reset") { OnHeadbuttReset(); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "init_beam1") { OnInitBeam1(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "leap_attack") { OnLeapAttack(); return true; }
		if (name == "leap_away") { OnLeapAway(Param(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "leap_done") { OnLeapDone(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_search_init_advanced") { OnNpcatkSearchInitAdvanced(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "npcatk_validatetarget") { OnNpcatkValidatetarget(Param(params, 0)); return true; }
		if (name == "orc_hop") { OnOrcHop(); return true; }
		if (name == "orc_jump_check") { OnOrcJumpCheck(); return true; }
		if (name == "push_targets") { OnPushTargets(); return true; }
		if (name == "reset_search_anim") { OnResetSearchAnim(); return true; }
		if (name == "resume_attack") { OnResumeAttack(); return true; }
		if (name == "run_step1") { OnRunStep1(); return true; }
		if (name == "run_step2") { OnRunStep2(); return true; }
		if (name == "script_leap") { OnScriptLeap(); return true; }
		if (name == "set_beam") { OnSetBeam(); return true; }
		return BaseLightningShield_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
