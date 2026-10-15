#pragma context server

// Converted from monsters/scorpion6_stone.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/scorpion6.as"

[script "monsters/scorpion6_stone"]
class Scorpion6Stone : Scorpion6Script
{
	// Variables declared by included files, with the value they start with in this script
	Scorpion6Stone()
	{
		IS_UNHOLY = true;
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
	}

	// unnamed block (first think)
	void Scorpion6Stone_FirstThink()
	{
		IS_UNHOLY = true;

		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "debris/concrete1.wav";
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";
	}

	// scorpion_spawn
	void OnScorpionSpawn()
	{
		SetHealth(5000);
		// ov 360
		SetWidth(196);
		SetHeight(196);
		SetBoundingBox("npcsize");
		SetRace("demon");
		SetName("Obsidian Scorpion");
		SetRoam(true);
		SetHearingSensitivity(3);
		NPC_GIVE_EXP = 1000.0f;

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("holy", 1.5f);

		CallEventDelayed(FREQ_JUMP, "do_jump");

		SetModel("monsters/scorp6.mdl");
		SetModelBody(1, 0);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");
		SetProp(ENT_ME, "skin", 2);

		// setanim.framerate 0.5
		SetAnimMoveSpeed(0.5f);
		// setvard BASE_FRAMERATE 0.5
		BASE_MOVESPEED = 0.5f;

		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, SOUND_IDLE1);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion6Stone_FirstThink();
		Scorpion6_FirstThink();
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
		if (name == "scorpion_spawn") { OnScorpionSpawn(); return true; }
		return Scorpion6Script::DispatchEvent(name, params);
	}
}
