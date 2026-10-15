#pragma context server

// Converted from sfor/wizard3.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/sfor/wizard_base.as"

[script "sfor/wizard3"]
class Wizard3 : WizardBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Wizard3()
	{
		SYMB_ITEM = "item_s3";
		SYMB_ITEM_NAME = "the third symbol";
		SAYTEXT_GOT_SYMBOL = "Remember, it will take the last of our energies to cast this spell, when the dark one comes we will not be here to assist you.";
		SYM_QUEST_NAME = "sym3";
	}

	// unnamed block (first think)
	void Wizard3_FirstThink()
	{
		SetName("Brother Tress");
		SetUniqueName("wizard3");
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		Wizard3_FirstThink();
	}
}
