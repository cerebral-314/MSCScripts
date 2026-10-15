#pragma context server

// Converted from chests/rand_dynamic2.script by msc_transpiler.
// Randomized individualized chest
// Provides random items/ammo/pots, the number items increases for each 500hp and number of players present, plus gold and random resup based on user's damage points and total players present. (Items/ammo range from good to epic.)
// - Items require >25% dmgpoint average (ie. if 4 players, must be among the top 3)
// - Takes addparam: set_num_chests. If used, chest will spawn another set of items for each subsequent chest of this type found.
// - Otherwise, provides one set of items per 500hp, quality/chance based on number of players.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/rand_dynamic2"]
class RandDynamic2 : BaseTreasurechestScript
{
	// Variables (an unset .script variable reads as its own name)
	float CHEST_TIER = 0.0f;
	bool CHEST_FOUND = false;

	// get_type
	// <chance1> <chance2> <chance3>
	string RandDynamic2_OnGetType(string chance1 = "", string chance2 = "", string chance3 = "")
	{
		string result = "";
		// returns 1-3 based on provided chances
		int roll = RandomInt(1, 100);
		if (roll <= Float(chance1))
		{
			result = AppendResult(result, "1");
			DebugPrint("get_type [ " + chance1 + " " + chance2 + " " + chance3 + " ] " + roll + " = 1");
			return result;
		}
		if (roll > Float(chance1) && roll <= Float(chance2))
		{
			DebugPrint("get_type [ " + chance1 + " " + chance2 + " " + chance3 + " ] " + roll + " = 2");
			result = AppendResult(result, "2");
			return result;
		}

		DebugPrint("get_type [ " + chance1 + " " + chance2 + " " + chance3 + " ] " + roll + " = 3");

		result = AppendResult(result, "3");
		return result;
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		float gmulti;
		int count;
		CHEST_TIER = Divide(MaxHealthOf(CHEST_USER), 500.0f);
		if (Truthy(Eval("game.central")))
		{
			float nplayers = ActivePlayerCount();
			if (nplayers > 1.0f)
			{
				nplayers *= 0.5f;
				CHEST_TIER += nplayers;
			}
		}

		DebugPrint("chest_additems chest_tier " + Text(CHEST_TIER));

		if (BC_USE_TRACKER)
		{
			if (!CHEST_FOUND)
			{
				CHEST_FOUND = true;
				LegacyCommand("add", "G_CHEST_TRACKER", 1);
			}
			gmulti = Float(GetVar("G_CHEST_TRACKER")) * 2.0f;
		}
		else
		{
			gmulti = CHEST_TIER;
		}
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= gmulti;
		if (Truthy(Eval("game.central")))
			goldToAdd *= ActivePlayerCount();
		DebugPrint("rand_self_adj gold: " + int(goldToAdd));
		OnAddGold(int(goldToAdd));

		if (BC_USE_TRACKER)
		{
			count = Int(GetVar("G_CHEST_TRACKER"));
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddItemsSelfAdj();
			}
		}
		else
		{
			count = int(CHEST_TIER);
			for (int i = 0; i < count; i++)
			{
				loopIteration = i;
				OnAddItemsSelfAdj();
			}
		}
	}

	// add_items_self_adj
	void OnAddItemsSelfAdj()
	{
		int type = 0;

		DebugPrint("add_items_self_adj " + Text(CHEST_TIER));

		if (CHEST_TIER < 2.0f)
		{
			type = Int(OnGetType("30", "30", "30"));
			if (type == 1)
				OnAddGreatItem();
			else if (type == 2)
				OnAddGoodPot();
			else if (type == 3)
				OnAddGoodArrows("100%");
		}
		if (CHEST_TIER >= 2.0f && CHEST_TIER < 3.0f)
		{
			type = Int(OnGetType("10", "25", "65"));
			if (type == 1)
				OnAddGoodPot();
			else if (type == 2)
				OnAddEpicItem();
			else if (type == 3)
				OnAddGreatArrows("100%");
		}
		if (CHEST_TIER >= 3.0f && CHEST_TIER < 4.0f)
		{
			type = Int(OnGetType("10", "35", "55"));
			if (type == 1)
				OnAddGreatPot();
			else if (type == 2)
				OnAddEpicItem();
			else if (type == 3)
				OnAddEpicArrows("100%");
		}
		if (CHEST_TIER >= 4.0f && CHEST_TIER < 5.0f)
		{
			type = Int(OnGetType("5", "40", "55"));
			if (type == 1)
				OnAddEpicPot();
			else if (type == 2)
				OnAddEpicItem();
			else if (type == 3)
				OnAddEpicArrows("100%");
		}
		if (CHEST_TIER >= 5.0f)
		{
			type = Int(OnGetType("10", "40", "50"));
			if (type == 1)
				OnAddEpicPot();
			else if (type == 2)
				OnAddEpicItem();
			else if (type == 3)
				OnAddEpicArrows("100%");
		}
	}

	string OnGetType(string chance1 = "", string chance2 = "", string chance3 = "") { return RandDynamic2_OnGetType(chance1, chance2, chance3); } // get_type

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "add_items_self_adj") { OnAddItemsSelfAdj(); return true; }
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "get_type") { Return(OnGetType(Param(params, 0), Param(params, 1), Param(params, 2))); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
