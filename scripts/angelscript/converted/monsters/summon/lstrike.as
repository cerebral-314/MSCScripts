#pragma context server

// Converted from monsters/summon/lstrike.script by msc_transpiler.
// lightning strike, by Thothie
// - Summons bolts down from sky onto everyone in area
// - damage sustains for a few seconds
// - first beam, 128 rad, comes down on summoner, lasts DUR_CENTER secs
// - secondary beams, 96 rad, come down on each target 2 secs later, last DUR_SECONDARY secs
// - odd naming conventions as this entire script was originally internal to sorc_chief1

#include "runtime/ScriptEntity.as"

[script "monsters/summon/lstrike"]
class Lstrike : ScriptEntity
{
	// Constants
	float DUR_CENTER = 15.0f;
	float DUR_SECONDARY = 13.0f;

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string MY_DMG = "MY_DMG";
	string MAX_CHILDREN = "MAX_CHILDREN";
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	int PVP_MODE = 0;
	string PLAYING_DEAD = "PLAYING_DEAD";
	Vector3 CENTER_POINT = Vector3();
	bool IS_ACTIVE = false;
	float LBLAST_CUR_TARG = 0.0f;
	float LBLAST_LOOPCOUNT = 0.0f;
	float LBLAST_TARGETS = 0.0f;
	bool SECONDARY_BEAMS_ON = false;
	string LBLAST_TARG1 = "LBLAST_TARG1";
	string LBLAST_TARG2 = "LBLAST_TARG2";
	string LBLAST_TARG3 = "LBLAST_TARG3";
	string LBLAST_TARG4 = "LBLAST_TARG4";
	string LBLAST_TARG5 = "LBLAST_TARG5";
	string LBLAST_TARG6 = "LBLAST_TARG6";
	string LBLAST_TARG7 = "LBLAST_TARG7";
	string LBLAST_TARG8 = "LBLAST_TARG8";
	string LBLAST_TARG9 = "LBLAST_TARG9";
	CBaseEntity@ BLAST_CHILD1 = null;
	CBaseEntity@ BLAST_CHILD2 = null;
	CBaseEntity@ BLAST_CHILD3 = null;
	CBaseEntity@ BLAST_CHILD5 = null;
	CBaseEntity@ BLAST_CHILD6 = null;
	CBaseEntity@ BLAST_CHILD7 = null;
	CBaseEntity@ BLAST_CHILD8 = null;
	CBaseEntity@ BLAST_CHILD9 = null;

	// unnamed block (timer)
	void Lstrike_Timer()
	{
		CallEventDelayed(1.0f, "Lstrike_Timer");
		PlaySound(0, 10, "magic/lightning_strike.wav");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		MY_DMG = creatorValue2;
		MAX_CHILDREN = damage; // abs max is 9

		LegacyCommand("storeentity", ENT_EXPOWNER, MY_OWNER);

		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));
		PVP_MODE = (IsPvp() ? 1 : 0);
		LegacyCommand("drop_to_floor");
		CallEventDelayed(0.1f, "summon_start");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Lightning Strike");
		// race beloved
		SetInvincible(true);
		SetHealth(1);
		PLAYING_DEAD = "1";
		LegacyCommand("drop_to_floor");
	}

	// summon_start
	void OnSummonStart()
	{
		Vector3 beamTop = Vec("BEAM_TOP");
		Vector3 beapTop = MyOrigin();
		Vector3 beamBottom = MyOrigin();
		beamBottom.z = GroundHeight(MyOrigin());
		SetOrigin(ENT_ME, beamBottom); // drop to ground, fo sure
		float skyHeight = SkyHeight(beamTop);
		beamTop = Vector3(MyOrigin().x, MyOrigin().y, skyHeight);
		Effect("beam", "point", "lgtning.spr", 200, beamBottom, beamTop, Vector3(255, 255, 0), 255, 100, DUR_CENTER);
		ClientEvent("new", "all", "effects/make_light", beamBottom, 128, Vector3(255, 255, 0), DUR_CENTER);
		CENTER_POINT = beamBottom;

		PlaySound(0, 10, "weather/Storm_exclamation.wav");
		IS_ACTIVE = true;
		LBLAST_CUR_TARG = 0.0f;
		CallEventDelayed(0.1f, "damage_loop");

		CallEventDelayed(2.0f, "start_secondary");
		CallEventDelayed(DUR_CENTER, "summon_end");
	}

	// start_secondary
	void OnStartSecondary()
	{
		LegacyCommand("getents", "any", 1024);
		SECONDARY_BEAMS_ON = true;
	}

	// lblast_mark_targets
	void OnLblastMarkTargets()
	{
		string checkEnt = "CHECK_ENT";
		bool exitSub = false;

		LBLAST_LOOPCOUNT += 1.0f;
		if (LBLAST_LOOPCOUNT == 1.0f)
			checkEnt = "GET_ENT1";
		if (LBLAST_LOOPCOUNT == 2.0f)
			checkEnt = "GET_ENT2";
		if (LBLAST_LOOPCOUNT == 3.0f)
			checkEnt = "GET_ENT3";
		if (LBLAST_LOOPCOUNT == 4.0f)
			checkEnt = "GET_ENT4";
		if (LBLAST_LOOPCOUNT == 5.0f)
			checkEnt = "GET_ENT5";
		if (LBLAST_LOOPCOUNT == 6.0f)
			checkEnt = "GET_ENT6";
		if (LBLAST_LOOPCOUNT == 7.0f)
			checkEnt = "GET_ENT7";
		if (LBLAST_LOOPCOUNT == 8.0f)
			checkEnt = "GET_ENT8";
		if (LBLAST_LOOPCOUNT == 9.0f)
			checkEnt = "GET_ENT9";

		if (RelationshipOf(checkEnt, MY_OWNER) != "enemy")
			return;

		// stop pvp damage in non-pvp game
		if (Truthy(OWNER_ISPLAYER) && PVP_MODE == 0 && IsPlayer(checkEnt))
			exitSub = true;
		if (exitSub)
			return;

		LBLAST_TARGETS += 1.0f;
		if (!(LBLAST_TARGETS <= Float(MAX_CHILDREN)))
			return;
		Vector3 mbeamTarg = OriginOf(checkEnt);
		float beamGround = GroundHeight(mbeamTarg);
		mbeamTarg.z = beamGround;

		// dbg lblast_mark_targets # LBLAST_LOOPCOUNT name $get(CHECK_ENT,name) gnd BEAM_GROUND adjtarg MBEAM_TARG actpos $get(CHECK_ENT,origin)
		if (LBLAST_TARGETS == 1.0f)
			LBLAST_TARG1 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 2.0f)
			LBLAST_TARG2 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 3.0f)
			LBLAST_TARG3 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 4.0f)
			LBLAST_TARG4 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 5.0f)
			LBLAST_TARG5 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 6.0f)
			LBLAST_TARG6 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 7.0f)
			LBLAST_TARG7 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 8.0f)
			LBLAST_TARG8 = Text(mbeamTarg);
		if (LBLAST_TARGETS == 9.0f)
			LBLAST_TARG9 = Text(mbeamTarg);

		float sbeamSky = SkyHeight(mbeamTarg);
		string sbeamTop = Text(mbeamTarg);
		sbeamTop = Text(WithZ(Vec(sbeamTop), sbeamSky));
		Effect("beam", "point", "lgtning.spr", 100, mbeamTarg, sbeamTop, Vector3(255, 255, 0), 200, 100, DUR_SECONDARY);
		ClientEvent("new", "all", "effects/make_light", mbeamTarg, 96, Vector3(255, 255, 0), DUR_SECONDARY);
	}

	// damage_loop
	void OnDamageLoop()
	{
		if (!IS_ACTIVE)
			return;
		CallEventDelayed(0.25f, "damage_loop");
		if (SECONDARY_BEAMS_ON)
		{
			LBLAST_CUR_TARG += 1.0f;
			if (LBLAST_CUR_TARG == 1.0f && !Exists(BLAST_CHILD1))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG1), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD1 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 2.0f && !Exists(BLAST_CHILD2))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG2), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD2 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 3.0f && !Exists(BLAST_CHILD3))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG3), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD3 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 4.0f && !Exists("BLAST_CHILD4"))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG4), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD5 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 5.0f && !Exists(BLAST_CHILD5))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG5), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD5 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 6.0f && !Exists(BLAST_CHILD6))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG6), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD6 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 7.0f && !Exists(BLAST_CHILD7))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG7), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD7 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 8.0f && !Exists(BLAST_CHILD8))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG8), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD8 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG == 9.0f && !Exists(BLAST_CHILD9))
			{
				CreateNpc("monsters/summon/lstrike_child", Vec(LBLAST_TARG9), MY_OWNER, MY_DMG, DUR_SECONDARY);
				@BLAST_CHILD9 = EntityOf(ENT_LASTCREATED);
			}
			if (LBLAST_CUR_TARG > 9.0f)
				SECONDARY_BEAMS_ON = false;
		}

		DoDamage(Text(MyOrigin()), 128, MY_DMG, "100%", 0.1f, "normal", "lightning");
	}

	// summon_end
	void OnSummonEnd()
	{
		IS_ACTIVE = false;
		CallEventDelayed(0.5f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
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
	void OnDurCenter() {} // DUR_CENTER

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		CallEventDelayed(1.0f, "Lstrike_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "damage_loop") { OnDamageLoop(); return true; }
		if (name == "debug_beam") { OnDebugBeam(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "lblast_mark_targets") { OnLblastMarkTargets(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "start_secondary") { OnStartSecondary(); return true; }
		if (name == "summon_end") { OnSummonEnd(); return true; }
		if (name == "summon_start") { OnSummonStart(); return true; }
		if (name == "Lstrike_Timer") { Lstrike_Timer(); return true; }
		return false;
	}
}
