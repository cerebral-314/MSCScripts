#pragma context server

// Converted from chests/quiver_of_random_lesser.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_quiver_of.as"

[script "chests/quiver_of_random_lesser"]
class QuiverOfRandomLesser : BaseQuiverOfScript
{
	// Variables declared by included files, with the value they start with in this script
	QuiverOfRandomLesser()
	{
		BQ_QUIVER_TYPE = "proj_arrow_silvertipped";
		BQ_BUNDLE_SIZE = "60";
	}

	// unnamed block (first think)
	void QuiverOfRandomLesser_FirstThink()
	{
		BQ_QUIVER_TYPE = "proj_arrow_silvertipped";
		BQ_BUNDLE_SIZE = "60";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseQuiverOf_OnGameSpawn(playerRace, playerGender); // chests/base_quiver_of
		SetName("Quiver of Arrows");
		CallEventDelayed(0.1f, "pick_random_type");
	}

	// pick_random_type
	void OnPickRandomType()
	{
		string arrowList;

		// addstoreitem STORENAME ITEMNAME QUANITY SELL_PRICE_ADJUSTMENT(integer%) BUYPRICE_ADJUSTMENT(multiplier%) #IN_BUNDLE
		int arrowQuality = RandomInt(1, 3);
		if (arrowQuality < 3)
			arrowList = GetVar("G_NOOB_ARROWS");
		else
			arrowList = GetVar("G_GOOD_ARROWS");

		float nArrows = GetTokenCount(arrowList) - 1.0f;
		int rndArrow = RandomInt(0, int(nArrows));
		BQ_QUIVER_TYPE = GetToken(arrowList, rndArrow);
	}

	// ---- Engine wiring (generated) ----

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		QuiverOfRandomLesser_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "pick_random_type") { OnPickRandomType(); return true; }
		return BaseQuiverOfScript::DispatchEvent(name, params);
	}
}
