#pragma context server

// Converted from monsters/k_larva.script by msc_transpiler.
// Kharaztorant Larva by Thothie, from scratch (some bits from childre)
// one of the evolutions of the Kharaztorant dragonkin

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class KLarva
{
	// Constants
	string ANIM_IDLE1 = "idle1";
	string ANIM_IDLE2 = "idle2";
	string ANIM_SEARCH = "idle1";
	string ANIM_LICK = "attack1";
	string ANIM_CLAW1 = "attack2";
	string ANIM_CLAW2 = "attack3";
	string ANIM_RUN_FAST = "runshort";
	string ANIM_RUN_NORM = "runlong";
	string ANIM_VICTORY = "victoryeat1";
	string ANIM_VICTORY_LOOP = "eat_loop";
	int DMG_LICK = 0;
	int DMG_CLAW1 = 0;
	int DMG_CLAW2 = 0;
	float FREQ_IDLE = 0.0f;
	int CHANCE_LICK_STUN = 50;
	float FREQ_LOOK = 10.0f;
	string SOUND_LICK_HIT = "barnacle/bcl_tongue1.wav";
	string SOUND_WARCRY = "barnacle/bcl_alert2.wav";
	string SOUND_MISS1 = "zombie/claw_miss1.wav";
	string SOUND_MISS2 = "zombie/claw_miss2.wav";
	string SOUND_CLAW_HIT1 = "zombie/claw_strike1.wav";
	string SOUND_CLAW_HIT2 = "zombie/claw_strike2.wav";
	string SOUND_IDLE1 = "bullchicken/bc_idle1.wav";
	string SOUND_IDLE2 = "bullchicken/bc_idle3.wav";
	string SOUND_IDLE3 = "bullchicken/bc_idle4.wav";
	string SOUND_IDLE4 = "bullchicken/bc_idle5.wav";
	string SOUND_IDLE5 = "houndeye/he_die2.wav";
	string SOUND_IDLE6 = "houndeye/he_die3.wav";
	string SOUND_SEARCH1 = "bullchicken/bc_die3.wav";
	string SOUND_SEARCH2 = "houndeye/he_alert2.wav";
	string SOUND_EAT = "monsters/gonome/gonome_eat.wav";
	string SOUND_CRAWL1 = "barnacle/bcl_chew1.wav";
	string SOUND_CRAWL2 = "barnacle/bcl_chew2.wav";
	string SOUND_ANGRY1 = "agrunt/ag_alert2.wav";
	string SOUND_ANGRY2 = "agrunt/ag_alert3.wav";
	string SOUND_ANGRY3 = "agrunt/ag_alert4.wav";
	string SOUND_STRUCK1 = "debris/flesh1.wav";
	string SOUND_STRUCK2 = "debris/flesh2.wav";
	string SOUND_GETUP = "bullchicken/bc_pain4.wav";
	string SOUND_DEATH = "agrunt/ag_die2.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_WALK = "walk";
	string ANIM_RUN = "runlong";
	string ANIM_IDLE = "idle1";
	string ANIM_FLINCH = "flinch";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string ANIM_DEATH = "ANIM_DEATH";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	string CAN_FLINCH = "CAN_FLINCH";
	string FLINCH_CHANCE = "FLINCH_CHANCE";
	float FLINCH_HEALTH = 0.0f;
	float FLINCH_DAMAGE_THRESHOLD = 0.0f;
	string FLINCH_DELAY = "FLINCH_DELAY";
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	float SEARCH_DELAY = 0.0f;
	float AS_ATTACKING = 0.0f;
	bool AM_EATING = false;
	bool DID_WARCRY = false;
	string ATTACK_TYPE = "ATTACK_TYPE";

	// unnamed block (first think)
	void KLarva_FirstThink()
	{
		IS_UNHOLY = true;

		// anims used by base
		ANIM_WALK = "walk";
		ANIM_RUN = "runlong";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1"; // attack_lick
		ANIM_DEATH = "diesimple";
		ANIM_FLINCH = "flinch";

		// stats used by base
		ATTACK_RANGE = 60.0f;
		ATTACK_HITRANGE = 120.0f;
		ATTACK_MOVERANGE = 50.0f;
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(10, 20);
		NPC_GIVE_EXP = 150.0f;
		CAN_FLINCH = "1";
		FLINCH_CHANCE = "90";
		FLINCH_HEALTH = 600.0f;
		FLINCH_DAMAGE_THRESHOLD = 30.0f;
		FLINCH_DELAY = "30.0";

		// custom stats
		ATTACK_HITCHANCE = "80";
	}

	// npc_spawn
	void KLarva_OnNpcSpawn(string npc = "")
	{
		OnLarvaSpawn();
	}

	// larva_spawn
	void KLarva_OnLarvaSpawn()
	{
		SetName("Kharaztorant Larva");
		SetModel("monsters/k_larva.mdl");
		SetHealth(800);
		SetRace("demon");
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHearingSensitivity(6);
	}

	// npc_post_spawn
	void KLarva_OnNpcPostSpawn()
	{
		SetDamageTaken("holy", 1);
		SetDamageTaken("fire", 0.5f);
		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);
	}

	// npcatk_lost_sight
	void KLarva_OnNpcatkLostSight()
	{
		if (CanSee("enemy"))
			return;
		PlayRandomSound(0, 10, SOUND_SEARCH1, SOUND_SEARCH2);
		if (int(SEARCH_DELAY) == 0)
		{
			SEARCH_DELAY = 1.0f;
			CallEventDelayed(FREQ_LOOK, "reset_search_delay");
			PlayAnim("once", ANIM_SEARCH);
		}
		AS_ATTACKING = GameTime();
	}

	// reset_search_delay
	void KLarva_OnResetSearchDelay()
	{
		SEARCH_DELAY = 0.0f;
	}

	// my_target_died
	void KLarva_OnMyTargetDied(string offender = "")
	{
		PlayAnim("critical", ANIM_VICTORY);
		PlaySound(0, 10, SOUND_EAT);
		SetRoam(false);
		SetIdleAnim(ANIM_VICTORY_LOOP);
		SetMoveAnim(ANIM_VICTORY_LOOP);
		AM_EATING = true;
	}

	// game_struck
	void KLarva_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_STRUCK1, SOUND_STRUCK2);
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		AM_EATING = false;
	}

	// npc_targetsighted
	void KLarva_OnNpcTargetsighted(string target = "")
	{
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		AM_EATING = false;

		if (DID_WARCRY)
			return;
		DID_WARCRY = true;
		PlaySound(0, 10, SOUND_WARCRY);
		PlayAnim("critical", ANIM_IDLE2);
		AS_ATTACKING = GameTime();
	}

	// unnamed block (timer)
	void KLarva_Timer()
	{
		CallEventDelayed(FREQ_IDLE, "KLarva_Timer");

		if (NPCATK_TARGET != "unset")
			PlayRandomSound(0, 10, SOUND_ANGRY1, SOUND_ANGRY2, SOUND_ANGRY3);

		if (NPCATK_TARGET != "unset")
			return;

		if (AM_EATING)
		{
			if (MyHealth() < MyMaxHealth())
				GiveHealth(100);
			PlaySound(0, 10, SOUND_EAT);
		}

		if (AM_EATING)
			return;
		PlayRandomSound(0, 10, SOUND_IDLE1, SOUND_IDLE2, SOUND_IDLE3, SOUND_IDLE4, SOUND_IDLE5, SOUND_IDLE6);
		int rndIdle = RandomInt(1, 2);
		if (rndIdle == 1)
			PlayAnim("critical", ANIM_IDLE1);
		if (rndIdle == 2)
			PlayAnim("critical", ANIM_IDLE2);
	}

	// npc_selectattack
	void KLarva_OnNpcSelectattack()
	{
		int rndAtk = RandomInt(1, 6);
		if (rndAtk <= 2)
			ANIM_ATTACK = ANIM_CLAW1;
		if (rndAtk > 3)
			ANIM_ATTACK = ANIM_CLAW2;
		if (rndAtk == 6)
			ANIM_ATTACK = ANIM_LICK;
	}

	// crawl_step
	// ============= model events - BEGIN
	void KLarva_OnCrawlStep()
	{
		PlayRandomSound(0, 8, SOUND_CRAWL1, SOUND_CRAWL2);
	}

	// attack_lick
	void KLarva_OnAttackLick()
	{
		ATTACK_TYPE = "attack_lick"; // heavy stun
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_LICK), ATTACK_HITCHANCE, "blunt");
		ANIM_ATTACK = ANIM_CLAW1;
	}

	// attack_claw1
	void KLarva_OnAttackClaw1()
	{
		ATTACK_TYPE = "attack_claw1";
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_CLAW1), ATTACK_HITCHANCE, "blunt");
	}

	// attack_claw2
	void KLarva_OnAttackClaw2()
	{
		ATTACK_TYPE = "attack_claw2";
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), Text(DMG_CLAW2), ATTACK_HITCHANCE, "blunt");
		ANIM_ATTACK = ANIM_CLAW1;
	}

	// game_dodamage
	// ============= model events - END
	string KLarva_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		if (!hit)
			PlayRandomSound(0, 10, SOUND_MISS1, SOUND_MISS2);

		if (ATTACK_TYPE == "attack_claw1" && hit)
			PlayRandomSound(0, 10, SOUND_CLAW_HIT1, SOUND_CLAW_HIT2);

		if (ATTACK_TYPE == "attack_lick" && hit)
		{
			PlaySound(0, 10, SOUND_LICK_HIT);
			if (RandomInt(1, 100) < CHANCE_LICK_STUN)
			{
				// poison, stun only
				AddVelocity(target, RelativeVelocity(Vector3(-200, -10, 10)));
				DebugPrint("temp apply stun");
				ApplyEffect(target, "effects/dot_poison", Random(3, 5), self, 0);
			}
		}

		if (ATTACK_TYPE == "attack_claw2" && hit)
		{
			AddVelocity(target, RelativeVelocity(Vector3(-400, -100, 50)));
			PlayRandomSound(0, 10, SOUND_CLAW_HIT1, SOUND_CLAW_HIT2);
		}

		ATTACK_TYPE = "none";
		return result;
	}

	// npc_flinch
	void KLarva_OnNpcFlinch(float damage = 0.0f)
	{
		PlaySound(0, 10, SOUND_DEATH);
		// the fake death in this one is part of the flinch animation
		CallEventDelayed(1.0f, "snap_to");
	}

	// snap_to
	void KLarva_OnSnapTo()
	{
		PlaySound(0, 10, SOUND_GETUP);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		KLarva_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		KLarva_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		KLarva_OnNpcSpawn(npc);
	}

	// npcatk_lost_sight
	void OnNpcatkLostSight()
	{
		BaseNpcAttackNew_OnNpcatkLostSight(); // monsters/base_npc_attack_new
		KLarva_OnNpcatkLostSight();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		KLarva_OnMyTargetDied(offender);
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, KLarva_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
		KLarva_OnNpcSelectattack();
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		KLarva_OnNpcTargetsighted(target);
	}

	void OnLarvaSpawn() { KLarva_OnLarvaSpawn(); } // larva_spawn
	void OnResetSearchDelay() { KLarva_OnResetSearchDelay(); } // reset_search_delay
	void OnCrawlStep() { KLarva_OnCrawlStep(); } // crawl_step
	void OnAttackLick() { KLarva_OnAttackLick(); } // attack_lick
	void OnAttackClaw1() { KLarva_OnAttackClaw1(); } // attack_claw1
	void OnAttackClaw2() { KLarva_OnAttackClaw2(); } // attack_claw2
	void OnNpcFlinch(float damage = 0.0f) { KLarva_OnNpcFlinch(damage); } // npc_flinch
	void OnSnapTo() { KLarva_OnSnapTo(); } // snap_to
	void OnFreqLook() {} // FREQ_LOOK

	// This file's events and timers by their .script names
	bool KLarva_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_claw1") { OnAttackClaw1(); return true; }
		if (name == "attack_claw2") { OnAttackClaw2(); return true; }
		if (name == "attack_lick") { OnAttackLick(); return true; }
		if (name == "crawl_step") { OnCrawlStep(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "larva_spawn") { OnLarvaSpawn(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_selectattack") { OnNpcSelectattack(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_lost_sight") { OnNpcatkLostSight(); return true; }
		if (name == "reset_search_delay") { OnResetSearchDelay(); return true; }
		if (name == "snap_to") { OnSnapTo(); return true; }
		if (name == "KLarva_Timer") { KLarva_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/k_larva"]
shared class KLarvaScript : BaseMonsterNewScript, KLarva
{
	// Variables every script that includes this file declares
	bool AM_BARFING = false;
	string ANIM_BARF = "ANIM_BARF";
	int BARF_BONE = 0;
	int BARF_DUR = 0;
	string BARF_TARGETS = "BARF_TARGETS";
	string CL_SCRIPT = "CL_SCRIPT";
	int DOT_BARF = 0;
	float FREQ_BARF = 0.0f;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	string SOUND_BARF = "SOUND_BARF";
	bool STARTED_CYCLES = false;

	// Variables declared by included files, with the value they start with in this script
	KLarvaScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "runlong";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "agrunt/ag_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/k_larva.mdl");
		CallEventDelayed(FREQ_IDLE, "KLarva_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		KLarva_FirstThink();
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
		return KLarva_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
