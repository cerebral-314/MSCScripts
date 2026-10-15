#pragma context server

// Converted from items/bows_longbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_longbow"]
class BowsLongbow : BowsBaseScript
{
	// Constants
	int RANGED_FORCE = 2100;
	float RANGED_ENERGY = 4.0f;
	string RANGED_ACCURACY = "3;0";
	float RANGED_POSTFIRE_DELAY = 0.3f;

	// Variables declared by included files, with the value they start with in this script
	BowsLongbow()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_WEAR = "weapons/p_weapons2.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "longbow";
		ANIM_PREFIX = "longbow";
		MODEL_BODY_OFS = "44";
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Wooden Long bow");
		SetDescription("A long bow, elegantly carved and made for range");
		SetWeight(70);
		SetValue(50);
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
