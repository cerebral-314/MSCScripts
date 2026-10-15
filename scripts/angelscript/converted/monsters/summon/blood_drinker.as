#pragma context server

// Converted from monsters/summon/blood_drinker.script by msc_transpiler.
// Want this to move from target to target
// but may need to simply make a projectile
// player version should simply move to wherever the player is looking
// player version will also need to pass damage differently to deal with FF
// -
// There is within this the basis for a base_noclip script
// combined with base_propelled and the 0.1 sec repeatdelay here in
// (use NPC_HACKED_MOVE_SPEED 1 + setmovedest + setorigin $relvel(0,FWD_SPEED,0))

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/summon/blood_drinker"]
class BloodDrinker : BasePropelledScript
{
	// Constants
	string MOVE_RANGE = "40";
	float FREQ_NEW_TARGET = 5.0f;
	float FREQ_SOUND = 0.5f;
	float FREQ_GLOW = 1.0f;
	string SOUND_SPIN = "zombie/claw_miss2.wav";
	int BEAM_BRIGHTNESS = 50;

	// Variables (an unset .script variable reads as its own name)
	float FWD_SPEED = 0.0f;
	string MY_OWNER = "MY_OWNER";
	string FIRST_TARGET = "FIRST_TARGET";
	float DMG_BASE = 0.0f;
	string BLADE_DURATION = "BLADE_DURATION";
	int GAME_PVP = 0;
	float OWNER_HEIGHT = 0.0f;
	string OWNER_ISPLAYER = "OWNER_ISPLAYER";
	string MY_SKILL = "MY_SKILL";
	string RETURN_ID = "RETURN_ID";
	string CUR_TARGET = "CUR_TARGET";
	bool IS_ACTIVE = false;
	string PLAYING_DEAD = "PLAYING_DEAD";
	float NEXT_TOUCH = 0.0f;
	bool GLOW_DELAY = false;
	bool NEW_TARG_DELAY = false;
	Vector3 CUR_DEST = Vector3();
	float TARG_HEIGHT = 0.0f;
	bool AM_HOVERING = false;
	bool AM_RETURNING = false;
	string BEAM_ID = "BEAM_ID";

	// Variables declared by included files, with the value they start with in this script
	BloodDrinker()
	{
		NPC_HACKED_MOVE_SPEED = 1.0f;
	}

	// unnamed block (first think)
	void BloodDrinker_FirstThink()
	{
		NPC_HACKED_MOVE_SPEED = 1.0f;
		FWD_SPEED = 20.0f;

		SetCallback("touch", "enable");
	}

	// game_touch
	// { damage_loop
	// callevent 0.1 damage_loop
	// //if ( OWNER_ISPLAYER )
	// //{
	// //	dbg damage_loop DMG_BASE $get(MY_OWNER,name)
	// //			//(src_origin)  rng dmg      cth  <attacr> <inflcer><skill>       <type>
	// //	xdodamage $relpos(0,0,0) 72 DMG_BASE 100% MY_OWNER MY_OWNER none dar
	// //}
	// //else
	// //{
	// //		local F_DMG_BASE 0
	// //		if ( !OWNER_ISPLAYER ) local F_DMG_BASE DMG_BASE
	// //		dodamage $relpos(0,0,0) 72 F_DMG_BASE 100% 0.0 reflective dark
	// //}
	// xdodamage $relpos(0,0,0) 72 DMG_BASE 0 MY_OWNER ent_me swordsmanship dark dmgevent:*bds
	// }
	string BloodDrinker_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		bool exitSub = false;
		string result = "";
		if (!(GameTime() > NEXT_TOUCH))
			return result;
		NEXT_TOUCH = GameTime() + 0.1f;

		if (RelationshipOf(other, MY_OWNER) != "enemy")
			return result;
		DoDamageEx(@other, "direct", DMG_BASE, "100%", MY_OWNER, ENT_ME, MY_SKILL, "dark");

		if (!Truthy(ScriptVarOf(other, "IMMUNE_VAMPIRE")) && RaceOf(other) != "undead")
		{
			if (Truthy(OWNER_ISPLAYER))
			{
				if (GAME_PVP == 0 && IsPlayer(other))
				{
					result = AppendResult(result, "0.0");
					exitSub = true;
				}
				if (!exitSub)
				{
					DebugPrint(EntityId(other) + " healowner");

					GiveHealth(MY_OWNER, 4.0f);
				}
			}
			else
			{
				string dmgDone = hpRange;
				GiveHealth(MY_OWNER, dmgDone);
				if (!GLOW_DELAY)
				{
					GLOW_DELAY = true;
					CallEventDelayed(FREQ_GLOW, "reset_glow_delay");
					Effect("glow", MY_OWNER, Vector3(0, 255, 0), 128, 0.25f, 0.25f);
				}
			}
		}

		if (NEW_TARG_DELAY)
			return result;
		if (AM_RETURNING)
			return result;
		if (EntityId(other) != CUR_TARGET)
			return result;
		NEW_TARG_DELAY = true;
		CallEventDelayed(FREQ_NEW_TARGET, "reset_new_targ_delay");
		OnFindNewTarget();
		return result;
	}

	// unnamed block (timer)
	void BloodDrinker_Timer()
	{
		CallEventDelayed(2.0f, "BloodDrinker_Timer");

		if (!IS_ACTIVE)
			return;
		CUR_DEST = OriginOf(CUR_TARGET);
		CUR_DEST.z += RandomInt(1, int(TARG_HEIGHT));
		SetMoveDest(CUR_DEST, MOVE_RANGE);
	}

	// unnamed block (timer)
	void BloodDrinker_Timer2()
	{
		CallEventDelayed(0.1f, "BloodDrinker_Timer2");
		if (!IS_ACTIVE)
			return;
		// teleport through objects
		Vector3 myOrg = MyOrigin() + RelativeVelocity(Vector3(0, FWD_SPEED, 0));

		if (IsAlive(CUR_TARGET))
		{
			SetOrigin(ENT_ME, myOrg);
		}
		else
		{
			myOrg = OriginOf(ENT_ME);
			Vector3 destDir = DirectionTo(myOrg, CUR_DEST) * 100.0f;
			SetVelocity(ENT_ME, destDir);
		}

		Vector3 masterOrg = OriginOf(MY_OWNER);

		if (AM_RETURNING)
		{
			SetMoveDest(MY_OWNER, 8);
			if (Distance(MyOrigin(), masterOrg) < OWNER_HEIGHT)
				OnNotifyReturn();
		}

		if (AM_RETURNING)
			return;
		if (Distance(MyOrigin(), CUR_DEST) < 64.0f)
		{
			if (Distance(MyOrigin(), masterOrg) > 1024.0f)
				OnReturnToOwner("too_far");
			if (!AM_RETURNING)
			{
				myOrg += RelativeVelocity(Vector3(0, 512, 0));

				// if ( !$get(CUR_TARGET,isalive) )
				// {
				// local OWNER_YAW $get(MY_OWNER,angles.yaw)
				// vectoradd MY_ORG $relpos($vec(0,OWNER_YAW,0),$vec(0,256,256)) //hover in front of and above owner
				// }
				SetMoveDest(myOrg, MOVE_RANGE);
			}
		}

		// callevent find_new_target
		if (!IsAlive(CUR_TARGET))
			OnFindNewTarget();
		Vector3 curTargOrigin = OriginOf(CUR_TARGET);
		if ((int(Distance(curTargOrigin, masterOrg)) == 0 ? 1 : 0) > 1024)
			OnFindNewTarget();
	}

	// unnamed block (timer)
	void BloodDrinker_Timer3()
	{
		CallEventDelayed(FREQ_SOUND, "BloodDrinker_Timer3");
		if (!IS_ACTIVE)
			return;
		PlaySound(0, 10, "zombie/claw_miss2.wav");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = creatorValue1;
		FIRST_TARGET = creatorValue2;
		DMG_BASE = Float(damage);
		BLADE_DURATION = skill;

		GAME_PVP = (IsPvp() ? 1 : 0);

		DebugPrint("bladedur " + BLADE_DURATION + " " + skill);

		// dbg blood_drinker dmg DMG_BASE
		OWNER_HEIGHT = HeightOf(MY_OWNER);
		OWNER_ISPLAYER = Text(IsPlayer(MY_OWNER));

		MY_SKILL = "none";
		if (Truthy(OWNER_ISPLAYER))
		{
			RETURN_ID = extraValue5; // id to send return message to
			MY_SKILL = "swordsmanship";
		}

		SetRace(RaceOf(MY_OWNER));
		CUR_TARGET = FIRST_TARGET;
		OnSetTarget(FIRST_TARGET);
		SetMoveDest(CUR_TARGET, MOVE_RANGE);
		CallEventOrDelay(BLADE_DURATION, "return_to_owner");
		IS_ACTIVE = true;
		CallEventDelayed(0.1f, "damage_loop");
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Blood Drinker");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 30);
		SetIdleAnim("spin_horizontal_norm");
		SetMoveAnim("spin_horizontal_norm");
		SetSolid("trigger");
		SetWidth(64);
		SetHeight(64);
		SetFly(true);
		SetBlood("none");
		SetInvincible(true);
		SetMonsterClip(false);
		PLAYING_DEAD = "1";
		Effect("glow", ENT_ME, Vector3(255, 0, 0), 32, -1, 0);
		CallEventDelayed(0.1f, "init_beam");

		SetDamageTaken("cold", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("lightning", 0);
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return BloodDrinker_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// reset_new_targ_delay
	void OnResetNewTargDelay()
	{
		NEW_TARG_DELAY = false;
	}

	// game_reached_dest
	void OnGameReachedDest()
	{
		if (AM_RETURNING)
			return;
	}

	// find_new_target
	void OnFindNewTarget()
	{
		bool exitSub = false;
		if (AM_RETURNING)
			return;
		if (IsAlive(CUR_TARGET) && RangeTo(CUR_TARGET) < 1024.0f)
		{
			OnSetTarget(CUR_TARGET);
			exitSub = true;
		}
		if (exitSub)
			return;
		string oldTarget = CUR_TARGET;
		Vector3 masterOrg = OriginOf(MY_OWNER);
		string targetList = LegacyFunction("get_tsphere", "enemy", 1024, masterOrg);
		if (GetTokenCount(targetList) > 0)
		{
			targetList = TokenShuffle(targetList);
			OnSetTarget(GetToken(targetList, 0));
		}
	}

	// set_target
	void OnSetTarget(string target = "")
	{
		CUR_TARGET = target;
		if (IsAlive(CUR_TARGET))
		{
			if (!AM_RETURNING && CUR_TARGET != MY_OWNER)
			{
				// make sure I can "see" target
				Vector3 traceStart = OriginOf(ENT_ME);
				Vector3 traceEnd = OriginOf(CUR_TARGET);
				string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
				if (traceLine == Text(traceEnd))
				{
					Effect("beam", "update", BEAM_ID, "end_target", CUR_TARGET);
					Effect("beam", "update", BEAM_ID, "brightness", BEAM_BRIGHTNESS);
				}
				else
				{
					// not valid, cant "see"
					Effect("beam", "update", BEAM_ID, "brightness", BEAM_ID, 0);
					CUR_TARGET = "unset";
				}
			}
		}
		else
		{
			Effect("beam", "update", BEAM_ID, "brightness", BEAM_ID, 0);
		}

		// setvard CUR_TARGET MY_OWNER
		// setvard TARG_ISPLAYER 1
		// if ( !$get(CUR_TARGET,isplayer) )
		// {
		// setvard TARG_ISPLAYER 0
		// dbg setting_target $get(CUR_TARGET,name)
		TARG_HEIGHT = HeightOf(CUR_TARGET);
		if (IsPlayer(CUR_TARGET))
			TARG_HEIGHT = Divide(TARG_HEIGHT, 2.0f);
		CUR_DEST = OriginOf(CUR_TARGET);
		CUR_DEST.z += RandomInt(1, int(TARG_HEIGHT));
		if (!AM_RETURNING && !IsAlive(CUR_TARGET))
		{
			float ownerYaw = AnglesOf(MY_OWNER).y;
			CUR_DEST = OriginOf(MY_OWNER) + RelativePosition(Vector3(0, ownerYaw, 0), Vector3(0, 128, 64)); // hover in front of and above owner
		}
		SetMoveDest(CUR_DEST, MOVE_RANGE);
		AM_HOVERING = false;
	}

	// return_to_owner
	void OnReturnToOwner(string value = "")
	{
		DebugPrint("return_to_owner " + value);
		Effect("beam", "update", BEAM_ID, "remove", 0);
		AM_RETURNING = true;
		AM_HOVERING = false;
		FWD_SPEED *= 2.0f;
		CUR_TARGET = MY_OWNER;
		OnSetTarget(MY_OWNER);
		SetMoveDest(MY_OWNER, MOVE_RANGE);
	}

	// notify_return
	// { return_boost
	// //addvelocity ent_me $relvel(0,1000,0)
	// callevent 5.0 notify_return
	// }
	void OnNotifyReturn()
	{
		if (!Truthy(OWNER_ISPLAYER))
			CallExternal(MY_OWNER, "sword_return");
		else
			CallExternal(RETURN_ID, "sword_return");
		SetProp(ENT_ME, "rendermode", 2);
		SetProp(ENT_ME, "renderamt", 0);
		Effect("glow", ENT_ME, Vector3(0, 0, 0), 0, -1, 0);
		IS_ACTIVE = false;
		CallEventDelayed(0.1f, "remove_me");
	}

	// remove_me
	void OnRemoveMe(string caller = "")
	{
		DeleteEntity(ENT_ME);
	}

	// reset_glow_delay
	// { game_damaged_other
	// if !$get(PARAM1,scriptvar,'IMMUNE_VAMPIRE')
	// if $get(PARAM1,race) isnot undead
	// if ( OWNER_ISPLAYER )
	// {
	// if ( !GAME_PVP )
	// {
	// if $get(PARAM1,isplayer)
	// setdmg hit 0
	// setdmg dmg 0
	// return 0.0
	// local EXIT_SUB 1
	// }
	// if !EXIT_SUB
	// givehp MY_OWNER 4.0
	// }
	// else
	// {
	// local DMG_DONE PARAM2
	// givehp MY_OWNER DMG_DONE
	// if !GLOW_DELAY
	// setvard GLOW_DELAY 1
	// callevent FREQ_GLOW reset_glow_delay
	// effect glow MY_OWNER (0,255,0) 128 0.25 0.25
	// }
	// }
	void OnResetGlowDelay()
	{
		GLOW_DELAY = false;
	}

	// init_beam
	void OnInitBeam()
	{
		// effect beam ents lgtning.spr 100 ent_me 0 ent_me 0 (255,255,0) 1 1 -1
		Effect("beam", "ents", "laserbeam.spr", 300, ENT_ME, 0, CUR_TARGET, 0, Vector3(255, 0, 0), BEAM_BRIGHTNESS, 1, -1);
		BEAM_ID = ENT_LASTCREATED;
	}

	// ext_remove
	// deleted due to player/monster death, or whatnot
	void OnExtRemove()
	{
		Effect("beam", "update", BEAM_ID, "remove", 0);
		CallEventDelayed(0.1f, "remove_me");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnBladeDuration() {} // BLADE_DURATION
	void OnFreqGlow() {} // FREQ_GLOW
	void OnFreqNewTarget() {} // FREQ_NEW_TARGET

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(2.0f, "BloodDrinker_Timer");
		CallEventDelayed(0.1f, "BloodDrinker_Timer2");
		CallEventDelayed(FREQ_SOUND, "BloodDrinker_Timer3");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BloodDrinker_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "ext_remove") { OnExtRemove(); return true; }
		if (name == "find_new_target") { OnFindNewTarget(); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_reached_dest") { OnGameReachedDest(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "init_beam") { OnInitBeam(); return true; }
		if (name == "notify_return") { OnNotifyReturn(); return true; }
		if (name == "remove_me") { OnRemoveMe(Param(params, 0)); return true; }
		if (name == "reset_glow_delay") { OnResetGlowDelay(); return true; }
		if (name == "reset_new_targ_delay") { OnResetNewTargDelay(); return true; }
		if (name == "return_to_owner") { OnReturnToOwner(Param(params, 0)); return true; }
		if (name == "set_target") { OnSetTarget(Param(params, 0)); return true; }
		if (name == "BloodDrinker_Timer") { BloodDrinker_Timer(); return true; }
		if (name == "BloodDrinker_Timer2") { BloodDrinker_Timer2(); return true; }
		if (name == "BloodDrinker_Timer3") { BloodDrinker_Timer3(); return true; }
		return BasePropelledScript::DispatchEvent(name, params);
	}
}
