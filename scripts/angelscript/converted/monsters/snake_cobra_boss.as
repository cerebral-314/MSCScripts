#pragma context server

// Converted from monsters/snake_cobra_boss.script by msc_transpiler.
// . tele -1568 -1776 -560
// Gargantuan Cobra by Thothie (from Giant Cobra)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SnakeCobraBoss
{
	// Constants
	float MONSTER_HP = 12000.0f;
	int DMG_SPIT = 400;
	float DMG_BITE = 0.0f;
	int DMG_POISON_DOT = 25;
	int DMG_GAS_DOT = 75;
	string POISON_DURATION = "5.0";
	float GAS_DURATION = 30.0f;
	string MONSTER_MODEL = "monsters/gcobra_boss.mdl";
	string ANIM_SPIT = "spit";
	string SOUND_SPIT = "agrunt/ag_attack2.wav";
	string CL_SCRIPT = "monsters/snake_cobra_boss_cl";
	string ANIM_BREATH = "breath";
	string ANIM_IDLE_NORM = "idle1";
	string ANIM_SLEEP = "idle2";
	string ATTACK_HITCHANCE = "80%";
	string SOUND_ALERT = "monsters/gsnake_idle1.wav";
	string SOUND_IDLE = "monsters/gsnake_idle1.wav";
	string SOUND_ATTACK = "agrunt/ag_attack2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	string SOUND_STRUCK = "debris/flesh3.wav";
	string SOUND_PAIN1 = "agrunt/ag_attack3.wav";
	string SOUND_PAIN2 = "agrunt/ag_idle2.wav";
	string SOUND_DEATH = "agrunt/ag_die2.wav";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_IDLE = "ANIM_IDLE";
	float NPC_GIVE_EXP = 0.0f;
	bool NPC_IS_BOSS = false;
	string CAN_RETALIATE = "CAN_RETALIATE";
	string ANIM_WALK = "ANIM_WALK";
	string ANIM_RUN = "ANIM_RUN";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	string CL_IDX = "CL_IDX";
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	bool SLEEP_MODE = false;
	bool CYCLE_STARTED = false;
	bool DOING_SPECIAL = false;
	float SPIT_LOOPS = 0.0f;
	bool SPIT_MODE = false;
	string PLAYER_LIST = "PLAYER_LIST";
	float NEXT_SPIT = 0.0f;
	string SPIT_TARGET = "SPIT_TARGET";
	int ATTACK_ANIMINDEX = 0;
	float CUR_ANG = 0.0f;
	float CLOUD_COUNT = 0.0f;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";

	// unnamed block (first think)
	void SnakeCobraBoss_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;
		if (ToLowerCase(MapName()) == "gertenheld_cave")
		{
			NPC_IS_BOSS = true;
			NPC_GIVE_EXP = 8000.0f;
		}
		else
		{
			NPC_GIVE_EXP = 400.0f;
		}
		CAN_RETALIATE = "0"; // kinda single minded

		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = ANIM_SLEEP;
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 350.0f;
		ATTACK_HITRANGE = 400.0f;
		ATTACK_MOVERANGE = 300.0f;
	}

	// npc_spawn
	void SnakeCobraBoss_OnNpcSpawn(string npc = "")
	{
		SetName("Gargantuan Cobra");
		SetHealth(MONSTER_HP);
		SetDamageTaken("all", 0.95f); // dridje wants 5% armor *shrug*
		SetWidth(300);
		SetHeight(250);
		SetRace("demon"); // for easier placement
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(0);
		OnSleepMode();
		CallEventDelayed(0.2f, "post_spawn_props");
		CallEventDelayed(1.0f, "idle_sounds");

		if (!AM_TURRET)
			return;
		NO_STUCK_CHECKS = "1";
		SetMoveSpeed(0);
		ANIM_WALK = ANIM_IDLE_NORM;
		ANIM_RUN = ANIM_IDLE_NORM;

		CallEventDelayed(1.0f, "setup_client");
	}

	// setup_client
	void SnakeCobraBoss_OnSetupClient()
	{
		ClientEvent("new", "all", CL_SCRIPT);
		CL_IDX = LastClientScriptId();
	}

	// idle_sounds
	void SnakeCobraBoss_OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// post_spawn_props
	void SnakeCobraBoss_OnPostSpawnProps()
	{
		SetDamageTaken("holy", 0); // not actually a demon :)
	}

	// attack1
	void SnakeCobraBoss_OnAttack1()
	{
		PlaySound(2, 10, SOUND_ATTACK);
		BITE_SOUND = true;
		if (!(RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE))
			return;
		OnNpcatkDodamage(NPCATK_TARGET, "direct", Text(DMG_BITE), ATTACK_HITCHANCE, ENT_ME, "pierce");
	}

	// game_damaged_other
	// PARAM1=ent hit PARAM2=damage
	string SnakeCobraBoss_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!BITE_SOUND)
			return result;
		BITE_SOUND = false;
		if (RandomInt(1, 2) != 1)
			return result;
		PlaySound(0, 10, SOUND_POISON);
		ApplyEffect(target, "effects/dot_poison", POISON_DURATION, self, DMG_POISON_DOT);
		return result;
	}

	// game_struck
	void SnakeCobraBoss_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK, SOUND_STRUCK);
	}

	// npcatk_targetvalidate
	void SnakeCobraBoss_OnNpcatkTargetvalidate(string target = "")
	{
		if (!IsAlive(target))
			return;
		if (RelationshipOf(target, ENT_ME) != "enemy")
			return;

		if (DID_ALERT)
			return;
		PlaySound(0, 10, SOUND_ALERT);
		OnWakeUp();
		DID_ALERT = true;
	}

	// my_target_died
	void SnakeCobraBoss_OnMyTargetDied(string offender = "")
	{
		SetMoveDest(NPC_SPAWN_LOC, 10);
		OnIdleSounds();
		DID_ALERT = false;
		OnNpcatkGoHome();
	}

	// npc_made_it_home
	void SnakeCobraBoss_OnNpcMadeItHome()
	{
		OnSleepMode();
	}

	// sleep_mode
	// { npcatk_attack
	// setvard NPC_DELAYING_UNSTUCK NPC_UNSTUCK_DELAY //I've stopped moving to attack, I'm not stuck
	// if !ATTACK_DELAY
	// playanim critical ANIM_ATTACK
	// playsound 0 10 SOUND_ATTACK
	// setvard ATTACK_DELAY 1
	// callevent 1.0 reset_attack_delay
	// }
	// { reset_attack_delay
	// setvard ATTACK_DELAY 0
	// }
	void SnakeCobraBoss_OnSleepMode()
	{
		if (!AM_TURRET)
			NO_STUCK_CHECKS = "1";
		SLEEP_MODE = true;
		SetRoam(false);
		SetIdleAnim(ANIM_SLEEP);
		SetMoveAnim(ANIM_SLEEP);
		ANIM_IDLE = ANIM_SLEEP;
	}

	// wake_up
	void SnakeCobraBoss_OnWakeUp()
	{
		if (!AM_TURRET)
			NO_STUCK_CHECKS = "0";
		SLEEP_MODE = false;
		SetIdleAnim(ANIM_IDLE_NORM);
		SetMoveAnim(ANIM_WALK);
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetRoam(true);

		if (CYCLE_STARTED)
			return;
		CYCLE_STARTED = true;
		CallEventDelayed(15.0f, "do_special");
	}

	// do_special
	void SnakeCobraBoss_OnDoSpecial()
	{
		if (!IsAlive(ENT_ME))
			return;
		float nextSpecial = 20.0f;

		if (IsAlive(NPCATK_TARGET) && !SUSPEND_AI)
		{
			int rndSpecial = RandomInt(1, 2);
			if (rndSpecial == 1)
			{
				nextSpecial = 40.0f;
				DOING_SPECIAL = true;
				OnDoSpit();
			}
			if (rndSpecial == 2)
			{
				nextSpecial = 40.0f;
				OnDoCloud();
			}
		}

		CallEventDelayed(nextSpecial, "do_special");
	}

	// do_spit
	void SnakeCobraBoss_OnDoSpit()
	{
		if (SPIT_MODE)
			return;
		SPIT_LOOPS += 1.0f;
		if (!(SPIT_LOOPS < 2.0f)) // weirdness going on here
			return;
		SPIT_MODE = true;
		if (!AM_TURRET)
			NO_STUCK_CHECKS = "1";
		OnNpcatkSuspendAi();
		SetIdleAnim(ANIM_SPIT);
		SetMoveAnim(ANIM_SPIT);
		PlayAnim("critical", ANIM_SPIT);
		PLAYER_LIST = GetActivePlayers();
		PLAYER_LIST = TokenShuffle(PLAYER_LIST);
		OnDoSpitLoop();
		CallEventDelayed(15.0f, "end_spit_mode");
	}

	// do_spit_loop
	void SnakeCobraBoss_OnDoSpitLoop()
	{
		if (!SPIT_MODE)
			return;
		CallEventDelayed(0.1f, "do_spit_loop");

		string curTarget = GetToken(PLAYER_LIST, 0);

		// check if can hit before spitting
		Vector3 mouthPos = BonePositionOf(ENT_ME, 6);
		Vector3 targPos = OriginOf(curTarget);
		string traceIt = LegacyFunction("get_traceline", mouthPos, targPos, "worldonly");
		bool traceFail = true;
		if (RangeTo(curTarget) < 800.0f) // if he's this close, try to hit him anyways
			traceIt = Text(targPos);
		if (traceIt != Text(targPos))
			OnNewSpitTarget();
		else
			traceFail = false;
		if (traceFail)
			return;

		if (!(GameTime() > NEXT_SPIT))
			return;
		NEXT_SPIT = GameTime() + 0.5f;

		SetMoveDest(curTarget, 99999);
		SPIT_TARGET = curTarget;
	}

	// end_spit_mode
	void SnakeCobraBoss_OnEndSpitMode()
	{
		if (!AM_TURRET)
			NO_STUCK_CHECKS = "0";
		SPIT_LOOPS -= 1.0f;
		SPIT_MODE = false;
		DOING_SPECIAL = false;
		SetIdleAnim(ANIM_IDLE_NORM);
		SetMoveAnim(ANIM_WALK);
		ANIM_IDLE = ANIM_IDLE_NORM;
		if (!AM_TURRET)
			SetRoam(true);
		OnNpcatkResumeAi();
	}

	// new_spit_target
	void SnakeCobraBoss_OnNewSpitTarget()
	{
		PLAYER_LIST = TokenShuffle(PLAYER_LIST);
	}

	// npcatk_attack
	// see if I can actually reach this bastard before attacking
	void SnakeCobraBoss_OnNpcatkAttack()
	{
		if (NPC_NO_ATTACK)
			return;
		OnNpcSelectattack(); // give chance for mon to chose an anim (external) (old naming convention for compatiblity)
		if (NPC_MOVEDEST_TARGET != NPCATK_TARGET) // keep moving towards him until in moverange
			OnNpcatkFaceattacker(NPCATK_TARGET);

		Vector3 mouthPos = BonePositionOf(ENT_ME, 6);
		Vector3 targPos = OriginOf(NPCATK_TARGET);
		string traceIt = LegacyFunction("get_traceline", mouthPos, targPos, "worldonly");
		if (traceIt != Text(targPos))
			return;

		PlayAnim("once", ANIM_ATTACK);
		ATTACK_ANIMINDEX = AnimIndexOf(ENT_ME);
	}

	// npcatk_hunt
	void SnakeCobraBoss_OnNpcatkHunt()
	{
		if (!AM_TURRET)
			return;
		if (SUSPEND_AI)
			return;
		if (DOING_SPECIAL)
			return;

		if (SPIT_MODE)
			return;
		if (!IsAlive(NPCATK_TARGET))
			return;

		if (RangeTo(NPCATK_TARGET) > ATTACK_RANGE && !SPIT_MODE)
		{
			SPIT_TARGET = NPCATK_TARGET;
			PlayAnim("once", ANIM_SPIT);
		}
	}

	// frame_spit
	void SnakeCobraBoss_OnFrameSpit()
	{
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(20, 150, 100)), SPIT_TARGET, 300, DMG_SPIT, 0.5f, "none");
		PlaySound(0, 10, SOUND_SPIT);
	}

	// game_death
	void SnakeCobraBoss_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", CL_IDX);
		ServerPlaySound(1, 0, "ambience/steamjet1.wav");
	}

	// do_cloud
	void SnakeCobraBoss_OnDoCloud()
	{
		ServerPlaySound(1, 10, "ambience/steamjet1.wav");
		OnNpcatkSuspendAi();
		SetRoam(false);
		DOING_SPECIAL = true;
		PlayAnim("critical", ANIM_BREATH);
		SetMoveAnim(ANIM_BREATH);
		SetIdleAnim(ANIM_BREATH);
		CUR_ANG = AnglesOf(ENT_ME).y;
		CLOUD_COUNT = 0.0f;
		OnDoCloudLoop();
	}

	// do_cloud_loop
	void SnakeCobraBoss_OnDoCloudLoop()
	{
		int count;

		if (!IsAlive(ENT_ME))
			return;

		if (CLOUD_COUNT == 180.0f)
		{
			OnNpcatkResumeAi();
			DOING_SPECIAL = false;
			SetIdleAnim(ANIM_IDLE_NORM);
			SetMoveAnim(ANIM_WALK);
			if (!AM_TURRET)
				SetRoam(true);
			ServerPlaySound(1, 0, "ambience/steamjet1.wav");
		}

		if (!(CLOUD_COUNT < 180.0f))
			return;
		CallEventDelayed(0.1f, "do_cloud_loop");

		CLOUD_COUNT += 1.0f;

		Vector3 cloudStart = BonePositionOf(ENT_ME, 8);
		ClientEvent("update", "all", CL_IDX, "make_cloud", cloudStart, AnglesOf(ENT_ME).y);

		CUR_ANG += 2.0f;
		if (CUR_ANG > 359.0f)
			CUR_ANG -= 359.0f;
		Vector3 facePos = MyOrigin() + RelativePosition(Vector3(0, CUR_ANG, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);

		if (CLOUD_TARGS != "none")
		{
			count = GetTokenCount(CLOUD_TARGS);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnPoisonTargets();
			}
		}

		if (!(GameTime() > NEXT_SCAN))
			return;
		NEXT_SCAN = GameTime() + 1.0f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 256, -125));
		CLOUD_TARGS = LegacyFunction("get_tbox", "enemy", 128, scanPoint);
		ServerPlaySound(1, 10, "ambience/steamjet1.wav");
	}

	// poison_targets
	void SnakeCobraBoss_OnPoisonTargets()
	{
		string curTarget = GetToken(CLOUD_TARGS, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 600.0f))
			return;
		ApplyEffect(curTarget, "effects/dot_poison_blind", 10.0f, self, DMG_POISON_DOT);
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
		SnakeCobraBoss_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SnakeCobraBoss_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SnakeCobraBoss_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SnakeCobraBoss_OnNpcSpawn(npc);
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		SnakeCobraBoss_OnNpcatkHunt();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SnakeCobraBoss_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		SnakeCobraBoss_OnMyTargetDied(offender);
	}

	void OnSetupClient() { SnakeCobraBoss_OnSetupClient(); } // setup_client
	void OnIdleSounds() { SnakeCobraBoss_OnIdleSounds(); } // idle_sounds
	void OnPostSpawnProps() { SnakeCobraBoss_OnPostSpawnProps(); } // post_spawn_props
	void OnAttack1() { SnakeCobraBoss_OnAttack1(); } // attack1
	void OnNpcMadeItHome() { SnakeCobraBoss_OnNpcMadeItHome(); } // npc_made_it_home
	void OnSleepMode() { SnakeCobraBoss_OnSleepMode(); } // sleep_mode
	void OnWakeUp() { SnakeCobraBoss_OnWakeUp(); } // wake_up
	void OnDoSpecial() { SnakeCobraBoss_OnDoSpecial(); } // do_special
	void OnDoSpit() { SnakeCobraBoss_OnDoSpit(); } // do_spit
	void OnDoSpitLoop() { SnakeCobraBoss_OnDoSpitLoop(); } // do_spit_loop
	void OnEndSpitMode() { SnakeCobraBoss_OnEndSpitMode(); } // end_spit_mode
	void OnNewSpitTarget() { SnakeCobraBoss_OnNewSpitTarget(); } // new_spit_target
	void OnNpcatkAttack() { SnakeCobraBoss_OnNpcatkAttack(); } // npcatk_attack
	void OnFrameSpit() { SnakeCobraBoss_OnFrameSpit(); } // frame_spit
	void OnDoCloud() { SnakeCobraBoss_OnDoCloud(); } // do_cloud
	void OnDoCloudLoop() { SnakeCobraBoss_OnDoCloudLoop(); } // do_cloud_loop
	void OnPoisonTargets() { SnakeCobraBoss_OnPoisonTargets(); } // poison_targets
	void OnNextSpecial() {} // NEXT_SPECIAL

	// This file's events and timers by their .script names
	bool SnakeCobraBoss_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "do_cloud") { OnDoCloud(); return true; }
		if (name == "do_cloud_loop") { OnDoCloudLoop(); return true; }
		if (name == "do_special") { OnDoSpecial(); return true; }
		if (name == "do_spit") { OnDoSpit(); return true; }
		if (name == "do_spit_loop") { OnDoSpitLoop(); return true; }
		if (name == "end_spit_mode") { OnEndSpitMode(); return true; }
		if (name == "frame_spit") { OnFrameSpit(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "new_spit_target") { OnNewSpitTarget(); return true; }
		if (name == "npc_made_it_home") { OnNpcMadeItHome(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_attack") { OnNpcatkAttack(); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "poison_targets") { OnPoisonTargets(); return true; }
		if (name == "post_spawn_props") { OnPostSpawnProps(); return true; }
		if (name == "setup_client") { OnSetupClient(); return true; }
		if (name == "sleep_mode") { OnSleepMode(); return true; }
		if (name == "wake_up") { OnWakeUp(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/snake_cobra_boss"]
shared class SnakeCobraBossScript : BaseMonsterNewScript, SnakeCobraBoss
{
	// Variables every script that includes this file declares
	bool AM_TURRET = false;

	// Variables declared by included files, with the value they start with in this script
	SnakeCobraBossScript()
	{
		SOUND_DEATH = "agrunt/ag_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gcobra_boss.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SnakeCobraBoss_FirstThink();
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
		return SnakeCobraBoss_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
