#pragma context server

// Converted from items/blunt_gauntlets_serpant.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/blunt_gauntlets_fire.as"

[script "items/blunt_gauntlets_serpant"]
class BluntGauntletsSerpant : BluntGauntletsFireScript
{
	// Variables declared by included files, with the value they start with in this script
	BluntGauntletsSerpant()
	{
		MODEL_VIEW_IDX = 4;
		MODEL_BODY_OFS = "112";
		MELEE_DMG = 125;
		MELEE_DMG_TYPE = "poison";
		MELEE_ACCURACY = "85%";
		SOUND_HITWALL1 = "weapons/cbar_hitbod1.wav";
		SOUND_HITWALL2 = "bullchicken/bc_bite2.wav";
		SOUND_BITE = "bullchicken/bc_bite2.wav";
		DOT_EFFECT = "effects/dot_poison";
	}

	// weapon_spawn
	void OnWeaponSpawn()
	{
		BaseMelee_OnWeaponSpawn(); // items/base_melee
		BluntGauntletsFire_OnWeaponSpawn(); // items/blunt_gauntlets_fire

		SetName("Serpent Gauntlets");
		SetDescription("These magical gauntlets have a bite");
		SetWeight(3);
		SetValue(2000);
		SetHand("both");
		SetHudSprite("hand", "117");
		SetHudSprite("trade", "117");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "weapon_spawn") { OnWeaponSpawn(); return true; }
		return BluntGauntletsFireScript::DispatchEvent(name, params);
	}
}
