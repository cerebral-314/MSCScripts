#pragma context server

// Converted from monsters/summon/shock_beam.script by msc_transpiler.
// Thothie - single beam of shocky goodness

#include "runtime/ScriptEntity.as"

[script "monsters/summon/shock_beam"]
class ShockBeam : ScriptEntity
{
	// Constants
	string SOUND_THUNDER = "weather/Storm_exclamation.wav";
	string SOUND_LIGHTNING = "magic/lightning_strike_replica.wav";
	string SOUND_WARNING = "magic/eraticlightfail.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	float MY_RADIUS = 0.0f;
	string MY_DURATION = "MY_DURATION";
	float MY_DAMAGE = 0.0f;
	string BEAM_COLOR = "BEAM_COLOR";
	string BEAM_DELAY = "BEAM_DELAY";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int GAME_PVP = 0;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string MY_SCRIPT = "MY_SCRIPT";
	Vector3 BEAM_START = Vector3();
	Vector3 BEAM_END = Vector3();
	bool IS_ACTIVE = false;

	// game_dodamage
	string ShockBeam_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		bool exitSub = false;
		string result = "";

		if (GAME_PVP == 0 && Truthy(OWNER_ISPLAYER) && IsPlayer(target))
			exitSub = true;
		if (exitSub)
			return result;
		if (RelationshipOf(MY_OWNER, @target) != "enemy")
			return result;

		if (HasEffect(target, "DOT_lightning"))
			return result;
		ApplyEffect(target, "effects/dot_lightning", 5.0f, MY_OWNER, MY_DAMAGE);
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_RADIUS = Float(creatorValue2);
		MY_DURATION = damage;
		MY_DAMAGE = Float(skill); // x5 seconds
		BEAM_COLOR = extraValue5;
		BEAM_DELAY = extraValue6;

		OWNER_ISPLAYER = Text(IsPlayer(creatorValue1));
		GAME_PVP = (IsPvp() ? 1 : 0);

		if (BEAM_COLOR.isEmpty())
			BEAM_COLOR = Text(Vector3(255, 255, 0));
		float fDuration = Float(MY_DURATION);
		if (!BEAM_DELAY.isEmpty())
			fDuration += Float(BEAM_DELAY);

		CallEventDelayed(fDuration, "end_effect");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetInvincible(true);
		PLAYING_DEAD = "1";
		CallEventDelayed(0.1f, "make_thunder");
	}

	// make_thunder
	void OnMakeThunder()
	{
		MY_SCRIPT = LastClientScriptId();

		BEAM_START = MyOrigin();
		BEAM_END = BEAM_START;
		BEAM_END.z = SkyHeight(BEAM_START);

		float clDuration = Float(MY_DURATION);
		if (!BEAM_DELAY.isEmpty())
			clDuration += Float(BEAM_DELAY);
		if (BEAM_DELAY.isEmpty())
		{
			// instant beam
			OnMakeLightning();
		}
		if (!BEAM_DELAY.isEmpty())
		{
			// beam with warning
			CallEventOrDelay(BEAM_DELAY, "make_lightning");
			PlaySound(0, 10, SOUND_WARNING);
		}
		ClientEvent("new", "all", "monsters/summon/shock_beam", BEAM_START, BEAM_COLOR, MY_RADIUS, clDuration);
	}

	// make_lightning
	void OnMakeLightning()
	{
		PlaySound(0, 10, SOUND_LIGHTNING);
		Effect("beam", "point", "lgtning.spr", 200, BEAM_START, BEAM_END, BEAM_COLOR, 255, 100, MY_DURATION);
		IS_ACTIVE = true;
		CallEventDelayed(0.1f, "more_noise");
		OnDamageLoop();
	}

	// more_noise
	void OnMoreNoise()
	{
		PlaySound(0, 10, SOUND_THUNDER);
	}

	// damage_loop
	void OnDamageLoop()
	{
		if (!IS_ACTIVE)
			return;
		DoDamage(Text(RelativePosition(Vector3(0, 0, 0))), MY_RADIUS, 0.0f, "100%", 0.0f, "reflective", "target");
		CallEventDelayed(0.25f, "damage_loop");
	}

	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "") { return ShockBeam_OnGameDodamage(hit, target, start, end, damageType, damageText); } // game_dodamage

	// end_effect
	void OnEndEffect()
	{
		IS_ACTIVE = false;
		ClientEvent("remove", "all", MY_SCRIPT);
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBeamDelay() {} // BEAM_DELAY
	void OnFDuration() {} // F_DURATION

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "end_effect") { OnEndEffect(); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "make_lightning") { OnMakeLightning(); return true; }
		if (name == "make_thunder") { OnMakeThunder(); return true; }
		if (name == "more_noise") { OnMoreNoise(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
