#pragma context server

// Converted from monsters/summon/zy_eye.script by msc_transpiler.
// Big floating eyes used by monsters/zombie_zygol

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/summon/zy_eye"]
class ZyEye : BaseMonsterNewScript, BasePropelled
{
	// Constants
	string SOUND_SHOCK1 = "debris/zap8.wav";
	string SOUND_SHOCK2 = "debris/zap3.wav";
	string SOUND_SHOCK3 = "debris/zap4.wav";
	int SHOCK_DMG = 100;
	float SHOCK_DUR = 5.0f;
	int RUN_REQ = 30;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MY_OWNER = "MY_OWNER";
	string BEAM_DAMAGE = "BEAM_DAMAGE";
	float RENDER_AMT = 0.0f;

	// Variables declared by included files, with the value they start with in this script
	ZyEye()
	{
		ANIM_IDLE = "spin_horizontal_slow";
		ANIM_WALK = "spin_horizontal_slow";
		ANIM_RUN = "spin_horizontal_slow";
	}

	// unnamed block (first think)
	void ZyEye_FirstThink()
	{
		IS_UNHOLY = true;

		ANIM_DEATH = "spin_vertical_norm";
		ANIM_IDLE = "spin_horizontal_slow";
		ANIM_WALK = "spin_horizontal_slow";
		ANIM_RUN = "spin_horizontal_slow";
		ANIM_ATTACK = "spin_horizontal_slow";

		NPC_GIVE_EXP = 200.0f;
	}

	// game_dynamically_created
	// <1:owner> <2:hp> <3:dmg>
	void ZyEye_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		MY_OWNER = EntityId(EntityOf(creatorValue1));
		SetHealth(Float(creatorValue2));
		BEAM_DAMAGE = damage;
		OnNpcatkFlee(MY_OWNER, "9999", "5.0");
	}

	// unnamed block (timer)
	void ZyEye_Timer()
	{
		CallEventDelayed(5.0f, "ZyEye_Timer");

		if (!CanSee("enemy"))
			return;
		Effect("glow", ENT_ME, Vector3(128, 128, 255), 64, 3.0f, 3.0f);
		PlayRandomSound(0, 10, SOUND_SHOCK1, SOUND_SHOCK2, SOUND_SHOCK3);
		ApplyEffect(ENT_LASTSEEN, "effects/dot_lightning", SHOCK_DUR, self, BEAM_DAMAGE);
		OnNpcatkFlee(ENT_LASTSEEN, "9999", "10.0");
		Vector3 beamStart = MyOrigin() + RelativePosition(Vector3(0, 0, 0), Vector3(0, 0, 64));
		Effect("beam", "end", "lgtning.spr", 30, beamStart, ENT_LASTSEEN, 0, Vector3(255, 255, 255), 200, 30, 1.5f);
	}

	// unnamed block (timer)
	void ZyEye_Timer2()
	{
		CallEventDelayed(1.0f, "ZyEye_Timer2");
		if (RENDER_AMT != 255.0f)
			return;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		ZyEye_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		CallExternal(MY_OWNER, "ext_eye_died");
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		if (damage > RUN_REQ)
			OnNpcatkFlee(ENT_LASTSTRUCK, "9999", "15.0");
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Eye of Zygoli");
		SetModel("weapons/projectiles.mdl");
		SetModelBody(0, 10);
		SetIdleAnim("spin_horizontal_slow");
		SetMoveAnim("spin_horizontal_slow");
		SetWidth(32);
		SetHeight(32);
		SetRoam(true);
		SetDamageTaken("holy", 2);
		SetDamageTaken("poison", 0);
		SetDamageTaken("pierce", 2);
		SetRace("demon");
		SetInvincible(true); // invincible until hp is set
		RENDER_AMT = 1.0f;
		CallEventDelayed(0.1f, "remove_invuln");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);

		OnNpcatkSuspendAi();
	}

	// remove_invuln
	void OnRemoveInvuln()
	{
		SetInvincible(false);
		OnFadeIn();
		PlaySound(0, 10, "magic/spawn_loud.wav");
	}

	// fade_in
	void OnFadeIn()
	{
		if (!(RENDER_AMT < 255.0f))
			return;
		RENDER_AMT += 1.0f;
		CallEventDelayed(0.1f, "fade_in");
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", RENDER_AMT);
	}

	// zygoli_died
	void OnZygoliDied()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// npc_post_spawn
	void OnNpcPostSpawn()
	{
		MonstersExternals_OnNpcPostSpawn(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_2(); // monsters/externals
		MonstersExternals_OnNpcPostSpawn_3(); // monsters/externals
		BaseSelfAdjust_OnNpcPostSpawn(); // monsters/base_self_adjust
		BaseNpc_OnNpcPostSpawn(); // monsters/base_npc
		BaseMonsterShared_OnNpcPostSpawn(); // monsters/base_monster_shared
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		CallEventDelayed(5.0f, "ZyEye_Timer");
		CallEventDelayed(1.0f, "ZyEye_Timer2");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ZyEye_FirstThink();
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
		if (name == "fade_in") { OnFadeIn(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "remove_invuln") { OnRemoveInvuln(); return true; }
		if (name == "zygoli_died") { OnZygoliDied(); return true; }
		if (name == "ZyEye_Timer") { ZyEye_Timer(); return true; }
		if (name == "ZyEye_Timer2") { ZyEye_Timer2(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
