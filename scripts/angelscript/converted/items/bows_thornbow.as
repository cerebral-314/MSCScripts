#pragma context server

// Converted from items/bows_thornbow.script by msc_transpiler.
// Thothie - Thornbow, from swiftbow

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_thornbow"]
class BowsThornbow : BowsBaseScript
{
	// Constants
	string BASE_LEVEL_REQ = "20";
	int MODEL_VIEW_IDX = 6;
	int RANGED_FORCE = 1700;
	float RANGED_ENERGY = 2.0f;
	string RANGED_ACCURACY = "1;0";
	float RANGED_POSTFIRE_DELAY = 0.1f;
	float RANGED_DMG_DELAY = 0.1f;
	float RANGED_DMG_MULTI = 1.75f;

	// Variables declared by included files, with the value they start with in this script
	BowsThornbow()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons3.mdl";
		MODEL_WORLD = "weapons/p_weapons3.mdl";
		MODEL_WEAR = "weapons/p_weapons3.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "standard";
		MODEL_BODY_OFS = "0";
		RANGED_ATK_DURATION = "0.1";
		RANGED_PULLTIME = 0.4f;
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Thornbow");
		SetDescription("Augments arrows with magical thorns");
		SetWeight(100);
		SetValue(1500);
		SetHudSprite("trade", "123");
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/p_weapons3.mdl");
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
