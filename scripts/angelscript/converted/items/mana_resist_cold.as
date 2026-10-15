#pragma context server

// Converted from items/mana_resist_cold.script by msc_transpiler.
// Thothie potion of Speed (from Potion of Forgetfulness)

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"

[script "items/mana_resist_cold"]
class ManaResistCold : BaseItemScript
{
	// Constants
	string ANIM_IDLE = "0";
	string ANIM_DRINK = "1";
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string MODEL_VIEW = "viewmodels/v_misc.mdl";
	int ITEM_MODEL_VIEW_IDX = 2;
	string SOUND_DRINK = "items/drink.wav";
	string MODEL_BODY_OFS = "39";
	string ANIM_PREFIX = "mana";

	// Variables (an unset .script variable reads as its own name)
	string DRINK_TYPE = "givemana";
	float RESTORE_PERCENT = 0.9f;
	int DRINK_EFFECTAMT = 300;
	int DRINK_AMOUNT = 1;
	float DRINK_GULP_DELAY = 3.0f;
	float DRINK_TIME = 3.0f;

	// unnamed block (first think)
	void ManaResistCold_FirstThink()
	{
		DRINK_TYPE = "givemana";
		RESTORE_PERCENT = 0.9f;
		DRINK_EFFECTAMT = 300;
		DRINK_AMOUNT = 1;
		DRINK_GULP_DELAY = 3.0f;
		DRINK_TIME = 3.0f;
	}

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item

		SetHand("any");
		SetAnimExtension("holditem");

		OnDrinkSpawn();
		LegacyCommand("registerdrink");
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras

		float submodel = Float(MODEL_BODY_OFS);
		submodel += 2.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// drink_spawn
	void OnDrinkSpawn()
	{
		SetName("Resist Cold Potion");
		SetDescription("Helps resist the cold arctic chill.");
		SetWeight(1);
		SetValue(100);
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "gpot");
	}

	// game_start_drink
	void OnGameStartDrink()
	{
		PlayViewAnim(Int(ANIM_DRINK));

		OnDrinkStart();
	}

	// game_drink
	void OnGameDrink()
	{
		CallExternal(EntityOf(ENT_OWNER), "ext_register_element", "coldp", "cold", 50);

		OwnerMessage("You are now more resistant to cold attacks.");

		OnDrinkNow();

		ServerPlaySound(2, 10, ScriptVarOf(ENT_OWNER, "PLR_SOUND_BREATHFAST2"));
	}

	// game_drink_done
	void OnGameDrinkDone()
	{
		PlayViewAnim(Int(ANIM_IDLE));
	}

	// game_deploy
	void OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += ItemHandIndex();
		SetModelBody(0, int(submodel));

		OnDrinkDeploy();
	}

	// ---- Engine wiring (generated) ----

	// Events whose included handlers run differently here than in the included files
	void OnDrinkDeploy() {} // drink_deploy
	void OnDrinkNow() {} // drink_now
	void OnDrinkStart() {} // drink_start

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		ManaResistCold_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drink") { OnGameDrink(); return true; }
		if (name == "game_drink_done") { OnGameDrinkDone(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_start_drink") { OnGameStartDrink(); return true; }
		return BaseItemScript::DispatchEvent(name, params);
	}
}
