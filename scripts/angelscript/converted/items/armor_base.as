#pragma context server

// Converted from items/armor_base.script by msc_transpiler.
// Armor
// #scope server
// [shared] game_wear, register_loop, set_armor_body
// Requires:
// BARMOR_TYPE				platemail|leather - affects display
// BARMOR_PROTECTION			Damage reduction%
// NEW_ARMOR_OFS				body offset in p_armorvest_new.mdl
// ARMOR_TEXT				text to display when donning armor, eg. "You assemble the phoenix armor."
// ARMOR_STR_REQ				optional - strength requirement for armor

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"
#include "converted/items/base_effect_armor.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ArmorBase
{
	// Constants
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "none";
	int ARMOR_HUMAN_FEMALE_OFS_ADJ = 20;
	string NEW_ARMOR_MODEL = "armor/p_armorvest_new.mdl";

	// Variables (an unset .script variable reads as its own name)
	string ARMOR_TYPE = "ARMOR_TYPE";
	bool ARMOR_PROTECTION = false;
	string ARMOR_PROTECTION_AREA = "ARMOR_PROTECTION_AREA";
	string ARMOR_REPLACE_BODYPARTS = "ARMOR_REPLACE_BODYPARTS";
	float L_PERC_TO_FLOAT = 0.0f;
	float DMG_REDUCT = 0.0f;

	// game_spawn
	void ArmorBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWorldModel(MODEL_WORLD);
		SetHudSprite("hand", "armor");
		SetHudSprite("trade", "leather");

		SetHand("any");

		ARMOR_TYPE = BARMOR_TYPE;
		ARMOR_PROTECTION = false;
		ARMOR_PROTECTION_AREA = GetVar("BARMOR_PROTECTION_AREA");
		ARMOR_REPLACE_BODYPARTS = GetVar("BARMOR_PROTECTION_AREA");

		LegacyCommand("registerarmor");

		// setmodelbody 0 NEW_ARMOR_OFS
		OnHideBodyParts();

		L_PERC_TO_FLOAT = Float(BARMOR_PROTECTION);
		L_PERC_TO_FLOAT *= 0.01f;
		DMG_REDUCT = 1.0f - L_PERC_TO_FLOAT;
	}

	// hide_body_parts
	void ArmorBase_OnHideBodyParts(string bodyParts = "")
	{
		// if ( BARMOR_TYPE equals leather ) setmodelbody ent_owner 1 1
		// if ( BARMOR_TYPE equals platemail ) setmodelbody ent_owner 1 2
		CallExternal(ENT_OWNER, "ext_setbodytype", BARMOR_TYPE, self);
	}

	// barmor_effect_activate
	void ArmorBase_OnBarmorEffectActivate()
	{
		CallExternal(ENT_OWNER, "ext_register_armor", self);
	}

	// show_body_parts
	void ArmorBase_OnShowBodyParts()
	{
		// setmodelbody ent_owner 1 0
		if (ScriptVarOf(ENT_OWNER, "PLR_LAST_WORN_ARMOR") == EntityId(self))
			CallExternal(ENT_OWNER, "ext_setbodytype", "normal", "remove");
		CallExternal(ENT_OWNER, "ext_register_armor", "none", "remove");
	}

	// game_deploy
	void ArmorBase_OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);

		float submodel = 16.0f + ItemHandIndex();
		SetModelBody(0, int(submodel));
	}

	// game_wear
	void ArmorBase_OnGameWear(string race = "", string gender = "", string source = "")
	{
		OnBarmorUpdateVest(race, gender, source);

		string armorText = ARMOR_TEXT + " (" + BARMOR_PROTECTION + ")";
		OwnerMessageClient(armorText);

		// callexternal ent_owner ext_setbodytype BARMOR_TYPE
		OnHideBodyParts();

		if (!(StatOf(ENT_OWNER, "strength") < Float(GetVar("ARMOR_STR_REQ"))))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// game_show
	void ArmorBase_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		OnBarmorUpdateVest(raceType, genderType, debugFlag);
	}

	// barmor_update_vest
	// <race> <gender> <debug>
	void ArmorBase_OnBarmorUpdateVest(string race = "", string gender = "", string debug = "")
	{
		string ownerRace;
		string ownerGender;
		bool armorGroup = false;
		SetModel(NEW_ARMOR_MODEL);
		SetModelBody(0, Int(GetVar("NEW_ARMOR_OFS")));

		ownerRace = RaceOf(ENT_OWNER);
		ownerGender = GenderOf(ENT_OWNER);

		ownerRace = ToLowerCase(ownerRace);
		ownerGender = ToLowerCase(ownerGender);
		if (ownerRace == "0") // char_menu, most likely
			ownerRace = race;
		if (ownerGender == "0") // char_menu, most likely
			ownerGender = gender;

		DebugPrint("barmor_update_vest race " + ownerRace + " gend " + ownerGender + " dbg " + debug);

		if (ownerGender == "female" && ownerRace == "human")
		{
			DebugPrint("*** Adjusted for Fembot");
			armorGroup = false;

			float femBody = Float(GetVar("NEW_ARMOR_OFS"));
			femBody += ARMOR_HUMAN_FEMALE_OFS_ADJ;
			SetModelBody((armorGroup ? 1 : 0), int(femBody));
		}

		if (Truthy(ScriptVarOf(ENT_OWNER, "PLR_HIDE_ARMOR")))
			SetModelBody((armorGroup ? 1 : 0), 0);
	}

	// ext_set_armor
	// for testing
	void ArmorBase_OnExtSetArmor(int bodyGroup = 0, int bodyIndex = 0)
	{
		SetModelBody(bodyGroup, bodyIndex);
	}

	// barmor_effect_remove
	void ArmorBase_OnBarmorEffectRemove()
	{
		if (ScriptVarOf(ENT_OWNER, "PLR_BODY_TYPE") == "normal")
			return;
		// callexternal ent_owner ext_setbodytype normal
		OnShowBodyParts();
	}

	// barmor_effect_activate
	// place holder for dbg spam removal
	void ArmorBase_OnBarmorEffectActivate_2()
	{
		CallExternal(ENT_OWNER, "ext_setbodytype", BARMOR_TYPE, self);
	}

	// failed_str_req_loop
	void ArmorBase_OnFailedStrReqLoop()
	{
		if (!IsWorn(ENT_ME))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < Float(GetVar("ARMOR_STR_REQ"))))
			return;
		CallEventDelayed(10.0f, "failed_str_req_loop");
		string alrtStr = "You are too weak to move freely in this armor. (Min Strength ";
		alrtStr += GetVar("ARMOR_STR_REQ") + ")";
		InfoMessage(ENT_OWNER, "Insufficient Strength for Armor", alrtStr);
		ApplyEffect(ENT_OWNER, "effects/effect_slow", 10.0f, "50%", self); // effects/speed 10.0 75% 0.5
	}

	// ext_activate_items
	void ArmorBase_OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		// dbg $currentscript ext_activate_items
		if (playerId !is EntityOf(ENT_OWNER))
			return;
		if (!(StatOf(ENT_OWNER, "strength") < Float(GetVar("ARMOR_STR_REQ"))))
			return;
		CallEventDelayed(0.1f, "failed_str_req_loop");
	}

	// game_takedamage
	// PARAM1=attacker PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type
	string ArmorBase_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		bool isSpider = false;
		float outDmg = 0.0f;
		string result = "";

		if (!IsWorn(ENT_ME))
			return result;

		float dmgAmt = damage;

		// should be in player_main, but not working here either
		if (Truthy(ScriptFlag(ENT_OWNER, "spider_resist", "type_exists")))
		{
			if (RaceOf(attacker) == "spider")
				isSpider = true;
			if (RaceOf(inflictor) == "spider")
				isSpider = true;
			string name = NameOf(attacker);
			name = ToLowerCase(name);
			if (Contains(name, "spider"))
				isSpider = true;
			if (Contains(ItemNameOf(attacker), "spid"))
				isSpider = true;
			if (isSpider)
			{
				string dmgRedAmtText = ScriptFlag(ENT_OWNER, "spider_resist", "type_first");
				int dmgRedAmt = Int(dmgRedAmtText);

				dmgAmt *= dmgRedAmt;

				SetDamageInfo("hit", 1);
				SetDamageInfo("dmg", dmgAmt);

				DebugPrint("spider_adjusted_damage " + Text(damage) + " to " + Text(outDmg) + " via " + dmgRedAmtText);
			}
		}

		if (Contains(damageType, "poison"))
		{
			// armor no longer protects against poison
			// but we are reducing all poison damage 50% to compensate
			outDmg = damage;
			dmgAmt *= 0.5f;
			SetDamageInfo("hit", 1);
			SetDamageInfo("dmg", dmgAmt);
			result = AppendResult(result, "0.5");
		}
		else
		{
			// basic protection
			if (!Truthy(ScriptVarOf(attacker, "NPC_IGNORES_ARMOR")))
			{
				dmgAmt *= DMG_REDUCT;
				SetDamageInfo("hit", 1);
				SetDamageInfo("dmg", dmgAmt);
				result = AppendResult(result, Text(DMG_REDUCT));
			}
		}
		return result;
	}

	// ext_hide_armor
	void ArmorBase_OnExtHideArmor()
	{
		SetModelBody(0, 0);
	}

	// ext_hide_armor_cl
	void ArmorBase_OnExtHideArmorCl()
	{
		SetModelBody(0, 0);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		ArmorBase_OnGameDeploy();
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		ArmorBase_OnExtActivateItems(playerId);
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBase_OnGameWear(race, gender, source);
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
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
	}

	void OnHideBodyParts(string bodyParts = "") { ArmorBase_OnHideBodyParts(bodyParts); } // hide_body_parts

	// barmor_effect_activate
	void OnBarmorEffectActivate()
	{
		ArmorBase_OnBarmorEffectActivate();
		ArmorBase_OnBarmorEffectActivate_2();
	}

	void OnShowBodyParts() { ArmorBase_OnShowBodyParts(); } // show_body_parts
	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { ArmorBase_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnBarmorUpdateVest(string race = "", string gender = "", string debug = "") { ArmorBase_OnBarmorUpdateVest(race, gender, debug); } // barmor_update_vest
	void OnExtSetArmor(int bodyGroup = 0, int bodyIndex = 0) { ArmorBase_OnExtSetArmor(bodyGroup, bodyIndex); } // ext_set_armor
	void OnBarmorEffectRemove() { ArmorBase_OnBarmorEffectRemove(); } // barmor_effect_remove
	void OnFailedStrReqLoop() { ArmorBase_OnFailedStrReqLoop(); } // failed_str_req_loop
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "") { return ArmorBase_OnGameTakedamage(attacker, inflictor, damage, damageType); } // game_takedamage
	void OnExtHideArmor() { ArmorBase_OnExtHideArmor(); } // ext_hide_armor
	void OnExtHideArmorCl() { ArmorBase_OnExtHideArmorCl(); } // ext_hide_armor_cl

	// This file's events and timers by their .script names
	bool ArmorBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "barmor_update_vest") { OnBarmorUpdateVest(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "ext_hide_armor") { OnExtHideArmor(); return true; }
		if (name == "ext_hide_armor_cl") { OnExtHideArmorCl(); return true; }
		if (name == "ext_set_armor") { OnExtSetArmor(Int(Param(params, 0)), Int(Param(params, 1))); return true; }
		if (name == "failed_str_req_loop") { OnFailedStrReqLoop(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "hide_body_parts") { OnHideBodyParts(Param(params, 0)); return true; }
		if (name == "show_body_parts") { OnShowBodyParts(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/armor_base"]
shared class ArmorBaseScript : BaseMiscitemScript, ArmorBase, BaseEffectArmor
{
	// Variables every script that includes this file declares
	string ARMOR_TEXT = "ARMOR_TEXT";
	string BARMOR_PROTECTION = "BARMOR_PROTECTION";
	string BARMOR_TYPE = "BARMOR_TYPE";

	// ---- Engine wiring (generated) ----

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
		return ArmorBase_DispatchEvent(name, params)
			|| BaseEffectArmor_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
