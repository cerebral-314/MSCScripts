#pragma context server

// Converted from items/armor_rehab.script by msc_transpiler.
// https://www.youtube.com/watch?v=UzdHSqkzgdM

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"

[script "items/armor_rehab"]
class ArmorRehab : ArmorBaseScript
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest.mdl";
	int ARMOR_BODY = 5;
	string BARMOR_PROTECTION_AREA = "chest";
	string BARMOR_REPLACE_BODYPARTS = "chest";
	float FREQ_CHANGE = 90.0f;
	int NEW_ARMOR_OFS = 19;
	string ELM_NAME = "rehab";
	float ELM_AMT = 100.0f;

	// Variables (an unset .script variable reads as its own name)
	float RND_ELE = 0.0f;
	bool DID_INIT = false;
	string ELM_TYPE = "ELM_TYPE";
	bool IS_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ArmorRehab()
	{
		ARMOR_TEXT = "You work your way into the visual nightmare.";
		BARMOR_TYPE = "leather";
		BARMOR_PROTECTION = "40%";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Chromatic Vest");
		SetDescription("This magic vest makes your eyes swim");
		SetWeight(12);
		SetWearable(1, "chest;arms");
		SetValue(3000);

		SetHudSprite("trade", "12");
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
		OnElmRemoveEffect();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		ArmorBase_OnGameDeploy(); // items/armor_base
		OnElmRemoveEffect();
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		ArmorBase_OnExtActivateItems(playerId); // items/armor_base
		bool exitSub = false;
		// dbg $currentscript ext_activate_items
		if (playerId !is EntityOf(ENT_OWNER))
			return;

		if (!IsWorn(ENT_ME))
			exitSub = true;
		if (exitSub)
			return;

		RND_ELE = RandomInt(1, 4);

		CallEventDelayed(0.1f, "elm_activate_effect");
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBase_OnGameWear(race, gender, source); // items/armor_base
		CallEventDelayed(0.1f, "elm_activate_effect");
	}

	// game_putinpack
	// track last element used/time left player or game_master side to avoid sploitz
	// shifts random element every 10 mins
	// scratch that, Rehab wanted every 90 seconds - going with 120, likely not worth reconnecting for
	// we'll have to do this manually, copying from base_elemental_resist
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
		OnElmRemoveEffect();
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
		OnElmRemoveEffect();
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
		OnElmRemoveEffect();
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
		OnElmRemoveEffect();
	}

	// elm_get_resist
	void OnElmGetResist()
	{
		if (!DID_INIT)
		{
			DID_INIT = true;
			RND_ELE = RandomInt(0, 3);
		}

		if (!IS_ACTIVE)
		{
			RND_ELE += 1.0f;
			if (RND_ELE > 4.0f)
				RND_ELE = 1.0f;
			if (RND_ELE == 1.0f)
				ELM_TYPE = "fire";
			if (RND_ELE == 2.0f)
				ELM_TYPE = "lightning";
			if (RND_ELE == 3.0f)
				ELM_TYPE = "cold";
			if (RND_ELE == 4.0f)
				ELM_TYPE = "poison";

			string iconName = "hud/status/alpha_" + ELM_TYPE + "_immune";

			AddStatusIcon(ENT_OWNER, iconName, "rehab", FREQ_CHANGE);
			ClientEvent("new", "all", "items/armor_rehab_cl", IndexOf(ENT_OWNER), RND_ELE);
			PlayerMessageGreen(ENT_OWNER, "Chromatic vest has chosen to protect you from " + ELM_TYPE);
			ServerPlaySound(2, 10, "magic/energy1.wav");
		}
	}

	// elm_activate_effect
	void OnElmActivateEffect()
	{
		OnElmGetResist();
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, ELM_TYPE, ELM_AMT, ScriptNameOf(ENT_ME));
		if (IS_ACTIVE)
			return;
		IS_ACTIVE = true;
		CallEventDelayed(FREQ_CHANGE, "change_element");
	}

	// elm_remove_effect
	void OnElmRemoveEffect()
	{
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, "remove", 0, ScriptNameOf(ENT_ME));
		if (IS_ACTIVE) // no workie
			LegacyCommand("hud.killimgicon", ENT_OWNER, "rehab");
	}

	// change_element
	void OnChangeElement()
	{
		if (!IS_ACTIVE)
			return;
		IS_ACTIVE = false;
		if (!IsWorn(ENT_ME))
			return;
		OnElmRemoveEffect();
		OnElmActivateEffect();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnFreqChange() {} // FREQ_CHANGE

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("armor/p_armorvest_new.mdl");
		Precache("magic/energy1.wav");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "change_element") { OnChangeElement(); return true; }
		if (name == "elm_activate_effect") { OnElmActivateEffect(); return true; }
		if (name == "elm_get_resist") { OnElmGetResist(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "ext_activate_items") { OnExtActivateItems(EntityParam(params, 0)); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drop") { OnGameDrop(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_putinpack") { OnGamePutinpack(); return true; }
		if (name == "game_remove") { OnGameRemove(); return true; }
		if (name == "game_sheath") { OnGameSheath(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		return ArmorBaseScript::DispatchEvent(name, params);
	}
}
