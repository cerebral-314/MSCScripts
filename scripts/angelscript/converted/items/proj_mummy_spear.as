#pragma context server

// Converted from items/proj_mummy_spear.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/proj_arrow_base.as"

[script "items/proj_mummy_spear"]
class ProjMummySpear : ProjArrowBaseScript
{
	// Constants
	string MODEL_BODY_OFS = "46";
	int ARROW_BODY_OFS = 46;
	string SOUND_BURN = "magic/ice_powerup.wav";
	bool ARROW_SOLIDIFY_ON_WALL = false;
	string ARROW_BREAK_CHANCE = "100%";
	string ITEM_NAME = "watermana";
	string PROJ_DAMAGESTAT = "spellcasting.ice";
	string PROJ_ANIM_IDLE = "idle_icebolt";
	int PROJ_AOE_RANGE = 30;
	float PROJ_AOE_FALLOFF = 0.0f;
	int PROJ_STICK_DURATION = 0;

	// Variables declared by included files, with the value they start with in this script
	ProjMummySpear()
	{
		MODEL_HANDS = "none";
		MODEL_WORLD = "weapons/projectiles.mdl";
		SOUND_HITWALL1 = "weapons/axemetal1.wav";
		SOUND_HITWALL2 = "weapons/axemetal1.wav";
		PROJ_DAMAGE = "50";
		PROJ_COLLIDEHITBOX = 32;
	}

	// arrow_spawn
	void OnArrowSpawn()
	{
		SetName("Nasty Spear");
		SetDescription("Its really nasty");
		SetWeight(0.1f);
		SetValue(0);
		SetGravity(0);
		SetGroupable(25);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("weapons/projectiles.mdl");
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
