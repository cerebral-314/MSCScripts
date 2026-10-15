#pragma context server

// Converted from monsters/swamp_vile.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/swamp_vile"]
class SwampVile : BaseMonsterNewScript
{
	// Constants
	string ANIM_POINT = "point";
	string ANIM_RALLY = "rally";
	string ANIM_RAWR = "idle_scream";
	string ANIM_ATTACK1 = "melee1";
	string ANIM_ATTACK2 = "melee1b";
	string ANIM_ATTACK3 = "melee2";
	string ANIM_THROW = "throw_rock";
	string ANIM_CUST_FLINCH = "duck";
	float DMG_SLASH = 400.0f;
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN1 = "monsters/keeper/c_troll_hit1.wav";
	string SOUND_PAIN2 = "monsters/keeper/c_troll_hit2.wav";
	string SOUND_ALERT1 = "monsters/keeper/c_troll_bat1.wav";
	string SOUND_ALERT2 = "monsters/keeper/c_troll_bat2.wav";
	string SOUND_ALERT3 = "monsters/keeper/c_troll_bat2_rev.wav";
	string SOUND_ATTACK1 = "monsters/keeper/c_lizardm_atk1.wav";
	string SOUND_ATTACK2 = "monsters/keeper/c_lizardm_atk2.wav";
	string SOUND_ATTACK3 = "monsters/keeper/c_lizardm_atk3.wav";
	string SOUND_SWING1 = "zombie/claw_miss1.wav";
	string SOUND_SWING2 = "zombie/claw_miss2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	float FREQ_THROW = 0.0f;
	string GLOB_EFFECT_TYPE = "GLOB_EFFECT_TYPE";
	int GLOB_EFFECT_DOT = 0;
	float GLOB_EFFECT_DUR = 0.0f;
	float HALF_HP = 0.0f;
	bool DID_ALERT = false;
	float NEXT_THROW = 0.0f;
	float NEXT_HEARD_ALERT = 0.0f;
	float NEXT_FLINCH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	SwampVile()
	{
		ANIM_WALK = "walk_lx";
		ANIM_IDLE = "idle_base";
		SOUND_DEATH = "monsters/keeper/c_troll_dead.wav";
	}

	// unnamed block (first think)
	void SwampVile_FirstThink()
	{
		ANIM_WALK = "walk_lx";
		ANIM_IDLE = "idle_base";
		ANIM_RUN = "run_kx";
		ANIM_ATTACK = "melee1";

		ANIM_DEATH = "death"; // needs a death anim! :O
	}

	// unnamed block (first think)
	void SwampVile_FirstThink2()
	{
		NPC_BASE_EXP = "2000";

		FREQ_THROW = 5.0f;

		ATTACK_MOVERANGE = 40.0f;
		MOVE_RANGE = "40";
		ATTACK_RANGE = 50.0f;
		ATTACK_HITRANGE = 70.0f;

		GLOB_EFFECT_TYPE = "effects/dot_poison_blind";
		GLOB_EFFECT_DOT = 150;
		GLOB_EFFECT_DUR = 3.0f;
	}

	// game_damaged
	string SwampVile_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(HealthOf(ENT_ME) < HALF_HP))
			return result;
		if (!(GameTime() > NEXT_FLINCH))
			return result;
		NEXT_FLINCH = GameTime() + 20.0f;
		OnNpcatkSuspendAi("1.0");
		PlaySound(0, 10, SOUND_PAIN1, SOUND_PAIN2);
		PlayAnim("critical", ANIM_CUST_FLINCH);
		return result;
	}

	// set_npc_turret
	void OnSetNpcTurret()
	{
		MonstersExternals_OnSetNpcTurret(); // monsters/externals
		FREQ_THROW = 2.0f; // turret variant throws faster, but pauses to taunt occasionally
		CallEventDelayed(Random(10, 15), "taunt_loop");
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Swamp Keeper");

		SetModel("monsters/keeper.mdl");
		SetHeight(64);
		SetWidth(32);
		SetRoam(true);
		SetHealth(5000);
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0.5f);
		SetRace("demon");

		SetMoveAnim(ANIM_WALK);
		SetIdleAnim(ANIM_IDLE);

		CallEventDelayed(2.0f, "finalize_me");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck

		if (NPCATK_TARGET == "unset")
			return;

		float targRange = RangeTo(NPCATK_TARGET);

		if (targRange > ATTACK_HITRANGE && GameTime() > NEXT_THROW)
		{
			NEXT_THROW = GameTime() + FREQ_THROW;
			OnNpcatkSuspendRoam(2.0f);
			PlayAnim("once", ANIM_THROW);
		}

		if (targRange < ATTACK_RANGE)
		{
			if (targRange < ATTACK_MOVERANGE)
			{
				ANIM_ATTACK = ANIM_ATTACK3; // double slash when very close
			}
			else
			{
				int rndAtk = RandomInt(1, 2);
				if (rndAtk == 1)
					ANIM_ATTACK = ANIM_ATTACK1;
				if (rndAtk == 2)
					ANIM_ATTACK = ANIM_ATTACK2;
			}
		}
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_ALERT = false;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, SwampVile_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		if (DID_ALERT)
			return;
		OnNpcatkSuspendRoam(2.0f);
		SetMoveDest(NPCATK_TARGET, 9999);
		DID_ALERT = true;

		LegacyCommand("add", "G_ALERT_CYCLE", 1);

		if (!NPC_IS_TURRET)
			NEXT_THROW = GameTime() + FREQ_THROW;

		if (Float(GetVar("G_ALERT_CYCLE")) == 1.0f)
		{
			PlayAnim("critical", ANIM_POINT);
			PlaySound(0, 10, SOUND_ALERT2);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 2.0f)
		{
			PlayAnim("critical", ANIM_RALLY);
			PlaySound(0, 10, SOUND_ALERT1);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 3.0f)
		{
			PlayAnim("critical", ANIM_RAWR);
			PlaySound(0, 10, SOUND_ALERT3);
		}

		if (Float(GetVar("G_ALERT_CYCLE")) == 3.0f)
			SetGlobal("G_ALERT_CYCLE", 0);
	}

	// finalize_me
	// give time for any map side HP adjusts
	void OnFinalizeMe()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// npc_heard_player
	void OnNpcHeardPlayer()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (!(GameTime() > NEXT_HEARD_ALERT))
			return;
		NEXT_HEARD_ALERT = GameTime() + 15.0f;
		PlaySound(0, 10, "monsters/keeper/c_troll_slct.wav");
	}

	// frame_melee_start
	void OnFrameMeleeStart()
	{
		PlayRandomSound(1, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// frame_melee1_strike
	void OnFrameMelee1Strike()
	{
		PlayRandomSound(2, 10, SOUND_SWING1, SOUND_SWING2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SLASH, "80%", "slash");
	}

	// frame_melee2_strike
	void OnFrameMelee2Strike()
	{
		PlayRandomSound(2, 10, SOUND_SWING1, SOUND_SWING2);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_SLASH, "80%", "slash");
	}

	// taunt_loop
	void OnTauntLoop()
	{
		DID_ALERT = false;
		CallEventDelayed(Random(10, 15), "taunt_loop");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/keeper.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SwampVile_FirstThink();
		SwampVile_FirstThink2();
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
		if (name == "cycle_down") { OnCycleDown(); return true; }
		if (name == "finalize_me") { OnFinalizeMe(); return true; }
		if (name == "frame_melee1_strike") { OnFrameMelee1Strike(); return true; }
		if (name == "frame_melee2_strike") { OnFrameMelee2Strike(); return true; }
		if (name == "frame_melee_start") { OnFrameMeleeStart(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_heard_player") { OnNpcHeardPlayer(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_npc_turret") { OnSetNpcTurret(); return true; }
		if (name == "taunt_loop") { OnTauntLoop(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
