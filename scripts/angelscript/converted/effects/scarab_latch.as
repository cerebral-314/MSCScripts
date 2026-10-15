#pragma context server

// Converted from effects/scarab_latch.script by msc_transpiler.
// chew chew for scarabs (stackable dot that scarabs can apply when latched)

#include "runtime/ScriptEntity.as"
#include "converted/effects/base_dot.as"

[script "effects/scarab_latch"]
class ScarabLatch : BaseDotScript
{
	// Variables declared by included files, with the value they start with in this script
	ScarabLatch()
	{
		EFFECT_ID = "DOT_scarab";
		DOT_TYPE = "magic_effect";
		DOT_IM_AFFECTED = "A scarab latches to you, sapping your life away!";
		DOT_IM_RESIST = "Youre not supposed to resist this.";
		DOT_HE_IMMUNE = "Youre not supposed to resist this.";
	}

	// dot_effect
	void OnDotEffect()
	{
		BaseDot_OnDotEffect(); // effects/base_dot

		if (!IsAlive(DOT_ATTACKER))
			RemoveScript();
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "dot_effect") { OnDotEffect(); return true; }
		return BaseDotScript::DispatchEvent(name, params);
	}
}
