#pragma context server

// Converted from sfor/wizard2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/sfor/wizard_base.as"

[script "sfor/wizard2"]
class Wizard2 : WizardBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Wizard2()
	{
		SYMB_ITEM = "item_s2";
		SYMB_ITEM_NAME = "the second symbol";
		SAYTEXT_GOT_SYMBOL = "Thank you, there may yet be hope to end this.";
		SYM_QUEST_NAME = "sym2";
	}

	// unnamed block (first think)
	void Wizard2_FirstThink()
	{
		SetName("Brother Duae");
		SetUniqueName("wizard2");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wizard2_FirstThink();
	}
}
