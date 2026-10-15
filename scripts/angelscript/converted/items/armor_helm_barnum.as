#pragma context server

// Converted from items/armor_helm_barnum.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base_helmet.as"

[script "items/armor_helm_barnum"]
class ArmorHelmBarnum : ArmorBaseHelmetScript
{
	// Variables declared by included files, with the value they start with in this script
	ArmorHelmBarnum()
	{
		ARMOR_MODEL = "armor/p_helmets.mdl";
		ARMOR_BODY = 6;
		ARMOR_TEXT = "You equip the Helm of Darkness.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "60%";
		STUN_PROTECTION = 0.75f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBaseHelmet_OnGameSpawn(playerRace, playerGender); // items/armor_base_helmet

		SetName("Helm of Darkness");
		SetDescription("This helm is enchanted with vile magics.");
		SetWeight(5);
		SetWearable(1, "head");
		SetValue(1150);

		SetHudSprite("trade", "helm3");
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseMiscitem_OnGameDeploy(); // items/base_miscitem
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
		CallEventDelayed(0.1f, "armor_spec_effect");
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBaseHelmet_OnGameWear(race, gender, source); // items/armor_base_helmet
		CallEventDelayed(0.1f, "armor_spec_effect");
	}

	// armor_spec_effect
	// armor_base
	void OnArmorSpecEffect()
	{
		if (!IsWorn(ENT_ME))
			OnRemoveBonus();

		if (!IsWorn(ENT_ME))
			return;
		if (!IsAlive(ENT_OWNER))
			return;
		CallEventDelayed(0.1f, "grant_bonus");
	}

	// grant_bonus
	void OnGrantBonus()
	{
		CallExternal(ENT_OWNER, "ext_set_dmg_multi", "poison", "helm1", 1.5f);
		CallExternal(ENT_OWNER, "ext_set_dmg_multi", "acid", "helm2", 1.5f);
		PlayerMessageGreen(ENT_OWNER, "Your affliction power has increased.");
	}

	// remove_bonus
	void OnRemoveBonus()
	{
		CallExternal(ENT_OWNER, "ext_set_dmg_multi", "poison", "helm1", 0);
		CallExternal(ENT_OWNER, "ext_set_dmg_multi", "acid", "helm2", 0);
		PlayerMessageDark(ENT_OWNER, "Your affliction power has returned to normal.");
	}

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
		if (name == "armor_spec_effect") { OnArmorSpecEffect(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		if (name == "grant_bonus") { OnGrantBonus(); return true; }
		if (name == "remove_bonus") { OnRemoveBonus(); return true; }
		return ArmorBaseHelmetScript::DispatchEvent(name, params);
	}
}
