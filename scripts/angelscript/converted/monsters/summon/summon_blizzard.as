#pragma context server

// Converted from monsters/summon/summon_blizzard.script by msc_transpiler.
// Blizzard

#include "runtime/ScriptEntity.as"
#include "converted/monsters/summon/base_aoe.as"

[script "monsters/summon/summon_blizzard"]
class SummonBlizzard : BaseAoeScript
{
	// Constants
	float FREQ_NOISE = 8.0f;
	int BLIZZARD_RANGE = 172;
	string SHARD_MODEL = "glassgibs.mdl";

	// Variables (an unset .script variable reads as its own name)
	float SCAN_RATE = 0.0f;
	bool SNOWING = false;
	string MY_ANGLES = "MY_ANGLES";
	float MY_BASE_DMG = 0.0f;
	int MY_BASE_DURATION = 0;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string TIME_LIVE = "TIME_LIVE";
	string PLAYING_DEAD = "PLAYING_DEAD";

	// Variables declared by included files, with the value they start with in this script
	SummonBlizzard()
	{
		AOE_FREQ = 2.0f;
		AOE_RADIUS = "172";
	}

	// unnamed block (first think)
	void SummonBlizzard_FirstThink()
	{
		SCAN_RATE = 2.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseAoe_OnGameSpawn(playerRace, playerGender); // monsters/summon/base_aoe

		SetName("Blizzard");
		SetInvincible(true);
		SetRace("beloved");
		SetModel("none");
		SetSolid("none");
		PLAYING_DEAD = "1";

		SetNoPush(true);

		SetGravity(0);
		SetRoam(false);
		// (always true here) if game.serverside
		PlaySound(0, 10, "amb/windy.wav");
		CallEventDelayed(FREQ_NOISE, "do_noise");
	}

	// snow_start
	// Start shooting
	void OnSnowStart()
	{
		SNOWING = true;
	}

	// game_dynamically_created
	// Server
	// ======
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_ANGLES = creatorValue2;
		MY_BASE_DMG = Float(damage);
		MY_BASE_DURATION = 10;
		ACTIVE_SKILL = extraValue5;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.ice";

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		GAME_PVP = (IsPvp() ? 1 : 0);
		if (Truthy(OWNER_ISPLAYER))
			SCAN_RATE = 1.0f;

		// //dbg Created Blizzard!
		// race $get(MY_OWNER,race)
		// Thothie - desperate attempts to pass proper XP
		// tried spellcasting.ice | spellcasting ice | skill.spellcasting ice | skill.spellcasting skill.spellcasting.balance |  |
		// setexpstat $get(ent_me,id) skill.spellcasting skill.spellcasting.balance
		// setexpstat ent_me skill.spellcasting skill.spellcasting.balance
		// setexpstat MY_OWNER skill.spellcasting skill.spellcasting.balance
		// storeentity ent_expowner MY_OWNER //no workie
		// //dbg =====
		// //dbg Mystat game.monster.spellcasting.ice //tried game.monster.skill.spellcasting.ice | game.skill.spellcasting.ice | game.monster.skill.spellcasting
		SetAngle("face.y", MY_ANGLES);
		// multiply PARAM4 1.5
		TIME_LIVE = MY_BASE_DURATION;

		// =========== Traceline test
		Vector3 traceStart = MyOrigin();
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 2000)));

		Vector3 roofHeight = Vec(LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly"));
		if (Distance(roofHeight, MyOrigin()) > 512.0f)
		{
			// if celing > 512, it is probably inside a skybrush, thus just use 512
			roofHeight = MyOrigin();
			roofHeight.z += 512.0f;
		}

		// //dbg tracelin test $get_traceline(TRACE_START,TRACE_END,worldonly)
		// ===========
		float myX = MyOrigin().x;
		float myY = MyOrigin().y;
		float grndZ = Float(LegacyFunction("vec.z", MY_OWNER, "origin")); // $get_ground_height(game.monster.origin)
		Vector3 snowfxSpawn = Vector3(myX, myY, grndZ);

		if (Truthy(OWNER_ISPLAYER))
		{
			ClientEvent("new", "all", "monsters/summon/summon_blizzard", snowfxSpawn, TIME_LIVE, roofHeight); // Send to client immediately - calls client_activate on client

			CallEventOrDelay(TIME_LIVE, "blizzard_death");
			OnSnowStart();
		}

		if (!Truthy(OWNER_ISPLAYER))
		{
			ClientEvent("new", "all", "monsters/summon/summon_blizzard", snowfxSpawn, TIME_LIVE, roofHeight); // Send to client immediately - calls client_activate on client
			CallEventOrDelay(TIME_LIVE, "blizzard_death");
			OnSnowStart();
		}
	}

	// do_noise
	void OnDoNoise()
	{
		if (!IS_ACTIVE)
			return;
		PlaySound(0, 10, "amb/windy.wav");
		CallEventDelayed(FREQ_NOISE, "do_noise");
	}

	// blizzard_death
	// Pewf
	void OnBlizzardDeath()
	{
		DeleteEntity(ENT_ME);
	}

	// apply_aoe_effect
	// base_aoe
	void OnApplyAoeEffect(CBaseEntity@ target = null)
	{
		if (HasEffect(target, "DOT_cold"))
			return;
		ApplyEffect(target, "effects/dot_cold", 5, MY_OWNER, MY_BASE_DMG, ACTIVE_SKILL);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqNoise() {} // FREQ_NOISE
	void OnTimeLive() {} // TIME_LIVE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("snow1.spr");
		Precache("glassgibs.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SummonBlizzard_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "apply_aoe_effect") { OnApplyAoeEffect(EntityParam(params, 0)); return true; }
		if (name == "blizzard_death") { OnBlizzardDeath(); return true; }
		if (name == "do_noise") { OnDoNoise(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "snow_start") { OnSnowStart(); return true; }
		return BaseAoeScript::DispatchEvent(name, params);
	}
}
