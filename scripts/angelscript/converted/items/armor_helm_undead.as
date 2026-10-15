#pragma context server

// Converted from items/armor_helm_undead.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base_helmet.as"

[script "items/armor_helm_undead"]
class ArmorHelmUndead : ArmorBaseHelmetScript
{
	// Variables declared by included files, with the value they start with in this script
	ArmorHelmUndead()
	{
		ARMOR_MODEL = "armor/p_helmets.mdl";
		ARMOR_BODY = 12;
		ARMOR_TEXT = "You gain resistance to damage from undead.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "0%";
		STUN_PROTECTION = 0.7f;
	}

	// game_takedamage
	// //PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type
	string ArmorHelmUndead_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool isUndead = false;
		string result = "";

		// dbg game_takedamage worn[ $get(ent_me,is_worn) ] infrace[ $get(PARAM2,race) ] atkrace [ $get(PARAM1,race) ]
		if (!IsWorn(ENT_ME))
			return result;

		if (RaceOf(attacker) == "undead")
			isUndead = true;
		if (RaceOf(inflictor) == "undead")
			isUndead = true;
		if (!isUndead)
			return result;

		float inDmg = damage;
		float outDmg = damage;
		inDmg *= 0.25f;
		outDmg -= inDmg;

		DebugPrint("game_takedamage adjustdmg " + Text(damage) + " to " + Text(outDmg));

		SetDamageInfo("hit", 1);
		SetDamageInfo("dmg", outDmg);
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender); // items/armor_base_helmet

		SetName("Helm of the Dead");
		SetDescription("This seems to be stitched from bat wings and rotting flesh");
		SetWeight(10);
		SetWearable(1, "head");
		SetValue(1);

		SetHudSprite("trade", "86");
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ArmorHelmUndead_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_helmets.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		return ArmorBaseHelmetScript::DispatchEvent(name, params);
	}
}
