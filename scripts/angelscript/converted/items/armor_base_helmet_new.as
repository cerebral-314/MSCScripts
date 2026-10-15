#pragma context server

// Converted from items/armor_base_helmet_new.script by msc_transpiler.
// NO LONGER IN USE
// - Experimental changes integrated into armor_base

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"
#include "converted/items/base_effect_armor.as"

[script "items/armor_base_helmet_new"]
class ArmorBaseHelmetNew : BaseItemScript, BaseEffectArmor
{
	// Constants
	bool IS_HELM = true;
	bool HELM_HIDES_HEAD = false;

	// Variables (an unset .script variable reads as its own name)
	string CUR_STUN_PROT = "CUR_STUN_PROT";

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item

		SetWearable(1, "head");
		SetModelBody(0, 0);
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		SetModel("ARMOR_MODEL");
		SetModelBody(0, 0);

		if (!HELM_HIDES_HEAD)
			return;
		CallExternal(ENT_OWNER, "ext_setheadtype", 1);
	}

	// display_stun_info
	void OnDisplayStunInfo()
	{
		string str = Text(Float(CUR_STUN_PROT) * 100.0f);
		str = Text(int(100.0f - Float(str))) + "%";

		if (Float(CUR_STUN_PROT) > 0.0f)
			PlayerMessageGreen(ENT_OWNER, "Your stun resistance is now " + str);
		if (Float(CUR_STUN_PROT) == 0.0f)
			PlayerMessageDark(ENT_OWNER, "You now have no stun resistance");
	}

	// barmor_effect_activate
	void OnBarmorEffectActivate()
	{
		if (HELM_HIDES_HEAD)
			CallExternal(ENT_OWNER, "ext_setheadtype", 1);
		float oldProt = DamageTakenOf(ENT_OWNER, "stun");
		CallExternal(ENT_OWNER, "set_stun_prot", "STUN_PROTECTION");
		CUR_STUN_PROT = "STUN_PROTECTION";
		if (oldProt != 0.0f)
			CallEventDelayed(0.1f, "display_stun_info");
	}

	// barmor_effect_remove
	void OnBarmorEffectRemove()
	{
		if (HELM_HIDES_HEAD)
			CallExternal(ENT_OWNER, "ext_setheadtype", 0);
		float oldProt = DamageTakenOf(ENT_OWNER, "stun");
		CallExternal(ENT_OWNER, "set_stun_prot", 1);
		float stunProt = DamageTakenOf(ENT_OWNER, "stun");
		CUR_STUN_PROT = "1";
		if (oldProt != stunProt)
			CallEventDelayed(0.1f, "display_stun_info");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseItem_OnGameDeploy(); // items/base_item
		BaseEffectArmor_OnGameDeploy(); // items/base_effect_armor
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
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

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "barmor_effect_activate") { OnBarmorEffectActivate(); return true; }
		if (name == "barmor_effect_remove") { OnBarmorEffectRemove(); return true; }
		if (name == "display_stun_info") { OnDisplayStunInfo(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_wear") { OnGameWear(Param(params, 0), Param(params, 1), Param(params, 2)); return true; }
		return BaseEffectArmor_DispatchEvent(name, params)
			|| BaseItemScript::DispatchEvent(name, params);
	}
}
