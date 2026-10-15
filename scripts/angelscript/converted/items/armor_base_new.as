#pragma context server

// Converted from items/armor_base_new.script by msc_transpiler.
// NO LONGER IN USE
// - Experimental changes integrated into armor_base

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"
#include "converted/items/base_effect_armor.as"

[script "items/armor_base_new"]
class ArmorBaseNew : BaseItemScript, BaseEffectArmor
{
	// Constants
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_BODY_OFS = "16";
	string MODEL_VIEW = "none";
	string NEW_ARMOR_MODEL = "armor/p_armorvest_new.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ARMOR_TYPE = "ARMOR_TYPE";
	bool ARMOR_PROTECTION = false;
	string ARMOR_PROTECTION_AREA = "ARMOR_PROTECTION_AREA";
	string ARMOR_REPLACE_BODYPARTS = "ARMOR_REPLACE_BODYPARTS";
	float L_PERC_TO_FLOAT = 0.0f;
	float DMG_REDUCT = 0.0f;

	// game_takedamage
	// PARAM1=attacker PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type
	string ArmorBaseNew_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		float outDmg = 0.0f;
		string result = "";

		if (!IsWorn(ENT_ME))
			return result;

		// this has to be handled here, for some damned reason
		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_SPIDER_PROT")) && RaceOf(attacker) == "spider")
		{
			string dmgRedAmt = ScriptVarOf(ENT_OWNER, "PLR_SPIDER_AMT");
			outDmg = damage * 0.0f;
			SetDamageInfo("hit", 1);
			SetDamageInfo("dmg", outDmg);
			result = AppendResult(result, "PLR_SPIDER_AMT");
		}

		if (Contains(damageType, "poison"))
		{
			// armor no longer protects against poison
			// but we are reducing all poison damage 50% to compensate
			outDmg = damage;
			damage *= 0.5f;
			SetDamageInfo("hit", 1);
			SetDamageInfo("dmg", damage);
			result = AppendResult(result, "0.5");
		}
		else
		{
			// basic protection
			if (!Truthy(ScriptVarOf(attacker, "NPC_IGNORES_ARMOR")))
			{
				damage *= DMG_REDUCT;
				SetDamageInfo("hit", 1);
				SetDamageInfo("dmg", damage);
				result = AppendResult(result, Text(DMG_REDUCT));
			}
		}
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item

		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", "armor");
		SetHudSprite("trade", "leather");

		SetHand("any");

		ARMOR_TYPE = "BARMOR_TYPE";
		ARMOR_PROTECTION = false;
		ARMOR_PROTECTION_AREA = "BARMOR_PROTECTION_AREA";
		ARMOR_REPLACE_BODYPARTS = "BARMOR_PROTECTION_AREA";

		LegacyCommand("registerarmor");

		SetModelBody(0, 0);
		OnHideBodyParts();

		L_PERC_TO_FLOAT = 0.0f;
		L_PERC_TO_FLOAT *= 0.01f;
		DMG_REDUCT = 1.0f - L_PERC_TO_FLOAT;
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor

		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);

		float submodel = 16.0f + ItemHandIndex();
		SetModelBody(0, int(submodel));
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor

		SetModel(NEW_ARMOR_MODEL);
		SetModelBody(0, 0);

		OwnerMessageClient("ARMOR_TEXT ( BARMOR_PROTECTION )");

		// callexternal ent_owner ext_setbodytype BARMOR_TYPE
		OnHideBodyParts();

		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// hide_body_parts
	void OnHideBodyParts(string bodyParts = "")
	{
		// if ( BARMOR_TYPE equals leather ) setmodelbody ent_owner 1 1
		// if ( BARMOR_TYPE equals platemail ) setmodelbody ent_owner 1 2
		CallExternal(ENT_OWNER, "ext_setbodytype", "BARMOR_TYPE");
	}

	// show_body_parts
	void OnShowBodyParts()
	{
		// setmodelbody ent_owner 1 0
		CallExternal(ENT_OWNER, "ext_setbodytype", "normal");
	}

	// barmor_effect_remove
	void OnBarmorEffectRemove()
	{
		if (ScriptVarOf(ENT_OWNER, "PLR_BODY_TYPE") == "normal")
			return;
		// callexternal ent_owner ext_setbodytype normal
		OnShowBodyParts();
	}

	// barmor_effect_activate
	// place holder for dbg spam removal
	void OnBarmorEffectActivate()
	{
		CallExternal(ENT_OWNER, "ext_setbodytype", "BARMOR_TYPE");
	}

	// failed_str_req_loop
	void OnFailedStrReqLoop()
	{
		if (!IsWorn(ENT_ME))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < 0.0f))
			return;
		CallEventDelayed(10.0f, "failed_str_req_loop");
		string alrtStr = "You are too weak to move freely in this armor. (Min Strength ARMOR_STR_REQ)";
		InfoMessage(ENT_OWNER, "Insufficient Strength for Armor", alrtStr);
		ApplyEffect(ENT_OWNER, "effects/effect_slow", 10.0f, "50%", self); // effects/speed 10.0 75% 0.5
	}

	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ArmorBaseNew_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseItem_OnGameDrop(); // items/base_item
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
	}

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_armorvest_new.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "failed_str_req_loop") { OnFailedStrReqLoop(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "hide_body_parts") { OnHideBodyParts(Param(params, 0)); return true; }
		if (name == "show_body_parts") { OnShowBodyParts(); return true; }
		return BaseEffectArmor_DispatchEvent(name, params)
			|| BaseItemScript::DispatchEvent(name, params);
	}
}
