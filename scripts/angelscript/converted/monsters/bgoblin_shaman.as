#pragma context server

// Converted from monsters/bgoblin_shaman.script by msc_transpiler.
// Blood Goblin Evoker
// - Summons fire elementals
// - Spawns fire walls
// - Lotso fire balls
// - Greater fire elemental bursts from body on death

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bgoblin.as"

[script "monsters/bgoblin_shaman"]
class BgoblinShaman : BgoblinScript
{
	// Constants
	int DMG_FIST = 10;
	int DOT_FIST = 50;
	int DMG_FIREWALL = 100;
	float FREQ_FLEE = 20.0f;
	float FREQ_FIREWALL = 18.0f;
	float FREQ_SUMMON = 15.0f;
	string FIRE_FIST_SCRIPT = "monsters/fire_fist_cl";
	string SUMMON_SCRIPT = "monsters/elemental_fire1";
	string DEATH_SCRIPT = "monsters/elemental_fire2";
	string FIREWALL_SCRIPT = "traps/fire_wall2";

	// Variables (an unset .script variable reads as its own name)
	string MY_CL_SCRIPT_IDX = "MY_CL_SCRIPT_IDX";
	float LAST_STRUCK = 0.0f;
	float NEXT_FLEE = 0.0f;
	bool FLAME_FIST = false;
	float NEXT_FIREWALL = 0.0f;
	float NEXT_SUMMON = 0.0f;
	Vector3 SUMMON_POS = Vector3();
	bool SUMMON_ALIVE = false;
	bool NO_SUMMONS = false;
	bool NO_DEATH_EVENT = false;

	// Variables declared by included files, with the value they start with in this script
	BgoblinShaman()
	{
		GOB_JUMPER = false;
		GOB_CHARGER = false;
		FREQ_FIREBALL = 3.0f;
		DMG_FIREBALL = 150;
		DMG_FIREBALL_DOT = 25;
		NPC_BASE_EXP = "800";
		MIN_FIREBALL_DIST = 70;
	}

	// unnamed block (first think)
	void BgoblinShaman_FirstThink()
	{
		CAN_FIREBALL = true;
		ATTACK_HITCHANCE = "75%";
		DROP_GOLD = 1;
		DROP_GOLD_AMT = RandomInt(50, 75);

		ATTACK_MOVERANGE = 800.0f;
		MOVE_RANGE = "800";

		ANIM_ATTACK = "swordswing1_L";
	}

	// game_dodamage
	// PARAM1=hit:0|1 PARAM2=ent_hit PARAM3=(start) PARAM4=(end)
	string BgoblinShaman_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";

		// fire axe effect
		if (hit && FLAME_FIST)
		{
			ApplyEffect(target, "effects/dot_fire", 10.0f, self, DOT_FIST);
			FLAME_FIST = false;
		}
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
		if (NO_DEATH_EVENT)
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

		LAST_STRUCK = GameTime();

		if (RangeTo(NPCATK_TARGET) < 96.0f && GameTime() > NEXT_FLEE)
		{
			NEXT_FLEE = GameTime() + FREQ_FLEE;
			SetMoveAnim(ANIM_RUN);
			SetMoveSpeed(2);
			CallEventDelayed(5.0f, "reset_move_speed");
			OnNpcatkFlee(LegacyFunction("get", ENT_LASTSTRUCK), "5.0");
		}
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BgoblinShaman_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// goblin_spawn
	void OnGoblinSpawn()
	{
		SetName("Blood Goblin Evoker");
		SetRace("goblin");
		SetBlood("red"); // green for v_goblin
		SetHealth(800);
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

			SetProp(ENT_ME, "skin", 2);
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

			SetProp(ENT_ME, "skin", 1); // 0-norm 1-blood 2-vile
		}

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);

		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 1.5f);

		ClientEvent("persist", "all", FIRE_FIST_SCRIPT, IndexOf(ENT_ME), 19);
		MY_CL_SCRIPT_IDX = LastClientScriptId();
	}

	// game_precache
	void OnGamePrecache()
	{
		PrecacheFile(SUMMON_SCRIPT);
		PrecacheFile(DEATH_SCRIPT);
		PrecacheFile(FIREWALL_SCRIPT);
	}

	// reset_move_speed
	void OnResetMoveSpeed()
	{
		SetMoveSpeed(1);
	}

	// swing_sword
	void OnSwingSword()
	{
		if (TOSS_FIREBALL)
		{
			TOSS_FIREBALL = false;
			// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
			TossProjectile("proj_fire_ball", RelativePosition(Vector3(0, 48, 0)), NPCATK_TARGET, 400, DMG_FIREBALL, 0.5f, "none");
			CallExternal(ENT_LASTPROJECTILE, "lighten", DMG_FIREBALL_DOT, 0.01f);
			PlaySound(0, 10, SOUND_FIREBALL);
		}
		if (TOSS_FIREBALL)
			return;
		PlayRandomSound(0, 10, SOUND_ATTACK1, SOUND_ATTACK2, SOUND_ATTACK3);
		FLAME_FIST = true;
		DoDamage(NPCATK_TARGET, ATTACK_HITRANGE, DMG_FIST, ATTACK_HITCHANCE, "blunt");
	}

	// gob_cycle_up
	void OnGobCycleUp()
	{
		// delay first fireball
		NEXT_FIREBALL = GameTime() + 3.0f;

		NEXT_FIREWALL = GameTime() + Random(5, 10);

		NEXT_SUMMON = GameTime() + Random(15, 20);

		if (GOB_JUMP_SCANNING)
			return;
		GOB_JUMP_SCANNING = true;
		PlaySound(0, 10, SOUND_SHAM_ALERT);
		OnGobJumpCheck();
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

		if (GameTime() > NEXT_FIREWALL && CanSee(NPCATK_TARGET))
		{
			NEXT_FIREWALL = GameTime() + FREQ_FIREWALL;
			PlayAnim("critical", ANIM_WARCRY);
			OnNpcatkSuspendAi("1.5");
			PlaySound(0, 10, SOUND_SHAM_ALERT);
			Vector3 firewallPos = OriginOf(NPCATK_TARGET);
			int firewallOfs = RandomInt(1, 4);
			if (firewallOfs == 1)
				firewallPos.x += 96.0f;
			if (firewallOfs == 2)
				firewallPos.y += 96.0f;
			if (firewallOfs == 3)
				firewallPos.x += -96.0f;
			if (firewallOfs == 4)
				firewallPos.y += -96.0f;
			CreateNpc(FIREWALL_SCRIPT, firewallPos, self, AnglesOf(NPCATK_TARGET).y, DMG_FIREWALL);
			exitSub = true;
		}
		if (exitSub)
			return;

		if (!SUMMON_ALIVE && !NO_SUMMONS && GameTime() > NEXT_SUMMON && RangeTo(NPCATK_TARGET) < 1024.0f)
		{
			NEXT_SUMMON = GameTime() + FREQ_SUMMON;
			PlayAnim("critical", ANIM_WARCRY);
			OnNpcatkSuspendAi("1.5");
			PlaySound(0, 10, SOUND_SHAM_ALERT);
			SUMMON_POS = OriginOf(NPCATK_TARGET);
			if (IsPlayer(NPCATK_TARGET)) // compensate for player center org
				SUMMON_POS.z += -30.0f;
			AddVelocity(NPCATK_TARGET, RelativeVelocity(Vector3(-120, 500, 200)), "override");
			CallEventDelayed(0.2f, "summon_elemental");
			exitSub = true;
		}
		if (exitSub)
			return;

		if (CAN_FIREBALL && GameTime() > NEXT_FIREBALL && RangeTo(NPCATK_TARGET) > MIN_FIREBALL_DIST && CanSee(NPCATK_TARGET))
		{
			NEXT_FIREBALL = GameTime() + FREQ_FIREBALL;
			TOSS_FIREBALL = true;
			PlayAnim("critical", ANIM_SWIPE);
			AS_ATTACKING = GameTime() + 10.0f;
			PlaySound(0, 10, SOUND_FIREBALL_CAST);
		}

		// idle in place if can see target but not recently hurt
		if (CanSee(NPCATK_TARGET))
		{
			float struckCheck = GameTime() - 5.0f;
			if (struckCheck > LAST_STRUCK)
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

	// summon_elemental
	void OnSummonElemental()
	{
		SUMMON_ALIVE = true;
		CreateNpc(SUMMON_SCRIPT, SUMMON_POS, self);
	}

	// elemental_died
	void OnElementalDied()
	{
		NEXT_SUMMON = GameTime() + FREQ_SUMMON;
		SUMMON_ALIVE = false;
	}

	// set_no_summons
	void OnSetNoSummons()
	{
		NO_SUMMONS = true;
	}

	// no_death_event
	void OnNoDeathEvent()
	{
		NO_DEATH_EVENT = true;
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BgoblinShaman_FirstThink();
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
		if (name == "elemental_died") { OnElementalDied(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "gob_cycle_up") { OnGobCycleUp(); return true; }
		if (name == "gob_hunt") { OnGobHunt(); return true; }
		if (name == "goblin_spawn") { OnGoblinSpawn(); return true; }
		if (name == "no_death_event") { OnNoDeathEvent(); return true; }
		if (name == "reset_move_speed") { OnResetMoveSpeed(); return true; }
		if (name == "set_no_summons") { OnSetNoSummons(); return true; }
		if (name == "summon_elemental") { OnSummonElemental(); return true; }
		if (name == "swing_sword") { OnSwingSword(); return true; }
		return BgoblinScript::DispatchEvent(name, params);
	}
}
