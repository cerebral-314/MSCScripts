#pragma context server

// Converted from items/health_apple.script by msc_transpiler.
// Apple

#include "runtime/ScriptEntity.as"
#include "converted/items/base_drink.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class HealthApple
{
	// Constants
	string ANIM_IDLE = "0";
	string ANIM_DRINK = "1";
	string MODEL_VIEW = "viewmodels/v_misc.mdl";
	int ITEM_MODEL_VIEW_IDX = 3;
	string MODEL_HANDS = "misc/p_misc.mdl";
	string MODEL_WORLD = "misc/p_misc.mdl";
	string SOUND_APPLE = "items/bite.wav";
	string MODEL_BODY_OFS = "1";
	string ANIM_PREFIX = "apple";
	string DRINK_WORD = "bite";
	string DONE_PHRASE = "You devour the last bite of the juicy";

	// Variables (an unset .script variable reads as its own name)
	string DRINK_TYPE = "givehealth";
	int DRINK_EFFECTAMT = 0;
	int DRINK_AMOUNT = 4;
	float DRINK_GULP_DELAY = 1.0f;
	float DRINK_TIME = 1.0f;

	// unnamed block (first think)
	void HealthApple_FirstThink()
	{
		DRINK_TYPE = "givehealth";
		DRINK_EFFECTAMT = RandomInt(1, 3);
		DRINK_AMOUNT = 4;
		DRINK_GULP_DELAY = 1.0f;
		DRINK_TIME = 1.0f;
	}

	// drink_spawn
	void HealthApple_OnDrinkSpawn()
	{
		SetName("Apple");
		SetDescription("An apple");
		SetWeight(0.3f);
		SetValue(1);
		SetHudSprite("trade", "apple");
	}

	// game_deploy
	void HealthApple_OnGameDeploy()
	{
		SetViewModel(MODEL_VIEW);
		SetModel(MODEL_HANDS);
		float submodel = Float(MODEL_BODY_OFS);
		submodel -= ItemHandIndex();
		SetModelBody(0, int(submodel));

		OnDrinkDeploy();
	}

	// game_fall
	void HealthApple_OnGameFall()
	{
		float submodel = Float(MODEL_BODY_OFS);
		submodel += 1.0f;
		SetModelBody(0, int(submodel));

		string anim = ANIM_PREFIX + "_floor_idle";
		PlayAnim(anim);
	}

	// game_start_drink
	void HealthApple_OnGameStartDrink()
	{
		CallEventDelayed(0.5f, "do_apple_sound"); // resync due to viewmodel change
	}

	// do_apple_sound
	void HealthApple_OnDoAppleSound()
	{
		PlaySound(Int(Eval("game.sound.voice")), 10, SOUND_APPLE);
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_start_drink
	void OnGameStartDrink()
	{
		BaseDrink_OnGameStartDrink(); // items/base_drink
		HealthApple_OnGameStartDrink();
	}

	void OnDrinkSpawn() { HealthApple_OnDrinkSpawn(); } // drink_spawn
	void OnGameDeploy() { HealthApple_OnGameDeploy(); } // game_deploy
	void OnGameFall() { HealthApple_OnGameFall(); } // game_fall
	void OnDoAppleSound() { HealthApple_OnDoAppleSound(); } // do_apple_sound

	// This file's events and timers by their .script names
	bool HealthApple_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "do_apple_sound") { OnDoAppleSound(); return true; }
		if (name == "drink_spawn") { OnDrinkSpawn(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_start_drink") { OnGameStartDrink(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/health_apple"]
shared class HealthAppleScript : BaseDrinkScript, HealthApple
{
	// Variables declared by included files, with the value they start with in this script
	HealthAppleScript()
	{
		ANIM_IDLE = "0";
		ANIM_DRINK = "1";
		MODEL_VIEW = "viewmodels/v_misc.mdl";
		ITEM_MODEL_VIEW_IDX = 3;
		MODEL_HANDS = "misc/p_misc.mdl";
		MODEL_WORLD = "misc/p_misc.mdl";
		MODEL_BODY_OFS = "1";
		ANIM_PREFIX = "apple";
		DRINK_TYPE = "givehealth";
		DRINK_AMOUNT = 4;
		DRINK_GULP_DELAY = 1.0f;
		DRINK_TIME = 1.0f;
		DRINK_WORD = "bite";
		DONE_PHRASE = "You devour the last bite of the juicy";
	}

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
		Precache("viewmodels/v_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		HealthApple_FirstThink();
		BaseItem_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return HealthApple_DispatchEvent(name, params)
			|| BaseDrinkScript::DispatchEvent(name, params);
	}
}
