#pragma context server

// Converted from monsters/anim_archer.script by msc_transpiler.
// Thothie - naming conventions
// Orc base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class AnimArcher
{
	// Constants
	float FREQ_BOW = 2.0f;
	int FIN_EXP = 45;
	string SOUND_STRUCK1 = "body/armour1.wav";
	string SOUND_STRUCK2 = "body/armour2.wav";
	string SOUND_STRUCK3 = "body/armour3.wav";
	string SOUND_HIT = "body/armour3.wav";
	string SOUND_HIT2 = "body/armour2.wav";
	string SOUND_HIT3 = "body/armour1.wav";
	string SOUND_PAIN = "body/armour1.wav";
	string SOUND_ATTACK1 = "none";
	string SOUND_ATTACK2 = "none";
	string SOUND_ATTACK3 = "none";
	string SOUND_DEATH = "none";
	string SOUND_BOW = "weapons/bow/bow.wav";
	int AIM_RATIO = 50;
	int ARROW_DAMAGE_LOW = 12;
	int ARROW_DAMAGE_HIGH = 15;
	int ATTACK_SPEED = 1000;
	int ATTACK_CONE_OF_FIRE = 2;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string ANIM_RUN = "run";
	string ANIM_IDLE = "idle1";
	string ANIM_WALK = "walk";
	bool IMMUNE_VAMPIRE = false;
	string NPC_MUST_SEE_TARGET = "NPC_MUST_SEE_TARGET";
	string ANIM_DEATH = "ANIM_DEATH";
	int DROP_GOLD = 0;
	float DROP_GOLD_AMT = 0.0f;
	float NPC_GIVE_EXP = 0.0f;
	int DROPS_CONTAINER = 0;
	string CONTAINER_DROP_CHANCE = "CONTAINER_DROP_CHANCE";
	string CONTAINER_SCRIPT = "CONTAINER_SCRIPT";
	string ANIM_ATTACK = "ANIM_ATTACK";
	string MOVE_RANGE = "MOVE_RANGE";
	float ATTACK_RANGE = 0.0f;
	bool I_AM_TURNABLE = false;
	string LAST_ENEMY = "LAST_ENEMY";
	float ATTACK_DELAY = 0.0f;
	float AS_ATTACKING = 0.0f;
	string SPAWNER = "SPAWNER";
	int I_AM_ONE = 0;
	int I_AM_TWO = 0;
	int I_AM_THREE = 0;
	int I_AM_FOUR = 0;

	// unnamed block (first think)
	void AnimArcher_FirstThink()
	{
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		NPC_MUST_SEE_TARGET = "1";
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die";
		DROP_GOLD = 1; // Gold Drop
		DROP_GOLD_AMT = RandomInt(15, 25);
		NPC_GIVE_EXP = FIN_EXP;

		DROPS_CONTAINER = 1;
		CONTAINER_DROP_CHANCE = "10%";
		CONTAINER_SCRIPT = "chests/quiver_of_silver";

		ANIM_ATTACK = "shootorcbow"; // Attack animation
		MOVE_RANGE = "400";
		ATTACK_RANGE = 60.0f;

		I_AM_TURNABLE = false;
	}

	// npc_spawn
	void AnimArcher_OnNpcSpawn(string npc = "")
	{
		SetName("Animated armor");
		SetRoam(true);
		SetRace("demon");
		SetWidth(40);
		SetHeight(90);
		SetHealth(200);
		SetStepSize(16); // override basic step size or these things walk off the catwalks in keledrosruins
		SetModel("monsters/animarmor.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetBlood("none");

		SetDamageTaken("all", 0.9f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 3);
		SetDamageTaken("lightning", 1.2f);

		SetModelBody(1, 1); // Pointy hat
		SetModelBody(2, 3); // Steel Bow
	}

	// npc_targetsighted
	// Warcry
	void AnimArcher_OnNpcTargetsighted(string target = "")
	{
		if (RangeTo(target) < ATTACK_SPEED && int(ATTACK_DELAY) == 0)
		{
			// if $cansee(enemy)
			if (CanSee(HUNT_LASTTARGET))
				OnDoAttack();
		}

		CBaseEntity@ lastseenEnemy = EntityOf(ENT_LASTSEEN);
		if (EntityId(lastseenEnemy) == LAST_ENEMY)
			return;

		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_ATTACK2);
		LAST_ENEMY = EntityId(lastseenEnemy);
	}

	// reset_attack_delay
	void AnimArcher_OnResetAttackDelay()
	{
		ATTACK_DELAY = 0.0f;
	}

	// npc_struck
	// Hit by someone
	void AnimArcher_OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");
	}

	// npc_targetsighted
	void AnimArcher_OnNpcTargetsighted_2(string target = "")
	{
		AS_ATTACKING = GameTime() + 1.0f;
	}

	// game_damaged_other
	string AnimArcher_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		// (never true here, the rest is skipped) if ATTACK_PUSH isnot 'ATTACK_PUSH'
		return result;
	}

	// npc_flinch
	void AnimArcher_OnNpcFlinch(float damage = 0.0f)
	{
		PlayAnim("critical", "flinch");
	}

	// retaliate
	void AnimArcher_OnRetaliate()
	{
		if (RandomInt(1, 3) != 1)
			return;

		SetMoveDest(ENT_LASTSTRUCK, 9999);
		Look();
		OnHuntLook();
	}

	// shoot_arrow
	void AnimArcher_OnShootArrow()
	{
		float aimAngle = Divide(DistanceTo(ENT_LASTSEEN), AIM_RATIO); // Aim up a bit
		SetAngle("add_view.x", aimAngle);

		float lclAtkdmg = Random(ARROW_DAMAGE_LOW, ARROW_DAMAGE_HIGH);

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_arrow_npc", RelativePosition(Vector3(0, 0, 3)), "none", ATTACK_SPEED, lclAtkdmg, ATTACK_CONE_OF_FIRE, "none");
		SetModelBody(3, 0); // Hide arrow
		PlaySound(2, 10, SOUND_BOW);

		AS_ATTACKING = GameTime() + 5.0f;
	}

	// grab_arrow
	// Called from the animation...
	void AnimArcher_OnGrabArrow()
	{
		// Just pulled an arrow out of quiver
		SetModelBody(3, 1); // Show arrow
		AS_ATTACKING = GameTime() + 5.0f;
	}

	// game_dynamically_created
	void AnimArcher_OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		SPAWNER = creatorValue1;
	}

	// two_was_summoned
	// This system allows Keledros' spawners to keep track of which archers are alive and which are dead, and can therefor be resummoned.
	void AnimArcher_OnTwoWasSummoned()
	{
		SetGlobal("ONE_IS_DEAD", 0);
		I_AM_ONE = 1;
	}

	// two_was_summoned
	void AnimArcher_OnTwoWasSummoned_2()
	{
		SetGlobal("TWO_IS_DEAD", 0);
		I_AM_TWO = 1;
	}

	// three_was_summoned
	void AnimArcher_OnThreeWasSummoned()
	{
		SetGlobal("THREE_IS_DEAD", 0);
		I_AM_THREE = 1;
	}

	// four_was_summoned
	void AnimArcher_OnFourWasSummoned()
	{
		SetGlobal("FOUR_IS_DEAD", 0);
		I_AM_FOUR = 1;
	}

	// npc_death
	// On death, don't display weapon
	void AnimArcher_OnNpcDeath()
	{
		if (I_AM_ONE == 1)
			SetGlobal("ONE_IS_DEAD", 1);
		if (I_AM_TWO == 1)
			SetGlobal("TWO_IS_DEAD", 1);
		if (I_AM_THREE == 1)
			SetGlobal("THREE_IS_DEAD", 1);
		if (I_AM_FOUR == 1)
			SetGlobal("FOUR_IS_DEAD", 1);

		SetModelBody(2, 0); // Hide weapon
		SetModelBody(3, 0); // Hide arrow
		SetModelBody(4, 0); // Hide Shield

		CallExternal(SPAWNER, "undead_died");
	}

	// do_attack
	void AnimArcher_OnDoAttack(string damage = "")
	{
		AS_ATTACKING = GameTime();
		ATTACK_DELAY = 1.0f;
		CallEventDelayed(FREQ_BOW, "reset_attack_delay");
		PlayAnim("once", ANIM_ATTACK);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AnimArcher_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		AnimArcher_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck
		AnimArcher_OnNpcSpawn(npc);
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		AnimArcher_OnNpcTargetsighted(target);
		AnimArcher_OnNpcTargetsighted_2(target);
	}

	void OnResetAttackDelay() { AnimArcher_OnResetAttackDelay(); } // reset_attack_delay
	void OnNpcStruck(float damage = 0.0f) { AnimArcher_OnNpcStruck(damage); } // npc_struck
	void OnNpcFlinch(float damage = 0.0f) { AnimArcher_OnNpcFlinch(damage); } // npc_flinch
	void OnRetaliate() { AnimArcher_OnRetaliate(); } // retaliate
	void OnShootArrow() { AnimArcher_OnShootArrow(); } // shoot_arrow
	void OnGrabArrow() { AnimArcher_OnGrabArrow(); } // grab_arrow

	// two_was_summoned
	void OnTwoWasSummoned()
	{
		AnimArcher_OnTwoWasSummoned();
		AnimArcher_OnTwoWasSummoned_2();
	}

	void OnThreeWasSummoned() { AnimArcher_OnThreeWasSummoned(); } // three_was_summoned
	void OnFourWasSummoned() { AnimArcher_OnFourWasSummoned(); } // four_was_summoned
	void OnNpcDeath() { AnimArcher_OnNpcDeath(); } // npc_death
	void OnDoAttack(string damage = "") { AnimArcher_OnDoAttack(damage); } // do_attack
	void OnFreqBow() {} // FREQ_BOW
	void OnHuntLook() {} // hunt_look

	// This file's events and timers by their .script names
	bool AnimArcher_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_attack") { OnDoAttack(Param(params, 0)); return true; }
		if (name == "four_was_summoned") { OnFourWasSummoned(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "grab_arrow") { OnGrabArrow(); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "reset_attack_delay") { OnResetAttackDelay(); return true; }
		if (name == "retaliate") { OnRetaliate(); return true; }
		if (name == "shoot_arrow") { OnShootArrow(); return true; }
		if (name == "three_was_summoned") { OnThreeWasSummoned(); return true; }
		if (name == "two_was_summoned") { OnTwoWasSummoned(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "monsters/anim_archer"]
shared class AnimArcherScript : BaseMonsterScript, AnimArcher
{
	// Variables every script that includes this file declares
	string ARMOR_TYPE = "ARMOR_TYPE";
	float ARROW_MISS_COUNT = 0.0f;
	string DAMAGE_TYPE = "DAMAGE_TYPE";
	float FLIGHT_STUCK = 0.0f;
	string LIGHT_COLOR = "LIGHT_COLOR";
	int LIGHT_RAD = 0;
	string MY_LIGHT_SCRIPT = "MY_LIGHT_SCRIPT";
	int STUCK_SENSITIVITY = 0;

	// Variables declared by included files, with the value they start with in this script
	AnimArcherScript()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/animarmor.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
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
		return AnimArcher_DispatchEvent(name, params)
			|| BaseMonsterScript::DispatchEvent(name, params);
	}
}
