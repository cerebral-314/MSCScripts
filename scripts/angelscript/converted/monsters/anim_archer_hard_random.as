#pragma context server

// Converted from monsters/anim_archer_hard_random.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/anim_archer.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AnimArcherHardRandom
{
	// Constants
	int LIGHT_RAD = 64;
	int STUCK_SENSITIVITY = 10;
	int FIN_EXP = 320;
	int ARROW_DAMAGE_LOW = 30;
	int ARROW_DAMAGE_HIGH = 45;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	bool IMMUNE_VAMPIRE = false;
	string MOVE_RANGE = "MOVE_RANGE";
	float ARROW_MISS_COUNT = 0.0f;
	string ARMOR_TYPE = "ARMOR_TYPE";
	string DAMAGE_TYPE = "DAMAGE_TYPE";
	string LIGHT_COLOR = "LIGHT_COLOR";
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	float FLIGHT_STUCK = 0.0f;
	float AS_ATTACKING = 0.0f;

	// unnamed block (first think)
	void AnimArcherHardRandom_FirstThink()
	{
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		MOVE_RANGE = "300";
	}

	// npc_spawn
	// nclude monsters/base_flyer_agro
	void AnimArcherHardRandom_OnNpcSpawn(string npc = "")
	{
		SetRoam(true);
		SetRace("demon");
		SetWidth(64);
		SetHeight(64);
		SetBoundingBox("npcsize");
		SetHealth(500);
		SetModel("monsters/animarmor_fly.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(8);
		SetBlood("none");

		SetFly(true);

		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);

		SetModelBody(1, 1); // Pointy hat
		SetModelBody(2, 3); // Steel Bow

		CallEventDelayed(0.1f, "select_armor");

		ARROW_MISS_COUNT = 0.0f;
	}

	// select_armor
	void AnimArcherHardRandom_OnSelectArmor()
	{
		if (ARMOR_TYPE == "ARMOR_TYPE")
			ARMOR_TYPE = RandomInt(1, 4);

		if (Float(ARMOR_TYPE) == 1.0f)
		{
			SetName("Animated Archer of Flame");
			DAMAGE_TYPE = "fire";
			SetDamageTaken("lightning", 1.2f);
			SetDamageTaken("fire", 0);
			SetDamageTaken("cold", 2);
			LIGHT_COLOR = Text(Vector3(255, 0, 0));

			DROPS_CONTAINER = 1;
			CONTAINER_DROP_CHANCE = "10%";
			CONTAINER_SCRIPT = "chests/quiver_of_fire";
		}

		if (Float(ARMOR_TYPE) == 2.0f)
		{
			SetName("Animated Archer of Thunder");
			DAMAGE_TYPE = "lightning";
			SetDamageTaken("lightning", 0);
			SetDamageTaken("acid", 2);
			LIGHT_COLOR = Text(Vector3(255, 255, 0));

			DROPS_CONTAINER = 1;
			CONTAINER_DROP_CHANCE = "10%";
			CONTAINER_SCRIPT = "chests/quiver_of_lightning";
		}

		if (Float(ARMOR_TYPE) == 3.0f)
		{
			SetName("Animated Archer of Frost");
			DAMAGE_TYPE = "cold";
			SetDamageTaken("fire", 2);
			SetDamageTaken("lightning", 1.2f);
			SetDamageTaken("cold", 0);
			LIGHT_COLOR = Text(Vector3(200, 200, 255));

			DROPS_CONTAINER = 1;
			CONTAINER_DROP_CHANCE = "10%";
			CONTAINER_SCRIPT = "chests/quiver_of_frost";
		}

		if (Float(ARMOR_TYPE) == 4.0f)
		{
			SetName("Animated Archer of Venom");
			DAMAGE_TYPE = "poison";
			SetDamageTaken("lightning", 2.5f);
			LIGHT_COLOR = Text(Vector3(0, 255, 0));

			DROPS_CONTAINER = 1;
			CONTAINER_DROP_CHANCE = "10%";
			CONTAINER_SCRIPT = "chests/quiver_of_gpoison";
		}

		Effect("glow", ENT_ME, LIGHT_COLOR, 64, -1, 0);

		float grndLevel = GroundHeight(MyOrigin());
		float myZ = MyOrigin().z;
		if (Float(LegacyFunction("dest", grndLevel, myZ)) < 32.0f)
			AddVelocity(ENT_ME, Vector3(0, 0, 110));
	}

	// game_damaged_other
	string AnimArcherHardRandom_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (!Contains(damageType, "pierce")) // hacky way to prevent infinite dot
			return result;
		ARROW_MISS_COUNT = 0.0f;

		if (DAMAGE_TYPE == "fire")
			ApplyEffect(target, "effects/dot_fire", 30, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "poison")
			ApplyEffect(target, "effects/dot_poison", 30, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "cold")
			ApplyEffect(target, "effects/dot_cold", 10, self, RandomInt(5, 12));
		if (DAMAGE_TYPE == "lightning")
			ApplyEffect(target, "effects/dot_lightning", 10, self, RandomInt(5, 12));
		return result;
	}

	// npc_post_spawn
	// ===light system
	// call at spawn or cycle_up
	void AnimArcherHardRandom_OnNpcPostSpawn()
	{
		ClientEvent("persist", "all", "monsters/lighted_cl", IndexOf(ENT_ME), LIGHT_COLOR, LIGHT_RAD);
		MY_LIGHT_SCRIPT = LastClientScriptId();
	}

	// game_death
	void AnimArcherHardRandom_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		ClientEvent("remove", "all", MY_LIGHT_SCRIPT);
		ClientEvent("update", "all", MY_LIGHT_SCRIPT, "remove_me");
	}

	// bf_agrofly_boost
	// ===end light system
	void AnimArcherHardRandom_OnBfAgroflyBoost()
	{
		SetVelocity(ENT_ME, RelativeVelocity(Vector3(0, 0, 150)));
	}

	// unnamed block (timer)
	void AnimArcherHardRandom_Timer()
	{
		float distDiff = 0.0f;
		bool exitSub = false;
		CallEventDelayed(10.0f, "AnimArcherHardRandom_Timer");
		Effect("glow", ENT_ME, LIGHT_COLOR, 64, -1, 0);

		// stay out of ground/ceiling
		float grndLevel = GroundHeight(MyOrigin());
		float myZ = MyOrigin().z;

		if (grndLevel >= myZ)
			distDiff = grndLevel - myZ;

		if (grndLevel < myZ)
			distDiff = myZ - grndLevel;

		if (distDiff < 32.0f)
		{
			AddVelocity(ENT_ME, Vector3(0, 0, 110));
			exitSub = true;
		}
		if (exitSub)
			return;

		Vector3 traceStart = MyOrigin();
		Vector3 traceEnd = MyOrigin();
		traceEnd.z += 4096.0f;
		string findCeiling = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		float ceilZ = Vec(findCeiling).z;
		string ceilZText;
		float skyZ = SkyHeight(MyOrigin());
		if (Text(skyZ) != "none" && skyZ < ceilZ)
		{
			ceilZText = "equals" + Text(skyZ);
			ceilZ = Float(ceilZText);
		}

		if (ceilZ >= myZ)
		{
			distDiff = ceilZ;
			distDiff -= myZ;
		}

		if (ceilZ < myZ)
			distDiff = myZ - ceilZ;

		if (distDiff < 32.0f)
			AddVelocity(ENT_ME, Vector3(0, 0, -110));
	}

	// bf_agrofly_loop
	void AnimArcherHardRandom_OnBfAgroflyLoop()
	{
		if (!IsAlive(HUNT_LASTTARGET))
			return;
		if (CanSee(HUNT_LASTTARGET))
			return;
		FLIGHT_STUCK = 8.0f;
	}

	// chicken_run
	void AnimArcherHardRandom_OnChickenRun(float duration = 0.0f)
	{
		SetMoveSpeed(2);
		AddVelocity(ENT_ME, RelativeVelocity(Vector3(0, -110, 120)));
	}

	// chicken_end
	void AnimArcherHardRandom_OnChickenEnd()
	{
		SetMoveSpeed(1);
	}

	// do_attack
	void AnimArcherHardRandom_OnDoAttack(string damage = "")
	{
		SetVelocity(ENT_ME, Vector3(0, 0, 0));
	}

	// shoot_arrow
	void AnimArcherHardRandom_OnShootArrow()
	{
		ARROW_MISS_COUNT += 1.0f;
		if (!(ARROW_MISS_COUNT > 3.0f))
			return;
		OnChickenRun(2.0f);

		AS_ATTACKING = GameTime() + 5.0f;
	}

	// npc_targetsighted
	void AnimArcherHardRandom_OnNpcTargetsighted(string target = "")
	{
		AS_ATTACKING = GameTime() + 1.0f;
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
		AnimArcherHardRandom_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AnimArcher_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AnimArcherHardRandom_OnGameDamagedOther(target, damage, damageType, damageEvent));
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
		AnimArcherHardRandom_OnNpcPostSpawn();
	}

	// chicken_run
	void OnChickenRun(float duration = 0.0f)
	{
		BaseNpcAttack_OnChickenRun(duration); // monsters/base_npc_attack
		AnimArcherHardRandom_OnChickenRun(duration);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		AnimArcher_OnNpcSpawn(npc); // monsters/anim_archer
		AnimArcherHardRandom_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		AnimArcher_OnNpcTargetsighted(target); // monsters/anim_archer
		AnimArcher_OnNpcTargetsighted_2(target); // monsters/anim_archer
		AnimArcherHardRandom_OnNpcTargetsighted(target);
	}

	// shoot_arrow
	void OnShootArrow()
	{
		AnimArcher_OnShootArrow(); // monsters/anim_archer
		AnimArcherHardRandom_OnShootArrow();
	}

	// do_attack
	void OnDoAttack(string damage = "")
	{
		AnimArcher_OnDoAttack(damage); // monsters/anim_archer
		AnimArcherHardRandom_OnDoAttack(damage);
	}

	void OnSelectArmor() { AnimArcherHardRandom_OnSelectArmor(); } // select_armor
	void OnBfAgroflyBoost() { AnimArcherHardRandom_OnBfAgroflyBoost(); } // bf_agrofly_boost
	void OnBfAgroflyLoop() { AnimArcherHardRandom_OnBfAgroflyLoop(); } // bf_agrofly_loop
	void OnChickenEnd() { AnimArcherHardRandom_OnChickenEnd(); } // chicken_end

	// This file's events and timers by their .script names
	bool AnimArcherHardRandom_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "bf_agrofly_boost") { OnBfAgroflyBoost(); return true; }
		if (name == "bf_agrofly_loop") { OnBfAgroflyLoop(); return true; }
		if (name == "chicken_end") { OnChickenEnd(); return true; }
		if (name == "chicken_run") { OnChickenRun(Float(Param(params, 0))); return true; }
		if (name == "do_attack") { OnDoAttack(Param(params, 0)); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "npc_post_spawn") { OnNpcPostSpawn(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "select_armor") { OnSelectArmor(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "AnimArcherHardRandom_Timer") { AnimArcherHardRandom_Timer(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/anim_archer_hard_random"]
shared class AnimArcherHardRandomScript : AnimArcherScript, AnimArcherHardRandom
{
	// Variables declared by included files, with the value they start with in this script
	AnimArcherHardRandomScript()
	{
		LIGHT_RAD = 64;
		STUCK_SENSITIVITY = 10;
		FIN_EXP = 320;
		ARROW_DAMAGE_LOW = 30;
		ARROW_DAMAGE_HIGH = 45;
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/animarmor_fly.mdl");
		Precache("monsters/animarmor.mdl");
		CallEventDelayed(10.0f, "AnimArcherHardRandom_Timer");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimArcherHardRandom_FirstThink();
		AnimArcher_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return AnimArcherHardRandom_DispatchEvent(name, params)
			|| AnimArcherScript::DispatchEvent(name, params);
	}
}
