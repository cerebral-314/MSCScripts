#pragma context server

// Converted from items/blunt_gauntlets_leather.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/gauntlets_normal.as"

[script "items/blunt_gauntlets_leather"]
class BluntGauntletsLeather : GauntletsNormalScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsLeather()
	{
		MODEL_VIEW_IDX = 1;
		MODEL_BODY_OFS = "114";
		MELEE_DMG = 70;
		SOUND_HITWALL1 = "weapons/cbar_hitbod1.wav";
		SOUND_HITWALL2 = "weapons/cbar_hitbod2.wav";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		GauntletsNormal_OnWeaponSpawn(); // items/gauntlets_normal

		SetName("a set of|Leather Gauntlets");
		SetDescription("The inner padding allows you to punch slightly harder");
		SetWeight(3);
		SetValue(40);
		SetHand("both");
		SetHudSprite("hand", "118");
		SetHudSprite("trade", "118");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return GauntletsNormalScript::DispatchEvent(name, params);
	}
}
