#pragma context server

// Converted from monsters/doom_plant_new.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"

[script "monsters/doom_plant_new"]
class DoomPlantNew : BaseMonsterNewScript
{
	// Constants
	float DMG_SPUR = 5.0f;
	float DMG_SLASH = 8.0f;
	float DMG_SPORE = 50.0f;
	float DOT_POISON = 30.0f;
	float FREQ_GROW = 40.0f;
	float FREQ_SHOOT = 0.5f;
	float FREQ_SPORE = 15.0f;
	float FREQ_CL_REFRESH = 20.0f;
	float FREQ_IDLE = 0.0f;
	string GIB_MODEL = "cactusgibs.mdl";
	string SOUND_GIB = "debris/bustflesh1.wav";
	string SOUND_SLASH = "zombie/claw_miss1.wav";
	string SOUND_SCRATCH = "headcrab/hc_attack1.wav";
	string SOUND_SPORE = "weapons/bow/crossbow.wav";
	string SOUND_GROW = "weapons/bow/stretch.wav";
	string SOUND_STRUCK1 = "weapons/xbow_hitbod1.wav";
	string SOUND_STRUCK2 = "weapons/xbow_hitbod2.wav";

	// Variables (an unset .script variable reads as its own name)
	float TREE_LEVEL = 0.0f;
	bool AM_GROWING = false;
	float NEXT_GROW = 0.0f;
	string LEVEL_PREFIX = "LEVEL_PREFIX";
	string ANIM_ATTACK = "ANIM_ATTACK";
	float HALF_HP = 0.0f;
	float NEXT_CL_REFRESH = 0.0f;
	string TREE_CL_INDEX = "TREE_CL_INDEX";
	float NEXT_IDLE = 0.0f;
	bool SLASH_ATTACK = false;
	float NEXT_SHOOT = 0.0f;
	float NEXT_SPORE = 0.0f;
	string SPORE_POISON_DMG = "SPORE_POISON_DMG";

	// unnamed block (first think)
	void DoomPlantNew_FirstThink()
	{
		NPC_GIVE_EXP = 200.0f;

		NO_STUCK_CHECKS = "1"; // canna move
	}

	// game_damaged
	string DoomPlantNew_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		if (!(TREE_LEVEL > 1.0f))
			return result;

		if (!(HealthOf(ENT_ME) < HALF_HP))
			return result;
		result = AppendResult(result, "0.0");
		OnDoShrink();
		return result;
	}

	// game_dodamage
	string DoomPlantNew_OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		if (SLASH_ATTACK)
			PlaySound(0, 10, SOUND_SCRATCH);
		SLASH_ATTACK = false;
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
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		PlaySound(0, 10, SOUND_GIB);
		Effect("tempent", "gibs", GIB_MODEL, RelativePosition(Vector3(0, 0, 0)), 1.0f, 100, 30, 20, 4.0f);
	}

	// npc_spawn
	void OnNpcSpawn(string npc = "")
	{
		BaseNpcAttackNew_OnNpcSpawn(npc); // monsters/base_npc_attack_new
		BaseMonsterShared_OnNpcSpawn(npc); // monsters/base_monster_shared
		BaseAntiStuck_OnNpcSpawn(npc); // monsters/base_anti_stuck

		SetName("Doom Tree");
		SetModel("monsters/dewm_tree_combo.mdl");
		SetRace("demon");
		SetBlood("green");
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 1.5f);
		SetHealth(100);
		SetNoPush(true);

		SetHearingSensitivity(4);

		SetWidth(48);
		SetHeight(96);

		TREE_LEVEL = 1.0f;

		AM_GROWING = true;
		CallEventDelayed(0.1f, "setup_tree_level");

		CallEventDelayed(2.0f, "set_final_params");
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
		BaseNpcAttackNew_OnNpcatkHunt(); // monsters/base_npc_attack_new
		BaseAntiStuck_OnNpcatkHunt(); // monsters/base_anti_stuck
		bool doIdle = false;

		if (GameTime() > NEXT_CL_REFRESH)
		{
			NEXT_CL_REFRESH = GameTime() + FREQ_CL_REFRESH;
			if (TREE_CL_INDEX != "TREE_CL_INDEX")
				ClientEvent("update", "all", TREE_CL_INDEX, "remove_fx");
			ClientEvent("new", "all", "monsters/doom_plant_cl", FREQ_CL_REFRESH);
			TREE_CL_INDEX = LastClientScriptId();
		}

		if (GameTime() > NEXT_GROW)
		{
			NEXT_GROW = GameTime() + FREQ_GROW;
			OnDoGrow();
		}

		if (SUSPEND_AI)
			return;

		if (NPCATK_TARGET != "unset" && CanSee(NPCATK_TARGET) && TREE_LEVEL >= 2.0f)
		{
			PlaySound(0, 10, SOUND_SLASH);
			PlayAnim("once", ANIM_ATTACK);
		}

		if (TREE_LEVEL == 1.0f && RangeTo(NPCATK_TARGET) > ATTACK_RANGE)
			doIdle = true;

		if (!CanSee(NPCATK_TARGET))
			doIdle = true;

		if (!doIdle)
			return;

		if (!(GameTime() > NEXT_IDLE))
			return;
		NEXT_IDLE = GameTime() + FREQ_IDLE;
		int rndAnim = RandomInt(1, 5);
		PlayAnim("once", LegacyFunction("stradd", LEVEL_PREFIX, "idle", rndAnim));
	}

	// game_dodamage
	string OnGameDodamage(bool hit = false, CBaseEntity@ target = null, Vector3 start = Vector3(), Vector3 end = Vector3(), string damageType = "", string damageText = "")
	{
		string result = "";
		result = AppendResult(result, BaseNpcAttackNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseAntiStuck_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, BaseMonsterShared_OnGameDodamage(hit, target, start, end, damageType, damageText));
		result = AppendResult(result, DoomPlantNew_OnGameDodamage(hit, target, start, end, damageType, damageText));
		return result;
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, DoomPlantNew_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// set_final_params
	void OnSetFinalParams()
	{
	}

	// do_grow
	void OnDoGrow()
	{
		if (!(TREE_LEVEL < 3.0f))
			return;
		TREE_LEVEL += 1.0f;
		AM_GROWING = true;
		OnSetupTreeLevel();
	}

	// setup_tree_level
	// addparams
	void OnSetupTreeLevel()
	{
		NEXT_GROW = GameTime() + FREQ_GROW;

		TREE_LEVEL = int(TREE_LEVEL);
		LEVEL_PREFIX = LegacyFunction("stradd", "level", TREE_LEVEL, "_");

		float treeLevelM1 = TREE_LEVEL - 1.0f;
		SetModelBody(0, int(treeLevelM1));

		OnNpcatkSuspendAi("1.0");

		if (AM_GROWING)
			PlayAnim("critical", LEVEL_PREFIX + "grow");
		AM_GROWING = false;

		ANIM_ATTACK = LEVEL_PREFIX + "attack";
		ANIM_IDLE = LEVEL_PREFIX + "idle1";

		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_IDLE);

		ANIM_WALK = ANIM_IDLE;
		ANIM_RUN = ANIM_IDLE;

		float finalHp = 100.0f;
		if (TREE_LEVEL == 1.0f)
			finalHp *= 1.0f;
		if (TREE_LEVEL == 2.0f)
			finalHp *= 5.0f;
		if (TREE_LEVEL == 3.0f)
			finalHp *= 10.0f;

		if (TREE_LEVEL < 3.0f)
			ATTACK_RANGE = 72.0f;
		if (TREE_LEVEL == 3.0f)
			ATTACK_RANGE = 128.0f;
		ATTACK_HITRANGE = ATTACK_RANGE;

		if (ToLowerCase(MapName()) == "underpath")
		{
			ATTACK_RANGE = 2048.0f;
			ATTACK_HITRANGE = 2048.0f;
		}

		if (NPC_SET_RANGE != "NPC_SET_RANGE")
		{
			ATTACK_RANGE = Float(NPC_SET_RANGE);
			ATTACK_HITRANGE = Float(NPC_SET_RANGE);
		}

		finalHp *= NPC_HP_MULTI;
		SetHealth(finalHp);
		HALF_HP = finalHp * 0.5f;
	}

	// grow_done
	void OnGrowDone()
	{
		OnNpcatkResumeAi();
	}

	// start_level2
	// Addparams
	void OnStartLevel2()
	{
		TREE_LEVEL = 2.0f;
		NPC_GIVE_EXP *= 2.0f;
		OnSetupTreeLevel();
	}

	// start_level3
	void OnStartLevel3()
	{
		TREE_LEVEL = 3.0f;
		NPC_GIVE_EXP *= 3.0f;
		OnSetupTreeLevel();
	}

	// spur_damage
	void OnSpurDamage()
	{
		float dmgSpur = DMG_SPUR * TREE_LEVEL;
		DoDamage(NPCATK_TARGET, "direct", dmgSpur, "100%", ENT_ME, "pierce");
	}

	// attack_slash
	void OnAttackSlash()
	{
		PlaySound(0, 10, SOUND_SLASH);
		float dmgSlash = DMG_SLASH * TREE_LEVEL;
		SLASH_ATTACK = true;
		DoDamage(NPCATK_TARGET, ATTACK_RANGE, dmgSlash, "100%", ENT_ME, "slash");

		if (!(TREE_LEVEL > 1.0f))
			return;

		if (!(GameTime() > NEXT_SHOOT))
			return;
		NEXT_SHOOT = GameTime() + FREQ_SHOOT;
		Vector3 traceStart = OriginOf(ENT_ME);
		float myYaw = AnglesOf(ENT_ME).y;
		traceStart += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 32, 32));
		if (TREE_LEVEL == 3.0f)
			traceStart.z += 32.0f;
		Vector3 traceEnd = OriginOf(NPCATK_TARGET);
		string traceLine = LegacyFunction("get_traceline", traceStart, traceEnd, "worldonly");
		if (traceLine != Text(traceEnd))
			return;

		ClientEvent("update", "all", TREE_CL_INDEX, "shoot_spur", traceStart, AnglesOf(ENT_ME).y);
		CallEventDelayed(0.1f, "spur_damage");

		if (TREE_LEVEL != 3.0f)
			return;
		if (!(GameTime() > NEXT_SPORE))
			return;
		NEXT_SPORE = GameTime() + FREQ_SPORE;
		PlaySound(0, 10, SOUND_SPORE);
		SPORE_POISON_DMG = Text(DOT_POISON); // read by proj_spore

		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_spore", RelativePosition(Vector3(0, 32, 16)), NPCATK_TARGET, 500, DMG_SPORE, 0.1f, "none");
	}

	// do_shrink
	void OnDoShrink()
	{
		NEXT_GROW = GameTime() + FREQ_GROW;
		PlayAnim("critical", LEVEL_PREFIX + "shrink");
		TREE_LEVEL -= 1.0f;
		OnNpcatkSuspendAi("0.75");
	}

	// shrink_done
	void OnShrinkDone()
	{
		AM_GROWING = false;
		OnNpcatkResumeAi();
		OnSetupTreeLevel();
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("cactusgibs.mdl");
		Precache("monsters/dewm_tree_combo.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		DoomPlantNew_FirstThink();
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
		if (name == "attack_slash") { OnAttackSlash(); return true; }
		if (name == "do_grow") { OnDoGrow(); return true; }
		if (name == "do_shrink") { OnDoShrink(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dodamage") { Return(OnGameDodamage(Truthy(Param(params, 0)), EntityParam(params, 1), Vec(Param(params, 2)), Vec(Param(params, 3)), Param(params, 4), Param(params, 5))); return true; }
		if (name == "grow_done") { OnGrowDone(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "set_final_params") { OnSetFinalParams(); return true; }
		if (name == "setup_tree_level") { OnSetupTreeLevel(); return true; }
		if (name == "shrink_done") { OnShrinkDone(); return true; }
		if (name == "spur_damage") { OnSpurDamage(); return true; }
		if (name == "start_level2") { OnStartLevel2(); return true; }
		if (name == "start_level3") { OnStartLevel3(); return true; }
		return BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
