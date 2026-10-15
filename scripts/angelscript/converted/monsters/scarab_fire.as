#pragma context server

// Converted from monsters/scarab_fire.script by msc_transpiler.
// Scarabs by Thothie - minimal AI to allow swarms
// - Latch onto players and do DOT, the DOT increases with number attached

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_stripped_ai.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ScarabFire
{
	// Constants
	string ANIM_MOVE = "walk";
	string ANIM_IDLE = "idle";
	int RANGE_LEAP_MAX = 512;
	int RANGE_LEAP_LONG = 256;
	int RANGE_LEAP_SHORT = 64;
	float FREQ_LEAP = 15.0f;
	float FREQ_CHITTER = 3.6f;
	int DMG_BURN_DOT = 50;
	int DMG_CHEW = 25;
	string EFFECT_SCRIPT = "effects/dot_fire";
	string EFFECT_DURATION = "5.0";
	float LATCH_DURATION = 10.0f;
	string SOUND_CHITTER = "monsters/spider/spideridle.wav";
	string SOUND_STRUCK1 = "body/flesh1.wav";
	string SOUND_STRUCK2 = "body/flesh2.wav";
	string SOUND_STRUCK3 = "body/flesh3.wav";
	string SOUND_PAIN1 = "monsters/spider/spiderhiss.wav";
	string SOUND_PAIN2 = "monsters/spider/spiderhiss.wav";
	string SOUND_DEATH = "monsters/spider/spiderdie.wav";
	string SOUND_LATCH_HISS = "monsters/spider/spiderhiss2.wav";
	string SOUND_LATCH_JUMP = "monsters/spider/spiderjump.wav";
	string SOUND_LATCH_PLYR = "monsters/spider/spiderlatch.wav";
	bool NPC_PROPELLED = true;

	// Variables (an unset .script variable reads as its own name)
	string ANIM_DEATH = "ANIM_DEATH";
	float NPC_GIVE_EXP = 0.0f;
	string NPCATK_TARGET = "NPCATK_TARGET";
	float NPC_SPAWN_TIME = 0.0f;
	float NEXT_LEAP = 0.0f;
	bool JUMP_SCAN_ACTIVE = false;
	bool LATCHED_ON = false;
	string LATCH_TARGET = "LATCH_TARGET";
	bool RUN_AWAY = false;
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	float SKEL_RESPAWN_TIMES = 0.0f;

	// unnamed block (first think)
	void ScarabFire_FirstThink()
	{
		ANIM_DEATH = "die";
	}

	// unnamed block (first think)
	void ScarabFire_FirstThink2()
	{
		NPC_GIVE_EXP = 100.0f;
	}

	// game_spawn
	void ScarabFire_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		NPCATK_TARGET = "unset";
		OnScarabSpawn();
	}

	// scarab_spawn
	void ScarabFire_OnScarabSpawn()
	{
		SetName("Golden Scarab");
		SetModel("monsters/scarab.mdl");
		SetBlood("red");
		SetHealth(150);
		SetWidth(16);
		SetHeight(16);
		SetRoam(true);
		SetRace("spider");
		SetHearingSensitivity(8);
		SetDamageTaken("holy", 0);
		SetDamageTaken("fire", 0);
		SetMoveAnim(ANIM_MOVE);
		SetIdleAnim(ANIM_IDLE);
		SetBoundingBox("npcsize"); // hoping will help with "reach" issues
		SetSolid("none");

		NPC_SPAWN_TIME = GameTime();
	}

	// game_damaged
	string ScarabFire_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		bool blockPrematureDamage = false;
		string result = "";
		float sinceSpawn = GameTime() - NPC_SPAWN_TIME;
		if (sinceSpawn < 2.0f)
		{
			if (RelationshipOf(attacker, ENT_ME) == "enemy")
				blockPrematureDamage = true;
			if (IsPlayer(attacker))
				blockPrematureDamage = true;
			if (blockPrematureDamage)
				result = AppendResult(result, "0");
		}
		return result;
	}

	// game_struck
	void ScarabFire_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(1, 10, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3, SOUND_PAIN1, SOUND_PAIN2);
		if (LATCHED_ON)
			return;
		if (NPCATK_TARGET != "unset")
			return;
		OnScarabSetTarget(EntityOf(ENT_LASTSTRUCK));
	}

	// game_heardsound
	void ScarabFire_OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		// dbg game_heardsound $get(ent_lastheard,name)
		if (LATCHED_ON)
			return;
		if (RUN_AWAY)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (!Exists(heardId))
			return;
		if (!IsAlive(heardId))
			return;
		if (RelationshipOf(heardId, ENT_ME) != "enemy")
			return;
		if (NPCATK_TARGET != "unset")
		{
			if (RangeTo(NPCATK_TARGET) > RangeTo(heardId))
				OnScarabSetTarget(heardId);
		}
		else
		{
			OnScarabSetTarget(heardId);
		}

		if (NPCATK_TARGET == EntityId(heardId))
			SetMoveDest(NPCATK_TARGET, 16);
	}

	// scarab_set_target
	void ScarabFire_OnScarabSetTarget(CBaseEntity@ target = null)
	{
		string oldTarg = NPCATK_TARGET;

		// validate
		if (Truthy(ScriptVarOf(NPCATK_TARGET, "PLAYING_DEAD")))
		{
			NPCATK_TARGET = "unset";
			if (oldTarg != "unset" && IsAlive(oldTarg))
				NPCATK_TARGET = oldTarg;
		}

		NPCATK_TARGET = EntityId(target);
	}

	// unnamed block (timer)
	// main cycle
	void ScarabFire_Timer()
	{
		CallEventDelayed(0.5f, "ScarabFire_Timer");

		if (!IsAlive(ENT_ME))
			return;

		if (NPCATK_TARGET != "unset" && !IsAlive(NPCATK_TARGET))
			NPCATK_TARGET = "unset";

		if (!IsAlive(ENT_ME))
			return;
		if (JUMP_SCAN_ACTIVE)
			return;
		if (I_R_FROZEN)
			return;

		if (RUN_AWAY)
		{
			if (IsAlive(LATCH_TARGET))
			{
				SetMoveDest(LATCH_TARGET, 512, "flee");
				if (RangeTo(LATCH_TARGET) < 32.0f)
					AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 110, 110)));
			}
			else
			{
				OnRunAwayEnd();
			}
		}

		if (RUN_AWAY)
			return;

		if (!LATCHED_ON)
		{
			if (NPCATK_TARGET != "unset" && IsAlive(NPCATK_TARGET))
			{
				// validate
				if (RangeTo(NPCATK_TARGET) < 1024.0f)
				{
					SetMoveDest(NPCATK_TARGET, 16);
					DebugPrint("move to " + NameOf(NPCATK_TARGET));
				}
				else
				{
					NPCATK_TARGET = "unset"; // target too far away
				}

				if (!IsAlive(NPCATK_TARGET))
				{
					NPCATK_TARGET = "unset";
					ServerPlaySound(2, 0, SOUND_CHITTER);
				}

				if (IsAlive(NPCATK_TARGET) && GameTime() > NEXT_LEAP && RangeTo(NPCATK_TARGET) < RANGE_LEAP_MAX) // case invalidated
				{
					NEXT_LEAP = GameTime() + FREQ_LEAP;

					SetMoveDest(NPCATK_TARGET, 999);
					CallEventDelayed(0.1f, "leap_boost");
				}
			}
		}
		else if (!IsAlive(LATCH_TARGET))
			OnDoDismount();
		else
			ApplyEffect(LATCH_TARGET, "effects/scarab_latch", 2.0f, self, DMG_CHEW);
	}

	// leap_boost
	void ScarabFire_OnLeapBoost()
	{
		Vector3 jumpVel = Vec("JUMP_VEL");
		if (!IsAlive(ENT_ME))
			return;

		PlaySound(0, 10, SOUND_LATCH_HISS);

		if (RangeTo(NPCATK_TARGET) >= RANGE_LEAP_LONG)
			jumpVel = RelativeVelocity(Vector3(0, 800, 300));
		if (RangeTo(NPCATK_TARGET) < RANGE_LEAP_LONG)
			jumpVel = RelativeVelocity(Vector3(0, 400, 200));
		if (RangeTo(NPCATK_TARGET) <= RANGE_LEAP_SHORT)
			jumpVel = RelativeVelocity(Vector3(0, 200, 50));

		// adjust for targets above me
		float myZ = OriginOf(ENT_ME).z;
		float targZ = OriginOf(NPCATK_TARGET).z;
		if (IsPlayer(NPCATK_TARGET)) // compensate for origin center
			targZ -= 38.0f;
		float zDiff = targZ - myZ;
		if (zDiff > 64.0f)
		{
			zDiff *= 4.0f;
			jumpVel.z += zDiff;
		}

		AddVelocity(ENT_ME, jumpVel);
		JUMP_SCAN_ACTIVE = true;
		CallEventDelayed(0.1f, "jump_scan");
		CallEventDelayed(1.0f, "end_jump_scan");
	}

	// jump_scan
	void ScarabFire_OnJumpScan()
	{
		if (!IsAlive(ENT_ME))
			return;

		if (!JUMP_SCAN_ACTIVE)
			return;
		CallEventDelayed(0.1f, "jump_scan");
		string inBox = FindInBox("enemy", 32);
		if (inBox == "none")
			return;
		inBox = SortEntities(inBox, "range");
		OnLatchOnto(FindEntity(GetToken(inBox, 0)));
	}

	// end_jump_scan
	void ScarabFire_OnEndJumpScan()
	{
		JUMP_SCAN_ACTIVE = false;
	}

	// latch_onto
	void ScarabFire_OnLatchOnto(CBaseEntity@ target = null)
	{
		if (!IsAlive(ENT_ME))
			return;

		SetSolid("box");
		LATCHED_ON = true;
		JUMP_SCAN_ACTIVE = false;
		LATCH_TARGET = EntityId(target);
		// setfollow LATCH_TARGET align_bottom
		PlayAnim("break");
		PlayAnim("critical", "chew");
		SetIdleAnim("chew");
		SetMoveAnim("chew");
		SetAngle("face.pitch", 0);
		ApplyEffect(LATCH_TARGET, EFFECT_SCRIPT, EFFECT_DURATION, self, DMG_BURN_DOT);
		// setbbox (-40,-40,0) (40,40,128)
		OnSpiderLatchThink();
		CallEventDelayed(LATCH_DURATION, "do_dismount");
	}

	// spider_latch_think
	void ScarabFire_OnSpiderLatchThink()
	{
		Vector3 targOrg;

		if (!IsAlive(ENT_ME))
			return;

		if (!LATCHED_ON)
			return;

		// target face
		if (IsPlayer(LATCH_TARGET))
		{
			targOrg = EyePositionOf(LATCH_TARGET);
		}
		else
		{
			targOrg = OriginOf(LATCH_TARGET);
			float targHeight = HeightOf(LATCH_TARGET);
			targOrg.z += targHeight;
		}

		int rndVPos = RandomInt(-64, 0);
		float targYaw = AnglesOf(LATCH_TARGET).y;
		targOrg += RelativePosition(Vector3(0, targYaw, 0), Vector3(0, 5, rndVPos));

		float targGround = GroundHeight(targOrg);
		if (targOrg.z < targGround)
		{
			targOrg.z = targGround;
			targOrg.z += 32.0f; // don't latch on beneath ground for I may fall of the map when I release
		}

		SetOrigin(ENT_ME, targOrg);
	}

	// do_dismount
	void ScarabFire_OnDoDismount()
	{
		if (!IsAlive(ENT_ME))
			return;

		if (!LATCHED_ON)
			return;

		SetSolid("none");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_MOVE);

		OnRollAway();

		LATCHED_ON = false;
	}

	// roll_away
	void ScarabFire_OnRollAway()
	{
		if (!IsAlive(ENT_ME))
			return;
		Vector3 targetOrg = OriginOf(LATCH_TARGET);
		float targAng = AnglesTo(MyOrigin(), targetOrg);
		SetMoveDest(LATCH_TARGET, 512, "flee");
		SetProp(ENT_ME, "movetype", 8);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, Float(Eval("game.monster.angles.yaw")), 0), Vector3(10, 500, 10)));
		RUN_AWAY = true;
		NPC_HACKED_MOVE_SPEED = 50.0f;
		SetAnimFrameRate(2);
		CallEventDelayed(5.0f, "run_away_end");
		CallEventDelayed(0.1f, "fix_bbox");
	}

	// fix_bbox
	void ScarabFire_OnFixBbox()
	{
		SetProp(ENT_ME, "movetype", 4);
	}

	// run_away_end
	void ScarabFire_OnRunAwayEnd()
	{
		NPC_HACKED_MOVE_SPEED = 25.0f;
		SetAnimFrameRate(1);
		RUN_AWAY = false;
	}

	// unnamed block (timer)
	void ScarabFire_Timer2()
	{
		CallEventDelayed(FREQ_CHITTER, "ScarabFire_Timer2");

		if (!IsAlive(ENT_ME))
			return;
		if (LATCHED_ON)
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;

		ServerPlaySound(2, 5, SOUND_CHITTER);
	}

	// game_death
	void ScarabFire_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayAnim("hold", ANIM_DEATH);
		ServerPlaySound(2, 0, SOUND_CHITTER);
		PlaySound(1, 10, SOUND_DEATH);
	}

	// unnamed block (first think)
	void ScarabFire_FirstThink3()
	{
		NPC_HACKED_MOVE_SPEED = 25.0f;
	}

	// game_movingto_dest
	// Hack in movement because the model anims are missing it
	void ScarabFire_OnGameMovingtoDest(Vector3 angles = Vector3())
	{
		if (I_R_FROZEN)
			return;
		if (LATCHED_ON)
			return;
		SetAnimMoveSpeed(NPC_HACKED_MOVE_SPEED); // Force move, since the animation doesn't have the required movement
	}

	// game_stopmoving
	void ScarabFire_OnGameStopmoving()
	{
		SetAnimMoveSpeed(0); // Force Stop
	}

	// npc_suicide
	void ScarabFire_OnNpcSuicide(string suicideMode = "")
	{
		bool exitSub = false;

		if (suicideMode == "no_pets")
		{
			// (never true here, the rest is skipped) if I_R_PET
		}

		if (suicideMode == "only_bad")
		{
			if (RaceOf(ENT_ME) == "human")
				exitSub = true;
			if (RaceOf(ENT_ME) == "hguard")
				exitSub = true;
		}
		if (exitSub)
			return;

		SetInvincible(false);
		SetRace("hated");
		SKEL_RESPAWN_TIMES = 99.0f;
		DoDamage(ENT_ME, "direct", 30000, 100, GetVar("GAME_MASTER"), "target");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseStrippedAi_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_stripped_ai
		ScarabFire_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// npc_suicide
	void OnNpcSuicide(string suicideMode = "")
	{
		MonstersExternals_OnNpcSuicide(suicideMode); // monsters/externals
		ScarabFire_OnNpcSuicide(suicideMode);
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseStrippedAi_OnGameSpawn(playerRace, playerGender); // monsters/base_stripped_ai
		ScarabFire_OnGameSpawn(playerRace, playerGender);
	}

	void OnScarabSpawn() { ScarabFire_OnScarabSpawn(); } // scarab_spawn
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return ScarabFire_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { ScarabFire_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f) { ScarabFire_OnGameHeardsound(soundType, origin, dangerRadius); } // game_heardsound
	void OnScarabSetTarget(CBaseEntity@ target = null) { ScarabFire_OnScarabSetTarget(target); } // scarab_set_target
	void OnLeapBoost() { ScarabFire_OnLeapBoost(); } // leap_boost
	void OnJumpScan() { ScarabFire_OnJumpScan(); } // jump_scan
	void OnEndJumpScan() { ScarabFire_OnEndJumpScan(); } // end_jump_scan
	void OnLatchOnto(CBaseEntity@ target = null) { ScarabFire_OnLatchOnto(target); } // latch_onto
	void OnSpiderLatchThink() { ScarabFire_OnSpiderLatchThink(); } // spider_latch_think
	void OnDoDismount() { ScarabFire_OnDoDismount(); } // do_dismount
	void OnRollAway() { ScarabFire_OnRollAway(); } // roll_away
	void OnFixBbox() { ScarabFire_OnFixBbox(); } // fix_bbox
	void OnRunAwayEnd() { ScarabFire_OnRunAwayEnd(); } // run_away_end
	void OnGameMovingtoDest(Vector3 angles = Vector3()) { ScarabFire_OnGameMovingtoDest(angles); } // game_movingto_dest
	void OnGameStopmoving() { ScarabFire_OnGameStopmoving(); } // game_stopmoving
	void OnLatchDuration() {} // LATCH_DURATION

	// This file's events and timers by their .script names
	bool ScarabFire_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_dismount") { OnDoDismount(); return true; }
		if (name == "end_jump_scan") { OnEndJumpScan(); return true; }
		if (name == "fix_bbox") { OnFixBbox(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "game_movingto_dest") { OnGameMovingtoDest(Vec(Param(params, 0))); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_stopmoving") { OnGameStopmoving(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "jump_scan") { OnJumpScan(); return true; }
		if (name == "latch_onto") { OnLatchOnto(EntityParam(params, 0)); return true; }
		if (name == "leap_boost") { OnLeapBoost(); return true; }
		if (name == "npc_suicide") { OnNpcSuicide(Param(params, 0)); return true; }
		if (name == "roll_away") { OnRollAway(); return true; }
		if (name == "run_away_end") { OnRunAwayEnd(); return true; }
		if (name == "scarab_set_target") { OnScarabSetTarget(EntityParam(params, 0)); return true; }
		if (name == "scarab_spawn") { OnScarabSpawn(); return true; }
		if (name == "spider_latch_think") { OnSpiderLatchThink(); return true; }
		if (name == "ScarabFire_Timer") { ScarabFire_Timer(); return true; }
		if (name == "ScarabFire_Timer2") { ScarabFire_Timer2(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/scarab_fire"]
shared class ScarabFireScript : BaseStrippedAiScript, ScarabFire
{
	// Variables declared by included files, with the value they start with in this script
	ScarabFireScript()
	{
		ANIM_IDLE = "idle";
		SOUND_STRUCK1 = "body/flesh1.wav";
		SOUND_STRUCK2 = "body/flesh2.wav";
		SOUND_STRUCK3 = "body/flesh3.wav";
		SOUND_PAIN1 = "monsters/spider/spiderhiss.wav";
		SOUND_PAIN2 = "monsters/spider/spiderhiss.wav";
		SOUND_DEATH = "monsters/spider/spiderdie.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/scarab.mdl");
		Precache("monsters/spider/spideridle.wav");
		CallEventDelayed(0.5f, "ScarabFire_Timer");
		CallEventDelayed(FREQ_CHITTER, "ScarabFire_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ScarabFire_FirstThink();
		ScarabFire_FirstThink2();
		MonstersExternals_FirstThink();
		ScarabFire_FirstThink3();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ScarabFire_DispatchEvent(name, params)
			|| BaseStrippedAiScript::DispatchEvent(name, params);
	}
}
