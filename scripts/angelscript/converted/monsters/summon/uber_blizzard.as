#pragma context server

// Converted from monsters/summon/uber_blizzard.script by msc_transpiler.
// Thothie
// Blizzard with adjustable AOE for NPC ( monsters/uber_ice_reaver )

#include "runtime/ScriptEntity.as"

[script "monsters/summon/uber_blizzard"]
class UberBlizzard : ScriptEntity
{
	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DMG = 0.0f;
	string MY_DURATION = "MY_DURATION";
	float MY_RADIUS = 0.0f;
	string FREEZE_CHANCE = "FREEZE_CHANCE";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float LOOP_COUNT = 0.0f;

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// $get(ent_me,id) DMG_STORM STORM_DUR STORM_RAD
		MY_OWNER = creatorValue1;
		MY_BASE_DMG = Float(creatorValue2);
		MY_DURATION = damage;
		MY_RADIUS = Float(skill);
		FREEZE_CHANCE = extraValue5; // chance to freeze each 10 seconds

		// dbg incpars owner $get(PARAM1,name) dmg MY_BASE_DMG dur MY_DURATION rad MY_RADIUS
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		ClientEvent("new", "all", "monsters/summon/uber_blizzard", OriginOf(ENT_ME), SkyHeight(MyOrigin()), MY_RADIUS, 10);
		MY_SCRIPT_IDX = LastClientScriptId();

		IS_ACTIVE = true;
		OnScanAttack();
		CallEventOrDelay(MY_DURATION, "end_summon");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Blizzard");
		SetRace("beloved");
		SetInvincible(true);
		SetHealth(1);
		PLAYING_DEAD = "1";
	}

	// scan_attack
	void OnScanAttack()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(10.0f, "scan_attack");
		LegacyCommand("getents", "any", MY_RADIUS);
		// (never true here, the rest is skipped) if GET_COUNT > 0
	}

	// check_attack
	void OnCheckAttack()
	{
		string checkEnt = "CHECK_ENT";
		bool exitSub = false;
		LOOP_COUNT += 1.0f;
		if (LOOP_COUNT == 1.0f)
			checkEnt = "GET_ENT1";
		if (LOOP_COUNT == 2.0f)
			checkEnt = "GET_ENT2";
		if (LOOP_COUNT == 3.0f)
			checkEnt = "GET_ENT3";
		if (LOOP_COUNT == 4.0f)
			checkEnt = "GET_ENT4";
		if (LOOP_COUNT == 5.0f)
			checkEnt = "GET_ENT5";
		if (LOOP_COUNT == 6.0f)
			checkEnt = "GET_ENT6";
		if (LOOP_COUNT == 7.0f)
			checkEnt = "GET_ENT7";
		if (LOOP_COUNT == 8.0f)
			checkEnt = "GET_ENT8";
		if (LOOP_COUNT == 9.0f)
			checkEnt = "GET_ENT9";

		if (RelationshipOf(checkEnt, MY_OWNER) != "enemy")
			return;

		if (Truthy(OWNER_ISPLAYER) && (IsPvp() ? 1 : 0) == 0 && IsPlayer(checkEnt))
			exitSub = true;
		if (exitSub)
			return;

		if (!(RangeTo(checkEnt) < MY_RADIUS)) // shouldn't need this
			return;

		if (!(RandomInt(1, 100) < Float(FREEZE_CHANCE)))
			return;
		ApplyEffect(checkEnt, "effects/dot_cold", 9.5f, MY_OWNER, MY_BASE_DMG);
	}

	// end_summon
	void OnEndSummon()
	{
		IS_ACTIVE = false;
		ClientEvent("remove", "all", MY_SCRIPT_IDX);
		CallEventDelayed(0.2f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_attack") { OnCheckAttack(); return true; }
		if (name == "end_summon") { OnEndSummon(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "scan_attack") { OnScanAttack(); return true; }
		return false;
	}
}
