#pragma context server

// Converted from monsters/summon/bear1.script by msc_transpiler.
// This uses a new model, so it cannot share the old bear base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_summon.as"

[script "monsters/summon/bear1"]
class Bear1 : BaseSummonScript
{
	// Constants
	int STAT_HP_MAX = 12000;
	int STAT_DMG_MAX = 400;
	bool SUMMON_UNIQUE = true;
	string SUMMON_UNIQUE_TAG = "bear1";
	bool SUM_NO_TALK = true;
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
	float DMG_CLAW_NORM_ADJ = 1.1f;
	float DMG_CLAW_STAND_ADJ = 0.8f;
	string NPC_BASE_EXP = "0";
	float FREQ_HOP = 5.0f;
	float FREQ_CHECK_STAND = 1.0f;
	string FREQ_STAND = "FREQ_STAND";
	int LEAP_RANGE = 256;
	int LEAP_RANGE_MAX = 512;
	string ATTACK_HITCHANCE = "90";
	string SOUND_SUMMON_ACKNOWLEDGE1 = "monsters/bear/c_bear_yes.wav";
	string SOUND_SUMMON_ACKNOWLEDGE2 = "monsters/bear/c_bear_no.wav";
	string SOUND_SUMMON_ACKNOWLEDGE3 = "monsters/bear/c_bear_slct.wav";
	string SOUND_DISAPOINT = "monsters/bear/c_bear_no.wav";
	string SOUND_DEATH2 = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP_GROWL = "monsters/bear/giantbeardeath2.wav";
	string SOUND_GETUP = "monsters/troll/step1.wav";
	string SOUND_GETDOWN = "monsters/troll/step2.wav";
	string SOUND_UPSNARL = "monsters/bear/giantbearupsnarl.wav";
	string SOUND_ATTACK1 = "monsters/bear/cubattack.wav";
	string SOUND_ATTACK2 = "zombie/claw_miss2.wav";
	string SOUND_ATTACK3 = "none";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_STRUCK4 = "monsters/bear/cubpain.wav";
	string SOUND_STRUCK5 = "none";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_FLINCH = "bear_flinch";
	float PLR_FRUSTRATED = 0.0f;
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float NEXT_STAND_CHECK = 0.0f;
	bool AM_STANDING = false;
	bool LEAP_DELAY = false;
	bool AM_LEAPING = false;
	bool DID_STUN = false;
	float OWNER_SKILL = 0.0f;
	float DMG_BASE = 0.0f;
	float HP_BASE = 0.0f;
	float SUMMON_DMG_BASE = 0.0f;
	string LAST_TIME_PLR_STRUCK = "LAST_TIME_PLR_STRUCK";

	// Variables declared by included files, with the value they start with in this script
	Bear1()
	{
		ANIM_WALK_BASE = "bear_walk";
		ANIM_RUN_BASE = "bear_run";
		HOVER_FAR = 138;
		HOVER_CLOSE = 138;
		SUMMON_CIRCLE_INDEX = 13;
		ANIM_WALK = "bear_walk";
		ANIM_RUN = "bear_run";
		ANIM_IDLE = "bear_idle01";
		CAN_FLINCH = "0";
		SOUND_DEATH = "monsters/bear/giantbeardeath.wav";
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	}

	// unnamed block (first think)
	void Bear1_FirstThink()
	{
		// ==================
		// these were added for summon, but not required
		// (keeping this up here for quick reading, though it should likely be in next section)
		PLR_FRUSTRATED = 0.0f; // anti-troll (blocking newbs)

		// also added summon_acknowledge and some minor script alterations for scaling damage with master's skill
		// ==================
		// anims used by base
		ANIM_WALK = "bear_walk";
		ANIM_RUN = "bear_run";
		ANIM_IDLE = "bear_idle01";
		ANIM_FLINCH = "bear_flinch";
		ANIM_ATTACK = "bear_claw02";
		ANIM_DEATH = "bear_die02";
	}

	// unnamed block (first think)
	void Bear1_FirstThink2()
	{
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

	// game_damaged
	// Some anti-troll stuff, as this guy can block hallways, and is not so easily slain
	string Bear1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool exitSub = false;
		string result = "";
		if (NPCATK_TARGET != "unset")
			return result;
		if (!IsPlayer(attacker))
			return result;
		if (!(RangeTo(attacker) < 128.0f))
			return result;
		SetMoveDest(@attacker, 256, "flee");
		CallEventDelayed(0.1f, "run_anim");
		PlayRandomSound(0, 10, SOUND_SUMMON_ACKNOWLEDGE1, SOUND_SUMMON_ACKNOWLEDGE2, SOUND_SUMMON_ACKNOWLEDGE3);

		if (EntityId(attacker) == SUMMON_MASTER)
			return result;

		if (LAST_TIME_PLR_STRUCK == "LAST_TIME_PLR_STRUCK")
		{
			LAST_TIME_PLR_STRUCK = Text(GameTime());
			exitSub = true;
		}
		if (exitSub)
			return result;

		float fiveSecsAgo = GameTime() - 10.0f;

		DebugPrint("anti-troll " + Text(fiveSecsAgo) + " vs. " + LAST_TIME_PLR_STRUCK);

		if (Float(LAST_TIME_PLR_STRUCK) < fiveSecsAgo)
		{
			PLR_FRUSTRATED = 0.0f;
			DebugPrint("anti-troll reset frustration");
		}
		if (!(Float(LAST_TIME_PLR_STRUCK) > fiveSecsAgo))
			return result;
		LAST_TIME_PLR_STRUCK = Text(GameTime());
		PLR_FRUSTRATED += 1.0f;

		DebugPrint("anti-troll " + Text(PLR_FRUSTRATED));

		if (!(PLR_FRUSTRATED > 4.0f))
			return result;
		PlayerMessageGreen(attacker, "You dismiss " + FullNameOf(ENT_ME));
		OnKillme();
		return result;
	}

	// game_death
	// summons vanish on death, so this isn't playing
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (AM_STANDING)
			ANIM_DEATH = "bear_diestanding";
		else
			ANIM_DEATH = "bear_die01";
		PlayAnim("critical", ANIM_DEATH);
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
		BaseSummon_OnNpcSpawn(npc); // monsters/summon/base_summon
		SetName("Bear Guardian");
		SetRace("human");
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("once", ANIM_IDLE);
		SetHealth(800);
		SetModel("monsters/giant_rat.mdl");
		SetModelBody(0, 5);
		SetRoam(false);
		SetProp(ENT_ME, "scale", 1.75f);
		SetWidth(100);
		SetHeight(80);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseSummon_OnNpcatkHunt(); // monsters/summon/base_summon

		if (NPCATK_TARGET == "unset" && AM_STANDING && GameTime() > NEXT_STAND_CHECK)
		{
			NEXT_STAND_CHECK = GameTime() + FREQ_CHECK_STAND;
			OnBearGetdown();
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (NPCATK_TARGET == SUMMON_MASTER)
			return;

		if (AM_STANDING && RangeTo(NPCATK_TARGET) > ATTACK_RANGE && GameTime() > NEXT_STAND_CHECK)
		{
			NEXT_STAND_CHECK = GameTime() + FREQ_CHECK_STAND;
			OnBearGetdown();
		}

		if (AM_STANDING)
			return;

		if (RangeTo(NPCATK_TARGET) >= LEAP_RANGE && RangeTo(NPCATK_TARGET) <= LEAP_RANGE_MAX)
			OnBearLeap(NPCATK_TARGET);
		if (AM_LEAPING)
			return;

		if (!(GameTime() > NEXT_STAND_CHECK))
			return;
		NEXT_STAND_CHECK = GameTime() + FREQ_CHECK_STAND;
		if (RangeTo(NPCATK_TARGET) <= ATTACK_RANGE && !AM_STANDING)
		{
			// check headroom
			Vector3 traceStart = OriginOf(ENT_ME);
			string traceEnd = Text(traceStart);
			traceEnd = Text(Vec(traceEnd) + Vector3(0.0f, 0.0f, 256.0f));
			string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
			DebugPrint("getup_test " + Text(Distance(traceStart, Vec(traceEnd))));
			if (Distance(traceStart, Vec(traceLine)) > 128.0f)
				OnBearGetup();
		}
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Bear1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// summon_summoned
	void OnSummonSummoned(string value = "", float lifetime = 0.0f, string minAttack = "")
	{
		BaseSummon_OnSummonSummoned(value, lifetime, minAttack); // monsters/summon/base_summon
		OWNER_SKILL = SkillOf(SUMMON_MASTER, "spellcasting") * 0.01f;
		DebugPrint("summon_summoned " + Text(OWNER_SKILL));
		DMG_BASE = Ratio(OWNER_SKILL, 1, STAT_DMG_MAX);
		HP_BASE = Ratio(OWNER_SKILL, 1, STAT_HP_MAX);
		SUMMON_DMG_BASE = DMG_BASE;
		SetHealth(HP_BASE);
	}

	// bear_getup
	void OnBearGetup()
	{
		DebugPrint("bear_getup");
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
		DebugPrint("bear_getdown");
		CAN_FLINCH = "0";
		AM_STANDING = false;
		ANIM_ATTACK = ANIM_CLAW_NORM;
		PlayAnim("critical", ANIM_STANDDOWN);
		ANIM_RUN = ANIM_RUN_NORM;
		ANIM_WALK = ANIM_WALK_NORM;
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE_NORM);
		AM_STANDING = false;
		CallEventDelayed(0.5f, "resume_stuck");
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
		float dmg = DMG_BASE * DMG_CLAW_NORM_ADJ;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(dmg), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// standclaw_2
	void OnStandclaw2()
	{
		OnAttackSound();
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		float dmg = DMG_BASE * DMG_CLAW_STAND_ADJ;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(dmg), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// crawlclaw_1
	void OnCrawlclaw1()
	{
		OnAttackSound();
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		float dmg = DMG_BASE * DMG_CLAW_NORM_ADJ;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(dmg), ATTACK_HITCHANCE, EntityId(self), "slash");
	}

	// summon_acknowledge
	// <follow|hunt|stay|defend|attack|report>
	void OnSummonAcknowledge(string command = "")
	{
		bool amDisapoint = false;

		if (command == "stay")
			amDisapoint = true;
		if (command == "follow")
			amDisapoint = true;

		if (command == "report")
		{
			int meStrength = int(SUMMON_DMG_BASE);
			ME_STREGTH += "/strike";

			int meHealth = int(MyHealth());
			int meMaxHealth = int(MyMaxHealth());
			string healthString = Text(meHealth) + "/" + meMaxHealth;

			SetSayTextRange(1024);
			SayText("Health: " + healthString + " Attack: " + meStrength);
		}

		if (amDisapoint)
			PlaySound(0, 10, SOUND_DISAPOINT);
		else
			PlayRandomSound(0, 10, SOUND_SUMMON_ACKNOWLEDGE1, SOUND_SUMMON_ACKNOWLEDGE2, SOUND_SUMMON_ACKNOWLEDGE3);
	}

	// run_anim
	void OnRunAnim()
	{
		PlayAnim("once", ANIM_RUN_BASE);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqHop() {} // FREQ_HOP

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("xflare1.spr");
		Precache("monsters/giant_rat.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Bear1_FirstThink();
		Bear1_FirstThink2();
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
		if (name == "attack_sound") { OnAttackSound(Float(Param(params, 0))); return true; }
		if (name == "bear_getdown") { OnBearGetdown(); return true; }
		if (name == "bear_getup") { OnBearGetup(); return true; }
		if (name == "bear_leap") { OnBearLeap(Param(params, 0)); return true; }
		if (name == "bear_leap2") { OnBearLeap2(); return true; }
		if (name == "bear_leap_done") { OnBearLeapDone(); return true; }
		if (name == "bear_leap_scan") { OnBearLeapScan(); return true; }
		if (name == "crawlclaw_1") { OnCrawlclaw1(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "reset_leap_delay") { OnResetLeapDelay(); return true; }
		if (name == "resume_flinch") { OnResumeFlinch(); return true; }
		if (name == "resume_stuck") { OnResumeStuck(); return true; }
		if (name == "run_anim") { OnRunAnim(); return true; }
		if (name == "standclaw_1") { OnStandclaw1(); return true; }
		if (name == "standclaw_2") { OnStandclaw2(); return true; }
		if (name == "summon_acknowledge") { OnSummonAcknowledge(Param(params, 0)); return true; }
		if (name == "summon_summoned") { OnSummonSummoned(Param(params, 0), Float(Param(params, 1)), Param(params, 2)); return true; }
		return BaseSummonScript::DispatchEvent(name, params);
	}
}
