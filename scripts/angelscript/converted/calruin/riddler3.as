#pragma context server

// Converted from calruin/riddler3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/calruin/base_riddler.as"

[script "calruin/riddler3"]
class Riddler3 : BaseRiddlerScript
{
	// Variables declared by included files, with the value they start with in this script
	Riddler3()
	{
		FAILED_MSG = "Your link, strong as the others it is not, goodbye.";
		RIDDLE_ANSWER = "time";
	}

	// riddle_question
	void OnRiddleQuestion()
	{
		SayText("This thing, all things devours: the birds, the beasts, the trees, the flowers...");
		CallEventDelayed(1.0f, "riddle_question2");
	}

	// riddle_question2
	void OnRiddleQuestion2()
	{
		SayText("It gnaws iron and bites steel. It grinds hard stones to meal...");
		CallEventDelayed(1.0f, "riddle_question3");
	}

	// riddle_question3
	void OnRiddleQuestion3()
	{
		SayText("It slays kings, and ruins town, and beats high mountain down!");
	}

	// riddle_correct
	void OnRiddleCorrect()
	{
		SayText("You are man... He is not man... For you he waits... For you...");
		PlaySound(Int(GetVar("CHAN_VOICE")), 10, "nihilanth/nil_man_notman.wav");
		UseTrigger("calriandoor");
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
