#pragma context server

// Converted from chests/gold_1000.script by msc_transpiler.
// Mega gold award

#include "runtime/ScriptEntity.as"
#include "converted/chests/bag_o_gold_base.as"

[script "chests/gold_1000"]
class Gold1000 : BagOGoldBaseScript
{
	// Variables declared by included files, with the value they start with in this script
	Gold1000()
	{
		GOLD_AMT = "1000";
	}
}
