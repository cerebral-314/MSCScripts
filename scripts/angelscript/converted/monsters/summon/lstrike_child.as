#pragma context server

// Converted from monsters/summon/lstrike_child.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/lstrike_child"]
class LstrikeChild : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	string MY_DURATION = "MY_DURATION";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int PVP_MODE = 0;
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";

	// unnamed block (timer)
	void LstrikeChild_Timer()
	{
		CallEventDelayed(1.0f, "LstrikeChild_Timer");
		PlaySound(0, 10, "magic/lightning_strike.wav");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		MY_DURATION = damage;

		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		PVP_MODE = (IsPvp() ? 1 : 0);
		LegacyCommand("drop_to_floor");
		IS_ACTIVE = true;
		OnSummonStart();
		CallEventOrDelay(MY_DURATION, "summon_end");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Strike");
		// race beloved
		SetInvincible(true);
		SetHealth(1);
		PLAYING_DEAD = "1";
		LegacyCommand("drop_to_floor");
	}

	// summon_start
	void OnSummonStart()
	{
		CallEventDelayed(0.1f, "damage_loop");
	}

	// damage_loop
	void OnDamageLoop()
	{
		CallEventDelayed(0.30f, "damage_loop");
		if (!IS_ACTIVE)
			return;
		DoDamage(Text(MyOrigin()), 96, MY_DMG, "100%", 0.1f, "normal", "lightning");
	}

	// summon_end
	void OnSummonEnd()
	{
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "LstrikeChild_Timer");
		CallEventDelayed(0.30f, "damage_loop");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "summon_end") { OnSummonEnd(); return true; }
		if (name == "summon_start") { OnSummonStart(); return true; }
		if (name == "LstrikeChild_Timer") { LstrikeChild_Timer(); return true; }
		return false;
	}
}
