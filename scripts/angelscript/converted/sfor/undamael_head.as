#pragma context server

// Converted from sfor/undamael_head.script by msc_transpiler.
// This is undamael's head
// - Rather, this is an invisible 128x128 box that tracks the position of his head
// - This gives the illusion that he is solid and gives him the ability to be struck

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_monster_new.as"
#include "converted/monsters/base_propelled.as"

[script "sfor/undamael_head"]
class UndamaelHead : BaseMonsterNewScript, BasePropelled
{
	// Variables (an unset .script variable reads as its own name)
	float NPC_HACKED_MOVE_SPEED = 0.0f;
	string MY_OWNER = "MY_OWNER";
	float LAST_PLR_TOUCH = 0.0f;
	bool NO_SOLID = false;
	string VULNERABLE = "VULNERABLE";

	// unnamed block (first think)
	void UndamaelHead_FirstThink()
	{
		SetCallback("touch", "enable"); // edited to work in APR2008a
		NPC_HACKED_MOVE_SPEED = 100.0f;
		NPC_GIVE_EXP = 15000.0f;
	}

	// game_spawn
	void UndamaelHead_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetUniqueName("head_undi");

		SetName("Undamael");
		SetRace("undead");
		SetHealth(20000);
		SetModel("monsters/undamael_hitbox.mdl");
		SetBlood("red");
		SetWidth(128);
		SetHeight(128);
		SetRoam(false);
		SetFly(true);
		SetBoundingBox("npcsize"); // commented
		SetSolid("box"); // slidebox
		SetDamageTaken("all", 0.5f);
		SetDamageTaken("fire", 0);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 2);
		SetModelBody(0, 0);
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 0);
		IMMUNE_VAMPIRE = true;
		SetNoPush(true);
		OnNpcatkSuspendAi();

		CallEventDelayed(1.0f, "check_vulnerable");
	}

	// game_damaged
	// PARAM1=attacker PARAM2=dmg PARAM3=dmg_type
	string UndamaelHead_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		if (Truthy(VULNERABLE))
			return result;

		SetHealth(MaxHealthOf(ENT_ME));
		DoDamage(attacker, "direct", damage, "100%", damageType);
		result = AppendResult(result, "0.0");
		return result;
	}

	// unnamed block (timer)
	void UndamaelHead_Timer()
	{
		CallEventDelayed(0.01f, "UndamaelHead_Timer");
		Vector3 destLoc = AttachmentPositionOf(MY_OWNER, 1); // location of Undamael's head center
		SetOrigin(ENT_ME, destLoc);
		if (GameTime() < LAST_PLR_TOUCH)
			SetSolid("trigger");
		else
			SetSolid("slidebox");
	}

	// game_touch
	string UndamaelHead_OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "")
	{
		string result = "";

		if (!IsPlayer(other))
			return result;
		LAST_PLR_TOUCH = GameTime() + 0.25f;
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		UndamaelHead_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
		BaseMonsterShared_OnGameSpawn(playerRace, playerGender); // monsters/base_monster_shared
	}

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseMonsterShared_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		CallExternal(MY_OWNER, "death_sequence");
	}

	// game_dynamically_created
	void OnGameDynamicallyCreated(string creatorValue1 = "", string creatorValue2 = "", string damage = "", string skill = "", string extraValue5 = "", string extraValue6 = "", float alwaysPush = 0.0f, string duration = "", string extraValue9 = "")
	{
		BaseSelfAdjust_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseSelfAdjust_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_self_adjust
		BaseAntiStuck_OnGameDynamicallyCreated(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		BaseAntiStuck_OnGameDynamicallyCreated_2(creatorValue1, creatorValue2, damage, skill, extraValue5, extraValue6, alwaysPush, duration, extraValue9); // monsters/base_anti_stuck
		MY_OWNER = creatorValue1;
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		BaseNpcAttackNew_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc_attack_new
		BaseMonsterShared_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_monster_shared
		DebugPrint("head struck");

		if (ScriptVarOf(MY_OWNER, "NPCATK_TARGET") == "unset")
			CallExternal(MY_OWNER, "npcatk_settarget", @EntityOf(ENT_LASTSTRUCK), "struck");
		else if (RandomInt(1, 100) < 50) // 50% retaliate
			CallExternal(MY_OWNER, "npcatk_settarget", @EntityOf(ENT_LASTSTRUCK), "struck");
	}

	// game_damaged - Return a damage multiplier to scale the damage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";
		result = AppendResult(result, BaseAntiStuck_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, BaseMonsterShared_OnGameDamaged_2(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		result = AppendResult(result, UndamaelHead_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill));
		return result;
	}

	// npcatk_hunt
	void OnNpcatkHunt()
	{
	}

	string OnGameTouch(CBaseEntity@ other = null, string hpRange = "", string effectDamage = "") { return UndamaelHead_OnGameTouch(other, hpRange, effectDamage); } // game_touch

	// ext_solid_on
	void OnExtSolidOn()
	{
		NO_SOLID = false;
		SetSolid("slidebox");
	}

	// ext_show_head
	void OnExtShowHead()
	{
		SetModelBody(0, 1);
		SetProp(ENT_ME, "renderamt", 64);
	}

	// ext_unsolid
	// PARAM1 = time
	void OnExtUnsolid(float time = 0.0f)
	{
		LAST_PLR_TOUCH = GameTime() + time;
		SetSolid("trigger");
	}

	// ext_vulnerable
	void OnExtVulnerable(string value = "")
	{
		VULNERABLE = value;
	}

	// do_nuke
	// <target> <dmg>
	void OnDoNuke(string target = "", int damage = 0)
	{
		DebugPrint("doing nuke");
		// <projectile scriptname> <"view"|(src_origin)> <target|(targ_origin)|none> <speed> <damage> <cof> <skill|none> //Converted to use new tossprojectile //greatguys1@FEB2022
		TossProjectile("proj_meteor", RelativePosition(Vector3(0, 0, 0)), @EntityOf(target), 150, damage, 2, "none");
	}

	// check_vulnerable
	void OnCheckVulnerable()
	{
		if (!Truthy(GetVar("G_UNDAMAEL_VULNERABLE")))
			return;
		VULNERABLE = "1";
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
		Precache("monsters/undamael_hitbox.mdl");
		CallEventDelayed(0.01f, "UndamaelHead_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		UndamaelHead_FirstThink();
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
		if (name == "check_vulnerable") { OnCheckVulnerable(); return true; }
		if (name == "do_nuke") { OnDoNuke(Param(params, 0), Int(Param(params, 1))); return true; }
		if (name == "ext_show_head") { OnExtShowHead(); return true; }
		if (name == "ext_solid_on") { OnExtSolidOn(); return true; }
		if (name == "ext_unsolid") { OnExtUnsolid(Float(Param(params, 0))); return true; }
		if (name == "ext_vulnerable") { OnExtVulnerable(Param(params, 0)); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_dynamically_created") { OnGameDynamicallyCreated(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3), Param(params, 4), Param(params, 5), Float(Param(params, 6)), Param(params, 7), Param(params, 8)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_touch") { Return(OnGameTouch(EntityParam(params, 0), Param(params, 1), Param(params, 2))); return true; }
		if (name == "npcatk_hunt") { OnNpcatkHunt(); return true; }
		if (name == "UndamaelHead_Timer") { UndamaelHead_Timer(); return true; }
		return BasePropelled_DispatchEvent(name, params)
			|| BaseMonsterNewScript::DispatchEvent(name, params);
	}
}
