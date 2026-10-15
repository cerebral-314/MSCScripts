#pragma context server

// Converted from monsters/croc1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/croc1"]
class Croc1 : BaseMonsterNewScript
{
	// Constants
	string ANIM_SWIM = "swim";
	string ANIM_RUN_NORMAL = "Run";
	string ANIM_CUSTOM_FLINCH = "Sflinch";
	float DMG_BITE = 300.0f;
	int FISH_VSPEED_UP = 25;
	int FISH_VSPEED_DOWN = -25;
	int FISH_VRANGE = 50;
	string SOUND_STEP1 = "monsters/gator/Gator_Footstep1.wav";
	string SOUND_STEP2 = "monsters/gator/Gator_Footstep2.wav";
	string SOUND_IDLE1 = "monsters/gator/Gator_IdleNormal_F0.wav";
	string SOUND_IDLE2 = "monsters/gator/Gator_IdleRoarLow_F0.wav";
	string SOUND_ATTACK1 = "monsters/gator/Gator_BiteAttack.wav";
	string SOUND_ATTACK2 = "monsters/gator/Gator_BiteAttack_1.wav";
	string SOUND_ATTACK3 = "monsters/gator/Gator_BiteAttack_2_f0.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	float STEP_COUNT = 0.0f;
	float HALF_HP = 0.0f;
	int DID_INTRO = 0;
	float NEXT_VICTORY = 0.0f;
	float NEXT_IDLE_SOUND = 0.0f;
	float NEXT_FLINCH = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	Croc1()
	{
		ANIM_WALK = "Walk";
		ANIM_IDLE = "idle";
		SOUND_DEATH = "monsters/Gator_DieSimple.wav";
	}

	// unnamed block (first think)
	void Croc1_FirstThink()
	{
		ANIM_RUN = "Run";
		ANIM_WALK = "Walk";
		ANIM_IDLE = "idle";

		ANIM_DEATH = "diesimple";

		ANIM_ATTACK = "biteattack"; // frame_bite
	}

	// unnamed block (first think)
	void Croc1_FirstThink2()
	{
		NPC_GIVE_EXP = 600.0f;

		MOVE_RANGE = "50";
		ATTACK_MOVERANGE = 50.0f;
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 90.0f;
	}

	// game_damaged
	string Croc1_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(HealthOf(ENT_ME) < HALF_HP))
			return result;
		if (!(GameTime() > NEXT_FLINCH))
			return result;
		NEXT_FLINCH = GameTime() + 20.0f;
		OnNpcatkSuspendRoam(2.0f);
		PlayAnim("critical", ANIM_CUSTOM_FLINCH);
		PlaySound(0, 10, "monsters/gator/Gator_Sflinch_f0.wav");
		return result;
	}

	// game_struck
	// Think monster makes a swim sound by default
	// { frame_swim
	// playrandomsound 0 5 SOUND_SWIM1 SOUND_SWIM2 SOUND_SWIM3 SOUND_SWIM4
	// }
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		PlayRandomSound(0, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Crocodile");
		SetModel("monsters/gator.mdl");
		SetWidth(32);
		SetHeight(32);
		SetRace("wildanimal");
		SetHealth(3000);
		SetDamageTaken("cold", 1.25f);
		SetRoam(true);
		SetHearingSensitivity(4);

		STEP_COUNT = 0.0f;

		CallEventDelayed(2.0f, "finalize_me");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		float zDiff = 0.0f;
		if (NPCATK_TARGET == "unset" && GameTime() > NEXT_IDLE_SOUND)
		{
			NEXT_IDLE_SOUND = GameTime() + Random(5, 15);
			PlayRandomSound(0, 10, SOUND_IDLE1);
		}

		if (NPCATK_TARGET == "unset")
			return;

		if (IsInWater(ENT_ME))
		{
			ANIM_RUN = ANIM_SWIM;
			SetMoveAnim(ANIM_RUN);

			float moveDestZ = Vec(Eval("game.monster.movedest.origin")).z;
			float myZ = OriginOf(ENT_ME).z;

			SetGravity(0);

			// borrowing bits from base_fish2, to allow vertical swimming
			if (moveDestZ > myZ && IsInWater(ENT_ME))
			{
				zDiff = moveDestZ - myZ;
				if (zDiff > FISH_VRANGE)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, FISH_VSPEED_UP)));
			}
			if (moveDestZ < myZ)
			{
				zDiff = myZ - moveDestZ;
				if (zDiff > FISH_VRANGE)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, FISH_VSPEED_DOWN)));
			}
		}
		else
		{
			SetGravity(1);
			ANIM_RUN = "Run";
			SetMoveAnim(ANIM_RUN);
		}
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		if (!(GameTime() > NEXT_VICTORY))
			return;
		OnNpcatkSuspendRoam(2.0f);
		NEXT_VICTORY = GameTime() + 20.0f;
		PlaySound(0, 10, "monsters/gator/Gator_IdleRoarLow_F0.wav");
		PlayAnim("critical", "idleroarlow");
	}

	// cycle_down
	void OnCycleDown()
	{
		BaseNpcAttackNew_OnCycleDown(); // monsters/base_npc_attack_new
		BaseMonsterShared_OnCycleDown(); // monsters/base_monster_shared
		BaseMonsterShared_OnCycleDown_2(); // monsters/base_monster_shared
		DID_INTRO = 0;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, Croc1_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (DID_INTRO != 0)
			return;
		DID_INTRO = 1;
		OnNpcatkSuspendRoam(2.0f);
		PlaySound(0, 10, "monsters/gator/Gator_SeePlayer_f0.wav");
		PlayAnim("critical", "idleroarlow");
	}

	// finalize_me
	void OnFinalizeMe()
	{
		HALF_HP = MaxHealthOf(ENT_ME) * 0.5f;
	}

	// frame_step
	void OnFrameStep()
	{
		STEP_COUNT += 1.0f;
		if (STEP_COUNT == 1.0f)
			PlaySound(0, 10, SOUND_STEP1);
		else
			PlaySound(0, 10, SOUND_STEP2);
	}

	// frame_bite
	void OnFrameBite()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "80%", "pierce");
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(0, 250, 110)));
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gator.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Croc1_FirstThink();
		Croc1_FirstThink2();
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
		if (name == "frame_bite") { OnFrameBite(); return true; }
		if (name == "frame_step") { OnFrameStep(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
