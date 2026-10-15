#pragma context server

// Converted from chests/orcfor_gobtown2.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/orcfor_base.as"

[script "chests/orcfor_gobtown2"]
class OrcforGobtown2 : OrcforBaseScript
{
	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		OrcforBase_OnChestAdditems(); // chests/orcfor_base

		OnAddGold(100.0f * Float(GetVar("G_GAVE_ARTI1")));

		if (Float(GetVar("G_GAVE_ARTI1")) == 1.0f)
		{
			OnAddNoobItem();
			OnAddGoodItem();
			OnAddGoodArrows();
		}

		if (Float(GetVar("G_GAVE_ARTI1")) == 2.0f)
		{
			OnAddGreatItem();
			OnAddGreatItem();
			OnAddGoodArrows();
		}

		if (Float(GetVar("G_GAVE_ARTI1")) == 3.0f)
		{
			OnAddGreatItem();
			OnAddEpicItem();
			OnAddGoodArrows();
		}

		if (Float(GetVar("G_GAVE_ARTI1")) == 4.0f)
		{
			OnAddGreatItem();
			OnAddEpicItem();
			OnAddEpicArrows();
		}

		if (Float(GetVar("G_GAVE_ARTI1")) == 5.0f)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicArrows();
		}

		if (Float(GetVar("G_GAVE_ARTI1")) > 5.0f)
		{
			OnAddEpicItem();
			OnAddEpicArrows();
			OnAddEpicArrows();
			OnAddEpicArrows();
		}
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		return OrcforBaseScript::DispatchEvent(name, params);
	}
}
