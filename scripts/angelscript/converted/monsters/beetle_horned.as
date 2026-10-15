#pragma context server

// Converted from monsters/beetle_horned.script by msc_transpiler.
// weekest of the beetles

#include "runtime/ScriptEntity.as"
#include "converted/monsters/beetle_base.as"

[script "monsters/beetle_horned"]
class BeetleHorned : BeetleBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	BeetleHorned()
	{
		BBET_GORE_PUSH_STR = 300;
		BBET_FAKE_DEATH = 1;
		DMG_SLASH = 20.0f;
		DMG_GORE = 30;
		DMG_LEAP = 50;
	}

	// unnamed block (first think)
	void BeetleHorned_FirstThink()
	{
		NPC_GIVE_EXP = 300.0f;
	}

	// game_precache
	void OnGamePrecache()
	{
	}

	// beetle_spawn
	void OnBeetleSpawn()
	{
		SetName("Horned Beetle");
		SetHealth(500);
		SetModelBody(0, 0); // 0=Horned 1=Venom 2=Fire
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/beetles.mdl");
		Precache("monsters/beetle/charge_loop1.wav");
		Precache("monsters/beetle/fly1.wav");
		CallEventDelayed(Float(Eval("$randf(8.0,15.0)")), "BeetleBase_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BeetleHorned_FirstThink();
		BeetleBase_FirstThink();
		BeetleBase_FirstThink2();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseNpcAttackNew_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "beetle_spawn") { OnBeetleSpawn(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		return BeetleBaseScript::DispatchEvent(name, params);
	}
}
