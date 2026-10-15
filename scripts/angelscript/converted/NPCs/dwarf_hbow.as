#pragma context server

// Converted from NPCs/dwarf_hbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/dwarf_zombie_hbow.as"
#include "converted/monsters/base_battle_ally.as"

[script "NPCs/dwarf_hbow"]
class DwarfHbow : DwarfZombieHbowScript, BaseBattleAlly
{
	// Variables declared by included files, with the value they start with in this script
	DwarfHbow()
	{
		NPC_BASE_EXP = "0";
		ANIM_ALLY_JUMP = "anim_roll_back";
		NPC_USE_IDLE = false;
		SOUND_ALLY_JUMP = "voices/dwarf/vs_nx0drogm_hit2.wav";
		ACT_ANIM_RUN = "run";
		SOUND_PAIN1 = "voices/dwarf/vs_ndwarfm1_hit1.wav";
		SOUND_PAIN2 = "voices/dwarf/vs_ndwarfm1_bat1.wav";
		SOUND_PAIN3 = "voices/dwarf/vs_ndwarfm1_hit3.wav";
		SOUND_FLINCH1 = "voices/dwarf/vs_nx0drogm_heal.wav";
		SOUND_FLINCH2 = "voices/dwarf/vs_nx0drogm_help.wav";
		SOUND_FLINCH3 = "voices/dwarf/vs_nx0drogm_hit1.wav";
		SOUND_DEATH = "voices/dwarf/vs_nx0drogm_hit3.wav";
		SOUND_ALERT1 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat3.wav";
		SOUND_ALERT2 = "voices/dwarf/voices/dwarf/vs_nx0drogm_bat1.wav";
		SOUND_ALERT3 = "voices/dwarf/voices/dwarf/vs_ndwarfm1_bat3.wav";
		NPC_FIGHTS_NPCS = true; // from monsters/base_battle_ally
		AI_NO_TARGET_STRING = "unset"; // from monsters/base_battle_ally
		ALLY_MIN_DISTANCE = 42; // from monsters/base_battle_ally
		ALLY_FOLLOW_CLOSE_DIST = 60; // from monsters/base_battle_ally
		ALLY_FOLLOW_NORM_DIST = 128; // from monsters/base_battle_ally
		ALLY_MOVE_AWAY_DIST = 64; // from monsters/base_battle_ally
		ALLY_REGEN_RATIO = 0.1f; // from monsters/base_battle_ally
		ALLY_MAX_JUMP_RANGE = 600; // from monsters/base_battle_ally
		ALLY_JUMP_THRESHOLD = 150; // from monsters/base_battle_ally
	}

	// unnamed block (first think)
	void DwarfHbow_FirstThink()
	{
		NPC_NO_PLAYER_DMG = true;
		ALLY_FOLLOW_ON = false;
	}

	// frame_roll_back_push
	void OnFrameRollBackPush()
	{
		DwarfZombieSbow_OnFrameRollBackPush(); // monsters/dwarf_zombie_sbow
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 100, 0)));
	}

	// set_follower
	void OnSetFollower()
	{
		BaseBattleAlly_OnSetFollower(); // monsters/base_battle_ally
		ALLY_FOLLOW_ON = true;
	}

	// darcher_spawn
	void OnDarcherSpawn()
	{
		SetName("Dwarven Bowman");
		SetModel("dwarf/male1.mdl");

		SetModelBody(0, 0);
		SetProp(ENT_ME, "skin", RandomInt(0, 6));
		SetModelBody(1, 7);
		SetWidth(32);
		SetHeight(48);
		SetRoam(true);
		SetHealth(300);
		SetRace("human");
		SetHearingSensitivity(8);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseStruck_OnNpcatkHunt(); // monsters/base_struck
		DwarfLanternBase_OnNpcatkHunt(); // NPCs/dwarf_lantern_base
		BaseBattleAlly_OnNpcatkHunt(); // monsters/base_battle_ally
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
		result = AppendResult(result, BaseBattleAlly_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/bows/boltexplosive.mdl");
		Precache("explode1.spr");
		Precache("agrunt/ag_pain3.wav");
		Precache("3dmflagry.spr");
		Precache("voices/dwarf/vs_ndwarfm1_hit1.wav");
		Precache("dwarf/male1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DwarfHbow_FirstThink();
		DwarfZombieSbow_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseStruck_FirstThink();
		BaseBattleAlly_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "darcher_spawn") { OnDarcherSpawn(); return true; }
		if (name == "frame_roll_back_push") { OnFrameRollBackPush(); return true; }
		if (name == "set_follower") { OnSetFollower(); return true; }
		return BaseBattleAlly_DispatchEvent(name, params)
			|| DwarfZombieHbowScript::DispatchEvent(name, params);
	}
}
