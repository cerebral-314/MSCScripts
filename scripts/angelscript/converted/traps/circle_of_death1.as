#pragma context server

// Converted from traps/circle_of_death1.script by msc_transpiler.
// circle trap requires addparams:
// dps;duration
// if dps is auto, 10% of avghp
// if duration <= 0, infinite until spawner removed
// duration should be divisible by 20

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class CircleOfDeath1
{
	// Constants
	float CIRCLE_RAD = 90.0f;
	int CL_BODY = 3;
	int CL_RAD = 98;
	string CIRCLE_DMG_TYPE = "dark_effect";
	string SOUND_LOOP = "ambience/pulsemachine.wav";

	// Variables (an unset .script variable reads as its own name)
	bool IS_ACTIVE = true;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string DMG_PULSE = "DMG_PULSE";
	float CIRCLE_END = 0.0f;
	float CL_DUR = 0.0f;
	bool NPC_DIE_ON_SPAWN_REMOVAL = false;
	Vector3 CIRCLE_POS = Vector3();
	string CL_IDX = "CL_IDX";
	float NEXT_CL_UPDATE = 0.0f;
	bool NPC_OVERRIDE_DEATH = false;
	bool NPC_QUED_FOR_DEATH = false;
	float SKEL_RESPAWN_TIMES = 0.0f;

	// game_spawn
	void CircleOfDeath1_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Circle of Death");
		SetInvincible(true);
		SetNoPush(true);
		SetSolid("none");
		SetBoundingBox("none");
		SetRace("undead");
		PLAYING_DEAD = "1";
		IS_ACTIVE = true;
		CallEventDelayed(0.5f, "circle_loop");
	}

	// game_postspawn
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void CircleOfDeath1_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		bool autoSet = false;
		if (int(params.length()) < 2)
			autoSet = true;
		if (params.isEmpty())
			autoSet = true;

		// variables not set, default to 10 seconds and auto damage
		if (autoSet)
		{
			DMG_PULSE = "auto";
			CIRCLE_END = 10.0f;
		}
		else
		{
			DMG_PULSE = GetToken(params, 0);
			CIRCLE_END = Float(GetToken(params, 1));
		}

		DebugPrint("game_postspawn " + Text(autoSet) + " " + DMG_PULSE + " " + Text(CIRCLE_END));

		if (CIRCLE_END <= 0.0f)
			CIRCLE_END = 9999.0f;
		CL_DUR = CIRCLE_END;
		CIRCLE_END += GameTime();
		NPC_DIE_ON_SPAWN_REMOVAL = true;
	}

	// game_dynamically_created
	void CircleOfDeath1_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		DMG_PULSE = "auto";
		CIRCLE_END = 10.0f;
		CL_DUR = CIRCLE_END;
		CIRCLE_END += GameTime();
	}

	// circle_loop
	void CircleOfDeath1_OnCircleLoop()
	{
		if (IS_ACTIVE)
			CallEventDelayed(1.0f, "circle_loop");
		if (!IsAlive(ENT_ME))
			return;

		float dmgPulse = Float(DMG_PULSE);
		if (DMG_PULSE == "auto")
		{
			dmgPulse = Float(Eval("game.players.totalhp"));
			dmgPulse = Divide(dmgPulse, PlayerCount());
			dmgPulse *= 0.1f;
			DebugPrint("circle_loop auto " + Text(dmgPulse) + " " + Text(CIRCLE_POS));
		}

		Vector3 dmgPoint = CIRCLE_POS;
		dmgPoint.z += 32.0f;

		DoDamageEx(dmgPoint, CIRCLE_RAD, dmgPulse, 0, ENT_ME, ENT_ME, "none", CIRCLE_DMG_TYPE);

		if (GameTime() > CIRCLE_END)
		{
			OnNpcSuicide();
		}
		else if (GameTime() > NEXT_CL_UPDATE)
		{
			ServerPlaySound(1, 10, SOUND_LOOP);
			CIRCLE_POS = OriginOf(ENT_ME);
			CIRCLE_POS.z = GroundHeight(CIRCLE_POS);
			ClientEvent("persist", "all", "effects/sfx_cod", CIRCLE_POS, CL_DUR, CL_BODY, CL_RAD);
			CL_IDX = LastClientScriptId();
			NEXT_CL_UPDATE = GameTime() + CL_DUR;
		}
	}

	// game_death
	void CircleOfDeath1_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		IS_ACTIVE = false;
		ClientEvent("update", "all", CL_IDX, "end_fx");
		ServerPlaySound(1, 0, SOUND_LOOP);
	}

	// npc_suicide
	// from monsters/externals
	void CircleOfDeath1_OnNpcSuicide(string suicideMode = "")
	{
		bool exitSub = false;

		if (!IsAlive(ENT_ME))
			return;
		// (always true here) if !I_R_COMPANION

		float sinceSpawn = GameTime() - 0.0f;

		// if ( NPC_QUED_FOR_DEATH ) local PARAM1 dienow
		if (sinceSpawn < 2.0f)
		{
			if (suicideMode == "dienow")
			{
				SetAnimFrameRate(0);
				SetAnimMoveSpeed(0);
				NPC_OVERRIDE_DEATH = true;
				DeleteEntity(ENT_ME, "fade");
				exitSub = true;
			}
			else
			{
				NPC_QUED_FOR_DEATH = true;
				CallEventDelayed(2.1f, "npc_suicide");
				DebugPrint("npc_suicide - not_ready_to_die - qued for death");
				exitSub = true;
			}
		}
		if (exitSub)
			return;

		if (suicideMode == "no_pets")
		{
			// (never true here, the rest is skipped) if I_R_PET
		}

		if (suicideMode == "only_bad")
		{
			if (RaceOf(ENT_ME) == "human")
				exitSub = true;
			if (RaceOf(ENT_ME) == "hguard")
				exitSub = true;
			if (RaceOf(ENT_ME) == "beloved")
				exitSub = true;
		}
		if (exitSub)
			return;

		SetInvincible(false);
		SetRace("hated");
		SKEL_RESPAWN_TIMES = 99.0f;
		DoDamage(ENT_ME, "direct", 99999, 100, GetVar("GAME_MASTER"), "target");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { CircleOfDeath1_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "") { CircleOfDeath1_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); } // game_postspawn
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "") { CircleOfDeath1_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); } // game_dynamically_created
	void OnCircleLoop() { CircleOfDeath1_OnCircleLoop(); } // circle_loop
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { CircleOfDeath1_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnNpcSuicide(string suicideMode = "") { CircleOfDeath1_OnNpcSuicide(suicideMode); } // npc_suicide

	// This file's events and timers by their .script names
	bool CircleOfDeath1_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "circle_loop") { OnCircleLoop(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "traps/circle_of_death1"]
shared class CircleOfDeath1Script : DebugScript, CircleOfDeath1
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("ambience/pulsemachine.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return CircleOfDeath1_DispatchEvent(name, params)
			|| DebugScript::DispatchEvent(name, params);
	}
}
