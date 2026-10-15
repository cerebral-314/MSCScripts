#pragma context server

// Converted from monsters/summon/barrier.script by msc_transpiler.
// barrier holds back enemies by Thothie
// Continues doing so until told otherwise by external
// PARAM1 - Owner
// PARAM2 - Radius
// PARAM3 - No sound when bounce if set to 1
// PARAM4 - No sprites
// PARAM5 - No exit sound when set to 1
// PARAM6 - Damage when repelled
// PARAM7 - set to 1 = Push allies too (ie. everyone but master)
// PARAM8 - vanish after PARAM8 seconds

#include "runtime/ScriptEntity.as"

[script "monsters/summon/barrier"]
class Barrier : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_RADIUS = 0.0f;
	float MY_BASE_DAMAGE = 0.0f;
	bool AM_SILENT = false;
	bool AM_INVISIBLE = false;
	bool SILENT_EXIT = false;
	bool ALWAYS_PUSH = false;
	string MY_DURATION = "MY_DURATION";
	float CL_DURATION = 0.0f;
	Vector3 SPRITE_COLOR = Vector3();
	string BARRIER_SCRIPT_IDX = "BARRIER_SCRIPT_IDX";
	bool AM_BLOCKING = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string SCAN_TARGS = "SCAN_TARGS";

	// game_dynamically_created
	// <owner> <rad> [nosound:0|1] [nosprites:0|1] [noexitsnd:0|1] [dmg] [pushally:0|1] [remove_delay]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_RADIUS = Float(creatorValue2);
		MY_BASE_DAMAGE = 0.0f;

		if (Float(damage) == 1.0f)
			AM_SILENT = true;
		if (Float(skill) == 1.0f)
			AM_INVISIBLE = true;
		if (Float(extraValue5) == 1.0f)
			SILENT_EXIT = true;
		if (!extraValue6.isEmpty())
			MY_BASE_DAMAGE = Float(extraValue6);
		if (alwaysPush == 1.0f)
			ALWAYS_PUSH = true;
		if (!duration.isEmpty())
		{
			MY_DURATION = duration;
			CL_DURATION = Float(duration);
			CL_DURATION += 2.0f;
			CallEventOrDelay(duration, "remove_barrier");
		}

		if (MY_BASE_DAMAGE == 0.0f)
			SPRITE_COLOR = Vector3(0, 0, 255);
		if (MY_BASE_DAMAGE > 0.0f)
			SPRITE_COLOR = Vector3(255, 0, 0);

		if (!AM_INVISIBLE)
		{
			ClientEvent("new", "all", "monsters/summon/barrier_cl", IndexOf(MY_OWNER), MY_RADIUS, SPRITE_COLOR, CL_DURATION);
			BARRIER_SCRIPT_IDX = LastClientScriptId();
		}

		AM_BLOCKING = true;

		CallEventDelayed(0.25f, "scan_loop");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Magical Barrier");
		SetModel("null.mdl");
		SetIdleAnim("none");
		SetNoPush(true);
		SetHealth(9000); // high HP in effort to prevent push
		SetInvincible(true);
		SetWidth(8);
		SetHeight(8);
		SetSolid("none");
		SetRace("beloved");

		PLAYING_DEAD = "1"; // not valid target
	}

	// scan_loop
	void OnScanLoop()
	{
		if (!AM_BLOCKING)
			return;
		if (!IsAlive(MY_OWNER))
			return;
		if (!Exists(MY_OWNER))
			return;
		CallEventDelayed(0.5f, "scan_loop");
		Vector3 scanOrg = OriginOf(ENT_ME);
		scanOrg.z += 32.0f;
		SCAN_TARGS = LegacyFunction("get_tsphere", "any", MY_RADIUS, scanOrg);
		if (SCAN_TARGS == "none")
			return;
		int count = GetTokenCount(SCAN_TARGS);
		int outerIteration = loopIteration;
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnAffectTargets();
		}
		loopIteration = outerIteration;
	}

	// affect_targets
	void OnAffectTargets()
	{
		CBaseEntity@ curTarg = FindEntity(GetToken(SCAN_TARGS, loopIteration));

		bool doPush = false;
		if (RelationshipOf(curTarg, MY_OWNER) == "enemy")
			doPush = true;
		if (ALWAYS_PUSH && EntityId(curTarg) != MY_OWNER)
			doPush = true;
		// dbg temp isnme $get(PARAM2,relationship,MY_OWNER) always ALWAYS_PUSH
		if (!doPush)
			return;

		if (MY_BASE_DAMAGE > 0.0f)
			DoDamage("CUR_TARGET", "direct", MY_BASE_DAMAGE, "100%", MY_OWNER, "magic");

		Vector3 targetOrg = OriginOf("CUR_TARGET");
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		if (!AM_SILENT)
			PlaySound(0, 10, "doors/aliendoor3.wav");
		SetVelocity("CUR_TARGET", RelativeVelocity(Vector3(0, targAng, 0), Vector3(10, 1000, 0))); // a little to the left too, in case he's stuck up against a wall
	}

	// remove_barrier
	void OnRemoveBarrier()
	{
		AM_BLOCKING = false;
		ClientEvent("update", "all", BARRIER_SCRIPT_IDX, "clear_sprites");
		if (!SILENT_EXIT)
			PlaySound(0, 10, "magic/spawn.wav");
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "affect_targets") { OnAffectTargets(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_barrier") { OnRemoveBarrier(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_loop") { OnScanLoop(); return true; }
		return false;
	}
}
