#pragma context server

// Converted from items/base_tome.script by msc_transpiler.
// "'all your concentration' - as wiki says, 'disambiguation'." - Thothie
// Tome Base
// Handles learning spells permanently on the character.
// As a tip for naming tomes, name them "SpellName Tome" instead of "Tome of SpellName".
// This makes the spellname not get cut off if the name of the tome is too long
// Requires:
// BASE_SPELL_SCRIPT

#include "runtime/ScriptEntity.as"
#include "converted/items/base_item_extras.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseTome
{
	// Constants
	string BASE_SPELL_SCRIPT = "magic_hand_fire_dart";
	string BASE_SUMMON_TEXT = "You learn to cast a weak fireball.";
	string BASE_SUMMON_TEXT_FAILED = "Your spell casting skills are not yet sufficient to memorize this tome.";
	string BASE_REQUIRED_SKILL = "skill.spellcasting.fire";
	int BASE_REQUIRED_LEVEL = 0;
	float BASE_CAN_SUMMON = 0.0f;
	string MODEL_WORLD = "misc/p_misc.mdl";
	int MODEL_BODY = 5;

	// Variables (an unset .script variable reads as its own name)
	int READING = 0;

	// unnamed block (first think)
	void BaseTome_FirstThink()
	{
		READING = 0; // 0 - readable; 1 - reading; -1 - put away while reading
	}

	// game_spawn
	void BaseTome_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Dire Fart Tome");
		SetDescription("im gonna learn you a oooh~ brrrt!");
		SetValue(1);
		SetWeight(1);

		// Height and width are for npcs, and are not set here.
		SetHudSprite("hand", "item");
		SetHudSprite("trade", "book");
	}

	// game_deploy
	// Models
	void BaseTome_OnGameDeploy()
	{
		// Shows the model in the player's hands
		SetModel(MODEL_WORLD); // Model must be set again, since the item gets hidden

		float subModel = MODEL_BODY - 2.0f + ItemHandIndex(); // Hand models are two submodels behind the world

		SetModelBody(0, int(subModel));
	}

	// game_fall
	// Models
	void BaseTome_OnGameFall()
	{
		// World model
		SetModel(MODEL_WORLD);
		SetModelBody(0, MODEL_BODY);
		PlayAnim("oldbook_floor_idle"); // Idle animation offsets the model to the floor
	}

	// game_attack1
	// Tome Stuff
	// Attempt to learn spell on click
	void BaseTome_OnGameAttack1()
	{
		if (READING != 0)
			return;

		READING = 1;
		OwnerMessage("You study the tome carefully...");
		CallEventDelayed(3.0f, "learn_spell");
	}

	// learn_spell
	// Tome Stuff
	void BaseTome_OnLearnSpell()
	{
		if (READING == 1)
		{
			if (int(BASE_CAN_SUMMON) != 0)
				LegacyCommand("learnspell", BASE_SPELL_SCRIPT);
			else
				OnGameLearnspellFailed();
		}

		READING = 0;
	}

	// game_removefromowner
	// Tome Stuff
	void BaseTome_OnGameRemovefromowner()
	{
		if (READING != 0) // Stop attempting to read of moved inventory slots or dropped
			READING = -1;
	}

	// game_learnspell_success
	void BaseTome_OnGameLearnspellSuccess()
	{
		OwnerMessage(BASE_SUMMON_TEXT);
	}

	// game_learnspell_failed
	void BaseTome_OnGameLearnspellFailed()
	{
		OwnerMessage(BASE_SUMMON_TEXT_FAILED);
	}

	// func_base_can_wield
	// Returns 1 if the player has the skill to summon the spell, otherwise it returns 0
	string BaseTome_OnFuncBaseCanWield()
	{
		string result = "";

		int ownerSkill = Int(GetProp(ENT_OWNER, BASE_REQUIRED_SKILL));
		if (ownerSkill >= BASE_REQUIRED_LEVEL)
			result = AppendResult(result, "1");
		else
			result = AppendResult(result, "0");
		return result;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender);
	}

	// game_fall
	void OnGameFall()
	{
		BaseItemExtras_OnGameFall(); // items/base_item_extras
		BaseItemExtras_OnGameFall_2(); // items/base_item_extras
		BaseTome_OnGameFall();
	}

	// game_deploy
	void OnGameDeploy()
	{
		BaseItemExtras_OnGameDeploy(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_2(); // items/base_item_extras
		BaseItemExtras_OnGameDeploy_3(); // items/base_item_extras
		BaseTome_OnGameDeploy();
	}

	void OnGameAttack1() { BaseTome_OnGameAttack1(); } // game_attack1
	void OnLearnSpell() { BaseTome_OnLearnSpell(); } // learn_spell
	void OnGameRemovefromowner() { BaseTome_OnGameRemovefromowner(); } // game_removefromowner
	void OnGameLearnspellSuccess() { BaseTome_OnGameLearnspellSuccess(); } // game_learnspell_success
	void OnGameLearnspellFailed() { BaseTome_OnGameLearnspellFailed(); } // game_learnspell_failed
	string OnFuncBaseCanWield() { return BaseTome_OnFuncBaseCanWield(); } // func_base_can_wield

	// This file's events and timers by their .script names
	bool BaseTome_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "func_base_can_wield") { Return(OnFuncBaseCanWield()); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_deploy") { OnGameDeploy(); return true; }
		if (name == "game_fall") { OnGameFall(); return true; }
		if (name == "game_learnspell_failed") { OnGameLearnspellFailed(); return true; }
		if (name == "game_learnspell_success") { OnGameLearnspellSuccess(); return true; }
		if (name == "game_removefromowner") { OnGameRemovefromowner(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "learn_spell") { OnLearnSpell(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_tome"]
shared class BaseTomeScript : BaseItemExtrasScript, BaseTome
{
	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("misc/p_misc.mdl");
	}

	// Unnamed .script blocks: run on the first think after spawn
	void OnFirstThink() override
	{
		BaseTome_FirstThink();
		BaseItemExtras_FirstThink();
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseTome_DispatchEvent(name, params)
			|| BaseItemExtrasScript::DispatchEvent(name, params);
	}
}
