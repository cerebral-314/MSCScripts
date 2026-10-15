#pragma context server

// Converted from monsters/scorpion7_fire.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/monsters/scorpion6.as"

[script "monsters/scorpion7_fire"]
class Scorpion7Fire : Scorpion6Script
{
	// Constants
	string NPC_BASE_EXP = "2000";

	// Variables declared by included files, with the value they start with in this script
	Scorpion7Fire()
	{
		IS_UNHOLY = true;
		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "weapons/dagger/daggermetal2.wav";
		DOT_EFFECT = "effects/dot_fire";
		BURST_SCRIPT = "effects/sfx_fire_burst";
		DOT_EFFECT_BURST_TYPE = "effect";
		DOT_DURATION = 5.0f;
		DOT_DMG = 100.0f;
		DMG_BURST = 300.0f;
		ATTACK_STINGRANGE = 180;
		ANIM_IDLE = "idle_b";
	}

	// unnamed block (first think)
	void Scorpion7Fire_FirstThink()
	{
		IS_UNHOLY = true;

		SOUND_STRUCK1 = "weapons/axemetal1.wav";
		SOUND_STRUCK2 = "weapons/axemetal2.wav";
		SOUND_STRUCK3 = "weapons/dagger/daggermetal2.wav";
		SOUND_PAIN = "monsters/spider/spiderhiss.wav";
		SOUND_IDLE1 = "monsters/spider/spideridle.wav";

		ANIM_IDLE = "idle_b";
		ANIM_RUN = "run";
		ANIM_WALK = "walk";
		ANIM_ATTACK = "attackb";
		ANIM_DEATH = "die";
	}

	// scorpion_spawn
	void OnScorpionSpawn()
	{
		SetName("Blistering Scorpion");
		SetHealth(5000);
		SetModel("monsters/scorp7.mdl");
		SetProp(ENT_ME, "skin", 4);
		SetIdleAnim("idle_a");
		SetMoveAnim("walk");

		SetWidth(196);
		SetHeight(196);
		SetBoundingBox("npcsize");

		SetHearingSensitivity(10);
		SetRoam(true);
		SetRace("demon");

		SetDamageTaken("all", 0.5f);
		SetDamageTaken("poison", 0);
		SetDamageTaken("fire", 0);
		SetDamageTaken("cold", 0.5f);
		SetDamageTaken("holy", 1.5f);

		CallEventDelayed(FREQ_JUMP, "do_jump");

		PlayAnim("once", "idle_a");

		// setanim.framerate 0.5
		// setanim.movespeed 0.25
		// setvard BASE_FRAMERATE 0.5
		// setvard BASE_MOVESPEED 0.25
		// make absolutely sure SOUND_IDLE1 is loading
		PlayRandomSound(2, SOUND_IDLE1);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("monsters/scorp7.mdl");
		CallEventDelayed(10.0f, "Scorpion6_Timer");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Scorpion7Fire_FirstThink();
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
