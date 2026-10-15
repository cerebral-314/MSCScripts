#pragma context server

// Converted from sfor/wizard4.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/sfor/wizard_base.as"

[script "sfor/wizard4"]
class Wizard4 : WizardBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Wizard4()
	{
		SYMB_ITEM = "item_s4";
		SYMB_ITEM_NAME = "the forth symbol";
		SAYTEXT_GOT_SYMBOL = "When the beast comes, aim for the horn atop his head.";
		SYM_QUEST_NAME = "sym4";
	}

	// unnamed block (first think)
	void Wizard4_FirstThink()
	{
		SetName("Brother Quatra");
		SetUniqueName("wizard4");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wizard4_FirstThink();
	}
}
