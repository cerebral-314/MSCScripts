#pragma context server

// Converted from monsters/troll_armored.script by msc_transpiler.
// This is based on an older script and may have some bad conventions as a result.
// Thothie - misc minor improvements sound + animation
// Standard Troll

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/troll_armored"]
class TrollArmored : BaseMonsterNewScript
{
	// Constants
	float FREQ_THROW = 0.0f;
	string SOUND_PAIN = "monsters/troll/trollpain.wav";
	string SOUND_ATTACK = "monsters/troll/trollattack.wav";
	string SOUND_WALK1 = "monsters/troll/step1.wav";
	string SOUND_WALK2 = "monsters/troll/step2.wav";
	string SOUND_IDLE = "monsters/troll/trollidle2.wav";

	// Variables (an unset .script variable reads as its own name)
	string SOUND_STRUCK1 = "SOUND_STRUCK1";
	string SOUND_STRUCK2 = "SOUND_STRUCK2";
	string SOUND_STRUCK3 = "SOUND_STRUCK3";
	int DROP_GOLD_MIN = 0;
	int DROP_GOLD_MAX = 0;
	string ANIM_ATTACK = "ANIM_ATTACK";
	string CAN_HUNT = "CAN_HUNT";
	string HUNT_AGRO = "HUNT_AGRO";
	bool IS_GUARDIAN = false;
	string PUSH_VEL = "PUSH_VEL";
	bool DID_WARCRY = false;
	float NEXT_THROW = 0.0f;
	string THROW_TARGET = "THROW_TARGET";
	bool IN_THROW = false;
	string NPC_BONUS_XP_RATIO = "NPC_BONUS_XP_RATIO";

	// Variables declared by included files, with the value they start with in this script
	TrollArmored()
	{
		SOUND_DEATH = "monsters/troll/trolldeath.wav";
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
	}

	// unnamed block (first think)
	void TrollArmored_FirstThink()
	{
		SOUND_STRUCK1 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK2 = "weapons/cbar_hitbod1.wav";
		SOUND_STRUCK3 = "weapons/cbar_hitbod1.wav";
		DROP_GOLD = 1;
		DROP_GOLD_MIN = 20;
		DROP_GOLD_MAX = 65;
		ANIM_IDLE = "idle0";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_DEATH = "die_fall";
		ANIM_ATTACK = "double_punch"; // this varies, needs to be a var
		ATTACK_RANGE = 75.0f;
		ATTACK_HITRANGE = 150.0f;
		CAN_FLINCH = "0";
		MOVE_RANGE = "100";
		CAN_HUNT = "1";
		HUNT_AGRO = "1";
		NPC_GIVE_EXP = 300.0f;
		NPC_MUST_SEE_TARGET = "0";

		// setvard STUCK_CHECK_FREQUENCY 1.2 //I move pretty damn fast, so stuck check more often
		PrecacheFile("monsters/base_monster");
		PrecacheFile("monsters/base_npc_attack");
		PrecacheFile("monsters/base_npc");
	}

	// game_damaged_other
	string TrollArmored_OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (PUSH_VEL == "PUSH_VEL")
			return result;

		AddVelocity(ENT_LASTSTRUCKBYME, Vec(PUSH_VEL)); // Push the player a bit
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile("monsters/summon/spiked_ball");
	}

	// game_damaged_other
	string OnGameDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, MonstersExternals_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseAntiStuck_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, BaseMonsterShared_OnGameDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, TrollArmored_OnGameDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetHealth(600);
		SetDamageTaken("all", 0.25f);
		// ov 100
		SetWidth(100);
		SetHeight(100);
		SetName("Battle Troll");
		if (MapName() == "ww3d")
			IS_GUARDIAN = true;
		if (Truthy(GetVar("G_SHAD_PRESENT")))
			OnBoZombieMode();
		if (IS_GUARDIAN)
		{
			SetName("Temple Guardian");
			SetRace("demon");
			SetProp(ENT_ME, "skin", 1);
			IMMUNE_VAMPIRE = true;
			SetBlood("none");
			CallEventDelayed(0.1f, "guard_attribs");
		}
		if (!IS_GUARDIAN)
			SetRace("orc");
		SetRoam(true);
		SetModel("monsters/troll_armored.mdl");
		SetIdleAnim("idle1");
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);

		CallEventDelayed(10.0f, "random_idle");

		OnTrollSpawn();
	}

	// npcatk_targetvalidate
	void OnNpcatkTargetvalidate(string target = "")
	{
		BaseNpcAttackNew_OnNpcatkTargetvalidate(target); // monsters/base_npc_attack_new

		if (DID_WARCRY)
			return;
		if (!IsPlayer(ENT_LASTSEEN))
			return;

		AS_ATTACKING = GameTime();
		PlayAnim("critical", "idle2");
		DID_WARCRY = true;
		NEXT_THROW = GameTime() + 1.0f;
	}

	// my_target_died
	void OnMyTargetDied(string offender = "")
	{
		BaseNpcAttackNew_OnMyTargetDied(offender); // monsters/base_npc_attack_new
		DID_WARCRY = false;
		if (CanSee("player"))
			return;
		PlayAnim("critical", "idle2");
	}

	// npc_targetsighted
	void OnNpcTargetsighted(string target = "")
	{
		BaseMonsterShared_OnNpcTargetsighted(target); // monsters/base_monster_shared
		if (!DID_WARCRY)
			return;
		if (!(GameTime() > NEXT_THROW))
			return;
		if (!(RangeTo(NPCATK_TARGET) > ATTACK_RANGE))
			return;
		NEXT_THROW = GameTime() + FREQ_THROW;
		SetMoveDest(NPCATK_TARGET, 9999);
		THROW_TARGET = NPCATK_TARGET;
		IN_THROW = true;
		SetRoam(false);
		OnNpcatkSuspendAi();
		PlayAnim("critical", "throw_rock");
		CallEventDelayed(5.0f, "exit_throw"); // in case flinches or otherwise stuck
	}

	// guard_attribs
	void OnGuardAttribs()
	{
		SetDamageTaken("holy", 2);
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// attack_1
	// called by model double_punch @ frame 13 and 26
	void OnAttack12()
	{
		PlaySound(2, 10, SOUND_ATTACK);
		PUSH_VEL = Text(RelativeVelocity(Vector3(10, 200, 10)));
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(ENTITY_ENEMY, "direct", Text(Random(30, 40)), "75%", "blunt");

		if (RandomInt(1, 4) == 1)
			ANIM_ATTACK = "hit_down";
	}

	// attack_2
	// called by model hit_down @ frame 20
	void OnAttack22()
	{
		PlaySound(2, 10, SOUND_ATTACK);
		if (RangeTo(NPCATK_TARGET) < ATTACK_HITRANGE)
			OnNpcatkDodamage(ENTITY_ENEMY, "direct", Text(Random(55, 65)), "75%", "blunt");
		ANIM_ATTACK = "double_punch";
	}

	// npc_struck
	void OnNpcStruck(float damage = 0.0f)
	{
		SetVolume(5);
		PlaySound(2, 5, SOUND_PAIN);
	}

	// stomp_1
	// called by model run @ frame 10 (newer June 27,2006+ model only)
	void OnStomp1()
	{
		PlaySound(2, 8, SOUND_WALK1);
	}

	// stomp_2
	// called by model run @ frame 30 (newer June 27,2006+ model only)
	void OnStomp2()
	{
		PlaySound(2, 8, SOUND_WALK2);
	}

	// game_hearsound
	void OnGameHearsound()
	{
		SetVolume(10);
		PlaySound(2, 10, SOUND_IDLE);
	}

	// random_idle
	// idle anims
	void OnRandomIdle()
	{
		// //dbg CanHear CAN_HEAR
		CallEventDelayed(10.0f, "random_idle");
		if (IS_HUNTING)
			return;
		if (CanSee("enemy"))
			return;
		if (IS_FLEEING)
			return;
		int animSelect = RandomInt(0, 3);
		if (animSelect == 0)
			ANIM_IDLE = "idle0";
		if (animSelect == 1)
			ANIM_IDLE = "idle1";
		if (animSelect == 2)
			ANIM_IDLE = "idle2";
		if (animSelect == 3)
			ANIM_IDLE = "idle3";
		PlayAnim("once", ANIM_IDLE);
	}

	// warcry
	// called by model idle2 @ frame 28
	void OnWarcry()
	{
		PlaySound(2, 10, SOUND_IDLE);
	}

	// bo_zombie_mode
	void OnBoZombieMode()
	{
		SetName("Petrified Troll");
		SetRace("demon");
		SetProp(ENT_ME, "skin", 1);
		IMMUNE_VAMPIRE = true;
		SetBlood("none");
		CallEventDelayed(0.1f, "guard_attribs");
	}

	// rock_pickup
	void OnRockPickup()
	{
		SetModelBody(1, 1);
	}

	// rock_throw
	void OnRockThrow()
	{
		CreateNpc("monsters/summon/spiked_ball", RelativePosition(Vector3(0, 64, 100)), self, RelativeVelocity(Vector3(0, 500, 110)), 0.3f);
		OnExitThrow();
	}

	// exit_throw
	void OnExitThrow()
	{
		if (!IN_THROW)
			return;
		SetModelBody(1, 0);
		IN_THROW = false;
		SetRoam(true);
		OnNpcatkResumeAi();
	}

	// set_bonus_orc_for
	void OnSetBonusOrcFor()
	{
		if (ToLowerCase(MapName()) != "orc_for")
			return;
		NPC_BONUS_XP_RATIO = "3.0";
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnTrollSpawn() {} // troll_spawn

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/troll_armored.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		TrollArmored_FirstThink();
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
		if (name == "attack_1") { OnAttack12(); return true; }
		if (name == "attack_2") { OnAttack22(); return true; }
		if (name == "bo_zombie_mode") { OnBoZombieMode(); return true; }
		if (name == "exit_throw") { OnExitThrow(); return true; }
		if (name == "game_damaged_other") { Return(OnGameDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "game_hearsound") { OnGameHearsound(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "guard_attribs") { OnGuardAttribs(); return true; }
		if (name == "my_target_died") { OnMyTargetDied(Param(params, 0)); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npc_struck") { OnNpcStruck(Float(Param(params, 0))); return true; }
		if (name == "npc_targetsighted") { OnNpcTargetsighted(Param(params, 0)); return true; }
		if (name == "npcatk_targetvalidate") { OnNpcatkTargetvalidate(Param(params, 0)); return true; }
		if (name == "random_idle") { OnRandomIdle(); return true; }
		if (name == "rock_pickup") { OnRockPickup(); return true; }
		if (name == "rock_throw") { OnRockThrow(); return true; }
		if (name == "set_bonus_orc_for") { OnSetBonusOrcFor(); return true; }
		if (name == "stomp_1") { OnStomp1(); return true; }
		if (name == "stomp_2") { OnStomp2(); return true; }
		if (name == "warcry") { OnWarcry(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
