#pragma context server

// Converted from monsters/bat_large_vampire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_flyer_grav.as"
#include "converted/monsters/base_propelled.as"

[script "monsters/bat_large_vampire"]
class BatLargeVampire : BaseMonsterNewScript, BaseFlyerGrav, BasePropelled
{
	// Constants
	bool BFLY_NO_FAKE_DEATH = true;
	bool AS_CUSTOM_UNSTUCK = true;
	string ANIM_DEAD_GROUND = "Deadground";
	string ANIM_HOVER = "IdleFlyFace";
	string ANIM_IDLE_HANG = "IdleHang";
	float DMG_BITE = 50.0f;
	float DOT_POISON = 10.0f;
	string SOUND_HEARTBEAT = "player/heartbeat_noloop.wav";
	string SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/cbar_hitbod2.wav";
	string SOUND_STRUCK3 = "weapons/cbar_hitbod3.wav";
	string SOUND_PAIN = "monsters/bat/c_bat_hit1.wav";
	string SOUND_IDLE = "monsters/bat/c_bat_hit2.wav";
	string SOUND_BOOST1 = "monsters/bat/c_bat_bat1.wav";
	string SOUND_BOOST2 = "monsters/bat/c_bat_bat2.wav";
	string SOUND_ATTACK1 = "monsters/bat/c_bat_atk1.wav";
	string SOUND_ATTACK2 = "monsters/bat/c_bat_atk2.wav";
	string SOUND_ATTACK3 = "monsters/bat/c_bat_atk3.wav";
	string SOUND_ALERT = "monsters/bat/death.wav";

	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 500.0f;
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool IS_ACTIVE = false;
	float REGEN_RATE = 0.0f;
	float NEXT_RETREAT = 0.0f;
	string OLD_TARGET = "OLD_TARGET";
	float TRACK_HIT = 0.0f;
	float NEXT_HORROR_BOOST = 0.0f;
	bool DID_ALERT = false;

	// Variables declared by included files, with the value they start with in this script
	BatLargeVampire()
	{
		ANIM_IDLE = "IdleFlyNormal";
		ANIM_WALK = "IdleFlyFace";
		ANIM_DEATH = "Deadground";
		SOUND_DEATH = "monsters/bat/c_bat_yes.wav";
	}

	// unnamed block (first think)
	void BatLargeVampire_FirstThink()
	{
		NPC_HACKED_MOVE_SPEED = 500.0f;

		ANIM_IDLE = "IdleFlyNormal";
		ANIM_WALK = "IdleFlyFace";
		ANIM_RUN = "IdleFlyNormal";
		ANIM_ATTACK = "Bite"; // bite1
		ANIM_DEATH = "Deadground"; // Die

		ATTACK_MOVERANGE = 15.0f;
		ATTACK_RANGE = 80.0f;
		ATTACK_HITRANGE = 100.0f;
		NPC_GIVE_EXP = 150.0f;
	}

	// game_damaged
	string BatLargeVampire_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!IS_ACTIVE)
			OnActiveMode();

		if (!(GameTime() > NEXT_RETREAT))
			return result;
		NEXT_RETREAT = GameTime() + Random(3, 5);
		float rndLr = Random(-300, 300);
		float rndFb = Random(-1500, 500);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(rndLr, rndFb, 0)));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Vampire Bat");
		SetModel("monsters/bat_large.mdl");
		SetHealth(200);
		SetRace("vermin");
		SetWidth(32);
		SetHeight(32);
		SetGravity(0);
		// fly 1
		SetHearingSensitivity(3.5f);
		SetIdleAnim(ANIM_IDLE_HANG);
		SetMoveAnim(ANIM_RUN);
		PlayAnim("once", ANIM_IDLE_HANG);
		IS_ACTIVE = false;
		OnNpcatkSuspendAi();
		CallEventDelayed(2.0f, "final_props");
		SetProp(ENT_ME, "skin", 1);

		if (ToLowerCase(MapName()) == "nightmare_edana")
			SetMonsterClip(false);
	}

	// game_heardsound
	void OnGameHeardsound(string soundType = "", Vector3 origin = Vector3(), float dangerRadius = 0.0f)
	{
		BaseNpcAttackNew_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameHeardsound(soundType, origin, dangerRadius); // monsters/base_monster_shared
		if (IS_ACTIVE)
			return;
		CBaseEntity@ heardId = EntityOf(ENT_LASTHEARD);
		if (RelationshipOf(heardId, ENT_ME) != "enemy")
			return;
		OnActiveMode();
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_ALERT = false;
	}

	// npcatk_suspend_ai
	void OnNpcatkSuspendAi(string seconds = "", string debugTag = "")
	{
		BaseNpcAttackNew_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcatkSuspendAi(seconds, debugTag); // monsters/base_monster_shared
		DebugPrint("npcatk_suspend_ai " + seconds + " " + debugTag);
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BatLargeVampire_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		BaseFlyerGrav_OnNpcTargetsighted(target); // monsters/base_flyer_grav
		if (GameTime() > NEXT_HORROR_BOOST)
		{
			// if $cansee(NPCATK_TARGET) //look at the event name, duh
			NEXT_HORROR_BOOST = GameTime() + Random(3, 5);
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, 800, 0)));

			LegacyCommand("svplayrandomsound", 0, 10, SOUND_BOOST1, SOUND_BOOST2);
		}

		if (RangeTo(NPCATK_TARGET) < ATTACK_RANGE) // rotate around target
			AddVelocity(ENT_ME, RelativeVelocity(Vector3(-50, 0, 0)));

		if (DID_ALERT)
			return;
		DID_ALERT = true;
		ServerPlaySound(0, 10, SOUND_ALERT);
	}

	// final_props
	void OnFinalProps()
	{
		REGEN_RATE = MaxHealthOf(ENT_ME) * 0.1f;
	}

	// set_spawn_active
	void OnSetSpawnActive()
	{
		CallEventDelayed(0.1f, "active_mode");
	}

	// active_mode
	void OnActiveMode()
	{
		PlayAnim("critical", ANIM_WALK);
		SetIdleAnim(ANIM_WALK);
		SetMoveAnim(ANIM_RUN);
		IS_ACTIVE = true;
		OnNpcatkResumeAi();
	}

	// bite_dodamage
	void OnBiteDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		if (!Truthy(ScriptVarOf(target, "IMMUNE_VAMPIRE")))
		{
			GiveHealth(ENT_ME, REGEN_RATE);
			PlaySound(0, 10, SOUND_HEARTBEAT);
		}

		if (!IsAlive(OLD_TARGET))
			OLD_TARGET = Text(hit);
		if (OLD_TARGET == EntityId(target))
			TRACK_HIT += 1.0f;
		else
			TRACK_HIT = 0.0f;
		if (TRACK_HIT > 3.0f)
		{
			TRACK_HIT = 0.0f;
			ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_POISON, 1);
		}
		OLD_TARGET = EntityId(target);
	}

	// bite1
	// frame event
	void OnBite1()
	{
		DoDamageEx(NPCATK_TARGET, ATTACK_HITRANGE, DMG_BITE, "90%", ENT_ME, ENT_ME, "none", "pierce", "dmgevent:bite");
		LegacyCommand("svplayrandomsound", 0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
	}

	// npc_death
	void OnNpcDeath()
	{
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		ClientEvent("new", "all", "monsters/bat_large_corpse_cl", OriginOf(ENT_ME), 1);
	}

	// as_npcatk_suspend_ai
	void OnAsNpcatkSuspendAi(float value = 0.0f, string value2 = "")
	{
		DebugPrint("as_npcatk_suspend_ai " + Text(value) + " " + value2);
	}

	// npc_stuck
	void OnNpcStuck()
	{
		DebugPrint("npc_stuck");
		OnChickenRun(1.0f);
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_flyer_grav
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
		BasePropelled_OnNpcPostSpawn(); // monsters/base_propelled
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
		BaseFlyerGrav_OnGameSpawn(playerRace, playerGender); // monsters/base_flyer_grav
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		BaseFlyerGrav_OnNpcatkHunt(); // monsters/base_flyer_grav
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/bat_large.mdl");
		Precache("monsters/bat/c_bat_atk1.wav");
		Precache("monsters/bat/c_bat_atk2.wav");
		Precache("monsters/bat/c_bat_atk3.wav");
		Precache("monsters/bat/c_bat_bat1.wav");
		Precache("monsters/bat/c_bat_bat2.wav");
		Precache("monsters/bat/death.wav");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BatLargeVampire_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
		BaseFlyerGrav_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "active_mode") { OnActiveMode(); return true; }
		if (name == "as_npcatk_suspend_ai") { OnAsNpcatkSuspendAi(Float(Param(params, 0)), Param(params, 1)); return true; }
		if (name == "bite1") { OnBite1(); return true; }
		if (name == "bite_dodamage") { OnBiteDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5)); return true; }
		if (name == "final_props") { OnFinalProps(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_heardsound") { OnGameHeardsound(Param(params, 0), Vec(Param(params, 1)), Float(Param(params, 2))); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_stuck") { OnNpcStuck(); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_suspend_ai") { OnNpcatkSuspendAi(Param(params, 0), Param(params, 1)); return true; }
		if (name == "set_spawn_active") { OnSetSpawnActive(); return true; }
		return BaseFlyerGrav_DispatchEvent(name, params)
			|| BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
