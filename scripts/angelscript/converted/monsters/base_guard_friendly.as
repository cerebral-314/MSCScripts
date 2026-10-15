#pragma context server

// Converted from monsters/base_guard_friendly.script by msc_transpiler.
// Thothie - human guards having problems across the board (always have) - hoping to make a base to help them out
// - requires: ANIM_IDLE ANIM_ATTACK

#include "runtime/ScriptEntity.as"

[script "monsters/base_guard_friendly"]
class BaseGuardFriendly : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	Vector3 MY_GUARD_POST = Vector3();
	Vector3 MY_ORG_ANGLES = Vector3();
	bool OH_IT_IS_ON = false;
	bool IS_HUNTING = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";
	string NPC_MOVE_TARGET = "NPC_MOVE_TARGET";
	bool STRUCK_BY_PLAYER = false;
	bool MADE_IT_HOME = false;
	string NPC_ATTACK_TARGET = "NPC_ATTACK_TARGET";

	// unnamed block (first think)
	void BaseGuardFriendly_FirstThink()
	{
		NO_STUCK_CHECKS = "1";
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetRoam(false);
		SetMoveSpeed(0);
		OnNpcatkSuspendAi();

		CallEventDelayed(1.0f, "set_guard_post");
		CallEventDelayed(1.0f, "scan_for_enemies");
	}

	// set_guard_post
	void OnSetGuardPost()
	{
		MY_GUARD_POST = OriginOf(ENT_ME);
		MY_ORG_ANGLES = AnglesOf(ENT_ME);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (OH_IT_IS_ON)
			return;
		// setvard HUNT_LASTTARGET ent_laststruck
		// setvard NPC_ATTACK_TARGET ent_laststruck
		// if ( $get(ent_laststruck,isplayer) )
		// {
		// setvard NPC_MOVE_TARGET player
		// }
		OnBaseguardTobattle(EntityOf(ENT_LASTSTRUCK));
	}

	// npcatk_targetvalidate
	// called from base_npc_attack on spotting target
	void OnNpcatkTargetvalidate(string target = "")
	{
		if (OH_IT_IS_ON)
			return;
		if (!CanSee("enemy"))
			return;
		OnBaseguardTobattle();
	}

	// baseguard_tobattle
	// param1 = enemy_id
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		// dbg TO BATTLE!
		OnNpcatkResumeAi();
		OH_IT_IS_ON = true;
		SetMoveSpeed(1);
		SetRoam(true);
		SetMoveAnim("ANIM_RUN");
		PlayAnim("critical", "ANIM_ATTACK");
		if (enemy !is null)
		{
			IS_HUNTING = true;
			HUNT_LASTTARGET = EntityId(enemy);
			NPC_MOVE_TARGET = EntityId(enemy);
			SetMoveDest(HUNT_LASTTARGET, "ATTACK_RANGE");
		}
	}

	// my_target_died
	// This return to post bit not working so good
	// plus it seems once you strike a guard, he never forgives you
	// called from base_npc_attack
	void OnMyTargetDied(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		STRUCK_BY_PLAYER = false;

		OH_IT_IS_ON = false;
		SetAngle("face_origin", MY_GUARD_POST);
		SetMoveDest(MY_GUARD_POST, 1);
		MADE_IT_HOME = false;
		OnGoingHome();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		// //dbg heard $get(ent_lastheard,relationship,ent_me) $get(ent_lastheard,name)
		if (RelationshipOf(ENT_LASTHEARD, ENT_ME) != "enemy")
			return;
		if (IsPlayer(ENT_LASTHEARD))
			return;
		HUNT_LASTTARGET = ENT_LASTSEEN;
		SetMoveDest(ENT_LASTHEARD, "ATTACK_RANGE");
		OnBaseguardTobattle(EntityOf(ENT_LASTHEARD));
	}

	// scan_for_enemies
	void OnScanForEnemies()
	{
		if (OH_IT_IS_ON)
			return;
		CallEventDelayed(1.1f, "scan_for_enemies");

		// //dbg Info width game.monster.width move game.monster.movespeed
		// //dbg Enemy? $cansee(enemy)
		if (!CanSee("enemy"))
			return;
		if (IsPlayer(ENT_LASTSEEN))
			return;
		HUNT_LASTTARGET = ENT_LASTSEEN;
		SetMoveDest(ENT_LASTSEEN, "ATTACK_RANGE");
		OnBaseguardTobattle(EntityOf(ENT_LASTSEEN));
	}

	// going_home
	void OnGoingHome(string phase = "")
	{
		if (CanSee("enemy"))
			return;
		if (MADE_IT_HOME)
			return;
		if (OH_IT_IS_ON)
			return;

		CallEventDelayed(1.0f, "going_home");
		Vector3 myPos = OriginOf(ENT_ME);

		// //dbg GoingHome distance game.monster.origin vs MY_POS
		if (Eval("game.monster.movedest.origin") != Text(MY_GUARD_POST))
			SetMoveDest(MY_GUARD_POST, 1);

		if (Distance(myPos, MY_GUARD_POST) < 10.0f && !OH_IT_IS_ON)
		{
			// dbg made it home
			myPos = OriginOf(ENT_ME);
			SetMoveDest("none");
			SetRoam(false);
			SetMoveSpeed(0);
			SetMoveAnim("ANIM_IDLE");
			SetAngle("face", MY_ORG_ANGLES);
			CallEventDelayed(1.0f, "scan_for_enemies");
			MADE_IT_HOME = true;
		}
	}

	// check_attack
	// if player hits him, and bad guys show up, he cant attack
	void OnCheckAttack()
	{
		NPC_ATTACK_TARGET = HUNT_LASTTARGET;
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnNpcatkResumeAi(string target = "") {} // npcatk_resume_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "") {} // npcatk_suspend_ai

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseGuardFriendly_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "going_home") { OnGoingHome(Param(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "scan_for_enemies") { OnScanForEnemies(); return true; }
		if (name == "set_guard_post") { OnSetGuardPost(); return true; }
		return false;
	}
}
