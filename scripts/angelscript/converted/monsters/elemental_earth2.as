#pragma context server

// Converted from monsters/elemental_earth2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/elemental_earth1.as"

[script "monsters/elemental_earth2"]
class ElementalEarth2 : ElementalEarth1Script
{
	// Variables declared by included files, with the value they start with in this script
	ElementalEarth2()
	{
		ELEMENTAL_LEVEL = 2;
		NUM_LONGS = 3;
		ELEMENTAL_EXP = 1000;
		HITCHANCE_SWIPE = 90;
		SHIELD_DURATION = 20.0f;
		ELEMENTAL_MOVERANGE = 256;
	}

	// elemental_spawn
	void OnElementalSpawn()
	{
		SetName("Greater Earth Elemental");
		SetModel("monsters/elementals_greater.mdl");
		SetHealth(2500);
		SetWidth(32);
		SetHeight(48);
		SetRace("demon");
		SetBlood("none");
		IS_BLOODLESS = true;
		IMMUNE_VAMPIRE = true;
		IS_UNHOLY = true;
		SetDamageTaken("all", 0.25f);
		SetDamageTaken("holy", 3);
		// takedmg lightning 0.0
		SetDamageTaken("poison", 0);
		SetRoam(true);
		SetIdleAnim(ANIM_IDLE);
		SetMoveAnim(ANIM_WALK);
		SetHearingSensitivity(5);
		SetModelBody(0, 2); // maybe different on greater (elder model)
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("rockgibs.mdl");
		Precache("rain_ripple.spr");
		Precache("debris/zap8.wav");
		Precache("debris/zap3.wav");
		Precache("debris/zap4.wav");
		Precache("weapons/debris1.wav");
		Precache("magic/volcano_start.wav");
		Precache("magic/volcano_loop.wav");
		Precache("monsters/elementals_greater.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "elemental_spawn") { OnElementalSpawn(); return true; }
		return ElementalEarth1Script::DispatchEvent(name, params);
	}
}
