#pragma context server

// Converted from monsters/monster_random.script by msc_transpiler.
// Special random monster selector
// List of monster scripts must be placed in addparams, seperated by semi-colons
// scripts beginning with monster/ can have that portion of their script name ommited (saves limited string space)
// any script used must appear as a regular monster elsewhere on the map to ensure their media is precached
// however, said monsters do not actually need to spawn

#include "runtime/ScriptEntity.as"

[script "monsters/monster_random"]
class MonsterRandom : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string PLAYING_DEAD = "PLAYING_DEAD";
	string IN_MOBS = "IN_MOBS";
	string FINAL_MOBS = "FINAL_MOBS";
	CBaseEntity@ SPAWN_ID = null;

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // don't target me
		SetInvincible(true);
		SetGravity(0);
		SetNoPush(true);
		SetFly(true);
		SetHealth(1);
		SetModel("null.mdl"); // need a model to gain proper origin
		SetWidth(3);
		SetHeight(3);
		SetSolid("none");
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		bool noInMobs = false;
		IN_MOBS = params;
		if (int(IN_MOBS.length()) < 3)
			noInMobs = true;
		if (IN_MOBS.isEmpty())
			noInMobs = true;
		if (noInMobs)
		{
			InfoMessage("all", "MAP ERROR", "monsters/monster_random not supplied with monster list");
			OnRemoveMe();
		}
		if (noInMobs)
			return;
		FINAL_MOBS = "";
		int count = GetTokenCount(IN_MOBS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnProcessInMobs();
		}
		float nMobs = GetTokenCount(FINAL_MOBS) - 1.0f;
		int rndMob = RandomInt(0, int(nMobs));
		string rndMobText = GetToken(FINAL_MOBS, rndMob);
		OnSpawnMob(rndMobText);
	}

	// process_in_mobs
	void OnProcessInMobs()
	{
		// auto-prefix with 'monsters/' if no slash in entry
		string curMob = GetToken(IN_MOBS, loopIteration);
		if (Contains(curMob, "/"))
		{
			FINAL_MOBS = TokenAdd(FINAL_MOBS, curMob);
		}
		else
		{
			string outToken = "monsters/" + curMob;
			FINAL_MOBS = TokenAdd(FINAL_MOBS, outToken);
		}
	}

	// spawn_mob
	// <script>
	void OnSpawnMob(string script = "")
	{
		CreateNpc(script, OriginOf(ENT_ME));
		@SPAWN_ID = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(1.0f, "monitor_spawn");
	}

	// monitor_spawn
	void OnMonitorSpawn()
	{
		if (!IsAlive(SPAWN_ID))
			OnRemoveMe();
		else
			CallEventDelayed(0.5f, "monitor_spawn");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		// this valid death should be monster spawn friendly
		SetInvincible(false);
		SetRace("hated");
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
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
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "monitor_spawn") { OnMonitorSpawn(); return true; }
		if (name == "process_in_mobs") { OnProcessInMobs(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "spawn_mob") { OnSpawnMob(Param(params, 0)); return true; }
		return false;
	}
}
