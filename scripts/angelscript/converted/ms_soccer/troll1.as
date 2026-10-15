#pragma context server

// Converted from ms_soccer/troll1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/ms_soccer/base_soccer.as"
#include "converted/monsters/base_monster_new.as"

[script "ms_soccer/troll1"]
class Troll1 : BaseMonsterNewScript, BaseSoccer
{
	// Constants
	string ANIM_KICK = "kick_ball";
	string ANIM_SCOOP_BALL = "throw_rock";
	string ANIM_ROUND_WIN1 = "idle2";
	string ANIM_ROUND_WIN2 = "idle2";
	string ANIM_ROUND_LOST1 = "idle3";
	string ANIM_ROUND_LOST2 = "idle3";
	string SOUND_STRUCK = "weapons/cbar_hitbod1.wav";
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK = "monsters/troll/trollattack.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle2.wav";
	bool AM_GOALIE = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";

	// Variables declared by included files, with the value they start with in this script
	Troll1()
	{
		ANIM_IDLE = "idle0";
		ANIM_WALK = "walk";
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		NPC_FIGHTS_NPCS = true;
	}

	// unnamed block (first think)
	void Troll1_FirstThink()
	{
		ANIM_IDLE = "idle0";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "kick_ball";
	}

	// unnamed block (first think)
	void Troll1_FirstThink2()
	{
		ATTACK_MOVERANGE = 20.0f;
		MOVE_RANGE = "20";
		ATTACK_RANGE = 38.0f;
		ATTACK_HITRANGE = 56.0f;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Soccer Troll");
		SetModel("soccer/soccer_troll.mdl");
		SetWidth(72);
		SetHeight(100);
		SetHealth(1000);
		SetRace("human");
		SetRoam(false);
		SetHearingSensitivity(0);
	}

	// frame_kick_land
	void OnFrameKickLand()
	{
		// dbg frame_kick_land
		OnSocKickball();
	}

	// rock_pickup
	void OnRockPickup()
	{
		OnSocBallScoop();
	}

	// rock_throw
	void OnRockThrow()
	{
		OnSocBallRelease();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseSoccer_OnGameSpawn(playerRace, playerGender); // ms_soccer/base_soccer
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseSoccer_OnNpcatkHunt(); // ms_soccer/base_soccer
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
	}

	// npc_selectattack
	void OnNpcSelectattack()
	{
		BaseSoccer_OnNpcSelectattack(); // ms_soccer/base_soccer
		BaseAntiStuck_OnNpcSelectattack(); // monsters/base_anti_stuck
		BaseMonsterShared_OnNpcSelectattack(); // monsters/base_monster_shared
	}

	// npcatk_setmovedest
	void OnNpcatkSetmovedest(string destination = "", string range = "")
	{
		BaseSoccer_OnNpcatkSetmovedest(destination, range); // ms_soccer/base_soccer
		BaseNpcAttackNew_OnNpcatkSetmovedest(destination, range); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkSetmovedest(destination, range); // monsters/base_anti_stuck
	}

	void OnNpcSuicide(string suicideMode = "") { MonstersExternals_OnNpcSuicide(suicideMode); } // npc_suicide

	// npcatk_settarget
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		BaseNpcAttackNew_OnNpcatkSettarget(target, debug); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSettarget(target, debug); // monsters/base_monster_shared
	}

	void OnNpcatkFlee(string threatEntity = "", string fleeDistance = "", string fleeDuration = "") { BaseNpcAttackNew_OnNpcatkFlee(threatEntity, fleeDistance, fleeDuration); } // npcatk_flee
	void OnChickenRun(float duration = 0.0f) { BaseNpcAttackNew_OnChickenRun(duration); } // chicken_run

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
	}

	// npcatk_resume_ai
	void OnNpcatkResumeAi(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkResumeAi(target); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkResumeAi(target); // monsters/base_monster_shared
		BaseMonsterShared_OnNpcatkResumeAi_2(target); // monsters/base_monster_shared
	}

	void OnNpcatkSuspendMovement(string idleAnim = "", string duration = "") { BaseMonsterShared_OnNpcatkSuspendMovement(idleAnim, duration); } // npcatk_suspend_movement
	void OnNpcatkResumeMovement() { BaseMonsterShared_OnNpcatkResumeMovement(); } // npcatk_resume_movement

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("soccer/soccer_troll.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Troll1_FirstThink();
		Troll1_FirstThink2();
		BaseSoccer_FirstThink();
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
		if (name == "frame_kick_land") { OnFrameKickLand(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "rock_pickup") { OnRockPickup(); return true; }
		if (name == "rock_throw") { OnRockThrow(); return true; }
		return BaseSoccer_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
