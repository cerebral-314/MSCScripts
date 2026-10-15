#pragma context server

// Converted from monsters/summon/horror_egg.script by msc_transpiler.
// createnpc monsters/summon/horror_egg

#include "runtime/ScriptEntity.as"
#include "converted/monsters/externals.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HorrorEgg
{
	// Constants
	float SCAN_SIZE = 100.0f;
	Vector3 GLOW_SHELL = Vector3();
	string SOUND_HATCH = "debris/bustflesh1.wav";
	string EGG_SCRIPT = "monsters/horror";

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string MY_OWNER = "MY_OWNER";
	float FAILED_HATCH = 0.0f;
	float NPC_SPAWN_TIME = 0.0f;

	// unnamed block (first think)
	void HorrorEgg_FirstThink()
	{
		IS_UNHOLY = true;
	}

	// game_dynamically_created
	void HorrorEgg_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
	}

	// game_spawn
	void HorrorEgg_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Horror Egg");
		SetHealth(50);
		SetRace("demon");
		SetModel("monsters/egg.mdl");
		SetBlood("green");
		SetWidth(64);
		SetHeight(64);
		SetModelBody(0, 1);

		SetSkillLevel(5); // give some bonus for hitting the sucker

		SetBoundingBox("npcsize");

		SetProp(ENT_ME, "movetype", Eval("const.movetype.bounce"));

		Effect("glow", ENT_ME, GLOW_SHELL, 128, -1, 0);

		CallEventDelayed(5.0f, "attempt_spawn");

		FAILED_HATCH = 0.0f;

		// be nice if game_touch or SOMETHING worked
		// imitating gib method of bounce detection
		CallEventDelayed(0.1f, "scan_bounce");

		NPC_SPAWN_TIME = GameTime();
	}

	// game_damaged
	string HorrorEgg_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool blockPrematureDamage = false;
		string result = "";
		float sinceSpawn = GameTime() - NPC_SPAWN_TIME;
		if (sinceSpawn < 1.0f)
		{
			if (RelationshipOf(attacker, ENT_ME) == "enemy")
				blockPrematureDamage = true;
			if (IsPlayer(attacker))
				blockPrematureDamage = true;
			if (blockPrematureDamage)
				result = AppendResult(result, "0");
		}
		return result;
	}

	// attempt_spawn
	void HorrorEgg_OnAttemptSpawn()
	{
		// set spawn org
		Vector3 myOrg = MyOrigin();
		string spawnOrg = Text(myOrg);
		spawnOrg = Text(Vec(spawnOrg) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 20)));

		// make sure there is space to spawn horror
		bool isRoom = true;
		// - x
		string traceStart = spawnOrg;
		string traceEnd = spawnOrg;
		traceStart = Text(Vec(traceStart) + RelativePosition(Vector3(0, 0, 0), Vector3(-SCAN_SIZE, 0, 0)));
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(SCAN_SIZE, 0, 0)));
		string traceWorld = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugBeam(traceStart, traceEnd);
		// //dbg TRACE_WORLD vs TRACE_END
		if (traceEnd != traceWorld)
			isRoom = false;

		// - y
		traceStart = spawnOrg;
		traceEnd = spawnOrg;
		traceStart = Text(Vec(traceStart) + RelativePosition(Vector3(0, 0, 0), Vector3(0, -SCAN_SIZE, 0)));
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, SCAN_SIZE, 0)));
		traceWorld = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugBeam(traceStart, traceEnd);
		// //dbg TRACE_WORLD vs TRACE_END
		if (traceEnd != traceWorld)
			isRoom = false;

		// - z
		traceStart = spawnOrg;
		traceEnd = spawnOrg;
		traceStart = Text(Vec(traceStart) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -10)));
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 30)));
		traceWorld = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugBeam(traceStart, traceEnd);
		// //dbg TRACE_WORLD vs TRACE_END
		if (traceEnd != traceWorld)
			isRoom = false;

		int inSphere = Int(LegacyFunction("get_insphere", "any", 45, spawnOrg));
		if (inSphere != 0)
		{
			// dbg Sphere struck NPC
			bool inRoom = false;
		}

		if (!isRoom)
		{
			FAILED_HATCH += 1.0f;
			// dbg failed_to_hatch(no_room) FAILED_HATCH
			if (FAILED_HATCH > 9.0f)
			{
				// dbg Ten failed hatch attempts, assuming off map
				OnGameDeath(); // assume spawned off map
			}
			OnBounceAbout();
			CallEventDelayed(5.0f, "attempt_spawn");
		}
		if (!isRoom)
			return;

		OnHatchEgg();
	}

	// scan_bounce
	void HorrorEgg_OnScanBounce()
	{
		CallEventDelayed(0.2f, "scan_bounce");
		float myZvel = Vec(Eval("game.monster.velocity")).z;
		// //dbg MY_ZVEL
		if (!(myZvel < 0.0f))
			return;

		Vector3 traceStart = MyOrigin() + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 0));
		string traceEnd = Text(traceStart);
		traceEnd = Text(Vec(traceEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, -50)));
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (Truthy(GetVar("G_DEVELOPER_MODE")))
			OnDebugBeam(Text(traceStart), traceEnd);
		if (traceLine != traceEnd)
			PlaySound(0, 10, "weapons/g_bounce1.wav");
	}

	// bounce_about
	void HorrorEgg_OnBounceAbout()
	{
		// no room, toss in random dir
		int tossDir = RandomInt(-200, 200);
		int tossHor = RandomInt(-200, 200);
		int tossVer = RandomInt(-400, 600);
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(tossDir, tossHor, tossVer)));
	}

	// game_struck
	void HorrorEgg_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		OnBounceAbout();
	}

	// hatch_egg
	void HorrorEgg_OnHatchEgg()
	{
		// tempent gibs <modelname/spritename> <position> <size> <velocity> <randomness> <amount> <duration>
		Effect("tempent", "gibs", "monsters/egg.mdl", RelativePosition(Vector3(0, 0, 0)), 0.1f, 100, 30, 2, 4);
		PlaySound(0, 10, SOUND_HATCH);
		CreateNpc(EGG_SCRIPT, RelativePosition(Vector3(0, 0, 20)), MY_OWNER);
		DeleteEntity(ENT_ME);
	}

	// debug_beam
	// <(start)> [(end)] [color] (if no [end] given, makes beam 64 units straight up)
	void HorrorEgg_OnDebugBeam(string startPosition = "", string endPosition = "", string beamColor = "")
	{
		string beamColorValue = "BEAM_COLOR";
		string beamEnd = "BEAM_END";

		if (beamColor.isEmpty())
			beamColorValue = Text(Vector3(255, 0, 255));
		if (!beamColor.isEmpty())
			beamColorValue = beamColor;
		float beamDuration = 1.0f;
		if (endPosition.isEmpty())
			beamEnd = startPosition;
		if (!endPosition.isEmpty())
			beamEnd = endPosition;
		beamEnd = Text(Vec(beamEnd) + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 64)));
		Effect("beam", "point", "laserbeam.spr", 20, startPosition, beamEnd, beamColorValue, 255, 0.7f, beamDuration);
	}

	// game_death
	void HorrorEgg_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		CallExternal(MY_OWNER, "horror_died");
		OnXpSend();

		Effect("tempent", "gibs", "monsters/egg.mdl", RelativePosition(Vector3(0, 0, 0)), 0.1f, 100, 30, 2, 4);
		PlaySound(0, 10, SOUND_HATCH);
		DeleteEntity(ENT_ME);
	}

	// xp_send
	void HorrorEgg_OnXpSend()
	{
		string monFull = Eval("game.monster.name.full");
		string outMsg = "You've slain " + monFull;
		PlayerMessageGreen(EntityOf(ENT_LASTSTRUCK), outMsg);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { HorrorEgg_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		HorrorEgg_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnGameSpawn(string playerRace = "", string playerGender = "") { HorrorEgg_OnGameSpawn(playerRace, playerGender); } // game_spawn
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return HorrorEgg_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnAttemptSpawn() { HorrorEgg_OnAttemptSpawn(); } // attempt_spawn
	void OnScanBounce() { HorrorEgg_OnScanBounce(); } // scan_bounce
	void OnBounceAbout() { HorrorEgg_OnBounceAbout(); } // bounce_about
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { HorrorEgg_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnHatchEgg() { HorrorEgg_OnHatchEgg(); } // hatch_egg
	void OnDebugBeam(string startPosition = "", string endPosition = "", string beamColor = "") { HorrorEgg_OnDebugBeam(startPosition, endPosition, beamColor); } // debug_beam
	void OnXpSend() { HorrorEgg_OnXpSend(); } // xp_send

	// This file's events and timers by their .script names
	bool HorrorEgg_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attempt_spawn") { OnAttemptSpawn(); return true; }
		if (name == "bounce_about") { OnBounceAbout(); return true; }
		if (name == "debug_beam") { OnDebugBeam(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "hatch_egg") { OnHatchEgg(); return true; }
		if (name == "scan_bounce") { OnScanBounce(); return true; }
		if (name == "xp_send") { OnXpSend(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/horror_egg"]
shared class HorrorEggScript : MonstersExternalsScript, HorrorEgg
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/egg.mdl");
		Precache("monsters/edwardgorey.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HorrorEgg_FirstThink();
		MonstersExternals_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return HorrorEgg_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
