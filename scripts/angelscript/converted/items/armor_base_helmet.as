#pragma context server

// Converted from items/armor_base_helmet.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_miscitem.as"
#include "converted/items/base_effect_armor.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class ArmorBaseHelmet
{
	// Constants
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "none";
	bool IS_HELM = true;
	bool HELM_HIDES_HEAD = false;

	// Variables (an unset .script variable reads as its own name)
	bool HELM_EFFECT_ACTIVE = false;
	string CUR_STUN_PROT = "CUR_STUN_PROT";

	// game_spawn
	void ArmorBaseHelmet_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetWearable(1, "head");
		SetModelBody(0, ARMOR_BODY);
	}

	// game_wear
	void ArmorBaseHelmet_OnGameWear(string race = "", string gender = "", string source = "")
	{
		// dbg game_wear PARAM1 PARAM2
		OnGameShow(race, gender, source);
	}

	// game_show
	void ArmorBaseHelmet_OnGameShow(string raceType = "", string genderType = "", string debugFlag = "")
	{
		string ownerRace;
		string ownerGender;
		SetModel(ARMOR_MODEL);
		SetModelBody(0, ARMOR_BODY);

		ownerRace = RaceOf(ENT_OWNER);
		ownerGender = GenderOf(ENT_OWNER);

		ownerRace = ToLowerCase(ownerRace);
		ownerGender = ToLowerCase(ownerGender);
		if (ownerRace == "0") // char_menu, most likely
			ownerRace = raceType;
		if (ownerGender == "0") // char_menu, most likely
			ownerGender = genderType;

		DebugPrint("game_show race " + ownerRace + " gend " + ownerGender + " dbg " + debugFlag);

		if (ownerGender == "female" && ownerRace == "human")
		{
			DebugPrint("*** Adjusted for Fembot");

			if (GetVar("ARMOR_BODY_HUMAN_FEMALE") != "ARMOR_BODY_HUMAN_FEMALE")
			{
				SetModelBody(0, Int(GetVar("ARMOR_BODY_HUMAN_FEMALE")));
			}
			else
			{
				float femBody = ARMOR_BODY + 14.0f;
				SetModelBody(0, int(femBody));
			}
		}

		if (!HELM_HIDES_HEAD)
			return;
		CallExternal(ENT_OWNER, "ext_setheadtype", 1);
	}

	// display_stun_info
	void ArmorBaseHelmet_OnDisplayStunInfo()
	{
		string str = Text(Float(CUR_STUN_PROT) * 100.0f);
		str = Text(int(100.0f - Float(str))) + "%";

		if (Float(CUR_STUN_PROT) < 1.0f)
			PlayerMessageGreen(ENT_OWNER, "Your stun resistance is now " + str);
		if (Float(CUR_STUN_PROT) == 1.0f)
			PlayerMessageDark(ENT_OWNER, "You now have no stun resistance");
	}

	// barmor_effect_activate
	void ArmorBaseHelmet_OnBarmorEffectActivate()
	{
		bool sameProtect = false;
		if (HELM_EFFECT_ACTIVE)
			return;
		HELM_EFFECT_ACTIVE = true;
		if (HELM_HIDES_HEAD)
			CallExternal(ENT_OWNER, "ext_setheadtype", 1);
		CallExternal(ENT_OWNER, "ext_register_helm", self);
		float oldProt = DamageTakenOf(ENT_OWNER, "stun");
		int potCheck = Int(ScriptVarOf(ENT_OWNER, "PLR_LESSER_LEADFOOT"));
		if (potCheck != 0)
		{
			CUR_STUN_PROT = ScriptVarOf(ENT_OWNER, "PLR_LESSER_LEADFOOT_STUN");
			sameProtect = true;
			PlayerMessageGreen(ENT_OWNER, "Your stun resistance remains " + Text(STUN_PROTECTION) + " due to Lesser Leadfoot Potion");
		}
		if (oldProt != STUN_PROTECTION)
		{
			CallExternal(ENT_OWNER, "set_stun_prot", STUN_PROTECTION);
			CallEventDelayed(0.1f, "display_stun_info");
		}
		if (!sameProtect)
			CUR_STUN_PROT = Text(STUN_PROTECTION);
	}

	// barmor_effect_remove
	void ArmorBaseHelmet_OnBarmorEffectRemove()
	{
		if (!HELM_EFFECT_ACTIVE)
			return;
		HELM_EFFECT_ACTIVE = false;
		if (HELM_HIDES_HEAD)
			CallExternal(ENT_OWNER, "ext_setheadtype", 0);
		CallExternal(EntityOf(ENT_OWNER), "ext_register_helm", "none");
		int potCheck = Int(ScriptVarOf(ENT_OWNER, "PLR_LESSER_LEADFOOT"));
		if (potCheck != 0)
		{
			string stunResist = ScriptVarOf(ENT_OWNER, "PLR_LESSER_LEADFOOT_STUN");
			PlayerMessageGreen(ENT_OWNER, "Your stun resistance remains " + stunResist + " due to Lesser Leadfoot Potion");
		}
		if (potCheck != 0)
			return;
		float oldProt = DamageTakenOf(ENT_OWNER, "stun");
		CallExternal(ENT_OWNER, "set_stun_prot", 1);
		float stunProt = DamageTakenOf(ENT_OWNER, "stun");
		CUR_STUN_PROT = "1";
		if (oldProt != stunProt)
			CallEventDelayed(0.1f, "display_stun_info");
	}

	// ext_setrender
	// debug
	void ArmorBaseHelmet_OnExtSetrender(string renderMode = "")
	{
		DebugPrint("got ext_setrender " + renderMode);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender);
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
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBaseHelmet_OnGameWear(race, gender, source);
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

	void OnGameShow(string raceType = "", string genderType = "", string debugFlag = "") { ArmorBaseHelmet_OnGameShow(raceType, genderType, debugFlag); } // game_show
	void OnDisplayStunInfo() { ArmorBaseHelmet_OnDisplayStunInfo(); } // display_stun_info
	void OnBarmorEffectActivate() { ArmorBaseHelmet_OnBarmorEffectActivate(); } // barmor_effect_activate
	void OnBarmorEffectRemove() { ArmorBaseHelmet_OnBarmorEffectRemove(); } // barmor_effect_remove
	void OnExtSetrender(string renderMode = "") { ArmorBaseHelmet_OnExtSetrender(renderMode); } // ext_setrender

	// This file's events and timers by their .script names
	bool ArmorBaseHelmet_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "display_stun_info") { OnDisplayStunInfo(); return true; }
		if (name == "ext_setrender") { OnExtSetrender(Param(params, 0)); return true; }
		if (name == "game_show") { OnGameShow(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/armor_base_helmet"]
shared class ArmorBaseHelmetScript : BaseMiscitemScript, ArmorBaseHelmet, BaseEffectArmor
{
	// Variables every script that includes this file declares
	int ARMOR_BODY = 0;
	string ARMOR_MODEL = "ARMOR_MODEL";
	string ARMOR_TEXT = "ARMOR_TEXT";
	string BARMOR_PROTECTION = "BARMOR_PROTECTION";
	string BARMOR_TYPE = "BARMOR_TYPE";
	float STUN_PROTECTION = 0.0f;

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return ArmorBaseHelmet_DispatchEvent(name, params)
			|| BaseEffectArmor_DispatchEvent(name, params)
			|| BaseMiscitemScript::DispatchEvent(name, params);
	}
}
