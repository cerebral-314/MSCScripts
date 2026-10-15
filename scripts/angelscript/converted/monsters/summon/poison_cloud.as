#pragma context server

// Converted from monsters/summon/poison_cloud.script by msc_transpiler.
// Poison Cloud by Thothie (from scratch, save smokes, from monsters/summon/summon_lightning_storm)
// - This script removes all occurances of itself at end, therefor, "there can be only one"
// - If you want an NPC to use this, copy to poison_cloud_noc - so player can't 'steal' his cloud

#include "runtime/ScriptEntity.as"

[script "monsters/summon/poison_cloud"]
class PoisonCloud : ScriptEntity
{
	// Constants
	string SMOKE_SPRITE = "poison_cloud.spr";
	int HEIGHT = 40;
	int WIDTH = 96;

	// Variables (an unset .script variable reads as its own name)
	bool POISONING = false;
	bool STORMING = false;
	string MY_OWNER = "MY_OWNER";
	float MY_BASE_DAMAGE = 0.0f;
	string MY_DURATION = "MY_DURATION";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MY_OWNER_RACE = "MY_OWNER_RACE";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool IN_POISON_LOOP = false;
	float LOOP_COUNT = 0.0f;

	// unnamed block (first think)
	void PoisonCloud_FirstThink()
	{
		POISONING = true;
	}

	// smokes_start
	// Start shooting
	void PoisonCloud_OnSmokesStart()
	{
		STORMING = true;
	}

	// unnamed block (timer)
	// EFFECTS STUFF from monsters/summon/summon_lightning_storm
	void PoisonCloud_Timer()
	{
		CallEventDelayed(1.0f, "PoisonCloud_Timer");
		if (!STORMING)
			return;
	}

	// smokes_start
	// Random lightning bolt
	// Start shooting
	void PoisonCloud_OnSmokesStart_2()
	{
		STORMING = true;
	}

	// smokes_start
	void OnSmokesStart()
	{
		PoisonCloud_OnSmokesStart();
		PoisonCloud_OnSmokesStart_2();
	}

	// game_dynamically_created
	// PARAM1=Owner PARAM2=Angles PARAM3=Damage PARAM4=Duration [PARAM5=skill]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_BASE_DAMAGE = Float(damage);
		MY_DURATION = skill;

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		MY_OWNER_RACE = RaceOf(creatorValue1);

		string mySkill = extraValue5;

		if (mySkill.isEmpty())
			mySkill = "spellcasting.affliction";

		// dbg IncDur MY_DURATION
		CallEventOrDelay(MY_DURATION, "poisoning_end");

		CallEventDelayed(2.0f, "smokes_start");
		ClientEvent("new", "all", "monsters/summon/poison_cloud", OriginOf(ENT_ME), creatorValue2, MY_DURATION);
		// needless to say, still on workie
		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		PLAYING_DEAD = "1"; // not a valid target

		SetName("Poison Cloud");
		SetHealth(1);
		SetInvincible(true);
		SetRace("beloved");
		SetHeight(32);
		SetWidth(32);
		SetBlood("none");
		SetModel("none");
		SetSolid("none");

		SetAngle("face", Vector3(0, 90, 0));

		POISONING = true;

		CallEventDelayed(0.5f, "poisoning_go");
	}

	// poisoning_go
	void OnPoisoningGo()
	{
		if (!POISONING)
			return;

		CallEventDelayed(1.0f, "poisoning_go");

		LegacyCommand("getents", "any", 256);
		// (never true here, the rest is skipped) if GET_COUNT > 0
	}

	// poison_area
	void OnPoisonArea()
	{
		string checkEnt = "CHECK_ENT";
		bool exitSub = false;

		if (!POISONING)
			return;
		CallEventDelayed(0.1f, "poison_area");

		LOOP_COUNT += 1.0f;
		if (LOOP_COUNT > 9.0f)
			LOOP_COUNT = 1.0f;

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

		// //dbg poison area spotted  $get(CHECK_ENT,name) alv $get(CHECK_ENT,isalive) rng $get(CHECK_ENT,relationship,MYOWNER) nme $get(CHECK_ENT,relationship,MY_OWNER)
		if (!IsAlive(checkEnt))
			return;

		if (!(RangeTo(checkEnt) < 256.0f))
			return;

		if (RelationshipOf(checkEnt, MY_OWNER) != "enemy")
			return;

		if ((IsPvp() ? 1 : 0) == 0 && Truthy(OWNER_ISPLAYER) && IsPlayer(checkEnt))
			exitSub = true;
		if (exitSub)
			return;

		// no poison through walls
		Vector3 traceStart = OriginOf(ENT_ME);
		Vector3 traceEnd = OriginOf(checkEnt);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != Text(traceEnd))
			return;

		// effect glow CHECK_ENT (75,215,0) 18 1 1
		// callexternal $get(ent_lastseen,id) effect_damage MY_BASE_DAMAGE MY_OWNER 0.5 poison //base_npc and player/externals
		// callexternal MY_OWNER send_damage CHECK_ENT direct MY_BASE_DAMAGE 100% MY_OWNER poison
		if (HasEffect(checkEnt, "DOT_poison"))
			return;
		ApplyEffect(checkEnt, "effects/dot_poison", 2.5f, MY_OWNER, MY_BASE_DAMAGE);
	}

	// poisoning_end
	void OnPoisoningEnd()
	{
		ClientEvent("remove", "all", "monsters/summon/poison_cloud");
		POISONING = false;
		STORMING = false;
		CallEventDelayed(0.1f, "remove_final");
	}

	// remove_final
	void OnRemoveFinal()
	{
		RemoveScript();
		ClientEvent("remove", "all", "monsters/summon/poison_cloud");
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnMyDuration() {} // MY_DURATION

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("poison_cloud.spr");
		CallEventDelayed(1.0f, "PoisonCloud_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		PoisonCloud_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "poison_area") { OnPoisonArea(); return true; }
		if (name == "poisoning_end") { OnPoisoningEnd(); return true; }
		if (name == "poisoning_go") { OnPoisoningGo(); return true; }
		if (name == "remove_final") { OnRemoveFinal(); return true; }
		if (name == "smokes_start") { OnSmokesStart(); return true; }
		if (name == "PoisonCloud_Timer") { PoisonCloud_Timer(); return true; }
		return false;
	}
}
