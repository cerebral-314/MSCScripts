#pragma context server

// Converted from monsters/summon/magic_dart.script by msc_transpiler.
// A sprite based projectile that varies with size and power by Thothie
// - Originally for Orion Bow, but phayled

#include "runtime/ScriptEntity.as"

[script "monsters/summon/magic_dart"]
class MagicDart : ScriptEntity
{
	// Constants
	string SOUND_SHOOT = "ambience/alienflyby1.wav";
	string SOUND_ZAP1 = "debris/beamstart14.wav";
	string SOUND_ZAP2 = "debris/beamstart14.wav";
	string SOUND_ZAP3 = "debris/zap1.wav";

	// Variables (an unset .script variable reads as its own name)
	string MY_OWNER = "MY_OWNER";
	string PROJ_DEST = "PROJ_DEST";
	string PROJ_SIZE = "PROJ_SIZE";
	string PROJ_DMG = "PROJ_DMG";
	string MY_SKILL = "MY_SKILL";
	float WORLD_SIZE = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	float PROJ_SPEED = 0.0f;
	string OWNER_ANGLES = "OWNER_ANGLES";
	Vector3 FINAL_DEST = Vector3();
	string MY_SCRIPT_IDX = "MY_SCRIPT_IDX";
	bool DART_ON = false;
	float STUCK_COUNT = 0.0f;
	Vector3 OLD_POS = Vector3();
	bool HIT_SOMETHING = false;
	float LOOP_COUNT = 0.0f;
	bool FIZZING_OUT = false;

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		PROJ_DEST = creatorValue2; // start angles
		PROJ_SIZE = damage; // size multiplier
		// setvard PROJ_SPEED PARAM4 //units to move forward every 0.1
		PROJ_DMG = extraValue5; // damage
		MY_SKILL = extraValue6;
		WORLD_SIZE = Float(PROJ_SIZE);
		WORLD_SIZE *= 15.0f;
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		// calculate speed based on size
		PROJ_SPEED = 180.0f;
		float speedAdj = Float(PROJ_SIZE);
		speedAdj *= 15.0f;
		PROJ_SPEED -= speedAdj;

		// dbg speed will be PROJ_SPEED ( size PROJ_SIZE )
		// vectoradd PROJ_DEST $relpos($vec(game.monster.angles),$vec(0,1000,0))
		SetMoveDest(PROJ_DEST, 1);

		SetProp(ENT_ME, "movetype", Eval("const.movetype.noclip"));
		SetProp(ENT_ME, "solid", 0);

		OWNER_ANGLES = Text(AnglesOf(MY_OWNER));
		SetAngle("face", OWNER_ANGLES);
		FINAL_DEST = RelativePosition(Vector3(0, 20000, 0));
		SetMoveDest(FINAL_DEST, 10);
		float projSpeed = PROJ_SPEED * 10.0f;
		SetAnimMoveSpeed(projSpeed);

		// dbg got owner $get(MY_OWNER,name) dest PROJ_DEST siz PROJ_SIZE spd PROJ_SPEED dmg PROJ_DMG world WORLD_SIZE
		ClientEvent("new", "all", "monsters/summon/magic_dart_cl", IndexOf(ENT_ME), PROJ_SIZE);
		MY_SCRIPT_IDX = LastClientScriptId();

		CallEventDelayed(0.1f, "setup_dart");

		CallEventDelayed(10.0f, "fiz_out");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Mana Bolt");
		SetModel("monsters/bat.mdl");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		SetWidth(32);
		SetHeight(32);
		SetSolid("none");
		SetBlood("none");
		SetInvincible(true);
		SetRace("beloved");
		SetMonsterClip(false);
		SetFly(true);
		SetGravity(0);
		CallEventDelayed(10.0f, "remove_me");
	}

	// setup_dart
	void OnSetupDart()
	{
		DART_ON = true;
		STUCK_COUNT = 0.0f;
		OLD_POS = MyOrigin();
		CallEventDelayed(0.1f, "move_dart");
		int shootVolume = int(Float(PROJ_SIZE));
		SetMoveDest(PROJ_DEST, 1);
		PlaySound(0, shootVolume, SOUND_SHOOT);
	}

	// move_dart
	void OnMoveDart()
	{
		if (!DART_ON)
			return;

		CallEventDelayed(0.1f, "move_dart");

		// local MY_YAW $vec.yaw(game.monster.angles)
		// local MY_PITCH $vec.pitch(game.monster.angles)
		// local MY_ROLL $vec.roll(game.monster.angles)
		// vectoradd FINAL_DEST $relpos($vec(MY_PITCH,MY_YAW,MY_ROLL),$vec(0,1000,0))
		// setangle face_origin FINAL_DEST
		SetMoveDest(PROJ_DEST, 1);

		// setorigin ent_me $relpos(0,PROJ_SPEED,0)
		// //dbg dest PROJ_DEST //
		LegacyCommand("getents", "any", WORLD_SIZE);

		if (Distance(MyOrigin(), Vec(PROJ_DEST)) <= PROJ_SPEED && !HIT_SOMETHING)
		{
			Vector3 newDest = Vec(PROJ_DEST);
			float myYaw = Vec(Eval("game.monster.angles.yaw")).z;
			newDest += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 1000, 0));
			PROJ_DEST = Text(newDest);
		}

		// callevent 0.1 fiz_out
		if (Text(MyOrigin()) == Text(OLD_POS) && !HIT_SOMETHING)
		{
			STUCK_COUNT += 1.0f;
			if (STUCK_COUNT > 3.0f)
				OnFizOut();
		}
		OLD_POS = MyOrigin();
	}

	// hit_target
	void OnHitTarget()
	{
		HIT_SOMETHING = true;
		LOOP_COUNT = 0.0f;
		for (int i = 0; i < 0; i++)
		{
			loopIteration = i;
			OnDmgTarget();
		}
	}

	// dmg_target
	void OnDmgTarget()
	{
		string checkEnt = "CHECK_ENT";
		bool exitSub = false;
		LOOP_COUNT += 1.0f;
		if (LOOP_COUNT == 1.0f)
			checkEnt = "GET_ENT1";
		if (LOOP_COUNT == 2.0f)
			checkEnt = "GET_ENT2";
		if (LOOP_COUNT == 3.0f)
			checkEnt = "GET_ENT3";
		if (LOOP_COUNT == 4.0f)
			checkEnt = "GET_ENT4";
		if (LOOP_COUNT == 5.0f)
			checkEnt = "GET_ENT5";
		if (LOOP_COUNT == 6.0f)
			checkEnt = "GET_ENT6";
		if (LOOP_COUNT == 7.0f)
			checkEnt = "GET_ENT7";
		if (LOOP_COUNT == 8.0f)
			checkEnt = "GET_ENT8";
		if (LOOP_COUNT == 9.0f)
			checkEnt = "GET_ENT9";

		// dbg in sphere ( WORLD_SIZE ) $get(CHECK_ENT,name)
		if (RelationshipOf(checkEnt, MY_OWNER) != "enemy")
			return;
		if (EntityId(EntityOf(checkEnt)) == "FIRST_TARG")
			return;

		if (Truthy(OWNER_ISPLAYER) && (IsPvp() ? 1 : 0) == 0 && IsPlayer(checkEnt))
			exitSub = true;
		// dbg aborted, players do not atk players in non-pvp ( game.pvp )
		if (exitSub)
			return;

		// callexternal MY_OWNER send_damage CHECK_ENT direct PROJ_DMG 100% MY_OWNER magic
		// <target|(origin)> <range|aoe|direct> <damage> <cth|fall_off> <attacker> <inflciter> <skill|none> <dmg_type> [flag_string]
		DoDamageEx(checkEnt, "direct", PROJ_DMG, "100%", MY_OWNER, MY_OWNER, MY_SKILL, "magic");
		Effect("screenfade", checkEnt, 3, 1, Vector3(255, 255, 255), 255, "fadein");
	}

	// debug_beam
	// <(start)> [(end)] [color] (if no [end] given, makes beam 64 units straight up)
	void OnDebugBeam(string startPosition = "", string endPosition = "", string beamColor = "")
	{
		string beamColorValue = "BEAM_COLOR";
		string beamEnd = "BEAM_END";

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

	// fiz_out
	void OnFizOut()
	{
		if (FIZZING_OUT)
			return;

		// dbg FizingOut PARAM1
		FIZZING_OUT = true;
		DART_ON = false;
		PlayRandomSound(0, 10, SOUND_ZAP1, SOUND_ZAP2, SOUND_ZAP3);
		ClientEvent("update", "all", MY_SCRIPT_IDX, "shrink_out");
		CallEventDelayed(2.0f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		// clientevent remove all MY_SCRIPT_IDX
		CallEventDelayed(0.1f, "remove_me2");
	}

	// remove_me2
	void OnRemoveMe2()
	{
		DeleteEntity(ENT_ME);
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		SetAnimMoveSpeed(PROJ_SPEED); // Force move, since the animation doesn't have the required movement
	}

	// game_stopmoving
	void OnGameStopmoving()
	{
		SetAnimMoveSpeed(PROJ_SPEED); // Force Stop
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "debug_beam") { OnDebugBeam(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "dmg_target") { OnDmgTarget(); return true; }
		if (name == "fiz_out") { OnFizOut(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "hit_target") { OnHitTarget(); return true; }
		if (name == "move_dart") { OnMoveDart(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "remove_me2") { OnRemoveMe2(); return true; }
		if (name == "setup_dart") { OnSetupDart(); return true; }
		return false;
	}
}
