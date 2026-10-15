#pragma context server

// Converted from chests/rmines_boss.script by msc_transpiler.

#include "runtime/ScriptEntity.as"
#include "converted/chests/base_treasurechest.as"

[script "chests/rmines_boss"]
class RminesBoss : BaseTreasurechestScript
{
	// Variables declared by included files, with the value they start with in this script
	RminesBoss()
	{
		ANIM_IDLE = "base";
		ANIM_CLOSE = "base";
		ANIM_OPEN = "base";
		SOUND_OPEN = "debris/flesh5.wav";
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseTreasurechest_OnGameSpawn(playerRace, playerGender); // chests/base_treasurechest
		SetName("Abyssal Nest");
		SetModel("tiod/ornest.mdl");
		SetProp(ENT_ME, "scale", 3.0f);
		SetWidth(96);
		SetHeight(48);

		OnTcAddArtifact("polearms_sl", 5.0f);
	}

	// chest_additems
	void OnChestAdditems()
	{
		BaseTreasurechest_OnChestAdditems(); // chests/base_treasurechest
		float goldToAdd = Float(ScriptVarOf(CHEST_USER, "PLR_TOTAL_DMG"));
		goldToAdd *= ActivePlayerCount();
		goldToAdd *= 10.0f;
		OnAddGold(int(goldToAdd));

		AddStoreItem(STORENAME, "proj_bolt_poison", 25, 0, 0, 25);

		OnAddGreatItem();
		OnAddEpicItem();
		OnAddGreatArrows();
		OnAddEpicArrows();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddGreatArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicItem();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();
		if (RandomInt(1, 10) == 1)
			OnAddEpicArrows();

		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "mana_paura", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "mana_faura", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "mana_fbrand", 1, 0);
		if (RandomInt(1, 30) == 1)
			AddStoreItem(STORENAME, "mana_font", 1, 0);

		if (RandomInt(1, 5) == 1)
			AddStoreItem(STORENAME, "proj_bolt_poison", 75, 0, 0, 25);

		OnOfferFelewynSymbol(20);
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/treasure.mdl");
		Precache("tiod/ornest.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "chest_additems") { OnChestAdditems(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		return BaseTreasurechestScript::DispatchEvent(name, params);
	}
}
