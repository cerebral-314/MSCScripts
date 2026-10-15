#pragma context server

// Converted from sfor/wizard5.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/sfor/wizard_base.as"

[script "sfor/wizard5"]
class Wizard5 : WizardBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Wizard5()
	{
		SYMB_ITEM = "item_s5";
		SYMB_ITEM_NAME = "the fifth symbol";
		SAYTEXT_GOT_SYMBOL = "It is good you arrived when you did, I've my doubts we could hold this gate shut much longer.";
		SYM_QUEST_NAME = "sym5";
	}

	// unnamed block (first think)
	void Wizard5_FirstThink()
	{
		SetName("Brother Quinas");
		SetUniqueName("wizard5");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wizard5_FirstThink();
	}
}
