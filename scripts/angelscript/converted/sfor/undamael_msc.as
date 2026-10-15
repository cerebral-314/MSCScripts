#pragma context server

// Converted from sfor/undamael_msc.script by msc_transpiler.
// Undamael 3.0 :D

#include "runtime/ScriptEntity.as"
#include "converted/monsters/debug.as"

[script "sfor/undamael_msc"]
class UndamaelMsc : DebugScript
{
	// Constants
	int DMG_NUKE = 800;
	int DOT_BREATH = 40;
	int DMG_BEAM1 = 1000;
	int DMG_BEAM2 = 100;
	float DMG_BITE = 80.0f;
	int SPEED_NORMAL = 10;
	string SMOKE_SPRITE = "bigsmoke.spr";
	string ANIM_BREATH = "Floor_Fidget_Pissed";
	int DETECT_RANGE = 1024;
	int ATTACK_ZRANGE = 80;
	string SOUND_BEAM1_WARMUP = "ambience/alienfazzle1.wav";
	string SOUND_BEAM2_WARMUP = "x/x_teleattack1.wav";
	string SOUND_PRE_BITE1 = "x/x_recharge1.wav";
	string SOUND_PRE_BITE2 = "x/x_recharge2.wav";
	string SOUND_IDLE1 = "tentacle/te_move1.wav";
	string SOUND_IDLE2 = "tentacle/te_move2.wav";
	string SOUND_BEAM1_FIRE = "x/x_ballattack1.wav";
	string SOUND_BEAM2_FIRE = "debris/beamstart1.wav";
	string SOUND_NUKE_WARMUP = "magic/spookie1.wav";
	string SOUND_BREATH_LOOP = "magic/flame_loop.wav";
	string SOUND_BREATH_START = "magic/flame_loop_start.wav";

	// Variables (an unset .script variable reads as its own name)
	bool NPC_IS_BOSS = false;
	int DOT_NUKE = 0;
	float FREQ_SPECIAL = 0.0f;
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	string MOVE_RANGE = "MOVE_RANGE";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string SOUND_HITEDGE1 = "SOUND_HITEDGE1";
	string SOUND_HITEDGE2 = "SOUND_HITEDGE2";
	string SOUND_HITEDGE3 = "SOUND_HITEDGE3";
	string SOUND_BITE_HIT1 = "SOUND_BITE_HIT1";
	string SOUND_BITE_HIT2 = "SOUND_BITE_HIT2";
	bool NPC_CAN_ATTACK = false;
	float UNDI_MAX_HEIGHT = 0.0f;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float HORRORS_UP = 0.0f;
	string MY_CL_IDX = "MY_CL_IDX";
	string UNDI_ATTACK_TARGET = "UNDI_ATTACK_TARGET";
	string UNDI_MOVE_DEST = "UNDI_MOVE_DEST";
	int CUR_SPEED = 0;
	string NPC_HOME_LOC = "NPC_HOME_LOC";
	float NPC_START_Z = 0.0f;
	int RAISED_LEVEL = 0;
	string PLAYER_LIST = "PLAYER_LIST";
	float LAST_SAW_TARGET = 0.0f;
	int NPC_FWD_SPEED = 0;
	bool IN_PIT_EDGE = false;
	float LAST_TOUCHED_EDGE = 0.0f;
	CBaseEntity@ HEAD_ID = null;
	float LAST_TARGET_SWITCH = 0.0f;
	bool NO_TURN = false;
	string BEAM_TARGET = "BEAM_TARGET";
	int BEAM_ATT1 = 0;
	string BEAM_ENT = "BEAM_ENT";
	bool CYCLES_STARTED = false;
	int BEAM_WARM_UP = 0;
	bool BEAM_SOUND_ON = false;
	float BEAM_VOL = 0.0f;
	CBaseEntity@ BEAM_EYE1 = null;
	CBaseEntity@ BEAM_EYE2 = null;
	CBaseEntity@ BEAM_EYE1_SEC = null;
	CBaseEntity@ BEAM_EYE2_SEC = null;
	float BEAM_COUNT = 0.0f;
	bool BEAM2_ON = false;
	float FB_COUNT = 0.0f;
	float BREATH_VOL = 0.0f;
	Vector3 BREATH_ORG = Vector3();
	string BURN_BOX = "BURN_BOX";
	string EAT_TARGET = "EAT_TARGET";
	bool AM_EATING = false;
	Vector3 z = Vector3();

	// unnamed block (first think)
	void UndamaelMsc_FirstThink()
	{
		NPC_IS_BOSS = true;
		DOT_NUKE = 80;

		FREQ_SPECIAL = 20.0f;
		ATTACK_RANGE = 360.0f;
		ATTACK_HITRANGE = 390.0f;
		MOVE_RANGE = "300";
		ANIM_ATTACK = "Floor_Strike";

		// this sound set may vary with location
		SOUND_HITEDGE1 = "doors/doorstop5.wav"; // slam door, creek, and env_shake fx for main room
		SOUND_HITEDGE2 = "doors/doorstop5.wav";
		SOUND_HITEDGE3 = "doors/doorstop5.wav";
		SOUND_BITE_HIT1 = "tentacle/te_strike1.wav";
		SOUND_BITE_HIT2 = "tentacle/te_strike2.wav";

		// dynamic sounds must be precached
		NPC_CAN_ATTACK = false;
		UNDI_MAX_HEIGHT = 600.0f; // may vary with area
		NPC_HACKED_MOVE_SPEED = 50.0f;
	}

	// unnamed block (timer)
	// ====================================================================== MAIN CYCLE [ BEGIN ]
	void UndamaelMsc_Timer()
	{
		string boxScan = "BOX_SCAN";
		string targetOrg;
		CallEventDelayed(0.1f, "UndamaelMsc_Timer");

		if (NO_TURN)
			return;

		if (BEAM_WARM_UP == 1)
			ClientEvent("update", "all", MY_CL_IDX, "eye_beam_prep_cl", AttachmentPositionOf(ENT_ME, 1), AttachmentPositionOf(ENT_ME, 2));

		if (BEAM_WARM_UP == 2)
			ClientEvent("update", "all", MY_CL_IDX, "eye_beam_prep_cl2", AttachmentPositionOf(ENT_ME, 1), AttachmentPositionOf(ENT_ME, 2));

		// debug
		if (BEAM_ENT != "BEAM_ENT")
			Effect("beam", "update", BEAM_ENT, "color", Vector3(RandomInt(0, 255), RandomInt(0, 255), RandomInt(0, 255)));

		// find a target
		if (UNDI_ATTACK_TARGET == "unset" && !BEAM2_ON)
		{
			boxScan = LegacyFunction("get_tbox", "enemy", 1024, MyOrigin());
			DebugPrint("scan_targets: " + boxScan);
			if (boxScan != "none")
			{
				boxScan = SortEntities(boxScan, "range");
				OnNpcatkSettarget(GetToken(boxScan, 0), "scanned");
			}
			if (UNDI_ATTACK_TARGET == "unset")
			{
				// still no target, try players only method
				PLAYER_LIST = GetActivePlayers();
				PLAYER_LIST = TokenShuffle(PLAYER_LIST);
				string targId = GetToken(PLAYER_LIST, 0);
				Vector3 targOrg = OriginOf(targId);
				Vector3 traceStart = AttachmentPositionOf(ENT_ME, 0);
				string traceOrg = LegacyFunction("get_traceline", traceStart, targOrg, "worldonly");
				if (traceOrg == Text(targOrg))
					OnNpcatkSettarget(targId, "scanned");
			}
		}

		if (UNDI_ATTACK_TARGET == "unset")
			return;

		// check target alive
		if (!IsAlive(UNDI_ATTACK_TARGET))
			OnMyTargetDied();

		float targRange = RangeTo(UNDI_ATTACK_TARGET);

		if (targRange > DETECT_RANGE)
			OnMyTargetDied();

		bool canSeeTarg = Truthy(LegacyFunction("cansee", UNDI_ATTACK_TARGET, 1024));

		if (!canSeeTarg)
		{
			// favor target you can see, over target you cant
			if (!BEAM2_ON)
			{
				boxScan = FindInBox("enemy", 1024);
				if (boxScan != "none")
				{
					boxScan = TokenShuffle(boxScan);
					// dbg Can't see targ: BOX_SCAN
					OnNpcatkSettarget(GetToken(boxScan, 0), "cant see");
				}
			}
		}

		if (UNDI_ATTACK_TARGET == "unset")
			return;

		// face target
		Vector3 myOrg = MyOrigin();
		if (UNDI_MOVE_DEST == "unset")
			targetOrg = Text(OriginOf(UNDI_ATTACK_TARGET));
		else
			targetOrg = UNDI_MOVE_DEST;

		float angleTo = AnglesTo(myOrg, Vec(targetOrg));
		if (UNDI_MOVE_DEST == "unset")
		{
			SetAngle("face", Vector3(0, angleTo, 0));
		}
		else
		{
			// keep facing target, even when moving away
			if (!BEAM2_ON)
			{
				Vector3 atktargetOrg = OriginOf(UNDI_ATTACK_TARGET);
				float fAngle = AnglesTo(myOrg, atktargetOrg);
				SetAngle("face", Vector3(0, fAngle, 0));
			}
		}

		// move towards target
		Vector3 destDir = DirectionTo(myOrg, Vec(targetOrg));
		float vSpeed = destDir.z * 8.0f;
		if (BEAM2_ON)
			vSpeed = 0.0f;

		string destLoc = Text(myOrg);

		// find base foot org
		string myFootOrg = Text(myOrg);
		myFootOrg = Text(WithZ(Vec(myFootOrg), Vec(NPC_HOME_LOC).z));
		float myDist2d = Distance(Vec(myFootOrg), Vec(NPC_HOME_LOC));

		string myYaw = Eval("game.monster.angles.yaw");

		if (myOrg.z > UNDI_MAX_HEIGHT && vSpeed > 0.0f)
		{
			DebugPrint("Too high!");
			vSpeed = -1.0f;
		}

		if (!IN_PIT_EDGE)
			destLoc = Text(Vec(destLoc) + RelativePosition(Vector3(0, angleTo, 0), Vector3(0, NPC_FWD_SPEED, vSpeed)));
		if (IN_PIT_EDGE)
		{
			// bounce back
			angleTo = AnglesTo(Vec(myFootOrg), Vec(NPC_HOME_LOC));
			destLoc = Text(Vec(destLoc) + RelativePosition(Vector3(0, angleTo, 0), Vector3(0, 5, vSpeed)));
		}

		// figure forward speed
		// - if beyond pit radius, only move forward if it puts me closer to center of pit
		// if ( MY_DIST_2D <= PIT_RADIUS ) setvard NPC_FWD_SPEED 10 //I'm within my pit, move forward
		// within pit, move forward, if target not within attack range
		string targetOrgXy = Text(WithZ(Vec(targetOrg), Vec(NPC_HOME_LOC).z));
		float targDist = Distance(Vec(myFootOrg), Vec(targetOrgXy));
		if (targDist > Float(MOVE_RANGE))
			NPC_FWD_SPEED = CUR_SPEED;
		else
			NPC_FWD_SPEED = -1;

		// but only to the outside of pit, if outside, move only if moving closer to pit center
		if (GameTime() > LAST_TOUCHED_EDGE)
			IN_PIT_EDGE = false;

		// if ( TOO_CLOSE ) setvard IN_PIT_EDGE 1
		SetOrigin(ENT_ME, Vec(destLoc));

		if (!NPC_CAN_ATTACK)
			return;

		if (RangeTo(UNDI_ATTACK_TARGET) < ATTACK_RANGE && UNDI_MOVE_DEST == "unset")
		{
			float zDiff = Float(Eval("game.monster.origin.z"));
			float targZ = OriginOf(UNDI_ATTACK_TARGET).z - 38.0f; // player centerpoint weirdness
			if (zDiff >= targZ)
			{
				zDiff -= targZ;
				if (zDiff < ATTACK_ZRANGE)
				{
					// if $cansee(UNDI_ATTACK_TARGET,ATTACK_RANGE)
					PlayAnim("once", ANIM_ATTACK);
				}
			}
		}
	}

	// unnamed block (timer)
	void UndamaelMsc_Timer2()
	{
		CallEventDelayed(Random(1, 2), "UndamaelMsc_Timer2");
		if (BEAM_SOUND_ON)
			return;
		PlayRandomSound(2, 10, SOUND_IDLE1, SOUND_IDLE2);
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("sfor/undamael_head");
		PrecacheFile("monsters/horror_fire");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("undamael");

		SetName("Undamael");
		SetRace("undead");
		SetHealth(20000);
		SetModel("monsters/undamael.mdl");
		SetIdleAnim("Pit_Idle");
		SetHearingSensitivity(11);
		SetWidth(64);
		SetHeight(64);
		LegacyCommand("setturnrate", 0.01f);
		SetBoundingBox("animsize");
		SetSolid("trigger");
		SetRoam(false);
		SetFly(true);
		SetInvincible(true);
		SetNoPush(true);

		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 3);

		HORRORS_UP = 0.0f;

		CallEventDelayed(0.1f, "init_beams");

		ClientEvent("new", "all", "sfor/undamael_msc"); // CL effects
		MY_CL_IDX = LastClientScriptId();

		UNDI_ATTACK_TARGET = "unset";
		UNDI_MOVE_DEST = "unset";
		CUR_SPEED = SPEED_NORMAL;
		CallEventDelayed(0.1f, "npc_post_spawn");
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		// adjust footprint
		OnAdjustFootprint();
		CallExternal("all", "undamael_spawn");
	}

	// adjust_footprint
	// needs to be called whenever he changes areas
	void OnAdjustFootprint()
	{
		Vector3 startLoc = MyOrigin();
		startLoc.z += 96.0f;
		SetOrigin(ENT_ME, startLoc);
		NPC_HOME_LOC = Text(startLoc);
		NPC_START_Z = Vec(NPC_HOME_LOC).z;
		UNDI_MAX_HEIGHT += NPC_START_Z;
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		if (UNDI_ATTACK_TARGET == "unset")
		{
			CBaseEntity@ lastHeard = EntityOf(ENT_LASTHEARD);
			if (!IsAlive(UNDI_ATTACK_TARGET))
				OnNpcatkSettarget(EntityId(lastHeard), "heard");
		}
		if (RAISED_LEVEL != 0)
			return;
		RAISED_LEVEL = 1;
		CallEventDelayed(2.0f, "raise_to_one");
	}

	// raise_to_one
	void OnRaiseToOne()
	{
		PlayAnim("critical", "rise_to_Temp1");
	}

	// mdl_rising
	void OnMdlRising()
	{
		if (RAISED_LEVEL != 1)
			return;
		PlayAnim("critical", "Temp1_to_Floor");
		SetIdleAnim("Floor_Idle");
	}

	// my_target_died
	// ====================================================================== MAIN CYCLE [ END ]
	void OnMyTargetDied(string offender = "")
	{
		PlaySound(0, 10, "x/x_attack1.wav");
		UNDI_ATTACK_TARGET = "unset";
	}

	// mdl_pre_attack
	void OnMdlPreAttack()
	{
		PlayRandomSound(0, 10, SOUND_PRE_BITE1, SOUND_PRE_BITE2);
	}

	// mdl_attack
	void OnMdlAttack()
	{
		if (RangeTo(UNDI_ATTACK_TARGET) < ATTACK_HITRANGE)
		{
			Vector3 targOrg = OriginOf(UNDI_ATTACK_TARGET);
			if (IsPlayer(UNDI_ATTACK_TARGET)) // aim at feet
				targOrg.z += -30.0f;
			Vector3 traceStart = AttachmentPositionOf(ENT_ME, 0);
			string traceTarg = LegacyFunction("get_traceline", traceStart, targOrg, "worldonly");

			DoDamage(traceTarg, 384, DMG_BITE, "90%", 0.5f, "reflective", "pierce");
		}
		Effect("screenshake", OriginOf(ENT_ME), 256, 10, 1, 384);
		PlayRandomSound(0, 10, SOUND_BITE_HIT1, SOUND_BITE_HIT2, SOUND_BITE_HIT2, SOUND_BITE_HIT2, SOUND_BITE_HIT2);
		CallExternal(HEAD_ID, "ext_unsolid", 1.0f);
		// (never true here, the rest is skipped) if EAT_ENABLED
	}

	// ext_pitedge_touch
	// called from other/undamael_pitedge - alerts undmael he's reached edge
	void OnExtPitedgeTouch()
	{
		LAST_TOUCHED_EDGE = GameTime() + 1.0f;
		if (!IN_PIT_EDGE)
			PlayRandomSound(0, 10, SOUND_HITEDGE1, SOUND_HITEDGE2, SOUND_HITEDGE3);
		IN_PIT_EDGE = true;
		DebugPrint("pitedge_set_topuch " + Text(GameTime()));
	}

	// mdl_raise_done
	void OnMdlRaiseDone()
	{
		NPC_CAN_ATTACK = true;
	}

	// npcatk_settarget
	// <target> [reason]
	void OnNpcatkSettarget(string target = "", string debug = "")
	{
		bool exitSub = false;

		DebugPrint("npcatk_settarget " + NameOf(target) + " " + debug);

		if (!Exists(HEAD_ID))
		{
			CreateNpc("sfor/undamael_head", RelativePosition(Vector3(0, 0, 64)), self);
			@HEAD_ID = EntityOf(ENT_LASTCREATED);
			OnStartCycles();
		}

		// don't pick a new target if I saw my current target in the last 10 seconds, and he's not dead, unless retaliating
		if (IsAlive(UNDI_ATTACK_TARGET) && debug != "struck" && GameTime() < LAST_SAW_TARGET)
			exitSub = true;
		if (exitSub)
			return;

		// undi is slow to switch targets
		if (UNDI_ATTACK_TARGET != "unset")
		{
			exitSub = true;
			if (GameTime() > LAST_TARGET_SWITCH)
			{
				LAST_TARGET_SWITCH = GameTime() + 10.0f;
				exitSub = false;
			}
		}
		if (exitSub)
			return;

		// validation
		if (Truthy(ScriptVarOf(target, "PLAYING_DEAD")))
			return;
		if (RelationshipOf(target, ENT_ME) == "ally")
			return;
		if (!IsAlive(target))
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;
		if (EntityOf(target) is self)
			return;
		if (EntityOf(target) is HEAD_ID)
			return;

		// anything below my spawn point is invalid
		if (!(OriginOf(target).z > Vec(NPC_HOME_LOC).z))
			return;

		UNDI_ATTACK_TARGET = target;
	}

	// ext_playanim
	void OnExtPlayanim(string animation = "")
	{
		PlayAnim("critical", animation);
		SetIdleAnim(animation);
	}

	// ext_noturn
	void OnExtNoturn()
	{
		DebugPrint("no_turn_set");
		if (!NO_TURN)
			NO_TURN = true;
		else
			NO_TURN = false;
	}

	// ext_test
	void OnExtTest(string value = "", string value2 = "", string value3 = "", string value4 = "")
	{
		float zDiff = Float(Eval("game.monster.origin.z"));
		zDiff -= OriginOf(UNDI_ATTACK_TARGET).z;

		DebugPrint("targz " + Text(OriginOf(UNDI_ATTACK_TARGET).z) + " vs. " + Eval("game.monster.origin.z") + " = " + Text(zDiff));

		string zLevel = NPC_HOME_LOC;
		zDiff = Float(NPC_HOME_LOC);
		zDiff = Float(Text(WithZ(Vec(Text(zDiff)), MyOrigin().z)));

		DebugPrint("ver_height_from_home " + Text(Distance(Vec(zLevel), Vec(Text(zDiff)))));
	}

	// ext_beam_relink
	void OnExtBeamRelink()
	{
		string nearFolk = LegacyFunction("get_tsphere", "enemy", 2048, MyOrigin());
		float nFolk = GetTokenCount(nearFolk) - 1.0f;
		int rndTarg = RandomInt(0, int(nFolk));
		CBaseEntity@ newTarg = FindEntity(GetToken(nearFolk, rndTarg));
		Effect("beam", "update", BEAM_ENT, "start_target", @newTarg);
	}

	// ext_beam_att
	void OnExtBeamAtt(string target = "")
	{
		BEAM_TARGET = target;
		BEAM_ATT1 = RandomInt(1, 3);
		Effect("beam", "update", @BEAM_EYE1, "brightness", 200);
		Effect("beam", "update", @BEAM_EYE1, "start_target", ENT_ME, BEAM_ATT1);
		Effect("beam", "update", @BEAM_EYE1, "end_target", BEAM_TARGET, 0);
		CallEventDelayed(0.1f, "ext_beam_att2");
	}

	// ext_beam_att2
	void OnExtBeamAtt2()
	{
		int beamAtt2 = RandomInt(1, 3);
		ConsoleMessage(BEAM_TARGET, "ext_beam_att " + BEAM_ATT1 + " " + beamAtt2);
		Effect("beam", "update", @BEAM_EYE2, "brightness", 200);
		Effect("beam", "update", @BEAM_EYE2, "start_target", ENT_ME, beamAtt2);
		Effect("beam", "update", @BEAM_EYE2, "end_target", BEAM_TARGET, 0);
	}

	// ext_beam_remove
	void OnExtBeamRemove()
	{
		Effect("beam", "update", BEAM_ENT, "remove", 0);
	}

	// ext_beam_new
	void OnExtBeamNew()
	{
		Effect("beam", "ents", "blueflare1.spr", 10, UNDI_ATTACK_TARGET, 0, self, 2, Vector3(0, 0, 255), 200, 0, 1000);
		BEAM_ENT = EntityId(EntityOf(ENT_LASTCREATED));
	}

	// start_cycles
	// ============================================================= END DEBUGGARY
	void OnStartCycles()
	{
		if (CYCLES_STARTED)
			return;
		CYCLES_STARTED = true;
		CallEventDelayed(FREQ_SPECIAL, "do_special");
	}

	// do_beam1
	void OnDoBeam1()
	{
		// one strong beam, vs a single player
		// if too close to target, move away before beaming
		if (RangeTo(UNDI_ATTACK_TARGET) < ATTACK_HITRANGE)
		{
			Vector3 targetOrg = OriginOf(UNDI_ATTACK_TARGET);
			UNDI_MOVE_DEST = Text(RelativePosition(Vector3(0, 0, 0), Vector3(0, 1000, 0)));
			CallEventDelayed(5.0f, "do_beam1_2");
		}
		else
		{
			OnDoBeam12();
		}
	}

	// do_beam1_2
	// warn em it's coming so they can hide/block
	void OnDoBeam12()
	{
		// callevent FREQ_BEAM1 do_beam
		UNDI_MOVE_DEST = "unset";
		CUR_SPEED = 1;

		// effect beam ents blueflare1.spr 100 ent_me 2 ent_me 2 (255,255,255) 0 60 -1
		Effect("beam", "update", @BEAM_EYE1, "noise", 60);
		Effect("beam", "update", @BEAM_EYE1, "color", Vector3(255, 255, 255));
		Effect("beam", "update", @BEAM_EYE2, "noise", 60);
		Effect("beam", "update", @BEAM_EYE2, "color", Vector3(255, 255, 255));

		PlayAnim("critical", "Floor_Fidget_SmallRise");

		BEAM_WARM_UP = 1;
		BEAM_SOUND_ON = true;
		PlaySound(1, 10, SOUND_BEAM1_WARMUP);

		CallEventDelayed(2.0f, "do_beam1_3");
	}

	// do_beam1_3
	void OnDoBeam13()
	{
		BEAM_WARM_UP = 0;
		BEAM_VOL = 10.0f;
		OnBeamSoundFade();

		// playsound 1 0 SOUND_BEAM1_WARMUP
		// $cansee wont cut it, since I "see" from my neck
		// trace from left eye to target instead
		Vector3 targOrg = OriginOf(UNDI_ATTACK_TARGET);
		Vector3 eyePos1 = AttachmentPositionOf(ENT_ME, 1);
		string traceTarg = LegacyFunction("get_traceline", eyePos1, targOrg, "worldonly");

		if (traceTarg == Text(targOrg))
		{
			PlaySound(0, 10, SOUND_BEAM1_FIRE);

			Effect("beam", "update", @BEAM_EYE1, "end_target", UNDI_ATTACK_TARGET, 0);
			Effect("beam", "update", @BEAM_EYE2, "end_target", UNDI_ATTACK_TARGET, 0);
			Effect("beam", "update", @BEAM_EYE1, "brightness", 200);
			Effect("beam", "update", @BEAM_EYE2, "brightness", 200);

			DoDamage(UNDI_ATTACK_TARGET, "direct", DMG_BEAM1, "100%", ENT_ME, "dark");
			AddVelocity(UNDI_ATTACK_TARGET, RelativeVelocity(Vector3(-20, 800, 150)));

			CallEventDelayed(2.0f, "beams_off");
		}
		CUR_SPEED = SPEED_NORMAL;
	}

	// beam_sound_fade
	void OnBeamSoundFade()
	{
		BEAM_VOL -= 1.0f;
		if (BEAM_VOL == 0.0f)
			BEAM_SOUND_ON = false;
		PlaySound(1, BEAM_VOL, SOUND_BEAM1_WARMUP);
		if (BEAM_VOL > 0.0f)
			CallEventDelayed(0.2f, "beam_sound_fade");
	}

	// beams_off
	void OnBeamsOff()
	{
		Effect("beam", "update", @BEAM_EYE1, "brightness", 0);
		Effect("beam", "update", @BEAM_EYE2, "brightness", 0);
	}

	// init_beams
	void OnInitBeams()
	{
		Effect("beam", "ents", "blueflare1.spr", 100, ENT_ME, 2, ENT_ME, 2, Vector3(255, 255, 255), 0, 60, -1);
		@BEAM_EYE1 = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(1.0f, "init_beam2");
	}

	// init_beam2
	void OnInitBeam2()
	{
		Effect("beam", "ents", "blueflare1.spr", 100, ENT_ME, 3, ENT_ME, 3, Vector3(255, 255, 255), 0, 60, -1);
		@BEAM_EYE2 = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(1.0f, "init_beam3");
	}

	// init_beam3
	void OnInitBeam3()
	{
		Effect("beam", "vector", "laserbeam.spr", 30, OriginOf(ENT_ME), OriginOf(ENT_ME), Vector3(255, 0, 255), 0, 10, -1);
		@BEAM_EYE1_SEC = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(1.0f, "init_beam4");
	}

	// init_beam4
	void OnInitBeam4()
	{
		Effect("beam", "vector", "laserbeam.spr", 30, OriginOf(ENT_ME), OriginOf(ENT_ME), Vector3(255, 0, 255), 0, 10, -1);
		@BEAM_EYE2_SEC = EntityOf(ENT_LASTCREATED);
	}

	// do_special
	// ============================= CLIENT [END] ==============================
	void OnDoSpecial()
	{
		int rndSpecial = RandomInt(2, 6);

		if (UNDI_ATTACK_TARGET == "unset")
		{
			rndSpecial = 0; // dont waste edicts casting spells with no targets
			FREQ_SPECIAL = 10.0f;
		}

		// local RND_SPECIAL 4 //developer xxx
		if (AM_EATING)
		{
			rndSpecial = 1;
			FREQ_SPECIAL = 40.0f; // this may take awhile and is initated elsewhere
		}
		if (rndSpecial == 2)
		{
			if (HORRORS_UP >= 4.0f)
				FREQ_SPECIAL = 1.0f;
			if (HORRORS_UP < 4.0f)
			{
				HORRORS_UP += 2.0f; // maybe better to delete existing horrors instead
				FREQ_SPECIAL = 20.0f;
				OnDoHorrors();
			}
		}
		if (rndSpecial == 3)
		{
			OnDoBeam1();
			FREQ_SPECIAL = 20.0f;
		}
		if (rndSpecial == 4)
		{
			OnDoBeam2();
			FREQ_SPECIAL = 40.0f; // this one takes longer than most
		}
		if (rndSpecial == 5)
		{
			OnDoNuke();
			FREQ_SPECIAL = 20.0f;
		}
		if (rndSpecial == 6)
		{
			OnDoBreathFire();
			FREQ_SPECIAL = 20.0f;
		}

		CallEventDelayed(FREQ_SPECIAL, "do_special");
	}

	// do_beam2
	void OnDoBeam2()
	{
		// a set of beams, strafeing against a wall
		// if too close to target, move away before beaming
		if (RangeTo(UNDI_ATTACK_TARGET) < 512.0f)
		{
			Vector3 targetOrg = OriginOf(UNDI_ATTACK_TARGET);
			float targAng = AnglesTo(MyOrigin(), targetOrg);
			UNDI_MOVE_DEST = Text(RelativePosition(Vector3(0, targAng, 0), Vector3(0, -1000, -256)));
			CallEventDelayed(5.0f, "do_beam2_2");
		}
		else
		{
			OnDoBeam22();
		}
	}

	// do_beam2_2
	// warn em it's coming so they can hide/block
	void OnDoBeam22()
	{
		// callevent FREQ_BEAM1 do_beam
		UNDI_MOVE_DEST = Text(OriginOf(ENT_ME));
		CUR_SPEED = 1;

		// effect beam update BEAM_EYE1_SEC noise 10
		// effect beam update BEAM_EYE1_SEC color (255,0,255)
		// effect beam update BEAM_EYE2_SEC noise 10
		// effect beam update BEAM_EYE2_SEC color (255,0,255)
		PlayAnim("critical", "Floor_Fidget_SmallRise");

		BEAM_WARM_UP = 2;
		BEAM_SOUND_ON = true;
		ServerPlaySound(1, 10, SOUND_BEAM2_WARMUP);

		CallEventDelayed(2.0f, "do_beam2_init");
	}

	// do_beam2_init
	void OnDoBeam2Init()
	{
		// setvard NO_TURN 1 //undamael equivalent of SUSPEND_AI
		BEAM_WARM_UP = 0;
		BEAM_COUNT = 0.0f;
		PlaySound(0, 10, SOUND_BEAM2_FIRE);
		Effect("beam", "update", @BEAM_EYE1_SEC, "brightness", 128);
		Effect("beam", "update", @BEAM_EYE2_SEC, "brightness", 128);

		float myYaw = AnglesOf(ENT_ME).y - 35.0f;
		if (myYaw < 0.0f)
			myYaw += 359.99f;
		SetAngle("face", Vector3(0, myYaw, 0));

		BEAM2_ON = true;

		CallEventDelayed(0.01f, "do_beam2_cycle");
	}

	// do_beam2_cycle
	void OnDoBeam2Cycle()
	{
		float myYaw = AnglesOf(ENT_ME).y + 0.5f;
		if (myYaw > 359.99f)
			myYaw -= 359.99f;
		SetAngle("face", Vector3(0, myYaw, 0));

		float myZ = OriginOf(ENT_ME).z + 64.0f;
		float hisZ = OriginOf(UNDI_ATTACK_TARGET).z;
		Vector3 myOrg = OriginOf(ENT_ME);
		if (myZ >= hisZ)
		{
			// dbg do_beam2_cycle sink
			myOrg.z += -1.0f;
			SetOrigin(ENT_ME, myOrg);
		}
		else
		{
			// dbg do_beam2_cycle raise
			if (myOrg.z < UNDI_MAX_HEIGHT)
			{
				myOrg.z += 2.0f;
				SetOrigin(ENT_ME, myOrg);
			}
		}

		Vector3 beam1Start = AttachmentPositionOf(ENT_ME, 1);
		Vector3 beam2Start = AttachmentPositionOf(ENT_ME, 2);

		string beam1End = Text(beam1Start);
		string beam2End = Text(beam2Start);

		beam1End = Text(Vec(beam1End) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 1000, 0)));
		beam2End = Text(Vec(beam2End) + RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 1000, 0)));

		beam1End = LegacyFunction("get_traceline", beam1Start, beam1End, "worldonly");
		beam2End = LegacyFunction("get_traceline", beam2Start, beam2End, "worldonly");

		Effect("beam", "update", @BEAM_EYE1_SEC, "points", beam1Start, beam1End);
		Effect("beam", "update", @BEAM_EYE2_SEC, "points", beam2Start, beam2End);

		DoDamageEx(beam1Start, beam1End, DMG_BEAM2, "100%", ENT_ME, ENT_ME, "none", "dark");
		DoDamageEx(beam2Start, beam2End, DMG_BEAM2, "100%", ENT_ME, ENT_ME, "none", "dark");

		BEAM_COUNT += 1.0f;
		if (BEAM_COUNT == 120.0f)
			OnDoBeam2End();
		else
			CallEventDelayed(0.1f, "do_beam2_cycle");
	}

	// do_beam2_end
	void OnDoBeam2End()
	{
		BEAM2_ON = false;
		UNDI_MOVE_DEST = "unset";
		CUR_SPEED = SPEED_NORMAL;
		// setvard NO_TURN 0
		Effect("beam", "update", @BEAM_EYE1_SEC, "brightness", 0);
		Effect("beam", "update", @BEAM_EYE2_SEC, "brightness", 0);
		ServerPlaySound(1, 0, SOUND_BEAM2_WARMUP);
	}

	// do_nuke
	void OnDoNuke(string target = "", int damage = 0)
	{
		if (RangeTo(UNDI_ATTACK_TARGET) < 512.0f)
		{
			Vector3 targetOrg = OriginOf(UNDI_ATTACK_TARGET);
			float targAng = AnglesTo(MyOrigin(), targetOrg);
			UNDI_MOVE_DEST = Text(RelativePosition(Vector3(0, targAng, 0), Vector3(0, -1000, -256)));
			CallEventDelayed(5.0f, "do_nuke_warmup");
			PlaySound(0, 10, SOUND_NUKE_WARMUP);
		}
		else
		{
			OnDoNukeWarmup();
		}
	}

	// do_nuke_warmup
	void OnDoNukeWarmup()
	{
		UNDI_MOVE_DEST = Text(OriginOf(ENT_ME));

		PlayAnim("critical", "Floor_Fidget_SmallRise");

		ClientEvent("update", "all", MY_CL_IDX, "eye_beam_fire", AttachmentPositionOf(ENT_ME, 1), AttachmentPositionOf(ENT_ME, 2));

		PlaySound(0, 10, SOUND_NUKE_WARMUP);
		CallEventDelayed(2.0f, "do_nuke_fire");
	}

	// do_nuke_fire
	void OnDoNukeFire()
	{
		UNDI_MOVE_DEST = "unset";

		CallExternal(FindByName("head_undi"), "do_nuke", UNDI_ATTACK_TARGET, DMG_NUKE);
	}

	// do_breath_fire
	void OnDoBreathFire()
	{
		UNDI_MOVE_DEST = Text(OriginOf(ENT_ME));
		PlayAnim("critical", ANIM_BREATH);
		FB_COUNT = 0.0f;
		CallEventDelayed(0.1f, "do_breath_fire_loop");
		BREATH_VOL = 10.0f;
		PlaySound(1, 10, SOUND_BREATH_LOOP);
		PlaySound(0, 10, SOUND_BREATH_START);
	}

	// do_breath_fire_loop
	void OnDoBreathFireLoop()
	{
		FB_COUNT += 1.0f;
		if (FB_COUNT == 60.0f)
		{
			OnBreathSoundFade();
			UNDI_MOVE_DEST = "unset";
		}
		if (!(FB_COUNT < 60.0f))
			return;
		CallEventDelayed(0.1f, "do_breath_fire_loop");

		PlayAnim("once", ANIM_BREATH);
		BREATH_ORG = AttachmentPositionOf(ENT_ME, 0);
		ClientEvent("update", "all", MY_CL_IDX, "eye_breath_fire", BREATH_ORG, AnglesOf(ENT_ME).y);

		if (FB_COUNT == 5.0f)
			OnBurnInbox();
		if (FB_COUNT == 25.0f)
			OnBurnInbox();
		if (FB_COUNT == 45.0f)
			OnBurnInbox();
		if (FB_COUNT == 55.0f)
			OnBurnInbox();
	}

	// burn_inbox
	void OnBurnInbox()
	{
		BURN_BOX = LegacyFunction("get_tbox", "enemy", 512, BREATH_ORG);
		DebugPrint("burn_inbox " + BURN_BOX);
		if (BURN_BOX == "none")
			return;
		int count = GetTokenCount(BURN_BOX);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnBurnTargetsInCone();
		}
	}

	// burn_targets_in_cone
	void OnBurnTargetsInCone()
	{
		CBaseEntity@ burnTarg = FindEntity(GetToken(BURN_BOX, loopIteration));
		Vector3 targOrg = OriginOf(burnTarg);
		Vector3 myAng = AnglesOf(ENT_ME);
		int inCone = Int(LegacyFunction("within_cone", targOrg, BREATH_ORG, myAng, 45));
		if (inCone == 0) // is in cone
			return;
		if (!(Distance(BREATH_ORG, targOrg) < 512.0f))
			return;
		if (LegacyFunction("get_traceline", BREATH_ORG, targOrg, "worldonly") != Text(targOrg))
			return;
		ApplyEffect(burnTarg, "effects/dot_fire", 10, self, DOT_BREATH);
	}

	// breath_sound_fade
	void OnBreathSoundFade()
	{
		BREATH_VOL -= 1.0f;
		PlaySound(1, 10, BREATH_VOL, SOUND_BREATH_LOOP);
		if (BREATH_VOL > 0.0f)
			CallEventDelayed(0.2f, "breath_sound_fade");
	}

	// horror_died
	void OnHorrorDied()
	{
		HORRORS_UP -= 1.0f;
		DebugPrint("horror_died " + Text(HORRORS_UP));
	}

	// do_horrors
	void OnDoHorrors()
	{
		if (RangeTo(UNDI_ATTACK_TARGET) < 512.0f)
		{
			Vector3 targetOrg = OriginOf(UNDI_ATTACK_TARGET);
			float targAng = AnglesTo(MyOrigin(), targetOrg);
			UNDI_MOVE_DEST = Text(RelativePosition(Vector3(0, targAng, 0), Vector3(0, -1000, -256)));
			CallEventDelayed(5.0f, "do_horrors_summon");
		}
		else
		{
			OnDoHorrorsSummon();
		}
	}

	// do_horrors_summon
	void OnDoHorrorsSummon()
	{
		PlayAnim("critical", "Engine_Idle"); // Floor_Fidget_SmallRise
		PlaySound(0, 10, "SOUND_PRE_SUMMON");
		ClientEvent("update", "all", MY_CL_IDX, "eye_beam_green", AttachmentPositionOf(ENT_ME, 1), AttachmentPositionOf(ENT_ME, 2));
		CallEventDelayed(1.0f, "make_horror1");
		CallEventDelayed(1.1f, "make_horror2");
	}

	// make_horror1
	void OnMakeHorror1()
	{
		CreateNpc("monsters/horror_fire", RelativePosition(Vector3(-100, 0, 64)), self);
	}

	// make_horror2
	void OnMakeHorror2()
	{
		UNDI_MOVE_DEST = "unset";
		CreateNpc("monsters/horror_fire", RelativePosition(Vector3(100, 0, 64)), self);
	}

	// do_eat
	void OnDoEat()
	{
		UNDI_MOVE_DEST = "START_LOC";
		PlayAnim("critical", "tentacle_grab");
		EAT_TARGET = UNDI_ATTACK_TARGET;
		AM_EATING = true;
		PlaySound(0, 10, "barnacle/bcl_chew1.wav");
		CallEventDelayed(0.1f, "eat_loop");
		CallEventDelayed(3.0f, "eat_sound");
		CallEventDelayed(6.0f, "eat_done");
	}

	// eat_sound
	void OnEatSound()
	{
		PlaySound(0, 10, "barnacle/bcl_chew2.wav");
	}

	// eat_loop
	void OnEatLoop()
	{
		if (!AM_EATING)
			return;
		SetOrigin(EAT_TARGET, AttachmentPositionOf(ENT_ME, 0));
		PlayAnim("once", "tentacle_grab");
		CallEventDelayed(0.1f, "eat_loop");
	}

	// eat_done
	void OnEatDone()
	{
		UNDI_MOVE_DEST = "unset";
		AM_EATING = false;
		PlayAnim("critical", "rise_to_Temp1");
	}

	// death_sequence
	// called from undamael_head
	void OnDeathSequence()
	{
		SetIdleAnim("Engine_death2");
		PlayAnim("critical", "Engine_death2");
		PlaySound(0, 10, "SOUND_DEATH");
		Effect("screenshake", OriginOf(ENT_ME), 256, 10, 20.0f, 1024);
		CallEventDelayed(1.0f, "reward_victor");
		CallEventDelayed(5.0f, "remove_me");
	}

	// reward_victor
	void OnRewardVictor()
	{
		if (ToLowerCase(MapName()) != "sfor")
			return;
		Vector3 swordOrigin = OriginOf(ENT_ME);
		z = swordOrigin + Vec(Text(256));
		CallExternal(GetVar("GAME_MASTER"), "undamael_reward_victor", swordOrigin);
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqSpecial() {} // FREQ_SPECIAL

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/undamael.mdl");
		Precache("x/x_teleattack1.wav");
		CallEventDelayed(0.1f, "UndamaelMsc_Timer");
		CallEventDelayed(Float(Eval("$randf(1,2)")), "UndamaelMsc_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		UndamaelMsc_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "adjust_footprint") { OnAdjustFootprint(); return true; }
		if (name == "beam_sound_fade") { OnBeamSoundFade(); return true; }
		if (name == "beams_off") { OnBeamsOff(); return true; }
		if (name == "breath_sound_fade") { OnBreathSoundFade(); return true; }
		if (name == "burn_inbox") { OnBurnInbox(); return true; }
		if (name == "burn_targets_in_cone") { OnBurnTargetsInCone(); return true; }
		if (name == "death_sequence") { OnDeathSequence(); return true; }
		if (name == "do_beam1") { OnDoBeam1(); return true; }
		if (name == "do_beam1_2") { OnDoBeam12(); return true; }
		if (name == "do_beam1_3") { OnDoBeam13(); return true; }
		if (name == "do_beam2") { OnDoBeam2(); return true; }
		if (name == "do_beam2_2") { OnDoBeam22(); return true; }
		if (name == "do_beam2_cycle") { OnDoBeam2Cycle(); return true; }
		if (name == "do_beam2_end") { OnDoBeam2End(); return true; }
		if (name == "do_beam2_init") { OnDoBeam2Init(); return true; }
		if (name == "do_breath_fire") { OnDoBreathFire(); return true; }
		if (name == "do_breath_fire_loop") { OnDoBreathFireLoop(); return true; }
		if (name == "do_eat") { OnDoEat(); return true; }
		if (name == "do_horrors") { OnDoHorrors(); return true; }
		if (name == "do_horrors_summon") { OnDoHorrorsSummon(); return true; }
		if (name == "do_nuke") { OnDoNuke(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "do_nuke_fire") { OnDoNukeFire(); return true; }
		if (name == "do_nuke_warmup") { OnDoNukeWarmup(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "eat_done") { OnEatDone(); return true; }
		if (name == "eat_loop") { OnEatLoop(); return true; }
		if (name == "eat_sound") { OnEatSound(); return true; }
		if (name == "ext_beam_att") { OnExtBeamAtt(Param(params, 0)); return true; }
		if (name == "ext_beam_att2") { OnExtBeamAtt2(); return true; }
		if (name == "ext_beam_new") { OnExtBeamNew(); return true; }
		if (name == "ext_beam_relink") { OnExtBeamRelink(); return true; }
		if (name == "ext_beam_remove") { OnExtBeamRemove(); return true; }
		if (name == "ext_noturn") { OnExtNoturn(); return true; }
		if (name == "ext_pitedge_touch") { OnExtPitedgeTouch(); return true; }
		if (name == "ext_playanim") { OnExtPlayanim(Param(params, 0)); return true; }
		if (name == "ext_test") { OnExtTest(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "horror_died") { OnHorrorDied(); return true; }
		if (name == "init_beam2") { OnInitBeam2(); return true; }
		if (name == "init_beam3") { OnInitBeam3(); return true; }
		if (name == "init_beam4") { OnInitBeam4(); return true; }
		if (name == "init_beams") { OnInitBeams(); return true; }
		if (name == "make_horror1") { OnMakeHorror1(); return true; }
		if (name == "make_horror2") { OnMakeHorror2(); return true; }
		if (name == "mdl_attack") { OnMdlAttack(); return true; }
		if (name == "mdl_pre_attack") { OnMdlPreAttack(); return true; }
		if (name == "mdl_raise_done") { OnMdlRaiseDone(); return true; }
		if (name == "mdl_rising") { OnMdlRising(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npcatk_settarget") { OnNpcatkSettarget(Param(params, 0), Param(params, 1)); return true; }
		if (name == "raise_to_one") { OnRaiseToOne(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reward_victor") { OnRewardVictor(); return true; }
		if (name == "start_cycles") { OnStartCycles(); return true; }
		if (name == "UndamaelMsc_Timer") { UndamaelMsc_Timer(); return true; }
		if (name == "UndamaelMsc_Timer2") { UndamaelMsc_Timer2(); return true; }
		return DebugScript::DispatchEvent(name, params);
	}
}
