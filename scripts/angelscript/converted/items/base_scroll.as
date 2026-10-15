#pragma context server

// Converted from items/base_scroll.script by msc_transpiler.
// Thothie - Base for spell scrolls

#include "runtime/ScriptEntity.as"
#include "converted/items/base_tome.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class BaseScroll
{
	// Constants
	string BASE_SPELL_SCRIPT = "magic_hand_fire_dart";
	string BASE_SUMMON_TEXT = "You conjure the Fire Dart spell.";
	string BASE_SUMMON_TEXT_FAILED = "You lack the arcane skills to control this scroll's magic.";
	string BASE_REQUIRED_SKILL = "skill.spellcasting.fire";
	int BASE_REQUIRED_LEVEL = 0;
	int MODEL_BODY = 8;

	// Variables (an unset .script variable reads as its own name)
	bool JUST_GOT = true;
	float SCROLL_TIME = 0.0f;

	// game_precache
	void BaseScroll_OnGamePrecache()
	{
		PrecacheFile(SPELL_MAKER_SCRIPT);
	}

	// game_spawn
	void BaseScroll_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetName("Dire Fart Tome");
		SetDescription("*eats all your apples* oooh~ brrrt!");
		SetValue(1);
		SetWeight(1);

		SetHand("both");

		SetHudSprite("hand", "item");
		SetHudSprite("trade", "letter"); // generic letter parchment icon

		OnScrollSpawn();
		OnExtScrollTime();
	}

	// game_pickup
	void BaseScroll_OnGamePickup()
	{
		JUST_GOT = true; // stop from activating on pick-up
	}

	// game_attack1
	void BaseScroll_OnGameAttack1()
	{
		if (SCROLL_TIME > GameTime())
		{
		}
		else
		{
			// don't allow use of scroll for 2 seconds after pulling from chest
			// this is more to stop accidental casting than anything else
			// playermessage "The magic needs a moment to recharge."
			if (Float(ScriptVarOf(ENT_OWNER, "PLR_NEXT_SCROLL")) > GameTime())
			{
				// only can use one scroll every 5 seconds (or so)
				// this is to stop 'chaining' of scrolls, resulting in server crash due to multiple firewalls or volcanos
				OwnerMessage("The magic needs a moment to recharge.");
			}
			else if (Float(GetProp(ENT_OWNER, "numitems")) >= Float(GetVar("G_MAX_ITEMS")))
			{
				PlayerMessageDark(ENT_OWNER, "Cannot activate scrolls when inventory is full.");
			}
			else
			{
				OnExtScrollTime();
				if (int(BASE_CAN_SUMMON) == 0)
					OwnerMessage(BASE_SUMMON_TEXT_FAILED);
				else
					OnGrantSpell();
			}
		}
	}

	// grant_spell
	void BaseScroll_OnGrantSpell()
	{
		Vector3 spellSpawnerLoc = RelativePosition(Vector3(0, 0, SPELL_MAKER_HEIGHT));

		if (SPELL_MAKER_SCRIPT != "SPELL_MAKER_SCRIPT")
			CreateNpc(SPELL_MAKER_SCRIPT, spellSpawnerLoc, @EntityOf(ENT_OWNER), BASE_SPELL_SCRIPT, ItemNameOf(ENT_ME), SPELL_MAKER_HEIGHT, self);
	}

	// clear_hands
	void BaseScroll_OnClearHands()
	{
		OnGameWear(); // This doesn't do anything currently
		DeleteMe(); // Clear item to make way for spell (otherwise spell drops to floor)
	}

	// ext_scroll_time
	void BaseScroll_OnExtScrollTime()
	{
		SCROLL_TIME = GameTime() + 2.0f;
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)

	// game_spawn
	void OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		BaseItemExtras_OnGameSpawn(playerRace, playerGender); // items/base_item_extras
		BaseTome_OnGameSpawn(playerRace, playerGender); // items/base_tome
		BaseScroll_OnGameSpawn(playerRace, playerGender);
	}

	void OnGamePrecache() { BaseScroll_OnGamePrecache(); } // game_precache
	void OnGamePickup() { BaseScroll_OnGamePickup(); } // game_pickup
	void OnGameAttack1() { BaseScroll_OnGameAttack1(); } // game_attack1
	void OnGrantSpell() { BaseScroll_OnGrantSpell(); } // grant_spell
	void OnClearHands() { BaseScroll_OnClearHands(); } // clear_hands
	void OnExtScrollTime() { BaseScroll_OnExtScrollTime(); } // ext_scroll_time
	void OnScrollSpawn() {} // scroll_spawn

	// This file's events and timers by their .script names
	bool BaseScroll_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "clear_hands") { OnClearHands(); return true; }
		if (name == "ext_scroll_time") { OnExtScrollTime(); return true; }
		if (name == "game_attack1") { OnGameAttack1(); return true; }
		if (name == "game_pickup") { OnGamePickup(); return true; }
		if (name == "game_precache") { OnGamePrecache(); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "grant_spell") { OnGrantSpell(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "items/base_scroll"]
shared class BaseScrollScript : BaseTomeScript, BaseScroll
{
	// Variables every script that includes this file declares
	int SPELL_MAKER_HEIGHT = 0;
	string SPELL_MAKER_SCRIPT = "SPELL_MAKER_SCRIPT";

	// Variables declared by included files, with the value they start with in this script
	BaseScrollScript()
	{
		BASE_SUMMON_TEXT = "You conjure the Fire Dart spell.";
		BASE_SUMMON_TEXT_FAILED = "You lack the arcane skills to control this scroll's magic.";
		MODEL_BODY = 8;
	}

	// ---- Engine wiring (generated) ----

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return BaseScroll_DispatchEvent(name, params)
			|| BaseTomeScript::DispatchEvent(name, params);
	}
}
