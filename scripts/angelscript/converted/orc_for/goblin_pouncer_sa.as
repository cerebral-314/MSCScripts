#pragma context server

// Converted from orc_for/goblin_pouncer_sa.script by msc_transpiler.
// HP(-50%)/XP(-20%) reduce MAY2011_30, due to people having issues hitting it.

#include "runtime/ScriptEntity.as"
#include "converted/orc_for/goblin_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class GoblinPouncerSa
{
	// Constants
	string ANIM_LEAP_READY = "pounce_ready";
	string ANIM_LEAP = "pounce_fly";
	string ANIM_LEAP_RIDE = "pounce_latch";
	bool AS_CUSTOM_UNSTUCK = true;
	bool GOBLIN_SELF_ADJUST = true;
	string NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
	string NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;";
	string NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;";
	string NPC_BASE_EXP = "200";
	int LEAP_RANGE = 500;
	float FREQ_LEAP = 15.0f;
	float DMG_SWORD = 15.0f;
	int DMG_POUND = 5;
	float FREQ_LAUGH = 0.0f;
	string SOUND_LEAP_READY = "monsters/goblin/c_gargoyle_bat1.wav";
	string SOUND_LEAP_GO = "monsters/goblin/c_gargoyle_atk3.wav";
	string SOUND_LAUGH = "monsters/goblin/c_gargoyle_bat2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool NPC_SELF_ADJUST = false;
	string ATTACK_HITCHANCE = "ATTACK_HITCHANCE";
	bool LEAP_MODE = false;
	float NEXT_LATCH_ATTEMPT = 0.0f;
	string LEAP_TARGET = "LEAP_TARGET";
	bool DID_WARNING = false;
	bool IN_LEAP = false;
	bool AM_LATCHED = false;
	string LATCH_TARGET = "LATCH_TARGET";
	float LATCH_END = 0.0f;
	bool WAS_LATCHED = false;
	bool PICKED_RANDOM = false;
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_IDLE = "ANIM_IDLE";
	float NEXT_LAUGH = 0.0f;
	bool NPC_FORCED_MOVEDEST = false;
	float AS_UNSTUCK_ANG = 0.0f;
	string TARG_LIST = "TARG_LIST";

	// unnamed block (first think)
	void GoblinPouncerSa_FirstThink()
	{
		ANIM_ATTACK = "swordswing1_L";
	}

	// unnamed block (first think)
	void GoblinPouncerSa_FirstThink2()
	{
		NPC_SELF_ADJUST = GOBLIN_SELF_ADJUST;
		ATTACK_HITCHANCE = "90%";
	}

	// goblin_spawn
	void GoblinPouncerSa_OnGoblinSpawn()
	{
		SetName("Goblin Pouncer");
		SetModel("monsters/goblin_new.mdl");
		SetHealth(50);
		SetWidth(24);
		SetHeight(50);
		SetRace("goblin");
		SetBlood("red");
		SetRoam(true);
		SetHearingSensitivity(2);
		SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
		SetModelBody(1, 0); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
		SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
		SetModelBody(3, 0); // arrow: On/off

		SetProp(ENT_ME, "skin", 3);

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
	}

	// npc_targetsighted
	void GoblinPouncerSa_OnNpcTargetsighted(string target = "")
	{
		if (LEAP_MODE)
			return;
		if (!(GameTime() > NEXT_LATCH_ATTEMPT))
			return;
		if (!(RangeTo(NPCATK_TARGET) < LEAP_RANGE))
			return;
		if (HasEffect(NPCATK_TARGET, "goblin_latch")) // cant latch if target already has a rider
			return;
		LEAP_MODE = true;
		NEXT_LATCH_ATTEMPT = GameTime() + FREQ_LEAP;
		OnLeapReady();
	}

	// leap_ready
	void GoblinPouncerSa_OnLeapReady()
	{
		PlaySound(0, 10, SOUND_LEAP_READY);
		LEAP_TARGET = NPCATK_TARGET;
		if (!DID_WARNING)
		{
			DID_WARNING = true;
			InfoMessage(LEAP_TARGET, "Beware the Goblin Pouncer", "If he pounces you, you'll have to be rescued by another player!");
		}
		OnReadyLeapMode();
		OnLeapTargetLoop();
		CallEventDelayed(3.0f, "do_leap");
	}

	// leap_target_loop
	void GoblinPouncerSa_OnLeapTargetLoop()
	{
		DebugPrint("leap_target_loop");
		if (!LEAP_MODE)
			return;
		if (IN_LEAP)
			return;
		SetMoveDest(LEAP_TARGET, 9999);
		CallEventDelayed(0.1f, "leap_target_loop");
	}

	// do_leap
	void GoblinPouncerSa_OnDoLeap()
	{
		bool exitSub = false;
		DebugPrint("do_leap");
		if (CanSee(LEAP_TARGET))
		{
			if (Truthy(ScriptVarOf(LEAP_TARGET, "PLAYING_DEAD")))
			{
				// target invalidated
				OnExitLeapMode();
				NEXT_LATCH_ATTEMPT = GameTime() + 2.0f;
				LEAP_MODE = false;
				exitSub = true;
			}
			if (!exitSub)
			{
				if (RangeTo(LEAP_TARGET) < LEAP_RANGE)
				{
					PlaySound(0, 10, SOUND_LEAP_GO);
					PlayAnim("hold", ANIM_LEAP);
					if (!I_R_FROZEN)
						AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 1000, 200)));
					IN_LEAP = true;
					CallEventDelayed(1.0f, "end_leap_scan");
					OnLeapScan();
				}
				else
				{
					// targe out of range
					OnExitLeapMode();
					NEXT_LATCH_ATTEMPT = GameTime() + 2.0f;
					LEAP_MODE = false;
				}
			}
		}
		else
		{
			// aborted, can't see target
			OnExitLeapMode();
			NEXT_LATCH_ATTEMPT = GameTime() + 5.0f;
			LEAP_MODE = false;
		}
	}

	// leap_scan
	void GoblinPouncerSa_OnLeapScan()
	{
		if (!IN_LEAP)
			return;
		DebugPrint("leap_scan");
		if (RangeTo(LEAP_TARGET) < 64.0f)
		{
			if (!I_R_FROZEN)
				OnLatchTarget2(LEAP_TARGET);
		}
		else
		{
			string scanTokens = FindInSphere("enemy", 64);
			if (scanTokens != "none")
			{
				CBaseEntity@ scanNme = FindEntity(GetToken(scanTokens, 0));
				if (IsAlive(scanNme))
				{
					LEAP_TARGET = EntityId(scanNme);
					OnLatchTarget2(LEAP_TARGET);
				}
			}
		}
		if (AM_LATCHED)
			return;
		if (!IN_LEAP)
			return;
		CallEventDelayed(0.1f, "leap_scan");
	}

	// end_leap_scan
	void GoblinPouncerSa_OnEndLeapScan()
	{
		DebugPrint("end_leap_scan");
		IN_LEAP = false;
		if (AM_LATCHED)
			return;
		LEAP_MODE = false;
		OnExitLeapMode();
		NEXT_LATCH_ATTEMPT = GameTime() + FREQ_LEAP;
	}

	// latch_target
	// <target>
	void GoblinPouncerSa_OnLatchTarget2(string target = "")
	{
		if (HasEffect(target, "goblin_latch")) // cant latch if target already has a rider
			return;
		DebugPrint("latch_target");
		AM_LATCHED = true;
		LATCH_TARGET = target;
		PlayAnim("break");
		OnRideMode();
		Vector3 latchPos = OriginOf(LATCH_TARGET);
		float targYaw = AnglesOf(LATCH_TARGET).y;
		latchPos += RelativePosition(Vector3(0, targYaw, 0), Vector3(0, -16, 32));
		SetOrigin(ENT_ME, latchPos);
		SetAngle("face", Vector3(0, targYaw, 0));
		LegacyCommand("setfollow", LATCH_TARGET, "align_bottom");
		LATCH_END = GameTime() + 20.0f;
		OnLatchThink();
		ApplyEffect(LATCH_TARGET, "effects/goblin_latch", 20, self);
		if (!IsPlayer(LATCH_TARGET))
			return;
		string outTitle = NameOf(LATCH_TARGET);
		string outMsg = "Has been pounced!";
		InfoMessage("all", outTitle, outMsg);
	}

	// player_left
	void GoblinPouncerSa_OnPlayerLeft(CBaseEntity@ player = null)
	{
		if (!AM_LATCHED)
			return;
		if (EntityId(player) != LATCH_TARGET)
			return;
		OnEndLatch();
	}

	// latch_think
	void GoblinPouncerSa_OnLatchThink()
	{
		DebugPrint("latch_think");
		if (!AM_LATCHED)
			return;
		CallEventDelayed(0.25f, "latch_think");
		// not letting go unless either I or the player dies
		if (!IsAlive(LATCH_TARGET))
			OnEndLatch();
		if (!AM_LATCHED)
			return;
		if (GameTime() > LATCH_END)
			OnEndLatch();
	}

	// end_latch
	void GoblinPouncerSa_OnEndLatch()
	{
		DebugPrint("end_latch");
		WAS_LATCHED = true;
		PICKED_RANDOM = false;
		AM_LATCHED = false;
		LEAP_MODE = false;
		IN_LEAP = false;
		LegacyCommand("setfollow", "none");
		NEXT_LATCH_ATTEMPT = GameTime() + FREQ_LEAP;
		OnExitRideMode();
		PlaySound(0, 10, SOUND_LAUGH);
		if (IsAlive(LATCH_TARGET))
		{
			OnNpcatkFlee(LATCH_TARGET, "1024", "3.0");
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -600, 110)));
		}
	}

	// bs_global_command
	void GoblinPouncerSa_OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		if (!AM_LATCHED)
			return;
		if (EntityId(deadPlayer) != LATCH_TARGET)
			return;
		if (reason != "death")
			return;
		OnEndLatch();
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type PARAM4=accuracy_roll PARAM5=skill
	string GoblinPouncerSa_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!AM_LATCHED)
			return result;
		DebugPrint("game_damaged " + Text(AM_LATCHED) + " by " + NameOf(attacker) + " vs " + NameOf(LATCH_TARGET));
		if (!IsAlive(LATCH_TARGET)) // probably redundant, but odd reports
			return result;
		if (EntityId(attacker) != LATCH_TARGET)
			return result;
		if (Contains(damageType, "effect"))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// game_death
	void GoblinPouncerSa_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (AM_LATCHED)
		{
			LegacyCommand("setfollow", "none");
			if (IsPlayer(ENT_LASTSTRUCK) && IsPlayer(LATCH_TARGET) && EntityId(EntityOf(ENT_LASTSTRUCK)) != LATCH_TARGET)
			{
				string bonusMsg = "for rescuing " + NameOf(LATCH_TARGET);
				CallExternal(ENT_LASTSTRUCK, "ext_dmgpoint_bonus", 1000, bonusMsg);
				CallExternal(LATCH_TARGET, "ext_goblin_died");
			}
		}
	}

	// ride_mode
	void GoblinPouncerSa_OnRideMode()
	{
		ANIM_RUN = ANIM_LEAP_RIDE;
		ANIM_WALK = ANIM_LEAP_RIDE;
		ANIM_IDLE = ANIM_LEAP_RIDE;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("critical", ANIM_LEAP_RIDE);
		OnNpcatkSuspendAi();
	}

	// ready_leap_mode
	void GoblinPouncerSa_OnReadyLeapMode()
	{
		ANIM_RUN = ANIM_LEAP_READY;
		ANIM_WALK = ANIM_LEAP_READY;
		ANIM_IDLE = ANIM_LEAP_READY;
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("hold", ANIM_LEAP_READY);
		OnNpcatkSuspendAi();
	}

	// exit_leap_mode
	void GoblinPouncerSa_OnExitLeapMode()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("break");
		PlayAnim("critical", ANIM_RUN);
		OnNpcatkResumeAi();
	}

	// exit_ride_mode
	void GoblinPouncerSa_OnExitRideMode()
	{
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_IDLE = "idle1";
		SetMoveAnim(ANIM_RUN);
		SetIdleAnim(ANIM_IDLE);
		PlayAnim("break");
		PlayAnim("critical", ANIM_RUN);
		OnNpcatkResumeAi();
	}

	// frame_pounce_pound
	void GoblinPouncerSa_OnFramePouncePound()
	{
		bool doLaugh = false;
		if (!AM_LATCHED)
			return;
		if (!IsAlive(LATCH_TARGET))
			return;
		DoDamage(LATCH_TARGET, "direct", DMG_POUND, "100%", ENT_ME, "blunt_effect");

		if (GameTime() > NEXT_LAUGH)
		{
			NEXT_LAUGH = GameTime() + FREQ_LAUGH;
			doLaugh = true;
		}

		if (!doLaugh)
			CallExternal(LATCH_TARGET, "ext_playrandomsound", 2, 5, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
		else
			CallExternal(LATCH_TARGET, "ext_playsound_kiss", 1, 10, SOUND_LAUGH);
	}

	// npc_stuck
	void GoblinPouncerSa_OnNpcStuck()
	{
		if (!SUSPEND_AI)
			OnAsNpcatkSuspendAi(AS_WIGGLE_DURATION);
		NPC_FORCED_MOVEDEST = true;
		string moveDest = "MY_ORG";
		AS_UNSTUCK_ANG += 36.0f;
		if (AS_UNSTUCK_ANG > 359.0f)
			AS_UNSTUCK_ANG -= 359.0f;
		// dbg npcatk_anti_stuck stuck_count STUCK_COUNT ang AS_UNSTUCK_ANG
		moveDest = Text(Vec(moveDest) + RelativePosition(Vector3(0, AS_UNSTUCK_ANG, 0), Vector3(0, 1000, 0)));
		SetMoveDest(moveDest, AS_MOVEPROX); // I'd love to have them trace along a wall, but I can't figure how to pull that.
		PlayAnim("once", ANIM_RUN);

		// I may have fallen off the map when unlatching
		DebugPrint("npc_stuck " + Text(STUCK_COUNT));
		if (!WAS_LATCHED)
			return;
		if (!(STUCK_COUNT > 3.0f))
			return;
		OnExtWinkOut(NPC_SPAWN_LOC, 1.0f);
		WAS_LATCHED = false;
	}

	// npcatk_hunt
	void GoblinPouncerSa_OnNpcatkHunt()
	{
		if (NPCATK_TARGET != "unset")
			return;
		if (PICKED_RANDOM)
			return;
		if (!WAS_LATCHED)
			return;
		if (HUNTING_PLAYER)
			return;
		TARG_LIST = GetActivePlayers();
		TARG_LIST = TokenShuffle(TARG_LIST);
		string rndPlr = GetToken(TARG_LIST, 0);
		if (!IsAlive(rndPlr))
			return;
		PICKED_RANDOM = true;
		// pick a random player target to ensure anti-stuck keeps pulsing after a ride
		// in case I fell off map
		OnNpcatkSettarget(rndPlr, "random_select");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		GoblinBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // orc_for/goblin_base
		GoblinPouncerSa_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// bs_global_command
	void OnBsGlobalCommand(CBasePlayer@ deadPlayer = null, string command = "", string reason = "")
	{
		MonstersExternals_OnBsGlobalCommand(deadPlayer, command, reason); // monsters/externals
		GoblinPouncerSa_OnBsGlobalCommand(deadPlayer, command, reason);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		GoblinBase_OnNpcatkHunt(); // orc_for/goblin_base
		GoblinPouncerSa_OnNpcatkHunt();
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GoblinBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, GoblinPouncerSa_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		GoblinPouncerSa_OnNpcTargetsighted(target);
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		GoblinBase_OnGoblinSpawn(); // orc_for/goblin_base
		GoblinPouncerSa_OnGoblinSpawn();
	}

	void OnLeapReady() { GoblinPouncerSa_OnLeapReady(); } // leap_ready
	void OnLeapTargetLoop() { GoblinPouncerSa_OnLeapTargetLoop(); } // leap_target_loop
	void OnDoLeap() { GoblinPouncerSa_OnDoLeap(); } // do_leap
	void OnLeapScan() { GoblinPouncerSa_OnLeapScan(); } // leap_scan
	void OnEndLeapScan() { GoblinPouncerSa_OnEndLeapScan(); } // end_leap_scan
	void OnLatchTarget2(string target = "") { GoblinPouncerSa_OnLatchTarget2(target); } // latch_target
	void OnPlayerLeft(CBaseEntity@ player = null) { GoblinPouncerSa_OnPlayerLeft(player); } // player_left
	void OnLatchThink() { GoblinPouncerSa_OnLatchThink(); } // latch_think
	void OnEndLatch() { GoblinPouncerSa_OnEndLatch(); } // end_latch
	void OnRideMode() { GoblinPouncerSa_OnRideMode(); } // ride_mode
	void OnReadyLeapMode() { GoblinPouncerSa_OnReadyLeapMode(); } // ready_leap_mode
	void OnExitLeapMode() { GoblinPouncerSa_OnExitLeapMode(); } // exit_leap_mode
	void OnExitRideMode() { GoblinPouncerSa_OnExitRideMode(); } // exit_ride_mode
	void OnFramePouncePound() { GoblinPouncerSa_OnFramePouncePound(); } // frame_pounce_pound
	void OnNpcStuck() { GoblinPouncerSa_OnNpcStuck(); } // npc_stuck
	void OnAsNpcatkSuspendAi(float value = 0.0f, string value2 = "") {} // as_npcatk_suspend_ai

	// This file's events and timers by their .script names
	bool GoblinPouncerSa_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bs_global_command") { OnBsGlobalCommand(PlayerParam(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "do_leap") { OnDoLeap(); return true; }
		if (name == "end_latch") { OnEndLatch(); return true; }
		if (name == "end_leap_scan") { OnEndLeapScan(); return true; }
		if (name == "exit_leap_mode") { OnExitLeapMode(); return true; }
		if (name == "exit_ride_mode") { OnExitRideMode(); return true; }
		if (name == "frame_pounce_pound") { OnFramePouncePound(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "latch_target") { OnLatchTarget2(Param(params, 0)); return true; }
		if (name == "latch_think") { OnLatchThink(); return true; }
		if (name == "leap_ready") { OnLeapReady(); return true; }
		if (name == "leap_scan") { OnLeapScan(); return true; }
		if (name == "leap_target_loop") { OnLeapTargetLoop(); return true; }
		if (name == "npc_stuck") { OnNpcStuck(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "player_left") { OnPlayerLeft(EntityParam(params, 0)); return true; }
		if (name == "ready_leap_mode") { OnReadyLeapMode(); return true; }
		if (name == "ride_mode") { OnRideMode(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "orc_for/goblin_pouncer_sa"]
shared class GoblinPouncerSaScript : GoblinBaseScript, GoblinPouncerSa
{
	// Variables declared by included files, with the value they start with in this script
	GoblinPouncerSaScript()
	{
		NPC_ADJ_TIERS = "0;750;1500;2000;3000;5000";
		NPC_ADJ_DMG_MUTLI_TOKENS = "1.0;1.5;2.0;5.0;7.5;10.0;";
		NPC_ADJ_HP_MUTLI_TOKENS = "1.0;2.0;3.0;5.0;7.5;10.0;";
		NPC_BASE_EXP = "200";
		DMG_SWORD = 15.0f;
		ANIM_WALK = "ANIM_WALK";
		ANIM_IDLE = "ANIM_IDLE";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/goblin_new.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		GoblinPouncerSa_FirstThink();
		GoblinPouncerSa_FirstThink2();
		GoblinBase_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return GoblinPouncerSa_DispatchEvent(name, params)
			|| GoblinBaseScript::DispatchEvent(name, params);
	}
}
