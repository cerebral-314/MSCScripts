#pragma context server

// Converted from other/hp_trigger_200.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/other/hp_trigger_base.as"

[script "other/hp_trigger_200"]
class HpTrigger200 : HpTriggerBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	HpTrigger200()
	{
		TRIGGER_REQ = 200;
		EVENT_NAME = "found_200";
	}
}
