#pragma context server

// Converted from monsters/skels_normal.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_temporary.as"

[script "monsters/skels_normal"]
class SkelsNormal : BaseTemporaryScript
{
	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "";
	string ANIM_DEATH = "ANIM_DEATH";

	// Variables declared by included files, with the value they start with in this script
	SkelsNormal()
	{
		DEATH_DELAY = 1.0f;
	}

	// unnamed block (first think)
	void SkelsNormal_FirstThink()
	{
		ANIM_IDLE = "";
		ANIM_DEATH = "";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTemporary_OnGameSpawn(playerRace, playerGender); // monsters/base_temporary

		SetInvincible(true);
		SetFly(true);
		SetHealth(10);
		// dbg Skeleton Normalizer spawned
		CallEventDelayed(0.1f, "remove_sleeps");
	}

	// remove_sleeps
	void OnRemoveSleeps()
	{
		// dbg Skels_normal - Ordering sleep scripts to suicide
		CBaseEntity@ sleeperTypea = FindByName("skels_sleep");
		CBaseEntity@ sleeperIda = EntityOf("SLEEPER_TYPEB");
		CallExternal(sleeperIda, "suicide_me");

		CallEventDelayed(0.2f, "remove_sleeps2");
	}

	// remove_sleeps2
	void OnRemoveSleeps2()
	{
		CBaseEntity@ sleeperTypeb = FindByName("skels_deep_sleep");
		CBaseEntity@ sleeperIdb = sleeperTypeb;
		CallExternal(sleeperIdb, "suicide_me");

		CallEventDelayed(0.2f, "double_remove");
	}

	// double_remove
	// redundant
	void OnDoubleRemove()
	{
		// dbg Skels_normal job complete, removing self
		DeleteEntity("SLEEPER_IDA");
		DeleteEntity("SLEEPER_IDB");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SkelsNormal_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "double_remove") { OnDoubleRemove(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_sleeps") { OnRemoveSleeps(); return true; }
		if (name == "remove_sleeps2") { OnRemoveSleeps2(); return true; }
		return BaseTemporaryScript::DispatchEvent(name, params);
	}
}
