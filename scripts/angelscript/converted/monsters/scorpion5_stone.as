#pragma context server

// Converted from monsters/scorpion5_stone.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/scorpion5.as"

[script "monsters/scorpion5_stone"]
class Scorpion5Stone : Scorpion5Script
{
	// Variables declared by included files, with the value they start with in this script
	Scorpion5Stone()
	{
		IS_UNHOLY = true;
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void Scorpion5Stone_FirstThink()
	{
		IS_UNHOLY = true;
	}

	// scorpion_spawn
	void OnScorpionSpawn()
	{
		SetHealth(1000);
		// ov 360
		SetWidth(40);
		SetHeight(50);
		SetRace("demon");
		SetName("Gigantic Stone Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 300.0f;

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);

		SetModel("monsters/scorp5.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");

		SetProp(ENT_ME, "skin", 3);

		SetAnimFrameRate(0.5f);
		SetAnimMoveSpeed(0.25f);
		BASE_FRAMERATE = "0.5";
		BASE_MOVESPEED = 0.25f;

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, SOUND_IDLE1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion5Stone_FirstThink();
		Scorpion5_FirstThink();
		BaseNpcAttack_FirstThink();
		BaseNpc_FirstThink();
		MonstersExternals_FirstThink();
		BaseMonsterShared_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "scorpion_spawn") { OnScorpionSpawn(); return true; }
		return Scorpion5Script::DispatchEvent(name, params);
	}
}
