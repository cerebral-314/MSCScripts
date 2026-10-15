#pragma context server

// Converted from monsters/snake_gcobra_metal.script by msc_transpiler.
// Giant Cobra by Thothie (from Large Sidewinder)

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/snake_gcobra_metal"]
class SnakeGcobraMetal : BaseMonsterNewScript
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
	string SOUND_STRUCK1 = "weapons/axemetal1.wav";
	string SOUND_STRUCK2 = "weapons/axemetal2.wav";
	string SOUND_STRUCK3 = "doors/doorstop5.wav";
	string SOUND_PAIN1 = "agrunt/ag_attack3.wav";
	string SOUND_PAIN2 = "agrunt/ag_idle2.wav";
	string CL_SCRIPT = "monsters/snake_gcobra_cl";
	string MONSTER_MODEL = "monsters/gcobra.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CL_IDX = "CL_IDX";
	int GAS_AMMO = 0;
	bool IS_UNHOLY = false;
	bool BITE_SOUND = false;
	bool DID_ALERT = false;
	float ATTACK_DELAY = 0.0f;
	bool SLEEP_MODE = false;
	bool DOING_SPECIAL = false;
	float CUR_ANG = 0.0f;
	float CLOUD_COUNT = 0.0f;
	float NEXT_SCAN = 0.0f;
	string CLOUD_TARGS = "CLOUD_TARGS";

	// Variables declared by included files, with the value they start with in this script
	SnakeGcobraMetal()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		SOUND_DEATH = "agrunt/ag_die2.wav";
	}

	// unnamed block (first think)
	void SnakeGcobraMetal_FirstThink()
	{
		ANIM_WALK = "walk";
		ANIM_RUN = "walk";
		ANIM_DEATH = "diesimple";
		ANIM_IDLE = ANIM_SLEEP;
		ANIM_ATTACK = "attack1";
		ATTACK_RANGE = 120.0f;
		ATTACK_HITRANGE = 150.0f;
		ATTACK_MOVERANGE = 60.0f;
		NPC_GIVE_EXP = 200.0f;
	}

	// game_damaged_other
	// PARAM1=ent hit PARAM2=damage
	string SnakeGcobraMetal_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!BITE_SOUND)
			return result;
		BITE_SOUND = false;
		if (RandomInt(1, 2) != 1)
			return result;
		PlaySound(0, 10, SOUND_POISON);
		ApplyEffect(target, "effects/dot_poison", POISON_DURATION, self, POISON_DAMAGE);
		return result;
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		ClientEvent("remove", "all", CL_IDX);
		ServerPlaySound(1, 0, "ambience/steamjet1.wav");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SnakeGcobraMetal_OnGameDamagedOther(target, damage, damageType, damageEvent));
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
		IS_UNHOLY = true;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared

		PlayRandomSound(0, 10, SOUND_PAIN1, SOUND_PAIN2, SOUND_STRUCK1, SOUND_STRUCK2, SOUND_STRUCK3);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Giant Metallic Cobra");
		SetHealth(800);
		SetWidth(64);
		SetHeight(32);
		SetIdleAnim(ANIM_SLEEP);
		SetRoam(false);
		SetRace("demon"); // for easier placement
		SetModel(MONSTER_MODEL);
		SetHearingSensitivity(0);
		OnSleepMode();
		CallEventDelayed(0.2f, "post_spawn_props");
		CallEventDelayed(1.0f, "idle_sounds");

		SetProp(ENT_ME, "skin", 1);

		SetDamageTaken("all", 0.25f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 4);
		SetDamageTaken("holy", 1);

		ClientEvent("new", "all", CL_SCRIPT);
		CL_IDX = LastClientScriptId();
		GAS_AMMO = 1;
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

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
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new

		GAS_AMMO = 1;

		SetMoveDest(NPC_SPAWN_LOC, 10);
		OnIdleSounds();
		DID_ALERT = false;

		DebugPrint("my_target_died");

		CallEventDelayed(1.0f, "npcatk_go_home");
	}

	// npc_targetsighted
	// == poison gas spray
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!(GAS_AMMO > 0))
			return;
		if (!(RangeTo(NPCATK_TARGET) < GAS_RANGE))
			return;
		GAS_AMMO = 0;
		OnDoCloud();
	}

	// idle_sounds
	void OnIdleSounds()
	{
		PlaySound(0, 10, SOUND_IDLE);
		CallEventDelayed(Random(5, 10), "idle_sounds");
	}

	// post_spawn_props
	void OnPostSpawnProps()
	{
		SetDamageTaken("holy", 0); // not actually a demon :)
	}

	// attack1
	void OnAttack1()
	{
		BITE_SOUND = true;
		OnNpcatkDodamage(NPCATK_TARGET, Text(ATTACK_HITRANGE), ATTACK_DAMAGE, ATTACK_HITCHANCE, ENT_ME);
	}

	// npc_made_it_home
	void OnNpcMadeItHome()
	{
		OnSleepMode();
	}

	// reset_attack_delay
	void OnResetAttackDelay()
	{
		ATTACK_DELAY = 0.0f;
	}

	// sleep_mode
	void OnSleepMode()
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
	void OnWakeUp()
	{
		SLEEP_MODE = false;
		NO_STUCK_CHECKS = "0";
		SetIdleAnim(ANIM_IDLE_NORM);
		SetMoveAnim(ANIM_WALK);
		ANIM_IDLE = ANIM_IDLE_NORM;
		SetRoam(true);
		SetHearingSensitivity(4);
	}

	// do_cloud
	void OnDoCloud()
	{
		ServerPlaySound(1, 10, "ambience/steamjet1.wav");
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
	void OnAdjAngles()
	{
		CUR_ANG -= 45.0f;
		if (CUR_ANG < 0.0f)
			CUR_ANG += 359.0f;
		Vector3 facePos = MyOrigin() + RelativePosition(Vector3(0, CUR_ANG, 0), Vector3(0, 1000, 0));
		SetMoveDest(facePos, 9999);
		CallEventDelayed(0.01f, "do_cloud_loop");
	}

	// do_cloud_loop
	void OnDoCloudLoop()
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
			ServerPlaySound(1, 0, "ambience/steamjet1.wav");
		}

		if (!(CLOUD_COUNT < 45.0f))
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
		NEXT_SCAN = GameTime() + 0.5f;
		Vector3 scanPoint = RelativePosition(Vector3(0, 96, 0));
		CLOUD_TARGS = LegacyFunction("get_tbox", "enemy", 96, scanPoint);
		ServerPlaySound(1, 10, "ambience/steamjet1.wav");
	}

	// poison_targets
	void OnPoisonTargets()
	{
		string curTarget = GetToken(CLOUD_TARGS, loopIteration);
		if (!IsAlive(curTarget))
			return;
		Vector3 targOrg = OriginOf(curTarget);
		if (!WithinCone2D(targOrg, MyOrigin(), MyAngles(), 30))
			return;
		if (!(RangeTo(curTarget) < 256.0f))
			return;
		ApplyEffect(curTarget, "effects/dot_poison_blind", POISON_DURATION, self, POISON_DAMAGE);
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
		SnakeGcobraMetal_FirstThink();
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
		if (name == "sleep_mode") { OnSleepMode(); return true; }
		if (name == "wake_up") { OnWakeUp(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
