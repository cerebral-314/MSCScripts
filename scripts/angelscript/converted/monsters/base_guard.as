#pragma context server

// Converted from monsters/base_guard.script by msc_transpiler.
// Thothie - human guards having problems across the board (always have) - hoping to make a base to help them out
// - requires: ANIM_IDLE ANIM_ATTACK

#include "runtime/ScriptEntity.as"

[script "monsters/base_guard"]
class BaseGuard : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 MY_GUARD_POST = Vector3();
	Vector3 MY_ORG_ANGLES = Vector3();
	bool OH_IT_IS_ON = false;
	bool MADE_IT_HOME = false;
	string HUNT_LASTTARGET = "HUNT_LASTTARGET";

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		SetRoam(false);
		SetMoveSpeed(0);

		CallEventDelayed(1.0f, "set_guard_post");
		CallEventDelayed(1.0f, "scan_for_enemies");
	}

	// set_guard_post
	void OnSetGuardPost()
	{
		MY_GUARD_POST = OriginOf(ENT_ME);
		MY_ORG_ANGLES = AnglesOf(ENT_ME);
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		if (OH_IT_IS_ON)
			return;
		OnBaseguardTobattle();
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
	// param1 = enemy triggered
	void OnBaseguardTobattle(CBaseEntity@ enemy = null)
	{
		// dbg TO BATTLE!
		OH_IT_IS_ON = true;
		SetMoveSpeed(1);
		SetRoam(true);
		SetMoveAnim("ANIM_RUN");
		PlayAnim("loop", "ANIM_ATTACK");
		if (enemy !is null)
			SetMoveDest(@enemy, "ATTACK_RANGE");
	}

	// my_target_died
	// This return to post bit not working so good
	// plus it seems once you strike a guard, he never forgives you
	// called from base_npc_attack
	void OnMyTargetDied(string offender = "")
	{
		if (CanSee("enemy"))
			return;
		OH_IT_IS_ON = false;
		SetAngle("face_origin", MY_GUARD_POST);
		SetMoveDest(MY_GUARD_POST, 1);
		MADE_IT_HOME = false;
		OnGoingHome();
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		// dbg heard $get(ent_lastheard,relationship,ent_me) $get(ent-_astheard,name)
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

		// dbg Enemy? $cansee(enemy)
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

		// dbg GoingHome distance $get(ent_me,"movedest.prox") vs $dist(MY_POS,MY_GUARD_POST) loc game.monster.movedest.origin
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

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "baseguard_tobattle") { OnBaseguardTobattle(EntityParam(params, 0)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "going_home") { OnGoingHome(Param(params, 0)); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "scan_for_enemies") { OnScanForEnemies(); return true; }
		if (name == "set_guard_post") { OnSetGuardPost(); return true; }
		return false;
	}
}
