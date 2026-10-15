#pragma context server

// Converted from monsters/summon/summon_volcano.script by msc_transpiler.
// Rewriting a good portion of this. T'is an old script and thus was fucked in strange ways. //greatguys1@FEB2022
// Thothie - Reduced level of Volcano to something obtainable
// - (This script has been  effed with waaay too much. ^_^
// Volcano

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SummonVolcano
{
	// Constants
	string MODEL_WORLD = "misc/volcano.mdl";
	string SOUND_SHOOT = "magic/flamelick_cast.wav";
	float FIREBALL_FREQ = 0.27f;
	float AOE_FREQ = 1.0f;
	string AOE_RADIUS = "32";
	int ANGLE_OFFSET = 60;
	int FORCE_OFFSET = 70;
	int ROCK_START_HEIGHT = 40;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	string MY_OWNER = "MY_OWNER";
	string FIREBALL_DMG = "FIREBALL_DMG";
	float AOE_DMG = 0.0f;
	string EFFECT_DURATION = "EFFECT_DURATION";
	string CAST_BY_PLAYER = "CAST_BY_PLAYER";
	string FX_IDX = "FX_IDX";
	bool ERUPTING = false;
	string FUNC_ROCKSPAWN_ORIGIN = "FUNC_ROCKSPAWN_ORIGIN";

	// unnamed block (first think)
	void SummonVolcano_FirstThink()
	{
		ANIM_DEATH = "down"; // for base_npc
	}

	// game_precache
	void SummonVolcano_OnGamePrecache()
	{
	}

	// game_spawn
	void SummonVolcano_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("volcano");
		SetHealth(1500);
		SetInvincible(true); // screw it, it has 1500pts anyways - and ya don't want it to report attacks against itself
		SetRace("beloved");

		SetWidth(32);
		SetHeight(64);
		SetSolid("none"); // doesnt trap monsters/players inside of it

		SetRoam(false);
		SetHearingSensitivity(0);

		SetModel(MODEL_WORLD);
		PlayAnim("hold", "up");

		CallEventDelayed(2.0f, "volcano_start"); // Start erupting after a delay
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 50, 10, 6, 512);
	}

	// game_dynamically_created
	// PARAM1=owner PARAM2=IntendedDmg PARAM3=Duration
	void SummonVolcano_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		// please balance from magic hand end
		MY_OWNER = creatorValue1;
		FIREBALL_DMG = creatorValue2;
		AOE_DMG = Float(FIREBALL_DMG) * 0.12f; // Damage is based on a ratio of FIREBALL_DMG, which is got from a dynamic spawn param
		EFFECT_DURATION = damage;

		CAST_BY_PLAYER = Text(IsPlayer(MY_OWNER));

		// Setup client fx
		ClientEvent("new", "all", "monsters/summon/summon_volcano", IndexOf(ENT_ME), EFFECT_DURATION);
		FX_IDX = LastClientScriptId();

		CallEventOrDelay(EFFECT_DURATION, "volcano_off"); // Die after a delay
	}

	// volcano_start
	// Start shooting
	void SummonVolcano_OnVolcanoStart()
	{
		ERUPTING = true;

		// emitsound ent_me $get(ent_me,origin) 64 EFFECT_DURATION danger 128 //This causes the fear effect and is not fun.
		ClientEvent("update", "all", FX_IDX, "fx_start");

		OnAoeLoop();
		OnFireballLoop();
	}

	// aoe_loop
	void SummonVolcano_OnAoeLoop()
	{
		if (!ERUPTING)
			return;

		OnFuncRockspawn(); // return var: FUNC_ROCKSPAWN_ORIGIN
		// <target|(src_origin)> <range|aoe|(dest_origin)|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(FUNC_ROCKSPAWN_ORIGIN, 128, AOE_DMG, 0.01f, MY_OWNER, self, "spellcasting.fire", "fire", "dmgevent:*volcano");
		CallEventDelayed(AOE_FREQ, "aoe_loop");
	}

	// fireball_loop
	void SummonVolcano_OnFireballLoop()
	{
		if (!ERUPTING)
			return;

		OnFuncRockspawn(); // return var: FUNC_ROCKSPAWN_ORIGIN
		string origin = FUNC_ROCKSPAWN_ORIGIN;

		string dir = Text(Vec(origin) + Vector3(0.0f, 0.0f, 50.0f));

		// The "cone of fire" of the projectile works better for view angles. Distribution of the fireballs using "cof" is not even, so I made my own angle offsets.
		dir = Text(Vec(dir) + Vector3(ANGLE_OFFSET * Random(-1, 1), 0.0f, 0.0f));
		dir = Text(Vec(dir) + Vector3(0.0f, ANGLE_OFFSET * Random(-1, 1), 0.0f));

		float force = 500.0f + FORCE_OFFSET * Random(-1, 1);

		// <projectile scriptname> <view|(src_origin)> <target|(targ_origin)> <speed> <damage> <cof> <skill|none>
		CallExternal(MY_OWNER, "ext_tossprojectile", "proj_volcano", origin, dir, force, FIREBALL_DMG, 0, "spellcasting.fire");

		// <channel> <volume> <filename> [Attenuation:0.8] [Pitch:100] - plays a wave, use channel 0 for auto
		PlaySound(Int(GetVar("CHAN_WEAPON")), 4, SOUND_SHOOT, 0.8f);

		CallEventDelayed(FIREBALL_FREQ, "fireball_loop");
	}

	// volcano_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end) PARAM5=DmgType PARAM6=DmgAmt
	void SummonVolcano_OnVolcanoDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!hit)
			return;
		if (!IsAlive(target))
			return;
		if (!(Float(damageText) > 0.0f))
			return;

		// Should match dot in items/proj_volcano
		float dmgFire = SkillOf(MY_OWNER, "spellcasting.fire") * 0.5f;
		ApplyEffect(target, "effects/dot_fire", 5, MY_OWNER, dmgFire, "spellcasting.fire");
	}

	// volcano_off
	void SummonVolcano_OnVolcanoOff()
	{
		ERUPTING = false;
		PlayAnim("hold", "down");
		CallEventDelayed(4.0f, "volcano_die");
	}

	// volcano_die
	// Fade out
	void SummonVolcano_OnVolcanoDie()
	{
		ClientEvent("update", "all", FX_IDX, "fx_die");
		DeleteEntity(ENT_ME, "fade");
	}

	// func_rockspawn
	// returns the origin of fireball spawn
	void SummonVolcano_OnFuncRockspawn()
	{
		Vector3 origin;

		// As of the alpha currently, $func is broken for clients. This is a workaround until I get back to making this a func.
		origin = OriginOf(ENT_ME);

		origin.z += ROCK_START_HEIGHT;

		FUNC_ROCKSPAWN_ORIGIN = Text(origin);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGamePrecache() { SummonVolcano_OnGamePrecache(); } // game_precache
	void OnGameSpawn(string playerRace = "", string playerGender = "") { SummonVolcano_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { SummonVolcano_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnVolcanoStart() { SummonVolcano_OnVolcanoStart(); } // volcano_start
	void OnAoeLoop() { SummonVolcano_OnAoeLoop(); } // aoe_loop
	void OnFireballLoop() { SummonVolcano_OnFireballLoop(); } // fireball_loop
	void OnVolcanoDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { SummonVolcano_OnVolcanoDodamage(hit, target, start, end, damageType, damageText); } // volcano_dodamage
	void OnVolcanoOff() { SummonVolcano_OnVolcanoOff(); } // volcano_off
	void OnVolcanoDie() { SummonVolcano_OnVolcanoDie(); } // volcano_die
	void OnFuncRockspawn() { SummonVolcano_OnFuncRockspawn(); } // func_rockspawn
	void OnAoeFreq() {} // AOE_FREQ
	void OnEffectDuration() {} // EFFECT_DURATION
	void OnFireballFreq() {} // FIREBALL_FREQ

	// This file's events and timers by their .script names
	bool SummonVolcano_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "aoe_loop") { OnAoeLoop(); return true; }
		if (name == "fireball_loop") { OnFireballLoop(); return true; }
		if (name == "func_rockspawn") { OnFuncRockspawn(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "volcano_die") { OnVolcanoDie(); return true; }
		if (name == "volcano_dodamage") { OnVolcanoDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "volcano_off") { OnVolcanoOff(); return true; }
		if (name == "volcano_start") { OnVolcanoStart(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/summon/summon_volcano"]
shared class SummonVolcanoScript : ScriptEntity, SummonVolcano
{
	// Variables every script that includes this file declares
	bool FIXED_VOLCANO = false;
	string VOLCANO_EXT_EVENT = "VOLCANO_EXT_EVENT";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/volcano.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SummonVolcano_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SummonVolcano_DispatchEvent(name, params);
	}
}
