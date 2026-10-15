#pragma context server

// Converted from items/blunt_gauntlets.script by msc_transpiler.
// To help packs sort out inventory, moving gauntlets to blunt_
// - Should still raise Melee XP though (cross fingers)

#include "runtime/ScriptEntity.as"
#include "converted/items/gauntlets_normal.as"

[script "items/blunt_gauntlets"]
class BluntGauntlets : GauntletsNormalScript
{
	// Constants
	string BASE_LEVEL_REQ = "6";
}
