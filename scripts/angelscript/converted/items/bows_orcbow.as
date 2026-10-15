#pragma context server

// Converted from items/bows_orcbow.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/bows_base.as"

[script "items/bows_orcbow"]
class BowsOrcbow : BowsBaseScript
{
	// Constants
	int MODEL_VIEW_IDX = 1;
	int RANGED_FORCE = 900;
	float RANGED_ENERGY = 0.3f;
	string RANGED_ACCURACY = "6;3";
	float RANGED_POSTFIRE_DELAY = 0.3f;

	// Variables declared by included files, with the value they start with in this script
	BowsOrcbow()
	{
		MODEL_VIEW = "viewmodels/v_bows.mdl";
		MODEL_HANDS = "weapons/p_weapons2.mdl";
		MODEL_WORLD = "weapons/p_weapons2.mdl";
		MODEL_WEAR = "weapons/p_weapons2.mdl";
		SOUND_SHOOT = "weapons/bow/bow.wav";
		ITEM_NAME = "orcbow";
		ANIM_PREFIX = "orcbow";
		MODEL_BODY_OFS = "40";
	}

	// bow_spawn
	void OnBowSpawn()
	{
		SetName("Orcish bow");
		SetDescription("A primitive bow used by the Orc race");
		SetWeight(30);
		SetValue(25);
		SetHudSprite("trade", "69");
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
