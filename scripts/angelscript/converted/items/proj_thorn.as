#pragma context server

// Converted from items/proj_thorn.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_thorn"]
class ProjThorn : ProjArrowBaseScript
{
	// Constants
	string PROJ_ANIM_IDLE = "idle_standard";
	int PROJ_STICK_DURATION = 0;
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string MODEL_BODY_OFS = "24";
	int ARROW_BODY_OFS = 24;
	string ROJ_DAMAGETYPE = "pierce";

	// Variables declared by included files, with the value they start with in this script
	ProjThorn()
	{
		MODEL_WORLD = "weapons/projectiles.mdl";
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("large thorn");
		SetDescription("a large thorn");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		LegacyCommand("useable", 0);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
		Precache("weapons/bows/arrows.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "arrow_spawn") { OnArrowSpawn(); return true; }
		return ProjArrowBaseScript::DispatchEvent(name, params);
	}
}
