#pragma context server

// Converted from items/armor_venom.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/armor_base.as"
#include "converted/items/base_elemental_resist.as"

[script "items/armor_venom"]
class ArmorVenom : ArmorBaseScript, BaseElementalResist
{
	// Constants
	string ARMOR_MODEL = "armor/p_armorvest2.mdl";
	int ARMOR_GROUP = 4;
	int ARMOR_BODY = 5;
	string BARMOR_PROTECTION_AREA = "chest;arms;legs";
	string BARMOR_REPLACE_BODYPARTS = "BARMOR_REPLACE_BODYPARTS";
	string ELM_NAME = "varmr";
	string ELM_TYPE = "poison";
	float ELM_AMT = 50.0f;
	int ARMOR_STR_REQ = 25;
	int NEW_ARMOR_OFS = 15;

	// Variables (an unset .script variable reads as its own name)
	bool PHOENIX_ACTIVE = false;

	// Variables declared by included files, with the value they start with in this script
	ArmorVenom()
	{
		ARMOR_TEXT = "You assemble the envenomed plate mail.";
		BARMOR_TYPE = "platemail";
		BARMOR_PROTECTION = "50%";
	}

	// game_takedamage
	// //PARAM1=attacker  PARAM2=inflictor? PARAM3=dmg PARAM4=dmg_type
	string ArmorVenom_OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";

		// dbg temp dmg_type PARAM4
		if (!IsWorn(ENT_ME))
			return result;
		if (RandomInt(1, 4) != 1)
			return result;

		Vector3 ownerPos = OriginOf(ENT_OWNER);
		Vector3 atkrPos = OriginOf(attacker);

		float minDist = Float(GetProp(attacker, "moveprox")); // approx monster width
		minDist += 32.0f; // adj for player size

		if (!(Distance(ownerPos, atkrPos) <= minDist))
			return result;

		float poisonDmg = SkillOf(ENT_OWNER, "spellcasting.affliction") * 0.5f;
		ApplyEffect(attacker, "effects/dot_poison", 10.0f, @EntityOf(ENT_OWNER), poisonDmg, "spellcasting.affliction");
		PlaySound(0, 10, "bullchicken/bc_bite2.wav"); // monsters/snake_idle1.wav

		OwnerMessage("Your Venom Plate poisons " + FullNameOf(attacker));
		return result;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseMiscitem_OnGameSpawn(playerRace, playerGender); // items/base_miscitem
		ArmorBase_OnGameSpawn(playerRace, playerGender); // items/armor_base

		SetName("Envenomed Plate");
		SetDescription("Hefty Plate mail enchanted with poison.");
		SetWeight(180);
		SetWearable(1, "chest;arms;legs");
		SetValue(600);

		SetHudSprite("trade", "152");
	}

	// game_takedamage
	string OnGameTakedamage(CBaseEntity@ attacker = null, CBaseEntity@ inflictor = null, float damage = 0.0f, string damageType = "")
	{
		string result = "";
		result = AppendResult(result, ArmorBase_OnGameTakedamage(attacker, inflictor, damage, damageType));
		result = AppendResult(result, ArmorVenom_OnGameTakedamage(attacker, inflictor, damage, damageType));
		return result;
	}

	// elm_activate_effect
	void OnElmActivateEffect()
	{
		float ownerSkill = SkillOf(ENT_OWNER, "spellcasting.affliction");
		if (ownerSkill < 20.0f)
			PlayerMessageDark(ENT_OWNER, "You lack the affliction skill to activate this armor's magic.");
		if (!(ownerSkill >= 20.0f))
			return;
		PHOENIX_ACTIVE = true;
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, ELM_TYPE, ELM_AMT);
	}

	// elm_remove_effect
	void OnElmRemoveEffect()
	{
		if (!PHOENIX_ACTIVE)
			return;
		PHOENIX_ACTIVE = false;
		if (!(SkillOf(ENT_OWNER, "spellcasting.affliction") >= 20.0f))
			return;
		PHOENIX_ACTIVE = false;
		CallExternal(ENT_OWNER, "ext_register_element", ELM_NAME, "remove");
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseMiscitem_OnGameFall(); // items/base_miscitem
		BaseEffectArmor_OnGameFall(); // items/base_effect_armor
		BaseElementalResist_OnGameFall(); // items/base_elemental_resist
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
		BaseElementalResist_OnGameDeploy(); // items/base_elemental_resist
	}

	// ext_activate_items
	void OnExtActivateItems(CBaseEntity@ playerId = null)
	{
		BaseItemExtras_OnExtActivateItems(playerId); // items/base_item_extras
		BaseEffectArmor_OnExtActivateItems(playerId); // items/base_effect_armor
		ArmorBase_OnExtActivateItems(playerId); // items/armor_base
		BaseElementalResist_OnExtActivateItems(playerId); // items/base_elemental_resist
	}

	// game_wear
	void OnGameWear(string race = "", string gender = "", string source = "")
	{
		BaseItemExtras_OnGameWear(race, gender, source); // items/base_item_extras
		BaseEffectArmor_OnGameWear(race, gender, source); // items/base_effect_armor
		ArmorBase_OnGameWear(race, gender, source); // items/armor_base
		BaseElementalResist_OnGameWear(race, gender, source); // items/base_elemental_resist
	}

	// game_putinpack
	void OnGamePutinpack()
	{
		BaseItemExtras_OnGamePutinpack(); // items/base_item_extras
		BaseEffectArmor_OnGamePutinpack(); // items/base_effect_armor
		BaseElementalResist_OnGamePutinpack(); // items/base_elemental_resist
	}

	// game_remove
	void OnGameRemove()
	{
		BaseItemExtras_OnGameRemove(); // items/base_item_extras
		BaseEffectArmor_OnGameRemove(); // items/base_effect_armor
		BaseElementalResist_OnGameRemove(); // items/base_elemental_resist
	}

	// game_sheath
	void OnGameSheath()
	{
		BaseItemExtras_OnGameSheath(); // items/base_item_extras
		BaseEffectArmor_OnGameSheath(); // items/base_effect_armor
		BaseElementalResist_OnGameSheath(); // items/base_elemental_resist
	}

	// game_drop
	void OnGameDrop()
	{
		BaseItemExtras_OnGameDrop(); // items/base_item_extras
		BaseMiscitem_OnGameDrop(); // items/base_miscitem
		BaseEffectArmor_OnGameDrop(); // items/base_effect_armor
		BaseElementalResist_OnGameDrop(); // items/base_elemental_resist
	}

	// game_deleted
	void OnGameDeleted()
	{
		BaseItemExtras_OnGameDeleted(); // items/base_item_extras
		BaseElementalResist_OnGameDeleted(); // items/base_elemental_resist
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseItemExtras_FirstThink();
		BaseElementalResist_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "elm_activate_effect") { OnElmActivateEffect(); return true; }
		if (name == "elm_remove_effect") { OnElmRemoveEffect(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_takedamage") { Return(OnGameTakedamage(EntityParam(params, 0), EntityParam(params, 1), Float(Param(params, 2)), Param(params, 3))); return true; }
		return BaseElementalResist_DispatchEvent(name, params)
			|| ArmorBaseScript::DispatchEvent(name, params);
	}
}
