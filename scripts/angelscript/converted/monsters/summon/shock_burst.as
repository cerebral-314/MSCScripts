#pragma context server

// Converted from monsters/summon/shock_burst.script by msc_transpiler.
// Lightning Burst by Thothie from Scratch
// - Odd bug, it seems only the first lightning bolt is doing damage
// - it also seems its target is pretty far off
// - I tried using dodamage, same effect, so its not a fault in $get_insphere's code

#include "runtime/ScriptEntity.as"

[script "monsters/summon/shock_burst"]
class ShockBurst : ScriptEntity
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
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float ANG_ADJ = 0.0f;
	float CUR_RAD = 0.0f;
	float CUR_ANG = 0.0f;
	float BOLTS_DEFINED = 0.0f;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float DL_ANG_ADJ = 0.0f;
	string BOLTS_STRING = "BOLTS_STRING";
	bool IS_ACTIVE = false;
	float LOOP_COUNT = 0.0f;

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

		if (BEAM_COLOR.isEmpty())
			BEAM_COLOR = Text(Vector3(255, 255, 0));
		if (BEAM_WIDTH.isEmpty())
			BEAM_WIDTH = "200";

		// dbg incvars $get(MY_OWNER,name) dmg MY_DMG rad MY_RADIUS nbolts NUM_BOLTS
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		ANG_ADJ = Divide(359.0f, Float(NUM_BOLTS));

		CUR_RAD = 5.0f;
		CUR_ANG = 0.0f;
		BOLTS_DEFINED = 0.0f;

		CallEventDelayed(0.25f, "define_bolts");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Blast");
		SetRace("hated");
		SetHealth(1);
		SetInvincible(true);
		PLAYING_DEAD = "1";
	}

	// define_bolts
	void OnDefineBolts()
	{
		if (!(BOLTS_DEFINED < Float(NUM_BOLTS)))
			return;
		BOLTS_DEFINED += 1.0f;
		if (BOLTS_DEFINED <= Float(NUM_BOLTS))
		{
			CUR_RAD += 2.0f;
			CUR_ANG += 5.0f;
			DL_ANG_ADJ += CUR_ANG;
			if (DL_ANG_ADJ > 359.0f)
				DL_ANG_ADJ -= 359.0f;
			Vector3 dboltStart = MyOrigin();
			dboltStart += RelativePosition(Vector3(0, DL_ANG_ADJ, 0), Vector3(0, CUR_RAD, 0));
			CreateNpc("monsters/summon/shock_burst_child", dboltStart, MY_OWNER, MY_DMG, BOLTS_DEFINED);
			if (BOLTS_STRING != "BOLTS_STRING")
				BOLTS_STRING = TokenAdd(BOLTS_STRING, EntityId(EntityOf(ENT_LASTCREATED)));
			if (BOLTS_STRING == "BOLTS_STRING")
				BOLTS_STRING = EntityId(EntityOf(ENT_LASTCREATED));
			CallEventDelayed(0.25f, "define_bolts");
		}

		if (BOLTS_DEFINED == Float(NUM_BOLTS))
		{
			IS_ACTIVE = true;
			OnMoveBolts();
			PlaySound(0, 10, SOUND_THUNDER);
		}
	}

	// move_bolts
	void OnMoveBolts()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.1f, "move_bolts");

		CUR_RAD += 2.0f;
		CUR_ANG += 5.0f;
		LOOP_COUNT = 0.0f;
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
		float angAdj = LOOP_COUNT * ANG_ADJ + CUR_ANG;
		if (angAdj > 359.0f)
			angAdj -= 359.0f;

		Vector3 boltStart = MyOrigin() + RelativePosition(Vector3(0, angAdj, 0), Vector3(0, CUR_RAD, 0));
		string boltEnd = Text(boltStart);
		boltEnd = Text(Vec(boltEnd) + Vector3(0.0f, 0.0f, BOLT_HEIGHT));
		Effect("beam", "point", "lgtning.spr", BEAM_WIDTH, boltStart, boltEnd, BEAM_COLOR, 255, 100, 0.1f);

		string boltToMove = GetToken(BOLTS_STRING, int(LOOP_COUNT));
		SetOrigin(boltToMove, boltStart);

		// //dbg draw_bolts_moving#( LOOP_COUNT / NUM_BOLTS ) id( BOLT_TO_MOVE )
		LOOP_COUNT += 1.0f;
	}

	// end_summon
	void OnEndSummon()
	{
		IS_ACTIVE = false;
		LOOP_COUNT = 0.0f;
		OnRemoveBoltsLoop();
	}

	// remove_bolts_loop
	void OnRemoveBoltsLoop()
	{
		if (LOOP_COUNT < Float(NUM_BOLTS))
			CallEventDelayed(0.1f, "remove_bolts_loop");
		if (LOOP_COUNT == Float(NUM_BOLTS))
			CallEventDelayed(1.0f, "remove_me");
		string boltToRemove = GetToken(BOLTS_STRING, int(LOOP_COUNT));
		if (Exists(boltToRemove))
			DeleteEntity(boltToRemove);
		LOOP_COUNT += 1.0f;
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "define_bolts") { OnDefineBolts(); return true; }
		if (name == "draw_bolts") { OnDrawBolts(); return true; }
		if (name == "end_summon") { OnEndSummon(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "move_bolts") { OnMoveBolts(); return true; }
		if (name == "remove_bolts_loop") { OnRemoveBoltsLoop(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		return false;
	}
}
