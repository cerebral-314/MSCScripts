#pragma context server

// Converted from other/hp_trigger_1000.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/hp_trigger_base.as"

[script "other/hp_trigger_1000"]
class HpTrigger1000 : HpTriggerBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	HpTrigger1000()
	{
		TRIGGER_RANGE = 512;
		TRIGGER_REQ = 1000;
		EVENT_NAME = "found_1000";
	}
}
