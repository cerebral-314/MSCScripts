#pragma context server

// Converted from monsters/snake_gcobra.script by msc_transpiler.
// Giant Cobra by Thothie (from Large Sidewinder)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SnakeGcobra
{
	// Constants
	string ANIM_BREATH = "breath";
	int GAS_RANGE = 200;
	string ANIM_IDLE_NORM = "idle1";
	string ANIM_SLEEP = "idle2";
	string ATTACK_HITCHANCE = "80%";
	string ATTACK_DAMAGE = "$randf(20,50)";
	string POISON_DAMAGE = "$randf(10,20)";
	string POISON_DURATION = "$rand(10,20)";
	string SOUND_ALERT = "monsters/gsnake_idle1.wav";
	string SOUND_IDLE = "monsters/gsnake_idle1.wav";
	string SOUND_ATTACK = "agrunt/ag_attack2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";
	string SOUND_STRUCK = "debris/flesh3.wav";
	string SOUND_PAIN1 = "agrunt/ag_attack3.wav";
	string SOUND_PAIN2 = "agrunt/ag_idle2.wav";
	string SOUND_DEATH = "agrunt/ag_die2.wav";
	string DMG_EFFECT_SCRIPT = "effects/dot_poison";
	string BREATH_EFFECT_SCRIPT = "effects/dot_poison_blind";
	string CL_SCRIPT = "monsters/snake_gcobra_cl";
	string MONSTER_MODEL = "monsters/gcobra.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_WALK = "walk";
	string ANIM_RUN = "walk";
	string ANIM_IDLE = "idle1";
	string ANIM_DEATH = "ANIM_DEATH";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float ATTACK_RANGE = 0.0f;
	float ATTACK_HITRANGE = 0.0f;
	float ATTACK_MOVERANGE = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	int GAS_AMMO = 0;
	bool NO_SLEEP = false;
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	float ATTACK_DELAY = 0.0f;
	bool SLEEP_MODE = false;
	string NO_STUCK_CHECKS = "NO_STUCK_CHECKS";
	bool DOING_SPECIAL = false;
	float CUR_ANG = 0.0f;
	float CLOUD_COUNT = 0.0f;
	string CL_IDX = "CL_IDX";
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";

	// unnamed block (first think)
	void SnakeGcobra_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = "idle1";
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 60.0f;
		NPC_GIVE_EXP = 200.0f;
	}

	// npc_spawn
	void SnakeGcobra_OnNpcSpawn(string npc = "")
	{
		SetName("Giant Cobra");
		SetHealth(800);
		SetWidth(64);
		SetHeight(32);
		SetRoam(false);
		SetRace("demon"); // for easier placement
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(0);
		CallEventDelayed(0.2f, "post_spawn_props");
		CallEventDelayed(1.0f, "idle_sounds");

		GAS_AMMO = 1;
	}

	// game_death
	void SnakeGcobra_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (DOING_SPECIAL)
			ClientEvent("update", "all", CL_IDX, "end_fx");
		if (!FIRE_BREATH)
			ServerPlaySound(1, 0, "ambience/steamjet1.wav");
	}

	// idle_sounds
	void SnakeGcobra_OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// post_spawn_props
	void SnakeGcobra_OnPostSpawnProps()
	{
		SetDamageTaken("holy", 0); // not actually a demon :)
	}

	// npc_post_spawn
	void SnakeGcobra_OnNpcPostSpawn()
	{
		if (NO_SLEEP)
			return;
		OnSleepMode();
	}

	// set_nosleep
	void SnakeGcobra_OnSetNosleep()
	{
		NO_SLEEP = true;
	}

	// attack1
	void SnakeGcobra_OnAttack1()
	{
		BITE_SOUND = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME);
	}

	// game_damaged_other
	// PARAM1=ent hit PARAM2=damage
	string SnakeGcobra_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!BITE_SOUND)
			return result;
		BITE_SOUND = false;
		if (RandomInt(1, 2) != 1)
			return result;
		PlaySound(0, 10, SOUND_POISON);
		ApplyEffect(target, DMG_EFFECT_SCRIPT, POISON_DURATION, self, POISON_DAMAGE);
		return result;
	}

	// game_struck
	void SnakeGcobra_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK, SOUND_STRUCK);
	}

	// npcatk_targetvalidate
	void SnakeGcobra_OnNpcatkTargetvalidate(string target = "")
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
	void SnakeGcobra_OnMyTargetDied(string offender = "")
	{
		GAS_AMMO = 1;

		SetMoveDest(NPC_SPAWN_LOC, 10);
		OnIdleSounds();
		DID_ALERT = false;

		DebugPrint("my_target_died");

		CallEventDelayed(1.0f, "npcatk_go_home");
	}

	// npc_made_it_home
	void SnakeGcobra_OnNpcMadeItHome()
	{
		OnSleepMode();
	}

	// reset_attack_delay
	void SnakeGcobra_OnResetAttackDelay()
	{
		ATTACK_DELAY = 0.0f;
	}

	// sleep_mode
	void SnakeGcobra_OnSleepMode()
	{
		SLEEP_MODE = true;
		NO_STUCK_CHECKS = "1";
		SetRoam(false);
		SetIdleAnim(ANIM_SLEEP);
		SetMoveAnim(ANIM_SLEEP);
		ANIM_IDLE = ANIM_SLEEP;
		SetHearingSensitivity(0);
	}

	// wake_up
	void SnakeGcobra_OnWakeUp()
	{
		SLEEP_MODE = false;
		NO_STUCK_CHECKS = "0";
		SetIdleAnim(ANIM_IDLE_NORM);
		SetMoveAnim(ANIM_WALK);
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// npc_targetsighted
	// == poison gas spray
	void SnakeGcobra_OnNpcTargetsighted(string target = "")
	{
		if (!(GAS_AMMO > 0))
			return;
		if (!(RangeTo(NPCATK_TARGET) < GAS_RANGE))
			return;
		GAS_AMMO = 0;
		OnDoCloud();
	}

	// do_cloud
	void SnakeGcobra_OnDoCloud()
	{
		if (!FIRE_BREATH)
			ServerPlaySound(1, 10, "ambience/steamjet1.wav");
		else
			PlaySound(0, 10, "monsters/goblin/sps_fogfire.wav");
		OnNpcatkSuspendAi();
		SetRoam(false);
		DOING_SPECIAL = true;
		PlayAnim("critical", ANIM_BREATH);
		SetMoveAnim(ANIM_BREATH);
		SetIdleAnim(ANIM_BREATH);
		SetMoveDest(NPCATK_TARGET, 9999);
		CUR_ANG = AnglesOf(ENT_ME).y;
		CLOUD_COUNT = 0.0f;
		CallEventDelayed(0.01f, "adj_angles");
	}

	// adj_angles
	void SnakeGcobra_OnAdjAngles()
	{
		CUR_ANG -= 45.0f;
		if (CUR_ANG < 0.0f)
			CUR_ANG += 359.0f;
		Vector3 facePos = MyOrigin() + RelativePosition(Vector3(0, CUR_ANG, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);
		ClientEvent("new", "all", CL_SCRIPT, IndexOf(ENT_ME));
		CL_IDX = LastClientScriptId();
		CallEventDelayed(0.01f, "do_cloud_loop");
	}

	// do_cloud_loop
	void SnakeGcobra_OnDoCloudLoop()
	{
		int count;

		if (!IsAlive(ENT_ME))
			return;

		if (CLOUD_COUNT == 45.0f)
		{
			OnNpcatkResumeAi();
			DOING_SPECIAL = false;
			SetIdleAnim(ANIM_IDLE_NORM);
			SetMoveAnim(ANIM_WALK);
			SetRoam(true);
			if (!FIRE_BREATH)
				ServerPlaySound(1, 0, "ambience/steamjet1.wav");
			ClientEvent("update", "all", CL_IDX, "end_fx");
		}

		if (!(CLOUD_COUNT < 45.0f))
			return;
		CallEventDelayed(0.1f, "do_cloud_loop");

		CLOUD_COUNT += 1.0f;

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
		NEXT_SCAN = GameTime() + 0.5f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 96, 0));
		CLOUD_TARGS = LegacyFunction("get_tbox", "enemy", 96, scanPoint);
		if (!FIRE_BREATH)
			ServerPlaySound(1, 10, "ambience/steamjet1.wav");
	}

	// poison_targets
	void SnakeGcobra_OnPoisonTargets()
	{
		string curTarget = GetToken(CLOUD_TARGS, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;

		ApplyEffect(curTarget, BREATH_EFFECT_SCRIPT, POISON_DURATION, self, POISON_DAMAGE);
		if (!PUSH_BREATH)
			return;
		AddVelocity(curTarget, RelativeVelocity(Vector3(0, 1000, 110)));
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
		SnakeGcobra_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SnakeGcobra_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		SnakeGcobra_OnNpcPostSpawn();
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		SnakeGcobra_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		SnakeGcobra_OnNpcSpawn(npc);
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new
		SnakeGcobra_OnNpcatkTargetvalidate(target);
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		SnakeGcobra_OnMyTargetDied(offender);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		SnakeGcobra_OnNpcTargetsighted(target);
	}

	void OnIdleSounds() { SnakeGcobra_OnIdleSounds(); } // idle_sounds
	void OnPostSpawnProps() { SnakeGcobra_OnPostSpawnProps(); } // post_spawn_props
	void OnSetNosleep() { SnakeGcobra_OnSetNosleep(); } // set_nosleep
	void OnAttack1() { SnakeGcobra_OnAttack1(); } // attack1
	void OnNpcMadeItHome() { SnakeGcobra_OnNpcMadeItHome(); } // npc_made_it_home
	void OnResetAttackDelay() { SnakeGcobra_OnResetAttackDelay(); } // reset_attack_delay
	void OnSleepMode() { SnakeGcobra_OnSleepMode(); } // sleep_mode
	void OnWakeUp() { SnakeGcobra_OnWakeUp(); } // wake_up
	void OnDoCloud() { SnakeGcobra_OnDoCloud(); } // do_cloud
	void OnAdjAngles() { SnakeGcobra_OnAdjAngles(); } // adj_angles
	void OnDoCloudLoop() { SnakeGcobra_OnDoCloudLoop(); } // do_cloud_loop
	void OnPoisonTargets() { SnakeGcobra_OnPoisonTargets(); } // poison_targets

	// This file's events and timers by their .script names
	bool SnakeGcobra_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "adj_angles") { OnAdjAngles(); return true; }
		if (name == "attack1") { OnAttack1(); return true; }
		if (name == "do_cloud") { OnDoCloud(); return true; }
		if (name == "do_cloud_loop") { OnDoCloudLoop(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "idle_sounds") { OnIdleSounds(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_made_it_home") { OnNpcMadeItHome(); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "poison_targets") { OnPoisonTargets(); return true; }
		if (name == "post_spawn_props") { OnPostSpawnProps(); return true; }
		if (name == "reset_attack_delay") { OnResetAttackDelay(); return true; }
		if (name == "set_nosleep") { OnSetNosleep(); return true; }
		if (name == "sleep_mode") { OnSleepMode(); return true; }
		if (name == "wake_up") { OnWakeUp(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/snake_gcobra"]
shared class SnakeGcobraScript : BaseMonsterNewScript, SnakeGcobra
{
	// Variables every script that includes this file declares
	bool FIRE_BREATH = false;
	string NPC_BASE_EXP = "NPC_BASE_EXP";
	bool PUSH_BREATH = false;

	// Variables declared by included files, with the value they start with in this script
	SnakeGcobraScript()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_IDLE = "idle1";
		SOUND_DEATH = "agrunt/ag_die2.wav";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/gcobra.mdl");
		Precache("ambience/steamjet1.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		SnakeGcobra_FirstThink();
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
		return SnakeGcobra_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
