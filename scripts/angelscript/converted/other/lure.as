#pragma context server

// Converted from other/lure.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/base_npc.as"
#include "converted/monsters/debug.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class OtherLure
{
	// Variables (an unset .script variable reads as its own name)
	Vector3 LURE_HOME_POS = Vector3();
	string NEW_NAME = "NEW_NAME";
	float NPC_DMG_MULTI = 0.0f;
	float NPC_HP_MULTI = 0.0f;
	string NPC_DO_EVENTS = "NPC_DO_EVENTS";
	bool NPC_CRIT_WARN_DELAY = false;
	bool NPC_CRITICAL = false;

	// game_spawn
	void OtherLure_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHealth(1);
		SetRoam(false);
		SetRace("human");
		SetBlood("none");
		SetSkillLevel(0);
		SetWidth(32);
		SetHeight(32);
		SetModel("null.mdl");
		SetNoPush(true);

		SetSolid("trigger");
		SetBoundingBox("npcsize");

		CallEventDelayed(1.0f, "get_pos");
	}

	// get_pos
	void OtherLure_OnGetPos()
	{
		LURE_HOME_POS = MyOrigin();
		CallEventDelayed(20.0f, "maintain_pos");
	}

	// npc_spawn
	void OtherLure_OnNpcSpawn(string npc = "")
	{
		SetBlood("none");
		SetProp(ENT_ME, Eval("const.movetype.none"));
	}

	// game_death
	void OtherLure_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		UseTrigger("lure_died");
	}

	// game_struck
	void OtherLure_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		SetOrigin(ENT_ME, LURE_HOME_POS);
		// dbg Remaining Lure Heath $get(ent_me,hp) [ struck for PARAM1 ]
		if ((IsPlayer(ENT_LASTSTRUCK) ? 1 : 0) != 1)
			return;
		GiveHealth(damage);
	}

	// game_takedamage
	// 1: Attacker  2: Inflictor  3: dmg  4: dmg type
	string OtherLure_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";

		DebugPrint("game_takedamage " + NameOf(attacker) + " " + NameOf(inflictor) + " " + Text(damage) + " " + damageType);

		// dbg Took PARAM3 from either PARAM1 or PARAM2
		if (IsPlayer(attacker))
			result = AppendResult(result, "0");
		if (IsPlayer(inflictor))
			result = AppendResult(result, "0");
		return result;
	}

	// game_damaged
	string OtherLure_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		DebugPrint("game_takedamage " + NameOf(attacker));

		if (!IsPlayer(attacker))
			return result;
		result = AppendResult(result, "0");
		return result;
	}

	// maintain_pos
	void OtherLure_OnMaintainPos()
	{
		SetOrigin(ENT_ME, LURE_HOME_POS);
		CallEventDelayed(20.0f, "maintain_pos");
	}

	// make_sun
	// vampire blood hack (dun think we're using this anymore, but not sure)
	void OtherLure_OnMakeSun()
	{
		SetName("The sun");
		SetInvincible(true);
		SetRace("hated");
	}

	// game_postspawn
	// ========= siege system, adjustable HP, etc.
	// PARAM1 = (name|default), PARAM2 = DmgMulti, PARAM3 = HPMulti, PARAM4 = pass_params
	void OtherLure_OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		DebugPrint("game_postspawn got name " + title + " dmg " + damageMultiplier + " hp " + healthMultiplier + " ( PARAMS: " + params + " )");
		NEW_NAME = title;
		if (NEW_NAME != "default")
			SetName(NEW_NAME);

		NPC_DMG_MULTI = 1.0f;
		if (Float(damageMultiplier) > 1.0f)
		{
			NPC_DMG_MULTI += Float(damageMultiplier);
			SetDamageMultiplier(Float(damageMultiplier));
		}

		NPC_HP_MULTI = 1.0f;
		if (Float(healthMultiplier) > 1.0f)
			NPC_HP_MULTI = Float(healthMultiplier);

		NPC_DO_EVENTS = params;
		if (params == "none")
			return;
		int count = GetTokenCount(NPC_DO_EVENTS);
		for (int i = 0; i < count; i++)
		{
			loopIteration = i;
			OnNpcatkDoEvents();
		}
	}

	// game_death
	void OtherLure_OnGameDeath_2(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// siege system
		if (!NPC_CRITICAL)
			return;
		string infoTitle = "A CRITICAL OBJECT HAS BEEN DESTROYED!";
		string infoMsg = NameOf(ENT_ME) + " has been destroyed! ";
		InfoMessage("all", infoTitle, infoMsg);
		CallExternal(GetVar("GAME_MASTER"), "gm_crit_npc_died", self, @EntityOf(ENT_LASTSTRUCK));
	}

	// game_struck
	void OtherLure_OnGameStruck_2(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (NPC_CRITICAL)
		{
			// warn players if critical NPC struck
			if (!NPC_CRIT_WARN_DELAY)
			{
				NPC_CRIT_WARN_DELAY = true;
				CallEventDelayed(NPC_FREQ_WARN, "npcatk_reset_warn_delay");
				string infoTitle = "Critical Object Under Attack!";
				string infoMsg = NameOf(ENT_ME) + " is under attack!";
				InfoMessage("all", infoTitle, infoMsg);
			}
		}
	}

	// critical_npc
	void OtherLure_OnCriticalNpc()
	{
		// for siege mode maps
		SetInvincible(false);
		NPC_CRITICAL = true;
		LegacyCommand("token.add", "G_CRITICAL_NPCS", self);
		SetGlobal("G_SIEGE_MAP", 1);
		CBaseEntity@ firstToken = FindEntity(GetToken(GetVar("G_CRITICAL_NPCS"), 0));
		if (!IsAlive(firstToken)) // fix buggy token creation
			LegacyCommand("token.del", "G_CRITICAL_NPCS", 0);
	}

	// npcatk_reset_warn_delay
	void OtherLure_OnNpcatkResetWarnDelay()
	{
		NPC_CRIT_WARN_DELAY = false;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		OtherLure_OnGameSpawn(playerRace, playerGender);
		BaseNpc_OnGameSpawn(playerRace, playerGender); // monsters/base_npc
	}

	void OnGetPos() { OtherLure_OnGetPos(); } // get_pos
	void OnNpcSpawn(string npc = "") { OtherLure_OnNpcSpawn(npc); } // npc_spawn

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BaseSelfAdjust_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_self_adjust
		BaseNpc_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		OtherLure_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
		OtherLure_OnGameDeath_2(attacker, extraValue2, extraValue3, extraValue4);
	}

	// critical_npc
	void OnCriticalNpc()
	{
		MonstersExternals_OnCriticalNpc(); // monsters/externals
		OtherLure_OnCriticalNpc();
	}

	// game_postspawn
	void OnGamePostspawn(string title = "", string damageMultiplier = "", string healthMultiplier = "", string params = "")
	{
		BaseSelfAdjust_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_self_adjust
		BaseNpc_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params); // monsters/base_npc
		OtherLure_OnGamePostspawn(title, damageMultiplier, healthMultiplier, params);
	}

	// game_struck
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		BaseNpc_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); // monsters/base_npc
		OtherLure_OnGameStruck(damage, extraValue2, extraValue3, extraValue4);
		OtherLure_OnGameStruck_2(damage, extraValue2, extraValue3, extraValue4);
	}

	// npcatk_reset_warn_delay
	void OnNpcatkResetWarnDelay()
	{
		BaseNpc_OnNpcatkResetWarnDelay(); // monsters/base_npc
		OtherLure_OnNpcatkResetWarnDelay();
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return OtherLure_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return OtherLure_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnMaintainPos() { OtherLure_OnMaintainPos(); } // maintain_pos
	void OnMakeSun() { OtherLure_OnMakeSun(); } // make_sun

	// This file's events and timers by their .script names
	bool OtherLure_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "critical_npc") { OnCriticalNpc(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_postspawn") { OnGamePostspawn(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "get_pos") { OnGetPos(); return true; }
		if (name == "maintain_pos") { OnMaintainPos(); return true; }
		if (name == "make_sun") { OnMakeSun(); return true; }
		if (name == "npc_spawn") { OnNpcSpawn(Param(params, 0)); return true; }
		if (name == "npcatk_reset_warn_delay") { OnNpcatkResetWarnDelay(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "other/lure"]
shared class OtherLureScript : BaseNpcScript, OtherLure
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("null.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return OtherLure_DispatchEvent(name, params)
			|| BaseNpcScript::DispatchEvent(name, params);
	}
}
