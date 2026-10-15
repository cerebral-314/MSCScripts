#pragma context server

// Converted from calruin/riddler1.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/base_riddler.as"

[script "calruin/riddler1"]
class Riddler1 : BaseRiddlerScript
{
	// Variables declared by included files, with the value they start with in this script
	Riddler1()
	{
		FAILED_MSG = "...And here I thought *MY* death was disturbing.";
		RIDDLE_ANSWER = "dark";
	}

	// riddle_question
	void OnRiddleQuestion()
	{
		SayText("It cannot be seen, cannot be heard, cannot be felt, cannot be smelt...");
		CallEventDelayed(1.0f, "riddle_question2");
	}

	// riddle_question2
	void OnRiddleQuestion2()
	{
		SayText("It lies behind stars and under hills and empty holes it fills...");
		CallEventDelayed(1.0f, "riddle_question3");
	}

	// riddle_question3
	void OnRiddleQuestion3()
	{
		SayText("It comes first and follows after. It ends life, kills laughter.");
	}

	// riddle_correct
	void OnRiddleCorrect()
	{
		SayText("You may pass...");
		UseTrigger("spikedoor1");
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
		if (name == "riddle_question3") { OnRiddleQuestion3(); return true; }
		return BaseRiddlerScript::DispatchEvent(name, params);
	}
}
