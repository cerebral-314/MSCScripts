#pragma context server

// Converted from items/bows_swiftbow.script by msc_transpiler.
// Thothie - This thing is crazy inaccurate, dunno why

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_swiftbow"]
class BowsSwiftbow : BowsBaseScript
{
	// Constants
	int MODEL_VIEW_IDX = 5;
	int RANGED_FORCE = 1500;
	float RANGED_ENERGY = 2.0f;
	string RANGED_ACCURACY = "1;1";
	float RANGED_POSTFIRE_DELAY = 0.1f;
	float RANGED_DMG_DELAY = 0.1f;

	// Variables declared by included files, with the value they start with in this script
	BowsSwiftbow()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_WEAR = "weapons/p_weapons2.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "longbow";
		MODEL_BODY_OFS = "44";
		RANGED_ATK_DURATION = "0.1";
		RANGED_PULLTIME = 0.4f;
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Elven Longbow");
		SetDescription("One of the finest elven longbows made out of the Sylven wood");
		SetWeight(60);
		SetValue(100);
		SetHudSprite("trade", ITEM_NAME);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons2.mdl");
		Precache("viewmodels/v_bows.mdl");
		CallEventDelayed(3.35f, "BowsBase_Timer");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bow_spawn") { OnBowSpawn(); return true; }
		return BowsBaseScript::DispatchEvent(name, params);
	}
}
