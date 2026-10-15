#pragma context server

// Converted from items/blunt_test.script by msc_transpiler.
// Snakestaff by Thothie from Hammer
// - Todos:
// - Secondary attack summons snake but poisons owner
// - Convert Model

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_base_onehanded.as"

[script "items/blunt_test"]
class BluntTest : BluntBaseOnehandedScript
{
	// Constants
	string MODEL_PLAYER = "weapons/staff/snake_staff_player.mdl";
	int SECONDARY_DMG = 0;
	string SOUND_SUMMON = "magic/spawn.wav";
	string SOUND_BITE = "bullchicken/bc_bite2.wav";
	string SOUND_POISON = "monsters/snakeman/sm_alert1.wav";

	// Variables declared by included files, with the value they start with in this script
	BluntTest()
	{
		MODEL_VIEW = "viewmodels/gearshield_rview.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_BODY_OFS = "58";
		ANIM_PREFIX = "khopesh";
		MELEE_STAT = "spellcasting.affliction";
		MELEE_DMG_TYPE = "poison";
		ANIM_IDLE1 = "0";
		ANIM_ATTACK1 = "1";
		ANIM_ATTACK3 = "5";
		ANIM_SHEATH = 4;
		MELEE_RANGE = "100";
		MELEE_DMG_DELAY = 0.3f;
		MELEE_ATK_DURATION = 0.6f;
		MELEE_ENERGY = 0.3f;
		MELEE_DMG = 30;
		MELEE_DMG_RANGE = 60;
		MELEE_ACCURACY = "65%";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntBaseOnehanded_OnWeaponSpawn(); // items/blunt_base_onehanded

		SetName("Test Item");
		SetDescription("Test stuff");
		SetWeight(10);
		SetValue(500);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "package");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/gearshield_rview.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntBaseOnehandedScript::DispatchEvent(name, params);
	}
}
