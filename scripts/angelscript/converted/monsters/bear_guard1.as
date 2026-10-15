#pragma context server

// Converted from monsters/bear_guard1.script by msc_transpiler.
// This uses a new model, so it cannot share the old bear base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/bear_guard1"]
class BearGuard1 : BaseMonsterNewScript
{
	// Constants
	string ANIM_RUN_NORM = "bear_run";
	string ANIM_WALK_NORM = "bear_walk";
	string ANIM_HOP = "bear_pounce";
	string ANIM_IDLE_NORM = "bear_idle01";
	string ANIM_IDLE_STAND = "bear_standingidle01";
	string ANIM_CLAW_STAND = "bear_claw";
	string ANIM_CLAW_NORM = "bear_claw02";
	string ANIM_DEATH_STAND = "bear_diestanding";
	string ANIM_DEATH_NORM = "bear_die02";
	string ANIM_STANDUP = "bear_standup";
	string ANIM_STANDDOWN = "bear_standdown";
	string NPC_BASE_EXP = "200";
	int DMG_CLAW_NORM = 0;
	int DMG_CLAW_STAND = 0;
	float FREQ_HOP = 5.0f;
	float FREQ_CHECK_STAND = 1.0f;
	string FREQ_STAND = "FREQ_STAND";
	int LEAP_RANGE = 256;
	int LEAP_RANGE_MAX = 512;
	string ATTACK_HITCHANCE = "90";
	string SOUND_DEATH2 = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP_GROWL = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP = "monsters/troll/step1.wav";
	string SOUND_GETDOWN = "monsters/troll/step2.wav";
	string SOUND_UPSNARL = "monsters/bear/giantbearupsnarl.wav";
	string SOUND_ATTACK1 = "monsters/bear/cubattack.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACK3 = "none";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "monsters/bear/cubpain.wav";
	string SOUND_STRUCK5 = "none";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "bear_flinch";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	bool CHECK_STAND_DELAY = false;
	bool AM_STANDING = false;
	bool STAND_DELAY = false;
	bool LEAP_DELAY = false;
	bool AM_LEAPING = false;
	bool DID_STUN = false;

	// Variables declared by included files, with the value they start with in this script
	BearGuard1()
	{
		ANIM_WALK = "bear_walk";
		ANIM_RUN = "bear_run";
		ANIM_IDLE = "bear_idle01";
		CAN_FLINCH = "0";
		SOUND_DEATH = "monsters/bear/giantbeardeath.wav";
	}

	// unnamed block (first think)
	void BearGuard1_FirstThink()
	{
		// anims used by base
		ANIM_WALK = "bear_walk";
		ANIM_RUN = "bear_run";
		ANIM_IDLE = "bear_idle01";
		ANIM_FLINCH = "bear_flinch";
		ANIM_ATTACK = "bear_claw02";
		ANIM_DEATH = "bear_die02";

		// stats used by base
		ATTACK_MOVERANGE = 140.0f; // get this close
		ATTACK_RANGE = 150.0f; // hit when this close
		ATTACK_HITRANGE = 200.0f; // actual range of attack
		CAN_FLINCH = "0"; // bear only flinches while standing
		FLINCH_CHANCE = "25"; // chance to flinch when struck for 10% health
		FLINCH_HEALTH = 500.0f; // how low on health I must be before I will flinch
		FLINCH_DELAY = "10"; // delay between flinches
		NPC_MUST_SEE_TARGET = "0";
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
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE_NORM);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 8, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_STRUCK4, SOUND_STRUCK5);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Bear Guardian");
		SetRace("wildanimal");
		SetHealth(800);
		SetWidth(100);
		SetHeight(80);
		SetModel("monsters/bear_mean.mdl");
		SetRoam(true);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (AM_STANDING && RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
			OnBearGetdown();

		if (AM_STANDING)
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;

		if (RangeTo(NPCATK_TARGET) >= LEAP_RANGE && RangeTo(NPCATK_TARGET) <= LEAP_RANGE_MAX)
			OnBearLeap(NPCATK_TARGET);
		if (AM_LEAPING)
			return;
		if (STAND_DELAY)
			return;
		if (CHECK_STAND_DELAY)
			return;
		CHECK_STAND_DELAY = true;
		CallEventDelayed(FREQ_CHECK_STAND, "reset_check_stand_delay");
		if (RangeTo(NPCATK_TARGET) <= ATTACK_RANGE)
		{
			// dbg temp considering standing
			if (!AM_STANDING)
				OnBearGetup();
		}
	}

	// npcatk_clear_targets
	void OnNpcatkClearTargets(string reason = "")
	{
		BaseNpcAttackNew_OnNpcatkClearTargets(reason); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkClearTargets(reason); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkClearTargets_2(reason); // monsters/base_monster_shared
		OnBearGetdown();
	}

	// reset_check_stand_delay
	void OnResetCheckStandDelay()
	{
		CHECK_STAND_DELAY = false;
	}

	// bear_getup
	void OnBearGetup()
	{
		PlaySound(0, 10, SOUND_GETUP_GROWL);
		CAN_FLINCH = "0";
		ANIM_ATTACK = ANIM_CLAW_STAND;
		PlayAnim("critical", ANIM_STANDUP);
		ANIM_RUN = ANIM_IDLE_STAND;
		ANIM_WALK = ANIM_IDLE_STAND;
		ANIM_IDLE = ANIM_IDLE_STAND;
		SetMoveAnim(ANIM_IDLE_STAND);
		SetIdleAnim(ANIM_IDLE_STAND);
		NO_STUCK_CHECKS = "1"; // I cant move while standing, so turn off stuck checker
		AM_STANDING = true;
		CallEventDelayed(1.0f, "resume_flinch");
	}

	// bear_getdown
	void OnBearGetdown()
	{
		CAN_FLINCH = "0";
		ANIM_ATTACK = ANIM_CLAW_NORM;
		PlayAnim("critical", ANIM_STANDDOWN);
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE_NORM);
		AM_STANDING = false;
		CallEventDelayed(0.5f, "resume_stuck");
		STAND_DELAY = true;
		CallEventOrDelay(FREQ_STAND, "reset_stand_delay");
	}

	// reset_stand_delay
	void OnResetStandDelay()
	{
		STAND_DELAY = false;
	}

	// resume_stuck
	void OnResumeStuck()
	{
		PlaySound(0, 10, SOUND_GETDOWN);
		NO_STUCK_CHECKS = "0";
	}

	// resume_flinch
	void OnResumeFlinch()
	{
		CAN_FLINCH = "1";
	}

	// bear_leap
	// PARAM1 = target
	void OnBearLeap(string target = "")
	{
		if (LEAP_DELAY)
			return;
		LEAP_DELAY = true;
		CallEventDelayed(FREQ_HOP, "reset_leap_delay");

		NPC_FORCED_MOVEDEST = true;
		SetMoveDest(target, ATTACK_MOVERANGE);
		PlaySound(0, 10, SOUND_UPSNARL);
		PlayAnim("critical", ANIM_HOP);
		AM_LEAPING = true;
		DID_STUN = false;
		CallEventDelayed(0.1f, "bear_leap2");
		CallEventDelayed(0.5f, "bear_leap_done");
	}

	// reset_leap_delay
	void OnResetLeapDelay()
	{
		LEAP_DELAY = false;
	}

	// bear_leap_done
	void OnBearLeapDone()
	{
		AM_LEAPING = false;
	}

	// bear_leap2
	void OnBearLeap2()
	{
		OnBearLeapScan();
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 500, 100)));
	}

	// bear_leap_scan
	void OnBearLeapScan()
	{
		if (!AM_LEAPING)
			return;
		CallEventDelayed(0.1f, "bear_leap_scan");
		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE && !DID_STUN)
		{
			DID_STUN = true;
			AddVelocity(ENT_LASTSTRUCKBYME, RelativeVelocity(Vector3(0, 100, 100)));
			ApplyEffect(NPCATK_TARGET, "effects/debuff_stun", 5.0f, self);
		}
	}

	// attack_sound
	void OnAttackSound(float pitch = 0.0f)
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// standclaw_1
	// anim events
	void OnStandclaw1()
	{
		OnAttackSound();
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_CLAW_STAND), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// standclaw_2
	void OnStandclaw2()
	{
		OnAttackSound();
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_CLAW_STAND), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// crawlclaw_1
	void OnCrawlclaw1()
	{
		OnAttackSound();
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_CLAW_NORM), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqCheckStand() {} // FREQ_CHECK_STAND
	void OnFreqHop() {} // FREQ_HOP
	void OnFreqStand() {} // FREQ_STAND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bear_mean.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BearGuard1_FirstThink();
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
		if (name == "bear_getdown") { OnBearGetdown(); return true; }
		if (name == "bear_getup") { OnBearGetup(); return true; }
		if (name == "bear_leap") { OnBearLeap(Param(params, 0)); return true; }
		if (name == "bear_leap2") { OnBearLeap2(); return true; }
		if (name == "bear_leap_done") { OnBearLeapDone(); return true; }
		if (name == "bear_leap_scan") { OnBearLeapScan(); return true; }
		if (name == "crawlclaw_1") { OnCrawlclaw1(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_clear_targets") { OnNpcatkClearTargets(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "reset_check_stand_delay") { OnResetCheckStandDelay(); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		if (name == "reset_stand_delay") { OnResetStandDelay(); return true; }
		if (name == "resume_flinch") { OnResumeFlinch(); return true; }
		if (name == "resume_stuck") { OnResumeStuck(); return true; }
		if (name == "standclaw_1") { OnStandclaw1(); return true; }
		if (name == "standclaw_2") { OnStandclaw2(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
