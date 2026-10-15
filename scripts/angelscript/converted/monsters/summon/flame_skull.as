#pragma context server

// Converted from monsters/summon/flame_skull.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

[script "monsters/summon/flame_skull"]
class FlameSkull : ScriptEntity
{
	// Constants
	string SOUND_SCREAM = "magic/spookie1.wav";
	string SOUND_FIRE = "magic/fireball_strike.wav";
	string SOUND_START = "magic/volcano_start.wav";
	string SOUND_LOOP = "magic/volcano_loop.wav";
	float FREQ_SOUND = 3.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float DMG_BASE = 0.0f;
	float MY_RADIUS = 0.0f;
	string ACTIVE_SKILL = "ACTIVE_SKILL";
	int GAME_PVP = 0;
	Vector3 START_POS = Vector3();
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float FLY_COUNT = 0.0f;
	float ROT_COUNT = 0.0f;
	bool IS_FLYING = false;
	string MY_SCRIPT_ID = "MY_SCRIPT_ID";
	string PLAYING_DEAD = "PLAYING_DEAD";
	bool SOUND_DELAY = false;
	CBaseEntity@ LAST_BURNED = null;

	// unnamed block (first think)
	void FlameSkull_FirstThink()
	{
		SetCallback("touch", "enable");
	}

	// game_touch
	string FlameSkull_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";
		// dbg game_touch PARAM1
		if (HasEffect(other, "DOT_fire"))
			return result;
		if (other is LAST_BURNED)
			return result;
		if (RelationshipOf(other, MY_OWNER) != "enemy")
			return result;
		ApplyEffect(other, "effects/dot_fire", 5.0f, MY_OWNER, DMG_BASE, ACTIVE_SKILL);
		@LAST_BURNED = other;
		return result;
	}

	// unnamed block (timer)
	void FlameSkull_Timer()
	{
		CallEventDelayed(4.4f, "FlameSkull_Timer");
		if (!IS_FLYING)
			return;
		PlaySound(1, 10, SOUND_SCREAM);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		DMG_BASE = Float(creatorValue2);
		MY_RADIUS = Float(damage);
		ACTIVE_SKILL = skill;
		if (ACTIVE_SKILL.isEmpty())
			ACTIVE_SKILL = "spellcasting.fire";

		GAME_PVP = (IsPvp() ? 1 : 0);

		START_POS = OriginOf(MY_OWNER);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		if (!Truthy(OWNER_ISPLAYER))
		{
			float ownerHeight = Divide(HeightOf(MY_OWNER), 2.0f);
			START_POS += RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, ownerHeight));
		}

		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);

		FLY_COUNT = 0.0f;
		ROT_COUNT = 0.0f;
		IS_FLYING = true;

		ClientEvent("new", "all", "monsters/summon/flame_skull", IndexOf(ENT_ME));
		MY_SCRIPT_ID = LastClientScriptId();

		CallEventDelayed(0.1f, "skull_fly");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Flaming Skull");
		SetHealth(1);
		SetRace("beloved");
		PLAYING_DEAD = "1"; // not a valid target
		SetInvincible(true);
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 12);
		SetSolid("trigger");
		SetWidth(32);
		SetHeight(32);
		SetGravity(0);
		SetFly(true);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);

		ServerPlaySound(2, 10, SOUND_LOOP);

		DebugPrint("Spawned Flaming Skull");
	}

	// skull_fly
	void OnSkullFly()
	{
		if (!IS_FLYING)
			return;
		CallEventDelayed(0.1f, "skull_fly");

		FLY_COUNT += 1.0f;
		ROT_COUNT += 10.0f;

		if (FLY_COUNT >= MY_RADIUS)
			OnEndFlight();
		if (ROT_COUNT > 359.0f)
			ROT_COUNT -= 359.0f;

		Vector3 newPos = START_POS;
		newPos += RelativePosition(Vector3(0, ROT_COUNT, 0), Vec(LegacyFunction("vece", 0, FLY_COUNT, 0)));
		SetOrigin(ENT_ME, newPos);
		SetAngle("face", Vector3(0, ROT_COUNT, 0));

		// callevent aoe_applyeffect_rad
		if (SOUND_DELAY)
			return;
		SOUND_DELAY = true;
		CallEventDelayed(FREQ_SOUND, "sound_delay_reset");
		PlaySound(0, 10, SOUND_START);
		Effect("screenshake", RelativePosition(Vector3(0, 0, 0)), 200, 200, 2, 128);
	}

	// end_flight
	void OnEndFlight()
	{
		IS_FLYING = false;
		SetProp(ENT_ME, "renderamt", 0);
		// attempting to kill ambient
		ServerPlaySound(2, 0, SOUND_LOOP);
		ClientEvent("remove", "all", MY_SCRIPT_ID);
		CallEventDelayed(1.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// sound_delay_reset
	void OnSoundDelayReset()
	{
		SOUND_DELAY = true;
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return FlameSkull_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqSound() {} // FREQ_SOUND

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("magic/volcano_loop.wav");
		CallEventDelayed(4.4f, "FlameSkull_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		FlameSkull_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "end_flight") { OnEndFlight(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "skull_fly") { OnSkullFly(); return true; }
		if (name == "sound_delay_reset") { OnSoundDelayReset(); return true; }
		if (name == "FlameSkull_Timer") { FlameSkull_Timer(); return true; }
		return false;
	}
}
