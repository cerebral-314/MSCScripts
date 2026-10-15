#pragma context server

// Converted from effects/gib_explode.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GibExplode
{
	// Constants
	string GIB_INFLICTER = "GIB_INFLICTER";
	int EXPLODE_RADIUS = 200;

	// Variables (an unset .script variable reads as its own name)
	string FX_OWNER = "FX_OWNER";
	string FX_DAMAGE = "FX_DAMAGE";
	string FX_SKILL = "FX_SKILL";
	string FX_BLOOD_COLOR = "FX_BLOOD_COLOR";

	// game_spawn
	// Throws a bouncing exploding gib. Takes owner, velocity, damage, and blood color.
	void GibExplode_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		SetRace("beloved");

		SetGravity(0.75f);

		SetHeight(10);
		SetWidth(10);

		SetProp(ENT_ME, "movetype", 10);
		SetProp(ENT_ME, "friction", 0.4f); // Just reduces bounce factor, doesnt reduce velocity if gliding on ground
		SetProp(ENT_ME, "solid", 0);
		SetAngle("face", Vector3(RandomInt(0, 359), RandomInt(0, 359), RandomInt(0, 359))); // Sets a random angle when thrown. Gets set again by the game when it hits the ground, makes for a nice effect
	}

	// game_dynamically_created
	// <owner> <velocity> <damage> <skill> <"green"|"red">
	void GibExplode_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		FX_OWNER = creatorValue1;
		SetVelocity(ENT_ME, Vec(creatorValue2));
		FX_DAMAGE = damage;
		FX_SKILL = skill;
		FX_BLOOD_COLOR = extraValue5;

		// Check the blood color and set appropriate model chunks and colors
		if (FX_BLOOD_COLOR == "green") // If green, set to green
		{
			SetModel("agibs.mdl");
			SetModelBody(0, RandomInt(0, 3)); // Random body
		}
		else
		{
			// In any other case, set to red.
			SetModel(GetRandomToken("gib_b_bone.mdl;gib_b_gib.mdl;gib_lung.mdl;gib_legbone.mdl"));
		}

		CallEventDelayed(Random(1, 2.4f), "stop_bounce");
		CallEventDelayed(Random(2.5f, 3.5f), "explode");
	}

	// explode
	void GibExplode_OnExplode()
	{
		string sound = "leech/leech_bite" + RandomInt(1, 2) + ".wav";
		PlaySound(0, 10, sound);
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(OriginOf(ENT_ME), EXPLODE_RADIUS, FX_DAMAGE, 0, FX_OWNER, GIB_INFLICTER, FX_SKILL, "dark", "dmgevent:*gib");
		ClientEvent("new", "all", "effects/swords_gb/sfx_gib_explode", OriginOf(ENT_ME), FX_BLOOD_COLOR);

		SetModel("null.mdl"); // Takes a whole frame to get deleted, so set invisible
		CallEventDelayed(0.1f, "remove_fx"); // delayed removal so gib_dodamage can do its thing
	}

	// remove_fx
	void GibExplode_OnRemoveFx()
	{
		DeleteMe();
	}

	// stop_bounce
	// Sets the movetype to something thatll make it stop gliding around
	void GibExplode_OnStopBounce()
	{
		SetProp(ENT_ME, "movetype", 13);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { GibExplode_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { GibExplode_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnExplode() { GibExplode_OnExplode(); } // explode
	void OnRemoveFx() { GibExplode_OnRemoveFx(); } // remove_fx
	void OnStopBounce() { GibExplode_OnStopBounce(); } // stop_bounce

	// This file's events and timers by their .script names
	bool GibExplode_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "explode") { OnExplode(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_fx") { OnRemoveFx(); return true; }
		if (name == "stop_bounce") { OnStopBounce(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "effects/gib_explode"]
shared class GibExplodeScript : ScriptEntity, GibExplode
{
	// Variables every script that includes this file declares
	string SWORD_ID = "SWORD_ID";

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
		return GibExplode_DispatchEvent(name, params);
	}
}
