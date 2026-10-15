#pragma context server

// Converted from monsters/vgoblin_shaman.script by msc_transpiler.
// Vile Goblin Shaman
// - Lots o spit bile
// - Poison cloud
// - Poison nova (defensive blast)
// - Horrors
// - Elder Horror Death script

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/vgoblin_shaman"]
class VgoblinShaman : BgoblinScript
{
	// Constants
	int DMG_FIST = 10;
	float DOT_POISON = 0.0f;
	int DMG_NOVA = 200;
	int DOT_FIST = 50;
	float FREQ_NOVA = 10.0f;
	float FREQ_CLOUD = 0.0f;
	float FREQ_SUMMON = 0.0f;
	string SUMMON_SCRIPT = "monsters/summon/horror_egg";
	string DEATH_SCRIPT = "monsters/horror2";
	string CLOUD_SCRIPT = "monsters/summon/npc_poison_cloud2";
	string NOVA_SCRIPT = "monsters/summon/poison_burst";
	string FIST_SCRIPT = "monsters/poison_fist_cl";

	// Variables (an unset .script variable reads as its own name)
	string MY_CL_SCRIPT_IDX = "MY_CL_SCRIPT_IDX";
	float NEXT_NOVA = 0.0f;
	bool POISON_FIST = false;
	float NEXT_CLOUD = 0.0f;
	float NEXT_SUMMON = 0.0f;
	bool SUMMON_ALIVE = false;
	CBaseEntity@ LAST_EGG = null;
	bool NO_DEATH_HORROR = false;

	// Variables declared by included files, with the value they start with in this script
	VgoblinShaman()
	{
		NPC_BASE_EXP = "800";
		GOB_JUMPER = false;
		GOB_CHARGER = false;
		DMG_FIREBALL = 75;
		FREQ_FIREBALL = 2.0f;
		DMG_FIREBALL_DOT = 25;
		SOUND_FIREBALL = "bullchicken/bc_attack2.wav";
	}

	// unnamed block (first think)
	void VgoblinShaman_FirstThink()
	{
		CAN_FIREBALL = true;

		ATTACK_MOVERANGE = 800.0f;
		MOVE_RANGE = "800";
		ATTACK_HITCHANCE = "75%";
		ANIM_ATTACK = "swordswing1_L";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string VgoblinShaman_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// fire axe effect
		if (hit && POISON_FIST)
			ApplyEffect(target, "effects/dot_poison", 5.0f, self, DOT_FIST);
		POISON_FIST = false;
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
		Bgoblin_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/bgoblin
		ClientEvent("remove", "all", MY_CL_SCRIPT_IDX);
		if (NO_DEATH_HORROR)
			return;
		CreateNpc(DEATH_SCRIPT, RelativePosition(Vector3(0, 0, 0)));
		CallExternal(GetVar("GAME_MASTER"), "gm_fade", self, 5);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		Bgoblin_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/bgoblin

		if (RangeTo(NPCATK_TARGET) < 96.0f && GameTime() > NEXT_NOVA)
		{
			NEXT_NOVA = GameTime();
			PlaySound(0, 10, SOUND_SHAM_ALERT);
			PlayAnim("critical", ANIM_WARCRY);
			AS_ATTACKING = GameTime();
			NEXT_NOVA += FREQ_NOVA;
			OnDoNova();
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, VgoblinShaman_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(SUMMON_SCRIPT);
		PrecacheFile(DEATH_SCRIPT);
		PrecacheFile(CLOUD_SCRIPT);
		PrecacheFile(NOVA_SCRIPT);
		PrecacheFile(FIST_SCRIPT);
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Vile Goblin Poisoner");
		SetRace("goblin");
		SetBlood("green");
		SetHealth(1000);
		SetWidth(32);
		SetHeight(60);
		SetRoam(true);

		SetHearingSensitivity(2);

		if (!NEW_MODEL)
		{
			SetModel("monsters/goblin2.mdl");
			SetWidth(32);
			SetHeight(60);

			SetModelBody(0, 0); // body: 0-Runed 1-Archer 2-Leathers 3-Sniper
			SetModelBody(1, 4); // head: 0-Horns* 1-Spikes* 2-Animal 3-Chief 4-Cowl *redcap
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: on/off

			SetProp(ENT_ME, "skin", 3);
		}
		else
		{
			SetModel("monsters/goblin_new.mdl");
			SetWidth(24);
			SetHeight(50);

			SetModelBody(0, 0); // body: 0-Bare 1-Quiver&Strap
			SetModelBody(1, 4); // head: 0-Bare 1-Horns 2-Animal 3-Chief 4-Rag
			SetModelBody(2, 0); // weapon: 0-Unarmed 1-Axe 2-wbow 3-sbow 4-sword 5-rAxe 6-sword&shield 7-club 8-knife
			SetModelBody(3, 0); // arrow: On/off

			SetProp(ENT_ME, "skin", 2); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("poison", 0);
		SetDamageTaken("lightning", 1.5f);

		ClientEvent("persist", "all", FIST_SCRIPT, IndexOf(ENT_ME), 19);
		MY_CL_SCRIPT_IDX = LastClientScriptId();
	}

	// toss_fireball
	void OnTossFireball()
	{
		TOSS_FIREBALL = false;
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_poison_spit2", RelativePosition(Vector3(0, 48, 0)), NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
		PlaySound(0, 10, SOUND_FIREBALL);
	}

	// do_nova
	void OnDoNova()
	{
		CreateNpc(NOVA_SCRIPT, RelativePosition(Vector3(0, 0, 0)), self, 256, 1, DMG_NOVA, DOT_POISON);
	}

	// swing_sword
	void OnSwingSword()
	{
		if (TOSS_FIREBALL)
			OnTossFireball();
		if (TOSS_FIREBALL)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		POISON_FIST = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_FIST, ATTACK_HITCHANCE, "blunt");
	}

	// gob_cycle_up
	void OnGobCycleUp()
	{
		NEXT_FIREBALL = GameTime() + 3.0f;

		NEXT_CLOUD = GameTime() + Random(5, 10);

		NEXT_SUMMON = GameTime() + Random(15, 20);

		if (GOB_JUMP_SCANNING)
			return;
		GOB_JUMP_SCANNING = true;
		PlaySound(0, 10, SOUND_SHAM_ALERT);
	}

	// gob_hunt
	void OnGobHunt()
	{
		bool exitSub = false;

		if (!IsAlive(NPCATK_TARGET))
			return;
		if (SUSPEND_AI)
			return;
		if (IS_FLEEING)
			return;

		if (GameTime() > NEXT_CLOUD && CanSee(NPCATK_TARGET))
		{
			NEXT_CLOUD = GameTime() + FREQ_CLOUD;
			PlayAnim("critical", ANIM_WARCRY);
			OnNpcatkSuspendAi("1.5");
			PlaySound(0, 10, SOUND_SHAM_ALERT);
			Vector3 cloudPos = OriginOf(NPCATK_TARGET);
			if (IsPlayer(NPCATK_TARGET)) // player center compensate
				cloudPos.z += -32.0f;
			CreateNpc(CLOUD_SCRIPT, cloudPos, self, DMG_FIREBALL_DOT, 10.0f, 1);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!SUMMON_ALIVE && GameTime() > NEXT_SUMMON)
		{
			NEXT_SUMMON = GameTime() + FREQ_SUMMON;
			PlayAnim("critical", ANIM_SMASH);
			AS_ATTACKING = GameTime();
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CAN_FIREBALL && GameTime() > NEXT_FIREBALL && RangeTo(NPCATK_TARGET) > MIN_FIREBALL_DIST && CanSee(NPCATK_TARGET))
		{
			NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;
			TOSS_FIREBALL = true;
			PlayAnim("once", ANIM_SWIPE);
			AS_ATTACKING = GameTime() + 10.0f;
			PlaySound(0, 10, SOUND_FIREBALL_CAST);
		}

		// idle in place if can see target but not recently hurt
		if (CanSee(NPCATK_TARGET))
		{
			float struckCheck = GameTime() - 5.0f;
			if (struckCheck > 0.0f)
			{
				if (!IS_FLEEING)
				{
					SetMoveAnim(ANIM_IDLE);
					AS_ATTACKING = GameTime() + 10.0f;
				}
			}
			else
			{
				SetMoveAnim(ANIM_RUN);
			}
		}
		else
		{
			SetMoveAnim(ANIM_RUN);
		}
	}

	// swing_axe
	void OnSwingAxe()
	{
		OnSummonHorrorEgg();
	}

	// summon_horror_egg
	void OnSummonHorrorEgg()
	{
		SUMMON_ALIVE = true;
		CreateNpc(SUMMON_SCRIPT, RelativePosition(Vector3(0, 64, 16)), self);
		@LAST_EGG = EntityOf(ENT_LASTCREATED);
		CallEventDelayed(0.1f, "boost_egg");
	}

	// boost_egg
	void OnBoostEgg()
	{
		AddVelocity(LAST_EGG, RelativeVelocity(Vector3(0, 130, 120)));
	}

	// horror_died
	void OnHorrorDied()
	{
		NEXT_SUMMON = GameTime() + FREQ_SUMMON;
		SUMMON_ALIVE = false;
	}

	// no_death_event
	void OnNoDeathEvent()
	{
		NO_DEATH_HORROR = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		VgoblinShaman_FirstThink();
		Bgoblin_FirstThink();
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
		if (name == "boost_egg") { OnBoostEgg(); return true; }
		if (name == "do_nova") { OnDoNova(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_cycle_up") { OnGobCycleUp(); return true; }
		if (name == "gob_hunt") { OnGobHunt(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "horror_died") { OnHorrorDied(); return true; }
		if (name == "no_death_event") { OnNoDeathEvent(); return true; }
		if (name == "summon_horror_egg") { OnSummonHorrorEgg(); return true; }
		if (name == "swing_axe") { OnSwingAxe(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		if (name == "toss_fireball") { OnTossFireball(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
