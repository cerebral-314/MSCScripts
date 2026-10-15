#pragma context server

// Converted from bloodrose/trigger_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/externals.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BloodroseTriggerBase
{
	// Constants
	float HOME_DELAY = 0.0f;
	float RESET_DELAY = 30.0f;

	// Variables (an unset .script variable reads as its own name)
	bool TAKE_IT = false;
	string TRIGGER_STRING = "TRIGGER_STRING";
	string PLAYING_DEAD = "PLAYING_DEAD";
	Vector3 HOME_POS = Vector3();
	bool TRIG_DELAY = false;
	bool IAM_ON = false;

	// game_spawn
	void BloodroseTriggerBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetNoPush(true);

		SetHealth(1500);
		TAKE_IT = false;
		SetName("Elemental Shard");
		SetRace("demon");
		SetModel("crystal.mdl");
		SetWidth(15);
		SetHeight(60);
		SetMoveSpeed(0);
		SetBlood("none");
		SetGravity(0);
		SetFly(true);

		// setsolid box
		// setprop ent_me movetype const.movetype.none
		TRIGGER_STRING = "toggle_" + ELEMENT_TYPE;
		SetProp(ENT_ME, "rendermode", 5);
		SetProp(ENT_ME, "renderamt", 255);
		CallEventDelayed(1.0f, "get_origin");

		SetMoveAnim("spin");
		SetIdleAnim("spin");

		SetDamageTaken("all", 0.33f);
		SetDamageTaken("stun", 0);

		PLAYING_DEAD = "1";
		CallEventDelayed(HOME_DELAY, "reset_pos");

		OnGlowLoop();

		OnTriggerSpawn();
	}

	// glow_loop
	void BloodroseTriggerBase_OnGlowLoop()
	{
		CallEventDelayed(5.3f, "glow_loop");
		// getent player 256
		if (ELEMENT_TYPE == "lightning")
			Effect("glow", ENT_ME, Vector3(255, 255, 0), 128, 10, 10);
		if (ELEMENT_TYPE == "cold")
			Effect("glow", ENT_ME, Vector3(4, 50, 128), 128, 10, 10);
		if (ELEMENT_TYPE == "fire")
			Effect("glow", ENT_ME, Vector3(255, 0, 0), 128, 10, 10);
		if (ELEMENT_TYPE == "poison")
			Effect("glow", ENT_ME, Vector3(0, 255, 0), 128, 10, 10);
	}

	// get_origin
	void BloodroseTriggerBase_OnGetOrigin()
	{
		HOME_POS = MyOrigin();
	}

	// reset_pos
	void BloodroseTriggerBase_OnResetPos()
	{
		SetOrigin(ENT_ME, HOME_POS);
		CallEventDelayed(11.0f, "reset_pos");
	}

	// game_damaged
	// PARAM1=attacker PARAM2=Damage PARAM3=Type
	string BloodroseTriggerBase_OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "")
	{
		string result = "";

		// setting hp to 3000 every time causing it to go BD?
		if (MyHealth() < MyMaxHealth())
		{
			float diff = MyMaxHealth() - MyHealth();
			GiveHealth(diff);
		}
		SetOrigin(ENT_ME, HOME_POS);

		OnCheckDamageType(damageType);
		return result;
	}

	// check_damage_type
	void BloodroseTriggerBase_OnCheckDamageType(string damageType = "")
	{
		bool damaged = false;

		if (Contains(ELEMENT_TYPE, damageType))
			damaged = true;
		if (Contains(damageType, "acid") && Contains(ELEMENT_TYPE, "poison"))
			damaged = true;
		if (!damaged)
			return;

		if (!TRIG_DELAY)
			TRIG_DELAY = true;

		OnElementOn();
	}

	// trig_reset
	void BloodroseTriggerBase_OnTrigReset()
	{
		IAM_ON = false;
		SetOrigin(ENT_ME, HOME_POS);
		TRIG_DELAY = false;
		CBaseEntity@ monName = FindByName("ele_monitor");
		CBaseEntity@ monId = monName;
		if (!TRIG_DELAY)
			CallExternal(monId, "trigger_off", ELEMENT_TYPE);
		UseTrigger(TRIGGER_STRING);
	}

	// element_trigs_remove
	void BloodroseTriggerBase_OnElementTrigsRemove()
	{
		DeleteEntity(ENT_ME);
	}

	// element_on
	void BloodroseTriggerBase_OnElementOn()
	{
		if (IAM_ON)
			return;
		IAM_ON = true;

		CBaseEntity@ monId = FindByName("ele_monitor");
		CallExternal(monId, "trigger_on", ELEMENT_TYPE);
		UseTrigger(TRIGGER_STRING);
	}

	// effect_damage
	// PARAM1=Dmg PARAM2=Attacker PARAM3=Duration PARAM4=Type
	void BloodroseTriggerBase_OnEffectDamage(string damage = "", string attacker = "", string duration = "", string damageType = "")
	{
		OnCheckDamageType(damageType);
	}

	// game_death
	void BloodroseTriggerBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		// ^_^ - I doubt this is happening, but just in case
		InfoMessage("all", "OMFG_WTF", "MAJOR MAP ERROR - AN A ELEMENTAL CRYSTAL DIED! WTF!?");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_death
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		DqMonsterExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // dq/externals/dq_monster_externals
		MonstersExternals_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); // monsters/externals
		BloodroseTriggerBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4);
	}

	void OnGameSpawn(string playerRace = "", string playerGender = "") { BloodroseTriggerBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnGlowLoop() { BloodroseTriggerBase_OnGlowLoop(); } // glow_loop
	void OnGetOrigin() { BloodroseTriggerBase_OnGetOrigin(); } // get_origin
	void OnResetPos() { BloodroseTriggerBase_OnResetPos(); } // reset_pos
	string OnGameDamaged(CBaseEntity@ attacker = null, float damage = 0.0f, string damageType = "", float accuracyRoll = 0.0f, CBaseEntity@ inflictor = null, string skill = "") { return BloodroseTriggerBase_OnGameDamaged(attacker, damage, damageType, accuracyRoll, inflictor, skill); } // game_damaged
	void OnCheckDamageType(string damageType = "") { BloodroseTriggerBase_OnCheckDamageType(damageType); } // check_damage_type
	void OnTrigReset() { BloodroseTriggerBase_OnTrigReset(); } // trig_reset
	void OnElementTrigsRemove() { BloodroseTriggerBase_OnElementTrigsRemove(); } // element_trigs_remove
	void OnElementOn() { BloodroseTriggerBase_OnElementOn(); } // element_on
	void OnEffectDamage(string damage = "", string attacker = "", string duration = "", string damageType = "") { BloodroseTriggerBase_OnEffectDamage(damage, attacker, duration, damageType); } // effect_damage
	void OnHomeDelay() {} // HOME_DELAY
	void OnTriggerSpawn() {} // trigger_spawn

	// This file's events and timers by their .script names
	bool BloodroseTriggerBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "check_damage_type") { OnCheckDamageType(Param(params, 0)); return true; }
		if (name == "effect_damage") { OnEffectDamage(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "element_on") { OnElementOn(); return true; }
		if (name == "element_trigs_remove") { OnElementTrigsRemove(); return true; }
		if (name == "game_damaged") { Return(OnGameDamaged(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Float(Param(params, 3)), EntityParam(params, 4), Param(params, 5))); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "get_origin") { OnGetOrigin(); return true; }
		if (name == "glow_loop") { OnGlowLoop(); return true; }
		if (name == "reset_pos") { OnResetPos(); return true; }
		if (name == "trig_reset") { OnTrigReset(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "bloodrose/trigger_base"]
shared class BloodroseTriggerBaseScript : MonstersExternalsScript, BloodroseTriggerBase
{
	// Variables every script that includes this file declares
	string ELEMENT_TYPE = "ELEMENT_TYPE";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("crystal.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BloodroseTriggerBase_DispatchEvent(name, params)
			|| MonstersExternalsScript::DispatchEvent(name, params);
	}
}
