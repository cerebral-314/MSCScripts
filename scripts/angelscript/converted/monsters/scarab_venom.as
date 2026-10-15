#pragma context server

// Converted from monsters/scarab_venom.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/scarab_fire.as"

[script "monsters/scarab_venom"]
class ScarabVenom : ScarabFireScript
{
	// Variables declared by included files, with the value they start with in this script
	ScarabVenom()
	{
		EFFECT_SCRIPT = "effects/dot_poison";
		EFFECT_DURATION = "10.0";
	}

	// scarab_spawn
	void OnScarabSpawn()
	{
		SetName("Jade Scarab");
		SetModel("monsters/scarab.mdl");
		SetHealth(150);
		SetWidth(16);
		SetHeight(16);
		SetRoam(true);
		SetRace("vermin");
		SetHearingSensitivity(8);
		// takedmg fire 0.0
		SetDamageTaken("holy", 0);
		SetBlood("green");
		SetMoveAnim(ANIM_MOVE);
		SetIdleAnim(ANIM_IDLE);
		SetBoundingBox("npcsize"); // hoping will help with "reach" issues
		SetSolid("none");
		SetProp(ENT_ME, "skin", 1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/spider/spideridle.wav");
		Precache("monsters/scarab.mdl");
		CallEventDelayed(0.5f, "ScarabFire_Timer");
		CallEventDelayed(FREQ_CHITTER, "ScarabFire_Timer2");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "scarab_spawn") { OnScarabSpawn(); return true; }
		return ScarabFireScript::DispatchEvent(name, params);
	}
}
