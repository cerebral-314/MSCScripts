#pragma context server

// Converted from sfor/wizard_base.script by msc_transpiler.

#include "runtime/ScriptEntity.as"

// Included by other scripts: its handlers run as part of every script that includes it.
mixin class WizardBase
{
	// Constants
	string CONV_ANIMS = "converse2;converse1;talkleft;talkright;lean;pondering;pondering2;pondering3;";
	string SOUND_DEATH1 = "scientist/scream1.wav";
	string SOUND_DEATH2 = "scientist/scream2.wav";
	string SOUND_DEATH3 = "scientist/scream3.wav";
	string SOUND_DEATH4 = "scientist/scream4.wav";

	// Variables (an unset .script variable reads as its own name)
	bool DID_WARN = false;
	bool HAS_SYMBOL = false;

	// game_spawn
	void WizardBase_OnGameSpawn(string playerRace = "", string playerGender = "")
	{
		SetRace("human");
		SetHealth(60);
		SetModel("npc/balancepriest2.mdl"); // reskin one of the balance priests
		SetWidth(32);
		SetHeight(72);
		SetSayTextRange(1024);
		SetIdleAnim("idle1"); // pondering2 keypad
		PlayAnim("once", "idle1");
		LegacyCommand("blind", 1);
		SetMenuAutoOpen(true);
	}

	// anim_text
	void WizardBase_OnAnimText(string text = "")
	{
		float nAnims = GetTokenCount(CONV_ANIMS) - 1.0f;
		int rndAnim = RandomInt(0, int(nAnims));
		PlayAnim("critical", GetToken(CONV_ANIMS, rndAnim));
		SayText(text);
	}

	// game_struck
	void WizardBase_OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		if (!IsPlayer(ENT_LASTSTRUCK))
			return;
		if (DID_WARN)
			return;
		DID_WARN = true;
		SayText("What sort of maniac are you!? If any one of us dies Undamael will be freed!");
	}

	// game_death
	void WizardBase_OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "")
	{
		PlayRandomSound(0, 10, SOUND_DEATH1, SOUND_DEATH2, SOUND_DEATH3, SOUND_DEATH4);
		CallExternal(FindByName("wizard1"), "wizard_died");
	}

	// game_menu_getoptions
	void WizardBase_OnGameMenuGetoptions(CBasePlayer@ player = null)
	{
		MenuItem menuItem;

		if (HAS_SYMBOL)
			return;

		if (GetVar("FSHARD_STARTED") == EntityId(player))
		{
			if (Truthy(ItemExists(player, SYMB_ITEM)))
			{
				menuItem.title = "Offer " + SYMB_ITEM_NAME;
				menuItem.type = "payment";
				menuItem.data = SYMB_ITEM;
				menuItem.callback = "got_symbol";
				RegisterMenuItem(menuItem);
			}
			else
			{
				menuItem.title = "Offer " + SYMB_ITEM_NAME;
				menuItem.type = "disabled";
				RegisterMenuItem(menuItem);
			}
		}
		else
		{
			InfoMessage("all", "Felewyn Shard Quest", "Talk to Brother Unum first!");

			menuItem.title = "Offer " + SYMB_ITEM_NAME;
			menuItem.type = "disabled";
			RegisterMenuItem(menuItem);
		}
	}

	// got_symbol
	void WizardBase_OnGotSymbol()
	{
		HAS_SYMBOL = true;
		CBaseEntity@ wizId = FindByName("wizard1");
		if (Float(ScriptVarOf(wizId, "N_SYMBOLS")) < 1.0f)
			SayText("Thank you. Remember we'll need all five at the same time.");
		else
			SayText(SAYTEXT_GOT_SYMBOL);
		SetIdleAnim("kneel_idle");
		SetMoveAnim("kneel_idle");
		PlayAnim("critical", "kneel");
		CallExternal(wizId, "add_symbol");
	}

	// fade_away
	void WizardBase_OnFadeAway()
	{
		DeleteEntity(ENT_ME, "fade");
	}

	// do_oshi
	void WizardBase_OnDoOshi()
	{
		if (!IsAlive(ENT_ME))
			return;
		SetIdleAnim("crouch_idle");
		PlayAnim("once", "crouch_idle");
	}

	// ---- Engine wiring (generated) ----

	// What each event runs in a script that includes this file
	// (a script with more handlers for an event declares its own)
	void OnGameSpawn(string playerRace = "", string playerGender = "") { WizardBase_OnGameSpawn(playerRace, playerGender); } // game_spawn
	void OnAnimText(string text = "") { WizardBase_OnAnimText(text); } // anim_text
	void OnGameStruck(float damage = 0.0f, string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { WizardBase_OnGameStruck(damage, extraValue2, extraValue3, extraValue4); } // game_struck
	void OnGameDeath(string attacker = "", string extraValue2 = "", string extraValue3 = "", string extraValue4 = "") { WizardBase_OnGameDeath(attacker, extraValue2, extraValue3, extraValue4); } // game_death
	void OnGameMenuGetoptions(CBasePlayer@ player = null) { WizardBase_OnGameMenuGetoptions(player); } // game_menu_getoptions
	void OnGotSymbol() { WizardBase_OnGotSymbol(); } // got_symbol
	void OnFadeAway() { WizardBase_OnFadeAway(); } // fade_away
	void OnDoOshi() { WizardBase_OnDoOshi(); } // do_oshi

	// This file's events and timers by their .script names
	bool WizardBase_DispatchEvent(const string &in name, const array<string> &in params)
	{
		if (name == "anim_text") { OnAnimText(Param(params, 0)); return true; }
		if (name == "do_oshi") { OnDoOshi(); return true; }
		if (name == "fade_away") { OnFadeAway(); return true; }
		if (name == "game_death") { OnGameDeath(Param(params, 0), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "game_menu_getoptions") { OnGameMenuGetoptions(PlayerParam(params, 0)); return true; }
		if (name == "game_spawn") { OnGameSpawn(Param(params, 0), Param(params, 1)); return true; }
		if (name == "game_struck") { OnGameStruck(Float(Param(params, 0)), Param(params, 1), Param(params, 2), Param(params, 3)); return true; }
		if (name == "got_symbol") { OnGotSymbol(); return true; }
		return false;
	}
}

// This file as a script of its own: what spawns when it is spawned directly, and the
// base class of the scripts that include it. Shared, so it is compiled only once.
[script "sfor/wizard_base"]
shared class WizardBaseScript : ScriptEntity, WizardBase
{
	// Variables every script that includes this file declares
	string SAYTEXT_GOT_SYMBOL = "SAYTEXT_GOT_SYMBOL";
	string SYMB_ITEM = "SYMB_ITEM";
	string SYMB_ITEM_NAME = "SYMB_ITEM_NAME";
	string SYM_QUEST_NAME = "SYM_QUEST_NAME";

	// ---- Engine wiring (generated) ----

	// Load time: resources the .script parser precaches, and timers it starts
	void OnLoad() override
	{
		Precache("npc/balancepriest2.mdl");
	}

	// Events and timers by their .script names (engine, callexternal, timers):
	// this script's own, then each included file's.
	// Variables are reached by their .script names directly (the fields keep those names).
	bool DispatchEvent(const string &in name, const array<string> &in params) override
	{
		return WizardBase_DispatchEvent(name, params);
	}
}
