#pragma context server

// Converted from monsters/summon/shock_burst_two.script by msc_transpiler.
// old one is crashing, trying this method via re-write

#include "runtime/ScriptEntity.as"

[script "monsters/summon/shock_burst_two"]
class ShockBurstTwo : ScriptEntity
{
	// Constants
	string SOUND_THUNDER = "weather/Storm_exclamation.wav";
	int BOLT_HEIGHT = 512;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	float MY_RADIUS = 0.0f;
	string NUM_BOLTS = "NUM_BOLTS";
	string BEAM_COLOR = "BEAM_COLOR";
	string BEAM_WIDTH = "BEAM_WIDTH";
	int GAME_PVP = 0;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float ANG_ADJ = 0.0f;
	float CUR_RAD = 0.0f;
	float CUR_ANG = 0.0f;
	float BOLTS_DEFINED = 0.0f;
	float BOLT_INC = 0.0f;
	float BOLT_ANG = 0.0f;
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	string BOLT_LIST = "BOLT_LIST";
	string HIT_TARG = "HIT_TARG";
	bool DELAY_SOUND = false;

	// game_dynamically_created
	// <owner> <dmg> <radius> <#bolts> [beam_color] [beam_width]
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		MY_RADIUS = Float(damage);
		NUM_BOLTS = skill;
		BEAM_COLOR = extraValue5;
		BEAM_WIDTH = extraValue6;

		GAME_PVP = (IsPvp() ? 1 : 0);

		if (BEAM_COLOR.isEmpty())
			BEAM_COLOR = Text(Vector3(255, 255, 0));
		if (BEAM_WIDTH.isEmpty())
			BEAM_WIDTH = "200";

		// dbg incvars $get(MY_OWNER,name) dmg MY_DMG rad MY_RADIUS nbolts NUM_BOLTS
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);
		SetRace(RaceOf(MY_OWNER));

		ANG_ADJ = Divide(359.0f, Float(NUM_BOLTS));

		CUR_RAD = 5.0f;
		CUR_ANG = 0.0f;
		BOLTS_DEFINED = 0.0f;

		BOLT_INC = Divide(359.0f, Float(NUM_BOLTS));
		BOLT_ANG = 0.0f;
		int count = Int(NUM_BOLTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDefineBolts();
		}

		IS_ACTIVE = true;
		OnRotateBolts();
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Blast");
		SetHealth(1);
		SetInvincible(true);
		PLAYING_DEAD = "1";

		PlaySound(0, 10, SOUND_THUNDER);
	}

	// define_bolts
	void OnDefineBolts()
	{
		BOLT_LIST = TokenAdd(BOLT_LIST, Text(BOLT_ANG));
		BOLT_ANG += BOLT_INC;
	}

	// rotate_bolts
	void OnRotateBolts()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "rotate_bolts");
		CUR_RAD += 2.0f;
		CUR_ANG += 5.0f;
		int count = Int(NUM_BOLTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnDrawBolts();
		}
		if (CUR_RAD >= MY_RADIUS)
			OnEndSummon();
	}

	// draw_bolts
	void OnDrawBolts()
	{
		int curBolt = loopIteration;
		float boltAng = Float(GetToken(BOLT_LIST, curBolt));
		boltAng += CUR_ANG;
		Vector3 boltStart = MyOrigin() + RelativePosition(Vector3(0, boltAng, 0), Vector3(0, CUR_RAD, 0));
		string boltEnd = Text(boltStart);
		boltEnd = Text(Vec(boltEnd) + Vector3(0.0f, 0.0f, BOLT_HEIGHT));
		Effect("beam", "point", "lgtning.spr", BEAM_WIDTH, boltStart, boltEnd, BEAM_COLOR, 255, 100, 0.1f);
		HIT_TARG = LegacyFunction("get_insphere", "any", 64, boltStart);
		if (Text(IsAlive("HIT_TARGET")) != "check_targ")
			return;
	}

	// end_summon
	void OnEndSummon()
	{
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// check_targ
	void OnCheckTarg2()
	{
		bool exitSub = false;
		if (RelationshipOf(MY_OWNER, HIT_TARG) != "enemy")
			return;
		if (Truthy(OWNER_ISPLAYER) && IsPlayer(HIT_TARG) && GAME_PVP < 1)
			exitSub = true;
		if (exitSub)
			return;

		OnShockTarg();
	}

	// shock_targ
	void OnShockTarg()
	{
		ApplyEffect(HIT_TARG, "effects/dot_lightning", 5, MY_OWNER, MY_DMG);
		if (DELAY_SOUND)
			return;
		DELAY_SOUND = true;
		CallEventDelayed(2.0f, "reset_delay_sound");
		CallExternal("ext_playsound", "SOUND_SHOCK");
	}

	// reset_delay_sound
	void OnResetDelaySound()
	{
		DELAY_SOUND = false;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "check_targ") { OnCheckTarg2(); return true; }
		if (name == "define_bolts") { OnDefineBolts(); return true; }
		if (name == "draw_bolts") { OnDrawBolts(); return true; }
		if (name == "end_summon") { OnEndSummon(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reset_delay_sound") { OnResetDelaySound(); return true; }
		if (name == "rotate_bolts") { OnRotateBolts(); return true; }
		if (name == "shock_targ") { OnShockTarg(); return true; }
		return false;
	}
}
