#pragma context server

// Converted from items/smallarms_eth.script by msc_transpiler.
// Ethereal Dagger, MiB
// Normal dagger that compensates for a monster's armor

#include "runtime/ScriptEntity.as"
#include "converted/items/smallarms_base.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class SmallarmsEth
{
	// Constants
	string BASE_LEVEL_REQ = "25";
	string MODEL_VIEW = "viewmodels/v_smallarms.mdl";
	string MODEL_HANDS = "weapons/p_weapons3.mdl";
	string MODEL_WORLD = "weapons/p_weapons3.mdl";
	string MODEL_BODY_OFS = "48";
	int MODEL_VIEW_IDX = 12;
	string MELEE_RANGE = "50";
	float MELEE_DMG_DELAY = 0.2f;
	float MELEE_ATK_DURATION = 0.9f;
	float MELEE_ENERGY = 0.6f;
	int MELEE_DMG = 225;
	int MELEE_DMG_RANGE = 50;
	string MELEE_DMG_TYPE = "dark";
	string MELEE_ACCURACY = "85%";
	string MELEE_ALIGN_BASE = "3.6,-6";
	string MELEE_ALIGN_TIP = "0,0";
	float MELEE_SOUND_DELAY = 0.0f;
	string MELEE_PARRY_CHANCE = "5%";
	string PLAYERANIM_AIM = "knife";
	string PLAYERANIM_SWING = "swing_knife";
	string SOUND_HITWALL1 = "debris/glass1.wav";
	string SOUND_HITWALL2 = "debris/glass2.wav";
	string ANIM_PREFIX = "standard";

	// Variables (an unset .script variable reads as its own name)
	bool ETHER_ABORT = false;

	// weapon_spawn
	void SmallarmsEth_OnWeaponSpawn()
	{
		SetName("Ethereal Dagger");
		SetDescription("A ghostly dagger");
		SetWeight(3);
		SetValue(3000);
		SetHudSprite("hand", "136");
		SetHudSprite("trade", "136");
	}

	// melee_damaged_other
	string SmallarmsEth_OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";

		if (ETHER_ABORT)
			return result;

		if (!IsAlive(target))
			return result;

		string enemyArmorText = ScriptVarOf(target, "MSC_ARMOR_ALL");
		int enemyArmor = Int(enemyArmorText);

		if (!(enemyArmor > 0))
			return result;

		OnAdjDamage(enemyArmorText, Text(damage));
		return result;
	}

	// special_02_damaged_other
	void SmallarmsEth_OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		if (ETHER_ABORT)
			return;

		if (!IsAlive(target))
			return;

		string enemyArmorText = ScriptVarOf(target, "MSC_ARMOR_ALL");
		int enemyArmor = Int(enemyArmorText);

		if (!(enemyArmor > 0))
			return;

		OnAdjDamage(enemyArmorText, Text(damage));
	}

	// adj_damage
	string SmallarmsEth_OnAdjDamage(string armorValue = "", string incomingDamage = "")
	{
		string result = "";

		if (!(Float(incomingDamage) > 0.0f))
			return result;
		if (!(Float(armorValue) < 1.0f))
			return result;
		float multDamage = Divide(1.0f, Float(armorValue));

		DebugPrint("adj_damage armr " + armorValue + " dmg " + incomingDamage);

		string outDamageText = incomingDamage;
		float outDamage = Float(outDamageText) * multDamage;
		outDamageText = Text(outDamage);

		SetDamageInfo("dmg", outDamageText);
		result = AppendResult(result, Text(multDamage));
		return result;
	}

	// ext_ether
	// debug
	void SmallarmsEth_OnExtEther()
	{
		if (ETHER_ABORT)
			ETHER_ABORT = false;
		else
			ETHER_ABORT = true;
		DebugPrint("ext_ether " + Text(ETHER_ABORT));
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		SmallarmsBase_OnWeaponSpawn(); // items/smallarms_base
		SmallarmsEth_OnWeaponSpawn();
	}

	// melee_damaged_other
	string OnMeleeDamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "")
	{
		string result = "";
		result = AppendResult(result, BaseMelee_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		result = AppendResult(result, SmallarmsEth_OnMeleeDamagedOther(target, damage, damageType, damageEvent));
		return result;
	}

	void OnSpecial02DamagedOther(CBaseEntity@ target = null, float damage = 0.0f, string damageType = "", string damageEvent = "") { SmallarmsEth_OnSpecial02DamagedOther(target, damage, damageType, damageEvent); } // special_02_damaged_other
	string OnAdjDamage(string armorValue = "", string incomingDamage = "") { return SmallarmsEth_OnAdjDamage(armorValue, incomingDamage); } // adj_damage
	void OnExtEther() { SmallarmsEth_OnExtEther(); } // ext_ether

	// This file's events and timers by their .script names
	bool SmallarmsEth_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "adj_damage") { Return(OnAdjDamage(Param(params, 0), Param(params, 1))); return true; }
		if (name == "ext_ether") { OnExtEther(); return true; }
		if (name == "melee_damaged_other") { Return(OnMeleeDamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3))); return true; }
		if (name == "special_02_damaged_other") { OnSpecial02DamagedOther(EntityParam(params, 0), Float(Param(params, 1)), Param(params, 2), Param(params, 3)); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/smallarms_eth"]
shared class SmallarmsEthScript : SmallarmsBaseScript, SmallarmsEth
{
	// Variables every script that includes this file declares
	float BURST_DAMAGE = 0.0f;
	bool CUSTOM_REGISTER_SECONDARY = false;
	bool CUSTOM_SWING = false;
	int GAME_PVP = 0;
	string TARG_LIST = "TARG_LIST";

	// Variables declared by included files, with the value they start with in this script
	SmallarmsEthScript()
	{
		MODEL_VIEW = "viewmodels/v_smallarms.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_BODY_OFS = "48";
		MODEL_VIEW_IDX = 12;
		MELEE_RANGE = "50";
		MELEE_DMG_DELAY = 0.2f;
		MELEE_ATK_DURATION = 0.9f;
		MELEE_ENERGY = 0.6f;
		MELEE_DMG = 225;
		MELEE_DMG_RANGE = 50;
		MELEE_DMG_TYPE = "dark";
		MELEE_ACCURACY = "85%";
		MELEE_PARRY_CHANCE = "5%";
		SOUND_HITWALL1 = "debris/glass1.wav";
		SOUND_HITWALL2 = "debris/glass2.wav";
		ANIM_PREFIX = "standard";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
		Precache("viewmodels/v_smallarms.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return SmallarmsEth_DispatchEvent(name, params)
			|| SmallarmsBaseScript::DispatchEvent(name, params);
	}
}
