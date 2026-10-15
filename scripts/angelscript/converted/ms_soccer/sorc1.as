#pragma context server

// Converted from ms_soccer/sorc1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/ms_soccer/base_soccer.as"
#include "converted/monsters/base_monster_new.as"

[script "ms_soccer/sorc1"]
class Sorc1 : BaseMonsterNewScript, BaseSoccer
{
	// Constants
	string ANIM_JUMP = "jump_hop";
	string ANIM_KICK = "kick";
	string ANIM_ROUND_WIN1 = "warcry";
	string ANIM_ROUND_WIN2 = "nod_yes";
	string ANIM_ROUND_LOST1 = "neigh";
	string ANIM_ROUND_LOST2 = "kneel";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool AM_LEADER = false;
	bool DOING_JUMP = false;

	// Variables declared by included files, with the value they start with in this script
	Sorc1()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		SOUND_DEATH = "voices/orc/die.wav";
		NPC_FIGHTS_NPCS = true;
	}

	// unnamed block (first think)
	void Sorc1_FirstThink()
	{
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_RUN = "run";
		ANIM_ATTACK = "kick";
	}

	// unnamed block (first think)
	void Sorc1_FirstThink2()
	{
		ATTACK_MOVERANGE = 20.0f;
		MOVE_RANGE = "20";
		ATTACK_RANGE = 30.0f;
		ATTACK_HITRANGE = 48.0f;
	}

	// setsoc_def
	void OnSetsocDef()
	{
		BaseSoccer_OnSetsocDef(); // ms_soccer/base_soccer
		SetModelBody(1, 4); // head - 0=horns 1=spikes 2=bear 3=chief 4=lizard
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SetName("Soccer Sorc");
		SetModel("soccer/sorc_soccer1.mdl");
		SetWidth(32);
		SetHeight(72);
		SetHealth(400);
		SetRace("human");
		SetRoam(false);
		SetHearingSensitivity(0);

		SetModelBody(0, 3); // body - 0=bare 1=shirts 2=armor 3=archer
		SetModelBody(1, 1); // head - 0=horns 1=spikes 2=bear 3=chief 4=lizard
		SetModelBody(2, 0); // weapon - 0=empty 1=beer
	}

	// setsoc_leader
	void OnSetsocLeader()
	{
		SetModelBody(0, 0); // body - 0=bare 1=shirts 2=armor 3=archer
		SetModelBody(1, 2); // head - 0=horns 1=spikes 2=bear 3=chief 4=lizard
		SetHealth(800);
		AM_LEADER = true; // kicks harder
	}

	// jump_start
	void OnJumpStart()
	{
	}

	// jump_boost
	void OnJumpBoost()
	{
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 200, 400)));
		DOING_JUMP = true;
		CallEventDelayed(0.2f, "check_boost2");
		CallEventDelayed(0.4f, "check_boost2");
		CallEventDelayed(0.6f, "check_boost2");
		CallEventDelayed(0.8f, "check_boost2");
	}

	// check_boost2
	void OnCheckBoost2()
	{
		if (!DOING_JUMP)
			return;
		Vector3 ballOrg = OriginOf(BALL_ID);
		Vector3 myOrg = OriginOf(ENT_ME);
		float ballFromGoal = Distance(ballOrg, Vec(NME_GOAL_LOC));
		bool keepGoing = false;
		float myFromGoal = Distance(myOrg, Vec(NME_GOAL_LOC));
		if (myFromGoal < ballFromGoal)
		{
			keepGoing = true; // still too close
		}

		if (Range2DTo(BALL_ID) < 30.0f) // on top of ball
			keepGoing = true;

		if (keepGoing)
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 100, 0)));
		else
			SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 0)));
	}

	// jump_land
	void OnJumpLand()
	{
		DOING_JUMP = false;
		OnNpcatkResumeAi();
	}

	// kick_land
	void OnKickLand()
	{
		OnSocKickball();
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
		Precache("soccer/sorc_soccer1.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Sorc1_FirstThink();
		Sorc1_FirstThink2();
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
		if (name == "check_boost2") { OnCheckBoost2(); return true; }
		if (name == "jump_boost") { OnJumpBoost(); return true; }
		if (name == "jump_land") { OnJumpLand(); return true; }
		if (name == "jump_start") { OnJumpStart(); return true; }
		if (name == "kick_land") { OnKickLand(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "setsoc_def") { OnSetsocDef(); return true; }
		if (name == "setsoc_leader") { OnSetsocLeader(); return true; }
		return BaseSoccer_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
