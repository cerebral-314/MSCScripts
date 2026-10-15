#pragma context server

// Converted from monsters/anim_warrior.script by msc_transpiler.
// Thothie - naming conventions
// Orc base

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster.as"

[script "monsters/anim_warrior"]
class AnimWarrior : BaseMonsterScript
{
	// Constants
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
	string ATTACK_ACCURACY = "85%";
	float ATTACK_DMG_LOW = 15.0f;
	float ATTACK_DMG_HIGH = 25.0f;

	// Variables (an unset .script variable reads as its own name)
	bool IS_UNHOLY = true;
	string LAST_ENEMY = "LAST_ENEMY";
	string ANIM_ATTACK = "ANIM_ATTACK";
	bool I_AM_TURNABLE = false;
	string SPAWNER = "SPAWNER";

	// Variables declared by included files, with the value they start with in this script
	AnimWarrior()
	{
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void AnimWarrior_FirstThink()
	{
		IS_UNHOLY = true;
		IMMUNE_VAMPIRE = true;
		ANIM_RUN = "run";
		ANIM_IDLE = "idle1";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die";
		CAN_HUNT = "1";
		HUNT_AGRO = "1"; // base_npc_attack - Premptive attack
		CAN_HEAR = "1"; // Turn to face enemies I hear
		CAN_FLEE = "0"; // Don't flee
		CAN_FLINCH = "0"; // Flinch when hit
		LAST_ENEMY = "`NONE`";
		MOVE_RANGE = "54";
		ATTACK_RANGE = 82.0f;
		ATTACK_HITRANGE = 128.0f;
		DROP_GOLD = 1; // Gold Drops
		DROP_GOLD_AMT = RandomInt(20, 40);
		NPC_GIVE_EXP = 65.0f;

		ANIM_ATTACK = "battleaxe_swing1_L"; // Attack animation

		IMMUNE_VAMPIRE = true;
		I_AM_TURNABLE = false;
	}

	// game_damaged_other
	string AnimWarrior_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		// (never true here, the rest is skipped) if ATTACK_PUSH isnot 'ATTACK_PUSH'
		return result;
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, AnimWarrior_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// turn_undead
	void OnTurnUndead(float holyDamage = 0.0f, CBaseEntity@ exorcist = null)
	{
		MonstersExternals_OnTurnUndead(holyDamage, exorcist); // monsters/externals

		// Takes half damage from holy light - cannot be turned
		// PARAM1 - incoming Holy damage
		// PARAM2 - exorcist
		float incHolyDmg = Divide(holyDamage, 2.0f);
		CBaseEntity@ meMe = self;

		DoDamage(meMe, "direct", incHolyDmg, 100, @exorcist);

		Effect("glow", ENT_ME, Vector3(255, 255, 0), 512, 1, 1);
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck

		SPAWNER = creatorValue1;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Animated armor");
		SetRoam(true);
		SetRace("demon");
		SetBlood("none");
		SetWidth(40);
		SetHealth(275);
		SetHeight(90);
		SetModel("monsters/animarmor.mdl");
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetStepSize(16); // override basic step size or these things walk off the catwalks in keledrosruins

		SetDamageTaken("all", 0.9f);
		SetDamageTaken("holy", 3);
		SetDamageTaken("lightning", 2);
		SetDamageTaken("poison", 0);

		SetModelBody(2, 1); // Axe
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared

		CBaseEntity@ lastseenEnemy = EntityOf(ENT_LASTSEEN);
		if (EntityId(lastseenEnemy) == LAST_ENEMY)
			return;

		PlaySound(Int(Eval("game.sound.voice")), 5, SOUND_ATTACK2);
		LAST_ENEMY = EntityId(lastseenEnemy);
	}

	// npc_death
	// On death, don't display weapon
	void OnNpcDeath()
	{
		SetModelBody(2, 0); // Hide weapon
		SetModelBody(4, 0); // Hide Shield

		CallExternal(SPAWNER, "undead_died");
	}

	// npc_struck
	// Hit by someone
	void OnNpcStruck(float damage = 0.0f)
	{
		PlayRandomSound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), SOUND_PAIN, SOUND_STRUCK2, SOUND_PAIN, "none", "none");
	}

	// npc_flinch
	void OnNpcFlinch(float damage = 0.0f)
	{
		PlayAnim("critical", "flinch");
	}

	// retaliate
	void OnRetaliate()
	{
		if (RandomInt(1, 3) != 1)
			return;

		SetMoveDest(ENT_LASTSTRUCK, 9999);
		Look();
		OnHuntLook();
	}

	// swing_axe
	void OnSwingAxe()
	{
		float dmg = Random(ATTACK_DMG_LOW, ATTACK_DMG_HIGH);
		DoDamage(ENT_LASTSEEN, ATTACK_HITRANGE, dmg, ATTACK_ACCURACY);
	}

	// swing_sword
	void OnSwingSword()
	{
		OnSwingAxe();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnHuntLook() {} // hunt_look

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/animarmor.mdl");
		CallEventDelayed(Float(CYCLE_TIME), "hunting_mode_go");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		AnimWarrior_FirstThink();
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
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "npc_death") { OnNpcDeath(); return true; }
		if (name == "npc_flinch") { OnNpcFlinch(Float(Param(params, 0))); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "retaliate") { OnRetaliate(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "turn_undead") { OnTurnUndead(Float(Param(params, 0)), EntityParam(params, 1)); return true; }
		return BaseMonsterScript::DispatchEvent(name, params);
	}
}
