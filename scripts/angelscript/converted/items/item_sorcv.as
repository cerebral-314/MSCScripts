#pragma context server

// Converted from items/item_sorcv.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/items/base_medal.as"

[script "items/item_sorcv"]
class ItemSorcv : BaseMedalScript
{
	// Variables declared by included files, with the value they start with in this script
	ItemSorcv()
	{
		MEDAL_FX_SCRIPT = "items/item_sorcv_cl";
	}

	// medal_spawn
	void OnMedalSpawn()
	{
		SetName("Shadahar Medal");
		SetDescription("Achievement Medal for Shadahar Village");
	}

	// medal_activate
	void OnMedalActivate()
	{
		string outMsg = "OUT_MSG";
		string ownerMedals = GetQuestData(ENT_OWNER, "a");
		float ownerAchieveLevel = Float(GetToken(ownerMedals, 0));
		ownerAchieveLevel -= 1.0f;

		if (ownerAchieveLevel == 0.0f)
			outMsg = "Has Achieved Tin Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 1.0f)
			outMsg = "Has Achieved Bronze Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 2.0f)
			outMsg = "Has Achieved Silver Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 3.0f)
			outMsg = "Has Achieved Gold Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 4.0f)
			outMsg = "Has Achieved Platinum Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 5.0f)
			outMsg = "Has Achieved Diamond Status in the Shadahar Village Challenge";
		if (ownerAchieveLevel == 6.0f)
			outMsg = "Has Achieved LORELDIAN Status in the Shadahar Village Challenge";

		InfoMessage("all", NameOf(ENT_OWNER), outMsg);

		Vector3 spawnPoint = OriginOf(ENT_OWNER);
		Vector3 myAngles = AnglesOf(ENT_OWNER);
		float myYaw = myAngles.y;
		spawnPoint += RelativePosition(Vector3(0, myYaw, 0), Vector3(0, 128, 0));
		spawnPoint.z = GroundHeight(spawnPoint);
		spawnPoint.z += 128.0f;

		ClientEvent("new", "all", MEDAL_FX_SCRIPT, spawnPoint, ownerAchieveLevel, myYaw, 20.0f);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("medals.spr");
		Precache("misc/p_misc.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "medal_activate") { OnMedalActivate(); return true; }
		if (name == "medal_spawn") { OnMedalSpawn(); return true; }
		return BaseMedalScript::DispatchEvent(name, params);
	}
}
