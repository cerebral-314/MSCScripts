#pragma context server

// Converted from monsters/companion/dridje.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/companion/dridje"]
class Dridje : ScriptEntity
{
	// Constants
	float FREQ_ROTATE = 0.1f;
	float FREQ_ZAP = 0.0f;
	int ROAM_DISTANCE = 28;
	bool ROAM_HEIGHT = false;
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart15.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string PLAYING_DEAD = "PLAYING_DEAD";
	float CUR_ROT = 0.0f;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	bool SPAWN_ZAP = false;

	// unnamed block (timer)
	void Dridje_Timer()
	{
		CallEventDelayed(FREQ_ZAP, "Dridje_Timer");
		OnZapDridje(MY_OWNER);
	}

	// unnamed block (timer)
	void Dridje_Timer2()
	{
		CallEventDelayed(FREQ_ROTATE, "Dridje_Timer2");
		Vector3 destPos = OriginOf(MY_OWNER);
		CUR_ROT += 5.0f;
		if (CUR_ROT > 359.0f)
			CUR_ROT -= 359.0f;
		destPos += RelativePosition(Vector3(0, CUR_ROT, 0), Vector3(0, ROAM_DISTANCE, (ROAM_HEIGHT ? 1.0f : 0.0f)));
		SetOrigin(ENT_ME, destPos);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("The Mighty Sphere of Dridje");
		SetUniqueName("dridje_sphere");
		LegacyCommand("blind", 1);
		SetFly(true);
		SetInvincible(true);
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 13);
		SetSolid("none");
		SetBoundingBox("none");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 64);
		CatchSpeech("zap_dridje", "zap");
		CatchSpeech("go_away", "vanish", "go away");
		PLAYING_DEAD = "1";
		SetIdleAnim("spin_horizontal_norm");

		CUR_ROT = 0.0f;

		ClientEvent("persist", "all", "monsters/companion/dridje", IndexOf(ENT_ME));
		MY_LIGHT_SCRIPT = LastClientScriptId();
		SPAWN_ZAP = true;
		CallEventDelayed(0.1f, "zap_dridje");
	}

	// go_away
	void OnGoAway()
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		// playsound 2 0 ambience/alien_beacon.wav
		SayText("Yes, my master...");
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// zap_dridje
	void OnZapDridje(string caster = "")
	{
		bool zapGo = false;
		if (caster == MY_OWNER)
			zapGo = true;
		if (EntityId(EntityOf(ENT_LASTSPOKE)) == MY_OWNER && caster != MY_OWNER)
		{
			SayText("Yes master...");
			zapGo = true;
		}
		if (SPAWN_ZAP)
		{
			SPAWN_ZAP = false;
			zapGo = true;
		}
		// playsound 2 3 ambience/alien_beacon.wav
		if (!zapGo)
			return;
		Effect("beam", "ents", "lgtning.spr", 20, ENT_ME, 0, MY_OWNER, 1, Vector3(255, 255, 0), 200, 200, 3.0f);
		Effect("beam", "ents", "lgtning.spr", 20, ENT_ME, 0, MY_OWNER, 2, Vector3(255, 255, 0), 200, 200, 3.0f);
		SetModelBody(0, 16);
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
		Effect("glow", MY_OWNER, Vector3(255, 255, 0), 128, 8.0f, 10.0f);
		CallEventDelayed(2.0f, "zap_down");
	}

	// zap_down
	void OnZapDown()
	{
		SetModelBody(0, 13);
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(FREQ_ZAP, "Dridje_Timer");
		CallEventDelayed(FREQ_ROTATE, "Dridje_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "go_away") { OnGoAway(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "zap_down") { OnZapDown(); return true; }
		if (name == "zap_dridje") { OnZapDridje(Param(params, 0)); return true; }
		if (name == "Dridje_Timer") { Dridje_Timer(); return true; }
		if (name == "Dridje_Timer2") { Dridje_Timer2(); return true; }
		return false;
	}
}
