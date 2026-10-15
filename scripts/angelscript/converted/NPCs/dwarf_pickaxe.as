#pragma context server

// Converted from NPCs/dwarf_pickaxe.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_battle_ally.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_struck.as"
#include "converted/NPCs/dwarf_lantern_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class DwarfPickaxe
{
	// Constants
	string ANIM_ALLY_JUMP = "anim_roll_back";
	string SOUND_ALLY_JUMP = "voices/dwarf/vs_nx0drogm_hit2.wav";
	int ALLY_MOVE_AWAY_DIST = 128;
	string NPC_MATERIAL_TYPE = "flesh";
	bool NPC_USE_PAIN = true;
	bool NPC_USE_IDLE = false;
	bool NPC_USE_FLINCH = true;
	string SOUND_PAIN1 = "voices/dwarf/vs_ndwarfm1_hit1.wav";
	string SOUND_PAIN2 = "voices/dwarf/vs_ndwarfm1_bat1.wav";
	string SOUND_PAIN3 = "voices/dwarf/vs_ndwarfm1_hit3.wav";
	string SOUND_FLINCH1 = "voices/dwarf/vs_nx0drogm_heal.wav";
	string SOUND_FLINCH2 = "voices/dwarf/vs_nx0drogm_help.wav";
	string SOUND_FLINCH3 = "voices/dwarf/vs_nx0drogm_hit1.wav";
	string SOUND_DEATH = "voices/dwarf/vs_nx0drogm_hit3.wav";
	string SOUND_ALERT1 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat3.wav";
	string SOUND_ALERT2 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat1.wav";
	string SOUND_ALERT3 = "voices/dwarf/voices/dwarf/vs_ndwarfm1_bat3.wav";
	string SOUND_ATTACK1 = "voices/dwarf/voices/dwarf/vs_nx0drogm_atk1.wav";
	string SOUND_ATTACK2 = "voices/dwarf/voices/dwarf/vs_nx0drogm_atk2.wav";
	string ANIM_FLINCH = "anim_xbow_flinch";
	string NPC_BASE_EXP = "0";
	string ATTACK_ACCURACY = "80";
	string ATTACK2_ACCURACY = "90";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "idle";
	string ANIM_WALK = "walk";
	string ANIM_RUN = "run";
	bool ALLY_FOLLOW_ON = false;
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_NO_PLAYER_DMG = false;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string ATTACK_DAMAGE = "ATTACK_DAMAGE";
	string ATTACK2_DAMAGE = "ATTACK2_DAMAGE";
	int ATTACK2_CHANCE = 0;

	// unnamed block (first think)
	void DwarfPickaxe_FirstThink()
	{
		// base ally
		ALLY_FOLLOW_ON = false;

		// base anims
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_DEATH = "death";
		ANIM_ATTACK = "attack"; // alternates between leap and slash
		NPC_NO_PLAYER_DMG = true;
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 100.0f;
		ATTACK_MOVERANGE = 48.0f;

		// top
		ATTACK_DAMAGE = "50";
		ATTACK2_DAMAGE = "150";
		ATTACK2_CHANCE = 30;
	}

	// game_spawn
	void DwarfPickaxe_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OnDwarfSpawn();
	}

	// dwarf_spawn
	void DwarfPickaxe_OnDwarfSpawn()
	{
		SetName("Dwarven Miner");
		SetModel("dwarf/male1.mdl");
		SetProp(ENT_ME, "skin", RandomInt(0, 6));
		SetModelBody(1, 8);
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(400);
		SetRace("human");
		SetHearingSensitivity(8);
	}

	// frame_roll_back_push
	void DwarfPickaxe_OnFrameRollBackPush()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 100, 0)));
	}

	// attack_1
	// called by modelanim attack @frame 6
	void DwarfPickaxe_OnAttack12()
	{
		// copypasta lazyness from dzomb
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK_DAMAGE, ATTACK_ACCURACY);
		if (RandomInt(1, 100) < ATTACK2_CHANCE)
			ANIM_ATTACK = "attack2";
	}

	// attack_2
	// called by modelanim attack2 @frame 9
	void DwarfPickaxe_OnAttack22()
	{
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, "SOUND_ATTACK3");

		// copypasta lazyness from dzomb
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, ATTACK2_DAMAGE, ATTACK2_ACCURACY);
		ANIM_ATTACK = "attack";
		if (!(RangeTo(ENT_LASTSTRUCKBYME) <= ATTACK_HITRANGE))
			return;
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/debuff_stun", RandomInt(2, 8), self);
		ApplyEffect(EntityOf(ENT_LASTSTRUCKBYME), "effects/effect_push", 2, RelativeVelocity(Vector3(10, -200, 10)), 0);
	}

	// set_leader
	void DwarfPickaxe_OnSetLeader(int isLeader = 0)
	{
		if (isLeader != 0)
		{
			// speed up to stay in front
			SetMoveSpeed(2.5f);
			SetAnimMoveSpeed(2.5f);
		}
		else
		{
			SetMoveSpeed(1);
			SetAnimMoveSpeed(1);
		}
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseStruck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// set_leader
	void OnSetLeader(int isLeader = 0)
	{
		BaseBattleAlly_OnSetLeader(isLeader); // monsters/base_battle_ally
		DwarfPickaxe_OnSetLeader(isLeader);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DwarfLanternBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // NPCs/dwarf_lantern_base
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseStruck_OnGameSpawn(playerRace, playerGender); // monsters/base_struck
		DwarfPickaxe_OnGameSpawn(playerRace, playerGender);
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	void OnDwarfSpawn() { DwarfPickaxe_OnDwarfSpawn(); } // dwarf_spawn
	void OnFrameRollBackPush() { DwarfPickaxe_OnFrameRollBackPush(); } // frame_roll_back_push
	void OnAttack12() { DwarfPickaxe_OnAttack12(); } // attack_1
	void OnAttack22() { DwarfPickaxe_OnAttack22(); } // attack_2

	// This file's events and timers by their .script names
	bool DwarfPickaxe_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "dwarf_spawn") { OnDwarfSpawn(); return true; }
		if (name == "frame_roll_back_push") { OnFrameRollBackPush(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_leader") { OnSetLeader(Int(Param(params, 0))); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "NPCs/dwarf_pickaxe"]
shared class DwarfPickaxeScript : BaseMonsterNewScript, DwarfPickaxe, BaseBattleAlly, BaseStruck, DwarfLanternBase
{
	// Variables every script that includes this file declares
	string WEAPON_CHOICE = "WEAPON_CHOICE";

	// Variables declared by included files, with the value they start with in this script
	DwarfPickaxeScript()
	{
		SOUND_DEATH = "voices/dwarf/vs_nx0drogm_hit3.wav";
		ANIM_IDLE = "idle";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("3dmflagry.spr");
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfPickaxe_FirstThink();
		BaseBattleAlly_FirstThink();
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
		return DwarfPickaxe_DispatchEvent(name, params)
			|| BaseBattleAlly_DispatchEvent(name, params)
			|| BaseStruck_DispatchEvent(name, params)
			|| DwarfLanternBase_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
