#pragma context server

// Converted from calruin/cavebat.script by msc_transpiler.
// Bat
// Moved ATTACK_HITCHANCE to bat_spawn, since setvard would be overridden upon initialization. -greatguys1 SEP2021

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bat.as"

[script "calruin/cavebat"]
class Cavebat : MonstersBatScript
{
	// Variables declared by included files, with the value they start with in this script
	Cavebat()
	{
		ATTACK_DAMAGE = "$randf(5,15)";
	}

	// bat_spawn
	void OnBatSpawn()
	{
		MonstersBat_OnBatSpawn(); // monsters/bat

		SetName("Cave bat");
		NPC_GIVE_EXP = 25.0f;
		ATTACK_HITCHANCE = "85%";
		SetMoveSpeed(2);
		SetWidth(16);
		SetHeight(16);
		SetHearingSensitivity(3.5f);
		SetVolume(5);

		SetModel("monsters/bat.mdl");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "bat_spawn") { OnBatSpawn(); return true; }
		return MonstersBatScript::DispatchEvent(name, params);
	}
}
