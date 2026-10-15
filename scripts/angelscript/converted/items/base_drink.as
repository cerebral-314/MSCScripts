#pragma context server

// Converted from items/base_drink.script by msc_transpiler.
// Base drink
// REQ:
// ANIM_DRINK
// SOUND_DRINK

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseDrink
{
	// Constants
	string MODEL_BODY_OFS = "21";
	string ANIM_PREFIX = "mhealth";
	string DRINK_WORD = "swig";
	string DONE_PHRASE = "You drink the last drop of the";

	// game_spawn
	void BaseDrink_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetHand("any");
		SetAnimExtension("holditem");

		OnDrinkSpawn();
		LegacyCommand("registerdrink");
	}

	// game_start_drink
	void BaseDrink_OnGameStartDrink()
	{
		PlayViewAnim(Int(ANIM_DRINK));

		OnDrinkStart();
	}

	// game_drink
	void BaseDrink_OnGameDrink()
	{
		float outAmt = 0.0f;

		if (DRINK_TYPE == "givehealth")
		{
			outAmt = MaxHealthOf(ENT_OWNER) * Float(GetVar("RESTORE_PERCENT"));
			if (outAmt < Float(GetVar("DRINK_EFFECTAMT")))
				outAmt = Float(GetVar("DRINK_EFFECTAMT"));
			// dbg Healing OUT_AMT Percent RESTORE_PERCENT
			GiveHealth(ENT_OWNER, outAmt);
		}
		if (DRINK_TYPE == "givemana")
		{
			outAmt = MaxManaOf(ENT_OWNER) * Float(GetVar("RESTORE_PERCENT"));
			if (outAmt < Float(GetVar("DRINK_EFFECTAMT")))
				outAmt = Float(GetVar("DRINK_EFFECTAMT"));
			// dbg Restoring OUT_AMT Percent RESTORE_PERCENT
			GiveMana(ENT_OWNER, outAmt);
		}
		if (GetVar("SOUND_DRINK") != "SOUND_DRINK")
			PlaySound(Int(Eval("game.sound.voice")), Eval("game.sound.maxvol"), GetVar("SOUND_DRINK"));
		if (DRINK_TYPE == "effect")
			OnDrinkEffect();

		OnDrinkNow();
	}

	// game_drink_done
	void BaseDrink_OnGameDrinkDone()
	{
		PlayViewAnim(Int(ANIM_IDLE));
	}

	// game_deploy
	void BaseDrink_OnGameDeploy()
	{
		if (Float(GetProp(ENT_ME, "drink_amt")) == 0.0f)
			OnDrinkRemove();

		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel += ItemHandIndex();
		SetModelBody(0, int(submodel));

		OnDrinkDeploy();
	}

	// game_fall
	void BaseDrink_OnGameFall()
	{
		if (Float(GetProp(ENT_ME, "drink_amt")) == 0.0f)
			OnDrinkRemove();

		float submodel = Float(MODEL_BODY_OFS);
		submodel += 2.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// drink_now
	void BaseDrink_OnDrinkNow()
	{
		CallEventDelayed(0.25f, "report_drink_amt");
	}

	// report_drink_amt
	void BaseDrink_OnReportDrinkAmt()
	{
		// Thothie attempting to fix the "undrinkable pot" bug
		int drinkRemain = Int(GetProp(ENT_ME, "drink_amt"));
		// subtract DRINK_REMAIN 1
		string myName = NameOf(ENT_ME);
		myName = ToLowerCase(myName);
		string myNameP = myName + ".";
		if (drinkRemain > 1)
		{
			string drinkWord = DRINK_WORD + "s";
			OwnerMessage("This " + myName + " has " + drinkRemain + " " + drinkWord + " left.");
		}
		if (drinkRemain == 1)
			OwnerMessage("This " + myName + " has one " + DRINK_WORD + " left.");
		if (drinkRemain == 0)
		{
			PlayerMessageDark(ENT_OWNER, DONE_PHRASE + " " + myNameP);
			CallEventDelayed(0.1f, "drink_remove");
		}
	}

	// drink_remove
	void BaseDrink_OnDrinkRemove()
	{
		DeleteEntity(ENT_ME);
	}

	// drink_deploy
	// drinks override standard item idle, so we require more vespine gas
	void BaseDrink_OnDrinkDeploy()
	{
		if (!(ITEM_MODEL_VIEW_IDX > 0))
			return;
		CallEventDelayed(0.01f, "bi_setup_model");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseItem_OnGameSpawn(playerRace, playerGender); // items/base_item
		BaseDrink_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseDrink_OnGameFall();
	}

	void OnGameStartDrink() { BaseDrink_OnGameStartDrink(); } // game_start_drink
	void OnGameDrink() { BaseDrink_OnGameDrink(); } // game_drink
	void OnGameDrinkDone() { BaseDrink_OnGameDrinkDone(); } // game_drink_done
	void OnGameDeploy() { BaseDrink_OnGameDeploy(); } // game_deploy
	void OnDrinkNow() { BaseDrink_OnDrinkNow(); } // drink_now
	void OnReportDrinkAmt() { BaseDrink_OnReportDrinkAmt(); } // report_drink_amt
	void OnDrinkRemove() { BaseDrink_OnDrinkRemove(); } // drink_remove
	void OnDrinkDeploy() { BaseDrink_OnDrinkDeploy(); } // drink_deploy
	void OnDrinkEffect() {} // drink_effect
	void OnDrinkSpawn() {} // drink_spawn
	void OnDrinkStart() {} // drink_start

	// This file's events and timers by their .script names
	bool BaseDrink_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "drink_deploy") { OnDrinkDeploy(); return true; }
		if (name == "drink_now") { OnDrinkNow(); return true; }
		if (name == "drink_remove") { OnDrinkRemove(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_drink") { OnGameDrink(); return true; }
		if (name == "game_drink_done") { OnGameDrinkDone(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_start_drink") { OnGameStartDrink(); return true; }
		if (name == "report_drink_amt") { OnReportDrinkAmt(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_drink"]
shared class BaseDrinkScript : BaseItemScript, BaseDrink
{
	// Variables every script that includes this file declares
	string ANIM_DRINK = "ANIM_DRINK";
	string ANIM_IDLE = "ANIM_IDLE";
	int DRINK_AMOUNT = 0;
	float DRINK_GULP_DELAY = 0.0f;
	float DRINK_TIME = 0.0f;
	string DRINK_TYPE = "DRINK_TYPE";
	int ITEM_MODEL_VIEW_IDX = 0;
	string MODEL_HANDS = "MODEL_HANDS";
	string MODEL_VIEW = "MODEL_VIEW";
	string MODEL_WORLD = "MODEL_WORLD";

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseDrink_DispatchEvent(name, params)
			|| BaseItemScript::DispatchEvent(name, params);
	}
}
