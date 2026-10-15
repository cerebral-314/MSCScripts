#pragma context server

// Converted from monsters/summon/shock_burst_child.script by msc_transpiler.
// Since AOE dodamage calls seem to have to be LOS from caller, trying this bit to see if can work around

#include "runtime/ScriptEntity.as"

[script "monsters/summon/shock_burst_child"]
class ShockBurstChild : ScriptEntity
{
	// Constants
	string SOUND_SHOCK = "debris/zap1.wav";

	// Variables (an unset .script variable reads as its own name)
	string CMY_OWNER = "CMY_OWNER";
	string CMY_DMG = "CMY_DMG";
	string N_CREATED = "N_CREATED";
	int PVP_MODE = 0;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool DELAY_SOUND = false;

	// game_dynamically_created
	// <owner> <dmg>
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		CMY_OWNER = creatorValue1;
		CMY_DMG = creatorValue2;
		N_CREATED = damage;

		PVP_MODE = (IsPvp() ? 1 : 0);
		OWNER_ISPLAYER = Text(IsPlayer(CMY_OWNER));

		float activeDelay = 1.0f + Float(N_CREATED);

		IS_ACTIVE = true;
		CallEventDelayed(activeDelay, "scan_loop");
		LegacyCommand("storeentity", ENT_EXPOWNER, CMY_OWNER);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Blast Bolt");
		SetRace("hated");
		SetHealth(1);
		SetInvincible(true);
		PLAYING_DEAD = "1";
	}

	// set_active
	void OnSetActive()
	{
		IS_ACTIVE = true;
	}

	// scan_loop
	void OnScanLoop()
	{
		bool exitSub = false;

		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.23f, "scan_loop");

		string hitTarg = FindOneInSphere("any", 64);

		if (RelationshipOf(hitTarg, CMY_OWNER) != "enemy")
			return;

		if (Truthy(OWNER_ISPLAYER))
		{
			// no pvp damage outside pvp
			if (PVP_MODE == 0 && IsPlayer(hitTarg))
				exitSub = true;
		}
		if (exitSub)
			return;

		ApplyEffect(hitTarg, "effects/dot_lightning", 5, CMY_OWNER, CMY_DMG);
		if (DELAY_SOUND)
			return;
		DELAY_SOUND = true;
		CallEventDelayed(2.0f, "reset_delay_sound");
		PlaySound(0, 10, SOUND_SHOCK);
	}

	// reset_delay_sound
	void OnResetDelaySound()
	{
		DELAY_SOUND = false;
	}

	// debug_beam
	// <(start)> [end] [color]
	void OnDebugBeam(string startPosition = "", string endPosition = "", string beamColor = "")
	{
		string beamColorValue = "BEAM_COLOR";
		string beamEnd = "BEAM_END";

		// if [end] not provided, draws a 64 unit beam straight up
		// if [color] no provided, beam is purple
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

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnActiveDelay() {} // ACTIVE_DELAY

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debug_beam") { OnDebugBeam(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "reset_delay_sound") { OnResetDelaySound(); return true; }
		if (name == "scan_loop") { OnScanLoop(); return true; }
		if (name == "set_active") { OnSetActive(); return true; }
		return false;
	}
}
