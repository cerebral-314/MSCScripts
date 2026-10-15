#pragma context server

// Converted from items/swords_testsub.script by msc_transpiler.
// Shortsword

#include "runtime/ScriptEntity.as"
#include "converted/items/swords_base_onehanded.as"

[script "items/swords_testsub"]
class SwordsTestsub : SwordsBaseOnehandedScript
{
	// Constants
	string MODEL_BLOCK = "armor/shields/p_shields.mdl";
	string SOUND_SHOUT = "SOUND_SHOUT";

	// Variables (an unset .script variable reads as its own name)
	float V_MODEL_OFS = 0.0f;
	int V_MODEL_OFS_MAX = 0;
	string VSCRIPT_ID = "VSCRIPT_ID";

	// Variables declared by included files, with the value they start with in this script
	SwordsTestsub()
	{
		MODEL_VIEW = "weapons/swords/smallswords_rview.mdl";
		MODEL_HANDS = "weapons/swords/p_swords.mdl";
		MODEL_WORLD = "weapons/swords/p_swords.mdl";
		SOUND_SWIPE = "weapons/swingsmall.wav";
		MODEL_BODY_OFS = "28";
		ANIM_PREFIX = "shortsword";
		MELEE_RANGE = "60";
		MELEE_DMG_DELAY = 0.6f;
		MELEE_ATK_DURATION = 1.1f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 140;
		MELEE_DMG_RANGE = 110;
		MELEE_DMG_TYPE = "slash";
		MELEE_ACCURACY = "70%";
		MELEE_STAT = "swordsmanship";
		MELEE_ALIGN_BASE = "4,-6";
		MELEE_ALIGN_TIP = "0,6";
		MELEE_PARRY_CHANCE = "5%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee

		SetName("Shortsword Modelbody");
		SetDescription("A short one-handed Sword");
		SetWeight(30);
		SetValue(15);
		SetHudSprite("trade", "shortsword");
		SetModelBody(0, 2);

		V_MODEL_OFS = 0.0f;
		V_MODEL_OFS_MAX = 2;
	}

	// special_01_start
	void OnSpecial01Start()
	{
		BaseMelee_OnSpecial01Start(); // items/base_melee

		V_MODEL_OFS += 1.0f;
		if (V_MODEL_OFS > V_MODEL_OFS_MAX)
			V_MODEL_OFS = 0.0f;
		SetProp(ENT_ME, "modelindex", "MODEL_OFS");

		if (VSCRIPT_ID == "VSCRIPT_ID")
		{
			// //dbg starting event
			ClientEvent("new", EntityOf(ENT_OWNER), "items/swords_testsub", V_MODEL_OFS);
			VSCRIPT_ID = LastClientScriptId();
		}
		else
		{
			ClientEvent("update", ENT_OWNER, VSCRIPT_ID, "update_model", V_MODEL_OFS);
		}
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/swords/p_swords.mdl");
		Precache("weapons/swords/smallswords_rview.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "special_01_start") { OnSpecial01Start(); return true; }
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return SwordsBaseOnehandedScript::DispatchEvent(name, params);
	}
}
