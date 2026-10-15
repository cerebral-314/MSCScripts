#pragma context server

// Converted from calruin/riddler2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/base_riddler.as"

[script "calruin/riddler2"]
class Riddler2 : BaseRiddlerScript
{
	// Variables declared by included files, with the value they start with in this script
	Riddler2()
	{
		FAILED_MSG = "So very disapointing...";
		RIDDLE_ANSWER = "river";
	}

	// riddle_question
	void OnRiddleQuestion()
	{
		SayText("What can run, yet never walks, has a mouth, yet never talks...");
		CallEventDelayed(0.0f, "1");
	}

	// riddle_question2
	void OnRiddleQuestion2()
	{
		SayText("...has a head, but never weeps, has a bed, but never sleeps?");
	}

	// riddle_correct
	void OnRiddleCorrect()
	{
		SayText("Smarter than I had thought. Or are you...?");
		UseTrigger("spikedoor2");
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "riddle_correct") { OnRiddleCorrect(); return true; }
		if (name == "riddle_question") { OnRiddleQuestion(); return true; }
		if (name == "riddle_question2") { OnRiddleQuestion2(); return true; }
		return BaseRiddlerScript::DispatchEvent(name, params);
	}
}
