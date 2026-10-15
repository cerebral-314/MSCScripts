#pragma context server

// Converted from tutorial/slavemaster.script by msc_transpiler.
// Slave Master. CMD

#include "runtime/ScriptEntity.as"
#include "converted/monsters/bandit.as"

[script "tutorial/slavemaster"]
class Slavemaster : BanditScript
{
	// Variables declared by included files, with the value they start with in this script
	Slavemaster()
	{
		WEAPON = "3";
	}

	// swordey
	void OnSwordey()
	{
		Bandit_OnSwordey(); // monsters/bandit
		if (Float(WEAPON) != 3.0f)
			return;
		SetName("Slave Master");
		ATTACK1_DAMAGE = "1";
		NPC_GIVE_EXP = 0.0f;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "swordey") { OnSwordey(); return true; }
		return BanditScript::DispatchEvent(name, params);
	}
}
